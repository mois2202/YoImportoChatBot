PGDMP  !                 	    |            BdBot    17.0    17.0 2    1           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                           false            2           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                           false            3           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                           false            4           1262    16388    BdBot    DATABASE     z   CREATE DATABASE "BdBot" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Spanish_Spain.1252';
    DROP DATABASE "BdBot";
                     postgres    false            �            1255    16466    add_employee(character varying) 	   PROCEDURE     �   CREATE PROCEDURE public.add_employee(IN nombre character varying)
    LANGUAGE plpgsql
    AS $$

BEGIN

	INSERT INTO infoclientes (nombre)
    VALUES (Nombre);

END;

$$;
 A   DROP PROCEDURE public.add_employee(IN nombre character varying);
       public               postgres    false            �            1259    16390    clientes    TABLE     �   CREATE TABLE public.clientes (
    idcliente integer NOT NULL,
    numero character varying(20) NOT NULL,
    ultimomsj date,
    seguimiento character varying(200)
);
    DROP TABLE public.clientes;
       public         heap r       postgres    false            �            1259    16399    infoclientes    TABLE     z   CREATE TABLE public.infoclientes (
    idcliente integer NOT NULL,
    nombre character varying(200),
    edad integer
);
     DROP TABLE public.infoclientes;
       public         heap r       postgres    false            �            1259    16517    v_is_exist_client    VIEW     �   CREATE VIEW public.v_is_exist_client AS
 SELECT c.idcliente,
    c.numero,
    c.ultimomsj,
    c.seguimiento,
    ic.nombre,
    ic.edad
   FROM (public.clientes c
     LEFT JOIN public.infoclientes ic ON ((c.idcliente = ic.idcliente)));
 $   DROP VIEW public.v_is_exist_client;
       public       v       postgres    false    220    218    218    218    218    220    220            �            1255    24633 (   f_get_is_exist_client(character varying)    FUNCTION     �  CREATE FUNCTION public.f_get_is_exist_client(num character varying) RETURNS SETOF public.v_is_exist_client
    LANGUAGE plpgsql
    AS $$
BEGIN

    IF (SELECT COUNT(*) FROM clientes WHERE numero = num) = 0 THEN

        INSERT INTO clientes (numero, seguimiento) VALUES (num, 'tw1');
		
    END IF;


    RETURN QUERY
    SELECT * FROM V_Is_Exist_Client
    WHERE numero = num;

END;
$$;
 C   DROP FUNCTION public.f_get_is_exist_client(num character varying);
       public               postgres    false    221            �            1255    24679    get_content(text)    FUNCTION       CREATE FUNCTION public.get_content(num text) RETURNS TABLE(tid character varying, tcontenido text, trespuestas text)
    LANGUAGE plpgsql
    AS $$
BEGIN

    RETURN QUERY 
    SELECT id, contenido, respuestas FROM get_cotenido_seguimiento WHERE numero = num;
	
END;
$$;
 ,   DROP FUNCTION public.get_content(num text);
       public               postgres    false            �            1255    24671    get_table_content(text)    FUNCTION     	  CREATE FUNCTION public.get_table_content(idregistro text) RETURNS TABLE(idr character varying, contenidor text, respuestasr text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY 
    SELECT id, Contenido, Respuestas FROM flujo WHERE id = idRegistro;
END;
$$;
 9   DROP FUNCTION public.get_table_content(idregistro text);
       public               postgres    false            �            1255    16435 0   save_or_update_contact(character varying, jsonb)    FUNCTION     �  CREATE FUNCTION public.save_or_update_contact(in_phone character varying, in_values jsonb) RETURNS void
    LANGUAGE plpgsql
    AS $$
        DECLARE
            contact_cursor refcursor := 'cur_contact';
            contact_id INT;
        BEGIN
            SELECT id INTO contact_id FROM contact WHERE phone = in_phone;
        
            IF contact_id IS NULL THEN
                INSERT INTO contact (phone, "values")
                VALUES (in_phone, in_values);
            ELSE
                UPDATE contact SET "values" = in_values, updated_in = current_timestamp
                WHERE id = contact_id;
            END IF;
        END;
        $$;
 Z   DROP FUNCTION public.save_or_update_contact(in_phone character varying, in_values jsonb);
       public               postgres    false            �            1255    16436 n   save_or_update_history_and_contact(character varying, character varying, text, text, character varying, jsonb)    FUNCTION     �  CREATE FUNCTION public.save_or_update_history_and_contact(in_ref character varying, in_keyword character varying, in_answer text, in_refserialize text, in_phone character varying, in_options jsonb) RETURNS void
    LANGUAGE plpgsql
    AS $$
        DECLARE
            _contact_id INT;
        BEGIN
            SELECT id INTO _contact_id FROM contact WHERE phone = in_phone;
        
            IF _contact_id IS NULL THEN
                INSERT INTO contact (phone)
                VALUES (in_phone)
                RETURNING id INTO _contact_id;
            ELSE
                UPDATE contact SET last_interaction = current_timestamp WHERE id = _contact_id;
            END IF;
        
            INSERT INTO history (ref, keyword, answer, refserialize, phone, options, contact_id, created_at)
            VALUES (in_ref, in_keyword, in_answer, in_refserialize, in_phone, in_options, _contact_id, current_timestamp);
        
        END;
        $$;
 �   DROP FUNCTION public.save_or_update_history_and_contact(in_ref character varying, in_keyword character varying, in_answer text, in_refserialize text, in_phone character varying, in_options jsonb);
       public               postgres    false            �            1255    16468 -   set_insert_client(integer, character varying) 	   PROCEDURE     �   CREATE PROCEDURE public.set_insert_client(IN numero integer, IN seguimi character varying)
    LANGUAGE plpgsql
    AS $$

BEGIN

	INSERT INTO clientes (numero,ultimomsj,seguimiento)
    VALUES (numero,NOW(),seguimi);

END;

$$;
 Z   DROP PROCEDURE public.set_insert_client(IN numero integer, IN seguimi character varying);
       public               postgres    false            �            1255    16516 7   set_insert_client(character varying, character varying) 	   PROCEDURE     �   CREATE PROCEDURE public.set_insert_client(IN numero character varying, IN seguimi character varying)
    LANGUAGE plpgsql
    AS $$

BEGIN

	INSERT INTO clientes (numero,ultimomsj,seguimiento)
    VALUES (numero,NOW(),seguimi);

END;

$$;
 d   DROP PROCEDURE public.set_insert_client(IN numero character varying, IN seguimi character varying);
       public               postgres    false            �            1255    16467 3   set_insert_client(integer, date, character varying) 	   PROCEDURE     �   CREATE PROCEDURE public.set_insert_client(IN numero integer, IN ultimoms date, IN seguimi character varying)
    LANGUAGE plpgsql
    AS $$

BEGIN

	INSERT INTO clientes (nombre,ultimomsj,seguimiento)
    VALUES ('SAMUEL',NOW(),'NADA');

END;

$$;
 l   DROP PROCEDURE public.set_insert_client(IN numero integer, IN ultimoms date, IN seguimi character varying);
       public               postgres    false            �            1259    16389    clientes_idcliente_seq    SEQUENCE     �   CREATE SEQUENCE public.clientes_idcliente_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.clientes_idcliente_seq;
       public               postgres    false    218            5           0    0    clientes_idcliente_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.clientes_idcliente_seq OWNED BY public.clientes.idcliente;
          public               postgres    false    217            �            1259    24643    contact    TABLE     3  CREATE TABLE public.contact (
    id integer NOT NULL,
    phone character varying(255) DEFAULT NULL::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_in timestamp without time zone,
    last_interaction timestamp without time zone,
    "values" jsonb
);
    DROP TABLE public.contact;
       public         heap r       postgres    false            �            1259    24642    contact_id_seq    SEQUENCE     �   CREATE SEQUENCE public.contact_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.contact_id_seq;
       public               postgres    false    224            6           0    0    contact_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.contact_id_seq OWNED BY public.contact.id;
          public               postgres    false    223            �            1259    24634    flujo    TABLE     o   CREATE TABLE public.flujo (
    id character varying(100) NOT NULL,
    contenido text,
    respuestas text
);
    DROP TABLE public.flujo;
       public         heap r       postgres    false            �            1259    24673    get_cotenido_seguimiento    VIEW     	  CREATE VIEW public.get_cotenido_seguimiento AS
 SELECT c.idcliente,
    c.numero,
    c.ultimomsj,
    c.seguimiento,
    f.id,
    f.contenido,
    f.respuestas
   FROM (public.clientes c
     LEFT JOIN public.flujo f ON (((f.id)::text = (c.seguimiento)::text)));
 +   DROP VIEW public.get_cotenido_seguimiento;
       public       v       postgres    false    218    222    222    222    218    218    218            �            1259    24654    history    TABLE     �  CREATE TABLE public.history (
    id integer NOT NULL,
    ref character varying(255) NOT NULL,
    keyword character varying(255),
    answer text NOT NULL,
    refserialize text NOT NULL,
    phone character varying(255) DEFAULT NULL::character varying,
    options jsonb,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_in timestamp without time zone,
    contact_id integer
);
    DROP TABLE public.history;
       public         heap r       postgres    false            �            1259    24653    history_id_seq    SEQUENCE     �   CREATE SEQUENCE public.history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.history_id_seq;
       public               postgres    false    226            7           0    0    history_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.history_id_seq OWNED BY public.history.id;
          public               postgres    false    225            �            1259    16398    infoclientes_idcliente_seq    SEQUENCE     �   CREATE SEQUENCE public.infoclientes_idcliente_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.infoclientes_idcliente_seq;
       public               postgres    false    220            8           0    0    infoclientes_idcliente_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE public.infoclientes_idcliente_seq OWNED BY public.infoclientes.idcliente;
          public               postgres    false    219            {           2604    16393    clientes idcliente    DEFAULT     x   ALTER TABLE ONLY public.clientes ALTER COLUMN idcliente SET DEFAULT nextval('public.clientes_idcliente_seq'::regclass);
 A   ALTER TABLE public.clientes ALTER COLUMN idcliente DROP DEFAULT;
       public               postgres    false    218    217    218            }           2604    24646 
   contact id    DEFAULT     h   ALTER TABLE ONLY public.contact ALTER COLUMN id SET DEFAULT nextval('public.contact_id_seq'::regclass);
 9   ALTER TABLE public.contact ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    223    224    224            �           2604    24657 
   history id    DEFAULT     h   ALTER TABLE ONLY public.history ALTER COLUMN id SET DEFAULT nextval('public.history_id_seq'::regclass);
 9   ALTER TABLE public.history ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    226    225    226            |           2604    16402    infoclientes idcliente    DEFAULT     �   ALTER TABLE ONLY public.infoclientes ALTER COLUMN idcliente SET DEFAULT nextval('public.infoclientes_idcliente_seq'::regclass);
 E   ALTER TABLE public.infoclientes ALTER COLUMN idcliente DROP DEFAULT;
       public               postgres    false    219    220    220            '          0    16390    clientes 
   TABLE DATA           M   COPY public.clientes (idcliente, numero, ultimomsj, seguimiento) FROM stdin;
    public               postgres    false    218   �G       ,          0    24643    contact 
   TABLE DATA           `   COPY public.contact (id, phone, created_at, updated_in, last_interaction, "values") FROM stdin;
    public               postgres    false    224   H       *          0    24634    flujo 
   TABLE DATA           :   COPY public.flujo (id, contenido, respuestas) FROM stdin;
    public               postgres    false    222   I       .          0    24654    history 
   TABLE DATA           }   COPY public.history (id, ref, keyword, answer, refserialize, phone, options, created_at, updated_in, contact_id) FROM stdin;
    public               postgres    false    226   �I       )          0    16399    infoclientes 
   TABLE DATA           ?   COPY public.infoclientes (idcliente, nombre, edad) FROM stdin;
    public               postgres    false    220   gQ       9           0    0    clientes_idcliente_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.clientes_idcliente_seq', 7, true);
          public               postgres    false    217            :           0    0    contact_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.contact_id_seq', 21, true);
          public               postgres    false    223            ;           0    0    history_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.history_id_seq', 21, true);
          public               postgres    false    225            <           0    0    infoclientes_idcliente_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.infoclientes_idcliente_seq', 3, true);
          public               postgres    false    219            �           2606    16498    clientes clientes_numero_key 
   CONSTRAINT     Y   ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_numero_key UNIQUE (numero);
 F   ALTER TABLE ONLY public.clientes DROP CONSTRAINT clientes_numero_key;
       public                 postgres    false    218            �           2606    16395    clientes clientes_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_pkey PRIMARY KEY (idcliente);
 @   ALTER TABLE ONLY public.clientes DROP CONSTRAINT clientes_pkey;
       public                 postgres    false    218            �           2606    24652    contact contact_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.contact
    ADD CONSTRAINT contact_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.contact DROP CONSTRAINT contact_pkey;
       public                 postgres    false    224            �           2606    24640    flujo flujo_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.flujo
    ADD CONSTRAINT flujo_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.flujo DROP CONSTRAINT flujo_pkey;
       public                 postgres    false    222            �           2606    24663    history history_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.history
    ADD CONSTRAINT history_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.history DROP CONSTRAINT history_pkey;
       public                 postgres    false    226            �           2606    16404    infoclientes infoclientes_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY public.infoclientes
    ADD CONSTRAINT infoclientes_pkey PRIMARY KEY (idcliente);
 H   ALTER TABLE ONLY public.infoclientes DROP CONSTRAINT infoclientes_pkey;
       public                 postgres    false    220            �           2606    16505    clientes unique_numero 
   CONSTRAINT     S   ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT unique_numero UNIQUE (numero);
 @   ALTER TABLE ONLY public.clientes DROP CONSTRAINT unique_numero;
       public                 postgres    false    218            �           2606    24664    history history_contact_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.history
    ADD CONSTRAINT history_contact_id_fkey FOREIGN KEY (contact_id) REFERENCES public.contact(id);
 I   ALTER TABLE ONLY public.history DROP CONSTRAINT history_contact_id_fkey;
       public               postgres    false    226    224    4750            �           2606    16405 (   infoclientes infoclientes_idcliente_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.infoclientes
    ADD CONSTRAINT infoclientes_idcliente_fkey FOREIGN KEY (idcliente) REFERENCES public.clientes(idcliente) ON UPDATE CASCADE ON DELETE CASCADE;
 R   ALTER TABLE ONLY public.infoclientes DROP CONSTRAINT infoclientes_idcliente_fkey;
       public               postgres    false    4742    218    220            '   +   x�3�4�0141276�4��4202�54�54�,)7����� xS�      ,   �   x�u��m�0@��x�,�oR�d�9*'-�T*�?H������1�>�w�R)`4O?����8�P)�^PVhX&��:�u��RE킶�*���yA��Њ��.%���
�RG�l?3Vh���]��#�2M��I�JsP��6%-q�2 ǘw��R�Wjr�s�s�?��4��y�y:iz?}�G2���M!�"�̖�6�NHp�>�.�[9�=�3����0XۘL[9ǌI��|�q���7      *   �   x�=�1nAEk���E��mG�M�(�DCcf�0h��=D�i�ҥ��ū�4��������ݾ�q�9z��@H���00Ba�m��&c�+4��8D��ݑT6)-�3��bӇ���S ��l%f�����#a�C��v�8�Z�Ii�j����'c�9����?ln��fM��K�hV��Z�IN�f�i������_a~XR      .   v  x�Ř�n+��ך�`�NU����YA6YāP�]�(��$ʁc�]�g�.K��|fx�	/m� �!��鯫�9%~���Hc�^�쾺PFu���[�U3[���Gb�d��&H����5�&Ӭ<<>v=�_�Χ�ǇXz-��Rm]K(e*�)çJُ�����Î����z���^/6p�?㪽].���ϗ]�/o/�˩�W�;x���_���}�-8��������B�ى�?H��T�zk^�
���0�SՅ��j��z�5��R�u�r�Z�t43h�
Z�K���f}R��й���w?��Ŧ9�,�Քb���P"{
�kXo-�� ��1R1�.(6X���D�F�R� 4U������U���f&�&7p7"J\(�K��؛)��!D:D��,(���~	�Ē�Hr���W�=�7lz���A�P�b��\iMv�x��}K�J�^o+A&?B�Zt��1���A(7V�79��6�a��6,��z,=QZ�,9S�٬� V�V-�]ȺVBi莩�U�B�*S(刂�(�i��8}�ZG����>��R�[�%mj�FB��4
�M�L'��/uc�P-�0�8O$<Z��9\�C�s���
�tZ��RΒ,��c'1g_������J��[�%o��Z9z�9�a�U��$h���=mx��3�FAF5׺�Cç���������ɩy)!I�8,�	m�!ڽ!䃯������r��E
�����Ex.tՄ9�j�v7"�z�h��vC}�J����(�߁��hŇ@\}ah=�~���\�N,K�B-u�bM�d�������'�A(G8a�ex�b�H�؜Y��Io!�⭅��9 ,h���fb¯;C�~���<m���t
�r�h��0�J�p�c�[�Ů5C�U�J���4�k�F����U2�-����^|���C�Ҫ�MK?S(����D�lÐ�6�L�^�]br���L{/�[1X��B��#
��eg>%����n���q�d�� �B�=�J]��V��a�i|�i�慯��rA��:�;Mɕ�"�t�јk����~s���j�%�HZz̵���f'�Y�_2 l+>����/#"l{��?��<�R��UZ;�xW'W�s�0 /���n�@�{���j�u�'k��@�#��J �׹�/�iw��c�@a�SG�K�5�8������a�M��8Kא �`W��k���i�^&�#�6����s�	���ڽ2� ӊ!$�a_c�{C5$� �S2�G�������Z;�#	�u��SzK<`;�������N���	J�vB\�'β`�D�	p�

Zc��'�B�$�t�~-4���(�0da��i���D`����5*���bC��h�P����1.hZ}�G�:a�B�=�4VO�A�b��B�'B��na��I#'��P��d4z#�z�7�r`�G.e�3煯���ӳ��ؓ"0G^L��:av��S?��&�
\�J�G�3�d�V���Ԁ�7���uP�W(_#�51"��	U:D^'�&א�!7���+ ���N�aMY��ᐘC�z�{#\10'��@]�{�`Sn@��y*/`(f��p��pk��1��-7<�%Іk3S����Šm�����!�)���c�;b�;�Ɂ�Jȴ��"�`�at�t˶B�Q�pC���p|������Q����r�������gܥ�n���'9��x��㮿��r�Ηu�����/����ߟ_��o��t�ˋ����ӏ��h��<���ܟ~��	W��C;޹��e��k���/�����N���7O��<=��h�W������i������@�(ne��ք�9Ih~�I?�xR�}z;��|�:�'������eY~*x-�      )      x������ � �     