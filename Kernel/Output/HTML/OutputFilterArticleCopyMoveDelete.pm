# --
# Kernel/Output/HTML/OutputFilterArticleCopyMoveDelete.pm - Output filter to provide a link
# to switch from customers to agents frontend and vice versa
# Copyright (C) 2006-2015 c.a.p.e. IT GmbH, http://www.cape-it.de
#
# written/edited by:
# * Torsten(dot)Thau(at)cape(dash)it(dot)de
# * Anna(dot)Litvinova(at)cape(dash)it(dot)de
# * Dorothea(dot)Doerffel(at)cape(dash)it(dot)de
# * Mario(dot)Illinger(at)cape(dash)it(dot)de
#
# --
# $Id: OutputFilterArticleCopyMoveDelete.pm,v 1.7 2015/03/13 08:24:50 millinger Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::OutputFilterArticleCopyMoveDelete;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Language',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::Ticket'
);

use Kernel::System::Group;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{ConfigObject}   = $Kernel::OM->Get('Kernel::Config');
    $Self->{LanguageObject} = $Kernel::OM->Get('Kernel::Language');
    $Self->{LayoutObject}   = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    $Self->{TicketObject}   = $Kernel::OM->Get('Kernel::System::Ticket');

    if ( !$Param{UserType} || ( $Param{UserType} ne 'User' && $Param{UserType} ne 'Customer' ) ) {
        return $Self;
    }

    # get user infos
    $Self->{UserID}    = $Param{UserID}    || '';
    $Self->{UserLogin} = $Param{UserLogin} || '';
    $Self->{UserType}  = $Param{UserType}  || '';
    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    if ( !$Self->{UserType} || ( $Self->{UserType} ne 'User' ) ) {
        return $Self;
    }

    # check data
    return if !$Param{Data};
    return if ref $Param{Data} ne 'SCALAR';
    return if !${ $Param{Data} };

    # get configuration for ArticleCopyMoveDelete button...
    my $ArticleCopyMoveDeleteReg = "";
    if ( $Self->{UserType} && $Self->{UserType} eq 'User' ) {
        $ArticleCopyMoveDeleteReg
            = $Self->{ConfigObject}->Get('Frontend::Module')->{AgentArticleCopyMove} || '';
    }

    my $SessionIDParamName = $Self->{ConfigObject}->Get('SessionName') || 'Session';

    return if !$ArticleCopyMoveDeleteReg;

    my $ArticleActionLink =
        '<li><a href="index.pl?Action=AgentArticleCopyMove;TicketID='
        . 'OTRS_TICKET_ID'
        . ';ArticleID='
        . 'OTRS_ARTICLE_ID;'
        . $SessionIDParamName
        . '=OTRS_SESSION" class="AsPopup PopupType_TicketAction" '
        . ' title="'
        . $Self->{LanguageObject}->Translate( $ArticleCopyMoveDeleteReg->{Description} )
        . '">'
        . $Self->{LanguageObject}->Translate('Copy/Move/Delete')
        . '</a></li>';

    my $AgentPatternShort = '<li>.+Action=AgentTicketPrint;TicketID=(\d+);'
        . 'ArticleID=(\d+).*?<\/li>';
    my $AgentPatternLong = '<li>.+Action=AgentTicketPrint;TicketID=(\d+);'
        . 'ArticleID=(\d+);'.$SessionIDParamName.'=(\w+).*?<\/li>';

    if (
        (
            ${ $Param{Data} } =~ m{ $AgentPatternLong }ixms
            || ${ $Param{Data} } =~ m{ $AgentPatternShort }ixms
        )
        && ${ $Param{Data} } !~ /Action=AgentArticleCopyMove;/
        )
    {
        my $Access    = 0;
        my $TicketID  = $1;
        my $ArticleID = $2;
        my $SessionID = $3 || '';

        # check group permissions...
        my $Groups = $ArticleCopyMoveDeleteReg->{Group} || '';
        if ( $Groups && ref($Groups) eq 'ARRAY' ) {
            for my $Group ( @{$Groups} ) {
                next if !$Self->{LayoutObject}->{"UserIsGroup[$Group]"};
                if ( $Self->{LayoutObject}->{"UserIsGroup[$Group]"} eq 'Yes' ) {
                    $Access = 1;
                    last;
                }
            }
        }
        return if ( !$Access );

        # check owner...
        $Access = $Self->{TicketObject}->OwnerCheck(
            TicketID => $TicketID,
            OwnerID  => $Self->{UserID},
        );
        return if ( !$Access );

        $ArticleActionLink =~ s/OTRS_TICKET_ID/$TicketID/g;
        $ArticleActionLink =~ s/OTRS_ARTICLE_ID/$ArticleID/g;

        if ($SessionID) {
            $ArticleActionLink =~ s/OTRS_SESSION/$SessionID/g;
            ${ $Param{Data} }  =~ s{ ($AgentPatternLong) }{$1$ArticleActionLink}ixms;
        }
        else {
            $ArticleActionLink =~ s/$SessionIDParamName=OTRS_SESSION//g;
            ${ $Param{Data} }  =~ s{ ($AgentPatternShort) }{$1$ArticleActionLink}ixms;
        }
    }

    return 1;
}

1;
