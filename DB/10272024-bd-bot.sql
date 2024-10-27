PGDMP                  	    |            BdBot    17.0    17.0 1    7           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                           false            8           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                           false            9           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                           false            :           1262    16388    BdBot    DATABASE     z   CREATE DATABASE "BdBot" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Spanish_Spain.1252';
    DROP DATABASE "BdBot";
                     postgres    false            �            1255    32976    f_get_content(text, text)    FUNCTION     >  CREATE FUNCTION public.f_get_content(num text, opc text) RETURNS TABLE(tid character varying, tcontenido text, trespuestas text)
    LANGUAGE plpgsql
    AS $$

DECLARE
    PociblesOpciones TEXT;
    selectOpc TEXT;

BEGIN

	PociblesOpciones := (SELECT respuestas  FROM get_cotenido_seguimiento WHERE numero = num);
	selectOpc := (SELECT f_get_respuesta(PociblesOpciones, opc));
	UPDATE clientes SET seguimiento = selectOpc WHERE numero = num;
		
	
    RETURN QUERY 
    SELECT id,contenido, respuestas 
    FROM get_cotenido_seguimiento 
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
       public               postgres    false            �            1255    32942 0   save_or_update_contact(character varying, jsonb)    FUNCTION     �  CREATE FUNCTION public.save_or_update_contact(in_phone character varying, in_values jsonb) RETURNS void
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
       public               postgres    false            �            1255    32943 n   save_or_update_history_and_contact(character varying, character varying, text, text, character varying, jsonb)    FUNCTION     �  CREATE FUNCTION public.save_or_update_history_and_contact(in_ref character varying, in_keyword character varying, in_answer text, in_refserialize text, in_phone character varying, in_options jsonb) RETURNS void
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
       public               postgres    false            �            1259    16390    clientes    TABLE     �   CREATE TABLE public.clientes (
    idcliente integer NOT NULL,
    numero character varying(20) NOT NULL,
    ultimomsj date,
    seguimiento character varying(200),
    respuestas text NOT NULL
);
    DROP TABLE public.clientes;
       public         heap r       postgres    false            �            1259    16389    clientes_idcliente_seq    SEQUENCE     �   CREATE SEQUENCE public.clientes_idcliente_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.clientes_idcliente_seq;
       public               postgres    false    218            ;           0    0    clientes_idcliente_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.clientes_idcliente_seq OWNED BY public.clientes.idcliente;
          public               postgres    false    217            �            1259    32900    contact    TABLE     3  CREATE TABLE public.contact (
    id integer NOT NULL,
    phone character varying(255) DEFAULT NULL::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_in timestamp without time zone,
    last_interaction timestamp without time zone,
    "values" jsonb
);
    DROP TABLE public.contact;
       public         heap r       postgres    false            �            1259    32899    contact_id_seq    SEQUENCE     �   CREATE SEQUENCE public.contact_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.contact_id_seq;
       public               postgres    false    225            <           0    0    contact_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.contact_id_seq OWNED BY public.contact.id;
          public               postgres    false    224            �            1259    24634    flujo    TABLE     o   CREATE TABLE public.flujo (
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
       public       v       postgres    false    222    222    222    218    218    218    218            �            1259    32911    history    TABLE     �  CREATE TABLE public.history (
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
       public         heap r       postgres    false            �            1259    32910    history_id_seq    SEQUENCE     �   CREATE SEQUENCE public.history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.history_id_seq;
       public               postgres    false    227            =           0    0    history_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.history_id_seq OWNED BY public.history.id;
          public               postgres    false    226            �            1259    16399    infoclientes    TABLE     z   CREATE TABLE public.infoclientes (
    idcliente integer NOT NULL,
    nombre character varying(200),
    edad integer
);
     DROP TABLE public.infoclientes;
       public         heap r       postgres    false            �            1259    16398    infoclientes_idcliente_seq    SEQUENCE     �   CREATE SEQUENCE public.infoclientes_idcliente_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.infoclientes_idcliente_seq;
       public               postgres    false    220            >           0    0    infoclientes_idcliente_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE public.infoclientes_idcliente_seq OWNED BY public.infoclientes.idcliente;
          public               postgres    false    219            �            1259    32969    pociblesopciones    TABLE     >   CREATE TABLE public.pociblesopciones (
    respuestas text
);
 $   DROP TABLE public.pociblesopciones;
       public         heap r       postgres    false            �            1259    32984    v_get_cotenido_seguimiento    VIEW       CREATE VIEW public.v_get_cotenido_seguimiento AS
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
       public       v       postgres    false    218    222    218    218    222    222    218            �            1259    16517    v_is_exist_client    VIEW     �   CREATE VIEW public.v_is_exist_client AS
 SELECT c.idcliente,
    c.numero,
    c.ultimomsj,
    c.seguimiento,
    ic.nombre,
    ic.edad
   FROM (public.clientes c
     LEFT JOIN public.infoclientes ic ON ((c.idcliente = ic.idcliente)));
 $   DROP VIEW public.v_is_exist_client;
       public       v       postgres    false    218    220    220    218    218    220    218                       2604    16393    clientes idcliente    DEFAULT     x   ALTER TABLE ONLY public.clientes ALTER COLUMN idcliente SET DEFAULT nextval('public.clientes_idcliente_seq'::regclass);
 A   ALTER TABLE public.clientes ALTER COLUMN idcliente DROP DEFAULT;
       public               postgres    false    217    218    218            �           2604    32903 
   contact id    DEFAULT     h   ALTER TABLE ONLY public.contact ALTER COLUMN id SET DEFAULT nextval('public.contact_id_seq'::regclass);
 9   ALTER TABLE public.contact ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    225    224    225            �           2604    32914 
   history id    DEFAULT     h   ALTER TABLE ONLY public.history ALTER COLUMN id SET DEFAULT nextval('public.history_id_seq'::regclass);
 9   ALTER TABLE public.history ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    226    227    227            �           2604    16402    infoclientes idcliente    DEFAULT     �   ALTER TABLE ONLY public.infoclientes ALTER COLUMN idcliente SET DEFAULT nextval('public.infoclientes_idcliente_seq'::regclass);
 E   ALTER TABLE public.infoclientes ALTER COLUMN idcliente DROP DEFAULT;
       public               postgres    false    219    220    220            ,          0    16390    clientes 
   TABLE DATA           Y   COPY public.clientes (idcliente, numero, ultimomsj, seguimiento, respuestas) FROM stdin;
    public               postgres    false    218   �F       1          0    32900    contact 
   TABLE DATA           `   COPY public.contact (id, phone, created_at, updated_in, last_interaction, "values") FROM stdin;
    public               postgres    false    225   �F       /          0    24634    flujo 
   TABLE DATA           :   COPY public.flujo (id, contenido, respuestas) FROM stdin;
    public               postgres    false    222   ;I       3          0    32911    history 
   TABLE DATA           }   COPY public.history (id, ref, keyword, answer, refserialize, phone, options, created_at, updated_in, contact_id) FROM stdin;
    public               postgres    false    227   �J       .          0    16399    infoclientes 
   TABLE DATA           ?   COPY public.infoclientes (idcliente, nombre, edad) FROM stdin;
    public               postgres    false    220   �U       4          0    32969    pociblesopciones 
   TABLE DATA           6   COPY public.pociblesopciones (respuestas) FROM stdin;
    public               postgres    false    228   �U       ?           0    0    clientes_idcliente_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.clientes_idcliente_seq', 24, true);
          public               postgres    false    217            @           0    0    contact_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.contact_id_seq', 56, true);
          public               postgres    false    224            A           0    0    history_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.history_id_seq', 56, true);
          public               postgres    false    226            B           0    0    infoclientes_idcliente_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.infoclientes_idcliente_seq', 3, true);
          public               postgres    false    219            �           2606    16498    clientes clientes_numero_key 
   CONSTRAINT     Y   ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_numero_key UNIQUE (numero);
 F   ALTER TABLE ONLY public.clientes DROP CONSTRAINT clientes_numero_key;
       public                 postgres    false    218            �           2606    16395    clientes clientes_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_pkey PRIMARY KEY (idcliente);
 @   ALTER TABLE ONLY public.clientes DROP CONSTRAINT clientes_pkey;
       public                 postgres    false    218            �           2606    32909    contact contact_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.contact
    ADD CONSTRAINT contact_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.contact DROP CONSTRAINT contact_pkey;
       public                 postgres    false    225            �           2606    24640    flujo flujo_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.flujo
    ADD CONSTRAINT flujo_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.flujo DROP CONSTRAINT flujo_pkey;
       public                 postgres    false    222            �           2606    32920    history history_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.history
    ADD CONSTRAINT history_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.history DROP CONSTRAINT history_pkey;
       public                 postgres    false    227            �           2606    16404    infoclientes infoclientes_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY public.infoclientes
    ADD CONSTRAINT infoclientes_pkey PRIMARY KEY (idcliente);
 H   ALTER TABLE ONLY public.infoclientes DROP CONSTRAINT infoclientes_pkey;
       public                 postgres    false    220            �           2606    16505    clientes unique_numero 
   CONSTRAINT     S   ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT unique_numero UNIQUE (numero);
 @   ALTER TABLE ONLY public.clientes DROP CONSTRAINT unique_numero;
       public                 postgres    false    218            �           2606    32921    history history_contact_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.history
    ADD CONSTRAINT history_contact_id_fkey FOREIGN KEY (contact_id) REFERENCES public.contact(id);
 I   ALTER TABLE ONLY public.history DROP CONSTRAINT history_contact_id_fkey;
       public               postgres    false    227    4754    225            �           2606    16405 (   infoclientes infoclientes_idcliente_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.infoclientes
    ADD CONSTRAINT infoclientes_idcliente_fkey FOREIGN KEY (idcliente) REFERENCES public.clientes(idcliente) ON UPDATE CASCADE ON DELETE CASCADE;
 R   ALTER TABLE ONLY public.infoclientes DROP CONSTRAINT infoclientes_idcliente_fkey;
       public               postgres    false    220    4746    218            ,   5   x�32�4�0141276�4��4202�54�52���wL.)M�ɬJ������ �V
$      1   D  x�u�ۍ$1 �o�����A\������J��n(����$�8�ɾ0�
��$��u^�Hc���*��#��p� �B�Ih�oP��W��� �R�pZ"��a�<���7��ǮN�ZgЀ�M���ؾ:��B♜�TH:���7qԘ|&	0L�ƔN�-q��՘�9��k�v c��c��q�FjHH%�"Yy��6�����!稏�����mp�5CI��%sj�4�,$�)Tҡ&(��'�D���]�((2UA�%��w��sM�	Jr.`��5f���!�-�1�	zHV�1����0س1ˈi�����)�H�!�v>)�ɰ�Vȓ#��G����Y&��n"��7G��Zc6G��T<7GI�3g�F!���4�J6G�o)ĳ�oR�����}�!+�Q��%4�n���!�kkJsd{d�^l5��Q���rr{x���ϓ�ke�GԘ'GIf=��J'GI����밑�#��:�k�u�G��=���%=8b\" "*ŻݤK������iw���Yc�d����(I2�a!����M��줒��^����P      /   j  x��R=O�@��_aԵ��v�V�J PA $7q�U�]z�+�~bcl�>H��,��z~�~�{ʢ�����������4G(	�'v�HƔ��

