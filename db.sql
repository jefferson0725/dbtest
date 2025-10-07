--
-- PostgreSQL database dump
--

-- Dumped from database version 16.10 (Homebrew)
-- Dumped by pg_dump version 17.5

-- Started on 2025-10-07 10:28:34 -05

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 5 (class 2615 OID 16390)
-- Name: postgraphile_watch; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA postgraphile_watch;


ALTER SCHEMA postgraphile_watch OWNER TO postgres;

--
-- TOC entry 233 (class 1255 OID 16391)
-- Name: notify_watchers_ddl(); Type: FUNCTION; Schema: postgraphile_watch; Owner: postgres
--

CREATE FUNCTION postgraphile_watch.notify_watchers_ddl() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
begin
  perform pg_notify(
    'postgraphile_watch',
    json_build_object(
      'type',
      'ddl',
      'payload',
      (select json_agg(json_build_object('schema', schema_name, 'command', command_tag)) from pg_event_trigger_ddl_commands() as x)
    )::text
  );
end;
$$;


ALTER FUNCTION postgraphile_watch.notify_watchers_ddl() OWNER TO postgres;

--
-- TOC entry 234 (class 1255 OID 16392)
-- Name: notify_watchers_drop(); Type: FUNCTION; Schema: postgraphile_watch; Owner: postgres
--

CREATE FUNCTION postgraphile_watch.notify_watchers_drop() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
begin
  perform pg_notify(
    'postgraphile_watch',
    json_build_object(
      'type',
      'drop',
      'payload',
      (select json_agg(distinct x.schema_name) from pg_event_trigger_dropped_objects() as x)
    )::text
  );
end;
$$;


ALTER FUNCTION postgraphile_watch.notify_watchers_drop() OWNER TO postgres;

--
-- TOC entry 235 (class 1255 OID 16393)
-- Name: set_updated_at(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.set_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.actualizado_en = NOW();
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.set_updated_at() OWNER TO postgres;

--
-- TOC entry 236 (class 1255 OID 16394)
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_updated_at_column() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 216 (class 1259 OID 16395)
-- Name: categorys_questions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categorys_questions (
    id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    status boolean DEFAULT false NOT NULL,
    form_type_id integer
);


ALTER TABLE public.categorys_questions OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16399)
-- Name: categorias_preguntas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.categorias_preguntas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.categorias_preguntas_id_seq OWNER TO postgres;

--
-- TOC entry 3910 (class 0 OID 0)
-- Dependencies: 217
-- Name: categorias_preguntas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.categorias_preguntas_id_seq OWNED BY public.categorys_questions.id;


--
-- TOC entry 218 (class 1259 OID 16400)
-- Name: drivers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.drivers (
    id integer NOT NULL,
    nombre character varying(150) NOT NULL,
    estado boolean DEFAULT true
);


ALTER TABLE public.drivers OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16404)
-- Name: conductores_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.conductores_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.conductores_id_seq OWNER TO postgres;

--
-- TOC entry 3911 (class 0 OID 0)
-- Dependencies: 219
-- Name: conductores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.conductores_id_seq OWNED BY public.drivers.id;


--
-- TOC entry 232 (class 1259 OID 17614)
-- Name: empleados_remote; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.empleados_remote (
    id integer NOT NULL,
    nombre character varying(255),
    apellido character varying(255),
    cedula bigint,
    fecha_nacimiento timestamp without time zone,
    estado character varying(255)
);


ALTER TABLE public.empleados_remote OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16405)
-- Name: tipo_formulario_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tipo_formulario_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tipo_formulario_id_seq OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16406)
-- Name: form_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.form_type (
    id integer DEFAULT nextval('public.tipo_formulario_id_seq'::regclass) NOT NULL,
    nombre character varying(150) NOT NULL,
    estado boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.form_type OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16413)
-- Name: formularios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.formularios (
    id integer NOT NULL,
    conductor character varying(150) NOT NULL,
    placa character varying(150) NOT NULL,
    fechainicio date NOT NULL,
    horainicio time without time zone NOT NULL,
    kminicio integer NOT NULL,
    cx6 character varying(150) NOT NULL,
    cx7 character varying(150) NOT NULL,
    cx8 character varying(150) NOT NULL,
    cx48 character varying,
    cx49 character varying,
    cx50 character varying,
    cx51 character varying,
    cx52 character varying,
    status boolean DEFAULT true NOT NULL
);


