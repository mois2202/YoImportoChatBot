import ComprobarDB from '../PreparacionSistema/ComprobarDB';

function VerificarSistema(): boolean {
    let todoEnOrden: boolean;
    todoEnOrden = ComprobarDB();
    return todoEnOrden;
}

export default VerificarSistema;