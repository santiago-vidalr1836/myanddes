--
-- TOC entry 196 (class 1259 OID 16385)
-- Name: activity; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.activity (
    id integer NOT NULL,
    name character varying(200) NOT NULL,
    parent character varying NOT NULL,
    editable_in_web boolean,
    mandatory boolean,
    code character varying(50),
    parent_code character varying(50),
    manual boolean
);


ALTER TABLE public.activity OWNER TO postgres;

--
-- TOC entry 197 (class 1259 OID 16391)
-- Name: activity_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.activity_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.activity_id_seq OWNER TO postgres;

--
-- TOC entry 3092 (class 0 OID 0)
-- Dependencies: 197
-- Name: activity_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.activity_id_seq OWNED BY public.activity.id;


--
-- TOC entry 198 (class 1259 OID 16393)
-- Name: ceo_presentation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ceo_presentation (
    id integer NOT NULL,
    url_video character varying(200),
    url_poster character varying(200)
);


ALTER TABLE public.ceo_presentation OWNER TO postgres;

--
-- TOC entry 199 (class 1259 OID 16396)
-- Name: ceo_presentation_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ceo_presentation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ceo_presentation_id_seq OWNER TO postgres;

--
-- TOC entry 3095 (class 0 OID 0)
-- Dependencies: 199
-- Name: ceo_presentation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ceo_presentation_id_seq OWNED BY public.ceo_presentation.id;


--
-- TOC entry 200 (class 1259 OID 16398)
-- Name: elearning_content; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.elearning_content (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    image character varying(200)
);


ALTER TABLE public.elearning_content OWNER TO postgres;

--
-- TOC entry 201 (class 1259 OID 16401)
-- Name: elearning_content_card; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.elearning_content_card (
    id integer NOT NULL,
    title character varying(100),
    type character varying(20) NOT NULL,
    draft boolean,
    content character varying(10000),
    deleted boolean DEFAULT false,
    "position" integer,
    elearning_content_id bigint,
    url_video character varying(200),
    url_poster character varying(200)
);


ALTER TABLE public.elearning_content_card OWNER TO postgres;

--
-- TOC entry 202 (class 1259 OID 16408)
-- Name: elearning_content_card_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.elearning_content_card_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.elearning_content_card_id_seq OWNER TO postgres;

--
-- TOC entry 3099 (class 0 OID 0)
-- Dependencies: 202
-- Name: elearning_content_card_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.elearning_content_card_id_seq OWNED BY public.elearning_content_card.id;


--
-- TOC entry 203 (class 1259 OID 16410)
-- Name: elearning_content_card_option; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.elearning_content_card_option (
    id integer NOT NULL,
    description character varying(200) NOT NULL,
    correct boolean,
    elearning_content_card_id bigint,
    deleted boolean DEFAULT false
);


ALTER TABLE public.elearning_content_card_option OWNER TO postgres;

--
-- TOC entry 204 (class 1259 OID 16414)
-- Name: elearning_content_card_option_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.elearning_content_card_option_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.elearning_content_card_option_id_seq OWNER TO postgres;

--
-- TOC entry 3102 (class 0 OID 0)
-- Dependencies: 204
-- Name: elearning_content_card_option_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.elearning_content_card_option_id_seq OWNED BY public.elearning_content_card_option.id;


--
-- TOC entry 205 (class 1259 OID 16416)
-- Name: elearning_content_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.elearning_content_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.elearning_content_id_seq OWNER TO postgres;

--
-- TOC entry 3104 (class 0 OID 0)
-- Dependencies: 205
-- Name: elearning_content_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.elearning_content_id_seq OWNED BY public.elearning_content.id;


--
-- TOC entry 229 (class 1259 OID 16616)
-- Name: file; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.file (
    id integer NOT NULL,
    filename character varying(100),
    path character varying(500)
);


ALTER TABLE public.file OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 16614)
-- Name: file_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.file_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.file_id_seq OWNER TO postgres;

--
-- TOC entry 3106 (class 0 OID 0)
-- Dependencies: 228
-- Name: file_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.file_id_seq OWNED BY public.file.id;


--
-- TOC entry 206 (class 1259 OID 16418)
-- Name: first_day_information_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.first_day_information_item (
    id integer NOT NULL,
    title character varying(50),
    description character varying(500),
    body character varying(2000),
    add_from_services boolean,
    type character varying(50),
    icon character varying(100) NOT NULL
);


ALTER TABLE public.first_day_information_item OWNER TO postgres;

--
-- TOC entry 207 (class 1259 OID 16424)
-- Name: first_day_information_item_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.first_day_information_item_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.first_day_information_item_id_seq OWNER TO postgres;

--
-- TOC entry 3108 (class 0 OID 0)
-- Dependencies: 207
-- Name: first_day_information_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.first_day_information_item_id_seq OWNED BY public.first_day_information_item.id;


--
-- TOC entry 208 (class 1259 OID 16426)
-- Name: on_site_induction; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.on_site_induction (
    id integer NOT NULL,
    description character varying(500)
);


ALTER TABLE public.on_site_induction OWNER TO postgres;

--
-- TOC entry 209 (class 1259 OID 16429)
-- Name: on_site_induction_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.on_site_induction_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.on_site_induction_id_seq OWNER TO postgres;

--
-- TOC entry 3111 (class 0 OID 0)
-- Dependencies: 209
-- Name: on_site_induction_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.on_site_induction_id_seq OWNED BY public.on_site_induction.id;


--
-- TOC entry 210 (class 1259 OID 16431)
-- Name: process; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.process (
    id integer NOT NULL,
    user_id bigint,
    start_date timestamp with time zone,
    status integer,
    results character varying(50),
    finished boolean,
    delayed boolean,
    welcomed boolean,
    hour_onsite character(5),
    place_onsite character varying(100),
    hour_remote character(5),
    link_remote character varying(500)
);


ALTER TABLE public.process OWNER TO postgres;

--
-- TOC entry 211 (class 1259 OID 16434)
-- Name: process_activity; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.process_activity (
    id integer NOT NULL,
    activity_id bigint,
    process_id bigint,
    completed boolean,
    result double precision,
    completion_date timestamp without time zone
);


ALTER TABLE public.process_activity OWNER TO postgres;

--
-- TOC entry 212 (class 1259 OID 16437)
-- Name: process_activity_content; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.process_activity_content (
    id integer NOT NULL,
    content_id bigint,
    result integer,
    progress integer,
    process_activity_id bigint
);


ALTER TABLE public.process_activity_content OWNER TO postgres;

--
-- TOC entry 213 (class 1259 OID 16440)
-- Name: process_activity_content_card; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.process_activity_content_card (
    id integer NOT NULL,
    card_id bigint NOT NULL,
    option_id_selected bigint,
    process_activity_content_id bigint NOT NULL,
    read_date_server timestamp without time zone,
    read_date_mobile timestamp without time zone
);


ALTER TABLE public.process_activity_content_card OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 16443)
-- Name: process_activity_content_card_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.process_activity_content_card_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.process_activity_content_card_id_seq OWNER TO postgres;

--
-- TOC entry 3117 (class 0 OID 0)
-- Dependencies: 214
-- Name: process_activity_content_card_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.process_activity_content_card_id_seq OWNED BY public.process_activity_content_card.id;


--
-- TOC entry 215 (class 1259 OID 16445)
-- Name: process_activity_content_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.process_activity_content_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.process_activity_content_id_seq OWNER TO postgres;

--
-- TOC entry 3119 (class 0 OID 0)
-- Dependencies: 215
-- Name: process_activity_content_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.process_activity_content_id_seq OWNED BY public.process_activity_content.id;


--
-- TOC entry 216 (class 1259 OID 16447)
-- Name: process_activity_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.process_activity_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.process_activity_id_seq OWNER TO postgres;

--
-- TOC entry 3121 (class 0 OID 0)
-- Dependencies: 216
-- Name: process_activity_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.process_activity_id_seq OWNED BY public.process_activity.id;


--
-- TOC entry 217 (class 1259 OID 16449)
-- Name: process_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.process_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.process_id_seq OWNER TO postgres;

--
-- TOC entry 3123 (class 0 OID 0)
-- Dependencies: 217
-- Name: process_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.process_id_seq OWNED BY public.process.id;


--
-- TOC entry 218 (class 1259 OID 16451)
-- Name: remote_induction; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.remote_induction (
    id integer NOT NULL,
    description character varying(500)
);


ALTER TABLE public.remote_induction OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16454)
-- Name: remote_induction_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.remote_induction_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.remote_induction_id_seq OWNER TO postgres;

