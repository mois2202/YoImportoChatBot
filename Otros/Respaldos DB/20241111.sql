PGDMP  )                
    |            BdBot    17.0    17.0                 0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                           false                       0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                           false                       0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                           false                       1262    16388    BdBot    DATABASE     z   CREATE DATABASE "BdBot" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Spanish_Spain.1252';
    DROP DATABASE "BdBot";
                     postgres    false            �            1255    41146    f_get_content(text, text)    FUNCTION     �  CREATE FUNCTION public.f_get_content(num text, opc text) RETURNS TABLE(tid character varying, tcontenido text, trespuestas text, ttypefile character, tfilename character varying)
    LANGUAGE plpgsql
    AS $$

DECLARE
    PociblesOpciones TEXT;
    selectOpc TEXT;

BEGIN

	PociblesOpciones := (SELECT respuestas FROM v_get_cotenido_seguimiento WHERE numero = num);
	selectOpc := (SELECT f_get_respuesta(PociblesOpciones, opc));
	UPDATE clientes SET seguimiento = selectOpc WHERE numero = num;
		
	
    RETURN QUERY 
    SELECT id,contenido, respuestas , typefile, filename 
    FROM v_get_cotenido_seguimiento 
    WHERE numero = num;
	
END;
$$;
 8   DROP FUNCTION public.f_get_content(num text, opc text);
       public               postgres    false            �            1255    32983 (   f_get_is_exist_client(character varying)    FUNCTION     �  CREATE FUNCTION public.f_get_is_exist_client(num character varying) RETURNS TABLE(tcontenido text, isexistr boolean)
    LANGUAGE plpgsql
    AS $$
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
$$;
 C   DROP FUNCTION public.f_get_is_exist_client(num character varying);
       public               postgres    false            �            1255    32977    f_get_respuesta(text, text)    FUNCTION     �  CREATE FUNCTION public.f_get_respuesta(entry text, match text) RETURNS text
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
       public               postgres    false            �            1259    41099    clientes    TABLE     �   CREATE TABLE public.clientes (
    idcliente integer NOT NULL,
    numero character varying(20) NOT NULL,
    ultimomsj timestamp without time zone,
    seguimiento character varying(200)
);
    DROP TABLE public.clientes;
       public         heap r       postgres    false            �            1259    41098    clientes_idcliente_seq    SEQUENCE     �   CREATE SEQUENCE public.clientes_idcliente_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.clientes_idcliente_seq;
       public               postgres    false    218                       0    0    clientes_idcliente_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.clientes_idcliente_seq OWNED BY public.clientes.idcliente;
          public               postgres    false    217            �            1259    41107    flujo    TABLE     �   CREATE TABLE public.flujo (
    id character varying(100) NOT NULL,
    contenido text,
    respuestas text,
    typefile character(3),
    filename character varying(300)
);
    DROP TABLE public.flujo;
       public         heap r       postgres    false            �            1259    41114    v_get_cotenido_seguimiento    VIEW     +  CREATE VIEW public.v_get_cotenido_seguimiento AS
 SELECT c.idcliente,
    c.numero,
    c.ultimomsj,
    c.seguimiento,
    f.id,
    f.contenido,
    f.respuestas,
    f.typefile,
    f.filename
   FROM (public.clientes c
     LEFT JOIN public.flujo f ON (((f.id)::text = (c.seguimiento)::text)));
 -   DROP VIEW public.v_get_cotenido_seguimiento;
       public       v       postgres    false    219    219    219    218    218    218    218    219    219            b           2604    41102    clientes idcliente    DEFAULT     x   ALTER TABLE ONLY public.clientes ALTER COLUMN idcliente SET DEFAULT nextval('public.clientes_idcliente_seq'::regclass);
 A   ALTER TABLE public.clientes ALTER COLUMN idcliente DROP DEFAULT;
       public               postgres    false    217    218    218            �          0    41099    clientes 
   TABLE DATA           M   COPY public.clientes (idcliente, numero, ultimomsj, seguimiento) FROM stdin;
    public               postgres    false    218          �          0    41107    flujo 
   TABLE DATA           N   COPY public.flujo (id, contenido, respuestas, typefile, filename) FROM stdin;
    public               postgres    false    219   c                  0    0    clientes_idcliente_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.clientes_idcliente_seq', 13, true);
          public               postgres    false    217            d           2606    41106    clientes clientes_numero_key 
   CONSTRAINT     Y   ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_numero_key UNIQUE (numero);
 F   ALTER TABLE ONLY public.clientes DROP CONSTRAINT clientes_numero_key;
       public                 postgres    false    218            f           2606    41104    clientes clientes_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_pkey PRIMARY KEY (idcliente);
 @   ALTER TABLE ONLY public.clientes DROP CONSTRAINT clientes_pkey;
       public                 postgres    false    218            h           2606    41113    flujo flujo_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.flujo
    ADD CONSTRAINT flujo_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.flujo DROP CONSTRAINT flujo_pkey;
       public                 postgres    false    219            �   ?   x�34�4�0141276�4��4202�54�54P0��2"K=SC3c#s��Լ���|�=... Gh�      �   �  x��RMk�@=K�b � d'�uH�n�Z
�0���iW�Y�����[��c�U$K�K-��;�f�̛a���J��@�%&���7��$u'w�S����}�H�R-�� �$o�͘�;4�-Aa�T%2��q�
��s��
�Q�,�%_�s�����hy��=M(q�
.�f?���s8W�̖�x5����t0g�g`��|P%���Ow�i)�Ó��1Q�A����m��aH`�`.?��'Z�&���?�`�҄�Z�c[� ���c�XL�Qu�|C��8��������s��/����Lb��_M�G��i
u���&M�����dv	���P��c皋륗�K�>OM�qO��AYSJ����J<����/��U㎴��h���/M��\���_����5��R]�����T�~A�j/��h�s�Aw�,`[��$'�ƃ�����ٟ����f�q��+@V     