CREATE OR REPLACE FUNCTION public.f_get_opcion(
	entry text,
	match text,
	nun text)
    RETURNS text
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
    parts text[];
    part text;
    key_value text[];
    result text;
BEGIN

	IF(match = '#') THEN

	SELECT * FROM 

    parts := string_to_array(entry, ',');

    FOREACH part IN ARRAY parts LOOP
        key_value := string_to_array(part, ':');

        IF key_value[1] = match THEN
            result := key_value[2];
            EXIT;
        END IF;
    END LOOP;

    RETURN result;
END;
$BODY$;

ALTER FUNCTION public.f_get_opcion(text, text)
    OWNER TO postgres;
