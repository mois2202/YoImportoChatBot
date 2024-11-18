import { createBot, createProvider, createFlow, addKeyword, EVENTS } from '@builderbot/bot';
import { BaileysProvider as Provider } from '@builderbot/provider-baileys';
import { MemoryDB as Database } from '@builderbot/bot';
import { ComprobarSistema } from './SistemDiac/ComprobarSistemas';
import { InitChat } from './InitChat';
import { console } from 'inspector';
const PORT = process.env.PORT ?? 3008;
const ElBotcito = addKeyword(EVENTS.WELCOME)
    .addAction(async (ctx, { flowDynamic }) => {
    await (async () => {
        console.log('inicio');
        const response = await InitChat(ctx);
        if (Array.isArray(response)) {
            console.log('fiti');
            await flowDynamic(response);
        }
        else {
            console.log('texto');
            await flowDynamic([{ body: response }]);
        }
    })();
});
const main = async () => {
    const adapterFlow = createFlow([ElBotcito]);
    const adapterProvider = createProvider(Provider);
    const adapterDB = new Database();
    const { handleCtx, httpServer } = await createBot({
        flow: adapterFlow,
        provider: adapterProvider,
        database: adapterDB,
    });
    adapterProvider.server.post('/v1/messages', handleCtx(async (bot, req, res) => {
        const { number, message, urlMedia } = req.body;
        await bot.sendMessage(number, message, { media: urlMedia ?? null });
        return res.end('sended');
    }));
    adapterProvider.server.post('/v1/register', handleCtx(async (bot, req, res) => {
        const { number, name } = req.body;
        await bot.dispatch('REGISTER_FLOW', { from: number, name });
        return res.end('trigger');
    }));
    adapterProvider.server.post('/v1/samples', handleCtx(async (bot, req, res) => {
        const { number, name } = req.body;
        await bot.dispatch('SAMPLES', { from: number, name });
        return res.end('trigger');
    }));
    adapterProvider.server.post('/v1/blacklist', handleCtx(async (bot, req, res) => {
        const { number, intent } = req.body;
        if (intent === 'remove')
            bot.blacklist.remove(number);
        if (intent === 'add')
            bot.blacklist.add(number);
        res.writeHead(200, { 'Content-Type': 'application/json' });
        return res.end(JSON.stringify({ status: 'ok', number, intent }));
    }));
    httpServer(+PORT);
};
if (ComprobarSistema()) {
    console.log('Sistema en linea');
    main();
}
else {
    console.log('Existe un problema');
}
