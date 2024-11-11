import {ExecuteSQLFunction}  from '../SQLExecute';
import { BotContext } from '@builderbot/bot/dist/types';

 export async function InitChat(ctx:BotContext) : Promise<string> {
    try {
        
        const info:any[] = await ExecuteSQLFunction('f_get_is_exist_client', [ctx.from]);        
        if(info[0].isexistr)
        {   
            return Seguimiento(ctx.from,ctx.body); 
        }
        return info[0].tcontenido;        

    } catch (error) {
        
        console.error('Error executing stored procedure:', error);
        return 'Sin datos';

    }
}

async function Seguimiento(from: string, resp: string): Promise<any> {
    try {

        const info: any[] = await ExecuteSQLFunction('f_get_content', [from, resp]);
        console.log(info);
        
        if (info[0].ttypefile != null) {

            console.log(process.cwd());
            return [info[0].tcontenido,info[0].tfilename]; 
            
        }

        return info[0].tcontenido; 

    } catch {

        console.log('Error al ejecutar segunda interacción');
        return 'No se pudo hacer seguimiento';

    }
}

