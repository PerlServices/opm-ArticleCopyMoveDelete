# --
# Kernel/System/Ticket/TicketExtensionsArticleCopyMove.pm - ArticleCopyMoveDelete ticket changes
# Copyright (C) 2006-2015 c.a.p.e. IT GmbH, http://www.cape-it.de
#
# written/edited by:
# * Torsten(dot)Thau(at)cape(dash)it(dot)de
# * Rene(dot)Boehm(at)cape(dash)it(dot)de
# * Martin(dot)Balzarek(at)cape(dash)it(dot)de
# * Stefan(dot)Mehlig(at)cape(dash)it(dot)de
# * Anna(dot)Litvinova(at)cape(dash)it(dot)de
# * Frank(dot)Oberender(at)cape(dash)it(dot)de
# * Dorothea(dot)Doerffel(at)cape(dash)it(dot)de
# * Ralf(dot)Boehm(at)cape(dash)it(dot)de
# * Mario(dot)Illinger(at)cape(dash)it(dot)de
# --
# $Id: TicketExtensionsArticleCopyMove.pm,v 1.4 2015/03/13 08:24:50 millinger Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Ticket::TicketExtensionsArticleCopyMove;

use strict;
use warnings;

=item ArticleMove()

Moves an article to another ticket

    my $Result = $TicketObject->ArticleMove(
        TicketID  => 123,
        ArticleID => 123,
        UserID    => 123,
    );

Result:
    1
    MoveFailed
    AccountFailed

Events:
    ArticleMove

=cut

sub ArticleMove {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(ArticleID TicketID UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log( Priority => 'error', Message => "ArticleMove: Need $Needed!" );
            return;
        }
    }

    # update article data
    return 'MoveFailed' if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL => "UPDATE article SET ticket_id = ?, "
            . "change_time = current_timestamp, change_by = ? WHERE id = ?",
        Bind => [ \$Param{TicketID}, \$Param{UserID}, \$Param{ArticleID} ],
    );

    # update time accounting data
    return 'AccountFailed' if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL => 'UPDATE time_accounting SET ticket_id = ?, '
            . "change_time = current_timestamp, change_by = ? WHERE article_id = ?",
        Bind => [ \$Param{TicketID}, \$Param{UserID}, \$Param{ArticleID} ],
    );

    # clear ticket cache
    delete $Self->{ 'Cache::GetTicket' . $Param{TicketID} };

    # event
    $Self->EventHandler(
        Event => 'ArticleMove',
        Data  => {
            TicketID  => $Param{TicketID},
            ArticleID => $Param{ArticleID},
        },
        UserID => $Param{UserID},
    );

    return 1;
}

=item ArticleCopy()

Copies an article to another ticket including all attachments

    my $Result = $TicketObject->ArticleCopy(
        TicketID  => 123,
        ArticleID => 123,
        UserID    => 123,
    );

Result:
    NewArticleID
    'NoOriginal'
    'CopyFailed'
    'UpdateFailed'

Events:
    ArticleCopy

=cut

