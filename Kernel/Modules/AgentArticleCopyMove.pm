# --
# Kernel/Modules/AgentArticleCopyMove.pm - to copy or move articles
# Copyright (C) 2006-2015 c.a.p.e. IT GmbH, http://www.cape-it.de
#
# written/edited by:
# * Stefan(dot)Mehlig(at)cape(dash)it(dot)de
# * Rene(dot)Boehm(at)cape(dash)it(dot)de
# * Martin(dot)Balzarek(at)cape(dash)it(dot)de
# * Dorothea(dot)Doerffel(at)cape(dash)it(dot)de
#
# --
# $Id: AgentArticleCopyMove.pm,v 1.4 2015/03/13 08:24:50 millinger Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentArticleCopyMove;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Ticket',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # create needed objects
    $Self->{ConfigObject} = $Kernel::OM->Get('Kernel::Config');
    $Self->{TicketObject} = $Kernel::OM->Get('Kernel::System::Ticket');
    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Output = $Self->{LayoutObject}->Header( Type => 'Small' );

    # check permissions
    my $Access = 0;
    my $Groups = $Self->{ConfigObject}->Get('Frontend::Module')->{AgentArticleCopyMove}->{Group}
        || '';
    if ( $Groups && ref($Groups) eq 'ARRAY' ) {
        for my $Group ( @{$Groups} ) {
            next if !$Self->{LayoutObject}->{"UserIsGroup[$Group]"};
            if ( $Self->{LayoutObject}->{"UserIsGroup[$Group]"} eq 'Yes' ) {
                $Access = 1;
                last;
            }
        }
    }
    else {
        $Access = 1;
    }

    if ( !$Access ) {
        $Output .= $Self->{LayoutObject}->Warning(
            Message => 'Sorry, you are not a member of allowed groups!',
            Comment => 'Please contact your admin.',
        );
        $Output .= $Self->{LayoutObject}->Footer( Type => 'Small' );
        return $Output;
    }

    # get params
    my %GetParam;
    for (qw(ArticleID TicketID ArticleAction NewTicketNumber TimeUnits TimeUnitsOriginal)) {
        $GetParam{$_} = $Self->{ParamObject}->GetParam( Param => $_ ) || '';
    }

    # check needed stuff
    for (qw(ArticleID TicketID)) {
        if ( !$GetParam{$_} ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "AgentArticleCopyMove: Need $_!",
                Comment => 'Please contact your admin.',
            );
        }
    }

    # check permissions
    $Access = $Self->{TicketObject}->OwnerCheck(
        TicketID => $GetParam{TicketID},
        OwnerID  => $Self->{UserID},
    );

    # error screen, don't show ticket
    if ( !$Access ) {
        $Output .= $Self->{LayoutObject}->Warning(
            Message => 'Sorry, you need to be owner of the selected ticket to do this action!',
            Comment => 'Please change the owner first.',
        );
        $Output .= $Self->{LayoutObject}->Footer( Type => 'Small' );
        return $Output;
    }

    # get first article
    my %FirstArticle = $Self->{TicketObject}->ArticleFirstArticle(
        TicketID => $GetParam{TicketID},
    );

    # check copy or move first article
    if ( $GetParam{ArticleID} != $FirstArticle{ArticleID} ) {
        $GetParam{FurtherActionOptions} = 1;
    }

    # get article content
    my %Article = $Self->{TicketObject}->ArticleGet(
        ArticleID => $GetParam{ArticleID},
    );

    # get accounting time
    $Param{AccountedTime} = $Self->{TicketObject}->ArticleAccountedTimeGet(
        ArticleID => $GetParam{ArticleID},
    );
    if ( $Self->{ConfigObject}->Get('Ticket::Frontend::NeedAccountedTime') ) {
        $Param{NeedAccountedTime} = 'Validate_Required';
    }

    if ( $Param{AccountedTime} ) {
        $Self->{LayoutObject}->Block(
            Name => 'TimeUnitsJs',
            Data => {
                %Param,
                TimeUnitsOriginal => $GetParam{TimeUnitsOriginal} || 'Difference',
            },
        );
        $Self->{LayoutObject}->Block(
            Name => 'TimeUnits',
            Data => \%Param,
        );
    }

    if ( $Self->{Subaction} eq 'Update' ) {
        my $NewTicketID = $GetParam{TicketID};

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        # delete article
        if ( $GetParam{ArticleAction} eq 'Delete' ) {
            my $DeleteResult = $Self->{TicketObject}->ArticleFullDelete(
                ArticleID => $GetParam{ArticleID},
                UserID    => $Self->{UserID},
            );
            if ( !$DeleteResult ) {
                return $Self->{LayoutObject}->ErrorScreen(
                    Message =>
                        "Can't delete article $GetParam{ArticleID} from ticket $Article{TicketNumber}!",
                    Comment => 'Please contact your admin.',
                );
            }

            # add history to original ticket
            $Self->{TicketObject}->HistoryAdd(
                Name => "Deleted article $GetParam{ArticleID} from ticket $Article{TicketNumber}",
                HistoryType  => 'Misc',
                TicketID     => $GetParam{TicketID},
                CreateUserID => $Self->{UserID},
            );
        }

        # preparations for move and copy
        else {

            # check needed stuff
            if ( !$GetParam{NewTicketNumber} ) {
                $Output .= $Self->{LayoutObject}->Notify(
                    Info => 'Perhaps, you forgot to enter a ticket number!',
                );
                $Output .= $Self->Form(
                    %Article,
                    %GetParam,
                    NewTicketNumberInvalid => 'ServerError',
                );
                return $Output;
            }

            # get new ticket id
            $NewTicketID = $Self->{TicketObject}->TicketCheckNumber(
                Tn => $GetParam{NewTicketNumber},
            );
            if ( !$NewTicketID ) {
                $Output .= $Self->{LayoutObject}->Notify(
                    Info =>
                        $Self->{LayoutObject}->{LanguageObject}
                        ->Get('Sorry, no ticket found for ticket number: ')
                        . $GetParam{NewTicketNumber}
                        . '!',
                );
                $Output .= $Self->Form(
                    %Article,
                    %GetParam,
                    NewTicketNumberInvalid => 'ServerError',
                );
                return $Output;
            }

            # check owner of new ticket
            my $NewAccessOk = $Self->{TicketObject}->OwnerCheck(
                TicketID => $NewTicketID,
                OwnerID  => $Self->{UserID},
            );
            if ( !$NewAccessOk ) {
                $Output .= $Self->{LayoutObject}->Notify(
                    Info => 'Sorry, you need to be owner of the new ticket to do this action!',
                );
                $Output .= $Self->Form(
                    %Article,
                    %GetParam,
                );
                $Output .= $Self->{LayoutObject}->Footer( Type => 'Small' );
                return $Output;
            }
        }

        # copy article
        if ( $GetParam{ArticleAction} eq 'Copy' ) {
            my $CopyResult = $Self->{TicketObject}->ArticleCopy(
                TicketID  => $NewTicketID,
                ArticleID => $GetParam{ArticleID},
                UserID    => $Self->{UserID},
            );
            if ( $CopyResult eq 'CopyFailed' ) {
                return $Self->{LayoutObject}->ErrorScreen(
                    Message =>
                        "Can't copy article $GetParam{ArticleID} to ticket $GetParam{NewTicketNumber}!",
                    Comment => 'Please contact your admin.',
                );
            }
            elsif ( $CopyResult eq 'UpdateFailed' ) {
                return $Self->{LayoutObject}->ErrorScreen(
                    Message => "Can't update times for article $GetParam{ArticleID}!",
                    Comment => 'Please contact your admin.',
                );
            }

            # add accounted time to new article
            if ( $GetParam{TimeUnits} ) {
                $Self->{TicketObject}->TicketAccountTime(
                    TicketID  => $NewTicketID,
                    ArticleID => $CopyResult,
                    TimeUnit  => $GetParam{TimeUnits},
                    UserID    => $Self->{UserID},
                );
            }

            # delete accounted time from old article
            if ( $GetParam{TimeUnitsOriginal} ne 'Keep' ) {
                $Self->{TicketObject}->ArticleAccountedTimeDelete(
                    ArticleID => $GetParam{ArticleID},
                );
            }

            # save residual if chosen to old article
            if ( $GetParam{TimeUnitsOriginal} eq 'Difference' ) {
                $Self->{TicketObject}->TicketAccountTime(
                    TicketID  => $GetParam{TicketID},
                    ArticleID => $GetParam{ArticleID},
                    TimeUnit  => ( $Param{AccountedTime} - $GetParam{TimeUnits} ),
                    UserID    => $Self->{UserID},
                );
            }

            # add history to original ticket
            $Self->{TicketObject}->HistoryAdd(
                Name => "Copied article $GetParam{ArticleID} from "
                    . "ticket $Article{TicketNumber} to ticket $GetParam{NewTicketNumber} "
                    . "as article $CopyResult",
                HistoryType  => 'Misc',
                TicketID     => $GetParam{TicketID},
                ArticleID    => $GetParam{ArticleID},
                CreateUserID => $Self->{UserID},
            );
        }

        # move article
        elsif ( $GetParam{ArticleAction} eq 'Move' ) {
            my $MoveResult = $Self->{TicketObject}->ArticleMove(
                TicketID  => $NewTicketID,
                ArticleID => $GetParam{ArticleID},
                UserID    => $Self->{UserID},
            );
            if ( $MoveResult eq 'MoveFailed' ) {
                return $Self->{LayoutObject}->ErrorScreen(
                    Message =>
                        "Can't move article $GetParam{ArticleID} to ticket $GetParam{NewTicketNumber}!",
                    Comment => 'Please contact your admin.',
                );
            }
            if ( $MoveResult eq 'AccountFailed' ) {
                return $Self->{LayoutObject}->ErrorScreen(
                    Message =>
                        "Can't update ticket id in time accounting data for article $GetParam{ArticleID}!",
                    Comment => 'Please contact your admin.',
                );
            }

            # add history to new ticket
            $Self->{TicketObject}->HistoryAdd(
                Name => "Moved article $GetParam{ArticleID} from ticket"
                    . " $Article{TicketNumber} to ticket $GetParam{NewTicketNumber} ",
                HistoryType  => 'Misc',
                TicketID     => $NewTicketID,
                ArticleID    => $GetParam{ArticleID},
                CreateUserID => $Self->{UserID},
            );

            # add history to old ticket
            $Self->{TicketObject}->HistoryAdd(
                Name => "Moved article $GetParam{ArticleID} from ticket"
                    . " $Article{TicketNumber} to ticket $GetParam{NewTicketNumber} ",
                HistoryType  => 'Misc',
                TicketID     => $GetParam{TicketID},
                ArticleID    => $GetParam{ArticleID},
                CreateUserID => $Self->{UserID},
            );
        }

        # redirect
        return $Self->{LayoutObject}->PopupClose(
            URL => "Action=AgentTicketZoom&TicketID=$NewTicketID"
        );
    }

    # show form
    $GetParam{CopyTypeChecked} = 'checked="checked"';
    $Output .= $Self->Form(
        %Article,
        %GetParam,
    );
    return $Output;
}

sub Form {
    my ( $Self, %Param ) = @_;

    $Self->{LayoutObject}->Block(
        Name => 'ArticleActionOptions',
        Data => \%Param,
    );

    if ( $Param{FurtherActionOptions} ) {
        $Self->{LayoutObject}->Block(
            Name => 'FurtherActionOptions',
            Data => \%Param,
        );
    }

    # start output
    my $Output = $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentArticleCopyMove',
        Data         => {
            %Param,
            ArticleAction => $Param{ArticleAction} || 'Copy',
        },
    );
    $Output .= $Self->{LayoutObject}->Footer( Type => 'Small' );
    return $Output;
}

1;
