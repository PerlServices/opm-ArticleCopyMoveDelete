# --
# Kernel/Language/de_ArticleCopyMoveDelete.pm - provides de translation for ArticleCopyMoveDelete
# Copyright (C) 2006-2015 c.a.p.e. IT GmbH, http://www.cape-it.de
#
# written/edited by:
# * Martin(dot)Balzarek(at)cape(dash)it(dot)de
# * Frank(dot)Oberender(at)cape(dash)it(dot)de
# * Torsten(dot)Thau(at)cape(dash)it(dot)de
# * Stefan(dot)Mehlig(at)cape(dash)it(dot)de
# * Rene(dot)Boehm(at)cape(dash)it(dot)de
# * Anna(dot)Litvinova(at)cape(dash)it(dot)de
# * Mario(dot)Illinger(at)cape(dash)it(dot)de
#
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::de_ArticleCopyMoveDelete;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;
    my $Lang = $Self->{Translation};
    return 0 if ref $Lang ne 'HASH';

    # possible charsets
    $Self->{Charset} = ['utf-8', ];

    # $$START$$

    # AgentArticleCopyMove
    $Lang->{'Copy/Move/Delete'}             = 'Kopieren/Verschieben/Löschen';
    $Lang->{'of destination ticket'}        = 'des Zieltickets';
    $Lang->{'Copy, Move or Delete Article'} = 'Kopieren, Verschieben oder Löschen eines Artikels';
    $Lang->{'Copy, move or delete selected article'} =
        'Kopieren, Verschieben oder Löschen des ausgewählten Artikels';
    $Lang->{'Action to be performed'} = 'Auszuführende Aktion';
    $Lang->{'Copy'}                   = 'Kopieren';
    $Lang->{'You cannot asign more time units as in the source article!'} =
        'Sie können nicht mehr Zeiteinheiten zuweisen, als im Original-Artikel!';
    $Lang->{'Copy Options'}            = 'Kopieroptionen';
    $Lang->{'Delete Options'}          = 'Löschoptionen';
    $Lang->{'Move Options'}            = 'Verschiebeoptionen';
    $Lang->{'Really delete this article?'} = 'Diesen Artikel wirklich löschen?';
    $Lang->{'Time units to transfer'}      = 'Zu transferierende Zeiteinheiten';
    $Lang->{'Handling of accounted time from source article?'} =
        'Umgang mit Zeitbuchung am Original-Artikel?';
    $Lang->{'Change to residue'}   = 'Auf Rest verringern';
    $Lang->{'Leave unchanged'}     = 'Unverändert lassen';
    $Lang->{'Owner / Responsible'} = 'Besitzer / Verantwortlicher';
    $Lang->{'Change the ticket owner and responsible!'} =
        'Ändern des Ticket-Besitzers und -Verantwortlichen!';
    $Lang->{'Perhaps, you forgot to enter a ticket number!'} =
        'Bitte geben Sie eine Ticket-Nummer ein';
    $Lang->{'Sorry, no ticket found for ticket number: '} =
        'Es konnte kein Ticket gefunden werden für Ticket-Nummer: ';
    $Lang->{'Sorry, you need to be owner of the new ticket to do this action!'} =
        'Sie müssen der Besitzer des neuen Tickets sein, um diese Aktion auszuführen!';
    $Lang->{'Sorry, you need to be owner of the selected ticket to do this action!'} =
        'Sie müssen der Besitzer des ausgewählten Tickets sein, um diese Aktion auszuführen!';
    $Lang->{'Please contact your admin.'}     = 'Bitte kontaktieren Sie Ihren Administrator.';
    $Lang->{'Please change the owner first.'} = 'Bitte ändern Sie zunächst den Besitzer.';
    $Lang->{'Sorry, you are not a member of allowed groups!'} =
        'Bitte entschuldigen Sie, aber Sie nicht Mitglied der berechtigten Gruppen!';

    $Lang->{'Options for Copy'} = 'Kopieroptionen';
    $Lang->{'Options for Move'} = 'Verschiebeoptionen';
    $Lang->{'Options for Delete'} = 'Löschoptionen';

    $Lang->{'Copied time units of the source article'} = 'Zu kopierende Zeiteinheiten des Quellarticels';
    # EO AgentArticleCopyMove

    # $$STOP$$

    return 0;
}

1;
