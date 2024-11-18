--DROP VIEW v_get_info_seguimiento

CREATE OR REPLACE VIEW public.v_get_info_seguimiento
 AS
 SELECT c.idcliente,
    c.numero,
    c.ultimomsj,
    c.seguimiento,
    f.id,
    f.contenido,
    f.respuestas,
    f.typeMedia,
    f.filename
   FROM clientes c
     LEFT JOIN flujo f ON f.id::text = c.seguimiento::text;

ALTER TABLE public.v_get_info_seguimiento
    OWNER TO postgres;

