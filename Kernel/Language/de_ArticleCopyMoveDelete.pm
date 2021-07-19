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
    $Lang->{'Activates the \'ArticleCopyMoveDelete\' link.'} = 'Aktiviert den \'ArticleCopyMoveDelete\' Link.';
    $Lang->{'Frontend module registration for AgentArticleCopyMoveDelete.'} = 
		'Frontend Modul Registrierung für AgentArticleCopyMoveDelete.';
    $Lang->{'Copy, move or delete selected article.'} = 'Kopieren, Verschieben oder Löschen des ausgewählten Artikels.';
    $Lang->{'Copy, Move or Delete Article'} = 'Kopieren, Verschieben oder Löschen eines Artikels';
    $Lang->{'Overloads (redefines) existing functions in Kernel::System::Ticket. Used to easily add customizations.'} =
         'Definiert bestehende Funktionen in Kernel::System::Ticket neu. Wird genutzt um Anpassungen leicht hinzuzufügen';

    # Kernel/Modules/AgentArticleCopyMove.pm
    $Lang->{'Sorry, you are not a member of allowed groups!'} =
        'Bitte entschuldigen Sie, aber Sie sind nicht Mitglied der berechtigten Gruppen!';
    $Lang->{'Please contact the administrator.'} = 'Bitte kontaktieren Sie Ihren Administrator.';
    $Lang->{'AgentArticleCopyMoveDelete: Need %s!'} = 'AgentArticleCopyMoveDelete: Benötige %s!';
    $Lang->{'Sorry, you need to be owner of the selected ticket to do this action!'} =
        'Sie müssen der Besitzer des ausgewählten Tickets sein, um diese Aktion auszuführen!';
    $Lang->{'Please change the owner first.'} = 'Bitte ändern Sie zunächst den Besitzer.';
    $Lang->{'Can\'t delete article %s from ticket %s!'} = 'Kann Artikel %s von Ticket %s nicht löschen!';
    $Lang->{'Perhaps, you forgot to enter a ticket number!'} = 'Bitte geben Sie eine Ticket-Nummer ein!';
    $Lang->{'Sorry, no ticket found for ticket number: %s!'} =
        'Es konnte kein Ticket gefunden werden für Ticket-Nummer: %s!';
    $Lang->{'Sorry, you need to be owner of the new ticket to do this action!'} =
        'Sie müssen der Besitzer des neuen Tickets sein, um diese Aktion auszuführen!';
    $Lang->{'Can\'t copy article %s to ticket %s!'} = 'Kann den Artikel %s nicht zum Ticket %s  kopieren!';
    $Lang->{'Can\'t update times for article %s!'} = 'Kann die Zeiten für Artikel %s nicht aktualisieren!';
    $Lang->{'Can\'t move article %s to ticket %s!'} = 'Kann den Artikel %s nicht zu Ticket %s verschieben!';
    $Lang->{'Can\'t update ticket ID in time accounting data for article %s!'} = 
		'Kann die Ticket ID in der Zeiterfassung für Artikel %s nicht aktualisieren!';

    # Kernel/Output/HTML/Templates/Standard/AgentArticleCopyMove.tt
    $Lang->{'Copy/Move/Delete'} = 'Kopieren/Verschieben/Löschen';
    $Lang->{'Cancel & close window'} = 'Abbrechen und Fenster schließen';
    $Lang->{'Article subject'} = 'Artikel Betreff';
    $Lang->{'Action to be performed'} = 'Auszuführende Aktion';
    $Lang->{'Copy'} = 'Kopieren';
    $Lang->{'Move'} = 'Verschieben';
    $Lang->{'Delete'} = 'Löschen';
    $Lang->{'Options for Delete'} = 'Löschoptionen';
    $Lang->{'Really delete this article?'} = 'Diesen Artikel wirklich löschen?';
    $Lang->{'This field is required.'} = 'Dieses Feld ist ein Pflichtfeld.';
    $Lang->{'Options for Copy'} = 'Kopieroptionen';
    $Lang->{'%s of destination ticket'} = '%s des Zieltickets';
    $Lang->{'Invalid ticket identifier!'} = 'Ungültiger Ticket-Identifizierer!';
    $Lang->{'Copied time units of the source article'} = 'Zu kopierende Zeiteinheiten des Quellarticels';
    $Lang->{'Invalid time!'} = 'Ungültige Zeitangabe';
    $Lang->{'You cannot assign more time units as in the source article!'} =
        'Sie können nicht mehr Zeiteinheiten zuweisen, als im Original-Artikel!';
    $Lang->{'Handling of accounted time from source article?'} = 'Umgang mit Zeitbuchung am Original-Artikel?';
    $Lang->{'Leave unchanged'} = 'Unverändert lassen';
    $Lang->{'Change to residue'} = 'Auf Rest verringern';
    $Lang->{'Submit'} = 'Übermitteln';
    $Lang->{'Options for Move'} = 'Verschiebeoptionen';
}

1;
