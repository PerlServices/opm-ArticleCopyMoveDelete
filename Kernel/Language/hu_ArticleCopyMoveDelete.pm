# --
# Kernel/Language/hu_ArticleCopyMoveDelete.pm - the Hungarian translation for ArticleCopyMoveDelete
# Copyright (C) 2006-2016 c.a.p.e. IT GmbH, http://www.cape-it.de
# Copyright (C) 2016 Balázs Úr, http://www.otrs-megoldasok.hu
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::hu_ArticleCopyMoveDelete;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    # Kernel/Config/Files/AgentArticleCopyMove.xml
    $Lang->{'Activates the \'ArticleCopyMoveDelete\' link.'} =
        'Bekapcsolja a bejegyzés másolása, áthelyezése, törlése hivatkozást.';
    $Lang->{'Frontend module registration for AgentArticleCopyMoveDelete.'} =
        'Előtétprogram-modul regisztráció az ügyintézői bejegyzés másoláshoz, áthelyezéshez, törléshez.';
    $Lang->{'Copy, move or delete selected article.'} = 'A kijelölt bejegyzés másolása, áthelyezése vagy törlése.';
    $Lang->{'Copy, Move or Delete Article'} = 'Bejegyzés másolása, áthelyezése vagy törlése';
    $Lang->{'Overloads (redefines) existing functions in Kernel::System::Ticket. Used to easily add customizations.'} =
        'Túlterheli (újra meghatározza) a meglévő függvényeket a Kernel::System::Ticket helyen. Arra használják, hogy egyszerűen hozzáadhatók legyenek a személyre szabások.';

    # Kernel/Modules/AgentArticleCopyMove.pm
    $Lang->{'Sorry, you are not a member of allowed groups!'} =
        'Sajnáljuk, de Ön nem tagja az engedélyezett csoportoknak!';
    $Lang->{'Please contact the administrator.'} = 'Vegye fel a kapcsolatot a rendszergazdával.';
    $Lang->{'AgentArticleCopyMoveDelete: Need %s!'} =
        'Ügyintézői bejegyzés másolás, áthelyezés, törlés: %s szükséges!';
    $Lang->{'Sorry, you need to be owner of the selected ticket to do this action!'} =
        'Sajnáljuk, de a kijelölt jegy tulajdonosának kell lennie a művelet végrehajtásához!';
    $Lang->{'Please change the owner first.'} = 'Először változtassa meg a tulajdonost.';
    $Lang->{'Can\'t delete article %s from ticket %s!'} = 'Nem lehet törölni a(z) %s bejegyzést ebből a jegyből: %s!';
    $Lang->{'Perhaps, you forgot to enter a ticket number!'} = 'Valószínűleg elfelejtett jegyszámot beírni!';
    $Lang->{'Sorry, no ticket found for ticket number: %s!'} =
        'Sajnáljuk, de nem található jegy ehhez a jegyszámhoz: %s!';
    $Lang->{'Sorry, you need to be owner of the new ticket to do this action!'} =
        'Sajnáljuk, de az új jegy tulajdonosának kell lennie a művelet végrehajtásához!';
    $Lang->{'Can\'t copy article %s to ticket %s!'} = 'Nem lehet átmásolni a(z) %s bejegyzést ebbe a jegybe: %s!';
    $Lang->{'Can\'t update times for article %s!'} = 'Nem lehet frissíteni az időket ennél a bejegyzésnél: %s!';
    $Lang->{'Can\'t move article %s to ticket %s!'} = 'Nem lehet áthelyezni a(z) %s bejegyzést ebbe a jegybe: %s!';
    $Lang->{'Can\'t update ticket ID in time accounting data for article %s!'} =
        'Nem lehet frissíteni a jegyazonosítót az időelszámolási adatokban ennél a bejegyzésnél: %s!';

    # Kernel/Output/HTML/Templates/Standard/AgentArticleCopyMove.tt
    $Lang->{'Copy/Move/Delete'} = 'Másolás, áthelyezés, törlés';
    $Lang->{'Cancel & close window'} = 'Megszakítás és az ablak bezárása';
    $Lang->{'Article subject'} = 'Bejegyzés tárgya';
    $Lang->{'Action to be performed'} = 'Végrehajtandó művelet';
    $Lang->{'Copy'} = 'Másolás';
    $Lang->{'Move'} = 'Áthelyezés';
    $Lang->{'Delete'} = 'Törlés';
    $Lang->{'Options for Delete'} = 'Törlési beállítások';
    $Lang->{'Really delete this article?'} = 'Valóban törli ezt a bejegyzést?';
    $Lang->{'This field is required.'} = 'Ez a mező kötelező.';
    $Lang->{'Options for Copy'} = 'Másolási beállítások';
    $Lang->{'%s of destination ticket'} = 'A céljegy %s értéke';
    $Lang->{'Invalid ticket identifier!'} = 'Érvénytelen jegyazonosító!';
    $Lang->{'Copied time units of the source article'} = 'A forrásbejegyzés átmásolt időegységei';
    $Lang->{'Invalid time!'} = 'Érvénytelen idő!';
    $Lang->{'You cannot assign more time units as in the source article!'} =
        'Nem rendelhet hozzá több időegységet annál, mint ami a forrásbejegyzésben volt!';
    $Lang->{'Handling of accounted time from source article?'} =
        'Hogyan kezeli az elszámolt időt a forrásbejegyzésből?';
    $Lang->{'Leave unchanged'} = 'Változatlanul hagyás';
    $Lang->{'Change to residue'} = 'Változtatás a maradékra';
    $Lang->{'Submit'} = 'Elküldés';
    $Lang->{'Options for Move'} = 'Áthelyezési beállítások';
}

1;
