import {ExecuteSP , ExecuteSPR} from './Modulos/SPs/Sps';
import { BotContext } from '@builderbot/bot/dist/types';

 export async function ElBotcito(ctx:BotContext) : Promise<string> {
    try {

        const info:any[] = await ExecuteSPR('F_get_Is_Exist_Client', [ctx.from]); 
        if(info[0].isexistr)
        {
            return Seguimiento(ctx.from,ctx.body);   

        }else{

            console.log(info);
            return info[0].tcontenido;

        }

    } catch (error) {

        console.error('Error executing stored procedure:', error);
        return 'Sin datos';
    }
}

async function Seguimiento(from:string, resp:string) : Promise<string> {
    const info:any[] = await ExecuteSPR('f_get_content', [from,resp]);
    console.log(info);
    return info[0].tcontenido;
}

export default ElBotcito;