--
-- TOC entry 3126 (class 0 OID 0)
-- Dependencies: 219
-- Name: remote_induction_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.remote_induction_id_seq OWNED BY public.remote_induction.id;


--
-- TOC entry 220 (class 1259 OID 16456)
-- Name: service; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.service (
    id bigint NOT NULL,
    name character varying(255),
    description character varying(500),
    icon character varying(50) NOT NULL,
    icon_web character varying(50)
);


ALTER TABLE public.service OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16462)
-- Name: service_detail; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.service_detail (
    id integer NOT NULL,
    title character varying(200),
    description character varying(2000),
    service_id bigint,
    hidden boolean
);


ALTER TABLE public.service_detail OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16468)
-- Name: service_detail_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.service_detail_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.service_detail_id_seq OWNER TO postgres;

--
-- TOC entry 3130 (class 0 OID 0)
-- Dependencies: 222
-- Name: service_detail_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.service_detail_id_seq OWNED BY public.service_detail.id;


--
-- TOC entry 223 (class 1259 OID 16470)
-- Name: service_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.service_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.service_id_seq OWNER TO postgres;

--
-- TOC entry 3132 (class 0 OID 0)
-- Dependencies: 223
-- Name: service_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.service_id_seq OWNED BY public.service.id;


--
-- TOC entry 224 (class 1259 OID 16472)
-- Name: tool; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tool (
    id bigint NOT NULL,
    cover character varying(255),
    description character varying(255),
    link character varying(255),
    name character varying(255)
);


ALTER TABLE public.tool OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16478)
-- Name: tool_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tool_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tool_id_seq OWNER TO postgres;

--
-- TOC entry 3135 (class 0 OID 0)
-- Dependencies: 225
-- Name: tool_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tool_id_seq OWNED BY public.tool.id;


--
-- TOC entry 226 (class 1259 OID 16480)
-- Name: user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."user" (
    id integer NOT NULL,
    fullname character varying(200) NOT NULL,
    email character varying(200) NOT NULL,
    job character varying(200) NOT NULL,
    start_date timestamp without time zone,
    image character varying(200),
    hobbies character varying(200),
    roles character varying(200),
    dni character(8) NOT NULL,
    deleted boolean DEFAULT true NOT NULL,
    on_itinerary boolean DEFAULT false NOT NULL,
    boss_id bigint,
    finished_itinerary boolean,
    nickname character varying(100),
    admin boolean DEFAULT false
);


ALTER TABLE public."user" OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16488)
-- Name: user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_id_seq OWNER TO postgres;

--
-- TOC entry 3138 (class 0 OID 0)
-- Dependencies: 227
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_id_seq OWNED BY public."user".id;


--
-- TOC entry 2856 (class 2604 OID 16490)
-- Name: activity id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.activity ALTER COLUMN id SET DEFAULT nextval('public.activity_id_seq'::regclass);


--
-- TOC entry 2857 (class 2604 OID 16491)
-- Name: ceo_presentation id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ceo_presentation ALTER COLUMN id SET DEFAULT nextval('public.ceo_presentation_id_seq'::regclass);


--
-- TOC entry 2858 (class 2604 OID 16492)
-- Name: elearning_content id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.elearning_content ALTER COLUMN id SET DEFAULT nextval('public.elearning_content_id_seq'::regclass);


--
-- TOC entry 2859 (class 2604 OID 16493)
-- Name: elearning_content_card id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.elearning_content_card ALTER COLUMN id SET DEFAULT nextval('public.elearning_content_card_id_seq'::regclass);


--
-- TOC entry 2861 (class 2604 OID 16494)
-- Name: elearning_content_card_option id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.elearning_content_card_option ALTER COLUMN id SET DEFAULT nextval('public.elearning_content_card_option_id_seq'::regclass);


--
-- TOC entry 2877 (class 2604 OID 16619)
-- Name: file id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.file ALTER COLUMN id SET DEFAULT nextval('public.file_id_seq'::regclass);


--
-- TOC entry 2863 (class 2604 OID 16495)
-- Name: first_day_information_item id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.first_day_information_item ALTER COLUMN id SET DEFAULT nextval('public.first_day_information_item_id_seq'::regclass);


--
-- TOC entry 2864 (class 2604 OID 16496)
-- Name: on_site_induction id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.on_site_induction ALTER COLUMN id SET DEFAULT nextval('public.on_site_induction_id_seq'::regclass);


--
-- TOC entry 2865 (class 2604 OID 16497)
-- Name: process id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.process ALTER COLUMN id SET DEFAULT nextval('public.process_id_seq'::regclass);


--
-- TOC entry 2866 (class 2604 OID 16498)
-- Name: process_activity id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.process_activity ALTER COLUMN id SET DEFAULT nextval('public.process_activity_id_seq'::regclass);


--
-- TOC entry 2867 (class 2604 OID 16499)
-- Name: process_activity_content id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.process_activity_content ALTER COLUMN id SET DEFAULT nextval('public.process_activity_content_id_seq'::regclass);


--
-- TOC entry 2868 (class 2604 OID 16500)
-- Name: process_activity_content_card id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.process_activity_content_card ALTER COLUMN id SET DEFAULT nextval('public.process_activity_content_card_id_seq'::regclass);


--
-- TOC entry 2869 (class 2604 OID 16501)
-- Name: remote_induction id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.remote_induction ALTER COLUMN id SET DEFAULT nextval('public.remote_induction_id_seq'::regclass);


--
-- TOC entry 2870 (class 2604 OID 16502)
-- Name: service id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service ALTER COLUMN id SET DEFAULT nextval('public.service_id_seq'::regclass);


--
-- TOC entry 2871 (class 2604 OID 16503)
-- Name: service_detail id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_detail ALTER COLUMN id SET DEFAULT nextval('public.service_detail_id_seq'::regclass);


--
-- TOC entry 2872 (class 2604 OID 16504)
-- Name: tool id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tool ALTER COLUMN id SET DEFAULT nextval('public.tool_id_seq'::regclass);


--
-- TOC entry 2873 (class 2604 OID 16505)
-- Name: user id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user" ALTER COLUMN id SET DEFAULT nextval('public.user_id_seq'::regclass);


--
-- TOC entry 3050 (class 0 OID 16385)
-- Dependencies: 196
-- Data for Name: activity; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.activity (id, name, parent, editable_in_web, mandatory, code, parent_code, manual) VALUES (1, 'Presentación gerente general', 'Antes', true, false, 'CEO_PRESENTATION', 'BEFORE', false);
INSERT INTO public.activity (id, name, parent, editable_in_web, mandatory, code, parent_code, manual) VALUES (2, 'Completa perfil', 'Antes', false, true, 'COMPLETE_PROFILE', 'BEFORE', false);
INSERT INTO public.activity (id, name, parent, editable_in_web, mandatory, code, parent_code, manual) VALUES (3, 'Información para tu primer día', 'Antes', true, false, 'FIRST_DAY_INFORMATION', 'BEFORE', false);
INSERT INTO public.activity (id, name, parent, editable_in_web, mandatory, code, parent_code, manual) VALUES (4, 'Conoce a tu equipo', 'Mi primer día', false, false, 'KNOW_YOUR_TEAM', 'FIRST_DAY', false);
INSERT INTO public.activity (id, name, parent, editable_in_web, mandatory, code, parent_code, manual) VALUES (5, 'Inducción presencial GT', 'Mi primer día', true, true, 'ON_SITE_INDUCTION', 'FIRST_DAY', true);
INSERT INTO public.activity (id, name, parent, editable_in_web, mandatory, code, parent_code, manual) VALUES (6, 'Inducción remota SSA', 'Mi primer día', true, true, 'REMOTE_INDUCTION', 'FIRST_DAY', true);
INSERT INTO public.activity (id, name, parent, editable_in_web, mandatory, code, parent_code, manual) VALUES (7, 'Inducción elearning', 'Mi primera semana', true, true, 'INDUCTION_ELEARNING', 'FIRST_WEEK', false);


--
-- TOC entry 3052 (class 0 OID 16393)
-- Dependencies: 198
-- Data for Name: ceo_presentation; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.ceo_presentation (id, url_video, url_poster) VALUES (1, 'https://mvcompendiotest.southcentralus.cloudapp.azure.com:8443/files/public/4/video/J9K49C7JRA1697245147388.mp4', 'https://mvcompendiotest.southcentralus.cloudapp.azure.com:8443/files/public/16/filename/fondo-tetris.jpg');


