--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.9
-- Dumped by pg_dump version 9.5.9

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: categories; Type: TABLE; Schema: public; Owner: ajdot
--

CREATE TABLE categories (
    id integer NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE categories OWNER TO ajdot;

--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: ajdot
--

CREATE SEQUENCE categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE categories_id_seq OWNER TO ajdot;

--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ajdot
--

ALTER SEQUENCE categories_id_seq OWNED BY categories.id;


--
-- Name: ethnicities; Type: TABLE; Schema: public; Owner: ajdot
--

CREATE TABLE ethnicities (
    id integer NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE ethnicities OWNER TO ajdot;

--
-- Name: ethnicities_id_seq; Type: SEQUENCE; Schema: public; Owner: ajdot
--

CREATE SEQUENCE ethnicities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ethnicities_id_seq OWNER TO ajdot;

--
-- Name: ethnicities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ajdot
--

ALTER SEQUENCE ethnicities_id_seq OWNED BY ethnicities.id;


--
-- Name: ingredients; Type: TABLE; Schema: public; Owner: ajdot
--

CREATE TABLE ingredients (
    id integer NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE ingredients OWNER TO ajdot;

--
-- Name: ingredients_id_seq; Type: SEQUENCE; Schema: public; Owner: ajdot
--

CREATE SEQUENCE ingredients_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ingredients_id_seq OWNER TO ajdot;

--
-- Name: ingredients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ajdot
--

ALTER SEQUENCE ingredients_id_seq OWNED BY ingredients.id;


--
-- Name: notes; Type: TABLE; Schema: public; Owner: ajdot
--

CREATE TABLE notes (
    recipe_id integer NOT NULL,
    note_number integer NOT NULL,
    description text NOT NULL,
    CONSTRAINT notes_note_number_check CHECK ((note_number > 0))
);


ALTER TABLE notes OWNER TO ajdot;

--
-- Name: recipes; Type: TABLE; Schema: public; Owner: ajdot
--

CREATE TABLE recipes (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    description text DEFAULT 'No description provided'::text
);


ALTER TABLE recipes OWNER TO ajdot;

--
-- Name: recipes_categories; Type: TABLE; Schema: public; Owner: ajdot
--

CREATE TABLE recipes_categories (
    recipe_id integer NOT NULL,
    category_id integer NOT NULL
);


ALTER TABLE recipes_categories OWNER TO ajdot;

--
-- Name: recipes_ethnicities; Type: TABLE; Schema: public; Owner: ajdot
--

CREATE TABLE recipes_ethnicities (
    recipe_id integer NOT NULL,
    ethnicity_id integer NOT NULL
);


ALTER TABLE recipes_ethnicities OWNER TO ajdot;

--
-- Name: recipes_id_seq; Type: SEQUENCE; Schema: public; Owner: ajdot
--

CREATE SEQUENCE recipes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE recipes_id_seq OWNER TO ajdot;

--
-- Name: recipes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ajdot
--

ALTER SEQUENCE recipes_id_seq OWNED BY recipes.id;


--
-- Name: recipes_ingredients; Type: TABLE; Schema: public; Owner: ajdot
--

CREATE TABLE recipes_ingredients (
    recipe_id integer NOT NULL,
    ingredient_id integer NOT NULL,
    amount numeric(6,2) NOT NULL,
    unit character varying(50) NOT NULL,
    complete boolean DEFAULT false,
    CONSTRAINT recipes_ingredients_amount_check CHECK ((amount > (0)::numeric))
);


ALTER TABLE recipes_ingredients OWNER TO ajdot;

--
-- Name: steps; Type: TABLE; Schema: public; Owner: ajdot
--

CREATE TABLE steps (
    recipe_id integer NOT NULL,
    step_number integer NOT NULL,
    description text NOT NULL,
    complete boolean DEFAULT false,
    CONSTRAINT steps_step_number_check CHECK ((step_number > 0))
);


ALTER TABLE steps OWNER TO ajdot;

--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ajdot
--

ALTER TABLE ONLY categories ALTER COLUMN id SET DEFAULT nextval('categories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ajdot
--

ALTER TABLE ONLY ethnicities ALTER COLUMN id SET DEFAULT nextval('ethnicities_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ajdot
--

ALTER TABLE ONLY ingredients ALTER COLUMN id SET DEFAULT nextval('ingredients_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ajdot
--

ALTER TABLE ONLY recipes ALTER COLUMN id SET DEFAULT nextval('recipes_id_seq'::regclass);


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: ajdot
--

COPY categories (id, name) FROM stdin;
1	Bread
2	Dinner
4	Breakfast
6	Brunch
7	Snack
\.


--
-- Name: categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ajdot
--

SELECT pg_catalog.setval('categories_id_seq', 43, true);


--
-- Data for Name: ethnicities; Type: TABLE DATA; Schema: public; Owner: ajdot
--

COPY ethnicities (id, name) FROM stdin;
1	American
50	Mexican
51	Asian
52	Thai
\.


--
-- Name: ethnicities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ajdot
--

SELECT pg_catalog.setval('ethnicities_id_seq', 52, true);


--
-- Data for Name: ingredients; Type: TABLE DATA; Schema: public; Owner: ajdot
--

COPY ingredients (id, name) FROM stdin;
1	luke warm water
2	dry active yeast
3	sugar
4	olive oil
5	all-purpose flour
6	cubed beef (stew meat)
7	dry onion soup mix
8	cream of mushroom soup
9	beef broth or stock
10	salt
11	pepper
15	ing 1
16	ing 2
17	ing 3
18	skinless, boneless chicken breast halves
19	vegetable oil (optional)
20	fresh button mushrooms, quartered
21	fresh shiitake mushrooms, stems removed, caps sliced
22	butter
23	Italian dry salad dressing mix
24	condensed golden mushroom soup
25	dry white wine
26	cream cheese spread with chives and onion
27	Hot cooked rice or angel hair pasta
28	Snipped fresh chives or sliced green onions (optional)
\.


--
-- Name: ingredients_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ajdot
--

SELECT pg_catalog.setval('ingredients_id_seq', 28, true);


--
-- Data for Name: notes; Type: TABLE DATA; Schema: public; Owner: ajdot
--

COPY notes (recipe_id, note_number, description) FROM stdin;
2	1	Yield: 4 servings
29	1	This is note # 1.
29	2	This is note # 2.
29	3	This is note # 3.
29	4	This is note # 4.
\.


--
-- Data for Name: recipes; Type: TABLE DATA; Schema: public; Owner: ajdot
--

COPY recipes (id, name, description) FROM stdin;
1	Focaccia Bread	No description provided
2	Crockpot Beef Tips & Gravy	No description provided
29	Full Recipe	Full description: This recipe is the best recipe you will ever read, contemplate, make, eat, AND clean up. It is so good
31	Angel Chicken	Chicken and fresh mushrooms slow-cook in cream cheese, wine and soup. It's easy to put together but tastes like chicken in a complex cream sauce--smooth with delicate seasoning.
\.


--
-- Data for Name: recipes_categories; Type: TABLE DATA; Schema: public; Owner: ajdot
--

COPY recipes_categories (recipe_id, category_id) FROM stdin;
1	1
2	2
29	1
29	2
29	4
29	6
29	7
31	2
\.


--
-- Data for Name: recipes_ethnicities; Type: TABLE DATA; Schema: public; Owner: ajdot
--

COPY recipes_ethnicities (recipe_id, ethnicity_id) FROM stdin;
2	1
29	1
29	51
29	52
\.


--
-- Name: recipes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ajdot
--

SELECT pg_catalog.setval('recipes_id_seq', 31, true);


--
-- Data for Name: recipes_ingredients; Type: TABLE DATA; Schema: public; Owner: ajdot
--

COPY recipes_ingredients (recipe_id, ingredient_id, amount, unit, complete) FROM stdin;
1	1	1.50	cup	f
1	2	2.00	tablespoon	f
1	3	0.25	cup	f
1	4	1.00	tablespoon	f
1	5	3.00	cup	f
2	6	1.50	lbs	f
2	7	1.00	packet	f
2	8	1.00	can	f
2	9	1.00	14-oz can	f
2	10	1.00	to taste	f
2	11	1.00	to-taste	f
29	15	10.00	test unit 1	f
29	16	20.00	test unit 2	f
29	17	30.00	test unit 3	f
31	18	4.00	pieces	f
31	19	1.00	Tbsp	f
31	20	1.00	8-oz package	f
31	21	1.00	8-oz package	f
31	22	0.25	cup	f
31	23	1.00	0.7-oz package	f
31	24	1.00	10 3/4-oz can	f
31	25	0.50	cup	f
31	26	0.50	8-oz tub	f
31	27	4.00	servings	f
31	28	4.00	servings	f
\.


--
-- Data for Name: steps; Type: TABLE DATA; Schema: public; Owner: ajdot
--

COPY steps (recipe_id, step_number, description, complete) FROM stdin;
1	1	Mix flour, water, sugar, and salt.	f
1	2	Add 1/2 tsp olive oil on dough in bowl then knead.	f
1	3	Cover tightly with plastic wrap and let rise for 1 hour.	f
1	4	Brush with another 2 tsp olive oil. Bake at 425 for 25 mins	f
1	5	Add coarse sea salt, rosemary, etc....	f
2	1	Add beef cubes to Crockpot, season with salt & pepper.	f
2	2	In bowl combine soup mix, soup & broth, stir to combine.	f
2	3	Dump mixed ingredients over top of beef, stir.	f
2	4	Cook on low 6-8 hours.	f
2	5	***If you are freezing, dump all ingredients into gallon sized freezer bag***	f
29	1	This is step # 1.	f
29	2	This is step # 2.	f
29	3	This is step # 3.	f
29	4	This is step # 4.	f
31	1	If you like, brown chicken on both sides in a large skillet in hot oil over medium heat. Combine mushrooms in a 3-1/2- or 4-quart slow cooker; top with chicken. Melt butter in a medium saucepan; stir in Italian dressing mix. Stir in mushroom soup, white wine, and cream cheese until melted; pour over chicken.	f
31	2	Cover; cook on low-heat setting for 4 to 5 hours.	f
31	3	Serve chicken and sauce over cooked rice. Sprinkle with chives, if you like.	f
\.


--
-- Name: categories_pkey; Type: CONSTRAINT; Schema: public; Owner: ajdot
--

ALTER TABLE ONLY categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: ethnicities_pkey; Type: CONSTRAINT; Schema: public; Owner: ajdot
--

ALTER TABLE ONLY ethnicities
    ADD CONSTRAINT ethnicities_pkey PRIMARY KEY (id);


--
-- Name: ingredients_pkey; Type: CONSTRAINT; Schema: public; Owner: ajdot
--

ALTER TABLE ONLY ingredients
    ADD CONSTRAINT ingredients_pkey PRIMARY KEY (id);


--
-- Name: notes_pkey; Type: CONSTRAINT; Schema: public; Owner: ajdot
--

ALTER TABLE ONLY notes
    ADD CONSTRAINT notes_pkey PRIMARY KEY (recipe_id, note_number);


--
-- Name: recipes_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: ajdot
--

ALTER TABLE ONLY recipes_categories
    ADD CONSTRAINT recipes_categories_pkey PRIMARY KEY (recipe_id, category_id);


--
-- Name: recipes_ethnicities_pkey; Type: CONSTRAINT; Schema: public; Owner: ajdot
--

ALTER TABLE ONLY recipes_ethnicities
    ADD CONSTRAINT recipes_ethnicities_pkey PRIMARY KEY (recipe_id, ethnicity_id);


--
-- Name: recipes_ingredients_pkey; Type: CONSTRAINT; Schema: public; Owner: ajdot
--

ALTER TABLE ONLY recipes_ingredients
    ADD CONSTRAINT recipes_ingredients_pkey PRIMARY KEY (recipe_id, ingredient_id);


--
-- Name: recipes_pkey; Type: CONSTRAINT; Schema: public; Owner: ajdot
--

ALTER TABLE ONLY recipes
    ADD CONSTRAINT recipes_pkey PRIMARY KEY (id);


--
-- Name: steps_pkey; Type: CONSTRAINT; Schema: public; Owner: ajdot
--

ALTER TABLE ONLY steps
    ADD CONSTRAINT steps_pkey PRIMARY KEY (recipe_id, step_number);


--
-- Name: notes_recipes_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ajdot
--

ALTER TABLE ONLY notes
    ADD CONSTRAINT notes_recipes_id_fkey FOREIGN KEY (recipe_id) REFERENCES recipes(id) ON DELETE CASCADE;


--
-- Name: recipes_categories_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ajdot
--

ALTER TABLE ONLY recipes_categories
    ADD CONSTRAINT recipes_categories_category_id_fkey FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE;


--
-- Name: recipes_categories_recipe_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ajdot
--

ALTER TABLE ONLY recipes_categories
    ADD CONSTRAINT recipes_categories_recipe_id_fkey FOREIGN KEY (recipe_id) REFERENCES recipes(id) ON DELETE CASCADE;


--
-- Name: recipes_ethnicities_ethnicity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ajdot
--

ALTER TABLE ONLY recipes_ethnicities
    ADD CONSTRAINT recipes_ethnicities_ethnicity_id_fkey FOREIGN KEY (ethnicity_id) REFERENCES ethnicities(id) ON DELETE CASCADE;


--
-- Name: recipes_ethnicities_recipe_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ajdot
--

ALTER TABLE ONLY recipes_ethnicities
    ADD CONSTRAINT recipes_ethnicities_recipe_id_fkey FOREIGN KEY (recipe_id) REFERENCES recipes(id) ON DELETE CASCADE;


--
-- Name: recipes_ingredients_ingredient_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ajdot
--

ALTER TABLE ONLY recipes_ingredients
    ADD CONSTRAINT recipes_ingredients_ingredient_id_fkey FOREIGN KEY (ingredient_id) REFERENCES ingredients(id) ON DELETE CASCADE;


--
-- Name: recipes_ingredients_recipe_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ajdot
--

ALTER TABLE ONLY recipes_ingredients
    ADD CONSTRAINT recipes_ingredients_recipe_id_fkey FOREIGN KEY (recipe_id) REFERENCES recipes(id) ON DELETE CASCADE;


--
-- Name: steps_recipes_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ajdot
--

ALTER TABLE ONLY steps
    ADD CONSTRAINT steps_recipes_id_fkey FOREIGN KEY (recipe_id) REFERENCES recipes(id) ON DELETE CASCADE;


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

