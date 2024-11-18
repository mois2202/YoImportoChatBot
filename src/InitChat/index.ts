import {ExecuteSQLFunction}  from '../SQLExecute';
import { BotContext } from '@builderbot/bot/dist/types';

 export async function InitChat(ctx:BotContext) : Promise<any> {
    try {

        const info: any[] = await ExecuteSQLFunction('f_get_resul_seguimiento', [ctx.from,ctx.body]);
        console.log(info);
        
        if (info[0].ttypemedia) {

            return [info[0].tcontenido,info[0].tfilename]; 
            
        }
        return info[0].tcontenido; 

    } catch (error) {
        
        console.error('Error executing stored procedure:', error);
        return 'Sin datos';

    }
}