--DROP FUNCTION f_get_resul_seguimiento

CREATE OR REPLACE FUNCTION public.f_get_resul_seguimiento(
	num text,
	opc text)
    RETURNS TABLE(tid character varying, tcontenido text, trespuestas text, ttypeMedia boolean, tfileName varchar(300)) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$

DECLARE

    selectOpc TEXT;
	OpcAnterior TEXT;

BEGIN

 	IF (SELECT COUNT(*) FROM clientes WHERE numero = num) = 0 THEN

        INSERT INTO clientes (numero, seguimiento, ultimomsj) VALUES (num, 'tw1',NOW());
		INSERT INTO historial (numero) VALUES (num);

		RETURN QUERY
    	SELECT id, contenido, respuestas, typeMedia,filename FROM flujo WHERE id = 'tw1';

	ELSE

		OpcAnterior := (SELECT seguimiento FROM v_get_info_seguimiento WHERE numero = num);
		selectOpc := (SELECT f_get_opcion((SELECT respuestas FROM v_get_info_seguimiento WHERE numero = num), opc));

		UPDATE historial SET hora = NOW(), mensaje = opc, flujo = OpcAnterior WHERE numero = num;
		UPDATE clientes SET seguimiento = selectOpc, ultimomsj = NOw() WHERE numero = num;
		
    	RETURN QUERY 
    	SELECT * FROM f_get_respuesta(num,selectOpc);

	END IF;
	
END;
$BODY$;

ALTER FUNCTION public.f_get_resul_seguimiento(text, text)
    OWNER TO postgres;