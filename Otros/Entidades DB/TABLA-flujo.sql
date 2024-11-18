--DROP TABLE flujo

CREATE TABLE IF NOT EXISTS public.flujo
(
    id character varying(100) COLLATE pg_catalog."default" NOT NULL,
    contenido text COLLATE pg_catalog."default",
    respuestas text COLLATE pg_catalog."default",
	typeMedia Boolean default false,
	fileName VARCHAR(300),
    CONSTRAINT flujo_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.flujo
    OWNER to postgres;