--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.2
-- Dumped by pg_dump version 9.6.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: intervals; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE intervals (
    id integer NOT NULL,
    months integer NOT NULL,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    user_id integer NOT NULL
);


--
-- Name: intervals_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE intervals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: intervals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE intervals_id_seq OWNED BY intervals.id;


--
-- Name: products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE products (
    id integer NOT NULL,
    code character varying(255) NOT NULL,
    "desc" text NOT NULL,
    interval_id integer NOT NULL,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    qty integer NOT NULL,
    user_id integer NOT NULL
);


--
-- Name: products_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE products_id_seq OWNED BY products.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp without time zone
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE users (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    username character varying(255) NOT NULL,
    password_hash character varying(255) NOT NULL,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: intervals id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY intervals ALTER COLUMN id SET DEFAULT nextval('intervals_id_seq'::regclass);


--
-- Name: products id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY products ALTER COLUMN id SET DEFAULT nextval('products_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: intervals intervals_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY intervals
    ADD CONSTRAINT intervals_pkey PRIMARY KEY (id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: intervals_user_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX intervals_user_id_index ON intervals USING btree (user_id);


--
-- Name: products_interval_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX products_interval_id_index ON products USING btree (interval_id);


--
-- Name: products_user_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX products_user_id_index ON products USING btree (user_id);


--
-- Name: users_username_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX users_username_index ON users USING btree (username);


--
-- Name: intervals intervals_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY intervals
    ADD CONSTRAINT intervals_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: products products_interval_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY products
    ADD CONSTRAINT products_interval_id_fkey FOREIGN KEY (interval_id) REFERENCES intervals(id);


--
-- Name: products products_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY products
    ADD CONSTRAINT products_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id);


--
-- PostgreSQL database dump complete
--

INSERT INTO "schema_migrations" (version) VALUES (20170223151856), (20170227032628), (20170227034542), (20170228035101), (20170228114947), (20170228120346), (20170305173744), (20170305180759), (20170305182326), (20170311120709);

