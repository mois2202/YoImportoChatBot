import {ExecuteSP , ExecuteSPR} from './Modulos/SPs/Sps';
import { BotContext } from '@builderbot/bot/dist/types';

const ElBotcito = async (ctx:BotContext) => {
    try {
        const info:any[] = await ExecuteSPR('V_Is_Exist_Client', [ctx.from]);
        
        if (info.length <= 0) {
            
        }
    } catch (error) {
        console.error('Error executing stored procedure:', error);
    }
}