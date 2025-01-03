PGDMP  	                
    |            BdBot    17.0    17.0                0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                           false                       0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                           false                       0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                           false                       1262    16388    BdBot    DATABASE     z   CREATE DATABASE "BdBot" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Spanish_Spain.1252';
    DROP DATABASE "BdBot";
                     postgres    false            �            1255    41237    f_get_opcion(text, text)    FUNCTION     �  CREATE FUNCTION public.f_get_opcion(entry text, match text) RETURNS text
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
 ;   DROP FUNCTION public.f_get_opcion(entry text, match text);
       public               postgres    false            �            1255    41239    f_get_respuesta(text, text)    FUNCTION       CREATE FUNCTION public.f_get_respuesta(num text, selectopc text) RETURNS TABLE(tid character varying, tcontenido text, trespuestas text, ttypemedia boolean, tfilename character varying)
    LANGUAGE plpgsql
    AS $$

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
$$;
 @   DROP FUNCTION public.f_get_respuesta(num text, selectopc text);
       public               postgres    false            �            1255    41175 #   f_get_resul_seguimiento(text, text)    FUNCTION     "  CREATE FUNCTION public.f_get_resul_seguimiento(num text, opc text) RETURNS TABLE(tid character varying, tcontenido text, trespuestas text, ttypemedia boolean, tfilename character varying)
    LANGUAGE plpgsql
    AS $$

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
$$;
 B   DROP FUNCTION public.f_get_resul_seguimiento(num text, opc text);
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
       public               postgres    false    218                       0    0    clientes_idcliente_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.clientes_idcliente_seq OWNED BY public.clientes.idcliente;
          public               postgres    false    217            �            1259    41229    complementos    TABLE     R   CREATE TABLE public.complementos (
    id integer NOT NULL,
    contenido text
);
     DROP TABLE public.complementos;
       public         heap r       postgres    false            �            1259    41228    complementos_id_seq    SEQUENCE     �   CREATE SEQUENCE public.complementos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.complementos_id_seq;
       public               postgres    false    223                       0    0    complementos_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.complementos_id_seq OWNED BY public.complementos.id;
          public               postgres    false    222            �            1259    41159    flujo    TABLE     �   CREATE TABLE public.flujo (
    id character varying(100) NOT NULL,
    contenido text,
    respuestas text,
    typemedia boolean DEFAULT false,
    filename character varying(300)
);
    DROP TABLE public.flujo;
       public         heap r       postgres    false            �            1259    41219 	   historial    TABLE     �   CREATE TABLE public.historial (
    numero character varying(20) NOT NULL,
    hora timestamp without time zone DEFAULT now(),
    flujo character varying(300),
    mensaje text
);
    DROP TABLE public.historial;
       public         heap r       postgres    false            �            1259    41171    v_get_info_seguimiento    VIEW     (  CREATE VIEW public.v_get_info_seguimiento AS
 SELECT c.idcliente,
    c.numero,
    c.ultimomsj,
    c.seguimiento,
    f.id,
    f.contenido,
    f.respuestas,
    f.typemedia,
    f.filename
   FROM (public.clientes c
     LEFT JOIN public.flujo f ON (((f.id)::text = (c.seguimiento)::text)));
 )   DROP VIEW public.v_get_info_seguimiento;
       public       v       postgres    false    218    218    218    218    219    219    219    219    219            k           2604    41102    clientes idcliente    DEFAULT     x   ALTER TABLE ONLY public.clientes ALTER COLUMN idcliente SET DEFAULT nextval('public.clientes_idcliente_seq'::regclass);
 A   ALTER TABLE public.clientes ALTER COLUMN idcliente DROP DEFAULT;
       public               postgres    false    217    218    218            n           2604    41232    complementos id    DEFAULT     r   ALTER TABLE ONLY public.complementos ALTER COLUMN id SET DEFAULT nextval('public.complementos_id_seq'::regclass);
 >   ALTER TABLE public.complementos ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    223    222    223                      0    41099    clientes 
   TABLE DATA           M   COPY public.clientes (idcliente, numero, ultimomsj, seguimiento) FROM stdin;
    public               postgres    false    218   �(                 0    41229    complementos 
   TABLE DATA           5   COPY public.complementos (id, contenido) FROM stdin;
    public               postgres    false    223   )                 0    41159    flujo 
   TABLE DATA           O   COPY public.flujo (id, contenido, respuestas, typemedia, filename) FROM stdin;
    public               postgres    false    219   c)                 0    41219 	   historial 
   TABLE DATA           A   COPY public.historial (numero, hora, flujo, mensaje) FROM stdin;
    public               postgres    false    221   �+                  0    0    clientes_idcliente_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.clientes_idcliente_seq', 57, true);
          public               postgres    false    217                       0    0    complementos_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.complementos_id_seq', 2, true);
          public               postgres    false    222            p           2606    41106    clientes clientes_numero_key 
   CONSTRAINT     Y   ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_numero_key UNIQUE (numero);
 F   ALTER TABLE ONLY public.clientes DROP CONSTRAINT clientes_numero_key;
       public                 postgres    false    218            r           2606    41104    clientes clientes_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_pkey PRIMARY KEY (idcliente);
 @   ALTER TABLE ONLY public.clientes DROP CONSTRAINT clientes_pkey;
       public                 postgres    false    218            x           2606    41236    complementos complementos_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.complementos
    ADD CONSTRAINT complementos_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.complementos DROP CONSTRAINT complementos_pkey;
       public                 postgres    false    223            t           2606    41166    flujo flujo_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.flujo
    ADD CONSTRAINT flujo_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.flujo DROP CONSTRAINT flujo_pkey;
       public                 postgres    false    219            v           2606    41226    historial hotorial_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY public.historial
    ADD CONSTRAINT hotorial_pkey PRIMARY KEY (numero);
 A   ALTER TABLE ONLY public.historial DROP CONSTRAINT hotorial_pkey;
       public                 postgres    false    221               <   x���� �ڞ"�aGB1��NK����� ��Y*ˑh-x��Fv&Ҿ�o��
�         F   x�3��R��UH,JT(JM/J-N,RH�Q�M�+UH�+I��/�2�ɋ�#��� ��̼���|�=... ��$         *  x��RKk�@>K�b �Y �y�� �-4ipJJ@���^#�*�+�q�*���?֙�� ����������Y�Z��o�Za���gFI�v�$��l��]E��MT�
�0��]���	��V@�74TJ��۸�cj-
r��RʴHU��	�����h��2�#�w������irvB�m$H�@mW��	N�t0<rϵ�0:r�e)�)�w&Zi��R�
��&�!��`i���N[H` V������EnS�^Lw��
���)��V�$6�3S,�Z����g��$���R�����>.g����f�I0�TE[��N´b���Y04��e[pF��˄�v��}��fM�*W������^6ըͿZ*�r�W�Eܕ�r�y28��lϣ��ه�z�5e=-��BY\	��SF�2}����1E>�B�w�S�B(G'�:m(��>���|�qIQ�����S�k��N�8��F�E���eJ��U����c��w�{;;�{��#���qRp2���)�����i|�&��ш�Y�y���         9   x����0�w2����Iga$��N7��vG�� t�[ޫ��+��|ff�S	�     