--
-- TOC entry 3054 (class 0 OID 16398)
-- Dependencies: 200
-- Data for Name: elearning_content; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.elearning_content (id, name, image) VALUES (1, '01. Valores y cultura en Anddes', 'https://storagecompendio.blob.core.windows.net/myanddes/UXXQ9GENC1717692538652/Surface@2x.png');
INSERT INTO public.elearning_content (id, name, image) VALUES (2, '02. Logistica', 'https://storagecompendio.blob.core.windows.net/myanddes/UXXQ9GENC1717692538652/Surface@2x.png');
INSERT INTO public.elearning_content (id, name, image) VALUES (3, '03. Contabilidad', 'https://storagecompendio.blob.core.windows.net/myanddes/UXXQ9GENC1717692538652/Surface@2x.png');
INSERT INTO public.elearning_content (id, name, image) VALUES (4, '04. SIG', 'https://storagecompendio.blob.core.windows.net/myanddes/UXXQ9GENC1717692538652/Surface@2x.png');


--
-- TOC entry 3055 (class 0 OID 16401)
-- Dependencies: 201
-- Data for Name: elearning_content_card; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.elearning_content_card (id, title, type, draft, content, deleted, "position", elearning_content_id, url_video, url_poster) VALUES (5, NULL, 'QUESTION', false, '¿ Maecenas a lobortis mi. Etiam leo mauris, malesuada eget facilisis ac, tincidunt sed sem. Nullam iaculis?', false, 2, 1, NULL, NULL);
INSERT INTO public.elearning_content_card (id, title, type, draft, content, deleted, "position", elearning_content_id, url_video, url_poster) VALUES (6, 'Contenido 3', 'TEXT', true, '<p>texto 3</p>', true, 0, 1, NULL, NULL);
INSERT INTO public.elearning_content_card (id, title, type, draft, content, deleted, "position", elearning_content_id, url_video, url_poster) VALUES (7, NULL, 'QUESTION', false, 'Pregunta 1', false, 3, 1, NULL, NULL);
INSERT INTO public.elearning_content_card (id, title, type, draft, content, deleted, "position", elearning_content_id, url_video, url_poster) VALUES (8, 'Prueba', 'TEXT', false, '<p>Descripcion</p><p></p>', false, 0, 2, NULL, NULL);
INSERT INTO public.elearning_content_card (id, title, type, draft, content, deleted, "position", elearning_content_id, url_video, url_poster) VALUES (9, NULL, 'QUESTION', false, 'Pregunta', false, 1, 2, NULL, NULL);
INSERT INTO public.elearning_content_card (id, title, type, draft, content, deleted, "position", elearning_content_id, url_video, url_poster) VALUES (10, 'Contabilidad', 'TEXT', false, '<p><span style="color: rgb(33, 51, 67); background-color: rgb(246, 249, 252);">La contabilidad es el proceso de registrar, analizar e interpretar de manera sistemática la información financiera de una entidad u organización. Esto se logra mediante el control de las operaciones económicas y tiene como fin establecer el balance de ingresos y egresos.</span></p><p><span style="color: rgb(33, 51, 67);">En realidad, la contabilidad forma parte de la vida económica tanto de personas como de organizaciones. Si, por ejemplo, llevas un registro de tus gastos semanales con el fin de ahorrar más, ya estás realizando un ejercicio contable. </span><strong style="color: rgb(33, 51, 67);">Lo mismo ocurre con las empresas, que pueden llevar un registro de cada una de sus operaciones para cuadrar sus gastos y ganancias.</strong><span style="color: rgb(33, 51, 67);"> Esto significa que existen diferentes modos de ejecutar la contabilidad de un agente.</span></p><p></p><h2><span style="color: rgb(33, 51, 67); background-color: rgb(255, 255, 255);">Qué es la contabilidad empresarial</span></h2><p><span style="color: rgb(33, 51, 67); background-color: rgb(246, 249, 252);">La contabilidad empresarial abarca todas las acciones que permiten a las organizaciones privadas mantener el registro y control de sus operaciones económicas. Esto tiene como objetivo que las compañías detecten ingresos y evalúen gastos con el fin de hacer rentable un negocio, definir inversiones o conocer el estado financiero de un proyecto.</span></p><p><span style="color: rgb(33, 51, 67);">Los dueños de las empresas la utilizan para rastrear las operaciones financieras, cumplir con sus obligaciones legales y tomar mejores decisiones de negocio. Pero sobre todo sirve para </span><a href="https://blog.hubspot.es/sales/analisis-costo-beneficio" rel="noopener noreferrer" target="_blank" style="color: var(--cl-anchor-color,#0068b1); background-color: transparent;">analizar la relación costo-beneficio</a><span style="color: rgb(33, 51, 67);"> y detectar buenas oportunidades de mercado y empresariales. </span></p><p><span style="color: rgb(33, 51, 67);">La tarea de esta rama de la economía consiste en cuantificar los recursos disponibles y analizar grandes volúmenes de información, a fin de establecer relaciones entre procesos, actividades comerciales y </span><a href="https://blog.hubspot.es/sales/que-es-estado-de-resultados" rel="noopener noreferrer" target="_blank" style="color: var(--cl-anchor-color,#0068b1); background-color: transparent;">estados de resultados</a><span style="color: rgb(33, 51, 67);"> o financieros.</span></p><p></p>', false, 0, 3, NULL, NULL);
INSERT INTO public.elearning_content_card (id, title, type, draft, content, deleted, "position", elearning_content_id, url_video, url_poster) VALUES (11, NULL, 'QUESTION', false, 'Por qué es importante la contabilidad', false, 1, 3, NULL, NULL);
INSERT INTO public.elearning_content_card (id, title, type, draft, content, deleted, "position", elearning_content_id, url_video, url_poster) VALUES (15, NULL, 'QUESTION', false, 'Cuantos son los principales tipos de sistemas de información', false, 1, 4, NULL, NULL);
INSERT INTO public.elearning_content_card (id, title, type, draft, content, deleted, "position", elearning_content_id, url_video, url_poster) VALUES (14, 'Los 6 principales tipos de sistemas de información', 'TEXT', false, '<h1></h1><p></p><p><img src="https://mvcompendiotest.southcentralus.cloudapp.azure.com:8443/files/public/10/filename/cq5dam.resized.img.1536.large.time1573048016666.jpg"></p><p></p><p>1. Sistemas de procesamiento de transacciones</p><p>Los sistemas de procesamiento de transacciones (TPS por sus siglas en inglés) son los sistemas empresariales básicos que sirven al nivel operacional de la organización.</p><p>Un sistema de procesamiento de transacciones es un sistema computarizado que realiza y registra las transacciones rutinarias diarias necesarias para el funcionamiento de la empresa. Se encuentran en el nivel más bajo de la jerarquía organizacional y soportan las actividades cotidianas del negocio.</p><p><strong>2. Sistemas de control de procesos de negocio</strong></p><p>Los sistemas de control de procesos de negocio (BPM por sus siglas en inglés) monitorizan y controlan los procesos industriales o físicos, como puede ser la refinación de petróleo, generación de energía o los sistemas de producción de acero en una planta siderúrgica.</p><p>Por ejemplo, en una refinería de petróleo se utilizan sensores electrónicos conectados a ordenadores para monitorizar procesos químicos continuamente y hacer ajustes en tiempo real que controlan el proceso de refinación. Un sistema de control de procesos comprende toda una gama de equipos, programas de ordenador y procedimientos de operación. </p><p></p><p><strong>3. Sistemas de colaboración empresarial</strong></p><p>Los sistemas de colaboración empresarial (ERP por sus siglas en inglés) son uno de los tipos de sistemas de información más utilizados. Ayudan a los directivos de una empresa a controlar el flujo de información en sus organizaciones.</p><p>Se trata de uno de los tipos de sistemas de información que no son específicos de un nivel concreto en la organización, sino que proporcionan un soporte importante para una amplia gama de usuarios. Estos sistemas de información están diseñados para soportar tareas de oficina como sistemas multimedia, correos electrónicos, videoconferencias y transferencias de archivos. </p><p><img src="https://www.kyoceradocumentsolutions.es/renditions/content/dam/kyocera/es/images/square/square-540x540-ebook-rpa.png/jcr%3Acontent/renditions/cq5dam.resized.img.540.medium.time1666702527891.png" alt="RPA: el punto de partida hacia la hiperautomatización" height="540" width="540"></p><h4><strong>4. Sistemas de Información de Gestión</strong></h4><p>Los sistemas de información de gestión (MIS por sus siglas en inglés) son un tipo de sistemas de información que recopilan y procesan información de diferentes fuentes para ayudar en la toma de decisiones en lo referente a la gestión de la organización.</p><p>Los sistemas de información de gestión proporcionan información en forma de informes y estadísticas. El siguiente nivel en la jerarquía organizacional está ocupado por gerentes y supervisores de bajo nivel. Este nivel contiene los sistemas informáticos que están destinados a ayudar a la gestión operativa en la supervisión y control de las actividades de procesamiento de transacciones que se producen a nivel administrativo.</p><p>Los sistemas de información de gestión utilizan los datos recogidos por el TPS para proporcionar a los supervisores los informes de control necesarios. Los sistemas de información de gestión son los tipos de sistemas de información que toman los datos internos del sistema y los resumen en formatos útiles como informes de gestión para utilizarlos como apoyo a las actividades de gestión y la toma de decisiones. </p><p><strong><a href="https://www.kyoceradocumentsolutions.es/es/content-services/soluciones-de-negocio/servicios-digitales/outsourcing.html" rel="noopener noreferrer" target="_blank">Podemos ayudarte</a></strong></p><h4><strong>5. Sistemas de apoyo a la toma de decisiones</strong></h4><p>Un sistema de apoyo a la toma de decisiones o de soporte a la decisión (DSS por sus siglas en inglés) es un sistema basado en ordenadores destinado a ser utilizado por un gerente particular o por un grupo de gerentes a cualquier nivel organizacional para tomar una decisión en el proceso de resolver una problemática semiestructurada. Los sistemas de apoyo a la toma de decisiones son un tipo de sistema computerizado de información organizacional que ayuda al gerente en la toma de decisiones cuando necesita modelar, formular, calcular, comparar, seleccionar la mejor opción o predecir los escenarios.</p><p>Los sistemas de apoyo a la toma de decisiones están específicamente diseñados para ayudar al equipo directivo a tomar decisiones en situaciones en las que existe incertidumbre sobre los posibles resultados o consecuencias. Ayuda a los gerentes a tomar decisiones complejas. </p><h4><strong>6. Sistemas de Información Ejecutiva</strong></h4><p>Los sistemas de información ejecutiva (EIS por sus siglas en inglés) proporcionan un acceso rápido a la información interna y externa, presentada a menudo en formato gráfico, pero con la capacidad de presentar datos básicos más detallados si es necesario. Los sistemas información ejecutiva proporcionan información crítica de una amplia variedad de fuentes internas y externas en formatos fáciles de usar para ejecutivos y gerentes.</p><p>Un sistema de información ejecutiva proporciona a los altos directivos un sistema para ayudar a tomar decisiones estratégicas. Está diseñado para generar información que sea lo suficientemente abstracta como para presentar toda la operación de la empresa en una versión simplificada para satisfacer a la alta dirección. </p>', false, 0, 4, NULL, NULL);
INSERT INTO public.elearning_content_card (id, title, type, draft, content, deleted, "position", elearning_content_id, url_video, url_poster) VALUES (16, NULL, 'QUESTION', false, 'Pregunta', false, 4, 1, NULL, NULL);
INSERT INTO public.elearning_content_card (id, title, type, draft, content, deleted, "position", elearning_content_id, url_video, url_poster) VALUES (4, 'Valores y cultura en Anddes', 'TEXT', true, '<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus tincidunt eros magna, ut convallis justo efficitur at. Maecenas rhoncus, metus id fringilla sodales, nisl mi bibendum purus, efficitur</p><p></p><a href="https://www.youtube.com/embed/bDmA8qQKhMY?showinfo=0">https://www.youtube.com/embed/bDmA8qQKhMY?showinfo=0</a><p></p>', false, 1, 1, NULL, NULL);
INSERT INTO public.elearning_content_card (id, title, type, draft, content, deleted, "position", elearning_content_id, url_video, url_poster) VALUES (18, 'Video 2', 'VIDEO', false, NULL, false, 6, 1, 'https://mvcompendiotest.southcentralus.cloudapp.azure.com:8443/files/public/4/video/J9K49C7JRA1697245147388.mp4', NULL);
INSERT INTO public.elearning_content_card (id, title, type, draft, content, deleted, "position", elearning_content_id, url_video, url_poster) VALUES (17, 'Video', 'VIDEO', false, NULL, false, 5, 1, 'https://mvcompendiotest.southcentralus.cloudapp.azure.com:8443/files/public/4/video/J9K49C7JRA1697245147388.mp4', 'https://mvcompendiotest.southcentralus.cloudapp.azure.com:8443/files/public/16/filename/fondo-tetris.jpg');


