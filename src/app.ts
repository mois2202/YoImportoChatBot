import { createBot, createProvider, createFlow, addKeyword, utils ,EVENTS} from '@builderbot/bot'
import { PostgreSQLAdapter as Database } from '@builderbot/database-postgres'
import { BaileysProvider as Provider } from '@builderbot/provider-baileys'
import {InitChat} from './Modulos/InitChat';
import {dbConfig} from './Modulos/shared/db/dbConfig';
import {dbConnection} from './Modulos/shared/db/dbConnection';

const { host_pg, user_pg, password_pg, database_pg, port_pg } = dbConfig.db;
const PORT = process.env.PORT ?? 3008;

const NewClient = addKeyword(EVENTS.WELCOME)
  .addAction(async (ctx, { flowDynamic }) => {
    await flowDynamic(await InitChat(ctx));
  });


const main = async () => {
    const adapterFlow = createFlow([NewClient])  
    const adapterProvider = createProvider(Provider)
    const adapterDB = new Database({
       host: host_pg,
       user: user_pg,
       database: database_pg,
       password: password_pg,
       port: port_pg
   })

    const { handleCtx, httpServer } = await createBot({
        flow: adapterFlow,
        provider: adapterProvider,
        database: adapterDB,
    })

    adapterProvider.server.post(
        '/v1/messages',
        handleCtx(async (bot, req, res) => {
            const { number, message, urlMedia } = req.body
            if (bot) {
                await bot.sendMessage(number, message, { media: urlMedia ?? null })
            } else {
                res.status(500).send('Bot instance is undefined')
            }
            return res.end('sended')
        })
    )

    adapterProvider.server.post(
        '/v1/register',
        handleCtx(async (bot, req, res) => {
            const { number, name } = req.body
            if (bot) {
                await bot.dispatch('REGISTER_FLOW', { from: number, name })
            } else {
                res.status(500).send('Bot instance is undefined')
            }
            return res.end('trigger')
        })
    )

    adapterProvider.server.post(
        '/v1/samples',
        handleCtx(async (bot, req, res) => {
            const { number, name } = req.body
            if (bot) {
                await bot.dispatch('SAMPLES', { from: number, name })
            } else {
                res.status(500).send('Bot instance is undefined')
            }
            return res.end('trigger')
        })
    )

    adapterProvider.server.post(
        '/v1/blacklist',
        handleCtx(async (bot, req, res) => {
            const { number, intent } = req.body
            if (bot) {
                if (intent === 'remove') bot.blacklist.remove(number)
                if (intent === 'add') bot.blacklist.add(number)
            } else {
                res.status(500).send('Bot instance is undefined')
                return res.end()
            }

            res.writeHead(200, { 'Content-Type': 'application/json' })
            return res.end(JSON.stringify({ status: 'ok', number, intent }))
        })
    )

    httpServer(+PORT)

}



main();
