import {ExecuteSQLFunction}  from '../SQLExecute';
import { BotContext } from '@builderbot/bot/dist/types';

 export async function InitChat(ctx:BotContext) : Promise<string> {
    try {
        const info:any[] = await ExecuteSQLFunction('F_get_Is_Exist_Client', [ctx.from]); 
        if(!info[0].isexistr)
        {   console.log(info);
            return info[0].tcontenido;        
        }
        return Seguimiento(ctx.from,ctx.body); 

    } catch (error) {
        console.error('Error executing stored procedure:', error);
        return 'Sin datos';
    }
}

async function Seguimiento(from:string, resp:string) : Promise<string> {
    try{
        const info:any[] = await ExecuteSQLFunction('f_get_content', [from,resp]);
        console.log(info);
        return info[0].tcontenido;
    }
    catch{
        console.log('Error al ejecutar segunda interaccion')
        return 'No se pudo hacer seguimiento';
    }

}

