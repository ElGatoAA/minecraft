--
-- PostgreSQL database dump
--

-- Dumped from database version 17.2 (Postgres.app)
-- Dumped by pg_dump version 17.2 (Homebrew)

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
-- Name: search_items(text); Type: FUNCTION; Schema: public; Owner: gatoaa
--

CREATE FUNCTION public.search_items(search_term text) RETURNS TABLE(id integer, name character varying, release character varying, stack_size integer, rarity character varying, creative_category character varying, where_crafted character varying, how_to_obtain text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT i.id, i.name, i.release, i.stack_size, i.rarity, i.creative_category, i.where_crafted, i.how_to_obtain
    FROM items i
    WHERE LOWER(i.name) LIKE LOWER('%' || search_term || '%')
    ORDER BY i.name
    LIMIT 10;
END;
$$;


ALTER FUNCTION public.search_items(search_term text) OWNER TO gatoaa;

--
-- Name: search_mobs(text); Type: FUNCTION; Schema: public; Owner: gatoaa
--

CREATE FUNCTION public.search_mobs(search_term text) RETURNS TABLE(id integer, name character varying, release character varying, health integer, height numeric, behavior character varying, spawn_category character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT m.id, m.name, m.release, m.health, m.height, m.behavior, m.spawn_category
    FROM mobs m
    WHERE LOWER(m.name) LIKE LOWER('%' || search_term || '%')
    ORDER BY m.name
    LIMIT 10;
END;
$$;


ALTER FUNCTION public.search_mobs(search_term text) OWNER TO gatoaa;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: blocks; Type: TABLE; Schema: public; Owner: gatoaa
--

CREATE TABLE public.blocks (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    release character varying(50) NOT NULL,
    stack_size integer NOT NULL,
    tool character varying(50) NOT NULL,
    hardness numeric(10,2) NOT NULL,
    blast_resistance numeric(10,2) NOT NULL,
    flammable boolean DEFAULT false NOT NULL,
    full_block boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.blocks OWNER TO gatoaa;

--
-- Name: blocks_id_seq; Type: SEQUENCE; Schema: public; Owner: gatoaa
--

CREATE SEQUENCE public.blocks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.blocks_id_seq OWNER TO gatoaa;

--
-- Name: blocks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gatoaa
--

ALTER SEQUENCE public.blocks_id_seq OWNED BY public.blocks.id;


--
-- Name: items; Type: TABLE; Schema: public; Owner: gatoaa
--

CREATE TABLE public.items (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    release character varying(50) NOT NULL,
    stack_size integer NOT NULL,
    rarity character varying(20) NOT NULL,
    creative_category character varying(50) NOT NULL,
    where_crafted character varying(100) NOT NULL,
    how_to_obtain text NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.items OWNER TO gatoaa;

--
-- Name: items_id_seq; Type: SEQUENCE; Schema: public; Owner: gatoaa
--

CREATE SEQUENCE public.items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.items_id_seq OWNER TO gatoaa;

--
-- Name: items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gatoaa
--

ALTER SEQUENCE public.items_id_seq OWNED BY public.items.id;


--
-- Name: mobs; Type: TABLE; Schema: public; Owner: gatoaa
--

CREATE TABLE public.mobs (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    release character varying(50) NOT NULL,
    health integer NOT NULL,
    height numeric(4,2) NOT NULL,
    behavior character varying(20) NOT NULL,
    spawn_category character varying(50) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.mobs OWNER TO gatoaa;

--
-- Name: mobs_id_seq; Type: SEQUENCE; Schema: public; Owner: gatoaa
--

CREATE SEQUENCE public.mobs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.mobs_id_seq OWNER TO gatoaa;

--
-- Name: mobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gatoaa
--

ALTER SEQUENCE public.mobs_id_seq OWNED BY public.mobs.id;


--
-- Name: blocks id; Type: DEFAULT; Schema: public; Owner: gatoaa
--

ALTER TABLE ONLY public.blocks ALTER COLUMN id SET DEFAULT nextval('public.blocks_id_seq'::regclass);


--
-- Name: items id; Type: DEFAULT; Schema: public; Owner: gatoaa
--

ALTER TABLE ONLY public.items ALTER COLUMN id SET DEFAULT nextval('public.items_id_seq'::regclass);


--
-- Name: mobs id; Type: DEFAULT; Schema: public; Owner: gatoaa
--

ALTER TABLE ONLY public.mobs ALTER COLUMN id SET DEFAULT nextval('public.mobs_id_seq'::regclass);


--
-- Data for Name: blocks; Type: TABLE DATA; Schema: public; Owner: gatoaa
--

COPY public.blocks (id, name, release, stack_size, tool, hardness, blast_resistance, flammable, full_block, created_at) FROM stdin;
1	Stone	Classic 0.0.14a	64	Pickaxe	1.50	6.00	f	t	2025-05-29 20:36:26.132821
2	Wood Planks	Classic 0.0.14a	64	Axe	2.00	3.00	t	t	2025-05-29 20:36:26.132821
3	Glass	Classic 0.0.19a	64	Any	0.30	0.30	f	t	2025-05-29 20:36:26.132821
4	Diamond Ore	Classic 0.0.14a	64	Iron Pickaxe	3.00	3.00	f	t	2025-05-29 20:36:26.132821
5	TNT	Classic 0.0.24a	64	Any	0.00	0.00	t	t	2025-05-29 20:36:26.132821
6	Obsidian	Classic 0.0.20a	64	Diamond Pickaxe	50.00	1200.00	f	t	2025-05-29 20:36:26.132821
7	Bedrock	Classic 0.0.12a	64	Unbreakable	-1.00	3600000.00	f	t	2025-05-29 20:36:26.132821
8	Sand	Classic 0.0.14a	64	Shovel	0.50	0.50	f	t	2025-05-29 20:36:26.132821
9	Wool	Classic 0.0.20a	64	Shears	0.80	0.80	t	t	2025-05-29 20:36:26.132821
10	Ice	Alpha v1.0.4	64	Pickaxe	0.50	0.50	f	t	2025-05-29 20:36:26.132821
11	Netherite Block	1.16	64	Diamond Pickaxe	50.00	1200.00	f	t	2025-05-29 20:36:26.132821
12	Ancient Debris	1.16	64	Diamond Pickaxe	30.00	1200.00	f	t	2025-05-29 20:36:26.132821
13	Crying Obsidian	1.16	64	Diamond Pickaxe	50.00	1200.00	f	t	2025-05-29 20:36:26.132821
14	Blackstone	1.16	64	Pickaxe	1.50	6.00	f	t	2025-05-29 20:36:26.132821
15	Deepslate	1.17	64	Pickaxe	3.00	6.00	f	t	2025-05-29 20:36:26.132821
16	Cobblestone	Classic 0.0.14a	64	Pickaxe	2.00	6.00	f	t	2025-05-29 21:46:24.043068
17	Dirt	Classic 0.0.14a	64	Shovel	0.50	0.50	f	t	2025-05-29 21:46:24.043068
18	Grass Block	Classic 0.0.14a	64	Shovel	0.60	0.50	f	t	2025-05-29 21:46:24.043068
19	Sandstone	Classic 0.0.14a	64	Pickaxe	0.80	4.00	f	t	2025-05-29 21:46:24.043068
20	Red Sandstone	1.7	64	Pickaxe	0.80	4.00	f	t	2025-05-29 21:46:24.043068
21	Clay	Classic 0.0.14a	64	Shovel	0.60	4.00	f	t	2025-05-29 21:46:24.043068
22	Netherrack	Beta 1.2	64	Pickaxe	0.40	2.00	f	t	2025-05-29 21:46:24.043068
23	Soul Sand	Beta 1.2	64	Shovel	0.50	2.50	f	t	2025-05-29 21:46:24.043068
24	Quartz Block	1.5	64	Pickaxe	0.80	4.00	f	t	2025-05-29 21:46:24.043068
25	Smooth Stone	1.8	64	Pickaxe	1.50	6.00	f	t	2025-05-29 21:46:24.043068
26	Prismarine	1.8	64	Pickaxe	1.50	6.00	f	t	2025-05-29 21:46:24.043068
27	Sea Lantern	1.8	64	Pickaxe	0.30	15.00	f	t	2025-05-29 21:46:24.043068
28	End Stone	Beta 1.9	64	Pickaxe	3.00	9.00	f	t	2025-05-29 21:46:24.043068
29	Purpur Block	1.9	64	Pickaxe	1.50	6.00	f	t	2025-05-29 21:46:24.043068
30	Slime Block	1.8	64	Any	0.50	0.50	f	t	2025-05-29 21:46:24.043068
31	Honey Block	1.15	64	Any	0.50	0.50	f	t	2025-05-29 21:46:24.043068
32	Moss Block	1.17	64	Any	0.60	0.50	f	t	2025-05-29 21:46:24.043068
33	Deepslate Coal Ore	1.17	64	Pickaxe	3.00	6.00	f	t	2025-05-29 21:46:24.043068
34	Amethyst Block	1.17	64	Pickaxe	1.50	6.00	f	t	2025-05-29 21:46:24.043068
35	Copper Block	1.17	64	Pickaxe	3.00	6.00	f	t	2025-05-29 21:46:24.043068
36	Lodestone	1.16	64	Pickaxe	5.00	6.00	f	t	2025-05-29 21:46:24.043068
37	Target Block	1.14	64	Pickaxe	0.50	0.50	f	t	2025-05-29 21:46:24.043068
38	Honeycomb Block	1.15	64	Any	0.50	0.50	t	t	2025-05-29 21:46:24.043068
39	Warped Nylium	1.16	64	Any	0.60	0.50	f	t	2025-05-29 21:46:24.043068
40	Crimson Nylium	1.16	64	Any	0.60	0.50	f	t	2025-05-29 21:46:24.043068
41	Soul Soil	1.16	64	Shovel	0.50	0.50	f	t	2025-05-29 21:46:24.043068
43	Basalt	1.16	64	Pickaxe	1.50	6.00	f	t	2025-05-29 21:46:24.043068
44	Smooth Basalt	1.16	64	Pickaxe	1.50	6.00	f	t	2025-05-29 21:46:24.043068
45	Stone Bricks	1.0	64	Pickaxe	1.50	6.00	f	t	2025-05-29 21:48:52.993686
46	Mossy Stone Bricks	1.0	64	Pickaxe	1.50	6.00	f	t	2025-05-29 21:48:52.993686
47	Cracked Stone Bricks	1.0	64	Pickaxe	1.50	6.00	f	t	2025-05-29 21:48:52.993686
48	Chiseled Stone Bricks	1.0	64	Pickaxe	1.50	6.00	f	t	2025-05-29 21:48:52.993686
49	Bricks	1.0	64	Pickaxe	2.00	6.00	f	t	2025-05-29 21:48:52.993686
50	Bookshelf	1.0	64	Axe	1.50	3.00	t	t	2025-05-29 21:48:52.993686
51	Sandstone Stairs	1.0	64	Pickaxe	0.80	4.00	f	t	2025-05-29 21:48:52.993686
52	Cobblestone Stairs	1.0	64	Pickaxe	2.00	6.00	f	t	2025-05-29 21:48:52.993686
53	Oak Planks	Classic 0.0.14a	64	Axe	2.00	3.00	t	t	2025-05-29 21:48:52.993686
54	Spruce Planks	1.2	64	Axe	2.00	3.00	t	t	2025-05-29 21:48:52.993686
55	Birch Planks	1.2	64	Axe	2.00	3.00	t	t	2025-05-29 21:48:52.993686
56	Jungle Planks	1.2	64	Axe	2.00	3.00	t	t	2025-05-29 21:48:52.993686
57	Acacia Planks	1.7	64	Axe	2.00	3.00	t	t	2025-05-29 21:48:52.993686
58	Dark Oak Planks	1.7	64	Axe	2.00	3.00	t	t	2025-05-29 21:48:52.993686
59	Cobweb	Beta 1.8	64	Any	4.00	15.00	f	f	2025-05-29 21:48:52.993686
60	Grass	Classic 0.0.14a	64	Any	0.00	0.00	f	f	2025-05-29 21:48:52.993686
61	Fern	1.7	64	Any	0.00	0.00	f	f	2025-05-29 21:48:52.993686
62	Dead Bush	1.7	64	Any	0.00	0.00	f	f	2025-05-29 21:48:52.993686
63	Lily Pad	Beta 1.9	64	Any	0.00	0.00	f	f	2025-05-29 21:48:52.993686
64	Pumpkin	Beta 1.9	64	Any	1.00	1.00	f	t	2025-05-29 21:48:52.993686
65	Jack o Lantern	1.2	64	Any	1.00	1.00	f	t	2025-05-29 21:48:52.993686
66	Cactus	Beta 1.2	64	Any	0.40	0.40	f	t	2025-05-29 21:48:52.993686
67	Sugar Cane	Beta 1.9	64	Any	0.00	0.00	f	f	2025-05-29 21:48:52.993686
68	Melon	Beta 1.8	64	Any	1.00	1.00	f	t	2025-05-29 21:48:52.993686
69	Moss Carpet	1.17	64	Any	0.00	0.00	f	f	2025-05-29 21:48:52.993686
70	Stone Slab	1.0	64	Pickaxe	2.00	6.00	f	t	2025-05-29 21:48:52.993686
71	Wooden Slab	1.0	64	Axe	2.00	3.00	t	t	2025-05-29 21:48:52.993686
72	Nether Brick	Beta 1.9	64	Pickaxe	2.00	6.00	f	t	2025-05-29 21:48:52.993686
73	Quartz Stairs	1.5	64	Pickaxe	0.80	4.00	f	t	2025-05-29 21:48:52.993686
74	Red Nether Brick	1.16	64	Pickaxe	2.00	6.00	f	t	2025-05-29 21:48:52.993686
75	Warped Stem	1.16	64	Axe	2.00	3.00	t	t	2025-05-29 21:48:52.993686
76	Crimson Stem	1.16	64	Axe	2.00	3.00	t	t	2025-05-29 21:48:52.993686
77	Warped Wart Block	1.16	64	Any	1.00	1.00	f	t	2025-05-29 21:48:52.993686
79	Nether Sprouts	1.16	64	Any	0.00	0.00	f	f	2025-05-29 21:48:52.993686
80	Weeping Vines	1.16	64	Any	0.00	0.00	f	f	2025-05-29 21:48:52.993686
81	Twisting Vines	1.16	64	Any	0.00	0.00	f	f	2025-05-29 21:48:52.993686
82	Copper Ore	1.17	64	Pickaxe	3.00	6.00	f	t	2025-05-29 21:48:52.993686
83	Raw Copper Block	1.17	64	Pickaxe	3.00	6.00	f	t	2025-05-29 21:48:52.993686
84	Raw Iron Block	1.17	64	Pickaxe	3.00	6.00	f	t	2025-05-29 21:48:52.993686
85	Raw Gold Block	1.17	64	Pickaxe	3.00	6.00	f	t	2025-05-29 21:48:52.993686
86	Stone Button	1.0	64	Any	0.50	0.50	f	f	2025-05-29 21:48:52.993686
87	Wooden Button	1.0	64	Any	0.50	0.50	t	f	2025-05-29 21:48:52.993686
88	Lever	1.0	64	Any	0.50	0.50	f	f	2025-05-29 21:48:52.993686
89	Anvil	1.4	64	Any	5.00	6000.00	f	t	2025-05-29 21:48:52.993686
94	Dark Prismarine	1.8	64	Pickaxe	1.50	6.00	f	t	2025-05-29 21:48:52.993686
95	Sea Pickle	1.13	64	Any	0.00	0.00	f	f	2025-05-29 21:48:52.993686
100	Polished Basalt	1.16	64	Pickaxe	1.50	6.00	f	t	2025-05-29 21:48:52.993686
\.


--
-- Data for Name: items; Type: TABLE DATA; Schema: public; Owner: gatoaa
--

COPY public.items (id, name, release, stack_size, rarity, creative_category, where_crafted, how_to_obtain, created_at) FROM stdin;
1	Diamond Sword	Classic 0.0.20a	1	Common	Combat	Crafting Table	Crafting with diamonds and stick	2025-05-29 20:35:01.451289
2	Iron Pickaxe	Classic 0.0.20a	1	Common	Tools	Crafting Table	Crafting with iron ingots and sticks	2025-05-29 20:35:01.451289
3	Ender Pearl	Beta 1.8	16	Uncommon	Misc	Not craftable	Dropped by Endermen	2025-05-29 20:35:01.451289
4	Golden Apple	Alpha v1.0.8	64	Rare	Food	Crafting Table	Crafting or found in chests	2025-05-29 20:35:01.451289
5	Bow	Classic 0.0.20a	1	Common	Combat	Crafting Table	Crafting with sticks and string	2025-05-29 20:35:01.451289
6	Bread	Alpha v1.0.8	64	Common	Food	Crafting Table	Crafting with wheat	2025-05-29 20:35:01.451289
7	Redstone	Alpha v1.0.1	64	Common	Redstone	Not craftable	Mining redstone ore	2025-05-29 20:35:01.451289
8	Totem of Undying	1.11	1	Epic	Combat	Not craftable	Dropped by Evokers	2025-05-29 20:35:01.451289
9	Elytra	1.9	1	Epic	Transportation	Not craftable	Found in End Cities	2025-05-29 20:35:01.451289
10	Coal	Classic 0.0.14a	64	Common	Misc	Not craftable	Mining coal ore or smelting wood	2025-05-29 20:35:01.451289
11	Diamond Pickaxe	Classic 0.0.20a	1	Common	Tools	Crafting Table	Crafting with diamonds and sticks	2025-05-29 20:35:01.451289
12	Netherite Sword	1.16	1	Epic	Combat	Smithing Table	Upgrading diamond sword with netherite	2025-05-29 20:35:01.451289
13	Enchanted Book	1.3.1	1	Rare	Misc	Not craftable	Found in structures or trading	2025-05-29 20:35:01.451289
14	Shulker Box	1.11	1	Rare	Decoration	Crafting Table	Crafting with shulker shells and chest	2025-05-29 20:35:01.451289
15	Trident	1.13	1	Rare	Combat	Not craftable	Dropped by Drowned	2025-05-29 20:35:01.451289
66	Copper Ingot	1.17	64	Common	Misc	Smelting	Smelting copper ore	2025-05-29 21:52:53.395165
67	Spyglass	1.17	1	Rare	Tools	Crafting Table	Crafting with copper ingots and amethyst shards	2025-05-29 21:52:53.395165
68	Amethyst Shard	1.17	64	Common	Misc	Mining	Mining amethyst clusters	2025-05-29 21:52:53.395165
69	Netherite Scrap	1.16	64	Common	Misc	Smelting	Smelting ancient debris	2025-05-29 21:52:53.395165
70	Respawn Anchor	1.16	64	Rare	Decoration	Crafting Table	Crafting with crying obsidian and glowstone	2025-05-29 21:52:53.395165
71	Soul Torch	1.16	64	Common	Decoration	Crafting Table	Crafting with soul soil and sticks	2025-05-29 21:52:53.395165
72	Warped Fungus	1.16	64	Common	Food	Not craftable	Found in warped forest biome	2025-05-29 21:52:53.395165
73	Crimson Fungus	1.16	64	Common	Food	Not craftable	Found in crimson forest biome	2025-05-29 21:52:53.395165
74	Shroomlight	1.16	64	Rare	Decoration	Not craftable	Found in nether biomes	2025-05-29 21:52:53.395165
75	Nether Star	1.4	64	Epic	Misc	Not craftable	Dropped by the Wither boss	2025-05-29 21:52:53.395165
76	End Crystal	1.9	64	Rare	Misc	Crafting Table	Crafting with glass, eye of ender, and ghast tear	2025-05-29 21:52:53.395165
77	Dragon Breath	1.9	64	Rare	Misc	Not craftable	Collected during Ender Dragon fight	2025-05-29 21:52:53.395165
78	Honey Bottle	1.15	64	Common	Food	Crafting Table	Collecting honey with a glass bottle	2025-05-29 21:52:53.395165
79	Honeycomb	1.15	64	Common	Misc	Not craftable	Harvested from bee nests or hives	2025-05-29 21:52:53.395165
80	Beehive	1.15	64	Common	Decoration	Crafting Table	Crafting with planks and honeycomb	2025-05-29 21:52:53.395165
81	Crossbow	1.14	1	Rare	Combat	Crafting Table	Crafting with sticks, iron ingots, and string	2025-05-29 21:52:53.395165
82	Firework Rocket	1.4	64	Common	Misc	Crafting Table	Crafting with paper and gunpowder	2025-05-29 21:52:53.395165
83	Firework Star	1.4	64	Rare	Misc	Crafting Table	Crafting with gunpowder and dyes	2025-05-29 21:52:53.395165
84	Saddle	Classic 0.0.14a	1	Rare	Misc	Not craftable	Found in chests or traded with villagers	2025-05-29 21:52:53.395165
85	Lead	1.14	64	Common	Tools	Crafting Table	Crafting with string and slimeball	2025-05-29 21:52:53.395165
86	Name Tag	1.4	64	Rare	Misc	Not craftable	Found in chests or traded with villagers	2025-05-29 21:52:53.395165
88	Honey Block	1.15	64	Common	Blocks	Crafting Table	Crafting with honeycomb and slimeballs	2025-05-29 21:52:53.395165
89	Honeycomb Block	1.15	64	Common	Blocks	Crafting Table	Crafting with honeycomb	2025-05-29 21:52:53.395165
90	Netherite Ingot	1.16	64	Epic	Misc	Smithing Table	Upgrading netherite scrap and gold ingot	2025-05-29 21:52:53.395165
91	Glow Ink Sac	1.17	64	Rare	Misc	Not craftable	Dropped by glowing squids	2025-05-29 21:52:53.395165
92	Copper Ore	1.17	64	Common	Blocks	Mining	Mining copper ore blocks	2025-05-29 21:52:53.395165
93	Raw Copper	1.17	64	Common	Misc	Not craftable	Dropped by mining copper ore	2025-05-29 21:52:53.395165
94	Raw Iron	1.17	64	Common	Misc	Not craftable	Dropped by mining iron ore	2025-05-29 21:52:53.395165
95	Raw Gold	1.17	64	Common	Misc	Not craftable	Dropped by mining gold ore	2025-05-29 21:52:53.395165
96	Raw Copper Block	1.17	64	Common	Blocks	Crafting Table	Crafting with raw copper	2025-05-29 21:52:53.395165
97	Raw Iron Block	1.17	64	Common	Blocks	Crafting Table	Crafting with raw iron	2025-05-29 21:52:53.395165
98	Raw Gold Block	1.17	64	Common	Blocks	Crafting Table	Crafting with raw gold	2025-05-29 21:52:53.395165
99	Bundle	1.17	64	Rare	Misc	Crafting Table	Crafting with rabbit hide and string	2025-05-29 21:52:53.395165
100	Copper Pickaxe	1.17	1	Common	Tools	Crafting Table	Crafting with copper ingots and sticks	2025-05-29 21:52:53.395165
\.


--
-- Data for Name: mobs; Type: TABLE DATA; Schema: public; Owner: gatoaa
--

COPY public.mobs (id, name, release, health, height, behavior, spawn_category, created_at) FROM stdin;
1	Zombie	Classic 0.0.24a	20	1.95	Hostile	Monster	2025-05-29 20:36:19.680871
2	Creeper	Classic 0.0.24a	20	1.70	Hostile	Monster	2025-05-29 20:36:19.680871
3	Cow	Classic 0.0.20a	10	1.40	Passive	Animal	2025-05-29 20:36:19.680871
4	Enderman	Beta 1.8	40	2.90	Neutral	Monster	2025-05-29 20:36:19.680871
5	Skeleton	Classic 0.0.24a	20	1.99	Hostile	Monster	2025-05-29 20:36:19.680871
6	Pig	Classic 0.0.20a	10	0.90	Passive	Animal	2025-05-29 20:36:19.680871
7	Spider	Classic 0.0.24a	16	0.90	Neutral	Monster	2025-05-29 20:36:19.680871
8	Villager	Alpha v1.0.16	20	1.95	Passive	NPC	2025-05-29 20:36:19.680871
9	Iron Golem	1.2.1	100	2.70	Neutral	Utility	2025-05-29 20:36:19.680871
10	Wither	1.4.2	300	3.50	Hostile	Boss	2025-05-29 20:36:19.680871
11	Ender Dragon	Beta 1.9	200	8.00	Hostile	Boss	2025-05-29 20:36:19.680871
12	Sheep	Classic 0.0.20a	8	1.30	Passive	Animal	2025-05-29 20:36:19.680871
13	Chicken	Alpha v1.0.14	4	0.70	Passive	Animal	2025-05-29 20:36:19.680871
14	Witch	1.4.2	26	1.95	Hostile	Monster	2025-05-29 20:36:19.680871
15	Blaze	Beta 1.9	20	1.80	Hostile	Monster	2025-05-29 20:36:19.680871
535	Horse	1.6.1	30	1.60	Passive	Animal	2025-05-29 21:41:28.748443
536	Donkey	1.6.1	30	1.60	Passive	Animal	2025-05-29 21:41:28.748443
537	Mule	1.6.1	30	1.60	Passive	Animal	2025-05-29 21:41:28.748443
538	Ocelot	1.2.1	10	0.70	Passive	Animal	2025-05-29 21:41:28.748443
539	Cat	1.14	10	0.70	Passive	Animal	2025-05-29 21:41:28.748443
540	Wolf	Alpha v1.0.17	20	0.85	Neutral	Animal	2025-05-29 21:41:28.748443
541	Parrot	1.12	6	0.90	Passive	Animal	2025-05-29 21:41:28.748443
542	Rabbit	1.8	3	0.50	Passive	Animal	2025-05-29 21:41:28.748443
543	Bat	1.4.2	6	0.90	Passive	Animal	2025-05-29 21:41:28.748443
544	Squid	Beta 1.2	10	0.80	Passive	Water	2025-05-29 21:41:28.748443
545	Mooshroom	Beta 1.9	10	1.40	Passive	Animal	2025-05-29 21:41:28.748443
546	Snow Golem	Beta 1.9	4	1.90	Passive	Utility	2025-05-29 21:41:28.748443
547	Llama	1.11	30	1.87	Neutral	Animal	2025-05-29 21:41:28.748443
548	Polar Bear	1.10	30	1.40	Neutral	Animal	2025-05-29 21:41:28.748443
549	Cod	1.13	3	0.25	Passive	Water	2025-05-29 21:41:28.748443
550	Salmon	1.13	3	0.35	Passive	Water	2025-05-29 21:41:28.748443
551	Pufferfish	1.13	3	0.35	Passive	Water	2025-05-29 21:41:28.748443
552	Tropical Fish	1.13	3	0.20	Passive	Water	2025-05-29 21:41:28.748443
553	Dolphin	1.13	10	0.60	Neutral	Water	2025-05-29 21:41:28.748443
554	Turtle	1.13	30	0.40	Passive	Animal	2025-05-29 21:41:28.748443
555	Phantom	1.13	20	0.50	Hostile	Monster	2025-05-29 21:41:28.748443
556	Drowned	1.13	20	1.95	Hostile	Monster	2025-05-29 21:41:28.748443
557	Glow Squid	1.17	10	0.80	Passive	Water	2025-05-29 21:41:28.748443
558	Axolotl	1.17	14	0.42	Passive	Water	2025-05-29 21:41:28.748443
559	Slime	Alpha v1.0.11	16	2.04	Hostile	Monster	2025-05-29 21:41:28.748443
560	Magma Cube	Beta 1.9	16	2.04	Hostile	Monster	2025-05-29 21:41:28.748443
561	Ghast	Alpha v1.2.0	10	4.00	Hostile	Monster	2025-05-29 21:41:28.748443
562	Zombified Piglin	Alpha v1.2.0	20	1.95	Neutral	Monster	2025-05-29 21:41:28.748443
563	Silverfish	Beta 1.8	8	0.30	Hostile	Monster	2025-05-29 21:41:28.748443
564	Cave Spider	Beta 1.8	12	0.50	Hostile	Monster	2025-05-29 21:41:28.748443
565	Husk	1.10	20	1.95	Hostile	Monster	2025-05-29 21:41:28.748443
566	Stray	1.10	20	1.99	Hostile	Monster	2025-05-29 21:41:28.748443
567	Wither Skeleton	Beta 1.4	20	2.40	Hostile	Monster	2025-05-29 21:41:28.748443
568	Evoker	1.11	24	1.95	Hostile	Monster	2025-05-29 21:41:28.748443
569	Vindicator	1.11	24	1.95	Hostile	Monster	2025-05-29 21:41:28.748443
570	Vex	1.11	14	0.80	Hostile	Monster	2025-05-29 21:41:28.748443
571	Shulker	1.9	30	1.00	Hostile	Monster	2025-05-29 21:41:28.748443
572	Guardian	1.8	30	0.85	Hostile	Monster	2025-05-29 21:41:28.748443
573	Elder Guardian	1.8	80	1.99	Hostile	Boss	2025-05-29 21:41:28.748443
574	Piglin	1.16	16	1.95	Neutral	Monster	2025-05-29 21:41:28.748443
575	Piglin Brute	1.16	50	1.95	Hostile	Monster	2025-05-29 21:41:28.748443
576	Hoglin	1.16	40	1.40	Hostile	Monster	2025-05-29 21:41:28.748443
577	Zoglin	1.16	40	1.40	Hostile	Monster	2025-05-29 21:41:28.748443
578	Strider	1.16	20	1.70	Passive	Animal	2025-05-29 21:41:28.748443
579	Pillager	1.14	24	1.95	Hostile	Monster	2025-05-29 21:41:28.748443
580	Wandering Trader	1.14	20	1.95	Passive	NPC	2025-05-29 21:41:28.748443
581	Trader Llama	1.14	30	1.87	Neutral	Animal	2025-05-29 21:41:28.748443
582	Fox	1.14	10	0.70	Passive	Animal	2025-05-29 21:41:28.748443
583	Bee	1.15	10	0.60	Neutral	Animal	2025-05-29 21:41:28.748443
584	Panda	1.14	34	1.50	Passive	Animal	2025-05-29 21:41:28.748443
585	Goat	1.17	10	1.30	Neutral	Animal	2025-05-29 21:41:28.748443
586	Allay	1.19	20	0.60	Passive	Utility	2025-05-29 21:41:28.748443
587	Frog	1.19	6	0.50	Passive	Animal	2025-05-29 21:41:28.748443
588	Tadpole	1.19	6	0.30	Passive	Animal	2025-05-29 21:41:28.748443
589	Warden	1.19	500	2.90	Hostile	Boss	2025-05-29 21:41:28.748443
590	Illusioner	1.12	32	1.95	Hostile	Monster	2025-05-29 21:41:28.748443
591	Ravager	1.14	100	2.20	Hostile	Monster	2025-05-29 21:41:28.748443
592	Wither Boss	1.4.2	300	3.50	Hostile	Boss	2025-05-29 21:41:28.748443
593	Tamed Wolf	Alpha v1.0.17	20	0.85	Passive	Utility	2025-05-29 21:41:28.748443
594	Tamed Cat	1.14	10	0.70	Passive	Utility	2025-05-29 21:41:28.748443
595	Tamed Horse	1.6.1	30	1.60	Passive	Utility	2025-05-29 21:41:28.748443
596	Tamed Llama	1.11	30	1.87	Passive	Utility	2025-05-29 21:41:28.748443
597	Tamed Parrot	1.12	6	0.90	Passive	Utility	2025-05-29 21:41:28.748443
598	Baby Zombie	Beta 1.8	20	0.98	Hostile	Monster	2025-05-29 21:41:28.748443
599	Baby Zombie Villager	1.4.2	20	0.98	Hostile	Monster	2025-05-29 21:41:28.748443
600	Zombie Villager	Beta 1.8	20	1.95	Hostile	Monster	2025-05-29 21:41:28.748443
601	Endermite	1.8	8	0.30	Hostile	Monster	2025-05-29 21:41:28.748443
\.


--
-- Name: blocks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: gatoaa
--

SELECT pg_catalog.setval('public.blocks_id_seq', 15, true);


--
-- Name: items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: gatoaa
--

SELECT pg_catalog.setval('public.items_id_seq', 15, true);


--
-- Name: mobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: gatoaa
--

SELECT pg_catalog.setval('public.mobs_id_seq', 602, true);


--
-- Name: blocks blocks_name_key; Type: CONSTRAINT; Schema: public; Owner: gatoaa
--

ALTER TABLE ONLY public.blocks
    ADD CONSTRAINT blocks_name_key UNIQUE (name);


--
-- Name: blocks blocks_pkey; Type: CONSTRAINT; Schema: public; Owner: gatoaa
--

ALTER TABLE ONLY public.blocks
    ADD CONSTRAINT blocks_pkey PRIMARY KEY (id);


--
-- Name: items items_name_key; Type: CONSTRAINT; Schema: public; Owner: gatoaa
--

ALTER TABLE ONLY public.items
    ADD CONSTRAINT items_name_key UNIQUE (name);


--
-- Name: items items_pkey; Type: CONSTRAINT; Schema: public; Owner: gatoaa
--

ALTER TABLE ONLY public.items
    ADD CONSTRAINT items_pkey PRIMARY KEY (id);


--
-- Name: mobs mobs_name_key; Type: CONSTRAINT; Schema: public; Owner: gatoaa
--

ALTER TABLE ONLY public.mobs
    ADD CONSTRAINT mobs_name_key UNIQUE (name);


--
-- Name: mobs mobs_pkey; Type: CONSTRAINT; Schema: public; Owner: gatoaa
--

ALTER TABLE ONLY public.mobs
    ADD CONSTRAINT mobs_pkey PRIMARY KEY (id);


--
-- Name: idx_blocks_name; Type: INDEX; Schema: public; Owner: gatoaa
--

CREATE INDEX idx_blocks_name ON public.blocks USING btree (name);


--
-- Name: idx_items_name; Type: INDEX; Schema: public; Owner: gatoaa
--

CREATE INDEX idx_items_name ON public.items USING btree (name);


--
-- Name: idx_mobs_name; Type: INDEX; Schema: public; Owner: gatoaa
--

CREATE INDEX idx_mobs_name ON public.mobs USING btree (name);


--
-- PostgreSQL database dump complete
--