ALTER TABLE public.formularios OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16419)
-- Name: formularios_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.formularios_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.formularios_id_seq OWNER TO postgres;

--
-- TOC entry 3912 (class 0 OID 0)
-- Dependencies: 223
-- Name: formularios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.formularios_id_seq OWNED BY public.formularios.id;


--
-- TOC entry 224 (class 1259 OID 16420)
-- Name: questions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.questions (
    id integer NOT NULL,
    categoria_id integer NOT NULL,
    texto text NOT NULL,
    cod character varying
);


ALTER TABLE public.questions OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16425)
-- Name: preguntas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.preguntas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.preguntas_id_seq OWNER TO postgres;

--
-- TOC entry 3913 (class 0 OID 0)
-- Dependencies: 225
-- Name: preguntas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.preguntas_id_seq OWNED BY public.questions.id;


--
-- TOC entry 226 (class 1259 OID 16426)
-- Name: respuestas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.respuestas (
    id bigint NOT NULL,
    formulario_id bigint NOT NULL,
    pregunta_id integer NOT NULL,
    valor character varying(5) NOT NULL,
    CONSTRAINT respuestas_valor_check CHECK (((valor)::text = ANY (ARRAY[('C'::character varying)::text, ('NC'::character varying)::text, ('NA'::character varying)::text])))
);


ALTER TABLE public.respuestas OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16430)
-- Name: respuestas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.respuestas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.respuestas_id_seq OWNER TO postgres;

--
-- TOC entry 3914 (class 0 OID 0)
-- Dependencies: 227
-- Name: respuestas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.respuestas_id_seq OWNED BY public.respuestas.id;


--
-- TOC entry 228 (class 1259 OID 16431)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    username character varying NOT NULL,
    password character varying NOT NULL,
    rol character varying,
    estado boolean DEFAULT true
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 16439)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- TOC entry 3915 (class 0 OID 0)
-- Dependencies: 229
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- TOC entry 230 (class 1259 OID 16440)
-- Name: vehicles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vehicles (
    id integer NOT NULL,
    item integer,
    tipo_vehiculo character varying(50),
    placa character varying(20) NOT NULL,
    proyecto_sede character varying(100),
    numero_vin character varying(50),
    numero_motor character varying(50),
    codigo character varying(10),
    fecha_fabricacion date,
    kilometraje bigint,
    proveedor character varying(100),
    empresa_contratista character varying(100),
    fecha_vigencia_soat date,
    estado_soat character varying(50),
    fecha_vigencia_rtm date,
    estado_rtm character varying(50),
    poliza_responsabilidad_civil date,
    estado_poliza character varying(50),
    tarjeta_operacion character varying(50),
    estado_tarjeta_operacion character varying(50),
    especificaciones_tecnicas text,
    incluido_plan_mantenimiento boolean,
    cumple_plan_mantenimiento boolean,
    estimado_km_mes integer,
    estado boolean DEFAULT true,
    creado_en timestamp without time zone DEFAULT now(),
    actualizado_en timestamp without time zone DEFAULT now()
);


ALTER TABLE public.vehicles OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 16448)
-- Name: vehicles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.vehicles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.vehicles_id_seq OWNER TO postgres;

--
-- TOC entry 3916 (class 0 OID 0)
-- Dependencies: 231
-- Name: vehicles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.vehicles_id_seq OWNED BY public.vehicles.id;


--
-- TOC entry 3694 (class 2604 OID 16449)
-- Name: categorys_questions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categorys_questions ALTER COLUMN id SET DEFAULT nextval('public.categorias_preguntas_id_seq'::regclass);


--
-- TOC entry 3696 (class 2604 OID 16450)
-- Name: drivers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.drivers ALTER COLUMN id SET DEFAULT nextval('public.conductores_id_seq'::regclass);


--
-- TOC entry 3702 (class 2604 OID 16451)
-- Name: formularios id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.formularios ALTER COLUMN id SET DEFAULT nextval('public.formularios_id_seq'::regclass);


--
-- TOC entry 3704 (class 2604 OID 16452)
-- Name: questions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questions ALTER COLUMN id SET DEFAULT nextval('public.preguntas_id_seq'::regclass);


--
-- TOC entry 3705 (class 2604 OID 16453)
-- Name: respuestas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.respuestas ALTER COLUMN id SET DEFAULT nextval('public.respuestas_id_seq'::regclass);


