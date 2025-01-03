PGDMP      %            
    |            DemoChatBot    17.0    17.0                 0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                           false                       0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                           false                       0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                           false                       1262    24800    DemoChatBot    DATABASE     �   CREATE DATABASE "DemoChatBot" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_United States.1252';
    DROP DATABASE "DemoChatBot";
                     postgres    false            �            1255    24801    f_get_content(text, text)    FUNCTION     R  CREATE FUNCTION public.f_get_content(num text, opc text) RETURNS TABLE(tid character varying, tcontenido text, trespuestas text)
    LANGUAGE plpgsql
    AS $$

DECLARE
    PociblesOpciones TEXT;
    selectOpc TEXT;

BEGIN

	PociblesOpciones := (SELECT respuestas  FROM v_get_cotenido_seguimiento WHERE numero = num);
	selectOpc := (SELECT f_get_respuesta(PociblesOpciones, opc));
	UPDATE clientes SET seguimiento = selectOpc WHERE numero = num;
		
	
    RETURN QUERY 
    SELECT id,contenido, respuestas, type, filename 
    FROM v_get_cotenido_seguimiento 
    WHERE numero = num;
	
END;
$$;
 8   DROP FUNCTION public.f_get_content(num text, opc text);
       public               postgres    false            �            1255    24802 (   f_get_is_exist_client(character varying)    FUNCTION     �  CREATE FUNCTION public.f_get_is_exist_client(num character varying) RETURNS TABLE(tcontenido text, isexistr boolean)
    LANGUAGE plpgsql
    AS $$
BEGIN

    IF (SELECT COUNT(*) FROM clientes WHERE numero = num) = 0 THEN

        INSERT INTO clientes (numero, seguimiento, respuestas,ultimomsj) VALUES (num, 'tw1','',NOW());

	RETURN QUERY
    SELECT contenido,false as IsExistR  FROM flujo WHERE id = 'tw1';

	ELSE

    RETURN QUERY
    SELECT '' as tcontenido ,true as IsExistR;
	
    END IF;

END;
$$;
 C   DROP FUNCTION public.f_get_is_exist_client(num character varying);
       public               postgres    false            �            1255    24803    f_get_respuesta(text, text)    FUNCTION     �  CREATE FUNCTION public.f_get_respuesta(entry text, match text) RETURNS text
    LANGUAGE plpgsql
    AS $$
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
$$;
 >   DROP FUNCTION public.f_get_respuesta(entry text, match text);
       public               postgres    false            �            1259    24804    clientes    TABLE     �   CREATE TABLE public.clientes (
    idcliente integer NOT NULL,
    numero character varying(20) NOT NULL,
    ultimomsj date,
    seguimiento character varying(200),
    respuestas text NOT NULL
);
    DROP TABLE public.clientes;
       public         heap r       postgres    false            �            1259    24809    clientes_idcliente_seq    SEQUENCE     �   CREATE SEQUENCE public.clientes_idcliente_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.clientes_idcliente_seq;
       public               postgres    false    217                       0    0    clientes_idcliente_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.clientes_idcliente_seq OWNED BY public.clientes.idcliente;
          public               postgres    false    218            �            1259    24810    flujo    TABLE     �   CREATE TABLE public.flujo (
    id character varying(100) NOT NULL,
    contenido text,
    respuestas text,
    type character varying(10),
    filename text
);
    DROP TABLE public.flujo;
       public         heap r       postgres    false            �            1259    24815    v_get_cotenido_seguimiento    VIEW     '  CREATE VIEW public.v_get_cotenido_seguimiento AS
 SELECT c.idcliente,
    c.numero,
    c.ultimomsj,
    c.seguimiento,
    f.id,
    f.contenido,
    f.respuestas,
    f.type,
    f.filename
   FROM (public.clientes c
     LEFT JOIN public.flujo f ON (((f.id)::text = (c.seguimiento)::text)));
 -   DROP VIEW public.v_get_cotenido_seguimiento;
       public       v       postgres    false    219    217    217    217    219    217    219    219    219            b           2604    24819    clientes idcliente    DEFAULT     x   ALTER TABLE ONLY public.clientes ALTER COLUMN idcliente SET DEFAULT nextval('public.clientes_idcliente_seq'::regclass);
 A   ALTER TABLE public.clientes ALTER COLUMN idcliente DROP DEFAULT;
       public               postgres    false    218    217            �          0    24804    clientes 
   TABLE DATA           Y   COPY public.clientes (idcliente, numero, ultimomsj, seguimiento, respuestas) FROM stdin;
    public               postgres    false    217          �          0    24810    flujo 
   TABLE DATA           J   COPY public.flujo (id, contenido, respuestas, type, filename) FROM stdin;
    public               postgres    false    219   P                  0    0    clientes_idcliente_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.clientes_idcliente_seq', 6, true);
          public               postgres    false    218            d           2606    24821    clientes clientes_numero_key 
   CONSTRAINT     Y   ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_numero_key UNIQUE (numero);
 F   ALTER TABLE ONLY public.clientes DROP CONSTRAINT clientes_numero_key;
       public                 postgres    false    217            f           2606    24823    clientes clientes_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_pkey PRIMARY KEY (idcliente);
 @   ALTER TABLE ONLY public.clientes DROP CONSTRAINT clientes_pkey;
       public                 postgres    false    217            h           2606    24825    flujo flujo_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.flujo
    ADD CONSTRAINT flujo_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.flujo DROP CONSTRAINT flujo_pkey;
       public                 postgres    false    219            �   ?   x�3�4�0141276�4��4202�54�50�,)7��2I����#��9c�8�b���� ���      �   �  x��RMk�@=ۿB�[INz����]h�KZ�,�b+�[�fҏC�S��^�Ǫq�$�K��轑��Ķ(}�ڼ`�Z��@P�͛���B�q7�� �x��2��Cpt�H�%Y�w)��8�צ��Lr?�2�xL�����q:1�.��$�`�,�F��8�5ˎ�S���l8��;hd^������Sxi��ɧ��Td�Uyw��V�	�������S��*[�}o2��c��b��O��%SQZ/���Z T�qV#�
ed��0?���>��ܣ��mGs��o�`�k}��x�7��<J�l[��?֓��0�׎��1�{A���+���7Z+1OC,�"y�(��h{��>vȉ"?pQc\>�]�����:�W_��$�Qe��m�K�k�m����8�&^���(M�w˲)�     