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
-- Name: recipe_manager; Type: DATABASE; Schema: -; Owner: ajdot
--

CREATE DATABASE recipe_manager WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.UTF-8' LC_CTYPE = 'en_US.UTF-8';


ALTER DATABASE recipe_manager OWNER TO ajdot;

\connect recipe_manager

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
    description character varying(100) NOT NULL,
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