--
-- TOC entry 3057 (class 0 OID 16410)
-- Dependencies: 203
-- Data for Name: elearning_content_card_option; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.elearning_content_card_option (id, description, correct, elearning_content_card_id, deleted) VALUES (2, 'Opción A', false, 5, false);
INSERT INTO public.elearning_content_card_option (id, description, correct, elearning_content_card_id, deleted) VALUES (3, 'Opción B', false, 5, true);
INSERT INTO public.elearning_content_card_option (id, description, correct, elearning_content_card_id, deleted) VALUES (14, 'Opcion C', true, 5, false);
INSERT INTO public.elearning_content_card_option (id, description, correct, elearning_content_card_id, deleted) VALUES (15, 'opción 01', true, 7, false);
INSERT INTO public.elearning_content_card_option (id, description, correct, elearning_content_card_id, deleted) VALUES (16, 'opción 02', false, 7, false);
INSERT INTO public.elearning_content_card_option (id, description, correct, elearning_content_card_id, deleted) VALUES (17, 'opcion', true, 9, false);
INSERT INTO public.elearning_content_card_option (id, description, correct, elearning_content_card_id, deleted) VALUES (18, 'opcion 2', false, 9, false);
INSERT INTO public.elearning_content_card_option (id, description, correct, elearning_content_card_id, deleted) VALUES (19, 'El correcto manejo de recursos es lo primero que una empresa debe asegurar', true, 11, false);
INSERT INTO public.elearning_content_card_option (id, description, correct, elearning_content_card_id, deleted) VALUES (20, 'Iniciar un proyecto o si habrá un menor volumen de compras en un periodo determinado', false, 11, false);
INSERT INTO public.elearning_content_card_option (id, description, correct, elearning_content_card_id, deleted) VALUES (21, '5', false, 15, false);
INSERT INTO public.elearning_content_card_option (id, description, correct, elearning_content_card_id, deleted) VALUES (22, '6', true, 15, false);
INSERT INTO public.elearning_content_card_option (id, description, correct, elearning_content_card_id, deleted) VALUES (23, '4', false, 15, false);
INSERT INTO public.elearning_content_card_option (id, description, correct, elearning_content_card_id, deleted) VALUES (24, 'opción A', false, 16, false);
INSERT INTO public.elearning_content_card_option (id, description, correct, elearning_content_card_id, deleted) VALUES (25, 'opcion b', true, 16, false);


--
-- TOC entry 3083 (class 0 OID 16616)
-- Dependencies: 229
-- Data for Name: file; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.file (id, filename, path) VALUES (1, 'I4P41720566674986CaSistemas.png', '/home/compendiotest/raanddes/files/F5M21720751150154I4P41720566674986CaSistemas.png');
INSERT INTO public.file (id, filename, path) VALUES (2, 'image 16.png', '/home/compendiotest/raanddes/files/2LLL1720828156293image 16.png');
INSERT INTO public.file (id, filename, path) VALUES (3, 'ejemplo.gif', '/home/compendiotest/raanddes/files/9MYJ1720828824832ejemplo.gif');
INSERT INTO public.file (id, filename, path) VALUES (4, 'J9K49C7JRA1697245147388.mp4', '/home/compendiotest/raanddes/files/0D6C1720828852820J9K49C7JRA1697245147388.mp4');
INSERT INTO public.file (id, filename, path) VALUES (5, 'IMAGE-1.jpg', '/home/compendiotest/raanddes/files/3N7A1721137714276IMAGE-1.jpg');
INSERT INTO public.file (id, filename, path) VALUES (6, 'IMAGE-2.jpg', '/home/compendiotest/raanddes/files/6A201721137777136IMAGE-2.jpg');
INSERT INTO public.file (id, filename, path) VALUES (7, 'image 16.png', '/home/compendiotest/raanddes/files/TMQZ1721137877493image 16.png');
INSERT INTO public.file (id, filename, path) VALUES (8, '1000091134.jpg', '/home/compendiotest/raanddes/files/2AE817211415434611000091134.jpg');
INSERT INTO public.file (id, filename, path) VALUES (9, '1000000033.jpg', '/home/compendiotest/raanddes/files/DOKV17212502652311000000033.jpg');
INSERT INTO public.file (id, filename, path) VALUES (10, 'cq5dam.resized.img.1536.large.time1573048016666.jpg', '/home/compendiotest/raanddes/files/DTT51721268163545cq5dam.resized.img.1536.large.time1573048016666.jpg');
INSERT INTO public.file (id, filename, path) VALUES (11, '1000000033.jpg', '/home/compendiotest/raanddes/files/XNKV17213199845091000000033.jpg');
INSERT INTO public.file (id, filename, path) VALUES (12, '1000000033.jpg', '/home/compendiotest/raanddes/files/RNN917213305526531000000033.jpg');
INSERT INTO public.file (id, filename, path) VALUES (13, '1000000033.jpg', '/home/compendiotest/raanddes/files/D3PC17213320696631000000033.jpg');
INSERT INTO public.file (id, filename, path) VALUES (14, '1000000033.jpg', '/home/compendiotest/raanddes/files/XBDV17213368406011000000033.jpg');
INSERT INTO public.file (id, filename, path) VALUES (15, '1000000033.jpg', '/home/compendiotest/raanddes/files/TBOG17213421012561000000033.jpg');
INSERT INTO public.file (id, filename, path) VALUES (16, 'fondo-tetris.jpg', '/home/compendiotest/raanddes/files/IWD31721352269842fondo-tetris.jpg');


