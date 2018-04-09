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
    delete $Self->{ 'Cache::GetTicket' . $Param{OldTicketID} };

    for my $Key ( qw/TicketID OldTicketID/ ) {
        $Kernel::OM->Get('Kernel::System::Cache')->Delete(
            Type => 'Article',
            Key  => '_MetaArticleList::' . $Param{$Key},
        );
    }

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
    for my $Needed (qw(ArticleID NewTicketID TicketID UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log( Priority => 'error', Message => "ArticleCopy: Need $Needed!" );
            return;
        }
    }

    my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');
    my $BackendObject = $ArticleObject->BackendForArticle(
        ArticleID => $Param{ArticleID},
        TicketID  => $Param{TicketID},
    );
    my ($Article) = $ArticleObject->ArticleList(
        TicketID => $Param{TicketID},
        ArticleID => $Param{ArticleID},
    );

    # get original article content
    my %Article = $BackendObject->ArticleGet(
        ArticleID => $Param{ArticleID},
        TicketID  => $Param{TicketID},
    );

    return 'NoOriginal' if !%Article;

    # copy original article
    my $CopyArticleID = $BackendObject->ArticleCreate(
        %Article,
        TicketID       => $Param{NewTicketID},
        UserID         => $Param{UserID},
        HistoryType    => 'Misc',
        HistoryComment => "Copied article $Param{ArticleID} from "
            . "ticket $Article{TicketID} to ticket $Param{TicketID}",
    );

    return 'CopyFailed' if !$CopyArticleID;

    # set article times from original article
    return 'UpdateFailed' if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL =>
            'UPDATE article_data_mime SET incoming_time = ? WHERE article_id = ?',
        Bind => [
            \$Article{IncomingTime}, \$CopyArticleID
        ],
    );

    # copy attachments from original article
    my %ArticleIndex = $BackendObject->ArticleAttachmentIndex(
        ArticleID => $Param{ArticleID},
        UserID    => $Param{UserID},
    );

    for my $Index ( keys %ArticleIndex ) {
        my %Attachment = $BackendObject->ArticleAttachment(
            ArticleID => $Param{ArticleID},
            FileID    => $Index,
            UserID    => $Param{UserID},
        );
        $BackendObject->ArticleWriteAttachment(
            %Attachment,
            ArticleID => $CopyArticleID,
            UserID    => $Param{UserID},
        );
    }

    # clear ticket cache
    delete $Self->{ 'Cache::GetTicket' . $Param{TicketID} };

    # copy plain article if exists
    if ( $BackendObject->ChannelNameGet() eq 'Email' ) {
        my $Data = $BackendObject->ArticlePlain(
            ArticleID => $Param{ArticleID},
            TicketID  => $Param{TicketID},
        );
        if ($Data) {
            $BackendObject->ArticleWritePlain(
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
            TicketID     => $Param{NewTicketID},
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
    for my $Needed (qw(TicketID ArticleID UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')
                ->Log( Priority => 'error', Message => "ArticleFullDelete: Need $Needed!" );
            return;
        }
    }

    my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');
    my $BackendObject = $ArticleObject->BackendForArticle(
        ArticleID => $Param{ArticleID},
        TicketID  => $Param{TicketID},
    );

    # get article content
    
    my %Article = $BackendObject->ArticleGet(
        ArticleID => $Param{ArticleID},
        TicketID  => $Param{TicketID},
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
    return if !$BackendObject->ArticleDelete(
        ArticleID => $Param{ArticleID},
        TicketID  => $Param{TicketID},
        UserID    => $Param{UserID},
    );

    # event
    $Self->EventHandler(
        Event => 'ArticleFullDelete',
        Data  => {
            TicketID  => $Param{TicketID},
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
        SQL => "UPDATE article SET incoming_time = ?, "
            . "change_time = current_timestamp, change_by = ? WHERE id = ?",
        Bind => [ \$Param{IncomingTime}, \$Param{UserID}, \$Param{ArticleID} ],
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
