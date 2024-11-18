CREATE OR REPLACE VIEW public.v_get_cotenido_seguimiento
 AS
 SELECT c.idcliente,
    c.numero,
    c.ultimomsj,
    c.seguimiento,
    f.id,
    f.contenido,
    f.respuestas
   FROM clientes c
     LEFT JOIN flujo f ON f.id::text = c.seguimiento::text;

ALTER TABLE public.v_get_cotenido_seguimiento
    OWNER TO postgres;

