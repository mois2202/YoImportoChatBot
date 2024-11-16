CREATE TABLE IF NOT EXISTS public.clientes
(
    idcliente integer NOT NULL DEFAULT nextval('clientes_idcliente_seq'::regclass),
    numero character varying(20) COLLATE pg_catalog."default" NOT NULL,
    ultimomsj timestamp without time zone,
    seguimiento character varying(200) COLLATE pg_catalog."default",
    CONSTRAINT clientes_pkey PRIMARY KEY (idcliente),
    CONSTRAINT clientes_numero_key UNIQUE (numero)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.clientes
    OWNER to postgres;