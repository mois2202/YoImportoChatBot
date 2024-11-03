CREATE OR REPLACE FUNCTION public.f_get_content(
	num text,
	opc text)
    RETURNS TABLE(tid character varying, tcontenido text, trespuestas text) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$

DECLARE
    PosiblesOpciones TEXT;
    selectOpc TEXT;

BEGIN

	PosiblesOpciones := (SELECT respuestas  FROM get_cotenido_seguimiento WHERE numero = num);
	selectOpc := (SELECT f_get_respuesta(PosiblesOpciones, opc));
	UPDATE clientes SET seguimiento = selectOpc WHERE numero = num;
		
	
    RETURN QUERY 
    SELECT id,contenido, respuestas 
    FROM get_cotenido_seguimiento 
    WHERE numero = num;
	
END;
$BODY$;

ALTER FUNCTION public.f_get_content(text, text)
    OWNER TO postgres;