--
-- TOC entry 3060 (class 0 OID 16418)
-- Dependencies: 206
-- Data for Name: first_day_information_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.first_day_information_item (id, title, description, body, add_from_services, type, icon) VALUES (3, 'Código de vestimenta', 'Conoce los protocolos de vestimenta internos,externos y virtuales.', '<p>test 2</p>', false, 'DEFAULT', 'checkroom_outlined');
INSERT INTO public.first_day_information_item (id, title, description, body, add_from_services, type, icon) VALUES (2, 'Servicio oficina', 'Contamos con una serie de servicios par la comodidad y bienestar de nuestros colaboradores.', NULL, true, 'OTHER_SOURCES', 'chair_outlined');
INSERT INTO public.first_day_information_item (id, title, description, body, add_from_services, type, icon) VALUES (4, 'Normas conviencia', 'Conoce las normas y códigos de conducta que tenemos en Anddes.', '<p>test 3</p><p>image</p>', false, 'DEFAULT', 'book_outlined');
INSERT INTO public.first_day_information_item (id, title, description, body, add_from_services, type, icon) VALUES (1, '¿Cómo llegar?', 'Edificio Capital golf Piso 13', '<p><img src="https://mvcompendiotest.southcentralus.cloudapp.azure.com:8443/files/public/3/filename/ejemplo.gif"></p><p></p><p><a href="https://maps.app.goo.gl/R81fTwvBkzU33er56" rel="noopener noreferrer" target="_blank">Ubicacion:</a></p>', false, 'DEFAULT', 'place_outlined');


--
-- TOC entry 3062 (class 0 OID 16426)
-- Dependencies: 208
-- Data for Name: on_site_induction; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.on_site_induction (id, description) VALUES (1, 'test desc');


--
-- TOC entry 3064 (class 0 OID 16431)
-- Dependencies: 210
-- Data for Name: process; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.process (id, user_id, start_date, status, results, finished, delayed, welcomed, hour_onsite, place_onsite, hour_remote, link_remote) VALUES (13, 18, '2024-07-15 00:00:00+00', 0, '-,-,-,-', false, false, false, '17:00', 'Sala piso 12', '01:00', 'meet.djfytss.com');
INSERT INTO public.process (id, user_id, start_date, status, results, finished, delayed, welcomed, hour_onsite, place_onsite, hour_remote, link_remote) VALUES (12, 17, '2024-07-17 00:00:00+00', 57, '0,-,-,-', false, true, true, '08:09', 'Auditorio', '10:00', 'www.google.com');
INSERT INTO public.process (id, user_id, start_date, status, results, finished, delayed, welcomed, hour_onsite, place_onsite, hour_remote, link_remote) VALUES (21, 2, '2024-07-31 00:00:00+00', 0, '-,-,-,-', false, false, false, '10:01', 'Sala 1', '05:00', 'meet.com');


--
-- TOC entry 3065 (class 0 OID 16434)
-- Dependencies: 211
-- Data for Name: process_activity; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.process_activity (id, activity_id, process_id, completed, result, completion_date) VALUES (51, 1, 12, false, NULL, NULL);
INSERT INTO public.process_activity (id, activity_id, process_id, completed, result, completion_date) VALUES (57, 7, 12, false, NULL, NULL);
INSERT INTO public.process_activity (id, activity_id, process_id, completed, result, completion_date) VALUES (58, 1, 13, false, NULL, NULL);
INSERT INTO public.process_activity (id, activity_id, process_id, completed, result, completion_date) VALUES (59, 2, 13, false, NULL, NULL);
INSERT INTO public.process_activity (id, activity_id, process_id, completed, result, completion_date) VALUES (60, 3, 13, false, NULL, NULL);
INSERT INTO public.process_activity (id, activity_id, process_id, completed, result, completion_date) VALUES (61, 4, 13, false, NULL, NULL);
INSERT INTO public.process_activity (id, activity_id, process_id, completed, result, completion_date) VALUES (62, 5, 13, false, NULL, NULL);
INSERT INTO public.process_activity (id, activity_id, process_id, completed, result, completion_date) VALUES (63, 6, 13, false, NULL, NULL);
INSERT INTO public.process_activity (id, activity_id, process_id, completed, result, completion_date) VALUES (64, 7, 13, false, NULL, NULL);
INSERT INTO public.process_activity (id, activity_id, process_id, completed, result, completion_date) VALUES (52, 2, 12, true, NULL, NULL);
INSERT INTO public.process_activity (id, activity_id, process_id, completed, result, completion_date) VALUES (53, 3, 12, true, NULL, NULL);
INSERT INTO public.process_activity (id, activity_id, process_id, completed, result, completion_date) VALUES (54, 4, 12, true, NULL, NULL);
INSERT INTO public.process_activity (id, activity_id, process_id, completed, result, completion_date) VALUES (56, 6, 12, true, NULL, NULL);
INSERT INTO public.process_activity (id, activity_id, process_id, completed, result, completion_date) VALUES (55, 5, 12, false, NULL, NULL);
INSERT INTO public.process_activity (id, activity_id, process_id, completed, result, completion_date) VALUES (121, 1, 21, false, NULL, NULL);
INSERT INTO public.process_activity (id, activity_id, process_id, completed, result, completion_date) VALUES (122, 2, 21, false, NULL, NULL);
INSERT INTO public.process_activity (id, activity_id, process_id, completed, result, completion_date) VALUES (123, 3, 21, false, NULL, NULL);
INSERT INTO public.process_activity (id, activity_id, process_id, completed, result, completion_date) VALUES (124, 4, 21, false, NULL, NULL);
INSERT INTO public.process_activity (id, activity_id, process_id, completed, result, completion_date) VALUES (125, 5, 21, false, NULL, NULL);
INSERT INTO public.process_activity (id, activity_id, process_id, completed, result, completion_date) VALUES (126, 6, 21, false, NULL, NULL);
INSERT INTO public.process_activity (id, activity_id, process_id, completed, result, completion_date) VALUES (127, 7, 21, false, NULL, NULL);


--
-- TOC entry 3066 (class 0 OID 16437)
-- Dependencies: 212
-- Data for Name: process_activity_content; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.process_activity_content (id, content_id, result, progress, process_activity_id) VALUES (66, 1, 0, 100, 57);


--
-- TOC entry 3067 (class 0 OID 16440)
-- Dependencies: 213
-- Data for Name: process_activity_content_card; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3072 (class 0 OID 16451)
-- Dependencies: 218
-- Data for Name: remote_induction; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.remote_induction (id, description) VALUES (1, 'remota');


--
-- TOC entry 3074 (class 0 OID 16456)
-- Dependencies: 220
-- Data for Name: service; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.service (id, name, description, icon, icon_web) VALUES (2, 'Programa de bienestar para todos', 'Conoce los protocolos de vestimenta internos, externos y virtual.', 'favorite_border', 'favorite');
INSERT INTO public.service (id, name, description, icon, icon_web) VALUES (1, 'Servicios oficina', 'Contamos con una serie de servicios par la comodidad y bienestar de nuestros colaboradores 1', 'chair_outlined', 'chair');