--
-- TOC entry 3706 (class 2604 OID 16454)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 3710 (class 2604 OID 16455)
-- Name: vehicles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vehicles ALTER COLUMN id SET DEFAULT nextval('public.vehicles_id_seq'::regclass);


--
-- TOC entry 3887 (class 0 OID 16395)
-- Dependencies: 216
-- Data for Name: categorys_questions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.categorys_questions (id, nombre, status, form_type_id) FROM stdin;
3	Inspección de la carrocería	t	1
4	Antes de encender el motor	t	1
5	Botiquín y herramientas	t	1
6	Vehículo encendido	f	1
2	Cumplimiento	f	1
1	Documentos	t	1
\.


--
-- TOC entry 3889 (class 0 OID 16400)
-- Dependencies: 218
-- Data for Name: drivers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.drivers (id, nombre, estado) FROM stdin;
1	el sani	t
2	San	t
3	Sant	t
4	Santiago1	t
5	Santigo20	t
\.


--
-- TOC entry 3903 (class 0 OID 17614)
-- Dependencies: 232
-- Data for Name: empleados_remote; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.empleados_remote (id, nombre, apellido, cedula, fecha_nacimiento, estado) FROM stdin;
3	Patricia	Fuertes	2311595691	1995-09-12 05:00:00	activo
4	Porfirio	Collado	2189419893	2006-09-16 05:00:00	activo
5	Candelaria	Amores	171042648	1995-09-09 05:00:00	activo
6	Marc	Bou	6167461338	2007-02-16 05:00:00	activo
7	Ramona	Julián	310026767	1995-01-10 05:00:00	activo
8	Quique	Diego	8989544025	1983-12-15 05:00:00	activo
9	María Pilar	Gisbert	1833296038	1995-12-29 05:00:00	activo
10	Camila	Valverde	9558738649	1982-03-08 05:00:00	activo
11	Fanny	Gisbert	4080378921	2001-06-24 05:00:00	activo
12	Obdulia	Ferrero	1713729684	1976-01-16 05:00:00	activo
13	Olimpia	Pérez	4202983756	1975-03-07 05:00:00	activo
14	Heraclio	Villaverde	8800005680	1993-04-14 05:00:00	activo
15	Pelayo	Andres	3697093963	1961-08-26 05:00:00	activo
16	Morena	Losa	5548829718	1991-11-20 05:00:00	activo
17	Juan Antonio	Ferrer	9219505444	2006-11-16 05:00:00	activo
18	Elodia	Ocaña	9105848384	1990-03-08 05:00:00	activo
19	Nuria	Olmedo	9924853944	1984-07-25 05:00:00	activo
20	Cecilio	Giménez	786213899	1966-09-14 05:00:00	activo
21	Javi	Soriano	2754112455	1973-02-19 05:00:00	activo
22	Nicolás	Fuente	1609435267	1992-08-05 04:00:00	activo
23	Etelvina	Abellán	8869611191	1992-05-18 04:00:00	activo
24	Virginia	Núñez	8855919668	2003-07-08 05:00:00	activo
25	Cesar	Carretero	5189553247	1986-03-11 05:00:00	activo
26	Micaela	Flores	5654219119	1992-04-12 05:00:00	activo
27	Tamara	Escalona	6251379376	1989-04-12 05:00:00	activo
28	Montserrat	Márquez	1297489453	1965-08-27 05:00:00	activo
29	Nicolasa	Priego	3421833895	1991-04-08 05:00:00	activo
30	Samu	Blazquez	1058386555	1970-07-24 05:00:00	activo
31	Francisco	Castejón	6772098351	1961-08-16 05:00:00	activo
32	Eutropio	Solana	6560669089	2004-05-19 05:00:00	activo
33	Esteban	Sánchez	8063654215	2004-06-23 05:00:00	activo
34	Pancho	Costa	7437910944	1997-02-01 05:00:00	activo
35	Carlota	Castro	9836617864	1961-03-16 05:00:00	activo
36	Alberto	Calderon	4219818936	1995-08-02 05:00:00	activo
37	Maribel	Chaparro	9107023248	1989-04-09 05:00:00	activo
38	Salomé	Ferreras	1805823848	1974-02-10 05:00:00	activo
39	Amaro	Infante	7556862847	1974-03-25 05:00:00	activo
40	Luís	Vallejo	6405047810	1976-02-13 05:00:00	activo
41	María Cristina	Moreno	2879965264	1977-05-26 05:00:00	activo
42	Candelas	Rius	5652502604	1968-09-01 05:00:00	activo
43	Benjamín	Otero	7291238159	1990-12-05 05:00:00	activo
44	Gloria	Villanueva	6857766477	1988-05-16 05:00:00	activo
45	Pascuala	Valls	1969386986	1968-08-25 05:00:00	activo
46	Bernardita	Cordero	3617634174	1995-05-17 05:00:00	activo
47	Arcelia	Alfonso	8362341718	1989-09-13 05:00:00	activo
48	Maxi	Español	2862512026	2001-02-28 05:00:00	activo
49	Adalberto	Conde	8860507787	1971-06-24 05:00:00	activo
50	Epifanio	Sáenz	7317852598	2001-11-17 05:00:00	activo
51	Luciana	Carreño	7835107365	1997-08-14 05:00:00	activo
52	Bernabé	Moreno	9822263087	2006-03-08 05:00:00	activo
53	Aura	Tolosa	7176808862	1966-12-21 05:00:00	activo
54	Sol	Barberá	6287933458	1976-08-29 05:00:00	activo
55	Graciano	Lluch	9321696870	1962-08-15 05:00:00	activo
56	María Pilar	Cabañas	4807889912	1994-04-20 05:00:00	activo
57	Víctor	Anaya	263207296	1964-01-24 05:00:00	activo
58	Venceslás	Morell	7604502849	2001-06-07 05:00:00	activo
59	Anselma	Vigil	9155446607	1973-04-27 05:00:00	activo
60	Jimena	Lluch	5368464899	1990-07-14 05:00:00	activo
61	Apolonia	Tejera	8047696176	1994-04-21 05:00:00	activo
62	Jose Miguel	Zabala	356094055	1977-06-01 05:00:00	activo
63	Ágata	Francisco	6234212482	1990-03-16 05:00:00	activo
64	Emigdio	Riera	6664793745	1968-01-10 05:00:00	activo
65	Ruben	Salamanca	3804104665	1981-04-02 05:00:00	activo
66	Camilo	Hernandez	7823747417	1988-11-24 05:00:00	activo
67	Camilo	Garcia	9795743949	2005-04-22 05:00:00	activo
68	Marcio	Carvajal	8102546565	1970-04-05 05:00:00	activo
69	Lilia	Paz	4123424221	1969-06-24 05:00:00	activo
70	José Luis	Cervantes	658200381	1991-07-31 05:00:00	activo
71	Isidoro	Burgos	766849392	1986-11-07 05:00:00	activo
72	Sonia	Torrens	9596181750	1970-10-30 05:00:00	activo
73	Guadalupe	Goicoechea	1012170858	1970-09-27 05:00:00	activo
74	Lara	Rosado	2540266207	1994-11-02 05:00:00	activo
75	Sancho	Nicolau	5433455429	1988-06-01 05:00:00	activo
76	Gustavo	Palacios	27581913	1981-06-04 05:00:00	activo
77	Cirino	Paz	6737384337	1961-01-28 05:00:00	activo
78	Nilo	Segarra	4103524416	1989-09-21 05:00:00	activo
79	Juliana	Alfaro	4536864997	1985-11-26 05:00:00	activo
80	Natanael	Villar	5990221859	2002-03-17 05:00:00	activo
81	Manolo	Vila	6018568324	1964-02-15 05:00:00	activo
82	Daniel	Granados	4749655724	1966-11-18 05:00:00	activo
83	Cesar	Lara	7029220235	1978-04-03 05:00:00	activo
84	Aníbal	Escudero	277352360	1978-02-25 05:00:00	activo
85	Marisol	Castilla	5201598346	1988-06-26 05:00:00	activo
86	Reina	Jordán	707086885	1987-05-17 05:00:00	activo
87	Eustaquio	Villa	235810525	1998-07-31 05:00:00	activo
88	Ana Belén	Morillo	8600936520	1965-11-02 05:00:00	activo
89	León	Barceló	9249612543	2006-08-01 05:00:00	activo
90	Gervasio	Roig	119525498	1964-09-04 05:00:00	activo
91	Julio César	Alegria	3765228983	2002-12-04 05:00:00	activo
92	Chus	Juliá	6942373532	1965-06-13 05:00:00	activo
93	Ema	Girón	9237954077	1964-04-13 05:00:00	activo
94	Juan Luis	Carro	5869037352	1990-08-18 05:00:00	activo
95	Aitor	Nicolau	537603371	1997-05-21 05:00:00	activo
96	Silvestre	Leal	7951123622	2002-01-21 05:00:00	activo
97	Efraín	Aroca	6306376791	1995-08-10 05:00:00	activo
98	Leire	Gómez	6383021323	1967-03-14 05:00:00	activo
99	Felix	Juárez	378871838	1963-03-07 05:00:00	activo
100	Gerardo	Franch	9038827059	1980-12-24 05:00:00	activo
101	Jefferson	martinez	1143169595	1999-07-25 05:00:00	activo
\.


