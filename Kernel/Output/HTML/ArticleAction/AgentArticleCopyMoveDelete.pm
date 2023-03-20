# --
# Copyright (C) 2022 - 2023 Perl-Services.de, https://perl-services.de
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Output::HTML::ArticleAction::AgentArticleCopyMoveDelete;

use strict;
use warnings;

use Kernel::Language qw(Translatable);

our @ObjectDependencies = qw(
    Kernel::Config
    Kernel::System::Log
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub CheckAccess {
    my ( $Self, %Param ) = @_;

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
    my $GroupObject  = $Kernel::OM->Get('Kernel::System::Group');

    # Check needed stuff.
    for my $Needed (qw(Ticket Article ChannelName UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # check if module is registered
    my $Frontend = $ConfigObject->Get('Frontend::Module')->{AgentArticleCopyMove};
    return if !$Frontend;

    # check Acl
    return if !$Param{AclActionLookup}->{AgentArticleCopyMove};

    my $Access;

    my $Groups = $Frontend->{Group} || '';
    if ( $Groups && ref($Groups) eq 'ARRAY' ) {

        my %UserGroups = $GroupObject->PermissionUserGet(
            UserID => $Param{UserID},
            Type   => 'rw',
        );

        my %GroupNameIDs = reverse %UserGroups;

        for my $Group ( @{$Groups} ) {
            next if !$GroupNameIDs{$Group};

            $Access = 1;
            last;
        }
    }

    return if ( !$Access );


    $Access = $TicketObject->OwnerCheck(
        TicketID => $Param{Ticket}->{TicketID},
        OwnerID  => $Param{UserID},
    );

    return if ( !$Access );

    return 1;
}

sub GetConfig {
    my ( $Self, %Param ) = @_;

    # Check needed stuff.
    for my $Needed (qw(Ticket Article UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my $Link = sprintf "Action=AgentArticleCopyMove&TicketID=%s&ArticleID=%s",
        $Param{Ticket}->{TicketID},
        $Param{Article}->{ArticleID};

    my $Description = Translatable('Copy/Move/Delete');

    my %MenuItem = (
        ItemType    => 'Link',
        Description => $Description,
        Name        => $Description,
        Class       => 'AsPopup PopupType_TicketAction',
        Link        => $Link,
    );

    return ( \%MenuItem );
}

1;
