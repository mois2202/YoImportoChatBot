-- Table: public.complementos

-- DROP TABLE IF EXISTS public.complementos;

CREATE TABLE IF NOT EXISTS public.complementos
(
    id integer NOT NULL DEFAULT nextval('complementos_id_seq'::regclass),
    contenido text COLLATE pg_catalog."default",
    CONSTRAINT complementos_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.complementos
    OWNER to postgres;