--
-- TOC entry 3892 (class 0 OID 16406)
-- Dependencies: 221
-- Data for Name: form_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.form_type (id, nombre, estado, created_at, updated_at) FROM stdin;
1	Preoperacional	t	2025-09-29 13:39:34.867173	2025-09-29 13:39:34.867173
\.


--
-- TOC entry 3893 (class 0 OID 16413)
-- Dependencies: 222
-- Data for Name: formularios; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.formularios (id, conductor, placa, fechainicio, horainicio, kminicio, cx6, cx7, cx8, cx48, cx49, cx50, cx51, cx52, status) FROM stdin;
7	Asd	123	2025-09-25	09:50:00	9000	C	C	C	\N	\N	\N	\N	\N	f
8	1234	1234	4567-03-12	12:34:00	1234	NC	NC	NC	\N	\N	\N	\N	\N	f
9	SDA	SDA	2025-09-25	10:53:00	1	C	C	C	NA	NA	NA	NA	NA	f
10	22222222	2222222	2222-02-22	22:22:00	2222	C	C	C	NA	NA	NA	NA	NA	f
11	1	11	1111-11-11	11:11:00	1	C	C	C	C	C	C	C	C	f
19	Formulario1	Formulario1	2025-09-25	14:57:00	1	NA	NC	C	NC	NC	C	NA	NC	f
20	Formulario2	Formulario2	2025-09-04	14:02:00	1	C	C	C	NA	NA	NA	NA	NC	f
21	Gasd	Gsd	3333-03-21	09:17:00	10	NA	C	NC	NA	NA	NC	NA	NC	f
22	Games	Games	2025-09-10	09:45:00	1231	C	NC	C	C	NC	NA	C	NC	f
23	YUYU	YUYU	2025-09-26	09:56:00	1	NC	C	NA	C	NC	NA	NC	C	f
24	sad123	asd	2025-09-26	10:07:00	12312	NA	NC	C	C	C	NA	C	NC	f
25	dasd	asdas	2025-09-26	10:22:00	12312	C	C	C	C	C	C	C	C	f
26	NewConductor	MDS-123	2025-09-26	10:41:00	123213123	C	NC	NA	NC	NC	C	NC	NA	f
27	nuevo conductor	123456	0123-03-12	12:13:00	123213	NC	NC	NA	C	C	NC	C	C	f
28	jefferson	111	1111-11-11	11:11:00	1111	C	C	C	C	C	C	C	C	f
29	Pedro Pérez	XYZ123	2025-09-30	08:00:00	1200	OK	OK	OK	OK	OK	OK	OK	OK	f
30	Fernando Pérez	XYZ123	2025-09-30	08:00:00	1200	OK	OK	OK	OK	OK	OK	OK	OK	f
31	carlos perez	333333	0111-11-11	11:11:00	1111	C	C	C	C	C	C	C	C	f
32	ñã	22222	1111-11-11	11:11:00	11111	NC	NC	C	C	C	C	C	C	f
54	aa	222	22222-02-22	14:22:00	2	C	C	C	C	C	C	C	C	f
55	Jhonaa	222	0022-02-22	14:22:00	22	C	C	C	C	C	C	C	C	f
56	aaa	111	2332-02-11	14:33:00	22	C	C	C	C	C	C	C	C	f
57	sa	233	3333-03-31	14:22:00	2	C	C	C	C	C	C	C	C	f
58	calito	222	2222-02-22	14:22:00	2	C	C	C	C	C	C	C	C	f
63	q	222	0022-02-22	14:22:00	22	C	C	C	C	C	C	C	C	t
64	333	333	3333-03-31	15:33:00	3	C	C	C	C	C	C	C	C	f
\.


