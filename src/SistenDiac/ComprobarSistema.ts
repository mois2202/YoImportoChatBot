import * as EstadoBD from './EstadoBD';

function ComprobarSistema() : boolean {    
    return EstadoBD.VerEstadoDB();
}

export default ComprobarSistema;