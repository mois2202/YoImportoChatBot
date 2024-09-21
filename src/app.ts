import { join } from 'path'
import { createBot, createProvider, createFlow, addKeyword, EVENTS} from '@builderbot/bot'
import { MemoryDB as Database } from '@builderbot/bot'
import { BaileysProvider as Provider } from '@builderbot/provider-baileys'
import { mensajeBienvenida, fechaCurso, queAprenderas, costoCurso, hablarConAsesor } from './messages'
import axios from 'axios'


const PORT = process.env.PORT ?? 3008


const menuFlow = addKeyword(EVENTS.WELCOME).addAnswer(
    mensajeBienvenida,
    { capture: true },
    async (ctx, { gotoFlow, fallBack, flowDynamic }) => {
      if (!["1", "2", "3", "4", "0"].includes(ctx.body)) {
        return fallBack(
          "Respuesta no válida, por favor selecciona una de las opciones."
        );
      }
      switch (ctx.body) {
        case "1":
          return gotoFlow(menu1Flow);
        case "2":
          return gotoFlow(menu2Flow);
        case "3":
          return gotoFlow(menu3Flow);
        case "4":
          return gotoFlow(menu4Flow);
        case "0":
          return await flowDynamic(
            "Saliendo... Puedes volver a acceder a este menú escribiendo '*Menu*'"
          );
      }
    }
  );


const menu1Flow = addKeyword(EVENTS.ACTION).addAnswer(queAprenderas);

const menu2Flow = addKeyword(EVENTS.ACTION).addAnswer(fechaCurso).addAnswer(``, 
    { media: join(process.cwd(), 'assets', 'Flyer1.jpg') });

const menu3Flow = addKeyword(EVENTS.ACTION).addAnswer(costoCurso);

const menu4Flow = addKeyword(EVENTS.ACTION).addAnswer(hablarConAsesor).addAction(
    async (ctx) => {
        try {
           
            // Datos del número y el mensaje
            const number : number = +584242976355; // Reemplaza con el número de destino, debe incluir el código del país, sin el signo '+'
            const message = `El numero de telefono +${ctx.from}, quiere comunicarse con un asesor`; // Reemplaza con el mensaje que deseas enviar 
            
            // Hacer una solicitud POST al endpoint interno del bot
            await axios.post(`http://localhost:${PORT}/v1/messages`, {
                number: number,
                message: message
            });
            console.log('Mensaje enviado correctamente');
        } catch (error) {
            console.error('Error al enviar el mensaje:', error);
        }
    }
);




const main = async () => {
    const adapterFlow = createFlow([menuFlow, menu1Flow, menu2Flow, menu3Flow, menu4Flow])
    
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
            const { number, message, urlMedia } = req.body
            await bot.sendMessage(number, message, { media: urlMedia ?? null })
            return res.end('sended')
        })
    )

    adapterProvider.server.post(
        '/v1/register',
        handleCtx(async (bot, req, res) => {
            const { number, name } = req.body
            await bot.dispatch('REGISTER_FLOW', { from: number, name })
            return res.end('trigger')
        })
    )

    adapterProvider.server.post(
        '/v1/samples',
        handleCtx(async (bot, req, res) => {
            const { number, name } = req.body
            await bot.dispatch('SAMPLES', { from: number, name })
            return res.end('trigger')
        })
    )

    adapterProvider.server.post(
        '/v1/blacklist',
        handleCtx(async (bot, req, res) => {
            const { number, intent } = req.body
            if (intent === 'remove') bot.blacklist.remove(number)
            if (intent === 'add') bot.blacklist.add(number)

            res.writeHead(200, { 'Content-Type': 'application/json' })
            return res.end(JSON.stringify({ status: 'ok', number, intent }))
        })
    )

    httpServer(+PORT)
}

main()