sub ArticleCopy {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(ArticleID TicketID UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log( Priority => 'error', Message => "ArticleCopy: Need $Needed!" );
            return;
        }
    }

    # get original article content
    my %Article = $Self->ArticleGet(
        ArticleID => $Param{ArticleID},
    );
    return 'NoOriginal' if !%Article;

    # copy original article
    my $CopyArticleID = $Self->ArticleCreate(
        %Article,
        TicketID       => $Param{TicketID},
        UserID         => $Param{UserID},
        HistoryType    => 'Misc',
        HistoryComment => "Copied article $Param{ArticleID} from "
            . "ticket $Article{TicketID} to ticket $Param{TicketID}",
    );
    return 'CopyFailed' if !$CopyArticleID;

    # set article times from original article
    return 'UpdateFailed' if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL =>
            'UPDATE article SET create_time = ?, change_time = ?, incoming_time = ? WHERE id = ?',
        Bind => [
            \$Article{Created},      \$Article{Changed},
            \$Article{IncomingTime}, \$CopyArticleID
        ],
    );

    # copy attachments from original article
    my %ArticleIndex = $Self->ArticleAttachmentIndex(
        ArticleID => $Param{ArticleID},
        UserID    => $Param{UserID},
    );
    for my $Index ( keys %ArticleIndex ) {
        my %Attachment = $Self->ArticleAttachment(
            ArticleID => $Param{ArticleID},
            FileID    => $Index,
            UserID    => $Param{UserID},
        );
        $Self->ArticleWriteAttachment(
            %Attachment,
            ArticleID => $CopyArticleID,
            UserID    => $Param{UserID},
        );
    }

    # clear ticket cache
    delete $Self->{ 'Cache::GetTicket' . $Param{TicketID} };

    # copy plain article if exists
    if ( $Article{ArticleType} =~ /email/i ) {
        my $Data = $Self->ArticlePlain(
            ArticleID => $Param{ArticleID}
        );
        if ($Data) {
            $Self->ArticleWritePlain(
                ArticleID => $CopyArticleID,
                Email     => $Data,
                UserID    => $Param{UserID},
            );
        }
    }

    # event
    $Self->EventHandler(
        Event => 'ArticleCopy',
        Data  => {
            TicketID     => $Param{TicketID},
            ArticleID    => $CopyArticleID,
            OldArticleID => $Param{ArticleID},
        },
        UserID => $Param{UserID},
    );

    return $CopyArticleID;
}

=item ArticleFullDelete()

Delete an article, its history, its plain message, and all attachments

    my $Success = $TicketObject->ArticleFullDelete(
        ArticleID => 123,
        UserID    => 123,
    );

ATTENTION:
    sub ArticleDelete is used in this sub, but this sub does not delete
    article history

Events:
    ArticleFullDelete

=cut

sub ArticleFullDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(ArticleID UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')
                ->Log( Priority => 'error', Message => "ArticleFullDelete: Need $Needed!" );
            return;
        }
    }

    # get article content
    my %Article = $Self->ArticleGet(
        ArticleID => $Param{ArticleID},
    );
    return if !%Article;

    # clear ticket cache
    delete $Self->{ 'Cache::GetTicket' . $Article{TicketID} };

    # delete article history
    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL  => 'DELETE FROM ticket_history WHERE article_id = ?',
        Bind => [ \$Param{ArticleID} ],
    );

    # delete article, attachments and plain emails
    return if !$Self->ArticleDelete(
        ArticleID => $Param{ArticleID},
        UserID    => $Param{UserID},
    );

    # event
    $Self->EventHandler(
        Event => 'ArticleFullDelete',
        Data  => {
            TicketID  => $Article{TicketID},
            ArticleID => $Param{ArticleID},
        },
        UserID => $Param{UserID},
    );

    return 1;
}

=item ArticleCreateDateUpdate()

Manipulates the article create date

    my $Result = $TicketObject->ArticleCreateDateUpdate(
        ArticleID => 123,
        UserID    => 123,
    );

Events:
    ArticleUpdate

=cut

sub ArticleCreateDateUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(TicketID ArticleID UserID Created IncomingTime)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')
                ->Log( Priority => 'error', Message => "ArticleCreateDateUpdate: Need $Needed!" );
            return;
        }
    }

    # db update
    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL => "UPDATE article SET incoming_time = ?, create_time = ?,"
            . "change_time = current_timestamp, change_by = ? WHERE id = ?",
        Bind => [ \$Param{IncomingTime}, \$Param{Created}, \$Param{UserID}, \$Param{ArticleID} ],
    );

    # event
    $Self->EventHandler(
        Event => 'ArticleUpdate',
        Data  => {
            TicketID  => $Param{TicketID},
            ArticleID => $Param{ArticleID},
        },
        UserID => $Param{UserID},
    );
    return 1;
}

1;
