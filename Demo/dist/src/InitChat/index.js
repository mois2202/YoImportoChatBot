import { sendMedia } from '~/Media/TypeMessagesFunctions';
import { ExecuteSQLFunction } from '../SQLExecute';
export async function InitChat(ctx) {
    try {
        const info = await ExecuteSQLFunction('f_get_is_exist_client', [ctx.from]);
        if (info[0].isexistr) {
            return Seguimiento(ctx.from, ctx.body);
        }
        return info[0].tcontenido;
    }
    catch (error) {
        console.error('Error executing stored procedure:', error);
        return 'Sin datos';
    }
}
async function Seguimiento(from, resp) {
    try {
        const info = await ExecuteSQLFunction('f_get_content', [from, resp]);
        console.log(info);
        if (info[0].ttypefile != null) {
            console.log('envio de foto');
            const responseFile = sendMedia('IMA', 'test', 'Imagen test');
            console.log(responseFile);
            return responseFile;
        }
        console.log('envio normal');
        return info[0].tcontenido;
    }
    catch {
        console.log('Error al ejecutar segunda interacción');
        return 'No se pudo hacer seguimiento';
    }
}
