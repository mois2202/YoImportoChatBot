CREATE OR REPLACE FUNCTION public.f_get_respuesta(num text,selectOpc text)
    RETURNS TABLE(tid character varying, tcontenido text, trespuestas text, ttypeMedia boolean, tfileName varchar(300)) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000
AS $BODY$

DECLARE 

ProximoFlujo text = (SELECT respuestas FROM flujo WHERE id = selectOpc);
Regresar text = (SELECT contenido FROM complementos WHERE id = 2);
Inicio text = (SELECT contenido FROM complementos WHERE id = 1);
BEGIN

	IF(ProximoFlujo = 'Sin Datos') THEN

		RETURN QUERY
		SELECT id, CONCAT(contenido, Inicio), respuestas, typeMedia, filename FROM v_get_info_seguimiento WHERE numero = num;
	
	ELSE
	
		RETURN QUERY 
		SELECT id, CONCAT(contenido, Regresar), respuestas , typeMedia, filename FROM v_get_info_seguimiento WHERE numero = num;

	END IF;

END;
$BODY$;

ALTER FUNCTION public.f_get_respuesta(text, text)
    OWNER TO postgres;
