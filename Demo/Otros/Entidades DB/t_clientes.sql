CREATE TABLE IF NOT EXISTS public.clientes
(
    idcliente SERIAL NOT NULL,
    numero character varying(20) COLLATE pg_catalog."default" NOT NULL,
    ultimomsj date,
    seguimiento character varying(200) COLLATE pg_catalog."default",
    respuestas text COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT clientes_pkey PRIMARY KEY (idcliente),
    CONSTRAINT clientes_numero_key UNIQUE (numero),
    CONSTRAINT unique_numero UNIQUE (numero)
)
TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.clientes
    OWNER to postgres;