--
-- TOC entry 3895 (class 0 OID 16420)
-- Dependencies: 224
-- Data for Name: questions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.questions (id, categoria_id, texto, cod) FROM stdin;
2	1	SOAT	cx2
3	1	Tecno Mecánica	cx3
4	1	Tarjeta/Chip suministro combustible	cx4
5	1	Tag Flypass	cx5
6	2	Licencia de conducción vigente para el tipo de vehículo	cx6
7	2	Conductor autorizado por la Empresa	cx7
8	2	Se verificó el estado de las vías, restricciones vehículares y cobertura del telepeaje	cx8
9	3	Cadena eje cardan disponible y en buen estado	cx9
10	3	Barra antivuelco	cx10
11	3	Vidrios panorámico y laterales	cx11
12	3	Espejos retrovisores	cx12
13	3	Puertas / Compuertas	cx13
14	3	Tapa de combustible	cx14
15	3	Desgaste de llantas (Presión, nivel de desgaste)	cx15
16	3	Rines sin grietas y espárragos completos	cx16
17	3	Cinta reflectivas	cx17
18	3	Banderín, emblemas y logos	cx18
19	3	Indicadores de tuerca y/o tuercas ajustadas	cx19
20	4	Aseo cabina	cx20
21	4	Testigos apagados (Aceite, motor, airbags)	cx21
22	4	Velocímetro	cx22
23	4	Sillas / Apoyacabezas	cx23
24	4	Cinturón de seguridad	cx24
25	4	Limpia parabrisas en buen estado	cx25
26	4	Radio de comunicación (Aplica para las minas)	cx26
27	4	Pedales de control (Acelerador/Freno/Embrague)	cx27
28	4	Pito funcionando	cx28
29	4	Luces traseras, delanteras y de reversa	cx29
30	4	Luces direccionales operativas	cx30
31	4	Bombillo buggy y baliza (Luz estroboscópica)	cx31
32	4	Alarma de retroceso	cx32
33	4	Nivel de aceite motor en límites permisibles	cx33
34	4	Nivel de aceite hidráulico en límites permisibles	cx34
35	4	Nivel de líquido refrigerante en límites permisibles	cx35
36	4	Nivel de líquido de frenos en límites permitidos	cx36
37	4	Batería y bornes ajustados	cx37
38	4	Correas tensionadas, alineadas y sin desgaste	cx38
39	4	Líneas libres de fugas o derrames	cx39
40	4	Amortiguadores sin grietas o fugas y sin piezas faltantes	cx40
41	4	Freno de parqueo operativo	cx41
42	5	Botiquín con: antisépticos, un elemento de corte, algodón, gasa estéril, esparadrapo o vendas adhesivas, venda elástica, jabón	cx42
43	5	Extintor PQS ABC	cx43
44	5	Tacos de bloqueo (2) / Conos de seguridad (2)	cx44
45	5	Extensión llata de repuesto y llanta de repuesto	cx45
46	5	Herramientas: Gato / Destornillador de pala / Destornillador de estría / Llave expansiva / Llave de perno / Llaves / Alicate / Cable de corriente	cx46
47	5	Linterna	cx47
48	6	Nivel de combustible suficiente para el trayecto	cx48
49	6	Sistema de tracción 4x4	cx49
50	6	Freno de pedal en buen funcionamiento	cx50
51	6	Dirección (Vibración y rigidez)	cx51
52	6	Aire acondicionado	cx52
100	1	Licencia	cx53
101	1	Tarjeta	cx54
1	1	Tarjeta de propiedad	cx1
\.


