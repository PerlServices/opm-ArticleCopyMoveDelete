# --
# Kernel/Language/es_ArticleCopyMoveDelete.pm - the Spanish translation for ArticleCopyMoveDelete
# Thanks to Eladio Galvez from JoopBox.com for providing the translation
# Copyright (C) 2006-2016 c.a.p.e. IT GmbH, http://www.cape-it.de
#
# written/edited by:
# * Mario(dot)Illinger(at)cape(dash)it(dot)de
#
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::es_ArticleCopyMoveDelete;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    # Kernel/Config/Files/AgentArticleCopyMove.xml
    $Lang->{'Activates the \'ArticleCopyMoveDelete\' link.'} = '';
    $Lang->{'Frontend module registration for AgentArticleCopyMoveDelete.'} = '';
    $Lang->{'Copy, move or delete selected article.'} = 'Copiar, mover o eliminar artículos seleccionados.';
    $Lang->{'Copy, Move or Delete Article'} = 'Copiar, Mover o Eliminar Artículo';
    $Lang->{'Overloads (redefines) existing functions in Kernel::System::Ticket. Used to easily add customizations.'} = '';

    # Kernel/Modules/AgentArticleCopyMove.pm
    $Lang->{'Sorry, you are not a member of allowed groups!'} = 'Lo sentimos, no eres miembro de un grupo permitido!';
    $Lang->{'Please contact the administrator.'} = 'Por favor, contact con su administrador.';
    $Lang->{'AgentArticleCopyMoveDelete: Need %s!'} = '';
    $Lang->{'Sorry, you need to be owner of the selected ticket to do this action!'} =
        'Lo sentimos, debes de ser el propietario del ticket seleccionado para realizar esta acción!';
    $Lang->{'Please change the owner first.'} = 'Por favor, modifique el propietario primero.';
    $Lang->{'Can\'t delete article %s from ticket %s!'} = '';
    $Lang->{'Perhaps, you forgot to enter a ticket number!'} =
        'Posiblemente has olvidado introducir un número de Ticket!';
    $Lang->{'Sorry, no ticket found for ticket number: %s!'} =
        'Lo sentimos, no se ha encontrado un ticket con ese número: %s!';
    $Lang->{'Sorry, you need to be owner of the new ticket to do this action!'} =
        'Lo sentimos, debes de ser el propietario del nuevo ticket para realizar esta acción!';
    $Lang->{'Can\'t copy article %s to ticket %s!'} = '';
    $Lang->{'Can\'t update times for article %s!'} = '';
    $Lang->{'Can\'t move article %s to ticket %s!'} = '';
    $Lang->{'Can\'t update ticket ID in time accounting data for article %s!'} = '';

    # Kernel/Output/HTML/Templates/Standard/AgentArticleCopyMove.tt
    $Lang->{'Copy/Move/Delete'} = 'Copiar/Mover/Eliminar';
    $Lang->{'Cancel & close window'} = '';
    $Lang->{'Article subject'} = '';
    $Lang->{'Action to be performed'} = 'Acción a aplicar';
    $Lang->{'Copy'} = 'Copiar';
    $Lang->{'Move'} = '';
    $Lang->{'Delete'} = '';
    $Lang->{'Options for Delete'} = 'Opciones de borrar';
    $Lang->{'Really delete this article?'} = 'Realmente quiere eliminar este artículo?';
    $Lang->{'This field is required.'} = '';
    $Lang->{'Options for Copy'} = 'Opciones de copiar';
    $Lang->{'%s of destination ticket'} = '%s Ticket Destino';
    $Lang->{'Invalid ticket identifier!'} = '';
    $Lang->{'Copied time units of the source article'} = 'Copiar las unidades de tiempo del artículo origen';
    $Lang->{'Invalid time!'} = '';
    $Lang->{'You cannot assign more time units as in the source article!'} =
        'No puedes aplicar más unidades de tiempo que en las del articulo origen!';
    $Lang->{'Handling of accounted time from source article?'} =
        'Uso del mismo tiempo contabilizado en el artículo origen?';
    $Lang->{'Leave unchanged'} = 'Mantener sin modificar';
    $Lang->{'Change to residue'} = 'Cambiar a residuo';
    $Lang->{'Submit'} = '';
    $Lang->{'Options for Move'} = 'Opciones de mover';
}

1;