--
-- TOC entry 3075 (class 0 OID 16462)
-- Dependencies: 221
-- Data for Name: service_detail; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.service_detail (id, title, description, service_id, hidden) VALUES (2, 'Sillón de masaje', '<p>Texto de prueba <img src="https://storagecompendio.blob.core.windows.net/myanddes/JEFZ2OA0E1717815283684/Surface.png"></p>', 1, false);
INSERT INTO public.service_detail (id, title, description, service_id, hidden) VALUES (1, 'Comedor y oficina', '<p>Descripcion Comedor y Oficina 213123</p>', 1, false);
INSERT INTO public.service_detail (id, title, description, service_id, hidden) VALUES (3, 'Programa 1', '<p>Descripción de programa 01.</p><p></p><p><img src="https://mvcompendiotest.southcentralus.cloudapp.azure.com:8443/files/public/7/filename/image 16.png"></p>', 2, false);


--
-- TOC entry 3078 (class 0 OID 16472)
-- Dependencies: 224
-- Data for Name: tool; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.tool (id, cover, description, link, name) VALUES (4, 'https://storagecompendio.blob.core.windows.net/myanddes/FOK2RI4ES1719106329609/PowerApps.png', 'Soluciones nativas dentro de tu office 365', 'www.google.com', 'Power apps');
INSERT INTO public.tool (id, cover, description, link, name) VALUES (5, 'https://storagecompendio.blob.core.windows.net/myanddes/24NDC4J1A1719106457521/ReportAndes.png', 'Informa de manera anónima cualquier situación que nos exponga a todos.', 'www.google.com', 'Reportanddes');
INSERT INTO public.tool (id, cover, description, link, name) VALUES (1, 'https://storagecompendio.blob.core.windows.net/myanddes/UXXQ9GENC1717692538652/Surface@2x.png', 'Lista de todos tus compañeros organizados área, incluye foto, datos de contacto y puesto', 'www.google.com', 'Directorio');
INSERT INTO public.tool (id, cover, description, link, name) VALUES (2, 'https://mvcompendiotest.southcentralus.cloudapp.azure.com:8443/files/public/1/filename/I4P41720566674986CaSistemas.png', 'Loremp ipsum and solum', 'www.anddes.com/caas', 'CAS Sistemas');
INSERT INTO public.tool (id, cover, description, link, name) VALUES (6, 'https://mvcompendiotest.southcentralus.cloudapp.azure.com:8443/files/public/2/filename/image 16.png', 'Prueba', 'www.compendio.pe', 'Nueva herramienta');
INSERT INTO public.tool (id, cover, description, link, name) VALUES (3, 'https://mvcompendiotest.southcentralus.cloudapp.azure.com:8443/files/public/5/filename/IMAGE-1.jpg', 'Soporte para cualquier inconvenientes que tengas con las herramientas de hardaware y software con las que estés trabajando.', 'www.google.com', 'Mesa de ayuda');


--
-- TOC entry 3080 (class 0 OID 16480)
-- Dependencies: 226
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."user" (id, fullname, email, job, start_date, image, hobbies, roles, dni, deleted, on_itinerary, boss_id, finished_itinerary, nickname, admin) VALUES (5, 'Zavalaga Zavalaga, Henry David', '41986239@correo.com', 'ADMINISTRADOR DEL CONTRATO', NULL, NULL, '', 'Colaborador', '41986239', false, false, NULL, false, NULL, false);
INSERT INTO public."user" (id, fullname, email, job, start_date, image, hobbies, roles, dni, deleted, on_itinerary, boss_id, finished_itinerary, nickname, admin) VALUES (8, 'Tumialan Esteban, Jhandira Shirley', '71473651@correo.com', 'ANALISTA DE CONTROL DE GESTION', NULL, NULL, '', 'Colaborador', '71473651', false, false, NULL, false, NULL, false);
INSERT INTO public."user" (id, fullname, email, job, start_date, image, hobbies, roles, dni, deleted, on_itinerary, boss_id, finished_itinerary, nickname, admin) VALUES (9, 'Luque Quenema, Estefany Bany', '75328496@correo.com', 'ANALISTA DE GESTIÓN DEL TALENTO', NULL, NULL, '', 'Colaborador', '75328496', false, false, NULL, false, NULL, false);
INSERT INTO public."user" (id, fullname, email, job, start_date, image, hobbies, roles, dni, deleted, on_itinerary, boss_id, finished_itinerary, nickname, admin) VALUES (10, 'Parian Meza, Elvis Antonio', '47195046@correo.com', 'ANALISTA DE LOGISTICA', NULL, NULL, '', 'Colaborador', '47195046', false, false, NULL, false, NULL, false);
INSERT INTO public."user" (id, fullname, email, job, start_date, image, hobbies, roles, dni, deleted, on_itinerary, boss_id, finished_itinerary, nickname, admin) VALUES (11, 'Vasquez Cerna, Silvia Paola', '07763573@correo.com', 'ANALISTA DE LOGÍSTICA DE PROYECTOS', NULL, NULL, '', 'Colaborador', '07763573', false, false, NULL, false, NULL, false);
INSERT INTO public."user" (id, fullname, email, job, start_date, image, hobbies, roles, dni, deleted, on_itinerary, boss_id, finished_itinerary, nickname, admin) VALUES (6, 'Espinoza Paco, Max Pastor', '46888692@correo.com', 'ALMACENERO', NULL, NULL, '', 'Colaborador', '46888692', false, false, NULL, false, NULL, false);
INSERT INTO public."user" (id, fullname, email, job, start_date, image, hobbies, roles, dni, deleted, on_itinerary, boss_id, finished_itinerary, nickname, admin) VALUES (7, 'Oropeza Ccaso, Silvia', '44047923@correo.com', 'ANALISTA CONTABLE DE CUENTAS POR PAGAR', NULL, NULL, '', 'Colaborador', '44047923', false, false, NULL, false, NULL, false);
INSERT INTO public."user" (id, fullname, email, job, start_date, image, hobbies, roles, dni, deleted, on_itinerary, boss_id, finished_itinerary, nickname, admin) VALUES (13, 'Santiago Vidal Ramos', 'santiago.vidalr@outlook.com', 'Java Developer', NULL, 'https://mvcompendiotest.southcentralus.cloudapp.azure.com:8443/files/public/15/filename/1000000033.jpg', 'tennis', 'Colaborador', '44811894', false, false, 17, false, 'Santi', true);
INSERT INTO public."user" (id, fullname, email, job, start_date, image, hobbies, roles, dni, deleted, on_itinerary, boss_id, finished_itinerary, nickname, admin) VALUES (3, 'Flores Peña, Alejandro', '04068430@correo.com', 'ADMINISTRADOR DE SOPORTE DE TI', NULL, NULL, '', 'Colaborador', '04068430', false, true, NULL, false, NULL, false);
INSERT INTO public."user" (id, fullname, email, job, start_date, image, hobbies, roles, dni, deleted, on_itinerary, boss_id, finished_itinerary, nickname, admin) VALUES (14, 'Juan Perez', '77152572@correo.com', 'ADMINISTRADOR DE INFRAESTRUCTURA DE TI', NULL, NULL, '', '', '77152572', false, false, 17, false, NULL, false);
INSERT INTO public."user" (id, fullname, email, job, start_date, image, hobbies, roles, dni, deleted, on_itinerary, boss_id, finished_itinerary, nickname, admin) VALUES (15, 'Omar Perez', '44576139@correo.com', 'ADMINISTRADOR DE REMUNERACIONES Y COMPENSACIONES', NULL, NULL, '', '', '44576139', false, false, 17, false, NULL, false);
INSERT INTO public."user" (id, fullname, email, job, start_date, image, hobbies, roles, dni, deleted, on_itinerary, boss_id, finished_itinerary, nickname, admin) VALUES (18, 'Jonas Urrutia', 'jonas_urrutiaq@anddes.com', 'ANALISTA', NULL, NULL, '', '', '56438654', false, true, 17, false, NULL, false);
INSERT INTO public."user" (id, fullname, email, job, start_date, image, hobbies, roles, dni, deleted, on_itinerary, boss_id, finished_itinerary, nickname, admin) VALUES (1, 'Alva Castro, Roberto Anthoni', '77152571@correo.com', 'ADMINISTRADOR DE INFRAESTRUCTURA DE TI', NULL, NULL, '', '', '77152571', false, true, NULL, false, NULL, false);
INSERT INTO public."user" (id, fullname, email, job, start_date, image, hobbies, roles, dni, deleted, on_itinerary, boss_id, finished_itinerary, nickname, admin) VALUES (4, 'Bernal Paredes, Edgard Eduardo 2', '42607250@correo.com', 'ADMINISTRADOR DEL CONTRATO', NULL, NULL, '', '', '42607250', false, false, 1, false, NULL, false);
INSERT INTO public."user" (id, fullname, email, job, start_date, image, hobbies, roles, dni, deleted, on_itinerary, boss_id, finished_itinerary, nickname, admin) VALUES (12, 'Cabezas Vasquez, Freddy Miguel', '72182379@correo.com', 'ANALISTA DE PROGRAMACION', NULL, NULL, '', '', '72182379', false, false, 1, false, NULL, false);
INSERT INTO public."user" (id, fullname, email, job, start_date, image, hobbies, roles, dni, deleted, on_itinerary, boss_id, finished_itinerary, nickname, admin) VALUES (16, 'Marco Perez', '04068431@correo.com', 'ADMINISTRADOR DE SOPORTE DE TI', NULL, NULL, '', '', '04068431', false, false, 13, false, NULL, false);
INSERT INTO public."user" (id, fullname, email, job, start_date, image, hobbies, roles, dni, deleted, on_itinerary, boss_id, finished_itinerary, nickname, admin) VALUES (17, 'Roy Justo', 'royjusto@hotmail.com', 'GERENTE DE INFRAESTRUCTURA DE TI', NULL, 'https://mvcompendiotest.southcentralus.cloudapp.azure.com:8443/files/public/8/filename/1000091134.jpg', NULL, '', '77152573', false, false, 1, false, NULL, true);
INSERT INTO public."user" (id, fullname, email, job, start_date, image, hobbies, roles, dni, deleted, on_itinerary, boss_id, finished_itinerary, nickname, admin) VALUES (2, 'Rivas Santos, Crhistian', '44576138@correo.com', 'ADMINISTRADOR DE REMUNERACIONES Y COMPENSACIONES', NULL, NULL, '', '', '44576138', false, true, NULL, false, NULL, false);