--
-- TOC entry 3897 (class 0 OID 16426)
-- Dependencies: 226
-- Data for Name: respuestas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.respuestas (id, formulario_id, pregunta_id, valor) FROM stdin;
\.


--
-- TOC entry 3899 (class 0 OID 16431)
-- Dependencies: 228
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, created_at, updated_at, username, password, rol, estado) FROM stdin;
2	2025-09-22 09:00:38.371477	2025-09-22 09:00:38.371477	nuevo_nombre	$2b$10$XsYroC6PchOl5/gIG5d5YuOFH0u6UQlMZ.3PJ6rI7bhc0zGrcCtYW	ADMIN	f
7	2025-10-01 15:27:36.150547	2025-10-01 15:27:36.150547	jeff3	$2b$10$FibOQO7cmFM4B80z0OWcv.JDpkOVTiwaVMmbAG3mN6/C4pKzqZhfa	CONDUCTOR	f
6	2025-10-01 15:24:38.347645	2025-10-01 15:24:38.347645	jefferson	$2b$10$/u.P86MnC.xcZa0oq3qd0OwjA.ysLyfXLS7GMdCi3pT.YHOxQiShK	ADMIN	f
8	2025-10-02 14:24:34.614008	2025-10-02 14:24:34.614008	je	$2b$10$ib335PeX1KrZdWXlRvIKh.n87WmzEtzzqdiCC.oucQiYrwys/zLkm	CONDUCTOR	t
3	2025-09-22 09:00:38.371477	2025-09-22 09:00:38.371477	Santiago3	123	supervisor	t
9	2025-10-07 08:58:48.867571	2025-10-07 08:58:48.867571	Jhon	$2b$10$1F1SVuPdAhXkG3xEcCPJAeJQadviGwrytSQo.Acc/oHNx/Fpl8X4G	CONDUCTOR	f
\.