��/����O�&�+ca��*�h�)��WMB"�
�4��}j����2H�o��	�zE%:�0J`�7Jb����&͸�q3jѤ��#FY�$�p������p��i�Y0ѾC��M=�ԏB�#�=4kOP�݇���y<̒�ҟ����+��d1-������la�B�mw�k��q@�N�/g٠�>eI�zͫ��ѳ�m�M/�\��_z�J2=5�Qp��d�K�ŝ��4�IgJ����V0�G͎3A���a���q�i?�      3   �
  x��[�nl�q�����V�HVif 2
�L� ��e�J�z8p�K�	Af��X�>'	���Z�AhH�%�7�jժU����Ӈ<��Hэ0�	���lZ4�O<������Ⱁ��ރLUݐ�S��F�Ӈ���}(�����ÇR�Y;W�1�>�lUHz�y��ߜ~�Mw��ܜ�_���Oϣ���	W��������e+�_.g�{�	f���k��~������
�Ϗ/��'�,���t&�a���(�uk�x��0�h8�kk��5U'9��9ii�uP��ܴ��k�F)�����@ъEJ�J�ŌC������o	�Ox]r >@�-� x�ZS��ZIN��31u%G, Hl;j"���t��9#�Nbh<g�:�+����.ʹ���r�&�B��$���o]B	;a��	5�Љ�5p[�BW�Ϯt#��>&�A /�b!�H�
8R7����jN���2Wj%=�ר�i��z}k��KfJ)�[�wl�DdȕZ�J��P[p%�	�4w �dj�h0'��]��R������`Ҥ���Ц�thϔ���|s&�,6Z��[�A���4"W�l�v��A�'n�@9�R)�B�� N����AP��Dj��A ���
1u�^[ ���t�>��-A��.�����i�;=FE��
�A��>��<=��ⰃP����QA��	�((D��@�^3�≺�Ԩ���&~RmB|�� �
��Úp���hq�� VT���)��|�N����Q��F5�����]���:*%��|�8��ؠ�"_�rV�����!�)�[�(���٩C��u�Zsv5����-����Xc�'EE��M=��{� ���/�۷�������_W�ɦK`M��m#}!��hk>@�vS�7�S_�4g�����LwV�9b�I�Em������]���O������r_�q�Z�} ,���~��_�qwn/��y��k����<?������o����������Xp������+燏��������(�ܜ�����?i����)��^�����?���-��o?����*�ĝ�;���4zܷ5�r��P�2*{(K�,#vD)��so��/ �p���*�	�����©�8$�1�zd���"�(�`&)b�N��"_�Y�� _�H��|1݈^�D>�'�So��w7
L��{�ޜN�3�$s�w�}��g���U��F�
�g7��@j�[��L�*¡��0�R�W��h'�!�i��d���
���G������t����ھȲ�*�٩�טЄ�Y<_���nd_�@�e艹�+�t*�Hl#�׎�}�����#���}�x�G�M���9���/�����oL�A��t�X����}t��8Sڥ�V��g���ӑ�'Ba���aJ���HX{nl@��L��1I�y´��y�|C|�,�K��ǎj��[B�<���-�	)J�`Id&����Tbt�h���j(�&K�im���
����k��
%TF��"��n!(��zx���O�`��9Lq�'WF�.���4�!~;ͪ���Y��$�U���(k����z�Lk�Fn}$ؽ� ��1ŷ�A���Ó�l��x�I�hؕ����
a�7�/)j����*&�y�
��lj��
��1���-h�c6W�\'3,���<iP��mh�������I|N�=�A>���Ao�\|��GNyc=��=�b���a��@�1LI��wy��z�Ȝ�|��]'����|�gۂ?��ڈ�\!�m�I���7�����i�Q�Y Yңo�F�dq�Q�����{�h��~�^c��_0%��@�r��K��bK	n�Gg%��N�2�������¹ƴϖ�pX@Ms�����g'�t��ΣՒr�\�` Q�*b��ja�2���%7�_8O�!y(׊ί��ΝUw�f��G��a��{����C�\IE?�G���z��2��8Q��~vvXH�e9[E�$,�2�+h6-�#Ԗ��H�6�<�~���3 �7|lK��]�BD[dx:�;p'�5vV'$(/�}O�{��gԕ�F�[HWI���?�nvC���8�HHUQ�X(�g���Z�@�FA��a���d/=�@����֢�h�
���l����T�4p�́Ŧ�5qg����#���#�l�Vtu=��b*r0B��p�=�&��]�VD8P�-�U�ͯ����0�&p��Ň<�(�0{u�)��)�rpБ��ޱ���|<#~��p*��E<g�o-�	�`��2�5D~=)
�]��+-���Izג� ߎ��I.�I�B���V����A��	<uMTG.�z8�
�+c2��~dZ�u�k��KD6�W��#���$n�	ؒ�9W{�C��h�Sv-되�V��Z�U��"��M����D����M��ZP/��C���]_Г�tcd��Z�?�%���3����)'��/6[Sn>���w|X��y��tY�����\�����x�O�mѣ��4g#����.�������U
�k�?�?��_ƹ=|��绁�>��`_.H^d�.(�~����)���8�|��SR�̱�qA3� �v��S����ٯ��Z2�Gp�8y�~�W�O݈\D$�3���3Z��$���	P�]����A���5����@]EYw�y�W�O��
Ѭ� _آ���.5ק��R�S��u��T�,��5�X�����([�B�
8]�O&���	�l�q��.%4�想�"�6�#��/k�Zr�xZ�_�����˶m�	3_R      .      x������ � �      4   2   x�3�*qL.)M�ɬJ4�1�*	�,��-��1�*q�K.M-.I����� 5�x     