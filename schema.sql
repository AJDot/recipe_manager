--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.10
-- Dumped by pg_dump version 9.5.10

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

--
-- Name: execute(text); Type: FUNCTION; Schema: public; Owner: ajdot
--

CREATE FUNCTION execute(text) RETURNS void
    LANGUAGE plpgsql
    AS $_$BEGIN execute $1; END;$_$;


ALTER FUNCTION public.execute(text) OWNER TO ajdot;

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
-- Name: images; Type: TABLE; Schema: public; Owner: ajdot
--

CREATE TABLE images (
    recipe_id integer NOT NULL,
    img_number integer NOT NULL,
    img_filename text NOT NULL,
    CONSTRAINT images_img_number_check CHECK ((img_number > 0))
);


ALTER TABLE images OWNER TO ajdot;

--
-- Name: ingredients; Type: TABLE; Schema: public; Owner: ajdot
--

CREATE TABLE ingredients (
    recipe_id integer NOT NULL,
    ing_number integer NOT NULL,
    description text NOT NULL,
    complete boolean DEFAULT false,
    CONSTRAINT ingredients_ing_number_check CHECK ((ing_number > 0))
);


ALTER TABLE ingredients OWNER TO ajdot;

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
    description text,
    cook_time interval hour to minute,
    CONSTRAINT cook_time_chk CHECK ((cook_time >= '00:00:00'::interval))
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
44	Lunch
45	Soup
46	Midnight Snack
52	Dessert
53	asdfasfdas
54	dfa
55	sdf
56	das
57	fad
58	sf
59	asdfsafd
60	asdf
61	c2
62	adsf
63	c1
64	c3
65	c4
66	c5
67	Appetizer
68	Pickle Bread
69	Apple Butter
70	Awesome Category
71	Apple
72	New Category
73	Chicken
\.


--
-- Name: categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ajdot
--

SELECT pg_catalog.setval('categories_id_seq', 73, true);


--
-- Data for Name: ethnicities; Type: TABLE DATA; Schema: public; Owner: ajdot
--

COPY ethnicities (id, name) FROM stdin;
1	American
66	asfa
67	sdf
68	adsf
69	afd
72	asdf
73	e1
74	asfd
75	e2
76	e3
77	e4
78	e5
50	Mexican
51	Asian
52	Thai
53	Italian
54	French
55	Indonesian
63	Chinese
\.


--
-- Name: ethnicities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ajdot
--

SELECT pg_catalog.setval('ethnicities_id_seq', 78, true);


--
-- Data for Name: images; Type: TABLE DATA; Schema: public; Owner: ajdot
--

COPY images (recipe_id, img_number, img_filename) FROM stdin;
113	1	banana_crumb_muffins.jpg
132	1	bread.jpg
141	1	jamie_minestrone.jpg
142	1	french-onion-chicken-104.jpg
137	1	apple_fritter_bread.jpg
61	1	crockpot_beef_tips_and_gravy.jpg
53	1	angel_chicken.jpg
65	1	polenta_bake_with_shrimp.jpg
52	1	the-word-pizza-written-in-flour_1101-327.jpg
60	1	easy_homemade_french_bread.jpg
79	1	bread.jpg
56	1	julia_child_french_bread.jpg
88	1	red_lentil_vegetable_soup.jpg
\.


--
-- Data for Name: ingredients; Type: TABLE DATA; Schema: public; Owner: ajdot
--

