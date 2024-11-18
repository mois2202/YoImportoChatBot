import * as EstadoBD from './EstadoBD';
export function ComprobarSistema() {
    return EstadoBD.VerEstadoDB();
}
export default { ComprobarSistema };
