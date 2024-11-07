CREATE TABLE IF NOT EXISTS public.infoclientes
(
    idcliente integer NOT NULL DEFAULT nextval('infoclientes_idcliente_seq'::regclass),
    nombre character varying(200) COLLATE pg_catalog."default",
    edad integer,
    CONSTRAINT infoclientes_pkey PRIMARY KEY (idcliente),
    CONSTRAINT infoclientes_idcliente_fkey FOREIGN KEY (idcliente)
        REFERENCES public.clientes (idcliente) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.infoclientes
    OWNER to postgres;