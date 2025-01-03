PGDMP  7    6            
    |            BdBot    17.0    17.0                 0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                           false                       0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                           false                       0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                           false                       1262    16388    BdBot    DATABASE     z   CREATE DATABASE "BdBot" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Spanish_Spain.1252';
    DROP DATABASE "BdBot";
                     postgres    false            �            1255    32976    f_get_content(text, text)    FUNCTION     B  CREATE FUNCTION public.f_get_content(num text, opc text) RETURNS TABLE(tid character varying, tcontenido text, trespuestas text)
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
    SELECT id,contenido, respuestas 
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
       public               postgres    false            �            1259    41081    clientes    TABLE     �   CREATE TABLE public.clientes (
    idcliente integer NOT NULL,
    numero character varying(20) NOT NULL,
    ultimomsj date,
    seguimiento character varying(200),
    respuestas text NOT NULL
);
    DROP TABLE public.clientes;
       public         heap r       postgres    false            �            1259    41080    clientes_idcliente_seq    SEQUENCE     �   CREATE SEQUENCE public.clientes_idcliente_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.clientes_idcliente_seq;
       public               postgres    false    219                       0    0    clientes_idcliente_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.clientes_idcliente_seq OWNED BY public.clientes.idcliente;
          public               postgres    false    218            �            1259    24634    flujo    TABLE     o   CREATE TABLE public.flujo (
    id character varying(100) NOT NULL,
    contenido text,
    respuestas text
);
    DROP TABLE public.flujo;
       public         heap r       postgres    false            �            1259    41091    v_get_cotenido_seguimiento    VIEW       CREATE VIEW public.v_get_cotenido_seguimiento AS
 SELECT c.idcliente,
    c.numero,
    c.ultimomsj,
    c.seguimiento,
    f.id,
    f.contenido,
    f.respuestas
   FROM (public.clientes c
     LEFT JOIN public.flujo f ON (((f.id)::text = (c.seguimiento)::text)));
 -   DROP VIEW public.v_get_cotenido_seguimiento;
       public       v       postgres    false    219    217    219    217    217    219    219            b           2604    41084    clientes idcliente    DEFAULT     x   ALTER TABLE ONLY public.clientes ALTER COLUMN idcliente SET DEFAULT nextval('public.clientes_idcliente_seq'::regclass);
 A   ALTER TABLE public.clientes ALTER COLUMN idcliente DROP DEFAULT;
       public               postgres    false    218    219    219            �          0    41081    clientes 
   TABLE DATA           Y   COPY public.clientes (idcliente, numero, ultimomsj, seguimiento, respuestas) FROM stdin;
    public               postgres    false    219   j       �          0    24634    flujo 
   TABLE DATA           :   COPY public.flujo (id, contenido, respuestas) FROM stdin;
    public               postgres    false    217   �                  0    0    clientes_idcliente_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.clientes_idcliente_seq', 5, true);
          public               postgres    false    218            f           2606    41090    clientes clientes_numero_key 
   CONSTRAINT     Y   ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_numero_key UNIQUE (numero);
 F   ALTER TABLE ONLY public.clientes DROP CONSTRAINT clientes_numero_key;
       public                 postgres    false    219            h           2606    41088    clientes clientes_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_pkey PRIMARY KEY (idcliente);
 @   ALTER TABLE ONLY public.clientes DROP CONSTRAINT clientes_pkey;
       public                 postgres    false    219            d           2606    24640    flujo flujo_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.flujo
    ADD CONSTRAINT flujo_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.flujo DROP CONSTRAINT flujo_pkey;
       public                 postgres    false    217            �   ,   x�3�4�0141276�4��4202�54�50�,)7������ }��      �   �  x��R=O�@��_a����2e�D%� R%�&.\�����|�'���?�/�4K�|��~~�3)}�ڼcb�#!� ����$/�_:�F��1-_�*~j�@�1��oq-�s (y��PT(������ �x��"��!8����-�.�k�IO�5��p��n'痳���`��q`���k<�z�/�3���צ">�s��D+u���-I{�ɩ�{*U��˞r���FΞ3����,�/y2Y9���@����k��PFDݭ�	�u��^&m;�۹�bK\�swCZc7�i�ܖf�e�Oǯ��e���&{)���.5�����h��>Y��G+dF�R�z�eN4s���y�85>��z��S|u�J��bF�qTf�|�����"     