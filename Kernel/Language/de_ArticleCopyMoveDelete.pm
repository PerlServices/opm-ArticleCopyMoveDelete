# --
# Kernel/Language/de_ArticleCopyMoveDelete.pm - the German translation for ArticleCopyMoveDelete
# Copyright (C) 2006-2016 c.a.p.e. IT GmbH, http://www.cape-it.de
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

    # Kernel/Config/Files/AgentArticleCopyMove.xml
    $Lang->{'Activates the \'ArticleCopyMoveDelete\' link.'} = '';
    $Lang->{'Frontend module registration for AgentArticleCopyMoveDelete.'} = '';
    $Lang->{'Copy, move or delete selected article.'} = 'Kopieren, Verschieben oder Löschen des ausgewählten Artikels.';
    $Lang->{'Copy, Move or Delete Article'} = 'Kopieren, Verschieben oder Löschen eines Artikels';
    $Lang->{'Overloads (redefines) existing functions in Kernel::System::Ticket. Used to easily add customizations.'} = '';

    # Kernel/Modules/AgentArticleCopyMove.pm
    $Lang->{'Sorry, you are not a member of allowed groups!'} =
        'Bitte entschuldigen Sie, aber Sie nicht Mitglied der berechtigten Gruppen!';
    $Lang->{'Please contact the administrator.'} = 'Bitte kontaktieren Sie Ihren Administrator.';
    $Lang->{'AgentArticleCopyMoveDelete: Need %s!'} = '';
    $Lang->{'Sorry, you need to be owner of the selected ticket to do this action!'} =
        'Sie müssen der Besitzer des ausgewählten Tickets sein, um diese Aktion auszuführen!';
    $Lang->{'Please change the owner first.'} = 'Bitte ändern Sie zunächst den Besitzer.';
    $Lang->{'Can\'t delete article %s from ticket %s!'} = '';
    $Lang->{'Perhaps, you forgot to enter a ticket number!'} = 'Bitte geben Sie eine Ticket-Nummer ein!';
    $Lang->{'Sorry, no ticket found for ticket number: %s!'} =
        'Es konnte kein Ticket gefunden werden für Ticket-Nummer: %s!';
    $Lang->{'Sorry, you need to be owner of the new ticket to do this action!'} =
        'Sie müssen der Besitzer des neuen Tickets sein, um diese Aktion auszuführen!';
    $Lang->{'Can\'t copy article %s to ticket %s!'} = '';
    $Lang->{'Can\'t update times for article %s!'} = '';
    $Lang->{'Can\'t move article %s to ticket %s!'} = '';
    $Lang->{'Can\'t update ticket ID in time accounting data for article %s!'} = '';

    # Kernel/Output/HTML/Templates/Standard/AgentArticleCopyMove.tt
    $Lang->{'Copy/Move/Delete'} = 'Kopieren/Verschieben/Löschen';
    $Lang->{'Cancel & close window'} = '';
    $Lang->{'Article subject'} = '';
    $Lang->{'Action to be performed'} = 'Auszuführende Aktion';
    $Lang->{'Copy'} = 'Kopieren';
    $Lang->{'Move'} = '';
    $Lang->{'Delete'} = '';
    $Lang->{'Options for Delete'} = 'Löschoptionen';
    $Lang->{'Really delete this article?'} = 'Diesen Artikel wirklich löschen?';
    $Lang->{'This field is required.'} = '';
    $Lang->{'Options for Copy'} = 'Kopieroptionen';
    $Lang->{'%s of destination ticket'} = '%s des Zieltickets';
    $Lang->{'Invalid ticket identifier!'} = '';
    $Lang->{'Copied time units of the source article'} = 'Zu kopierende Zeiteinheiten des Quellarticels';
    $Lang->{'Invalid time!'} = '';
    $Lang->{'You cannot assign more time units as in the source article!'} =
        'Sie können nicht mehr Zeiteinheiten zuweisen, als im Original-Artikel!';
    $Lang->{'Handling of accounted time from source article?'} = 'Umgang mit Zeitbuchung am Original-Artikel?';
    $Lang->{'Leave unchanged'} = 'Unverändert lassen';
    $Lang->{'Change to residue'} = 'Auf Rest verringern';
    $Lang->{'Submit'} = '';
    $Lang->{'Options for Move'} = 'Verschiebeoptionen';
}

1;
