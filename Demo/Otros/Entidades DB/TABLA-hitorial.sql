-- Table: public.hitorial

-- DROP TABLE IF EXISTS public.historial;

CREATE TABLE IF NOT EXISTS public.historial
(
    numero character varying(20),
    hora timestamp without time zone DEFAULT now(),
    flujo character varying(300) COLLATE pg_catalog."default",
    mensaje text COLLATE pg_catalog."default",
	CONSTRAINT  hotorial_pkey PRIMARY KEY (numero)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.historial
    OWNER to postgres;