COPY ingredients (recipe_id, ing_number, description, complete) FROM stdin;
63	1	2.0 Tbsp olive oil, extra virgin	f
63	2	2.0 cups white onion, diced	f
63	3	1.0 cup carrots, diced	f
63	4	1.0 cup celery, diced	f
63	5	4.0 cloves garlic, peeled and minced	f
63	6	8.0 cups vegetable or chicken stock	f
63	7	1.0 cup red lentils, rinsed	f
63	8	1.0 15-oz can fire-roasted diced tomatoes	f
63	9	2.0 leaves bay leaves	f
63	10	0.25 tsp thyme, dried	f
63	11	0.25 tsp black pepper, freshly-ground	f
63	12	1.0 pinch red pepper, crushed	f
52	1	3.0 items garlic cloves - minced	f
52	2	3.0 tablespoon olive oil	f
52	3	29.0 ounce tomato puree	f
52	4	28.0 ounce crushed tomatoes	f
52	5	2.0 tablespoon brown sugar	f
52	6	1.0 tablespoon italian seasoning	f
52	7	1.0 teaspoon dried basil	f
52	8	0.5 teaspoon salt	f
52	9	0.5 teaspoon crushed red pepper flakes	f
52	10	2.0 teaspoon dry yeast	f
52	11	1.0 cup warm water	f
52	12	3.0 cup all-purpose flour	f
52	13	1.0 tablespoon sugar	f
52	14	1.0 teaspoon salt	f
63	13	2.0 cups collard greens, roughly chopped	f
50	1	1.5 cup luke warm water	f
50	2	2.0 tablespoon dry active yeast	f
50	3	0.25 cup sugar	f
50	4	1.0 tablespoon olive oil	f
50	5	3.0 cup all-purpose flour	f
127	1	     92: def recipe_name_error(recipe_id, name)	f
77	5	3 scallions, chopped	f
77	6	2 1/2 teaspoons salt	f
77	7	2 teaspoons sugar	f
77	8	1 tablespoon sesame oil	f
77	9	2 tablespoons oil	f
127	2	     93:   this_recipe = Recipe.new({ recipe_id: recipe_id, name: name })	f
127	3	     94:   recipes = @storage.recipes.map { |recipe| Recipe.new(recipe) }	f
127	4	 =>  95:   binding.pry	f
127	5	     96:   if !(1..100).cover? this_recipe.name.size	f
127	6	     97:     'Recipe name must be between 1 and 100 characters.'	f
127	7	     98:   elsif recipes.any? do |recipe|	f
127	8	     99:           # recipe[:name] == name && recipe[:recipe_id] != recipe_id	f
127	9	    100:           this_recipe.name == recipe.name && this_recipe != recipe	f
127	10	    101:         end	f
127	11	    102:     'Recipe name must be unique.'	f
127	12	    103:   end	f
127	13	    104: end	f
137	1	1/3 cup light brown sugar	f
137	2	1 teaspoon ground cinnamon	f
137	3	2/3 cup white sugar	f
137	4	1/2 cup butter softened	f
137	5	2 eggs	f
137	6	1 1/2 teaspoons vanilla extract	f
137	7	1 1/2 cups all-purpose flour	f
137	8	1 3/4 teaspoons baking powder	f
137	9	1/2 cup milk or almond milk	f
137	10	2 apples any kind, peeled and chopped , mixed with 2 tablespoons granulated sugar and 1 teaspoon cinnamon	f
136	1	1 1/2 TBSP butter	f
136	2	1 TBSP extra-virgin olive oil	f
136	3	2 Vidalia onions	f
136	4	1 tsp salt	f
136	5	1/2 tsp black pepper	f
136	6	1/2 tsp sugar	f
136	7	4 c beef broth	f
136	8	2 bay leaves	f
136	9	thyme to taste	f
136	10	french baguette, toasted	f
136	11	Swiss or Gruyere cheese	f
60	1	2.5 cup very warm water	f
60	2	2.0 tablespoon dry active yeast	f
60	3	0.25 cup sugar	f
60	4	1.0 tablespoon oil (vegetable or olive)	f
60	5	6.0 cup all-purpose flour	f
60	6	1.0 tablespoon butter	f
77	10	1/4 teaspoon five spice powder (optional)	f
77	11	1/4 teaspoon white pepper	f
77	12	3 cups shredded or diced roast pork	f
77	13	2 cups cooked shrimp, chopped (optional)	f
77	14	1 package egg roll wrappers (about 24 pieces)	f
77	15	1 egg, beaten	f
77	16	Peanut or vegetable oil, for frying	f
87	1	1 tablespoon olive oil	f
87	2	1 onion, chopped	f
87	3	2 red bell pepper, seeded and chopped	f
87	4	1 jalapeno pepper, seeded and minced	f
87	5	10 fresh mushrooms, quartered	f
87	6	6 roma (plum) tomatoes, diced	f
87	7	1 cup fresh corn kernels	f
87	8	1 teaspoon ground black pepper	f
87	9	1 teaspoon ground cumin	f
87	10	1 tablespoon chili powder	f
87	11	2 (15 ounce) cans black beans, drained and rinsed	f
87	12	1 1/2 cups chicken broth or vegetable broth	f
57	1	1.0 3-lbs brisket beef brisket, trimmed	f
57	2	1.0 tsp salt	f
57	3	0.5 tsp freshly ground black pepper	f
57	4	0.25 cup water	f
57	5	2.0 cup vertically sliced onion	f
57	6	1.5 cup parsnip, chopped	f
57	7	1.0 Tbsp balsamic vinegar	f
57	8	1.0 leaf bay leaf	f
57	9	1.0 12-oz bottle light beer	f
58	1	4.0 chops pork chops, 3/4 inch thick	f
58	2	1.0 tsp Vegetable oil	f
58	3	2.0 Tbsp Brown sugar	f
58	4	0.125 tsp Cinnamon, ground	f
58	5	0.125 tsp Nutmeg, ground	f
58	6	2.0 Tbsp Butter, unsalted	f
58	7	2.0 whole Apples, tart - peeled, cored, sliced	f
58	8	3.0 Tbsp Pecans (optional)	f
62	1	2.0 pieces Boneless skinless chicken breast	f
62	2	4.0 Tbsp Cream cheese	f
62	3	0.25 cup Pepperjack cheese, shredded	f
62	4	2.0 Tbsp Green Onion, chopped	f
62	5	6.0 pieces Bacon	f
55	1	2.0 Tbsp olive oil	f
55	2	1.0 whole onion, peeled and diced	f
55	3	1.0 clove garlic, crushed	f
55	4	2.0 whole carrots, peeled and diced	f
55	5	1.0 lbs ground lamb or beef	f
55	6	1.0 Tbsp tomato paste	f
55	7	1.25 cup lamb or beef stock, heated	f
64	1	2.0 lbs lean beef stew meat	f
64	2	6.0 Tbsp all-purpose flour	f
64	3	2.0 cup carrots, 1-inch thick slices	f
64	4	1.0 16-oz package frozen pearl onions, thawed	f
64	5	1.0 8-oz package mushrooms, stems removed	f
64	6	2.0 cloves garlic, minced	f
64	7	0.75 cup beef broth, fat-free lower-sodium	f
64	8	0.5 cup dry red wine	f
64	9	0.25 cup tomato paste	f
64	10	1.5 tsp salt	f
64	11	0.5 tsp rosemary, dried	f
64	12	0.25 tsp thyme, dried	f
64	13	0.5 tsp black pepper, freshly ground	f
64	14	8.0 oz egg noodle, uncooked	f
64	15	0.25 cup thyme, fresh chopped	f
52	15	1.0 teaspoon olive oil	f
55	8	1.5 cup frozen peas	f
55	9	1.0 to taste Sea salt and freshly ground black pepper	f
55	10	1.0 topping For the Colcannon Topping	f
55	11	2.25 lbs Yukon Gold potatoes	f
56	1	2.25 teaspoon instant yeast	f
56	2	3.5 cup all-purpose flour	f
56	3	2.25 teaspoon salt	f
56	4	1.5 cup warm water	f
55	12	3.5 Tbsp butter, plus more, melted, for brushing	f
77	1	8 cups shredded savoy cabbage	f
66	1	1.0 teaspoon vegetable oil	f
66	2	1.0 4-lbs roast pork shoulder roast	f
66	3	1.0 cup barbeque sauce	f
66	4	0.5 cup apple cider vinegar	f
66	5	0.5 cup chicken broth	f
66	6	0.25 cup light brown suger	f
66	7	1.0 tablespoon yellow mustard	f
66	8	1.0 tablespoon Worchestershire sauce	f
66	9	1.0 tablespoon chili powder	f
66	10	1.0 item onion, chopped	f
66	11	2.0 cloves garlic cloves, crushed	f
66	12	1.5 teaspoons thyme, dried	f
66	13	8.0 buns hamburger buns	f
66	14	2.0 tablespoons butter	f
77	2	8 cups shredded green cabbage	f
53	1	4.0 pieces skinless, boneless chicken breast halves	f
53	2	1.0 Tbsp vegetable oil (optional)	f
53	3	1.0 8-oz package fresh button mushrooms, quartered	f
53	4	1.0 8-oz package fresh shiitake mushrooms, stems removed, caps sliced	f
53	5	0.25 cup butter	f
53	6	1.0 0.7-oz package Italian dry salad dressing mix	f
53	7	1.0 10 3/4-oz can condensed golden mushroom soup	f
53	8	0.5 cup dry white wine	f
53	9	0.5 8-oz tub cream cheese spread with chives and onion	f
53	10	4.0 servings Hot cooked rice or angel hair pasta	f
53	11	4.0 servings Snipped fresh chives or sliced green onions (optional)	f
77	3	2 cups shredded carrot	f
77	4	2 cups shredded celery	f
55	13	1.0 whole leek, finely chopped	f
55	14	0.33 cup milk	f
55	15	0.25 tsp freshly grated nutmeg	f
59	1	1.0 Tbsp Canola Oil	f
59	2	1.0 lbs chicken breasts, skinless, boneless, 1-in pieces	f
59	3	0.75 lbs chicken thighs, skinless, boneless, 1-in pieces	f
59	4	2.0 cup onion, chopped	f
59	5	2.0 cup Green bell pepper, chopped	f
59	6	1.0 cup Celery, chopped	f
59	7	2.0 cloves Garlic, minced	f
65	1	2.0 cup whole milk	f
65	2	2.0 cup water	f
65	3	1.0 cup polenta	f
65	4	3.0 oz Parmesan cheese, grated (about 0.75 cup)	f
65	5	0.5 tsp black pepper	f
65	6	2.0 oz butter, melted, unsalted	f
65	7	1.0 tsp kosher salt, divided	f
65	8	1.0 pound large raw shrimp, peeled and deveined	f
65	9	1.0 cup cherry tomatoes halved	f
65	10	0.5 tsp paprika	f
65	11	2.0 Tbsp scallions, sliced	f
59	8	4.0 oz turkey kielbasa, halved, 1/4-in slices	f
78	1	2 (1-pound) pork tenderloins, trimmed	f
78	2	1/4 cup lower-sodium soy sauce, divided	f
78	3	1 tablespoon hoisin sauce	f
78	4	1 tablespoon tomato sauce	f
78	5	1 teaspoon sugar	f
78	6	1 teaspoon grated peeled fresh ginger	f
78	7	2 garlic cloves, minced	f
78	8	3 tablespoons seasoned rice vinegar	f
78	9	1 teaspoon dark sesame oil	f
78	10	8 cups hot cooked Chinese-style noodles (about 16 ounces uncooked)	f
78	11	1 cup matchstick-cut carrots	f
78	12	3/4 cup diagonally sliced green onions	f
78	13	1/4 cup fresh cilantro leaves	f
78	14	1/3 cup chopped unsalted, dry-roasted peanuts	f
78	15	1/3 cup chopped fresh cilantro	f
78	16	9 lime wedges	f
79	1	2 (.25 ounce) packages active dry yeast	f
79	2	3 tablespoons white sugar	f
79	3	2 1/2 cups warm water (110 degrees F/45 degrees C)	f
79	4	3 tablespoons lard, softened	f
79	5	1 tablespoon salt	f
79	6	6 1/2 cups bread flour	f
87	13	1 teaspoon salt	f
88	1	1 tablespoon olive oil	f
88	2	4 medium carrots, peeled and chopped	f
88	3	1 small onion, chopped	f
88	4	1 teaspoon ground cumin	f
88	5	1 can (14 1/2-ounce) diced tomatoes	f
88	6	1 can (14- to 14 1/2-ounce) vegetable broth	f
88	7	1 cup dried red lentils	f
88	8	1/4 teaspoon salt	f
88	9	1/8 teaspoon ground black pepper	f
88	10	1 bag (5-ounce) baby spinach	f
61	1	1.5 lbs cubed beef (stew meat)	f
61	2	1.0 packet Dry Onion Soup Mix	f
61	3	1.0 can Cream of Mushroom Soup	f
61	4	1.0 14-oz can Beef broth or stock	f
61	5	1.0 to taste Salt & Pepper	f
133	1	1cup (5 ounces) all-purpose flour	f
133	2	1/2cup (1 1/2 ounces) unsweetened cocoa powder	f
133	3	1teaspoon baking powder	f
133	4	1/4teaspoon baking soda	f
133	5	1/2teaspoon salt	f
133	6	1 1/2cups packed (10 1/2 ounces) brown sugar	f
133	7	3large eggs	f
133	8	4teaspoons instant espresso powder (optional)	f
133	9	1teaspoon vanilla extract	f
89	1	1lb apples, peeled, cored, and cut into 1/2in dice.	f
89	2	1 TBSP lemon juice	f
89	3	1/2C unsalted butter	f
89	4	2/3C superfine sugar	f
89	5	2 xl eggs, beaten	f
89	6	2C all purpose flour	f
89	7	3 tsp baking powder	f
89	8	1 tsp ground cinnamon	f
89	9	½ tsp ground nutmeg	f
89	10	3 TBSP hard cider or apple juice	f
89	11	1/3 C all purpose flour	f
89	12	2 TBSP light brown sugar	f
89	13	½ tsp cinnamon	f
89	14	2 TBSP unsalted butter, melted	f
133	10	4ounces unsweetened chocolate, chopped	f
133	11	4tablespoons unsalted butter	f
133	12	1/2cup (3 1/2 ounces) granulated sugar	f
113	1	1 1/2 cups all-purpose flour	f
113	2	1 teaspoon baking soda	f
113	3	1 teaspoon baking powder	f
113	4	1/2 teaspoon salt	f
113	5	3 bananas, mashed	f
113	6	3/4 cup white sugar	f
113	7	1 egg, lightly beaten	f
113	8	1/3 cup butter, melted	f
113	9	1/3 cup packed brown sugar	f
113	10	2 tablespoons all-purpose flour	f
113	11	1/8 teaspoon ground cinnamon	f
113	12	1 tablespoon butter	f
54	1	4.0 cup rotini pasta (measure uncooked)	f
54	2	2.0 tablespoon butter	f
54	3	2.0 tablespoon all-purpose flour	f
54	4	2.5 cup whole milk	f
54	5	1.0 teaspoon Better Than Bullion Chicken Base	f
54	6	1.0 teaspoon Dijon mustard (add up to 1 teaspoon more if you want the mustard flavor stronger)	f
54	7	1.5 teaspoon Worchestershire	f
54	8	0.5 teaspoon salt	f
54	9	0.75 cup chicken, cooked, cubed (I used a rotisserie from the deli)	f
54	10	0.75 cup ham, cubed, cooked	f
54	11	5.0 slice swiss cheese	f
54	12	1.0 cup breadcrumbs*	f
133	13	1/2cup (2 ounces) confectioners' sugar	f
137	11	1/2 cup of powdered sugar	f
137	12	1-3 tablespoons of milk or cream- depending on thickness of glaze wanted	f
59	9	2.0 tsp Cajun seasoning, salt-free	f
59	10	0.5 tsp Thyme, dried	f
59	11	0.25 tsp Spanish smoked paprika (optional)	f
141	1	3 tablespoons olive oil	f
141	2	4 cloves garlic, pressed	f
59	12	2.0 14.5-oz can Tomatoes, diced with onion and green peppers, undrained	f
59	13	1.0 14-oz can Chicken broth, fat-free, lower-sodium	f
59	14	1.0 lbs Shrimp, medium, peeled, deveined	f
59	15	2.0 Tbsp Parsley, fresh, chopped, flat-leaf	f
59	16	1.0 Tbsp Hot sauce	f
141	3	2 onions, chopped	f
141	4	2 cups chopped celery	f
141	5	6 carrots, sliced	f
141	6	2 cups chicken broth	f
141	7	2 cups water	f
141	8	4 cups tomato sauce	f
141	9	1/2 cup red wine (optional)	f
141	10	2 cup canned kidney beans, drained	f
141	11	1 (15 ounce) can green beans	f
141	12	2 cups baby spinach, rinsed	f
141	13	1 zucchini, quartered and sliced	f
141	14	1 tablespoon chopped fresh oregano	f
141	15	2 tablespoons chopped fresh basil	f
141	16	salt and pepper to taste	f
141	17	2 cups seashell pasta	f
141	18	2 tablespoons grated Parmesan cheese for topping	f
142	1	2 medium yellow onions, thinly sliced into rings	f
142	2	3 tablespoons butter	f
142	3	1 cup plus 3 tablespoons beef broth, divided	f
142	4	4 boneless skinless chicken breasts, pounded to even thickness	f
142	5	1 tablespoon oil	f
142	6	salt and pepper, to taste	f
142	7	1 teaspoon Italian blend herbs/Italian seasoning (OR ¼ teaspoon dried basil + ¼ teaspoon dried thyme + ½ teaspoon dried oregano)	f
142	8	2 tablespoons flour	f
142	9	4 slices provolone cheese	f
142	10	4 slices swiss cheese	f
142	11	¾ cup shredded parmesan cheese	f
142	12	fresh thyme or parsley and cracked black pepper for topping (optional)	f
\.


