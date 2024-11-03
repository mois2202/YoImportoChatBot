import * as EstadoBD from './EstadoBD';

export function ComprobarSistema() : Promise<boolean> {    
    return EstadoBD.VerEstadoDB();
}


export default {ComprobarSistema};