--
-- TOC entry 3901 (class 0 OID 16440)
-- Dependencies: 230
-- Data for Name: vehicles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vehicles (id, item, tipo_vehiculo, placa, proyecto_sede, numero_vin, numero_motor, codigo, fecha_fabricacion, kilometraje, proveedor, empresa_contratista, fecha_vigencia_soat, estado_soat, fecha_vigencia_rtm, estado_rtm, poliza_responsabilidad_civil, estado_poliza, tarjeta_operacion, estado_tarjeta_operacion, especificaciones_tecnicas, incluido_plan_mantenimiento, cumple_plan_mantenimiento, estimado_km_mes, estado, creado_en, actualizado_en) FROM stdin;
\.


--
-- TOC entry 3917 (class 0 OID 0)
-- Dependencies: 217
-- Name: categorias_preguntas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.categorias_preguntas_id_seq', 6, true);


--
-- TOC entry 3918 (class 0 OID 0)
-- Dependencies: 219
-- Name: conductores_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.conductores_id_seq', 5, true);


--
-- TOC entry 3919 (class 0 OID 0)
-- Dependencies: 223
-- Name: formularios_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.formularios_id_seq', 64, true);


--
-- TOC entry 3920 (class 0 OID 0)
-- Dependencies: 225
-- Name: preguntas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.preguntas_id_seq', 52, true);


--
-- TOC entry 3921 (class 0 OID 0)
-- Dependencies: 227
-- Name: respuestas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.respuestas_id_seq', 1, false);


--
-- TOC entry 3922 (class 0 OID 0)
-- Dependencies: 220
-- Name: tipo_formulario_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tipo_formulario_id_seq', 1, true);


--
-- TOC entry 3923 (class 0 OID 0)
-- Dependencies: 229
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 9, true);


--
-- TOC entry 3924 (class 0 OID 0)
-- Dependencies: 231
-- Name: vehicles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.vehicles_id_seq', 1, false);


--
-- TOC entry 3738 (class 2606 OID 17620)
-- Name: empleados_remote PK_ebb81a4cc1aa181d95bb43504c2; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.empleados_remote
    ADD CONSTRAINT "PK_ebb81a4cc1aa181d95bb43504c2" PRIMARY KEY (id);


--
-- TOC entry 3716 (class 2606 OID 16457)
-- Name: categorys_questions categorias_preguntas_nombre_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categorys_questions
    ADD CONSTRAINT categorias_preguntas_nombre_key UNIQUE (nombre);


--
-- TOC entry 3718 (class 2606 OID 16459)
-- Name: categorys_questions categorias_preguntas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categorys_questions
    ADD CONSTRAINT categorias_preguntas_pkey PRIMARY KEY (id);


--
-- TOC entry 3720 (class 2606 OID 16461)
-- Name: drivers conductores_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.drivers
    ADD CONSTRAINT conductores_pkey PRIMARY KEY (id);


--
-- TOC entry 3726 (class 2606 OID 16463)
-- Name: formularios formularios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.formularios
    ADD CONSTRAINT formularios_pkey PRIMARY KEY (id);


--
-- TOC entry 3728 (class 2606 OID 16465)
-- Name: questions preguntas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT preguntas_pkey PRIMARY KEY (id);


