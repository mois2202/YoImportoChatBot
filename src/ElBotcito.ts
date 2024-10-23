import {ExecuteSP , ExecuteSPR} from './Modulos/SPs/Sps';
import { BotContext } from '@builderbot/bot/dist/types';

 export async function ElBotcito(ctx:BotContext) : Promise<string> {
    try {

        const info:any[] = await ExecuteSPR('F_get_Is_Exist_Client', [ctx.from]); 
        return Seguimiento(ctx.from);              

    } catch (error) {

        console.error('Error executing stored procedure:', error);
        return 'Sin datos';
    }
}

async function Seguimiento(from:string) : Promise<string> {
    const info:any[] = await ExecuteSPR('get_content', [from]);
    console.log(info);
    console.log(info[0].tcontenido);
    return info[0].tcontenido;
}

export default ElBotcito;