--
-- Data for Name: notes; Type: TABLE DATA; Schema: public; Owner: ajdot
--

COPY notes (recipe_id, note_number, description) FROM stdin;
137	1	Source: http://www.thebakingchocolatess.com/awesome-country-apple-fritter-bread-recipe/
88	1	Recipe courtesy of Good Housekeeping, 2012
137	2	Optional: Next time I think I would add in walnuts. You can always use other fruit, or you could add in chocolate chips too! (Of course!)
137	3	Substitutions: I've also substituted this with 1/2 cup Greek Yogurt, 1/3 cup milk and add 1/4 teaspoon baking soda instead of 1/2 cup milk as called out in the bread loaf ingredients.
137	4	Baking options: Bake 30-40 min. for 2 loaf recipe, 15-20 minutes for muffins or 50 -60 minutes for one full loaf recipe or until toothpick inserted in center comes out clean.
63	1	optional toppings: freshly-grated Parmesan cheese, finely-chopped fresh parsley or basil
61	1	Yield: 4 servings
141	1	Source: http://allrecipes.com/recipe/jamies-minestrone/detail.aspx
133	1	Makes 22 cookies
133	2	Both natural and Dutch-processed cocoa will work in this recipe. Our favorite natural cocoa is Hershey’s Natural Cocoa Unsweetened; our favorite Dutch-processed cocoa is Droste Cocoa. Our preferred unsweetened chocolate is Hershey’s Unsweetened Baking Bar.
55	1	- See more at: http://www.rachaelrayshow.com/recipes/20997_clodagh_mckenna_shepherd_s_pie_with_colcannon_topping/#sthash.Gkaygdcd.dpuf
57	1	Beef brisket is at its best when you simmer it in a slow cooker and flavor it with beer and onions.
57	2	Yield: 12 servings (serving size: about 3 ounces brisket and 1/3 cup sauce)
58	1	Succulent pork loin chops are paired brilliantly with slices of tart apple cooked in a satin-smooth sauce of butter, brown sugar, cinnamon, and nutmeg. A few chopped pecans over the top make this a delectable autumn entree.
59	1	Get ready to serve a crowd! Baguette pieces continue the French-Cajun theme.
59	2	Yield: 8 servings (serving size: 1 1/4 cups)
62	1	One piece of bacon wrapped around each breast is enough, but 2 pieces of bacon for each breast fully wraps the chicken and is outstanding as well.
64	1	Yield: 8 servings (serving size: about 1 1/4 cups beef mixture, 1/2 cup egg noodles, and 1 1/2 teaspoons thyme)
66	1	source: http://allrecipes.com/recipe/92462/slow-cooker-texas-pulled-pork/
66	2	Cook's Note:\r\nThe pork can also be cooked on Low for 10 to 12 hours.\r\n
66	3	Easy Cleanup\r\nTry using a liner in your slow cooker for easier cleanup.
136	1	Prep time: 1 hour
138	1	Here is a link to a thing: https://www.lucidchart.com/documents#docs?folder_id=home&browser=icon&sort=saved-desc
138	2	Here is another link, https://www.postgresql.org/docs/9.1/static/sql-altertable.html, to another thing.
65	1	This Southern-inspired single skillet dinner is warming and hearty—like comfort food all grown up. It’s simple and quick enough for a weeknight, and the whole family will be grateful. Whole milk and Parmesan cheese give the polenta an extra dose of creaminess, and plenty of large tail-on shrimp get tossed in paprika and butter for layers of decadent flavor. For maximum charring with minimal hands-on work, the shrimp and cherry tomatoes are broiled before being added to the skillet. Before serving, the dish gets a smattering of fresh scallions for crunch and a bright green pop of color. Get your skillet (and forks) ready.
138	3	http://ruby-doc.org/core-2.4.2/String.html#method-i-gsub: This is a link at the beginning.
78	1	Yield: 9 servings (serving size: 1 1/3 cups noodle mixture, 1 teaspoon peanuts, 2 teaspoons cilantro, and 1 lime wedge)
142	1	Source: https://www.lecremedelacrumb.com/french-onion-chicken/
142	2	If you do not have an oven-safe skillet, you can use whatever pan you do have for the stove portion of the recipe, then transfer everything to a casserole dish or similar baking pan for the baking portion of the recipe.
\.