--
-- TOC entry 3140 (class 0 OID 0)
-- Dependencies: 197
-- Name: activity_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.activity_id_seq', 7, true);


--
-- TOC entry 3141 (class 0 OID 0)
-- Dependencies: 199
-- Name: ceo_presentation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ceo_presentation_id_seq', 1, true);


--
-- TOC entry 3142 (class 0 OID 0)
-- Dependencies: 202
-- Name: elearning_content_card_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.elearning_content_card_id_seq', 18, true);


--
-- TOC entry 3143 (class 0 OID 0)
-- Dependencies: 204
-- Name: elearning_content_card_option_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.elearning_content_card_option_id_seq', 25, true);


--
-- TOC entry 3144 (class 0 OID 0)
-- Dependencies: 205
-- Name: elearning_content_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.elearning_content_id_seq', 4, true);


--
-- TOC entry 3145 (class 0 OID 0)
-- Dependencies: 228
-- Name: file_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.file_id_seq', 16, true);


--
-- TOC entry 3146 (class 0 OID 0)
-- Dependencies: 207
-- Name: first_day_information_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.first_day_information_item_id_seq', 4, true);


--
-- TOC entry 3147 (class 0 OID 0)
-- Dependencies: 209
-- Name: on_site_induction_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.on_site_induction_id_seq', 1, true);


--
-- TOC entry 3148 (class 0 OID 0)
-- Dependencies: 214
-- Name: process_activity_content_card_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.process_activity_content_card_id_seq', 89, true);


--
-- TOC entry 3149 (class 0 OID 0)
-- Dependencies: 215
-- Name: process_activity_content_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.process_activity_content_id_seq', 1, false);


--
-- TOC entry 3150 (class 0 OID 0)
-- Dependencies: 216
-- Name: process_activity_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.process_activity_id_seq', 147, true);


--
-- TOC entry 3151 (class 0 OID 0)
-- Dependencies: 217
-- Name: process_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.process_id_seq', 23, true);


--
-- TOC entry 3152 (class 0 OID 0)
-- Dependencies: 219
-- Name: remote_induction_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.remote_induction_id_seq', 1, true);


--
-- TOC entry 3153 (class 0 OID 0)
-- Dependencies: 222
-- Name: service_detail_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.service_detail_id_seq', 3, true);


--
-- TOC entry 3154 (class 0 OID 0)
-- Dependencies: 223
-- Name: service_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.service_id_seq', 2, true);


--
-- TOC entry 3155 (class 0 OID 0)
-- Dependencies: 225
-- Name: tool_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tool_id_seq', 6, true);


--
-- TOC entry 3156 (class 0 OID 0)
-- Dependencies: 227
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_id_seq', 18, true);


--
-- TOC entry 2879 (class 2606 OID 16507)
-- Name: activity activity_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.activity
    ADD CONSTRAINT activity_pkey PRIMARY KEY (id);


--
-- TOC entry 2887 (class 2606 OID 16509)
-- Name: elearning_content_card_option elearning_content_card_option_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.elearning_content_card_option
    ADD CONSTRAINT elearning_content_card_option_pkey PRIMARY KEY (id);


--
-- TOC entry 2885 (class 2606 OID 16511)
-- Name: elearning_content_card elearning_content_card_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.elearning_content_card
    ADD CONSTRAINT elearning_content_card_pkey PRIMARY KEY (id);


--
-- TOC entry 2883 (class 2606 OID 16513)
-- Name: elearning_content elearning_content_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.elearning_content
    ADD CONSTRAINT elearning_content_pkey PRIMARY KEY (id);


--
-- TOC entry 2916 (class 2606 OID 16624)
-- Name: file file_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.file
    ADD CONSTRAINT file_pkey PRIMARY KEY (id);


--
-- TOC entry 2891 (class 2606 OID 16515)
-- Name: on_site_induction first_day_induction_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.on_site_induction
    ADD CONSTRAINT first_day_induction_pkey PRIMARY KEY (id);


--
-- TOC entry 2889 (class 2606 OID 16517)
-- Name: first_day_information_item first_day_information_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.first_day_information_item
    ADD CONSTRAINT first_day_information_item_pkey PRIMARY KEY (id);


--
-- TOC entry 2897 (class 2606 OID 16519)
-- Name: process_activity_content process_activity_content_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.process_activity_content
    ADD CONSTRAINT process_activity_content_pkey PRIMARY KEY (id);


--
-- TOC entry 2899 (class 2606 OID 16521)
-- Name: process_activity_content_card process_checklist_card_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.process_activity_content_card
    ADD CONSTRAINT process_checklist_card_pkey PRIMARY KEY (id);


--
-- TOC entry 2895 (class 2606 OID 16523)
-- Name: process_activity process_checklist_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.process_activity
    ADD CONSTRAINT process_checklist_pkey PRIMARY KEY (id);


--
-- TOC entry 2893 (class 2606 OID 16525)
-- Name: process process_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.process
    ADD CONSTRAINT process_pkey PRIMARY KEY (id);


--
-- TOC entry 2901 (class 2606 OID 16527)
-- Name: remote_induction remote_induction_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.remote_induction
    ADD CONSTRAINT remote_induction_pkey PRIMARY KEY (id);


--
-- TOC entry 2906 (class 2606 OID 16529)
-- Name: service_detail service_detail_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_detail
    ADD CONSTRAINT service_detail_pkey PRIMARY KEY (id);


--
-- TOC entry 2903 (class 2606 OID 16531)
-- Name: service service_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service
    ADD CONSTRAINT service_pkey PRIMARY KEY (id);


--
-- TOC entry 2908 (class 2606 OID 16533)
-- Name: tool tool_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tool
    ADD CONSTRAINT tool_pkey PRIMARY KEY (id);


--
-- TOC entry 2910 (class 2606 OID 16535)
-- Name: user user_dni_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_dni_unique UNIQUE (dni);


--
-- TOC entry 2912 (class 2606 OID 16537)
-- Name: user user_email_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_email_unique UNIQUE (email);


--
-- TOC entry 2914 (class 2606 OID 16539)
-- Name: user user_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pk PRIMARY KEY (id);


--
-- TOC entry 2881 (class 2606 OID 16541)
-- Name: ceo_presentation welcome_video_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ceo_presentation
    ADD CONSTRAINT welcome_video_pkey PRIMARY KEY (id);


--
-- TOC entry 2904 (class 1259 OID 16542)
-- Name: fki_service_detail_service_fk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_service_detail_service_fk ON public.service_detail USING btree (service_id);


--
-- TOC entry 2917 (class 2606 OID 16543)
-- Name: elearning_content_card elearning_content_card_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.elearning_content_card
    ADD CONSTRAINT elearning_content_card_fk FOREIGN KEY (elearning_content_id) REFERENCES public.elearning_content(id) NOT VALID;


