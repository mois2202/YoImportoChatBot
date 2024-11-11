CREATE OR REPLACE FUNCTION public.f_get_is_exist_client(
	num character varying)
    RETURNS TABLE(tcontenido text, isexistr boolean) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
BEGIN

    IF (SELECT COUNT(*) FROM clientes WHERE numero = num) = 0 THEN

        INSERT INTO clientes (numero, seguimiento, ultimomsj) VALUES (num, 'tw1',NOW());

	RETURN QUERY
    SELECT contenido,false as IsExistR  FROM flujo WHERE id = 'tw1';

	ELSE

    RETURN QUERY
    SELECT '' as tcontenido ,true as IsExistR;
	
    END IF;

END;
$BODY$;

ALTER FUNCTION public.f_get_is_exist_client(character varying)
    OWNER TO postgres;