--
-- Data for Name: recipes; Type: TABLE DATA; Schema: public; Owner: ajdot
--

COPY recipes (id, name, description, cook_time) FROM stdin;
62	Bacon Wrapped Cream Cheese Stuffed Chicken Breast	No description provided	\N
64	Beef Burgundy with Egg Noodles	No description provided	\N
66	Slow Cooker Texas Pulled Pork	No description provided	\N
65	Polenta Bake with Shrimp	This Southern-inspired single skillet dinner is warming and hearty—like comfort food all grown up. It’s simple and quick enough for a weeknight, and the whole family will be grateful. Whole milk and Parmesan cheese give the polenta an extra dose of creaminess, and plenty of large tail-on shrimp get tossed in paprika and butter for layers of decadent flavor. For maximum charring with minimal hands-on work, the shrimp and cherry tomatoes are broiled before being added to the skillet. Before serving, the dish gets a smattering of fresh scallions for crunch and a bright green pop of color. Get your skillet (and forks) ready.	\N
142	French Onion Chicken	Saucy one pan French onion chicken with juicy pan-seared chicken smothered in caramelized onion gravy and three kinds of melty Italian cheese. This 30 minute meal will be a staple in your house!	00:30:00
137	Awesome Country Apple Fritter Bread	Fluffy, buttery, white cake loaf loaded with chunks of apples and layers of brown sugar and cinnamon swirled inside and on top. Simply Irresistible!	00:00:00
136	French Onion Soup	A warm, flavorful, basic french onion soup.	02:00:00
141	Jamie's Minestrone	Follow the link at the bottom to the original recipe. This recipe has been altered to my liking.	01:50:00
52	Pizza	No description provided	\N
138	Link Recipe		00:00:00
53	Angel Chicken	No description provided	\N
78	Chinese Pork Tenderloin with Garlic-Sauced Noodles	This slow cooker medley of Chinese flavors is a yummy and healthy alternative to take-out. Serve with lime wedges to add zesty flavor.	\N
79	Traditional White Bread	A delicious bread with a very light center with crunchy crust. You may substitute butter or vegetable oil for the lard if you wish.	\N
122	Test 77		03:33:00
61	Crockpot Beef Tips & Gravy	No description provided	00:00:00
56	Julia Child's French Bread	No description provided	\N
113	Banana Crumb Muffins	A basic banana muffin is made extraordinary with a brown sugar crumb topping that will melt in your mouth.	\N
50	Focaccia Bread	No description provided	\N
60	Easy Homemade French Bread	No description provided	\N
54	Chicken Cordon Bleu Pasta Bake	No description provided	\N
116	Test 2		00:20:00
77	Copycat Takeout Egg Rolls		\N
121	Test 6		00:00:00
87	Black Bean Chili	A chili that is best when prepared with fresh vegetables, but still delicious with canned or frozen. Serve by itself or over rice.	\N
88	Red Lentil and Vegetable Soup		\N
89	Apple Cake with Streusel Topping		\N
123	Test 8		109:34:00
63	Italian Lentil Soup	No description provided	00:00:00
119	Test 5		00:02:00
133	Chocolate Crinkle Cookies	These eye-catching cookies are as much about looks as they are about flavor. The problem is, most are neither chocolaty nor crinkley.	00:00:00
55	Shepherds Pie	No description provided	00:00:00
57	Beef Brisket with Beer	No description provided	00:00:00
58	Caramel Apple Pork Chops	No description provided	00:00:00
126	Test 11		00:00:00
132	Test Bread		25:02:00
59	Chicken and Shrimp Jambalaya	No description provided	00:00:00
127	Test 12	Started with run options --seed 57435	12:00:00
\.


