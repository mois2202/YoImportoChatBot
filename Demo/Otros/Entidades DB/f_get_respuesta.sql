CREATE OR REPLACE FUNCTION public.f_get_respuesta(
	entry text,
	match text)
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

ALTER FUNCTION public.f_get_respuesta(text, text)
    OWNER TO postgres;
