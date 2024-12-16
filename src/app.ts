import { createBot, createProvider, createFlow, addKeyword, EVENTS } from '@builderbot/bot'
import { BaileysProvider as Provider } from '@builderbot/provider-baileys'
import { MemoryDB as Database } from '@builderbot/bot'
import {ComprobarSistema} from './SistemDiac/ComprobarSistemas'
import { InitChat } from './InitChat'
import { console } from 'inspector'

const PORT = process.env.PORT ?? 3008

const ElBotcito = addKeyword(EVENTS.WELCOME)
  .addAction(async (ctx, { flowDynamic }) => {
    const resul = await InitChat(ctx);
    if(Array.isArray(resul))
    {
        await flowDynamic([{ body: resul[0], media: resul[1] }]);
    }
    else
    {
        await flowDynamic(resul);   
    }
  });

const main = async () => {
    const adapterFlow = createFlow([ElBotcito])
    
    const adapterProvider = createProvider(Provider)
    const adapterDB = new Database()

    const { handleCtx, httpServer } = await createBot({
        flow: adapterFlow,
        provider: adapterProvider,
        database: adapterDB,
    })

    adapterProvider.server.post(
        '/v1/messages',
        handleCtx(async (bot, req, res) => {
            console.log('bot', bot);
            console.log('req', req);
            console.log('res', res);
            const { number, message, urlMedia } = req.body
            await bot.sendMessage(number, message, { media: urlMedia ?? null })
            return res.end('sended')
        })
    )

    httpServer(+PORT)
}

if(ComprobarSistema())
{
    console.log('Sistema en linea');
    main();
}else
{
    console.log('Existe un problema');  
}