--
-- Data for Name: recipes_categories; Type: TABLE DATA; Schema: public; Owner: ajdot
--

COPY recipes_categories (recipe_id, category_id) FROM stdin;
78	2
62	2
64	2
66	2
79	1
56	1
50	1
89	52
142	73
142	2
113	52
113	4
54	2
137	1
137	52
137	71
63	2
63	44
63	45
52	2
53	2
61	2
141	45
133	52
55	2
57	2
58	2
59	2
60	1
65	2
136	45
136	67
\.


--
-- Data for Name: recipes_ethnicities; Type: TABLE DATA; Schema: public; Owner: ajdot
--

COPY recipes_ethnicities (recipe_id, ethnicity_id) FROM stdin;
54	1
63	53
61	1
133	1
52	53
53	1
55	1
57	1
58	1
59	1
65	53
136	54
62	1
64	1
66	1
142	54
137	1
141	53
77	63
87	1
88	1
89	1
\.


--
-- Name: recipes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ajdot
--

SELECT pg_catalog.setval('recipes_id_seq', 143, true);


--
-- Data for Name: steps; Type: TABLE DATA; Schema: public; Owner: ajdot
--

COPY steps (recipe_id, step_number, description, complete) FROM stdin;
136	1	Melt butter in pot, medium heat. Add extra-virgin olive oil.	f
136	2	Cook onions until soft. ~15 mins.	f
136	3	Add salt, pepper, and sugar. Cook until caramelized. ~40 mins.	f
136	4	Add 3/4 cup beef broth. Cook on medium heat until liquid evaporates. ~10 mins.	f
136	5	Add thyme, bay leaves, and remainder broth. Bring to boil then simmer until thicken. ~30-60 min.	f
136	6	Serve with toasted baguette topped with Swiss-like cheese (Gruyere, etc...)	f
133	1	Adjust oven rack to middle position and heat oven to 325 degrees. Line 2 baking sheets with parchment paper. Whisk flour, cocoa, baking powder, baking soda, and salt together in bowl.	f
133	2	Whisk brown sugar; eggs; espresso powder, if using; and vanilla together in large bowl. Combine chocolate and butter in bowl and microwave at 50 percent power, stirring occasionally, until melted, 2 to 3 minutes.	f
133	3	Whisk chocolate mixture into egg mixture until combined. Fold in flour mixture until no dry streaks remain. Let dough sit at room temperature for 10 minutes.	f
133	4	Place granulated sugar and confectioners’ sugar in separate shallow dishes. Working with 2 tablespoons dough (or use #30 scoop) at a time, roll into balls. Drop dough balls directly into granulated sugar and roll to coat. Transfer dough balls to confectioners’ sugar and roll to coat evenly. Evenly space dough balls on prepared sheets, 11 per sheet.	f
133	5	Bake cookies, 1 sheet at a time, until puffed and cracked and edges have begun to set but centers are still soft (cookies will look raw between cracks and seem underdone), about 12 minutes, rotating sheet halfway through baking. Let cool completely on sheet before serving.	f
59	1	Heat a large skillet over high heat. Add oil to pan; swirl to coat. Add chicken; cook 4 minutes, stirring occasionally. Place chicken in an electric slow cooker.	f
59	2	Add onion, bell pepper, celery, and garlic to pan; sauté 4 minutes or until tender. Add onion mixture, turkey kielbasa, and next 5 ingredients (through chicken broth) to slow cooker. Cover and cook on LOW for 5 hours.	f
59	3	Cook rice according to package directions. Add cooked rice and remaining ingredients except parsley garnish to slow cooker. Cover and cook on HIGH 15 minutes or until shrimp are done. Garnish with parsley leaves, if desired.	f
88	1	In 4-quart saucepan, heat oil on medium until hot.	f
88	2	Add carrots and onion, and cook 6 to 8 minutes or until lightly browned and tender.	f
88	3	Stir in cumin; cook 1 minute.	f
88	4	Add tomatoes, broth, lentils, 2 cups water, salt, and pepper; cover and heat to boiling on high.	f
88	5	Reduce heat to low and simmer, covered, 8 to 10 minutes or until lentils are tender.	f
53	1	If you like, brown chicken on both sides in a large skillet in hot oil over medium heat. Combine mushrooms in a 3-1/2- or 4-quart slow cooker; top with chicken. Melt butter in a medium saucepan; stir in Italian dressing mix. Stir in mushroom soup, white wine, and cream cheese until melted; pour over chicken.	f
53	2	Cover; cook on low-heat setting for 4 to 5 hours.	f
53	3	Serve chicken and sauce over cooked rice. Sprinkle with chives, if you like.	f
88	6	Stir in spinach.	f
137	12	To make glaze, mix powdered sugar and milk or cream together until well mixed.	f
113	1	Preheat oven to 375 degrees F (190 degrees C). Lightly grease 10 muffin cups, or line with muffin papers.	f
113	2	In a large bowl, mix together 1 1/2 cups flour, baking soda, baking powder and salt. In another bowl, beat together bananas, sugar, egg and melted butter. Stir the banana mixture into the flour mixture just until moistened. Spoon batter into prepared muffin cups.	f
113	3	In a small bowl, mix together brown sugar, 2 tablespoons flour and cinnamon. Cut in 1 tablespoon butter until mixture resembles coarse cornmeal. Sprinkle topping over muffins.	f
113	4	Bake in preheated oven for 18 to 20 minutes, until a toothpick inserted into center of a muffin comes out clean.	f
137	13	Let cool for about 15 minutes before drizzling with glaze.	f
56	1	In the mixing bowl of a stand mixer using the flat beater, combine the yeast, 2 1/2 cups flour and salt. Mix on low for about 30 seconds.	f
56	2	With the motor running on low, pour in the warm water. Continue mixing until a shaggy forms. Clean off beater and switch to the dough hook. Mix in the remaining of flour a little at a time, to make a soft dough, adding more or less flour needed. Knead the dough for 5 minutes. The surface should be smooth and the dough be soft and somewhat sticky.	f
56	3	Turn the dough onto a kneading surface and let rest for 2 - 3 minutes while you and dry the bowl.	f
56	4	Return the dough to the mixing bowl and let it rise at room temperature (about 75º) 3 1/2 times its original volume. This will probably take about 3 hours.	f
56	5	Deflate the dough and return it to the bowl. Let the dough rise at room temperature not quite tripled in volume, about 1 1/2 - 2 hours.	f
63	1	STOVETOP DIRECTIONS	f
63	2	Heat oil in a large stockpot over medium-high heat.  Add onion, carrots and celery, and saute for 6-7 minutes, stirring occasionally, until the onion is soft and translucent.  Add the garlic and saute for an additional 1-2 minutes until fragrant, stirring occasionally.	f
63	3	Add the stock, lentils, tomatoes, bay leaves, thyme, black pepper, and crushed pepper, and stir to combine.  Continue cooking until the mixture reaches a simmer.	f
63	4	Reduce heat to medium-low and cover the pot partially with the lid.  Keeping the soup at a low simmer, continue cooking for about 25-30 minutes or until the lentils are tender and cooked through, stirring occasionally.	f
63	5	Stir in the collard greens, and continue cooking for 5 minutes or until the greens have softened.	f
63	6	Taste, and season with additional salt and pepper if needed.  Remove the bay leaves.	f
63	7	Serve warm, garnished with optional toppings if desired.	f
63	8	This soup can also be refrigerated in a sealed container for up to 3 days, or frozen for up to 3 months.	f
62	1	Cut chicken into 4 equal size pieces. Pound breasts so it is about 1/4" thick.	f
62	2	Mix together softened cream cheese, chopped green onions and shredded pepperjack cheese. Put 1/4 of this mixture into the middle of each piece of chicken.	f
62	3	Starting at the long side, roll chicken breast up, keeping the cheese mixture to the middle.	f
62	4	Wrap 1 to 2 slices of bacon around the chicken breast, secure with toothpick, if needed.	f
62	5	Place on baking sheet and bake for 30 minutes at 375 F.	f
62	6	Broil topside for about 5 minutes to fully brown and crisp bacon. Turn each breast over and broil for another 3 minutes or so to crisp up the bottom side.	f
62	7	Serve immediately.	f
63	9	SLOW COOKER DIRECTIONS	f
63	10	Add the first 12 ingredients (through the red pepper) to a large 6-quart slow cooker, and stir to combine.  Cook for 4-5 hours on high or 8-10 hours on low, until the lentils are tender and cooked through.	f
63	11	Stir in the collard greens, and continue cooking for 5 minutes or until the greens have softened.	f
78	1	Place tenderloins in a 5-quart electric slow cooker. Combine 1 tablespoon soy sauce and next 5 ingredients (through garlic); drizzle over tenderloins. Cover and cook on LOW for 3 1/2 hours. Remove pork from slow cooker, and place in a large bowl, reserving cooking liquid in slow cooker. Let pork stand 10 minutes.	f
78	2	Strain cooking liquid through a sieve into a bowl. Cover and keep warm. Shred pork with 2 forks.	f
78	3	Return cooking liquid to slow cooker; stir in remaining 3 tablespoons soy sauce, vinegar, and sesame oil. Cover and cook on HIGH 10 minutes. Turn slow cooker off. Add pork, noodles, and next 3 ingredients (through cilantro leaves), tossing to coat. Spoon noodle mixture into bowls; sprinkle with peanuts and chopped cilantro. Serve with lime wedges	f
79	1	In a large bowl, dissolve yeast and sugar in warm water. Stir in lard, salt and two cups of the flour. Stir in the remaining flour, 1/2 cup at a time, beating well after each addition. When the dough has pulled together, turn it out onto a lightly floured surface and knead until smooth and elastic, about 8 minutes.	f
79	2	Lightly oil a large bowl, place the dough in the bowl and turn to coat with oil. Cover with a damp cloth and let rise in a warm place until doubled in volume, about 1 hour.	f
63	12	Taste, and season with additional salt and pepper if needed.  Remove the bay leaves.	f
57	1	Rub brisket with salt and pepper. Heat a large heavy skillet over medium-high heat. Coat pan with cooking spray. Add brisket to pan; cook 10 minutes, browning on all sides. Remove brisket from the pan. Add 1/4 cup water to pan, stirring to loosen browned bits. Add onion and parsnip; sauté 5 minutes or until vegetables are tender.	f
57	2	Place onion mixture, vinegar, bay leaf, and beer in a large electric slow cooker. Place brisket on top of onion mixture. Cover and cook on low for 8 hours. Discard bay leaf. Cut brisket diagonally across the grain into thin slices. Serve with sauce.	f
64	1	Place beef in a large bowl; sprinkle with flour, tossing well to coat. Place beef mixture, carrot, onions, mushrooms, and garlic in an electric slow cooker. Combine beef broth and next 6 ingredients (through pepper); stir into beef mixture. Cover and cook on LOW for 8 hours.	f
64	2	Cook noodles according to package directions, omitting salt and fat. Serve beef mixture over noodles; sprinkle with thyme.	f
52	1	In a large sauce pan, saute garlic in oil until tender. Stir in the remaining ingredients.	f
52	2	Bring to a boil. Reduce heat and simmer uncovered for 30 minutes of until sauce reached desired thickness.	f
66	1	Pour the vegetable oil into the bottom of a slow cooker. Place the pork roast into the slow cooker; pour in the barbecue sauce, apple cider vinegar, and chicken broth. Stir in the brown sugar, yellow mustard, Worcestershire sauce, chili powder, onion, garlic, and thyme. Cover and cook on High until the roast shreds easily with a fork, 5 to 6 hours.	f
66	2	Remove the roast from the slow cooker, and shred the meat using two forks. Return the shredded pork to the slow cooker, and stir the meat into the juices.	f
66	3	Spread the inside of both halves of hamburger buns with butter. Toast the buns, butter side down, in a skillet over medium heat until golden brown. Spoon pork into the toasted buns.	f
52	3	Disolve the yeast in the warm water.	f
52	4	In a large mixing bowl. combine flour, sugar and salt. Make a well in the center of the dry ingredients and pour the olive oil and yeast mixture into it. Stir until it begins to form a ball, then turn it out onto a clean, floured and knead for about 5 minutes.	f
52	5	Lightly oil the ball and the inside of a large glass bowl. Place the into the bowl, cover and let it rise in a warm place until doubled, about hour. For better crust, punch down the dough, reshape into a ball and let it again. (This is where the instructions call to cut the dough to make four pieces but I found the dough was just enough to make one large pizza.)	f
52	6	Transfer to a pizza pan or pizza stone. Bake in a 500 degree oven until crust is golden brown and the cheese is melted 10-13 minutes (My oven left center of the pie soft. You may want to try baking the dough for a little before adding toppings. I had a lot of toppings and sauce, only a little cheese)	f
56	6	Meanwhile, prepare the rising surface: rub flour into canvas or linen towel placed a baking sheet. (I used parchment paper.)	f
56	7	Divide the dough into 3, 6, or 12 pieces depending on the size loaves you wish to. Fold each piece of dough in two, cover loosely, and let the pieces relax for minutes.	f
56	8	Shape the loaves and place them on the prepared towel or parchment. Cover the loaves and let them rise at room temperature until almost triple in volume, about 1/2 - 2 1/2 hours.	f
56	9	Preheat oven to 450º. Set up a "simulated baker's oven" by placing a baking stone the center rack, with a metal broiler pan on the rack beneath, at least 4 inches from the baking stone to prevent the stone from cracking.	f
56	10	Transfer the risen loaves onto a peel.	f
56	11	Slash the loaves.	f
56	12	Spray the loaves with water. Slide the loaves into the oven onto the preheated stone add a cup of hot water to the broiler tray.	f
56	13	Bake for about 25 minutes until golden brown. (If you used parchment paper you will to remove it after about 10-15 minutes to crisp up the bottom crust. Spray loaves with water three times at 3-minute intervals.	f
56	14	Cool for 2 - 3 hours before cutting.	f
77	1	Bring a large pot of water to a boil. Put the cabbage, carrots, and celery into the boiling water and cook for about 2 minutes. Transfer the veggies to an ice bath and drain. Thoroughly squeeze out all the excess water from the vegetables (you can put the drained veggies in a clean kitchen towel and squeeze out the water). This is a very important step because if the filling is too wet, you will have a wet filling and soggy egg rolls!	f
77	2	Once dry, transfer the veggies to a large mixing bowl. Add the scallions, salt, sugar, sesame oil, 2 tablespoons oil, five spice powder (if using), white pepper, roast pork, and cooked shrimp (if using). Toss everything together. The filling is ready to be wrapped!	f
77	3	The way to wrap these egg rolls is to first take a small fistful of filling, squeeze it a little in your hand until it is compressed together, and place it on the wrapper. Check out the photos below to see how to wrap them. Basically, it's similar to the method you'd use to wrap a burrito. Just add a thin layer of egg to make sure it stays sealed. Line them up on a lightly floured surface, and continue assembling until you run out of ingredients.	f
77	4	In a small pot, heat oil to 325 degrees. You don't need too much--just enough to submerge the egg rolls. Carefully place a couple egg rolls into the oil, and fry them for about 5 minutes until golden brown. Keep them moving in the oil to make sure they fry evenly.	f
60	1	In a large bowl, mix together water, yeast, and sugar until the yeast is completely dissolved. Add in salt, oil, and flour. Stir with a large wooden spoon or mixer until it becomes too difficult, then knead for two minutes on a floured surface.	f
60	2	Spray a large bowl with non-stick cooking spray and place dough in the bowl. Cover with a dish towel and let it raise until it doubles in size (I usually place the bread in my kitchen window sill where there is sunlight and it's a little warmer. I have found that on cooler days - like in the winter time - it sometimes takes a little longer to double in size).	f
60	3	Dump dough out onto a floured surface. Cut in half and shape into a smooth, worm-like shape (or a bread loaf shape . . . ha ha!). If you want to get fancy and make your bread look the way that it does in the picture, use a sharp knife and slice about 1/3 of the way down into the bread, opening up little cracks about 2" apart. The cracks will eparate more as they rise and bake.	f
60	4	Place dough loaves on a greased cookie sheet and let rise again until doubled (about 25-30 minutes). Bake at 375 degrees for 20-30 minutes, or until the top is golden brown and the bread sounds hollow when tapped.	f
60	5	Remove bread from oven and rub butter on top.	f
60	6	Makes two loaves of French bread.	f
65	1	Preheat broiler with oven rack 6 inches from heat. Bring the milk and water to a simmer in a 12-inch ovenproof nonstick skillet. Reduce heat to medium; whisk in the polenta and cook, whisking occasionally, until thick and creamy, about 15 minutes. Stir in the Parmesan, pepper, 3 tablespoons of the melted butter, and ½ teaspoon of  the salt.	f
65	2	Toss together the shrimp, tomatoes, paprika, and the remaining butter and salt. Arrange in an even layer over the polenta. Broil until the shrimp are cooked through and just beginning to brown, 3 to 4 minutes. Top with the scallions.	f
50	1	Mix flour water, sugar, and salt.	f
50	2	Add 1/2 tsp olive oil on dough in bowl then knead.	f
50	3	Cover tightly with plastic wrap let rise 1 hour	f
50	4	Brush with another 2 tsp olive oil. Bake at 425 for 25 mins.	f
50	5	Add coarse sea salt, rosemary, etc....	f
77	5	My father used to tell me that frying egg rolls was a fool-proof task. You just slide them gently into the oil, and keep them moving while they are frying. When they're done, they'll "call" you with a slightly louder sizzling noise. That splattering noise is signaling that the filling is getting hot inside. The steam is escaping, causing the oil to bubble up.	f
77	6	You can serve them after they've cooled a bit. Freeze leftovers in freezer bags and reheat them in the oven.	f
142	1	Preheat oven to bake at 400 degrees OR broil on low. In a large oven-safe skillet (see note) over medium-high heat, melt butter. Add onions and 3 tablespoons beef broth and saute onions for 3-4 minutes until translucent. Continue to cook, stirring occasionally so the onions don't burn, for about 15 minutes longer until browned and very tender. Use tongs or a fork to transfer to a bowl and cover to keep warm.	f
79	3	Deflate the dough and turn it out onto a lightly floured surface. Divide the dough into two equal pieces and form into loaves. Place the loaves into two lightly greased 9x5 inch loaf pans. Cover the loaves with a damp cloth and let rise until doubled in volume, about 40 minutes.	f
79	4	Preheat oven to 425 degrees F (220 degrees C).	f
79	5	Bake at 375 degrees F (190 degrees C) for about 30 minutes or until the top is golden brown and the bottom of the loaf sounds hollow when tapped.	f
142	2	While onions are cooking, prepare the chicken by drizzling with oil, then seasoning with salt and pepper (to taste) and Italian herbs. Once onions have finished cooking and are removed from the pan, cook chicken for 4-5 minutes on each side (don't clean out the pan between the onions and chicken) until browned on both sides. (Chicken may not be fully cooked through yet, that is okay).	f
137	1	Preheat oven to 350 degrees. Use a 9x5-inch loaf pan and spray with non-stick spray or line with foil and spray with non-stick spray to get out easily for slicing.	f
137	2	Mix brown sugar and cinnamon together in a bowl. Set aside.	f
137	3	In another medium-sized bowl, beat white sugar and butter together using an electric mixer until smooth and creamy.	f
54	1	Preheat oven to 350 degrees.	f
54	2	Prepare a 1 1/2 quart baking dish by spraying with nonstick spray. Set aside.	f
54	3	Boil water for pasta in a large pot, and cook pasta according to directions. While you are waiting for the pasta to cook, you can start on the sauce.	f
54	4	In a medium pan, melt butter over medium high heat.	f
54	5	Whisk in flour and cook for a few minutes. The flour will be bubbly.	f
54	6	Gradually whisk in the milk and whisk frequently until it comes to a gentle boil.	f
54	7	Whisk in chicken base, dijon mustard, Worchestershire, and sale.	f
54	8	Whisk for a few more minutes until the sauce starts to thicken slightly.	f
54	9	When the pasta is cooked, drain the water and return to the pan. Stir in the sauce, chicken, and ham and mix to combine.	f
54	10	Pour half of the pasta mixture into your prepared baking dish. Place slices of swiss cheese evenly over the pasta. Pour the rest of the past over the cheese and spread evenly.	f
54	11	Sprinkle breadcrumbs over the top of the pasta.	f
54	12	12. Bake for 20-25 minutes. The top will be golden brown and the edges bubbly.	f
54	13	Allow to set for a few minutes before serving.	f
54	14	* To make your own breadcrumbs, place a crusty dinner roll or large slice of french bread torn into pieces in a blender or food processor, and pulse. I like to keep a few dinner rolls in the freezer so I can take out one at a time if a recipe calls for breadcrumbs. I added 1 teaspoon of dried parsley to mine.	f
137	4	Beat in eggs, 1 at a time, until blended in; add in vanilla extract.	f
58	1	Preheat over to 175 F (80 C). Place a medium dish in the over to warm.	f
58	2	heat a large skillet over medium-high heat. Brush chops lightly with oil and place in hot pan. Cook for 5 to 6 minutes, turning occasionally, or until done. Transfer to the warm dish and keep warm in the preheated oven.	f
58	3	In a small bowl, combine brown sugar, salt and pepper to taste, cinnamon, and nutmeg. Add butter to skillet and stir in brown sugar mixture and apples. Cover and cook until apples are just tender. Remove apples with a slotted spoon and arrange on top of chops. Keep warm in the preheated oven.	f
58	4	Continue cooking sauce uncovered in skillet until thickened slightly. Spoon sauce over apples and chops. Sprinkle with pecans.	f
61	1	Add beef cubes to Crockpot, season with salt & pepper.	f
87	1	Heat oil in a large saucepan over medium-high heat. Saute the onion, red bell peppers, jalapeno, mushrooms, tomatoes and corn for 10 minutes or until the onions are translucent. Season with black pepper, cumin, and chili powder. Stir in the black beans, chicken or vegetable broth, and salt. Bring to a boil.	f
87	2	Reduce heat to medium low. Remove 1 1/2 cups of the soup to food processor or blender; puree and stir the bean mixture back into the soup. Serve hot by itself or over rice.	f
89	1	Grease 8 in round and line with parchment paper. 	f
89	2	Toss apples in lemon juice	f
89	3	Cream butter and sugar until fluffy then add eggs. Sift flour, baking powder, cinnamon, and nutmeg. Fold into mixture using spoon. Stir in hard cider. Stir apples until evenly distributed. Pour into pan. 	f
89	4	Combine flour, brown sugar, and cinnamon then stir in melted butter until crumbly. Spread over cake	f
61	2	In bowl combine soup mix, soup & broth, stir to combine.	f
61	3	Dump mixed ingredients over top of beef, stir.	f
61	4	Cook on low 6-8 hours.	f
61	5	***If you are freezing, dump all ingredients into gallon sized freezer bag***	f
141	1	In a large stock pot, over medium-low heat, heat olive oil and sauté garlic for 2 to 3 minutes. Add onion and sauté for 4 to 5 minutes. Add celery and carrots, sauté for 1 to 2 minutes.	f
55	1	Place a casserole dish over medium heat and add the olive oil. When the oil is hot, add the onion, garlic and carrots then cover. Reduce the heat and let sweat for 5 minutes.	f
55	2	Remove the lid and increase the heat to high. Add the ground lamb and cook until browned then stir in the tomato paste, hot stock and frozen peas. Season with salt and black pepper, and simmer over low heat for 15 minutes.	f
55	3	Meanwhile, make the colcannon topping: Place the potatoes, whole and unpeeled, in a saucepan with the largest ones at the bottom and fill the pan halfway with water. Cover the pan and place over high heat. When the water begins to boil, drain off about half of it, leaving just enough for the potatoes to steam. When the potatoes are cooked, about 30-40 minutes depending on their size, drain and peel (hold them in a kitchen towel if they are too hot to handle). Place in a warm bowl.	f
55	4	In a saucepan, heat the butter over low to medium heat until melted then stir in the leeks. Cover and cook for 2-3 minutes. Remove the lid and stir in the milk and nutmeg. Heat until the milk has warmed through.	f
55	5	Mash the potatoes, gradually adding the warm milk and leek mixture. Season to taste with salt and black pepper.	f
55	6	Transfer the lamb mixture to a medium-size pie dish and spoon the colcannon topping over it. Brush the top with melted butter to get a crispy golden finish. Bake in the oven for 25 minutes and serve.	f
132	1	Butt	f
132	2	asdf	f
141	2	Add chicken broth, water and tomato sauce, bring to boil, stirring frequently. If desired add red wine at this point. Reduce heat to low and add kidney beans, green beans, spinach leaves, zucchini, oregano, basil, salt and pepper. Simmer for 30 to 40 minutes, the longer the better.	f
89	5	Bake for 1-1 ¼ hours at 350 until firm and golden brown.	f
141	3	Fill a medium saucepan with water and bring to a boil. Add macaroni and cook until tender. Drain water and set aside.	f
141	4	Once pasta is cooked and soup is heated, through place 2 tablespoons cooked pasta into individual serving bowls (Personally, I mix all the pasta in all the soup). Ladle soup on top of pasta and sprinkle Parmesan cheese on top and serve.	f
142	3	Transfer chicken to a plate and cover to keep warm and return the onions to the pan. Sprinkle flour over the onions and stir for 1 minute over medium-high heat. Add beef broth and continue to cook, stirring throughout, until mixture comes to a boil. Season with salt and pepper to taste. Return chicken to pan and spoon some of the sauce over each piece of chicken.	f
142	4	Top chicken with one slice of provolone each, then one slice of swiss, then ¼ of the parmesan cheese. Transfer skillet to your preheated oven and cook for about 10 minutes until chicken is cooked through completely and cheeses are melted.	f
142	5	Spoon some of the onions and gravy over the top of the chicken, garnish with thyme or parsley and cracked black pepper, and serve.	f
137	5	Combine & whisk flour and baking powder together in another bowl and add into creamed butter mixture and stir until blended.	f
137	6	Mix milk into batter until smooth.	f
137	7	Pour half the batter into the prepared loaf pan; add half the apple mixture, then half the brown sugar/cinnamon mixture.	f
137	8	Lightly pat apple mixture into batter.	f
137	9	Pour the remaining batter over apple layer and top with remaining apple mixture, then the remaining brown sugar/cinnamon mixture.	f
137	10	Lightly pat apples into batter; swirl brown sugar mixture through apples using knife or spoon.	f
137	11	Bake in the preheated oven until a toothpick inserted in the center of the loaf comes out clean, approximately 50-60 minutes.	f
\.


--
-- Name: categories_pkey; Type: CONSTRAINT; Schema: public; Owner: ajdot
--

ALTER TABLE ONLY categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: category_name_key; Type: CONSTRAINT; Schema: public; Owner: ajdot
--

ALTER TABLE ONLY categories
    ADD CONSTRAINT category_name_key UNIQUE (name);


--
-- Name: ethnicities_pkey; Type: CONSTRAINT; Schema: public; Owner: ajdot
--

ALTER TABLE ONLY ethnicities
    ADD CONSTRAINT ethnicities_pkey PRIMARY KEY (id);


--
-- Name: ethnicity_name_key; Type: CONSTRAINT; Schema: public; Owner: ajdot
--

ALTER TABLE ONLY ethnicities
    ADD CONSTRAINT ethnicity_name_key UNIQUE (name);


--
-- Name: images_pkey; Type: CONSTRAINT; Schema: public; Owner: ajdot
--

ALTER TABLE ONLY images
    ADD CONSTRAINT images_pkey PRIMARY KEY (recipe_id, img_number);


--
-- Name: ingredients_pkey; Type: CONSTRAINT; Schema: public; Owner: ajdot
--

ALTER TABLE ONLY ingredients
    ADD CONSTRAINT ingredients_pkey PRIMARY KEY (recipe_id, ing_number);


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
-- Name: images_recipe_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ajdot
--

ALTER TABLE ONLY images
    ADD CONSTRAINT images_recipe_id_fkey FOREIGN KEY (recipe_id) REFERENCES recipes(id) ON DELETE CASCADE;


--
-- Name: ingredients_recipe_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ajdot
--

ALTER TABLE ONLY ingredients
    ADD CONSTRAINT ingredients_recipe_id_fkey FOREIGN KEY (recipe_id) REFERENCES recipes(id) ON DELETE CASCADE;


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

