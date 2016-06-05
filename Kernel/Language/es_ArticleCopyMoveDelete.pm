# --
# Kernel/Language/de_ArticleCopyMoveDelete.pm - provides es translation for ArticleCopyMoveDelete
# Thanks to Eladio Galvez from JoopBox.com for providing the translation
# Copyright (C) 2006-2015 c.a.p.e. IT GmbH, http://www.cape-it.de
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
    return 0 if ref $Lang ne 'HASH';

    # possible charsets
    $Self->{Charset} = ['utf-8', ];

    # $$START$$

    # AgentArticleCopyMove
    $Lang->{'Copy/Move/Delete'}             = 'Copiar/Mover/Eliminar';
    $Lang->{'of destination ticket'}        = 'Ticket Destino';
    $Lang->{'Copy, Move or Delete Article'} = 'Copiar, Mover o Eliminar Artículo';
    $Lang->{'Copy, move or delete selected article'} =
        'Copiar, mover o eliminar artículos seleccionados';
    $Lang->{'Action to be performed'} = 'Acción a aplicar';
    $Lang->{'Copy'}                   = 'Copiar';
    $Lang->{'You cannot asign more time units as in the source article!'} =
        'No puedes aplicar más unidades de tiempo que en las del articulo origen!';
    $Lang->{'Copy Options'}            = 'Opciones de copiar';
    $Lang->{'Delete Options'}          = 'Opciones de borrar';
    $Lang->{'Move Options'}            = 'Opciones de mover';
    $Lang->{'Really delete this article?'} = 'Realmente quiere eliminar este artículo?';
    $Lang->{'Time units to transfer'}      = 'Unidades de tiempo a transferir';
    $Lang->{'Handling of accounted time from source article?'} =
        'Uso del mismo tiempo contabilizado en el artículo origen?';
    $Lang->{'Change to residue'}   = 'Cambiar a residuo';
    $Lang->{'Leave unchanged'}     = 'Mantener sin modificar';
    $Lang->{'Owner / Responsible'} = 'Propietario / Responsable';
    $Lang->{'Change the ticket owner and responsible!'} =
        'Cambiar el propietario y responsable del Ticket!';
    $Lang->{'Perhaps, you forgot to enter a ticket number!'} =
        'Posiblemente has olvidado introducir un número de Ticket!';
    $Lang->{'Sorry, no ticket found for ticket number: '} =
        'Lo sentimos, no se ha encontrado un ticket con ese número!: ';
    $Lang->{'Sorry, you need to be owner of the new ticket to do this action!'} =
        'Lo sentimos, debes de ser el propietario del nuevo ticket para realizar esta acción!';
    $Lang->{'Sorry, you need to be owner of the selected ticket to do this action!'} =
        'Lo sentimos, debes de ser el propietario del ticket seleccionado para realizar esta acción!';
    $Lang->{'Please contact your admin.'}     = 'Por favor, contact con su administrador.';
    $Lang->{'Please change the owner first.'} = 'Por favor, modifique el propietario primero.';
    $Lang->{'Sorry, you are not a member of allowed groups!'} =
        'Lo sentimos, no eres miembro de un grupo permitido!';

    $Lang->{'Options for Copy'} = 'Opciones de copiar';
    $Lang->{'Options for Move'} = 'Opciones de mover';
    $Lang->{'Options for Delete'} = 'Opciones de borrar';

    $Lang->{'Copied time units of the source article'} = 'Copiar las unidades de tiempo del artículo origen';
    # EO AgentArticleCopyMove

    # $$STOP$$

    return 0;
}

1;
