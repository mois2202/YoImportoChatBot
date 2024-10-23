import * as EstadoBD from './EstadoBD';

async function ComprobarSistema() : Promise<boolean> {    
    return await EstadoBD.VerEstadoDB();
}

export default ComprobarSistema;