--
-- TOC entry 2924 (class 2606 OID 16548)
-- Name: process_activity_content_card elearning_content_card_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.process_activity_content_card
    ADD CONSTRAINT elearning_content_card_fk FOREIGN KEY (card_id) REFERENCES public.elearning_content_card(id) NOT VALID;


--
-- TOC entry 2918 (class 2606 OID 16553)
-- Name: elearning_content_card_option elearning_content_card_option_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.elearning_content_card_option
    ADD CONSTRAINT elearning_content_card_option_fk FOREIGN KEY (elearning_content_card_id) REFERENCES public.elearning_content_card(id);


--
-- TOC entry 2925 (class 2606 OID 16558)
-- Name: process_activity_content_card elearning_content_card_option_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.process_activity_content_card
    ADD CONSTRAINT elearning_content_card_option_fk FOREIGN KEY (option_id_selected) REFERENCES public.elearning_content_card_option(id) NOT VALID;


--
-- TOC entry 2926 (class 2606 OID 16563)
-- Name: process_activity_content_card process_activity_content_card_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.process_activity_content_card
    ADD CONSTRAINT process_activity_content_card_fk FOREIGN KEY (process_activity_content_id) REFERENCES public.process_activity_content(id) NOT VALID;


--
-- TOC entry 2922 (class 2606 OID 16568)
-- Name: process_activity_content process_activity_content_elearning_content_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.process_activity_content
    ADD CONSTRAINT process_activity_content_elearning_content_fk FOREIGN KEY (content_id) REFERENCES public.elearning_content(id);


--
-- TOC entry 2923 (class 2606 OID 16573)
-- Name: process_activity_content process_activity_process_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.process_activity_content
    ADD CONSTRAINT process_activity_process_fk FOREIGN KEY (process_activity_id) REFERENCES public.process_activity(id) NOT VALID;


--
-- TOC entry 2920 (class 2606 OID 16578)
-- Name: process_activity process_checklist_activity_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.process_activity
    ADD CONSTRAINT process_checklist_activity_fk FOREIGN KEY (activity_id) REFERENCES public.activity(id) NOT VALID;


--
-- TOC entry 2921 (class 2606 OID 16583)
-- Name: process_activity process_checklist_process_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.process_activity
    ADD CONSTRAINT process_checklist_process_fk FOREIGN KEY (process_id) REFERENCES public.process(id) NOT VALID;


--
-- TOC entry 2919 (class 2606 OID 16588)
-- Name: process process_user_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.process
    ADD CONSTRAINT process_user_fk FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- TOC entry 2927 (class 2606 OID 16593)
-- Name: service_detail service_detail_service_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_detail
    ADD CONSTRAINT service_detail_service_fk FOREIGN KEY (service_id) REFERENCES public.service(id) NOT VALID;


--
-- TOC entry 2928 (class 2606 OID 16598)
-- Name: user user_boss_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_boss_fk FOREIGN KEY (boss_id) REFERENCES public."user"(id);


--
-- TOC entry 3090 (class 0 OID 0)
-- Dependencies: 6
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- TOC entry 3091 (class 0 OID 0)
-- Dependencies: 196
-- Name: TABLE activity; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.activity TO PUBLIC;


--
-- TOC entry 3093 (class 0 OID 0)
-- Dependencies: 197
-- Name: SEQUENCE activity_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.activity_id_seq TO PUBLIC;


--
-- TOC entry 3094 (class 0 OID 0)
-- Dependencies: 198
-- Name: TABLE ceo_presentation; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.ceo_presentation TO PUBLIC;


--
-- TOC entry 3096 (class 0 OID 0)
-- Dependencies: 199
-- Name: SEQUENCE ceo_presentation_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.ceo_presentation_id_seq TO PUBLIC;


--
-- TOC entry 3097 (class 0 OID 0)
-- Dependencies: 200
-- Name: TABLE elearning_content; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.elearning_content TO PUBLIC;


--
-- TOC entry 3098 (class 0 OID 0)
-- Dependencies: 201
-- Name: TABLE elearning_content_card; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.elearning_content_card TO PUBLIC;


--
-- TOC entry 3100 (class 0 OID 0)
-- Dependencies: 202
-- Name: SEQUENCE elearning_content_card_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.elearning_content_card_id_seq TO PUBLIC;


--
-- TOC entry 3101 (class 0 OID 0)
-- Dependencies: 203
-- Name: TABLE elearning_content_card_option; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.elearning_content_card_option TO PUBLIC;


--
-- TOC entry 3103 (class 0 OID 0)
-- Dependencies: 204
-- Name: SEQUENCE elearning_content_card_option_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.elearning_content_card_option_id_seq TO PUBLIC;


--
-- TOC entry 3105 (class 0 OID 0)
-- Dependencies: 205
-- Name: SEQUENCE elearning_content_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.elearning_content_id_seq TO PUBLIC;


--
-- TOC entry 3107 (class 0 OID 0)
-- Dependencies: 206
-- Name: TABLE first_day_information_item; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.first_day_information_item TO PUBLIC;


--
-- TOC entry 3109 (class 0 OID 0)
-- Dependencies: 207
-- Name: SEQUENCE first_day_information_item_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.first_day_information_item_id_seq TO PUBLIC;


--
-- TOC entry 3110 (class 0 OID 0)
-- Dependencies: 208
-- Name: TABLE on_site_induction; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.on_site_induction TO PUBLIC;


--
-- TOC entry 3112 (class 0 OID 0)
-- Dependencies: 209
-- Name: SEQUENCE on_site_induction_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.on_site_induction_id_seq TO PUBLIC;


--
-- TOC entry 3113 (class 0 OID 0)
-- Dependencies: 210
-- Name: TABLE process; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.process TO PUBLIC;


--
-- TOC entry 3114 (class 0 OID 0)
-- Dependencies: 211
-- Name: TABLE process_activity; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.process_activity TO PUBLIC;


--
-- TOC entry 3115 (class 0 OID 0)
-- Dependencies: 212
-- Name: TABLE process_activity_content; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.process_activity_content TO PUBLIC;


--
-- TOC entry 3116 (class 0 OID 0)
-- Dependencies: 213
-- Name: TABLE process_activity_content_card; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.process_activity_content_card TO PUBLIC;


--
-- TOC entry 3118 (class 0 OID 0)
-- Dependencies: 214
-- Name: SEQUENCE process_activity_content_card_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.process_activity_content_card_id_seq TO PUBLIC;


--
-- TOC entry 3120 (class 0 OID 0)
-- Dependencies: 215
-- Name: SEQUENCE process_activity_content_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.process_activity_content_id_seq TO PUBLIC;


--
-- TOC entry 3122 (class 0 OID 0)
-- Dependencies: 216
-- Name: SEQUENCE process_activity_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.process_activity_id_seq TO PUBLIC;


--
-- TOC entry 3124 (class 0 OID 0)
-- Dependencies: 217
-- Name: SEQUENCE process_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.process_id_seq TO PUBLIC;


--
-- TOC entry 3125 (class 0 OID 0)
-- Dependencies: 218
-- Name: TABLE remote_induction; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.remote_induction TO PUBLIC;


--
-- TOC entry 3127 (class 0 OID 0)
-- Dependencies: 219
-- Name: SEQUENCE remote_induction_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.remote_induction_id_seq TO PUBLIC;


--
-- TOC entry 3128 (class 0 OID 0)
-- Dependencies: 220
-- Name: TABLE service; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.service TO PUBLIC;


--
-- TOC entry 3129 (class 0 OID 0)
-- Dependencies: 221
-- Name: TABLE service_detail; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.service_detail TO PUBLIC;


--
-- TOC entry 3131 (class 0 OID 0)
-- Dependencies: 222
-- Name: SEQUENCE service_detail_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.service_detail_id_seq TO PUBLIC;


--
-- TOC entry 3133 (class 0 OID 0)
-- Dependencies: 223
-- Name: SEQUENCE service_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.service_id_seq TO PUBLIC;


--
-- TOC entry 3134 (class 0 OID 0)
-- Dependencies: 224
-- Name: TABLE tool; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.tool TO PUBLIC;


--
-- TOC entry 3136 (class 0 OID 0)
-- Dependencies: 225
-- Name: SEQUENCE tool_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.tool_id_seq TO PUBLIC;


--
-- TOC entry 3137 (class 0 OID 0)
-- Dependencies: 226
-- Name: TABLE "user"; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public."user" TO PUBLIC;


--
-- TOC entry 3139 (class 0 OID 0)
-- Dependencies: 227
-- Name: SEQUENCE user_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.user_id_seq TO PUBLIC;


-- Completed on 2024-07-21 16:53:55

--
-- PostgreSQL database dump complete
--