--
-- TOC entry 3730 (class 2606 OID 16467)
-- Name: respuestas respuestas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.respuestas
    ADD CONSTRAINT respuestas_pkey PRIMARY KEY (id);


--
-- TOC entry 3722 (class 2606 OID 16469)
-- Name: form_type tipo_formulario_nombre_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.form_type
    ADD CONSTRAINT tipo_formulario_nombre_key UNIQUE (nombre);


--
-- TOC entry 3724 (class 2606 OID 16471)
-- Name: form_type tipo_formulario_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.form_type
    ADD CONSTRAINT tipo_formulario_pkey PRIMARY KEY (id);


--
-- TOC entry 3732 (class 2606 OID 16473)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 3734 (class 2606 OID 16475)
-- Name: vehicles vehicles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vehicles
    ADD CONSTRAINT vehicles_pkey PRIMARY KEY (id);


--
-- TOC entry 3736 (class 2606 OID 16477)
-- Name: vehicles vehicles_placa_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vehicles
    ADD CONSTRAINT vehicles_placa_key UNIQUE (placa);


--
-- TOC entry 3742 (class 2620 OID 16478)
-- Name: form_type set_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_updated_at BEFORE UPDATE ON public.form_type FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 3743 (class 2620 OID 16479)
-- Name: vehicles trg_update_vehicles; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_update_vehicles BEFORE UPDATE ON public.vehicles FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 3739 (class 2606 OID 16480)
-- Name: categorys_questions fk_form_type; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categorys_questions
    ADD CONSTRAINT fk_form_type FOREIGN KEY (form_type_id) REFERENCES public.form_type(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3740 (class 2606 OID 16485)
-- Name: questions preguntas_categoria_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT preguntas_categoria_id_fkey FOREIGN KEY (categoria_id) REFERENCES public.categorys_questions(id) ON DELETE CASCADE;


--
-- TOC entry 3741 (class 2606 OID 16490)
-- Name: respuestas respuestas_pregunta_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.respuestas
    ADD CONSTRAINT respuestas_pregunta_id_fkey FOREIGN KEY (pregunta_id) REFERENCES public.questions(id) ON DELETE CASCADE;


--
-- TOC entry 3909 (class 0 OID 0)
-- Dependencies: 6
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- TOC entry 3692 (class 3466 OID 16495)
-- Name: postgraphile_watch_ddl; Type: EVENT TRIGGER; Schema: -; Owner: postgres
--

CREATE EVENT TRIGGER postgraphile_watch_ddl ON ddl_command_end
         WHEN TAG IN ('ALTER AGGREGATE', 'ALTER DOMAIN', 'ALTER EXTENSION', 'ALTER FOREIGN TABLE', 'ALTER FUNCTION', 'ALTER POLICY', 'ALTER SCHEMA', 'ALTER TABLE', 'ALTER TYPE', 'ALTER VIEW', 'COMMENT', 'CREATE AGGREGATE', 'CREATE DOMAIN', 'CREATE EXTENSION', 'CREATE FOREIGN TABLE', 'CREATE FUNCTION', 'CREATE INDEX', 'CREATE POLICY', 'CREATE RULE', 'CREATE SCHEMA', 'CREATE TABLE', 'CREATE TABLE AS', 'CREATE VIEW', 'DROP AGGREGATE', 'DROP DOMAIN', 'DROP EXTENSION', 'DROP FOREIGN TABLE', 'DROP FUNCTION', 'DROP INDEX', 'DROP OWNED', 'DROP POLICY', 'DROP RULE', 'DROP SCHEMA', 'DROP TABLE', 'DROP TYPE', 'DROP VIEW', 'GRANT', 'REVOKE', 'SELECT INTO')
   EXECUTE FUNCTION postgraphile_watch.notify_watchers_ddl();


ALTER EVENT TRIGGER postgraphile_watch_ddl OWNER TO postgres;

--
-- TOC entry 3693 (class 3466 OID 16496)
-- Name: postgraphile_watch_drop; Type: EVENT TRIGGER; Schema: -; Owner: postgres
--

CREATE EVENT TRIGGER postgraphile_watch_drop ON sql_drop
   EXECUTE FUNCTION postgraphile_watch.notify_watchers_drop();


ALTER EVENT TRIGGER postgraphile_watch_drop OWNER TO postgres;

-- Completed on 2025-10-07 10:28:34 -05

--
-- PostgreSQL database dump complete
--

