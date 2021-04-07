--
-- PostgreSQL database dump
--

-- Dumped from database version 12.5 (Debian 12.5-1.pgdg100+1)
-- Dumped by pg_dump version 12.5 (Debian 12.5-1.pgdg100+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: btree_gin; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS btree_gin WITH SCHEMA public;


--
-- Name: EXTENSION btree_gin; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION btree_gin IS 'support for indexing common datatypes in GIN';


--
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;


--
-- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';


--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


--
-- Name: messages_trigger(); Type: FUNCTION; Schema: public; Owner: saleor
--

CREATE FUNCTION public.messages_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
            begin
              new.search_vector :=
                 setweight(
                 to_tsvector('pg_catalog.english', coalesce(new.name,'')), 'A'
                 ) ||
                 setweight(
                 to_tsvector(
                 'pg_catalog.english', coalesce(new.description_plaintext,'')),
                 'B'
                 );
              return new;
            end
            $$;


ALTER FUNCTION public.messages_trigger() OWNER TO saleor;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: account_address; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.account_address (
    id integer NOT NULL,
    first_name character varying(256) NOT NULL,
    last_name character varying(256) NOT NULL,
    company_name character varying(256) NOT NULL,
    street_address_1 character varying(256) NOT NULL,
    street_address_2 character varying(256) NOT NULL,
    city character varying(256) NOT NULL,
    postal_code character varying(20) NOT NULL,
    country character varying(2) NOT NULL,
    country_area character varying(128) NOT NULL,
    phone character varying(128) NOT NULL,
    city_area character varying(128) NOT NULL,
    billing_details jsonb NOT NULL
);


ALTER TABLE public.account_address OWNER TO saleor;

--
-- Name: account_customerevent; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.account_customerevent (
    id integer NOT NULL,
    date timestamp with time zone NOT NULL,
    type character varying(255) NOT NULL,
    parameters jsonb NOT NULL,
    order_id integer,
    user_id integer NOT NULL
);


ALTER TABLE public.account_customerevent OWNER TO saleor;

--
-- Name: account_customerevent_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.account_customerevent_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.account_customerevent_id_seq OWNER TO saleor;

--
-- Name: account_customerevent_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.account_customerevent_id_seq OWNED BY public.account_customerevent.id;


--
-- Name: account_customernote; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.account_customernote (
    id integer NOT NULL,
    date timestamp with time zone NOT NULL,
    content text NOT NULL,
    is_public boolean NOT NULL,
    customer_id integer NOT NULL,
    user_id integer
);


ALTER TABLE public.account_customernote OWNER TO saleor;

--
-- Name: account_customernote_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.account_customernote_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.account_customernote_id_seq OWNER TO saleor;

--
-- Name: account_customernote_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.account_customernote_id_seq OWNED BY public.account_customernote.id;


--
-- Name: app_app; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.app_app (
    id integer NOT NULL,
    private_metadata jsonb,
    metadata jsonb,
    name character varying(60) NOT NULL,
    created timestamp with time zone NOT NULL,
    is_active boolean NOT NULL,
    about_app text,
    app_url character varying(200),
    configuration_url character varying(200),
    data_privacy text,
    data_privacy_url character varying(200),
    homepage_url character varying(200),
    identifier character varying(256),
    support_url character varying(200),
    type character varying(60) NOT NULL,
    version character varying(60)
);


ALTER TABLE public.app_app OWNER TO saleor;

--
-- Name: account_serviceaccount_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.account_serviceaccount_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.account_serviceaccount_id_seq OWNER TO saleor;

--
-- Name: account_serviceaccount_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.account_serviceaccount_id_seq OWNED BY public.app_app.id;


--
-- Name: app_app_permissions; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.app_app_permissions (
    id integer NOT NULL,
    app_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.app_app_permissions OWNER TO saleor;

--
-- Name: account_serviceaccount_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.account_serviceaccount_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.account_serviceaccount_permissions_id_seq OWNER TO saleor;

--
-- Name: account_serviceaccount_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.account_serviceaccount_permissions_id_seq OWNED BY public.app_app_permissions.id;


--
-- Name: app_apptoken; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.app_apptoken (
    id integer NOT NULL,
    name character varying(128) NOT NULL,
    auth_token character varying(30) NOT NULL,
    app_id integer NOT NULL
);


ALTER TABLE public.app_apptoken OWNER TO saleor;

--
-- Name: account_serviceaccounttoken_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.account_serviceaccounttoken_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.account_serviceaccounttoken_id_seq OWNER TO saleor;

--
-- Name: account_serviceaccounttoken_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.account_serviceaccounttoken_id_seq OWNED BY public.app_apptoken.id;


--
-- Name: account_staffnotificationrecipient; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.account_staffnotificationrecipient (
    id integer NOT NULL,
    staff_email character varying(254),
    active boolean NOT NULL,
    user_id integer
);


ALTER TABLE public.account_staffnotificationrecipient OWNER TO saleor;

--
-- Name: account_staffnotificationrecipient_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.account_staffnotificationrecipient_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.account_staffnotificationrecipient_id_seq OWNER TO saleor;

--
-- Name: account_staffnotificationrecipient_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.account_staffnotificationrecipient_id_seq OWNED BY public.account_staffnotificationrecipient.id;


--
-- Name: account_user; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.account_user (
    id integer NOT NULL,
    is_superuser boolean NOT NULL,
    email character varying(254) NOT NULL,
    is_staff boolean NOT NULL,
    is_active boolean NOT NULL,
    password character varying(128) NOT NULL,
    date_joined timestamp with time zone NOT NULL,
    last_login timestamp with time zone,
    default_billing_address_id integer,
    default_shipping_address_id integer,
    note text,
    first_name character varying(256) NOT NULL,
    last_name character varying(256) NOT NULL,
    avatar character varying(100),
    private_metadata jsonb,
    metadata jsonb,
    jwt_token_key character varying(12) NOT NULL
);


ALTER TABLE public.account_user OWNER TO saleor;

--
-- Name: account_user_addresses; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.account_user_addresses (
    id integer NOT NULL,
    user_id integer NOT NULL,
    address_id integer NOT NULL
);


ALTER TABLE public.account_user_addresses OWNER TO saleor;

--
-- Name: account_user_groups; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.account_user_groups (
    id integer NOT NULL,
    user_id integer NOT NULL,
    group_id integer NOT NULL
);


ALTER TABLE public.account_user_groups OWNER TO saleor;

--
-- Name: account_user_user_permissions; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.account_user_user_permissions (
    id integer NOT NULL,
    user_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.account_user_user_permissions OWNER TO saleor;

--
-- Name: app_appinstallation; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.app_appinstallation (
    id integer NOT NULL,
    status character varying(50) NOT NULL,
    message character varying(255),
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    app_name character varying(60) NOT NULL,
    manifest_url character varying(200) NOT NULL
);


ALTER TABLE public.app_appinstallation OWNER TO saleor;

--
-- Name: app_appinstallation_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.app_appinstallation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.app_appinstallation_id_seq OWNER TO saleor;

--
-- Name: app_appinstallation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.app_appinstallation_id_seq OWNED BY public.app_appinstallation.id;


--
-- Name: app_appinstallation_permissions; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.app_appinstallation_permissions (
    id integer NOT NULL,
    appinstallation_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.app_appinstallation_permissions OWNER TO saleor;

--
-- Name: app_appinstallation_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.app_appinstallation_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.app_appinstallation_permissions_id_seq OWNER TO saleor;

--
-- Name: app_appinstallation_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.app_appinstallation_permissions_id_seq OWNED BY public.app_appinstallation_permissions.id;


--
-- Name: auth_group; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.auth_group (
    id integer NOT NULL,
    name character varying(150) NOT NULL
);


ALTER TABLE public.auth_group OWNER TO saleor;

--
-- Name: auth_group_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.auth_group_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_group_id_seq OWNER TO saleor;

--
-- Name: auth_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.auth_group_id_seq OWNED BY public.auth_group.id;


--
-- Name: auth_group_permissions; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.auth_group_permissions (
    id integer NOT NULL,
    group_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_group_permissions OWNER TO saleor;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.auth_group_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_group_permissions_id_seq OWNER TO saleor;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.auth_group_permissions_id_seq OWNED BY public.auth_group_permissions.id;


--
-- Name: auth_permission; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.auth_permission (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    content_type_id integer NOT NULL,
    codename character varying(100) NOT NULL
);


ALTER TABLE public.auth_permission OWNER TO saleor;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.auth_permission_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_permission_id_seq OWNER TO saleor;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.auth_permission_id_seq OWNED BY public.auth_permission.id;


--
-- Name: checkout_checkoutline; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.checkout_checkoutline (
    id integer NOT NULL,
    quantity integer NOT NULL,
    checkout_id uuid NOT NULL,
    variant_id integer NOT NULL,
    data jsonb NOT NULL,
    CONSTRAINT cart_cartline_quantity_check CHECK ((quantity >= 0))
);


ALTER TABLE public.checkout_checkoutline OWNER TO saleor;

--
-- Name: cart_cartline_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.cart_cartline_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cart_cartline_id_seq OWNER TO saleor;

--
-- Name: cart_cartline_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.cart_cartline_id_seq OWNED BY public.checkout_checkoutline.id;


--
-- Name: checkout_checkout; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.checkout_checkout (
    created timestamp with time zone NOT NULL,
    last_change timestamp with time zone NOT NULL,
    email character varying(254) NOT NULL,
    token uuid NOT NULL,
    quantity integer NOT NULL,
    user_id integer,
    billing_address_id integer,
    discount_amount numeric(12,3) NOT NULL,
    discount_name character varying(255),
    note text NOT NULL,
    shipping_address_id integer,
    shipping_method_id integer,
    voucher_code character varying(12),
    translated_discount_name character varying(255),
    metadata jsonb,
    private_metadata jsonb,
    currency character varying(3) NOT NULL,
    country character varying(2) NOT NULL,
    redirect_url character varying(200),
    tracking_code character varying(255),
    CONSTRAINT cart_cart_quantity_check CHECK ((quantity >= 0))
);


ALTER TABLE public.checkout_checkout OWNER TO saleor;

--
-- Name: checkout_checkout_gift_cards; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.checkout_checkout_gift_cards (
    id integer NOT NULL,
    checkout_id uuid NOT NULL,
    giftcard_id integer NOT NULL
);


ALTER TABLE public.checkout_checkout_gift_cards OWNER TO saleor;

--
-- Name: checkout_checkout_gift_cards_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.checkout_checkout_gift_cards_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.checkout_checkout_gift_cards_id_seq OWNER TO saleor;

--
-- Name: checkout_checkout_gift_cards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.checkout_checkout_gift_cards_id_seq OWNED BY public.checkout_checkout_gift_cards.id;


--
-- Name: csv_exportevent; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.csv_exportevent (
    id integer NOT NULL,
    date timestamp with time zone NOT NULL,
    type character varying(255) NOT NULL,
    parameters jsonb NOT NULL,
    app_id integer,
    export_file_id integer NOT NULL,
    user_id integer
);


ALTER TABLE public.csv_exportevent OWNER TO saleor;

--
-- Name: csv_exportevent_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.csv_exportevent_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.csv_exportevent_id_seq OWNER TO saleor;

--
-- Name: csv_exportevent_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.csv_exportevent_id_seq OWNED BY public.csv_exportevent.id;


--
-- Name: csv_exportfile; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.csv_exportfile (
    id integer NOT NULL,
    status character varying(50) NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    content_file character varying(100),
    app_id integer,
    user_id integer,
    message character varying(255)
);


ALTER TABLE public.csv_exportfile OWNER TO saleor;

--
-- Name: csv_exportfile_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.csv_exportfile_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.csv_exportfile_id_seq OWNER TO saleor;

--
-- Name: csv_exportfile_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.csv_exportfile_id_seq OWNED BY public.csv_exportfile.id;


--
-- Name: discount_sale; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.discount_sale (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    type character varying(10) NOT NULL,
    value numeric(12,3) NOT NULL,
    end_date timestamp with time zone,
    start_date timestamp with time zone NOT NULL
);


ALTER TABLE public.discount_sale OWNER TO saleor;

--
-- Name: discount_sale_categories; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.discount_sale_categories (
    id integer NOT NULL,
    sale_id integer NOT NULL,
    category_id integer NOT NULL
);


ALTER TABLE public.discount_sale_categories OWNER TO saleor;

--
-- Name: discount_sale_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.discount_sale_categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.discount_sale_categories_id_seq OWNER TO saleor;

--
-- Name: discount_sale_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.discount_sale_categories_id_seq OWNED BY public.discount_sale_categories.id;


--
-- Name: discount_sale_collections; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.discount_sale_collections (
    id integer NOT NULL,
    sale_id integer NOT NULL,
    collection_id integer NOT NULL
);


ALTER TABLE public.discount_sale_collections OWNER TO saleor;

--
-- Name: discount_sale_collections_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.discount_sale_collections_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.discount_sale_collections_id_seq OWNER TO saleor;

--
-- Name: discount_sale_collections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.discount_sale_collections_id_seq OWNED BY public.discount_sale_collections.id;


--
-- Name: discount_sale_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.discount_sale_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.discount_sale_id_seq OWNER TO saleor;

--
-- Name: discount_sale_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.discount_sale_id_seq OWNED BY public.discount_sale.id;


--
-- Name: discount_sale_products; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.discount_sale_products (
    id integer NOT NULL,
    sale_id integer NOT NULL,
    product_id integer NOT NULL
);


ALTER TABLE public.discount_sale_products OWNER TO saleor;

--
-- Name: discount_sale_products_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.discount_sale_products_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.discount_sale_products_id_seq OWNER TO saleor;

--
-- Name: discount_sale_products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.discount_sale_products_id_seq OWNED BY public.discount_sale_products.id;


--
-- Name: discount_saletranslation; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.discount_saletranslation (
    id integer NOT NULL,
    language_code character varying(10) NOT NULL,
    name character varying(255),
    sale_id integer NOT NULL
);


ALTER TABLE public.discount_saletranslation OWNER TO saleor;

--
-- Name: discount_saletranslation_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.discount_saletranslation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.discount_saletranslation_id_seq OWNER TO saleor;

--
-- Name: discount_saletranslation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.discount_saletranslation_id_seq OWNED BY public.discount_saletranslation.id;


--
-- Name: discount_voucher; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.discount_voucher (
    id integer NOT NULL,
    type character varying(20) NOT NULL,
    name character varying(255),
    code character varying(12) NOT NULL,
    usage_limit integer,
    used integer NOT NULL,
    start_date timestamp with time zone NOT NULL,
    end_date timestamp with time zone,
    discount_value_type character varying(10) NOT NULL,
    discount_value numeric(12,3) NOT NULL,
    min_spent_amount numeric(12,3),
    apply_once_per_order boolean NOT NULL,
    countries character varying(749) NOT NULL,
    min_checkout_items_quantity integer,
    apply_once_per_customer boolean NOT NULL,
    currency character varying(3) NOT NULL,
    CONSTRAINT discount_voucher_min_checkout_items_quantity_check CHECK ((min_checkout_items_quantity >= 0)),
    CONSTRAINT discount_voucher_usage_limit_check CHECK ((usage_limit >= 0)),
    CONSTRAINT discount_voucher_used_check CHECK ((used >= 0))
);


ALTER TABLE public.discount_voucher OWNER TO saleor;

--
-- Name: discount_voucher_categories; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.discount_voucher_categories (
    id integer NOT NULL,
    voucher_id integer NOT NULL,
    category_id integer NOT NULL
);


ALTER TABLE public.discount_voucher_categories OWNER TO saleor;

--
-- Name: discount_voucher_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.discount_voucher_categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.discount_voucher_categories_id_seq OWNER TO saleor;

--
-- Name: discount_voucher_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.discount_voucher_categories_id_seq OWNED BY public.discount_voucher_categories.id;


--
-- Name: discount_voucher_collections; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.discount_voucher_collections (
    id integer NOT NULL,
    voucher_id integer NOT NULL,
    collection_id integer NOT NULL
);


ALTER TABLE public.discount_voucher_collections OWNER TO saleor;

--
-- Name: discount_voucher_collections_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.discount_voucher_collections_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.discount_voucher_collections_id_seq OWNER TO saleor;

--
-- Name: discount_voucher_collections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.discount_voucher_collections_id_seq OWNED BY public.discount_voucher_collections.id;


--
-- Name: discount_voucher_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.discount_voucher_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.discount_voucher_id_seq OWNER TO saleor;

--
-- Name: discount_voucher_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.discount_voucher_id_seq OWNED BY public.discount_voucher.id;


--
-- Name: discount_voucher_products; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.discount_voucher_products (
    id integer NOT NULL,
    voucher_id integer NOT NULL,
    product_id integer NOT NULL
);


ALTER TABLE public.discount_voucher_products OWNER TO saleor;

--
-- Name: discount_voucher_products_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.discount_voucher_products_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.discount_voucher_products_id_seq OWNER TO saleor;

--
-- Name: discount_voucher_products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.discount_voucher_products_id_seq OWNED BY public.discount_voucher_products.id;


--
-- Name: discount_vouchercustomer; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.discount_vouchercustomer (
    id integer NOT NULL,
    customer_email character varying(254) NOT NULL,
    voucher_id integer NOT NULL
);


ALTER TABLE public.discount_vouchercustomer OWNER TO saleor;

--
-- Name: discount_vouchercustomer_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.discount_vouchercustomer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.discount_vouchercustomer_id_seq OWNER TO saleor;

--
-- Name: discount_vouchercustomer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.discount_vouchercustomer_id_seq OWNED BY public.discount_vouchercustomer.id;


--
-- Name: discount_vouchertranslation; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.discount_vouchertranslation (
    id integer NOT NULL,
    language_code character varying(10) NOT NULL,
    name character varying(255),
    voucher_id integer NOT NULL
);


ALTER TABLE public.discount_vouchertranslation OWNER TO saleor;

--
-- Name: discount_vouchertranslation_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.discount_vouchertranslation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.discount_vouchertranslation_id_seq OWNER TO saleor;

--
-- Name: discount_vouchertranslation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.discount_vouchertranslation_id_seq OWNED BY public.discount_vouchertranslation.id;


--
-- Name: django_content_type; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.django_content_type (
    id integer NOT NULL,
    app_label character varying(100) NOT NULL,
    model character varying(100) NOT NULL
);


ALTER TABLE public.django_content_type OWNER TO saleor;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.django_content_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_content_type_id_seq OWNER TO saleor;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.django_content_type_id_seq OWNED BY public.django_content_type.id;


--
-- Name: django_migrations; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.django_migrations (
    id integer NOT NULL,
    app character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    applied timestamp with time zone NOT NULL
);


ALTER TABLE public.django_migrations OWNER TO saleor;

--
-- Name: django_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.django_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_migrations_id_seq OWNER TO saleor;

--
-- Name: django_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.django_migrations_id_seq OWNED BY public.django_migrations.id;


--
-- Name: django_prices_openexchangerates_conversionrate; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.django_prices_openexchangerates_conversionrate (
    id integer NOT NULL,
    to_currency character varying(3) NOT NULL,
    rate numeric(20,12) NOT NULL,
    modified_at timestamp with time zone NOT NULL
);


ALTER TABLE public.django_prices_openexchangerates_conversionrate OWNER TO saleor;

--
-- Name: django_prices_openexchangerates_conversionrate_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.django_prices_openexchangerates_conversionrate_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_prices_openexchangerates_conversionrate_id_seq OWNER TO saleor;

--
-- Name: django_prices_openexchangerates_conversionrate_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.django_prices_openexchangerates_conversionrate_id_seq OWNED BY public.django_prices_openexchangerates_conversionrate.id;


--
-- Name: django_prices_vatlayer_ratetypes; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.django_prices_vatlayer_ratetypes (
    id integer NOT NULL,
    types text NOT NULL
);


ALTER TABLE public.django_prices_vatlayer_ratetypes OWNER TO saleor;

--
-- Name: django_prices_vatlayer_ratetypes_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.django_prices_vatlayer_ratetypes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_prices_vatlayer_ratetypes_id_seq OWNER TO saleor;

--
-- Name: django_prices_vatlayer_ratetypes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.django_prices_vatlayer_ratetypes_id_seq OWNED BY public.django_prices_vatlayer_ratetypes.id;


--
-- Name: django_prices_vatlayer_vat; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.django_prices_vatlayer_vat (
    id integer NOT NULL,
    country_code character varying(2) NOT NULL,
    data text NOT NULL
);


ALTER TABLE public.django_prices_vatlayer_vat OWNER TO saleor;

--
-- Name: django_prices_vatlayer_vat_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.django_prices_vatlayer_vat_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_prices_vatlayer_vat_id_seq OWNER TO saleor;

--
-- Name: django_prices_vatlayer_vat_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.django_prices_vatlayer_vat_id_seq OWNED BY public.django_prices_vatlayer_vat.id;


--
-- Name: django_site; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.django_site (
    id integer NOT NULL,
    domain character varying(100) NOT NULL,
    name character varying(50) NOT NULL
);


ALTER TABLE public.django_site OWNER TO saleor;

--
-- Name: django_site_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.django_site_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_site_id_seq OWNER TO saleor;

--
-- Name: django_site_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.django_site_id_seq OWNED BY public.django_site.id;


--
-- Name: giftcard_giftcard; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.giftcard_giftcard (
    id integer NOT NULL,
    code character varying(16) NOT NULL,
    created timestamp with time zone NOT NULL,
    start_date date NOT NULL,
    end_date date,
    last_used_on timestamp with time zone,
    is_active boolean NOT NULL,
    initial_balance_amount numeric(12,3) NOT NULL,
    current_balance_amount numeric(12,3) NOT NULL,
    user_id integer,
    currency character varying(3) NOT NULL
);


ALTER TABLE public.giftcard_giftcard OWNER TO saleor;

--
-- Name: giftcard_giftcard_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.giftcard_giftcard_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.giftcard_giftcard_id_seq OWNER TO saleor;

--
-- Name: giftcard_giftcard_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.giftcard_giftcard_id_seq OWNED BY public.giftcard_giftcard.id;


--
-- Name: invoice_invoice; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.invoice_invoice (
    id integer NOT NULL,
    private_metadata jsonb,
    metadata jsonb,
    status character varying(50) NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    number character varying(255),
    created timestamp with time zone,
    external_url character varying(2048),
    invoice_file character varying(100) NOT NULL,
    order_id integer,
    message character varying(255)
);


ALTER TABLE public.invoice_invoice OWNER TO saleor;

--
-- Name: invoice_invoice_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.invoice_invoice_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.invoice_invoice_id_seq OWNER TO saleor;

--
-- Name: invoice_invoice_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.invoice_invoice_id_seq OWNED BY public.invoice_invoice.id;


--
-- Name: invoice_invoiceevent; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.invoice_invoiceevent (
    id integer NOT NULL,
    date timestamp with time zone NOT NULL,
    type character varying(255) NOT NULL,
    parameters jsonb NOT NULL,
    invoice_id integer,
    order_id integer,
    user_id integer
);


ALTER TABLE public.invoice_invoiceevent OWNER TO saleor;

--
-- Name: invoice_invoiceevent_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.invoice_invoiceevent_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.invoice_invoiceevent_id_seq OWNER TO saleor;

--
-- Name: invoice_invoiceevent_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.invoice_invoiceevent_id_seq OWNED BY public.invoice_invoiceevent.id;


--
-- Name: menu_menu; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.menu_menu (
    id integer NOT NULL,
    name character varying(250) NOT NULL,
    slug character varying(255) NOT NULL
);


ALTER TABLE public.menu_menu OWNER TO saleor;

--
-- Name: menu_menu_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.menu_menu_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.menu_menu_id_seq OWNER TO saleor;

--
-- Name: menu_menu_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.menu_menu_id_seq OWNED BY public.menu_menu.id;


--
-- Name: menu_menuitem; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.menu_menuitem (
    id integer NOT NULL,
    name character varying(128) NOT NULL,
    sort_order integer,
    url character varying(256),
    lft integer NOT NULL,
    rght integer NOT NULL,
    tree_id integer NOT NULL,
    level integer NOT NULL,
    category_id integer,
    collection_id integer,
    menu_id integer NOT NULL,
    page_id integer,
    parent_id integer,
    CONSTRAINT menu_menuitem_level_check CHECK ((level >= 0)),
    CONSTRAINT menu_menuitem_lft_check CHECK ((lft >= 0)),
    CONSTRAINT menu_menuitem_rght_check CHECK ((rght >= 0)),
    CONSTRAINT menu_menuitem_tree_id_check CHECK ((tree_id >= 0))
);


ALTER TABLE public.menu_menuitem OWNER TO saleor;

--
-- Name: menu_menuitem_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.menu_menuitem_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.menu_menuitem_id_seq OWNER TO saleor;

--
-- Name: menu_menuitem_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.menu_menuitem_id_seq OWNED BY public.menu_menuitem.id;


--
-- Name: menu_menuitemtranslation; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.menu_menuitemtranslation (
    id integer NOT NULL,
    language_code character varying(10) NOT NULL,
    name character varying(128) NOT NULL,
    menu_item_id integer NOT NULL
);


ALTER TABLE public.menu_menuitemtranslation OWNER TO saleor;

--
-- Name: menu_menuitemtranslation_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.menu_menuitemtranslation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.menu_menuitemtranslation_id_seq OWNER TO saleor;

--
-- Name: menu_menuitemtranslation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.menu_menuitemtranslation_id_seq OWNED BY public.menu_menuitemtranslation.id;


--
-- Name: order_fulfillment; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.order_fulfillment (
    id integer NOT NULL,
    tracking_number character varying(255) NOT NULL,
    created timestamp with time zone NOT NULL,
    order_id integer NOT NULL,
    fulfillment_order integer NOT NULL,
    status character varying(32) NOT NULL,
    metadata jsonb,
    private_metadata jsonb,
    CONSTRAINT order_fulfillment_fulfillment_order_check CHECK ((fulfillment_order >= 0))
);


ALTER TABLE public.order_fulfillment OWNER TO saleor;

--
-- Name: order_fulfillment_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.order_fulfillment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.order_fulfillment_id_seq OWNER TO saleor;

--
-- Name: order_fulfillment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.order_fulfillment_id_seq OWNED BY public.order_fulfillment.id;


--
-- Name: order_fulfillmentline; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.order_fulfillmentline (
    id integer NOT NULL,
    order_line_id integer NOT NULL,
    quantity integer NOT NULL,
    fulfillment_id integer NOT NULL,
    stock_id integer,
    CONSTRAINT order_fulfillmentline_quantity_81b787d3_check CHECK ((quantity >= 0))
);


ALTER TABLE public.order_fulfillmentline OWNER TO saleor;

--
-- Name: order_fulfillmentline_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.order_fulfillmentline_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.order_fulfillmentline_id_seq OWNER TO saleor;

--
-- Name: order_fulfillmentline_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.order_fulfillmentline_id_seq OWNED BY public.order_fulfillmentline.id;


--
-- Name: order_order; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.order_order (
    id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    tracking_client_id character varying(36) NOT NULL,
    user_email character varying(254) NOT NULL,
    token character varying(36) NOT NULL,
    billing_address_id integer,
    shipping_address_id integer,
    user_id integer,
    total_net_amount numeric(12,3) NOT NULL,
    discount_amount numeric(12,3) NOT NULL,
    discount_name character varying(255),
    voucher_id integer,
    language_code character varying(35) NOT NULL,
    shipping_price_gross_amount numeric(12,3) NOT NULL,
    total_gross_amount numeric(12,3) NOT NULL,
    shipping_price_net_amount numeric(12,3) NOT NULL,
    status character varying(32) NOT NULL,
    shipping_method_name character varying(255),
    shipping_method_id integer,
    display_gross_prices boolean NOT NULL,
    translated_discount_name character varying(255),
    customer_note text NOT NULL,
    weight double precision NOT NULL,
    checkout_token character varying(36) NOT NULL,
    currency character varying(3) NOT NULL,
    metadata jsonb,
    private_metadata jsonb
);


ALTER TABLE public.order_order OWNER TO saleor;

--
-- Name: order_order_gift_cards; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.order_order_gift_cards (
    id integer NOT NULL,
    order_id integer NOT NULL,
    giftcard_id integer NOT NULL
);


ALTER TABLE public.order_order_gift_cards OWNER TO saleor;

--
-- Name: order_order_gift_cards_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.order_order_gift_cards_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.order_order_gift_cards_id_seq OWNER TO saleor;

--
-- Name: order_order_gift_cards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.order_order_gift_cards_id_seq OWNED BY public.order_order_gift_cards.id;


--
-- Name: order_order_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.order_order_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.order_order_id_seq OWNER TO saleor;

--
-- Name: order_order_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.order_order_id_seq OWNED BY public.order_order.id;


--
-- Name: order_orderline; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.order_orderline (
    id integer NOT NULL,
    product_name character varying(386) NOT NULL,
    product_sku character varying(255) NOT NULL,
    quantity integer NOT NULL,
    unit_price_net_amount numeric(12,3) NOT NULL,
    unit_price_gross_amount numeric(12,3) NOT NULL,
    is_shipping_required boolean NOT NULL,
    order_id integer NOT NULL,
    quantity_fulfilled integer NOT NULL,
    variant_id integer,
    tax_rate numeric(5,2) NOT NULL,
    translated_product_name character varying(386) NOT NULL,
    currency character varying(3) NOT NULL,
    translated_variant_name character varying(255) NOT NULL,
    variant_name character varying(255) NOT NULL
);


ALTER TABLE public.order_orderline OWNER TO saleor;

--
-- Name: order_ordereditem_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.order_ordereditem_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.order_ordereditem_id_seq OWNER TO saleor;

--
-- Name: order_ordereditem_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.order_ordereditem_id_seq OWNED BY public.order_orderline.id;


--
-- Name: order_orderevent; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.order_orderevent (
    id integer NOT NULL,
    date timestamp with time zone NOT NULL,
    type character varying(255) NOT NULL,
    order_id integer NOT NULL,
    user_id integer,
    parameters jsonb NOT NULL
);


ALTER TABLE public.order_orderevent OWNER TO saleor;

--
-- Name: order_orderevent_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.order_orderevent_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.order_orderevent_id_seq OWNER TO saleor;

--
-- Name: order_orderevent_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.order_orderevent_id_seq OWNED BY public.order_orderevent.id;


--
-- Name: page_page; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.page_page (
    id integer NOT NULL,
    slug character varying(255) NOT NULL,
    title character varying(250) NOT NULL,
    content text NOT NULL,
    created timestamp with time zone NOT NULL,
    is_published boolean NOT NULL,
    publication_date date,
    seo_description character varying(300),
    seo_title character varying(70),
    content_json jsonb NOT NULL,
    metadata jsonb,
    private_metadata jsonb
);


ALTER TABLE public.page_page OWNER TO saleor;

--
-- Name: page_page_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.page_page_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.page_page_id_seq OWNER TO saleor;

--
-- Name: page_page_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.page_page_id_seq OWNED BY public.page_page.id;


--
-- Name: page_pagetranslation; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.page_pagetranslation (
    id integer NOT NULL,
    seo_title character varying(70),
    seo_description character varying(300),
    language_code character varying(10) NOT NULL,
    title character varying(255) NOT NULL,
    content text NOT NULL,
    page_id integer NOT NULL,
    content_json jsonb NOT NULL
);


ALTER TABLE public.page_pagetranslation OWNER TO saleor;

--
-- Name: page_pagetranslation_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.page_pagetranslation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.page_pagetranslation_id_seq OWNER TO saleor;

--
-- Name: page_pagetranslation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.page_pagetranslation_id_seq OWNED BY public.page_pagetranslation.id;


--
-- Name: payment_payment; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.payment_payment (
    id integer NOT NULL,
    gateway character varying(255) NOT NULL,
    is_active boolean NOT NULL,
    created timestamp with time zone NOT NULL,
    modified timestamp with time zone NOT NULL,
    charge_status character varying(20) NOT NULL,
    billing_first_name character varying(256) NOT NULL,
    billing_last_name character varying(256) NOT NULL,
    billing_company_name character varying(256) NOT NULL,
    billing_address_1 character varying(256) NOT NULL,
    billing_address_2 character varying(256) NOT NULL,
    billing_city character varying(256) NOT NULL,
    billing_city_area character varying(128) NOT NULL,
    billing_postal_code character varying(256) NOT NULL,
    billing_country_code character varying(2) NOT NULL,
    billing_country_area character varying(256) NOT NULL,
    billing_email character varying(254) NOT NULL,
    customer_ip_address inet,
    cc_brand character varying(40) NOT NULL,
    cc_exp_month integer,
    cc_exp_year integer,
    cc_first_digits character varying(6) NOT NULL,
    cc_last_digits character varying(4) NOT NULL,
    extra_data text NOT NULL,
    token character varying(512) NOT NULL,
    currency character varying(3) NOT NULL,
    total numeric(12,3) NOT NULL,
    captured_amount numeric(12,3) NOT NULL,
    checkout_id uuid,
    order_id integer,
    to_confirm boolean NOT NULL,
    payment_method_type character varying(256) NOT NULL,
    return_url character varying(200),
    CONSTRAINT payment_paymentmethod_cc_exp_month_check CHECK ((cc_exp_month >= 0)),
    CONSTRAINT payment_paymentmethod_cc_exp_year_check CHECK ((cc_exp_year >= 0))
);


ALTER TABLE public.payment_payment OWNER TO saleor;

--
-- Name: payment_paymentmethod_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.payment_paymentmethod_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.payment_paymentmethod_id_seq OWNER TO saleor;

--
-- Name: payment_paymentmethod_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.payment_paymentmethod_id_seq OWNED BY public.payment_payment.id;


--
-- Name: payment_transaction; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.payment_transaction (
    id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    token character varying(512) NOT NULL,
    kind character varying(25) NOT NULL,
    is_success boolean NOT NULL,
    error character varying(256),
    currency character varying(3) NOT NULL,
    amount numeric(12,3) NOT NULL,
    gateway_response jsonb NOT NULL,
    payment_id integer NOT NULL,
    customer_id character varying(256),
    action_required boolean NOT NULL,
    action_required_data jsonb NOT NULL,
    already_processed boolean NOT NULL,
    searchable_key character varying(512)
);


ALTER TABLE public.payment_transaction OWNER TO saleor;

--
-- Name: payment_transaction_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.payment_transaction_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.payment_transaction_id_seq OWNER TO saleor;

--
-- Name: payment_transaction_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.payment_transaction_id_seq OWNED BY public.payment_transaction.id;


--
-- Name: plugins_pluginconfiguration; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.plugins_pluginconfiguration (
    id integer NOT NULL,
    name character varying(128) NOT NULL,
    description text NOT NULL,
    active boolean NOT NULL,
    configuration jsonb,
    identifier character varying(128) NOT NULL
);


ALTER TABLE public.plugins_pluginconfiguration OWNER TO saleor;

--
-- Name: plugins_pluginconfiguration_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.plugins_pluginconfiguration_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.plugins_pluginconfiguration_id_seq OWNER TO saleor;

--
-- Name: plugins_pluginconfiguration_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.plugins_pluginconfiguration_id_seq OWNED BY public.plugins_pluginconfiguration.id;


--
-- Name: product_assignedproductattribute; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.product_assignedproductattribute (
    id integer NOT NULL,
    product_id integer NOT NULL,
    assignment_id integer NOT NULL
);


ALTER TABLE public.product_assignedproductattribute OWNER TO saleor;

--
-- Name: product_assignedproductattribute_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.product_assignedproductattribute_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.product_assignedproductattribute_id_seq OWNER TO saleor;

--
-- Name: product_assignedproductattribute_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.product_assignedproductattribute_id_seq OWNED BY public.product_assignedproductattribute.id;


--
-- Name: product_assignedproductattribute_values; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.product_assignedproductattribute_values (
    id integer NOT NULL,
    assignedproductattribute_id integer NOT NULL,
    attributevalue_id integer NOT NULL
);


ALTER TABLE public.product_assignedproductattribute_values OWNER TO saleor;

--
-- Name: product_assignedproductattribute_values_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.product_assignedproductattribute_values_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.product_assignedproductattribute_values_id_seq OWNER TO saleor;

--
-- Name: product_assignedproductattribute_values_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.product_assignedproductattribute_values_id_seq OWNED BY public.product_assignedproductattribute_values.id;


--
-- Name: product_assignedvariantattribute; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.product_assignedvariantattribute (
    id integer NOT NULL,
    variant_id integer NOT NULL,
    assignment_id integer NOT NULL
);


ALTER TABLE public.product_assignedvariantattribute OWNER TO saleor;

--
-- Name: product_assignedvariantattribute_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.product_assignedvariantattribute_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.product_assignedvariantattribute_id_seq OWNER TO saleor;

--
-- Name: product_assignedvariantattribute_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.product_assignedvariantattribute_id_seq OWNED BY public.product_assignedvariantattribute.id;


--
-- Name: product_assignedvariantattribute_values; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.product_assignedvariantattribute_values (
    id integer NOT NULL,
    assignedvariantattribute_id integer NOT NULL,
    attributevalue_id integer NOT NULL
);


ALTER TABLE public.product_assignedvariantattribute_values OWNER TO saleor;

--
-- Name: product_assignedvariantattribute_values_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.product_assignedvariantattribute_values_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.product_assignedvariantattribute_values_id_seq OWNER TO saleor;

--
-- Name: product_assignedvariantattribute_values_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.product_assignedvariantattribute_values_id_seq OWNED BY public.product_assignedvariantattribute_values.id;


--
-- Name: product_attribute; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.product_attribute (
    id integer NOT NULL,
    slug character varying(250) NOT NULL,
    name character varying(255) NOT NULL,
    metadata jsonb,
    private_metadata jsonb,
    input_type character varying(50) NOT NULL,
    available_in_grid boolean NOT NULL,
    visible_in_storefront boolean NOT NULL,
    filterable_in_dashboard boolean NOT NULL,
    filterable_in_storefront boolean NOT NULL,
    value_required boolean NOT NULL,
    storefront_search_position integer NOT NULL,
    is_variant_only boolean NOT NULL
);


ALTER TABLE public.product_attribute OWNER TO saleor;

--
-- Name: product_attributevalue; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.product_attributevalue (
    id integer NOT NULL,
    name character varying(250) NOT NULL,
    attribute_id integer NOT NULL,
    slug character varying(255) NOT NULL,
    sort_order integer,
    value character varying(100) NOT NULL
);


ALTER TABLE public.product_attributevalue OWNER TO saleor;

--
-- Name: product_attributechoicevalue_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.product_attributechoicevalue_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.product_attributechoicevalue_id_seq OWNER TO saleor;

--
-- Name: product_attributechoicevalue_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.product_attributechoicevalue_id_seq OWNED BY public.product_attributevalue.id;


--
-- Name: product_attributevaluetranslation; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.product_attributevaluetranslation (
    id integer NOT NULL,
    language_code character varying(10) NOT NULL,
    name character varying(100) NOT NULL,
    attribute_value_id integer NOT NULL
);


ALTER TABLE public.product_attributevaluetranslation OWNER TO saleor;

--
-- Name: product_attributechoicevaluetranslation_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.product_attributechoicevaluetranslation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.product_attributechoicevaluetranslation_id_seq OWNER TO saleor;

--
-- Name: product_attributechoicevaluetranslation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.product_attributechoicevaluetranslation_id_seq OWNED BY public.product_attributevaluetranslation.id;


--
-- Name: product_attributeproduct; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.product_attributeproduct (
    id integer NOT NULL,
    attribute_id integer NOT NULL,
    product_type_id integer NOT NULL,
    sort_order integer
);


ALTER TABLE public.product_attributeproduct OWNER TO saleor;

--
-- Name: product_attributeproduct_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.product_attributeproduct_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.product_attributeproduct_id_seq OWNER TO saleor;

--
-- Name: product_attributeproduct_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.product_attributeproduct_id_seq OWNED BY public.product_attributeproduct.id;


--
-- Name: product_attributetranslation; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.product_attributetranslation (
    id integer NOT NULL,
    language_code character varying(10) NOT NULL,
    name character varying(100) NOT NULL,
    attribute_id integer NOT NULL
);


ALTER TABLE public.product_attributetranslation OWNER TO saleor;

--
-- Name: product_attributevariant; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.product_attributevariant (
    id integer NOT NULL,
    attribute_id integer NOT NULL,
    product_type_id integer NOT NULL,
    sort_order integer
);


ALTER TABLE public.product_attributevariant OWNER TO saleor;

--
-- Name: product_attributevariant_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.product_attributevariant_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.product_attributevariant_id_seq OWNER TO saleor;

--
-- Name: product_attributevariant_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.product_attributevariant_id_seq OWNED BY public.product_attributevariant.id;


--
-- Name: product_category; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.product_category (
    id integer NOT NULL,
    name character varying(250) NOT NULL,
    slug character varying(255) NOT NULL,
    description text NOT NULL,
    lft integer NOT NULL,
    rght integer NOT NULL,
    tree_id integer NOT NULL,
    level integer NOT NULL,
    parent_id integer,
    background_image character varying(100),
    seo_description character varying(300),
    seo_title character varying(70),
    background_image_alt character varying(128) NOT NULL,
    description_json jsonb NOT NULL,
    metadata jsonb,
    private_metadata jsonb,
    CONSTRAINT product_category_level_check CHECK ((level >= 0)),
    CONSTRAINT product_category_lft_check CHECK ((lft >= 0)),
    CONSTRAINT product_category_rght_check CHECK ((rght >= 0)),
    CONSTRAINT product_category_tree_id_check CHECK ((tree_id >= 0))
);


ALTER TABLE public.product_category OWNER TO saleor;

--
-- Name: product_category_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.product_category_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.product_category_id_seq OWNER TO saleor;

--
-- Name: product_category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.product_category_id_seq OWNED BY public.product_category.id;


--
-- Name: product_categorytranslation; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.product_categorytranslation (
    id integer NOT NULL,
    seo_title character varying(70),
    seo_description character varying(300),
    language_code character varying(10) NOT NULL,
    name character varying(128) NOT NULL,
    description text NOT NULL,
    category_id integer NOT NULL,
    description_json jsonb NOT NULL
);


ALTER TABLE public.product_categorytranslation OWNER TO saleor;

--
-- Name: product_categorytranslation_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.product_categorytranslation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.product_categorytranslation_id_seq OWNER TO saleor;

--
-- Name: product_categorytranslation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.product_categorytranslation_id_seq OWNED BY public.product_categorytranslation.id;


--
-- Name: product_collection; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.product_collection (
    id integer NOT NULL,
    name character varying(250) NOT NULL,
    slug character varying(255) NOT NULL,
    background_image character varying(100),
    seo_description character varying(300),
    seo_title character varying(70),
    is_published boolean NOT NULL,
    description text NOT NULL,
    publication_date date,
    background_image_alt character varying(128) NOT NULL,
    description_json jsonb NOT NULL,
    metadata jsonb,
    private_metadata jsonb
);


ALTER TABLE public.product_collection OWNER TO saleor;

--
-- Name: product_collection_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.product_collection_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.product_collection_id_seq OWNER TO saleor;

--
-- Name: product_collection_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.product_collection_id_seq OWNED BY public.product_collection.id;


--
-- Name: product_collectionproduct; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.product_collectionproduct (
    id integer NOT NULL,
    collection_id integer NOT NULL,
    product_id integer NOT NULL,
    sort_order integer
);


ALTER TABLE public.product_collectionproduct OWNER TO saleor;

--
-- Name: product_collection_products_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.product_collection_products_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.product_collection_products_id_seq OWNER TO saleor;

--
-- Name: product_collection_products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.product_collection_products_id_seq OWNED BY public.product_collectionproduct.id;


--
-- Name: product_collectiontranslation; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.product_collectiontranslation (
    id integer NOT NULL,
    seo_title character varying(70),
    seo_description character varying(300),
    language_code character varying(10) NOT NULL,
    name character varying(128) NOT NULL,
    collection_id integer NOT NULL,
    description text NOT NULL,
    description_json jsonb NOT NULL
);


ALTER TABLE public.product_collectiontranslation OWNER TO saleor;

--
-- Name: product_collectiontranslation_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.product_collectiontranslation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.product_collectiontranslation_id_seq OWNER TO saleor;

--
-- Name: product_collectiontranslation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.product_collectiontranslation_id_seq OWNED BY public.product_collectiontranslation.id;


--
-- Name: product_digitalcontent; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.product_digitalcontent (
    id integer NOT NULL,
    use_default_settings boolean NOT NULL,
    automatic_fulfillment boolean NOT NULL,
    content_type character varying(128) NOT NULL,
    content_file character varying(100) NOT NULL,
    max_downloads integer,
    url_valid_days integer,
    product_variant_id integer NOT NULL,
    metadata jsonb,
    private_metadata jsonb
);


ALTER TABLE public.product_digitalcontent OWNER TO saleor;

--
-- Name: product_digitalcontent_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.product_digitalcontent_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.product_digitalcontent_id_seq OWNER TO saleor;

--
-- Name: product_digitalcontent_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.product_digitalcontent_id_seq OWNED BY public.product_digitalcontent.id;


--
-- Name: product_digitalcontenturl; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.product_digitalcontenturl (
    id integer NOT NULL,
    token uuid NOT NULL,
    created timestamp with time zone NOT NULL,
    download_num integer NOT NULL,
    content_id integer NOT NULL,
    line_id integer
);


ALTER TABLE public.product_digitalcontenturl OWNER TO saleor;

--
-- Name: product_digitalcontenturl_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.product_digitalcontenturl_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.product_digitalcontenturl_id_seq OWNER TO saleor;

--
-- Name: product_digitalcontenturl_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.product_digitalcontenturl_id_seq OWNED BY public.product_digitalcontenturl.id;


--
-- Name: product_product; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.product_product (
    id integer NOT NULL,
    name character varying(250) NOT NULL,
    description text NOT NULL,
    publication_date date,
    updated_at timestamp with time zone,
    product_type_id integer NOT NULL,
    is_published boolean NOT NULL,
    category_id integer,
    seo_description character varying(300),
    seo_title character varying(70),
    charge_taxes boolean NOT NULL,
    weight double precision,
    description_json jsonb NOT NULL,
    metadata jsonb,
    private_metadata jsonb,
    minimal_variant_price_amount numeric(12,3),
    currency character varying(3) NOT NULL,
    slug character varying(255) NOT NULL,
    available_for_purchase date,
    visible_in_listings boolean NOT NULL,
    default_variant_id integer,
    description_plaintext text NOT NULL,
    search_vector tsvector
);


ALTER TABLE public.product_product OWNER TO saleor;

--
-- Name: product_product_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.product_product_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.product_product_id_seq OWNER TO saleor;

--
-- Name: product_product_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.product_product_id_seq OWNED BY public.product_product.id;


--
-- Name: product_productattribute_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.product_productattribute_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.product_productattribute_id_seq OWNER TO saleor;

--
-- Name: product_productattribute_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.product_productattribute_id_seq OWNED BY public.product_attribute.id;


--
-- Name: product_productattributetranslation_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.product_productattributetranslation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.product_productattributetranslation_id_seq OWNER TO saleor;

--
-- Name: product_productattributetranslation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.product_productattributetranslation_id_seq OWNED BY public.product_attributetranslation.id;


--
-- Name: product_producttype; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.product_producttype (
    id integer NOT NULL,
    name character varying(250) NOT NULL,
    has_variants boolean NOT NULL,
    is_shipping_required boolean NOT NULL,
    weight double precision NOT NULL,
    is_digital boolean NOT NULL,
    metadata jsonb,
    private_metadata jsonb,
    slug character varying(255) NOT NULL
);


ALTER TABLE public.product_producttype OWNER TO saleor;

--
-- Name: product_productclass_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.product_productclass_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.product_productclass_id_seq OWNER TO saleor;

--
-- Name: product_productclass_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.product_productclass_id_seq OWNED BY public.product_producttype.id;


--
-- Name: product_productimage; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.product_productimage (
    id integer NOT NULL,
    image character varying(100) NOT NULL,
    ppoi character varying(20) NOT NULL,
    alt character varying(128) NOT NULL,
    sort_order integer,
    product_id integer NOT NULL
);


ALTER TABLE public.product_productimage OWNER TO saleor;

--
-- Name: product_productimage_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.product_productimage_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.product_productimage_id_seq OWNER TO saleor;

--
-- Name: product_productimage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.product_productimage_id_seq OWNED BY public.product_productimage.id;


--
-- Name: product_producttranslation; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.product_producttranslation (
    id integer NOT NULL,
    seo_title character varying(70),
    seo_description character varying(300),
    language_code character varying(10) NOT NULL,
    name character varying(250) NOT NULL,
    description text NOT NULL,
    product_id integer NOT NULL,
    description_json jsonb NOT NULL
);


ALTER TABLE public.product_producttranslation OWNER TO saleor;

--
-- Name: product_producttranslation_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.product_producttranslation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.product_producttranslation_id_seq OWNER TO saleor;

--
-- Name: product_producttranslation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.product_producttranslation_id_seq OWNED BY public.product_producttranslation.id;


--
-- Name: product_productvariant; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.product_productvariant (
    id integer NOT NULL,
    sku character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    product_id integer NOT NULL,
    cost_price_amount numeric(12,3),
    track_inventory boolean NOT NULL,
    weight double precision,
    metadata jsonb,
    private_metadata jsonb,
    currency character varying(3),
    price_amount numeric(12,3) NOT NULL,
    sort_order integer
);


ALTER TABLE public.product_productvariant OWNER TO saleor;

--
-- Name: product_productvariant_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.product_productvariant_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.product_productvariant_id_seq OWNER TO saleor;

--
-- Name: product_productvariant_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.product_productvariant_id_seq OWNED BY public.product_productvariant.id;


--
-- Name: product_productvarianttranslation; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.product_productvarianttranslation (
    id integer NOT NULL,
    language_code character varying(10) NOT NULL,
    name character varying(255) NOT NULL,
    product_variant_id integer NOT NULL
);


ALTER TABLE public.product_productvarianttranslation OWNER TO saleor;

--
-- Name: product_productvarianttranslation_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.product_productvarianttranslation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.product_productvarianttranslation_id_seq OWNER TO saleor;

--
-- Name: product_productvarianttranslation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.product_productvarianttranslation_id_seq OWNED BY public.product_productvarianttranslation.id;


--
-- Name: product_variantimage; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.product_variantimage (
    id integer NOT NULL,
    image_id integer NOT NULL,
    variant_id integer NOT NULL
);


ALTER TABLE public.product_variantimage OWNER TO saleor;

--
-- Name: product_variantimage_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.product_variantimage_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.product_variantimage_id_seq OWNER TO saleor;

--
-- Name: product_variantimage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.product_variantimage_id_seq OWNED BY public.product_variantimage.id;


--
-- Name: shipping_shippingmethod; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.shipping_shippingmethod (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    maximum_order_price_amount numeric(12,3),
    maximum_order_weight double precision,
    minimum_order_price_amount numeric(12,3),
    minimum_order_weight double precision,
    price_amount numeric(12,3) NOT NULL,
    type character varying(30) NOT NULL,
    shipping_zone_id integer NOT NULL,
    currency character varying(3) NOT NULL
);


ALTER TABLE public.shipping_shippingmethod OWNER TO saleor;

--
-- Name: shipping_shippingmethod_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.shipping_shippingmethod_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.shipping_shippingmethod_id_seq OWNER TO saleor;

--
-- Name: shipping_shippingmethod_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.shipping_shippingmethod_id_seq OWNED BY public.shipping_shippingmethod.id;


--
-- Name: shipping_shippingmethodtranslation; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.shipping_shippingmethodtranslation (
    id integer NOT NULL,
    language_code character varying(10) NOT NULL,
    name character varying(255),
    shipping_method_id integer NOT NULL
);


ALTER TABLE public.shipping_shippingmethodtranslation OWNER TO saleor;

--
-- Name: shipping_shippingmethodtranslation_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.shipping_shippingmethodtranslation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.shipping_shippingmethodtranslation_id_seq OWNER TO saleor;

--
-- Name: shipping_shippingmethodtranslation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.shipping_shippingmethodtranslation_id_seq OWNED BY public.shipping_shippingmethodtranslation.id;


--
-- Name: shipping_shippingzone; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.shipping_shippingzone (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    countries character varying(749) NOT NULL,
    "default" boolean NOT NULL
);


ALTER TABLE public.shipping_shippingzone OWNER TO saleor;

--
-- Name: shipping_shippingzone_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.shipping_shippingzone_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.shipping_shippingzone_id_seq OWNER TO saleor;

--
-- Name: shipping_shippingzone_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.shipping_shippingzone_id_seq OWNED BY public.shipping_shippingzone.id;


--
-- Name: site_authorizationkey; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.site_authorizationkey (
    id integer NOT NULL,
    name character varying(20) NOT NULL,
    key text NOT NULL,
    password text NOT NULL,
    site_settings_id integer NOT NULL
);


ALTER TABLE public.site_authorizationkey OWNER TO saleor;

--
-- Name: site_authorizationkey_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.site_authorizationkey_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.site_authorizationkey_id_seq OWNER TO saleor;

--
-- Name: site_authorizationkey_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.site_authorizationkey_id_seq OWNED BY public.site_authorizationkey.id;


--
-- Name: site_sitesettings; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.site_sitesettings (
    id integer NOT NULL,
    header_text character varying(200) NOT NULL,
    description character varying(500) NOT NULL,
    site_id integer NOT NULL,
    bottom_menu_id integer,
    top_menu_id integer,
    display_gross_prices boolean NOT NULL,
    include_taxes_in_prices boolean NOT NULL,
    charge_taxes_on_shipping boolean NOT NULL,
    track_inventory_by_default boolean NOT NULL,
    homepage_collection_id integer,
    default_weight_unit character varying(10) NOT NULL,
    automatic_fulfillment_digital_products boolean NOT NULL,
    default_digital_max_downloads integer,
    default_digital_url_valid_days integer,
    company_address_id integer,
    default_mail_sender_address character varying(254),
    default_mail_sender_name character varying(78) NOT NULL,
    customer_set_password_url character varying(255)
);


ALTER TABLE public.site_sitesettings OWNER TO saleor;

--
-- Name: site_sitesettings_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.site_sitesettings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.site_sitesettings_id_seq OWNER TO saleor;

--
-- Name: site_sitesettings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.site_sitesettings_id_seq OWNED BY public.site_sitesettings.id;


--
-- Name: site_sitesettingstranslation; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.site_sitesettingstranslation (
    id integer NOT NULL,
    language_code character varying(10) NOT NULL,
    header_text character varying(200) NOT NULL,
    description character varying(500) NOT NULL,
    site_settings_id integer NOT NULL
);


ALTER TABLE public.site_sitesettingstranslation OWNER TO saleor;

--
-- Name: site_sitesettingstranslation_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.site_sitesettingstranslation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.site_sitesettingstranslation_id_seq OWNER TO saleor;

--
-- Name: site_sitesettingstranslation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.site_sitesettingstranslation_id_seq OWNED BY public.site_sitesettingstranslation.id;


--
-- Name: userprofile_address_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.userprofile_address_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.userprofile_address_id_seq OWNER TO saleor;

--
-- Name: userprofile_address_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.userprofile_address_id_seq OWNED BY public.account_address.id;


--
-- Name: userprofile_user_addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.userprofile_user_addresses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.userprofile_user_addresses_id_seq OWNER TO saleor;

--
-- Name: userprofile_user_addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.userprofile_user_addresses_id_seq OWNED BY public.account_user_addresses.id;


--
-- Name: userprofile_user_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.userprofile_user_groups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.userprofile_user_groups_id_seq OWNER TO saleor;

--
-- Name: userprofile_user_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.userprofile_user_groups_id_seq OWNED BY public.account_user_groups.id;


--
-- Name: userprofile_user_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.userprofile_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.userprofile_user_id_seq OWNER TO saleor;

--
-- Name: userprofile_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.userprofile_user_id_seq OWNED BY public.account_user.id;


--
-- Name: userprofile_user_user_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.userprofile_user_user_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.userprofile_user_user_permissions_id_seq OWNER TO saleor;

--
-- Name: userprofile_user_user_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.userprofile_user_user_permissions_id_seq OWNED BY public.account_user_user_permissions.id;


--
-- Name: warehouse_allocation; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.warehouse_allocation (
    id integer NOT NULL,
    quantity_allocated integer NOT NULL,
    order_line_id integer NOT NULL,
    stock_id integer NOT NULL,
    CONSTRAINT warehouse_allocation_quantity_allocated_check CHECK ((quantity_allocated >= 0))
);


ALTER TABLE public.warehouse_allocation OWNER TO saleor;

--
-- Name: warehouse_allocation_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.warehouse_allocation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.warehouse_allocation_id_seq OWNER TO saleor;

--
-- Name: warehouse_allocation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.warehouse_allocation_id_seq OWNED BY public.warehouse_allocation.id;


--
-- Name: warehouse_stock; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.warehouse_stock (
    id integer NOT NULL,
    quantity integer NOT NULL,
    product_variant_id integer NOT NULL,
    warehouse_id uuid NOT NULL,
    CONSTRAINT warehouse_stock_quantity_check CHECK ((quantity >= 0))
);


ALTER TABLE public.warehouse_stock OWNER TO saleor;

--
-- Name: warehouse_stock_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.warehouse_stock_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.warehouse_stock_id_seq OWNER TO saleor;

--
-- Name: warehouse_stock_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.warehouse_stock_id_seq OWNED BY public.warehouse_stock.id;


--
-- Name: warehouse_warehouse; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.warehouse_warehouse (
    id uuid NOT NULL,
    name character varying(250) NOT NULL,
    company_name character varying(255) NOT NULL,
    email character varying(254) NOT NULL,
    address_id integer NOT NULL,
    slug character varying(255) NOT NULL
);


ALTER TABLE public.warehouse_warehouse OWNER TO saleor;

--
-- Name: warehouse_warehouse_shipping_zones; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.warehouse_warehouse_shipping_zones (
    id integer NOT NULL,
    warehouse_id uuid NOT NULL,
    shippingzone_id integer NOT NULL
);


ALTER TABLE public.warehouse_warehouse_shipping_zones OWNER TO saleor;

--
-- Name: warehouse_warehouse_shipping_zones_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.warehouse_warehouse_shipping_zones_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.warehouse_warehouse_shipping_zones_id_seq OWNER TO saleor;

--
-- Name: warehouse_warehouse_shipping_zones_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.warehouse_warehouse_shipping_zones_id_seq OWNED BY public.warehouse_warehouse_shipping_zones.id;


--
-- Name: webhook_webhook; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.webhook_webhook (
    id integer NOT NULL,
    target_url character varying(255) NOT NULL,
    is_active boolean NOT NULL,
    secret_key character varying(255),
    app_id integer NOT NULL,
    name character varying(255)
);


ALTER TABLE public.webhook_webhook OWNER TO saleor;

--
-- Name: webhook_webhook_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.webhook_webhook_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.webhook_webhook_id_seq OWNER TO saleor;

--
-- Name: webhook_webhook_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.webhook_webhook_id_seq OWNED BY public.webhook_webhook.id;


--
-- Name: webhook_webhookevent; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.webhook_webhookevent (
    id integer NOT NULL,
    event_type character varying(128) NOT NULL,
    webhook_id integer NOT NULL
);


ALTER TABLE public.webhook_webhookevent OWNER TO saleor;

--
-- Name: webhook_webhookevent_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.webhook_webhookevent_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.webhook_webhookevent_id_seq OWNER TO saleor;

--
-- Name: webhook_webhookevent_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.webhook_webhookevent_id_seq OWNED BY public.webhook_webhookevent.id;


--
-- Name: wishlist_wishlist; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.wishlist_wishlist (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    token uuid NOT NULL,
    user_id integer
);


ALTER TABLE public.wishlist_wishlist OWNER TO saleor;

--
-- Name: wishlist_wishlist_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.wishlist_wishlist_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.wishlist_wishlist_id_seq OWNER TO saleor;

--
-- Name: wishlist_wishlist_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.wishlist_wishlist_id_seq OWNED BY public.wishlist_wishlist.id;


--
-- Name: wishlist_wishlistitem; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.wishlist_wishlistitem (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    product_id integer NOT NULL,
    wishlist_id integer NOT NULL
);


ALTER TABLE public.wishlist_wishlistitem OWNER TO saleor;

--
-- Name: wishlist_wishlistitem_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.wishlist_wishlistitem_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.wishlist_wishlistitem_id_seq OWNER TO saleor;

--
-- Name: wishlist_wishlistitem_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.wishlist_wishlistitem_id_seq OWNED BY public.wishlist_wishlistitem.id;


--
-- Name: wishlist_wishlistitem_variants; Type: TABLE; Schema: public; Owner: saleor
--

CREATE TABLE public.wishlist_wishlistitem_variants (
    id integer NOT NULL,
    wishlistitem_id integer NOT NULL,
    productvariant_id integer NOT NULL
);


ALTER TABLE public.wishlist_wishlistitem_variants OWNER TO saleor;

--
-- Name: wishlist_wishlistitem_variants_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
--

CREATE SEQUENCE public.wishlist_wishlistitem_variants_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.wishlist_wishlistitem_variants_id_seq OWNER TO saleor;

--
-- Name: wishlist_wishlistitem_variants_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
--

ALTER SEQUENCE public.wishlist_wishlistitem_variants_id_seq OWNED BY public.wishlist_wishlistitem_variants.id;


--
-- Name: account_address id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.account_address ALTER COLUMN id SET DEFAULT nextval('public.userprofile_address_id_seq'::regclass);


--
-- Name: account_customerevent id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.account_customerevent ALTER COLUMN id SET DEFAULT nextval('public.account_customerevent_id_seq'::regclass);


--
-- Name: account_customernote id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.account_customernote ALTER COLUMN id SET DEFAULT nextval('public.account_customernote_id_seq'::regclass);


--
-- Name: account_staffnotificationrecipient id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.account_staffnotificationrecipient ALTER COLUMN id SET DEFAULT nextval('public.account_staffnotificationrecipient_id_seq'::regclass);


--
-- Name: account_user id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.account_user ALTER COLUMN id SET DEFAULT nextval('public.userprofile_user_id_seq'::regclass);


--
-- Name: account_user_addresses id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.account_user_addresses ALTER COLUMN id SET DEFAULT nextval('public.userprofile_user_addresses_id_seq'::regclass);


--
-- Name: account_user_groups id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.account_user_groups ALTER COLUMN id SET DEFAULT nextval('public.userprofile_user_groups_id_seq'::regclass);


--
-- Name: account_user_user_permissions id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.account_user_user_permissions ALTER COLUMN id SET DEFAULT nextval('public.userprofile_user_user_permissions_id_seq'::regclass);


--
-- Name: app_app id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.app_app ALTER COLUMN id SET DEFAULT nextval('public.account_serviceaccount_id_seq'::regclass);


--
-- Name: app_app_permissions id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.app_app_permissions ALTER COLUMN id SET DEFAULT nextval('public.account_serviceaccount_permissions_id_seq'::regclass);


--
-- Name: app_appinstallation id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.app_appinstallation ALTER COLUMN id SET DEFAULT nextval('public.app_appinstallation_id_seq'::regclass);


--
-- Name: app_appinstallation_permissions id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.app_appinstallation_permissions ALTER COLUMN id SET DEFAULT nextval('public.app_appinstallation_permissions_id_seq'::regclass);


--
-- Name: app_apptoken id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.app_apptoken ALTER COLUMN id SET DEFAULT nextval('public.account_serviceaccounttoken_id_seq'::regclass);


--
-- Name: auth_group id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.auth_group ALTER COLUMN id SET DEFAULT nextval('public.auth_group_id_seq'::regclass);


--
-- Name: auth_group_permissions id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.auth_group_permissions ALTER COLUMN id SET DEFAULT nextval('public.auth_group_permissions_id_seq'::regclass);


--
-- Name: auth_permission id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.auth_permission ALTER COLUMN id SET DEFAULT nextval('public.auth_permission_id_seq'::regclass);


--
-- Name: checkout_checkout_gift_cards id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.checkout_checkout_gift_cards ALTER COLUMN id SET DEFAULT nextval('public.checkout_checkout_gift_cards_id_seq'::regclass);


--
-- Name: checkout_checkoutline id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.checkout_checkoutline ALTER COLUMN id SET DEFAULT nextval('public.cart_cartline_id_seq'::regclass);


--
-- Name: csv_exportevent id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.csv_exportevent ALTER COLUMN id SET DEFAULT nextval('public.csv_exportevent_id_seq'::regclass);


--
-- Name: csv_exportfile id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.csv_exportfile ALTER COLUMN id SET DEFAULT nextval('public.csv_exportfile_id_seq'::regclass);


--
-- Name: discount_sale id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.discount_sale ALTER COLUMN id SET DEFAULT nextval('public.discount_sale_id_seq'::regclass);


--
-- Name: discount_sale_categories id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.discount_sale_categories ALTER COLUMN id SET DEFAULT nextval('public.discount_sale_categories_id_seq'::regclass);


--
-- Name: discount_sale_collections id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.discount_sale_collections ALTER COLUMN id SET DEFAULT nextval('public.discount_sale_collections_id_seq'::regclass);


--
-- Name: discount_sale_products id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.discount_sale_products ALTER COLUMN id SET DEFAULT nextval('public.discount_sale_products_id_seq'::regclass);


--
-- Name: discount_saletranslation id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.discount_saletranslation ALTER COLUMN id SET DEFAULT nextval('public.discount_saletranslation_id_seq'::regclass);


--
-- Name: discount_voucher id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.discount_voucher ALTER COLUMN id SET DEFAULT nextval('public.discount_voucher_id_seq'::regclass);


--
-- Name: discount_voucher_categories id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.discount_voucher_categories ALTER COLUMN id SET DEFAULT nextval('public.discount_voucher_categories_id_seq'::regclass);


--
-- Name: discount_voucher_collections id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.discount_voucher_collections ALTER COLUMN id SET DEFAULT nextval('public.discount_voucher_collections_id_seq'::regclass);


--
-- Name: discount_voucher_products id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.discount_voucher_products ALTER COLUMN id SET DEFAULT nextval('public.discount_voucher_products_id_seq'::regclass);


--
-- Name: discount_vouchercustomer id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.discount_vouchercustomer ALTER COLUMN id SET DEFAULT nextval('public.discount_vouchercustomer_id_seq'::regclass);


--
-- Name: discount_vouchertranslation id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.discount_vouchertranslation ALTER COLUMN id SET DEFAULT nextval('public.discount_vouchertranslation_id_seq'::regclass);


--
-- Name: django_content_type id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.django_content_type ALTER COLUMN id SET DEFAULT nextval('public.django_content_type_id_seq'::regclass);


--
-- Name: django_migrations id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.django_migrations ALTER COLUMN id SET DEFAULT nextval('public.django_migrations_id_seq'::regclass);


--
-- Name: django_prices_openexchangerates_conversionrate id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.django_prices_openexchangerates_conversionrate ALTER COLUMN id SET DEFAULT nextval('public.django_prices_openexchangerates_conversionrate_id_seq'::regclass);


--
-- Name: django_prices_vatlayer_ratetypes id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.django_prices_vatlayer_ratetypes ALTER COLUMN id SET DEFAULT nextval('public.django_prices_vatlayer_ratetypes_id_seq'::regclass);


--
-- Name: django_prices_vatlayer_vat id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.django_prices_vatlayer_vat ALTER COLUMN id SET DEFAULT nextval('public.django_prices_vatlayer_vat_id_seq'::regclass);


--
-- Name: django_site id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.django_site ALTER COLUMN id SET DEFAULT nextval('public.django_site_id_seq'::regclass);


--
-- Name: giftcard_giftcard id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.giftcard_giftcard ALTER COLUMN id SET DEFAULT nextval('public.giftcard_giftcard_id_seq'::regclass);


--
-- Name: invoice_invoice id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.invoice_invoice ALTER COLUMN id SET DEFAULT nextval('public.invoice_invoice_id_seq'::regclass);


--
-- Name: invoice_invoiceevent id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.invoice_invoiceevent ALTER COLUMN id SET DEFAULT nextval('public.invoice_invoiceevent_id_seq'::regclass);


--
-- Name: menu_menu id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.menu_menu ALTER COLUMN id SET DEFAULT nextval('public.menu_menu_id_seq'::regclass);


--
-- Name: menu_menuitem id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.menu_menuitem ALTER COLUMN id SET DEFAULT nextval('public.menu_menuitem_id_seq'::regclass);


--
-- Name: menu_menuitemtranslation id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.menu_menuitemtranslation ALTER COLUMN id SET DEFAULT nextval('public.menu_menuitemtranslation_id_seq'::regclass);


--
-- Name: order_fulfillment id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.order_fulfillment ALTER COLUMN id SET DEFAULT nextval('public.order_fulfillment_id_seq'::regclass);


--
-- Name: order_fulfillmentline id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.order_fulfillmentline ALTER COLUMN id SET DEFAULT nextval('public.order_fulfillmentline_id_seq'::regclass);


--
-- Name: order_order id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.order_order ALTER COLUMN id SET DEFAULT nextval('public.order_order_id_seq'::regclass);


--
-- Name: order_order_gift_cards id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.order_order_gift_cards ALTER COLUMN id SET DEFAULT nextval('public.order_order_gift_cards_id_seq'::regclass);


--
-- Name: order_orderevent id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.order_orderevent ALTER COLUMN id SET DEFAULT nextval('public.order_orderevent_id_seq'::regclass);


--
-- Name: order_orderline id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.order_orderline ALTER COLUMN id SET DEFAULT nextval('public.order_ordereditem_id_seq'::regclass);


--
-- Name: page_page id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.page_page ALTER COLUMN id SET DEFAULT nextval('public.page_page_id_seq'::regclass);


--
-- Name: page_pagetranslation id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.page_pagetranslation ALTER COLUMN id SET DEFAULT nextval('public.page_pagetranslation_id_seq'::regclass);


--
-- Name: payment_payment id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.payment_payment ALTER COLUMN id SET DEFAULT nextval('public.payment_paymentmethod_id_seq'::regclass);


--
-- Name: payment_transaction id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.payment_transaction ALTER COLUMN id SET DEFAULT nextval('public.payment_transaction_id_seq'::regclass);


--
-- Name: plugins_pluginconfiguration id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.plugins_pluginconfiguration ALTER COLUMN id SET DEFAULT nextval('public.plugins_pluginconfiguration_id_seq'::regclass);


--
-- Name: product_assignedproductattribute id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_assignedproductattribute ALTER COLUMN id SET DEFAULT nextval('public.product_assignedproductattribute_id_seq'::regclass);


--
-- Name: product_assignedproductattribute_values id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_assignedproductattribute_values ALTER COLUMN id SET DEFAULT nextval('public.product_assignedproductattribute_values_id_seq'::regclass);


--
-- Name: product_assignedvariantattribute id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_assignedvariantattribute ALTER COLUMN id SET DEFAULT nextval('public.product_assignedvariantattribute_id_seq'::regclass);


--
-- Name: product_assignedvariantattribute_values id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_assignedvariantattribute_values ALTER COLUMN id SET DEFAULT nextval('public.product_assignedvariantattribute_values_id_seq'::regclass);


--
-- Name: product_attribute id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_attribute ALTER COLUMN id SET DEFAULT nextval('public.product_productattribute_id_seq'::regclass);


--
-- Name: product_attributeproduct id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_attributeproduct ALTER COLUMN id SET DEFAULT nextval('public.product_attributeproduct_id_seq'::regclass);


--
-- Name: product_attributetranslation id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_attributetranslation ALTER COLUMN id SET DEFAULT nextval('public.product_productattributetranslation_id_seq'::regclass);


--
-- Name: product_attributevalue id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_attributevalue ALTER COLUMN id SET DEFAULT nextval('public.product_attributechoicevalue_id_seq'::regclass);


--
-- Name: product_attributevaluetranslation id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_attributevaluetranslation ALTER COLUMN id SET DEFAULT nextval('public.product_attributechoicevaluetranslation_id_seq'::regclass);


--
-- Name: product_attributevariant id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_attributevariant ALTER COLUMN id SET DEFAULT nextval('public.product_attributevariant_id_seq'::regclass);


--
-- Name: product_category id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_category ALTER COLUMN id SET DEFAULT nextval('public.product_category_id_seq'::regclass);


--
-- Name: product_categorytranslation id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_categorytranslation ALTER COLUMN id SET DEFAULT nextval('public.product_categorytranslation_id_seq'::regclass);


--
-- Name: product_collection id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_collection ALTER COLUMN id SET DEFAULT nextval('public.product_collection_id_seq'::regclass);


--
-- Name: product_collectionproduct id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_collectionproduct ALTER COLUMN id SET DEFAULT nextval('public.product_collection_products_id_seq'::regclass);


--
-- Name: product_collectiontranslation id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_collectiontranslation ALTER COLUMN id SET DEFAULT nextval('public.product_collectiontranslation_id_seq'::regclass);


--
-- Name: product_digitalcontent id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_digitalcontent ALTER COLUMN id SET DEFAULT nextval('public.product_digitalcontent_id_seq'::regclass);


--
-- Name: product_digitalcontenturl id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_digitalcontenturl ALTER COLUMN id SET DEFAULT nextval('public.product_digitalcontenturl_id_seq'::regclass);


--
-- Name: product_product id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_product ALTER COLUMN id SET DEFAULT nextval('public.product_product_id_seq'::regclass);


--
-- Name: product_productimage id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_productimage ALTER COLUMN id SET DEFAULT nextval('public.product_productimage_id_seq'::regclass);


--
-- Name: product_producttranslation id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_producttranslation ALTER COLUMN id SET DEFAULT nextval('public.product_producttranslation_id_seq'::regclass);


--
-- Name: product_producttype id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_producttype ALTER COLUMN id SET DEFAULT nextval('public.product_productclass_id_seq'::regclass);


--
-- Name: product_productvariant id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_productvariant ALTER COLUMN id SET DEFAULT nextval('public.product_productvariant_id_seq'::regclass);


--
-- Name: product_productvarianttranslation id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_productvarianttranslation ALTER COLUMN id SET DEFAULT nextval('public.product_productvarianttranslation_id_seq'::regclass);


--
-- Name: product_variantimage id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_variantimage ALTER COLUMN id SET DEFAULT nextval('public.product_variantimage_id_seq'::regclass);


--
-- Name: shipping_shippingmethod id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.shipping_shippingmethod ALTER COLUMN id SET DEFAULT nextval('public.shipping_shippingmethod_id_seq'::regclass);


--
-- Name: shipping_shippingmethodtranslation id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.shipping_shippingmethodtranslation ALTER COLUMN id SET DEFAULT nextval('public.shipping_shippingmethodtranslation_id_seq'::regclass);


--
-- Name: shipping_shippingzone id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.shipping_shippingzone ALTER COLUMN id SET DEFAULT nextval('public.shipping_shippingzone_id_seq'::regclass);


--
-- Name: site_authorizationkey id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.site_authorizationkey ALTER COLUMN id SET DEFAULT nextval('public.site_authorizationkey_id_seq'::regclass);


--
-- Name: site_sitesettings id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.site_sitesettings ALTER COLUMN id SET DEFAULT nextval('public.site_sitesettings_id_seq'::regclass);


--
-- Name: site_sitesettingstranslation id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.site_sitesettingstranslation ALTER COLUMN id SET DEFAULT nextval('public.site_sitesettingstranslation_id_seq'::regclass);


--
-- Name: warehouse_allocation id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.warehouse_allocation ALTER COLUMN id SET DEFAULT nextval('public.warehouse_allocation_id_seq'::regclass);


--
-- Name: warehouse_stock id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.warehouse_stock ALTER COLUMN id SET DEFAULT nextval('public.warehouse_stock_id_seq'::regclass);


--
-- Name: warehouse_warehouse_shipping_zones id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.warehouse_warehouse_shipping_zones ALTER COLUMN id SET DEFAULT nextval('public.warehouse_warehouse_shipping_zones_id_seq'::regclass);


--
-- Name: webhook_webhook id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.webhook_webhook ALTER COLUMN id SET DEFAULT nextval('public.webhook_webhook_id_seq'::regclass);


--
-- Name: webhook_webhookevent id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.webhook_webhookevent ALTER COLUMN id SET DEFAULT nextval('public.webhook_webhookevent_id_seq'::regclass);


--
-- Name: wishlist_wishlist id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.wishlist_wishlist ALTER COLUMN id SET DEFAULT nextval('public.wishlist_wishlist_id_seq'::regclass);


--
-- Name: wishlist_wishlistitem id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.wishlist_wishlistitem ALTER COLUMN id SET DEFAULT nextval('public.wishlist_wishlistitem_id_seq'::regclass);


--
-- Name: wishlist_wishlistitem_variants id; Type: DEFAULT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.wishlist_wishlistitem_variants ALTER COLUMN id SET DEFAULT nextval('public.wishlist_wishlistitem_variants_id_seq'::regclass);


--
-- Data for Name: account_address; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.account_address (id, first_name, last_name, company_name, street_address_1, street_address_2, city, postal_code, country, country_area, phone, city_area, billing_details) FROM stdin;
\.


--
-- Data for Name: account_customerevent; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.account_customerevent (id, date, type, parameters, order_id, user_id) FROM stdin;
1	2021-02-27 16:19:15.56401+00	account_created	{}	\N	3
\.


--
-- Data for Name: account_customernote; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.account_customernote (id, date, content, is_public, customer_id, user_id) FROM stdin;
\.


--
-- Data for Name: account_staffnotificationrecipient; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.account_staffnotificationrecipient (id, staff_email, active, user_id) FROM stdin;
\.


--
-- Data for Name: account_user; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.account_user (id, is_superuser, email, is_staff, is_active, password, date_joined, last_login, default_billing_address_id, default_shipping_address_id, note, first_name, last_name, avatar, private_metadata, metadata, jwt_token_key) FROM stdin;
2	t	veubroina@gmail.com	t	t	pbkdf2_sha256$216000$aA4U3vswljK4$LXIFTSYSDrtW/WlAOVwPBLDD8uWcjZ/GmKJfRknsiWA=	2021-02-04 18:53:07.555501+00	2021-02-10 04:38:34.138146+00	\N	\N	\N				{}	{}	ghzZmyT598Qh
3	f	ciprian@trusca.net	f	f	pbkdf2_sha256$216000$79sX25GJsonF$SmyDuw5S4M36ss5z4nAW1TKm0uDlVUG/FF4Cq4FBn58=	2021-02-27 16:19:14.636819+00	\N	\N	\N	\N				{}	{}	O19LcS9zezkg
1	t	ciprian@sagital.ro	t	t	pbkdf2_sha256$216000$J9rvcaA3xFSm$IGWftSC7SFumQJGSWj1ez16vtzyuxMbiNidXaFHIXS0=	2021-02-04 16:18:48.431855+00	2021-03-14 20:06:57.913201+00	\N	\N	\N				{}	{}	0coil4Yyerak
\.


--
-- Data for Name: account_user_addresses; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.account_user_addresses (id, user_id, address_id) FROM stdin;
\.


--
-- Data for Name: account_user_groups; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.account_user_groups (id, user_id, group_id) FROM stdin;
\.


--
-- Data for Name: account_user_user_permissions; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.account_user_user_permissions (id, user_id, permission_id) FROM stdin;
\.


--
-- Data for Name: app_app; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.app_app (id, private_metadata, metadata, name, created, is_active, about_app, app_url, configuration_url, data_privacy, data_privacy_url, homepage_url, identifier, support_url, type, version) FROM stdin;
1	{}	{}	data-import	2021-02-05 16:50:08.695112+00	t	\N	\N	\N	\N	\N	\N	\N	\N	local	\N
\.


--
-- Data for Name: app_app_permissions; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.app_app_permissions (id, app_id, permission_id) FROM stdin;
1	1	194
2	1	164
3	1	69
4	1	5
5	1	295
6	1	236
7	1	31
8	1	237
9	1	82
10	1	181
11	1	87
12	1	250
13	1	60
14	1	30
15	1	223
\.


--
-- Data for Name: app_appinstallation; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.app_appinstallation (id, status, message, created_at, updated_at, app_name, manifest_url) FROM stdin;
\.


--
-- Data for Name: app_appinstallation_permissions; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.app_appinstallation_permissions (id, appinstallation_id, permission_id) FROM stdin;
\.


--
-- Data for Name: app_apptoken; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.app_apptoken (id, name, auth_token, app_id) FROM stdin;
1	Default	uej7bJDEgVtSk5ttlxbqvUlObNx7m8	1
\.


--
-- Data for Name: auth_group; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.auth_group (id, name) FROM stdin;
\.


--
-- Data for Name: auth_group_permissions; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.auth_group_permissions (id, group_id, permission_id) FROM stdin;
\.


--
-- Data for Name: auth_permission; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.auth_permission (id, name, content_type_id, codename) FROM stdin;
1	Can add plugin configuration	1	add_pluginconfiguration
2	Can change plugin configuration	1	change_pluginconfiguration
3	Can delete plugin configuration	1	delete_pluginconfiguration
4	Can view plugin configuration	1	view_pluginconfiguration
5	Manage plugins	1	manage_plugins
6	Can add content type	2	add_contenttype
7	Can change content type	2	change_contenttype
8	Can delete content type	2	delete_contenttype
9	Can view content type	2	view_contenttype
10	Can add site	3	add_site
11	Can change site	3	change_site
12	Can delete site	3	delete_site
13	Can view site	3	view_site
14	Can add permission	4	add_permission
15	Can change permission	4	change_permission
16	Can delete permission	4	delete_permission
17	Can view permission	4	view_permission
18	Can add group	5	add_group
19	Can change group	5	change_group
20	Can delete group	5	delete_group
21	Can view group	5	view_group
22	Can add address	6	add_address
23	Can change address	6	change_address
24	Can delete address	6	delete_address
25	Can view address	6	view_address
26	Can add user	7	add_user
27	Can change user	7	change_user
28	Can delete user	7	delete_user
29	Can view user	7	view_user
30	Manage customers.	7	manage_users
31	Manage staff.	7	manage_staff
32	Can add customer note	8	add_customernote
33	Can change customer note	8	change_customernote
34	Can delete customer note	8	delete_customernote
35	Can view customer note	8	view_customernote
36	Can add customer event	9	add_customerevent
37	Can change customer event	9	change_customerevent
38	Can delete customer event	9	delete_customerevent
39	Can view customer event	9	view_customerevent
40	Can add staff notification recipient	10	add_staffnotificationrecipient
41	Can change staff notification recipient	10	change_staffnotificationrecipient
42	Can delete staff notification recipient	10	delete_staffnotificationrecipient
43	Can view staff notification recipient	10	view_staffnotificationrecipient
44	Can add voucher	11	add_voucher
45	Can change voucher	11	change_voucher
46	Can delete voucher	11	delete_voucher
47	Can view voucher	11	view_voucher
48	Can add voucher customer	12	add_vouchercustomer
49	Can change voucher customer	12	change_vouchercustomer
50	Can delete voucher customer	12	delete_vouchercustomer
51	Can view voucher customer	12	view_vouchercustomer
52	Can add voucher translation	13	add_vouchertranslation
53	Can change voucher translation	13	change_vouchertranslation
54	Can delete voucher translation	13	delete_vouchertranslation
55	Can view voucher translation	13	view_vouchertranslation
56	Can add sale	14	add_sale
57	Can change sale	14	change_sale
58	Can delete sale	14	delete_sale
59	Can view sale	14	view_sale
60	Manage sales and vouchers.	14	manage_discounts
61	Can add sale translation	15	add_saletranslation
62	Can change sale translation	15	change_saletranslation
63	Can delete sale translation	15	delete_saletranslation
64	Can view sale translation	15	view_saletranslation
65	Can add gift card	16	add_giftcard
66	Can change gift card	16	change_giftcard
67	Can delete gift card	16	delete_giftcard
68	Can view gift card	16	view_giftcard
69	Manage gift cards.	16	manage_gift_card
70	Can add category	17	add_category
71	Can change category	17	change_category
72	Can delete category	17	delete_category
73	Can view category	17	view_category
74	Can add category translation	18	add_categorytranslation
75	Can change category translation	18	change_categorytranslation
76	Can delete category translation	18	delete_categorytranslation
77	Can view category translation	18	view_categorytranslation
78	Can add product type	19	add_producttype
79	Can change product type	19	change_producttype
80	Can delete product type	19	delete_producttype
81	Can view product type	19	view_producttype
82	Manage product types and attributes.	19	manage_product_types_and_attributes
83	Can add product	20	add_product
84	Can change product	20	change_product
85	Can delete product	20	delete_product
86	Can view product	20	view_product
87	Manage products.	20	manage_products
88	Can add product translation	21	add_producttranslation
89	Can change product translation	21	change_producttranslation
90	Can delete product translation	21	delete_producttranslation
91	Can view product translation	21	view_producttranslation
92	Can add product variant	22	add_productvariant
93	Can change product variant	22	change_productvariant
94	Can delete product variant	22	delete_productvariant
95	Can view product variant	22	view_productvariant
96	Can add product variant translation	23	add_productvarianttranslation
97	Can change product variant translation	23	change_productvarianttranslation
98	Can delete product variant translation	23	delete_productvarianttranslation
99	Can view product variant translation	23	view_productvarianttranslation
100	Can add digital content	24	add_digitalcontent
101	Can change digital content	24	change_digitalcontent
102	Can delete digital content	24	delete_digitalcontent
103	Can view digital content	24	view_digitalcontent
104	Can add digital content url	25	add_digitalcontenturl
105	Can change digital content url	25	change_digitalcontenturl
106	Can delete digital content url	25	delete_digitalcontenturl
107	Can view digital content url	25	view_digitalcontenturl
108	Can add assigned product attribute	26	add_assignedproductattribute
109	Can change assigned product attribute	26	change_assignedproductattribute
110	Can delete assigned product attribute	26	delete_assignedproductattribute
111	Can view assigned product attribute	26	view_assignedproductattribute
112	Can add assigned variant attribute	27	add_assignedvariantattribute
113	Can change assigned variant attribute	27	change_assignedvariantattribute
114	Can delete assigned variant attribute	27	delete_assignedvariantattribute
115	Can view assigned variant attribute	27	view_assignedvariantattribute
116	Can add attribute product	28	add_attributeproduct
117	Can change attribute product	28	change_attributeproduct
118	Can delete attribute product	28	delete_attributeproduct
119	Can view attribute product	28	view_attributeproduct
120	Can add attribute variant	29	add_attributevariant
121	Can change attribute variant	29	change_attributevariant
122	Can delete attribute variant	29	delete_attributevariant
123	Can view attribute variant	29	view_attributevariant
124	Can add attribute	30	add_attribute
125	Can change attribute	30	change_attribute
126	Can delete attribute	30	delete_attribute
127	Can view attribute	30	view_attribute
128	Can add attribute translation	31	add_attributetranslation
129	Can change attribute translation	31	change_attributetranslation
130	Can delete attribute translation	31	delete_attributetranslation
131	Can view attribute translation	31	view_attributetranslation
132	Can add attribute value	32	add_attributevalue
133	Can change attribute value	32	change_attributevalue
134	Can delete attribute value	32	delete_attributevalue
135	Can view attribute value	32	view_attributevalue
136	Can add attribute value translation	33	add_attributevaluetranslation
137	Can change attribute value translation	33	change_attributevaluetranslation
138	Can delete attribute value translation	33	delete_attributevaluetranslation
139	Can view attribute value translation	33	view_attributevaluetranslation
140	Can add product image	34	add_productimage
141	Can change product image	34	change_productimage
142	Can delete product image	34	delete_productimage
143	Can view product image	34	view_productimage
144	Can add variant image	35	add_variantimage
145	Can change variant image	35	change_variantimage
146	Can delete variant image	35	delete_variantimage
147	Can view variant image	35	view_variantimage
148	Can add collection product	36	add_collectionproduct
149	Can change collection product	36	change_collectionproduct
150	Can delete collection product	36	delete_collectionproduct
151	Can view collection product	36	view_collectionproduct
152	Can add collection	37	add_collection
153	Can change collection	37	change_collection
154	Can delete collection	37	delete_collection
155	Can view collection	37	view_collection
156	Can add collection translation	38	add_collectiontranslation
157	Can change collection translation	38	change_collectiontranslation
158	Can delete collection translation	38	delete_collectiontranslation
159	Can view collection translation	38	view_collectiontranslation
160	Can add checkout	39	add_checkout
161	Can change checkout	39	change_checkout
162	Can delete checkout	39	delete_checkout
163	Can view checkout	39	view_checkout
164	Manage checkouts	39	manage_checkouts
165	Can add checkout line	40	add_checkoutline
166	Can change checkout line	40	change_checkoutline
167	Can delete checkout line	40	delete_checkoutline
168	Can view checkout line	40	view_checkoutline
169	Can add export file	41	add_exportfile
170	Can change export file	41	change_exportfile
171	Can delete export file	41	delete_exportfile
172	Can view export file	41	view_exportfile
173	Can add export event	42	add_exportevent
174	Can change export event	42	change_exportevent
175	Can delete export event	42	delete_exportevent
176	Can view export event	42	view_exportevent
177	Can add menu	43	add_menu
178	Can change menu	43	change_menu
179	Can delete menu	43	delete_menu
180	Can view menu	43	view_menu
181	Manage navigation.	43	manage_menus
182	Can add menu item	44	add_menuitem
183	Can change menu item	44	change_menuitem
184	Can delete menu item	44	delete_menuitem
185	Can view menu item	44	view_menuitem
186	Can add menu item translation	45	add_menuitemtranslation
187	Can change menu item translation	45	change_menuitemtranslation
188	Can delete menu item translation	45	delete_menuitemtranslation
189	Can view menu item translation	45	view_menuitemtranslation
190	Can add order	46	add_order
191	Can change order	46	change_order
192	Can delete order	46	delete_order
193	Can view order	46	view_order
194	Manage orders.	46	manage_orders
195	Can add order line	47	add_orderline
196	Can change order line	47	change_orderline
197	Can delete order line	47	delete_orderline
198	Can view order line	47	view_orderline
199	Can add fulfillment	48	add_fulfillment
200	Can change fulfillment	48	change_fulfillment
201	Can delete fulfillment	48	delete_fulfillment
202	Can view fulfillment	48	view_fulfillment
203	Can add fulfillment line	49	add_fulfillmentline
204	Can change fulfillment line	49	change_fulfillmentline
205	Can delete fulfillment line	49	delete_fulfillmentline
206	Can view fulfillment line	49	view_fulfillmentline
207	Can add order event	50	add_orderevent
208	Can change order event	50	change_orderevent
209	Can delete order event	50	delete_orderevent
210	Can view order event	50	view_orderevent
211	Can add invoice	51	add_invoice
212	Can change invoice	51	change_invoice
213	Can delete invoice	51	delete_invoice
214	Can view invoice	51	view_invoice
215	Can add invoice event	52	add_invoiceevent
216	Can change invoice event	52	change_invoiceevent
217	Can delete invoice event	52	delete_invoiceevent
218	Can view invoice event	52	view_invoiceevent
219	Can add shipping zone	53	add_shippingzone
220	Can change shipping zone	53	change_shippingzone
221	Can delete shipping zone	53	delete_shippingzone
222	Can view shipping zone	53	view_shippingzone
223	Manage shipping.	53	manage_shipping
224	Can add shipping method	54	add_shippingmethod
225	Can change shipping method	54	change_shippingmethod
226	Can delete shipping method	54	delete_shippingmethod
227	Can view shipping method	54	view_shippingmethod
228	Can add shipping method translation	55	add_shippingmethodtranslation
229	Can change shipping method translation	55	change_shippingmethodtranslation
230	Can delete shipping method translation	55	delete_shippingmethodtranslation
231	Can view shipping method translation	55	view_shippingmethodtranslation
232	Can add site settings	56	add_sitesettings
233	Can change site settings	56	change_sitesettings
234	Can delete site settings	56	delete_sitesettings
235	Can view site settings	56	view_sitesettings
236	Manage settings.	56	manage_settings
237	Manage translations.	56	manage_translations
238	Can add site settings translation	57	add_sitesettingstranslation
239	Can change site settings translation	57	change_sitesettingstranslation
240	Can delete site settings translation	57	delete_sitesettingstranslation
241	Can view site settings translation	57	view_sitesettingstranslation
242	Can add authorization key	58	add_authorizationkey
243	Can change authorization key	58	change_authorizationkey
244	Can delete authorization key	58	delete_authorizationkey
245	Can view authorization key	58	view_authorizationkey
246	Can add page	59	add_page
247	Can change page	59	change_page
248	Can delete page	59	delete_page
249	Can view page	59	view_page
250	Manage pages.	59	manage_pages
251	Can add page translation	60	add_pagetranslation
252	Can change page translation	60	change_pagetranslation
253	Can delete page translation	60	delete_pagetranslation
254	Can view page translation	60	view_pagetranslation
255	Can add payment	61	add_payment
256	Can change payment	61	change_payment
257	Can delete payment	61	delete_payment
258	Can view payment	61	view_payment
259	Can add transaction	62	add_transaction
260	Can change transaction	62	change_transaction
261	Can delete transaction	62	delete_transaction
262	Can view transaction	62	view_transaction
263	Can add warehouse	63	add_warehouse
264	Can change warehouse	63	change_warehouse
265	Can delete warehouse	63	delete_warehouse
266	Can view warehouse	63	view_warehouse
267	Can add stock	64	add_stock
268	Can change stock	64	change_stock
269	Can delete stock	64	delete_stock
270	Can view stock	64	view_stock
271	Can add allocation	65	add_allocation
272	Can change allocation	65	change_allocation
273	Can delete allocation	65	delete_allocation
274	Can view allocation	65	view_allocation
275	Can add webhook	66	add_webhook
276	Can change webhook	66	change_webhook
277	Can delete webhook	66	delete_webhook
278	Can view webhook	66	view_webhook
279	Can add webhook event	67	add_webhookevent
280	Can change webhook event	67	change_webhookevent
281	Can delete webhook event	67	delete_webhookevent
282	Can view webhook event	67	view_webhookevent
283	Can add wishlist	68	add_wishlist
284	Can change wishlist	68	change_wishlist
285	Can delete wishlist	68	delete_wishlist
286	Can view wishlist	68	view_wishlist
287	Can add wishlist item	69	add_wishlistitem
288	Can change wishlist item	69	change_wishlistitem
289	Can delete wishlist item	69	delete_wishlistitem
290	Can view wishlist item	69	view_wishlistitem
291	Can add app	70	add_app
292	Can change app	70	change_app
293	Can delete app	70	delete_app
294	Can view app	70	view_app
295	Manage apps	70	manage_apps
296	Can add app token	71	add_apptoken
297	Can change app token	71	change_apptoken
298	Can delete app token	71	delete_apptoken
299	Can view app token	71	view_apptoken
300	Can add app installation	72	add_appinstallation
301	Can change app installation	72	change_appinstallation
302	Can delete app installation	72	delete_appinstallation
303	Can view app installation	72	view_appinstallation
304	Can add conversion rate	73	add_conversionrate
305	Can change conversion rate	73	change_conversionrate
306	Can delete conversion rate	73	delete_conversionrate
307	Can view conversion rate	73	view_conversionrate
308	Can add vat	74	add_vat
309	Can change vat	74	change_vat
310	Can delete vat	74	delete_vat
311	Can view vat	74	view_vat
312	Can add rate types	75	add_ratetypes
313	Can change rate types	75	change_ratetypes
314	Can delete rate types	75	delete_ratetypes
315	Can view rate types	75	view_ratetypes
\.


--
-- Data for Name: checkout_checkout; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.checkout_checkout (created, last_change, email, token, quantity, user_id, billing_address_id, discount_amount, discount_name, note, shipping_address_id, shipping_method_id, voucher_code, translated_discount_name, metadata, private_metadata, currency, country, redirect_url, tracking_code) FROM stdin;
\.


--
-- Data for Name: checkout_checkout_gift_cards; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.checkout_checkout_gift_cards (id, checkout_id, giftcard_id) FROM stdin;
\.


--
-- Data for Name: checkout_checkoutline; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.checkout_checkoutline (id, quantity, checkout_id, variant_id, data) FROM stdin;
\.


--
-- Data for Name: csv_exportevent; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.csv_exportevent (id, date, type, parameters, app_id, export_file_id, user_id) FROM stdin;
\.


--
-- Data for Name: csv_exportfile; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.csv_exportfile (id, status, created_at, updated_at, content_file, app_id, user_id, message) FROM stdin;
\.


--
-- Data for Name: discount_sale; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.discount_sale (id, name, type, value, end_date, start_date) FROM stdin;
\.


--
-- Data for Name: discount_sale_categories; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.discount_sale_categories (id, sale_id, category_id) FROM stdin;
\.


--
-- Data for Name: discount_sale_collections; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.discount_sale_collections (id, sale_id, collection_id) FROM stdin;
\.


--
-- Data for Name: discount_sale_products; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.discount_sale_products (id, sale_id, product_id) FROM stdin;
\.


--
-- Data for Name: discount_saletranslation; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.discount_saletranslation (id, language_code, name, sale_id) FROM stdin;
\.


--
-- Data for Name: discount_voucher; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.discount_voucher (id, type, name, code, usage_limit, used, start_date, end_date, discount_value_type, discount_value, min_spent_amount, apply_once_per_order, countries, min_checkout_items_quantity, apply_once_per_customer, currency) FROM stdin;
\.


--
-- Data for Name: discount_voucher_categories; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.discount_voucher_categories (id, voucher_id, category_id) FROM stdin;
\.


--
-- Data for Name: discount_voucher_collections; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.discount_voucher_collections (id, voucher_id, collection_id) FROM stdin;
\.


--
-- Data for Name: discount_voucher_products; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.discount_voucher_products (id, voucher_id, product_id) FROM stdin;
\.


--
-- Data for Name: discount_vouchercustomer; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.discount_vouchercustomer (id, customer_email, voucher_id) FROM stdin;
\.


--
-- Data for Name: discount_vouchertranslation; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.discount_vouchertranslation (id, language_code, name, voucher_id) FROM stdin;
\.


--
-- Data for Name: django_content_type; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.django_content_type (id, app_label, model) FROM stdin;
1	plugins	pluginconfiguration
2	contenttypes	contenttype
3	sites	site
4	auth	permission
5	auth	group
6	account	address
7	account	user
8	account	customernote
9	account	customerevent
10	account	staffnotificationrecipient
11	discount	voucher
12	discount	vouchercustomer
13	discount	vouchertranslation
14	discount	sale
15	discount	saletranslation
16	giftcard	giftcard
17	product	category
18	product	categorytranslation
19	product	producttype
20	product	product
21	product	producttranslation
22	product	productvariant
23	product	productvarianttranslation
24	product	digitalcontent
25	product	digitalcontenturl
26	product	assignedproductattribute
27	product	assignedvariantattribute
28	product	attributeproduct
29	product	attributevariant
30	product	attribute
31	product	attributetranslation
32	product	attributevalue
33	product	attributevaluetranslation
34	product	productimage
35	product	variantimage
36	product	collectionproduct
37	product	collection
38	product	collectiontranslation
39	checkout	checkout
40	checkout	checkoutline
41	csv	exportfile
42	csv	exportevent
43	menu	menu
44	menu	menuitem
45	menu	menuitemtranslation
46	order	order
47	order	orderline
48	order	fulfillment
49	order	fulfillmentline
50	order	orderevent
51	invoice	invoice
52	invoice	invoiceevent
53	shipping	shippingzone
54	shipping	shippingmethod
55	shipping	shippingmethodtranslation
56	site	sitesettings
57	site	sitesettingstranslation
58	site	authorizationkey
59	page	page
60	page	pagetranslation
61	payment	payment
62	payment	transaction
63	warehouse	warehouse
64	warehouse	stock
65	warehouse	allocation
66	webhook	webhook
67	webhook	webhookevent
68	wishlist	wishlist
69	wishlist	wishlistitem
70	app	app
71	app	apptoken
72	app	appinstallation
73	django_prices_openexchangerates	conversionrate
74	django_prices_vatlayer	vat
75	django_prices_vatlayer	ratetypes
\.


--
-- Data for Name: django_migrations; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.django_migrations (id, app, name, applied) FROM stdin;
1	plugins	0001_initial	2021-02-04 16:14:23.974976+00
2	plugins	0002_auto_20200417_0335	2021-02-04 16:14:24.343942+00
3	contenttypes	0001_initial	2021-02-04 16:14:24.3884+00
4	contenttypes	0002_remove_content_type_name	2021-02-04 16:14:24.488057+00
5	auth	0001_initial	2021-02-04 16:14:24.558696+00
6	auth	0002_alter_permission_name_max_length	2021-02-04 16:14:24.696045+00
7	auth	0003_alter_user_email_max_length	2021-02-04 16:14:24.714693+00
8	auth	0004_alter_user_username_opts	2021-02-04 16:14:24.732477+00
9	auth	0005_alter_user_last_login_null	2021-02-04 16:14:24.758301+00
10	auth	0006_require_contenttypes_0002	2021-02-04 16:14:24.799842+00
11	auth	0007_alter_validators_add_error_messages	2021-02-04 16:14:24.89918+00
12	auth	0008_alter_user_username_max_length	2021-02-04 16:14:24.95264+00
13	auth	0009_alter_user_last_name_max_length	2021-02-04 16:14:24.983933+00
14	auth	0010_alter_group_name_max_length	2021-02-04 16:14:25.022168+00
15	auth	0011_update_proxy_permissions	2021-02-04 16:14:25.057482+00
16	product	0001_initial	2021-02-04 16:14:25.411128+00
17	product	0002_auto_20150722_0545	2021-02-04 16:14:25.738328+00
18	product	0003_auto_20150820_2016	2021-02-04 16:14:25.798969+00
19	product	0003_auto_20150820_1955	2021-02-04 16:14:25.830757+00
20	product	0004_merge	2021-02-04 16:14:25.844711+00
21	product	0005_auto_20150825_1433	2021-02-04 16:14:25.937037+00
22	product	0006_product_updated_at	2021-02-04 16:14:26.426113+00
23	product	0007_auto_20160112_1025	2021-02-04 16:14:26.485944+00
24	product	0008_auto_20160114_0733	2021-02-04 16:14:26.557691+00
25	product	0009_discount_categories	2021-02-04 16:14:26.624222+00
26	product	0010_auto_20160129_0826	2021-02-04 16:14:26.720108+00
27	product	0011_stock_quantity_allocated	2021-02-04 16:14:26.738844+00
28	product	0012_auto_20160218_0812	2021-02-04 16:14:26.831957+00
29	product	0013_auto_20161207_0555	2021-02-04 16:14:26.908225+00
30	product	0014_auto_20161207_0840	2021-02-04 16:14:26.952545+00
31	product	0015_transfer_locations	2021-02-04 16:14:27.020593+00
32	product	0016_auto_20161207_0843	2021-02-04 16:14:27.075653+00
33	product	0017_remove_stock_location	2021-02-04 16:14:27.112693+00
34	product	0018_auto_20161207_0844	2021-02-04 16:14:27.280096+00
35	product	0019_auto_20161212_0230	2021-02-04 16:14:27.479919+00
36	product	0020_attribute_data_to_class	2021-02-04 16:14:27.742623+00
37	product	0021_add_hstore_extension	2021-02-04 16:14:28.237453+00
38	product	0022_auto_20161212_0301	2021-02-04 16:14:28.387237+00
39	product	0023_auto_20161211_1912	2021-02-04 16:14:28.541242+00
40	product	0024_migrate_json_data	2021-02-04 16:14:28.601556+00
41	product	0025_auto_20161219_0517	2021-02-04 16:14:28.690694+00
42	product	0026_auto_20161230_0347	2021-02-04 16:14:28.723471+00
43	product	0027_auto_20170113_0435	2021-02-04 16:14:28.935058+00
44	product	0013_auto_20161130_0608	2021-02-04 16:14:28.966077+00
45	product	0014_remove_productvariant_attributes	2021-02-04 16:14:29.048184+00
46	product	0015_productvariant_attributes	2021-02-04 16:14:29.103232+00
47	product	0016_auto_20161204_0311	2021-02-04 16:14:29.127872+00
48	product	0017_attributechoicevalue_slug	2021-02-04 16:14:29.145377+00
49	product	0018_auto_20161212_0725	2021-02-04 16:14:29.198921+00
50	product	0026_merge_20161221_0845	2021-02-04 16:14:29.207054+00
51	product	0028_merge_20170116_1016	2021-02-04 16:14:29.214405+00
52	product	0029_product_is_featured	2021-02-04 16:14:29.236952+00
53	product	0030_auto_20170206_0407	2021-02-04 16:14:29.72291+00
54	product	0031_auto_20170206_0601	2021-02-04 16:14:29.757551+00
55	product	0032_auto_20170216_0438	2021-02-04 16:14:29.780331+00
56	product	0033_auto_20170227_0757	2021-02-04 16:14:29.848928+00
57	product	0034_product_is_published	2021-02-04 16:14:29.871613+00
58	product	0035_auto_20170919_0846	2021-02-04 16:14:29.903065+00
59	product	0036_auto_20171115_0608	2021-02-04 16:14:29.94528+00
60	product	0037_auto_20171124_0847	2021-02-04 16:14:30.110307+00
61	product	0038_auto_20171129_0616	2021-02-04 16:14:30.223709+00
62	product	0037_auto_20171129_1004	2021-02-04 16:14:30.518213+00
63	product	0039_merge_20171130_0727	2021-02-04 16:14:30.634183+00
64	product	0040_auto_20171205_0428	2021-02-04 16:14:30.6702+00
65	product	0041_auto_20171205_0546	2021-02-04 16:14:30.694868+00
66	product	0042_auto_20171206_0501	2021-02-04 16:14:30.763101+00
67	product	0043_auto_20171207_0839	2021-02-04 16:14:31.1471+00
68	product	0044_auto_20180108_0814	2021-02-04 16:14:32.203079+00
69	product	0045_md_to_html	2021-02-04 16:14:32.762597+00
70	product	0046_product_category	2021-02-04 16:14:32.83555+00
71	product	0047_auto_20180117_0359	2021-02-04 16:14:32.94622+00
72	product	0048_product_class_to_type	2021-02-04 16:14:33.212956+00
73	product	0049_collection	2021-02-04 16:14:33.413488+00
74	product	0050_auto_20180131_0746	2021-02-04 16:14:33.657164+00
75	product	0051_auto_20180202_1106	2021-02-04 16:14:33.677339+00
76	product	0052_slug_field_length	2021-02-04 16:14:33.763174+00
77	product	0053_product_seo_description	2021-02-04 16:14:33.949771+00
78	product	0053_auto_20180305_1002	2021-02-04 16:14:33.991467+00
79	product	0054_merge_20180320_1108	2021-02-04 16:14:34.002007+00
80	shipping	0001_initial	2021-02-04 16:14:34.0731+00
81	shipping	0002_auto_20160906_0741	2021-02-04 16:14:34.340125+00
82	shipping	0003_auto_20170116_0700	2021-02-04 16:14:34.382856+00
83	shipping	0004_auto_20170206_0407	2021-02-04 16:14:34.748811+00
84	shipping	0005_auto_20170906_0556	2021-02-04 16:14:34.762571+00
85	shipping	0006_auto_20171109_0908	2021-02-04 16:14:34.777777+00
86	shipping	0007_auto_20171129_1004	2021-02-04 16:14:34.793141+00
87	shipping	0008_auto_20180108_0814	2021-02-04 16:14:34.826989+00
88	userprofile	0001_initial	2021-02-04 16:14:35.480364+00
89	order	0001_initial	2021-02-04 16:14:36.17301+00
90	order	0002_auto_20150820_1955	2021-02-04 16:14:36.617118+00
91	order	0003_auto_20150825_1433	2021-02-04 16:14:36.66695+00
92	order	0004_order_total	2021-02-04 16:14:36.730115+00
93	order	0005_deliverygroup_last_updated	2021-02-04 16:14:36.765314+00
94	order	0006_deliverygroup_shipping_method	2021-02-04 16:14:37.785925+00
95	order	0007_deliverygroup_tracking_number	2021-02-04 16:14:37.856913+00
96	order	0008_auto_20151026_0820	2021-02-04 16:14:37.934284+00
97	order	0009_auto_20151201_0820	2021-02-04 16:14:38.033868+00
98	order	0010_auto_20160119_0541	2021-02-04 16:14:38.57275+00
99	discount	0001_initial	2021-02-04 16:14:38.664316+00
100	discount	0002_voucher	2021-02-04 16:14:39.015416+00
101	discount	0003_auto_20160207_0534	2021-02-04 16:14:39.756636+00
102	order	0011_auto_20160207_0534	2021-02-04 16:14:40.271197+00
103	order	0012_auto_20160216_1032	2021-02-04 16:14:40.615462+00
104	order	0013_auto_20160906_0741	2021-02-04 16:14:40.755782+00
105	order	0014_auto_20161028_0955	2021-02-04 16:14:40.895033+00
106	order	0015_auto_20170206_0407	2021-02-04 16:14:42.234457+00
107	order	0016_order_language_code	2021-02-04 16:14:42.434823+00
108	order	0017_auto_20170906_0556	2021-02-04 16:14:42.486208+00
109	order	0018_auto_20170919_0839	2021-02-04 16:14:42.532446+00
110	order	0019_auto_20171109_1423	2021-02-04 16:14:43.108612+00
111	order	0020_auto_20171123_0609	2021-02-04 16:14:43.450036+00
112	order	0021_auto_20171129_1004	2021-02-04 16:14:43.617629+00
113	order	0022_auto_20171205_0428	2021-02-04 16:14:43.79018+00
114	order	0023_auto_20171206_0506	2021-02-04 16:14:43.877741+00
115	order	0024_remove_order_status	2021-02-04 16:14:44.091527+00
116	order	0025_auto_20171214_1015	2021-02-04 16:14:44.17027+00
117	order	0026_auto_20171218_0428	2021-02-04 16:14:44.674816+00
118	order	0027_auto_20180108_0814	2021-02-04 16:14:46.530227+00
119	order	0028_status_fsm	2021-02-04 16:14:46.80841+00
120	order	0029_auto_20180111_0845	2021-02-04 16:14:46.908262+00
121	order	0030_auto_20180118_0605	2021-02-04 16:14:47.473587+00
122	order	0031_auto_20180119_0405	2021-02-04 16:14:48.99961+00
123	order	0032_orderline_is_shipping_required	2021-02-04 16:14:49.230522+00
124	order	0033_auto_20180123_0832	2021-02-04 16:14:49.767242+00
125	order	0034_auto_20180221_1056	2021-02-04 16:14:49.856441+00
126	order	0035_auto_20180221_1057	2021-02-04 16:14:50.42496+00
127	order	0036_remove_order_total_tax	2021-02-04 16:14:50.492216+00
128	order	0037_auto_20180228_0450	2021-02-04 16:14:50.842935+00
129	order	0038_auto_20180228_0451	2021-02-04 16:14:51.238709+00
130	order	0039_auto_20180312_1203	2021-02-04 16:14:51.784921+00
131	order	0040_auto_20180210_0422	2021-02-04 16:14:52.463846+00
132	order	0041_auto_20180222_0458	2021-02-04 16:14:53.306372+00
133	order	0042_auto_20180227_0436	2021-02-04 16:14:53.504882+00
134	order	0043_auto_20180322_0655	2021-02-04 16:14:53.70211+00
135	order	0044_auto_20180326_1055	2021-02-04 16:14:53.944019+00
136	order	0045_auto_20180329_0142	2021-02-04 16:14:54.701871+00
137	order	0046_order_line_taxes	2021-02-04 16:14:54.967238+00
138	order	0047_order_line_name_length	2021-02-04 16:14:55.03574+00
139	order	0048_auto_20180629_1055	2021-02-04 16:14:55.500025+00
140	order	0049_auto_20180719_0520	2021-02-04 16:14:56.151101+00
141	order	0050_auto_20180803_0528	2021-02-04 16:14:56.658669+00
142	order	0050_auto_20180803_0337	2021-02-04 16:14:56.735304+00
143	order	0051_merge_20180807_0704	2021-02-04 16:14:56.743092+00
144	order	0052_auto_20180822_0720	2021-02-04 16:14:56.843862+00
145	order	0053_orderevent	2021-02-04 16:14:57.227798+00
146	order	0054_move_data_to_order_events	2021-02-04 16:14:57.472179+00
147	order	0055_remove_order_note_order_history_entry	2021-02-04 16:14:58.323723+00
148	order	0056_auto_20180911_1541	2021-02-04 16:14:58.515688+00
149	order	0057_orderevent_parameters_new	2021-02-04 16:14:58.595842+00
150	order	0058_remove_orderevent_parameters	2021-02-04 16:14:58.922461+00
151	order	0059_auto_20180913_0841	2021-02-04 16:14:58.97315+00
152	order	0060_auto_20180919_0731	2021-02-04 16:14:59.021246+00
153	order	0061_auto_20180920_0859	2021-02-04 16:14:59.234226+00
154	order	0062_auto_20180921_0949	2021-02-04 16:14:59.319099+00
155	order	0063_auto_20180926_0446	2021-02-04 16:14:59.613746+00
156	order	0064_auto_20181016_0819	2021-02-04 16:14:59.675586+00
157	cart	0001_initial	2021-02-04 16:15:00.184315+00
158	cart	0002_auto_20161014_1221	2021-02-04 16:15:01.261339+00
159	cart	fix_empty_data_in_lines	2021-02-04 16:15:01.390664+00
160	cart	0001_auto_20170113_0435	2021-02-04 16:15:02.383464+00
161	cart	0002_auto_20170206_0407	2021-02-04 16:15:03.252484+00
162	cart	0003_auto_20170906_0556	2021-02-04 16:15:03.451103+00
163	cart	0004_auto_20171129_1004	2021-02-04 16:15:03.51579+00
164	cart	0005_auto_20180108_0814	2021-02-04 16:15:04.617728+00
165	cart	0006_auto_20180221_0825	2021-02-04 16:15:04.952905+00
166	userprofile	0002_auto_20150907_0602	2021-02-04 16:15:05.153563+00
167	userprofile	0003_auto_20151104_1102	2021-02-04 16:15:05.311399+00
168	userprofile	0004_auto_20160114_0419	2021-02-04 16:15:05.449017+00
169	userprofile	0005_auto_20160205_0651	2021-02-04 16:15:05.975963+00
170	userprofile	0006_auto_20160829_0819	2021-02-04 16:15:06.269115+00
171	userprofile	0007_auto_20161115_0940	2021-02-04 16:15:06.482837+00
172	userprofile	0008_auto_20161115_1011	2021-02-04 16:15:06.664667+00
173	userprofile	0009_auto_20170206_0407	2021-02-04 16:15:06.819507+00
174	userprofile	0010_auto_20170919_0839	2021-02-04 16:15:07.029284+00
175	userprofile	0011_auto_20171110_0552	2021-02-04 16:15:07.123131+00
176	userprofile	0012_auto_20171117_0846	2021-02-04 16:15:07.745932+00
177	userprofile	0013_auto_20171120_0521	2021-02-04 16:15:07.873525+00
178	userprofile	0014_auto_20171129_1004	2021-02-04 16:15:08.08582+00
179	userprofile	0015_auto_20171213_0734	2021-02-04 16:15:08.163383+00
180	userprofile	0016_auto_20180108_0814	2021-02-04 16:15:10.373159+00
181	account	0017_auto_20180206_0957	2021-02-04 16:15:10.665809+00
182	account	0018_auto_20180426_0641	2021-02-04 16:15:10.924329+00
183	account	0019_auto_20180528_1205	2021-02-04 16:15:11.030543+00
184	checkout	0007_merge_cart_with_checkout	2021-02-04 16:15:12.669084+00
185	checkout	0008_rename_tables	2021-02-04 16:15:12.977049+00
186	checkout	0009_cart_translated_discount_name	2021-02-04 16:15:13.0213+00
187	checkout	0010_auto_20180822_0720	2021-02-04 16:15:13.914272+00
188	checkout	0011_auto_20180913_0817	2021-02-04 16:15:14.064971+00
189	checkout	0012_remove_cartline_data	2021-02-04 16:15:14.366887+00
190	checkout	0013_auto_20180913_0841	2021-02-04 16:15:14.585545+00
191	checkout	0014_auto_20180921_0751	2021-02-04 16:15:14.634411+00
192	checkout	0015_auto_20181017_1346	2021-02-04 16:15:15.338991+00
193	payment	0001_initial	2021-02-04 16:15:16.321138+00
194	payment	0002_transfer_payment_to_payment_method	2021-02-04 16:15:17.330525+00
195	order	0065_auto_20181017_1346	2021-02-04 16:15:18.521114+00
196	order	0066_auto_20181023_0319	2021-02-04 16:15:18.698019+00
197	order	0067_auto_20181102_1054	2021-02-04 16:15:19.184005+00
198	order	0068_order_checkout_token	2021-02-04 16:15:19.270317+00
199	order	0069_auto_20190225_2305	2021-02-04 16:15:19.580807+00
200	order	0070_drop_update_event_and_rename_events	2021-02-04 16:15:19.768273+00
201	account	0020_user_token	2021-02-04 16:15:20.17961+00
202	account	0021_unique_token	2021-02-04 16:15:20.319028+00
203	account	0022_auto_20180718_0956	2021-02-04 16:15:20.644023+00
204	account	0023_auto_20180719_0520	2021-02-04 16:15:20.682251+00
205	account	0024_auto_20181011_0737	2021-02-04 16:15:20.754564+00
206	account	0025_auto_20190314_0550	2021-02-04 16:15:21.002126+00
207	account	0026_user_avatar	2021-02-04 16:15:21.046061+00
208	account	0027_customerevent	2021-02-04 16:15:21.49353+00
209	account	0028_user_private_meta	2021-02-04 16:15:21.549704+00
210	account	0029_user_meta	2021-02-04 16:15:21.611779+00
211	account	0030_auto_20190719_0733	2021-02-04 16:15:22.255794+00
212	account	0031_auto_20190719_0745	2021-02-04 16:15:22.375932+00
213	account	0032_remove_user_token	2021-02-04 16:15:22.585488+00
214	account	0033_serviceaccount	2021-02-04 16:15:22.696965+00
215	webhook	0001_initial	2021-02-04 16:15:23.412038+00
216	webhook	0002_webhook_name	2021-02-04 16:15:23.514836+00
217	sites	0001_initial	2021-02-04 16:15:24.125246+00
218	sites	0002_alter_domain_unique	2021-02-04 16:15:24.175628+00
219	site	0001_initial	2021-02-04 16:15:24.212024+00
220	site	0002_add_default_data	2021-02-04 16:15:24.446819+00
221	site	0003_sitesettings_description	2021-02-04 16:15:24.484192+00
222	site	0004_auto_20170221_0426	2021-02-04 16:15:24.586186+00
223	site	0005_auto_20170906_0556	2021-02-04 16:15:24.713031+00
224	site	0006_auto_20171025_0454	2021-02-04 16:15:24.787537+00
225	site	0007_auto_20171027_0856	2021-02-04 16:15:25.323388+00
226	site	0008_auto_20171027_0856	2021-02-04 16:15:26.240913+00
227	site	0009_auto_20171109_0849	2021-02-04 16:15:26.286039+00
228	site	0010_auto_20171113_0958	2021-02-04 16:15:26.303732+00
229	site	0011_auto_20180108_0814	2021-02-04 16:15:26.532986+00
230	page	0001_initial	2021-02-04 16:15:26.567195+00
231	menu	0001_initial	2021-02-04 16:15:26.709715+00
232	menu	0002_auto_20180319_0412	2021-02-04 16:15:26.927744+00
233	site	0012_auto_20180405_0757	2021-02-04 16:15:27.327397+00
234	menu	0003_auto_20180405_0854	2021-02-04 16:15:27.553131+00
235	site	0013_assign_default_menus	2021-02-04 16:15:27.682642+00
236	site	0014_handle_taxes	2021-02-04 16:15:27.730062+00
237	site	0015_sitesettings_handle_stock_by_default	2021-02-04 16:15:27.750337+00
238	site	0016_auto_20180719_0520	2021-02-04 16:15:27.768917+00
239	site	0017_auto_20180803_0528	2021-02-04 16:15:28.264965+00
240	product	0055_auto_20180321_0417	2021-02-04 16:15:28.60387+00
241	product	0056_auto_20180330_0321	2021-02-04 16:15:29.183788+00
242	product	0057_auto_20180403_0852	2021-02-04 16:15:29.235477+00
243	product	0058_auto_20180329_0142	2021-02-04 16:15:29.840324+00
244	product	0059_generate_variant_name_from_attrs	2021-02-04 16:15:30.077376+00
245	product	0060_collection_is_published	2021-02-04 16:15:30.404682+00
246	product	0061_product_taxes	2021-02-04 16:15:30.480133+00
247	product	0062_sortable_models	2021-02-04 16:15:31.854798+00
248	product	0063_required_attr_value_order	2021-02-04 16:15:31.953891+00
249	product	0064_productvariant_handle_stock	2021-02-04 16:15:31.991662+00
250	product	0065_auto_20180719_0520	2021-02-04 16:15:32.053336+00
251	product	0066_auto_20180803_0528	2021-02-04 16:15:33.558617+00
252	site	0018_sitesettings_homepage_collection	2021-02-04 16:15:33.856139+00
253	site	0019_sitesettings_default_weight_unit	2021-02-04 16:15:34.018538+00
254	site	0020_auto_20190301_0336	2021-02-04 16:15:34.058621+00
255	site	0021_auto_20190326_0521	2021-02-04 16:15:34.125146+00
256	site	0022_sitesettings_company_address	2021-02-04 16:15:34.406862+00
257	site	0023_auto_20191007_0835	2021-02-04 16:15:34.890317+00
258	site	0024_sitesettings_customer_set_password_url	2021-02-04 16:15:34.936939+00
259	site	0025_auto_20191024_0552	2021-02-04 16:15:35.21254+00
260	shipping	0009_auto_20180629_1055	2021-02-04 16:15:35.391801+00
261	shipping	0010_auto_20180719_0520	2021-02-04 16:15:35.436087+00
262	shipping	0011_auto_20180802_1238	2021-02-04 16:15:35.47707+00
263	shipping	0012_remove_legacy_shipping_methods	2021-02-04 16:15:36.593288+00
264	shipping	0013_auto_20180822_0721	2021-02-04 16:15:38.414962+00
265	shipping	0014_auto_20180920_0956	2021-02-04 16:15:38.897091+00
266	shipping	0015_auto_20190305_0640	2021-02-04 16:15:38.947955+00
267	shipping	0016_shippingmethod_meta	2021-02-04 16:15:39.443923+00
268	shipping	0017_django_price_2	2021-02-04 16:15:39.911017+00
269	product	0067_remove_product_is_featured	2021-02-04 16:15:39.968593+00
270	product	0068_auto_20180822_0720	2021-02-04 16:15:40.175262+00
271	product	0069_auto_20180912_0326	2021-02-04 16:15:40.40222+00
272	product	0070_auto_20180912_0329	2021-02-04 16:15:40.555528+00
273	product	0071_attributechoicevalue_value	2021-02-04 16:15:40.744402+00
274	product	0072_auto_20180925_1048	2021-02-04 16:15:41.406279+00
275	product	0073_auto_20181010_0729	2021-02-04 16:15:42.508789+00
276	product	0074_auto_20181010_0730	2021-02-04 16:15:43.715271+00
277	product	0075_auto_20181010_0842	2021-02-04 16:15:44.941058+00
278	product	0076_auto_20181012_1146	2021-02-04 16:15:45.264775+00
279	product	0077_generate_versatile_background_images	2021-02-04 16:15:45.284431+00
280	product	0078_auto_20181120_0437	2021-02-04 16:15:45.340847+00
281	product	0079_default_tax_rate_instead_of_empty_field	2021-02-04 16:15:45.471727+00
282	product	0080_collection_published_date	2021-02-04 16:15:45.778214+00
283	product	0080_auto_20181214_0440	2021-02-04 16:15:46.042447+00
284	product	0081_merge_20181215_1659	2021-02-04 16:15:46.05142+00
285	product	0081_auto_20181218_0024	2021-02-04 16:15:46.154328+00
286	product	0082_merge_20181219_1440	2021-02-04 16:15:46.307928+00
287	product	0083_auto_20190104_0443	2021-02-04 16:15:46.405285+00
288	product	0084_auto_20190122_0113	2021-02-04 16:15:46.761093+00
289	product	0085_auto_20190125_0025	2021-02-04 16:15:47.131582+00
290	product	0086_product_publication_date	2021-02-04 16:15:47.412875+00
291	product	0087_auto_20190208_0326	2021-02-04 16:15:47.492618+00
292	product	0088_auto_20190220_1928	2021-02-04 16:15:47.533857+00
293	product	0089_auto_20190225_0252	2021-02-04 16:15:47.805821+00
294	product	0090_auto_20190328_0608	2021-02-04 16:15:48.160365+00
295	product	0091_auto_20190402_0853	2021-02-04 16:15:48.849825+00
296	product	0092_auto_20190507_0309	2021-02-04 16:15:49.946276+00
297	product	0093_auto_20190521_0124	2021-02-04 16:15:51.346157+00
298	product	0094_auto_20190618_0430	2021-02-04 16:15:51.626355+00
299	product	0095_auto_20190618_0842	2021-02-04 16:15:51.800886+00
300	product	0096_auto_20190719_0339	2021-02-04 16:15:52.093586+00
301	product	0097_auto_20190719_0458	2021-02-04 16:15:52.33647+00
302	product	0098_auto_20190719_0733	2021-02-04 16:15:52.479796+00
303	product	0099_auto_20190719_0745	2021-02-04 16:15:52.906289+00
304	product	0096_raw_html_to_json	2021-02-04 16:15:53.445976+00
305	product	0100_merge_20190719_0803	2021-02-04 16:15:53.45631+00
306	product	0101_auto_20190719_0839	2021-02-04 16:15:54.099606+00
307	product	0102_migrate_data_enterprise_grade_attributes	2021-02-04 16:15:54.886566+00
308	product	0103_schema_data_enterprise_grade_attributes	2021-02-04 16:15:58.460924+00
309	product	0104_fix_invalid_attributes_map	2021-02-04 16:15:58.883635+00
310	product	0105_product_minimal_variant_price	2021-02-04 16:15:59.183189+00
311	product	0106_django_prices_2	2021-02-04 16:15:59.540382+00
312	product	0107_attributes_map_to_m2m	2021-02-04 16:16:01.656235+00
313	product	0108_auto_20191003_0422	2021-02-04 16:16:03.000279+00
314	product	0109_auto_20191006_1433	2021-02-04 16:16:03.162008+00
315	product	0110_auto_20191108_0340	2021-02-04 16:16:03.634886+00
316	account	0034_service_account_token	2021-02-04 16:16:04.491841+00
317	account	0035_staffnotificationrecipient	2021-02-04 16:16:04.705271+00
318	account	0036_auto_20191209_0407	2021-02-04 16:16:04.922962+00
319	account	0037_auto_20191219_0944	2021-02-04 16:16:04.973048+00
320	warehouse	0001_initial	2021-02-04 16:16:06.747922+00
321	product	0111_auto_20191209_0437	2021-02-04 16:16:07.402937+00
322	product	0112_auto_20200129_0050	2021-02-04 16:16:08.46252+00
323	product	0113_auto_20200129_0717	2021-02-04 16:16:10.324704+00
324	product	0114_auto_20200129_0815	2021-02-04 16:16:10.85651+00
325	product	0115_auto_20200221_0257	2021-02-04 16:16:12.108551+00
326	giftcard	0001_initial	2021-02-04 16:16:12.476291+00
327	order	0071_order_gift_cards	2021-02-04 16:16:13.459116+00
328	order	0072_django_price_2	2021-02-04 16:16:13.974931+00
329	order	0073_auto_20190829_0249	2021-02-04 16:16:15.318738+00
330	order	0074_auto_20190930_0731	2021-02-04 16:16:15.948903+00
331	order	0075_auto_20191006_1433	2021-02-04 16:16:16.048151+00
332	order	0076_auto_20191018_0554	2021-02-04 16:16:16.369334+00
333	order	0077_auto_20191118_0606	2021-02-04 16:16:16.613212+00
334	order	0078_auto_20200221_0257	2021-02-04 16:16:16.843448+00
335	payment	0003_rename_payment_method_to_payment	2021-02-04 16:16:18.060203+00
336	payment	0004_auto_20181206_0031	2021-02-04 16:16:18.119656+00
337	payment	0005_auto_20190104_0443	2021-02-04 16:16:18.378815+00
338	payment	0006_auto_20190109_0358	2021-02-04 16:16:18.419905+00
339	payment	0007_auto_20190206_0938	2021-02-04 16:16:18.44471+00
340	payment	0007_auto_20190125_0242	2021-02-04 16:16:18.652599+00
341	payment	0008_merge_20190214_0447	2021-02-04 16:16:18.662195+00
342	payment	0009_convert_to_partially_charged_and_partially_refunded	2021-02-04 16:16:18.894149+00
343	payment	0010_auto_20190220_2001	2021-02-04 16:16:19.229913+00
344	checkout	0016_auto_20190112_0506	2021-02-04 16:16:19.837832+00
345	checkout	0017_auto_20190130_0207	2021-02-04 16:16:19.900561+00
346	checkout	0018_auto_20190410_0132	2021-02-04 16:16:20.72394+00
347	checkout	0019_checkout_gift_cards	2021-02-04 16:16:21.300606+00
348	checkout	0020_auto_20190723_0722	2021-02-04 16:16:22.048284+00
349	checkout	0021_django_price_2	2021-02-04 16:16:22.300467+00
350	checkout	0022_auto_20191219_1137	2021-02-04 16:16:22.63721+00
351	checkout	0023_checkout_country	2021-02-04 16:16:22.74422+00
352	checkout	0024_auto_20200120_0154	2021-02-04 16:16:23.59711+00
353	checkout	0025_auto_20200221_0257	2021-02-04 16:16:23.826588+00
354	account	0038_auto_20200123_0034	2021-02-04 16:16:24.398535+00
355	account	0039_auto_20200221_0257	2021-02-04 16:16:24.622372+00
356	core	0001_migrate_metadata	2021-02-04 16:16:27.266591+00
357	account	0040_auto_20200415_0443	2021-02-04 16:16:27.610558+00
358	account	0041_permissions_to_groups	2021-02-04 16:16:28.052401+00
359	account	0040_auto_20200225_0237	2021-02-04 16:16:28.315935+00
360	account	0041_merge_20200421_0529	2021-02-04 16:16:28.326275+00
361	account	0042_merge_20200422_0555	2021-02-04 16:16:28.334795+00
362	account	0043_rename_service_account_to_app	2021-02-04 16:16:29.097063+00
363	webhook	0003_unmount_service_account	2021-02-04 16:16:29.365097+00
364	account	0044_unmount_app_and_app_token	2021-02-04 16:16:29.710453+00
365	account	0045_auto_20200427_0425	2021-02-04 16:16:30.213269+00
366	account	0046_user_jwt_token_key	2021-02-04 16:16:30.429687+00
367	account	0047_auto_20200810_1415	2021-02-04 16:16:30.6145+00
368	account	0048_address_billing_details	2021-02-04 16:16:30.805632+00
369	app	0001_initial	2021-02-04 16:16:31.792049+00
370	app	0002_auto_20200702_0945	2021-02-04 16:16:32.828445+00
371	app	0003_auto_20200810_1415	2021-02-04 16:16:34.020775+00
372	auth	0012_alter_user_first_name_max_length	2021-02-04 16:16:34.363362+00
373	checkout	0026_auto_20200709_1102	2021-02-04 16:16:34.571373+00
374	checkout	0027_auto_20200810_1415	2021-02-04 16:16:34.769964+00
375	checkout	0028_auto_20200824_1019	2021-02-04 16:16:34.976556+00
376	checkout	0029_auto_20200904_0529	2021-02-04 16:16:35.353576+00
377	csv	0001_initial	2021-02-04 16:16:35.894804+00
378	csv	0002_exportfile_message	2021-02-04 16:16:36.071596+00
379	csv	0003_auto_20200810_1415	2021-02-04 16:16:36.151652+00
380	discount	0004_auto_20170206_0407	2021-02-04 16:16:37.800562+00
381	discount	0005_auto_20170919_0839	2021-02-04 16:16:37.893778+00
382	discount	0006_auto_20171129_1004	2021-02-04 16:16:37.981318+00
383	discount	0007_auto_20180108_0814	2021-02-04 16:16:39.89422+00
384	discount	0008_sale_collections	2021-02-04 16:16:40.097566+00
385	discount	0009_auto_20180719_0520	2021-02-04 16:16:40.233364+00
386	discount	0010_auto_20180724_1251	2021-02-04 16:16:41.412004+00
387	discount	0011_auto_20180803_0528	2021-02-04 16:16:41.892486+00
388	discount	0012_auto_20190329_0836	2021-02-04 16:16:42.131676+00
389	discount	0013_auto_20190618_0733	2021-02-04 16:16:42.982237+00
390	discount	0014_auto_20190701_0402	2021-02-04 16:16:43.218819+00
391	discount	0015_voucher_min_quantity_of_products	2021-02-04 16:16:43.300428+00
392	discount	0016_auto_20190716_0330	2021-02-04 16:16:43.569087+00
393	discount	0017_django_price_2	2021-02-04 16:16:43.73027+00
394	discount	0018_auto_20190827_0315	2021-02-04 16:16:43.981377+00
395	discount	0019_auto_20200217_0350	2021-02-04 16:16:44.179222+00
396	discount	0020_auto_20200709_1102	2021-02-04 16:16:44.385736+00
397	discount	0021_auto_20200902_1249	2021-02-04 16:16:44.777068+00
398	django_prices_openexchangerates	0001_initial	2021-02-04 16:16:44.808219+00
399	django_prices_openexchangerates	0002_auto_20160329_0702	2021-02-04 16:16:44.854651+00
400	django_prices_openexchangerates	0003_auto_20161018_0707	2021-02-04 16:16:44.905101+00
401	django_prices_openexchangerates	0004_auto_20170316_0944	2021-02-04 16:16:44.925682+00
402	django_prices_openexchangerates	0005_auto_20190124_1008	2021-02-04 16:16:44.944188+00
403	django_prices_vatlayer	0001_initial	2021-02-04 16:16:44.981578+00
404	django_prices_vatlayer	0002_ratetypes	2021-02-04 16:16:45.015665+00
405	django_prices_vatlayer	0003_auto_20180316_1053	2021-02-04 16:16:45.141106+00
406	giftcard	0002_auto_20190814_0413	2021-02-04 16:16:45.51402+00
407	giftcard	0003_auto_20200217_0350	2021-02-04 16:16:45.58472+00
408	giftcard	0004_auto_20200902_1249	2021-02-04 16:16:46.554585+00
409	warehouse	0002_auto_20200123_0036	2021-02-04 16:16:46.739619+00
410	warehouse	0003_warehouse_slug	2021-02-04 16:16:47.089446+00
411	warehouse	0004_auto_20200129_0717	2021-02-04 16:16:47.429819+00
412	warehouse	0005_auto_20200204_0722	2021-02-04 16:16:47.645129+00
413	warehouse	0006_auto_20200228_0519	2021-02-04 16:16:47.929256+00
414	order	0079_auto_20200304_0752	2021-02-04 16:16:48.177281+00
415	order	0080_invoice	2021-02-04 16:16:48.343755+00
416	order	0081_auto_20200406_0456	2021-02-04 16:16:48.551607+00
417	warehouse	0007_auto_20200406_0341	2021-02-04 16:16:49.093912+00
418	order	0082_fulfillmentline_stock	2021-02-04 16:16:49.833245+00
419	order	0079_auto_20200225_0237	2021-02-04 16:16:49.917869+00
420	order	0081_merge_20200309_0952	2021-02-04 16:16:49.927789+00
421	order	0083_merge_20200421_0529	2021-02-04 16:16:49.935017+00
422	order	0084_auto_20200522_0522	2021-02-04 16:16:50.037197+00
423	order	0085_delete_invoice	2021-02-04 16:16:50.053301+00
424	invoice	0001_initial	2021-02-04 16:16:50.366743+00
425	invoice	0002_invoice_message	2021-02-04 16:16:50.516163+00
426	invoice	0003_auto_20200713_1311	2021-02-04 16:16:50.596287+00
427	invoice	0004_auto_20200810_1415	2021-02-04 16:16:50.772116+00
428	menu	0004_sort_order_index	2021-02-04 16:16:50.82549+00
429	menu	0005_auto_20180719_0520	2021-02-04 16:16:50.863841+00
430	menu	0006_auto_20180803_0528	2021-02-04 16:16:51.198518+00
431	menu	0007_auto_20180807_0547	2021-02-04 16:16:51.428008+00
432	menu	0008_menu_json_content_new	2021-02-04 16:16:51.606705+00
433	menu	0009_remove_menu_json_content	2021-02-04 16:16:51.631134+00
434	menu	0010_auto_20180913_0841	2021-02-04 16:16:51.662251+00
435	menu	0011_auto_20181204_0004	2021-02-04 16:16:51.683242+00
436	menu	0012_auto_20190104_0443	2021-02-04 16:16:51.704403+00
437	menu	0013_auto_20190507_0309	2021-02-04 16:16:51.846598+00
438	menu	0014_auto_20190523_0759	2021-02-04 16:16:51.913424+00
439	menu	0015_auto_20190725_0811	2021-02-04 16:16:51.975447+00
440	menu	0016_auto_20200217_0350	2021-02-04 16:16:52.008208+00
441	menu	0017_remove_menu_json_content	2021-02-04 16:16:52.034785+00
442	menu	0018_auto_20200709_1102	2021-02-04 16:16:52.176658+00
443	menu	0019_menu_slug	2021-02-04 16:16:52.923755+00
444	order	0086_auto_20200716_1226	2021-02-04 16:16:53.014416+00
445	order	0087_auto_20200810_1415	2021-02-04 16:16:53.495647+00
446	order	0088_auto_20200812_1101	2021-02-04 16:16:53.590837+00
447	order	0089_auto_20200902_1249	2021-02-04 16:16:54.891216+00
448	page	0002_auto_20180321_0417	2021-02-04 16:16:54.931203+00
449	page	0003_auto_20180719_0520	2021-02-04 16:16:54.952513+00
450	page	0004_auto_20180803_0528	2021-02-04 16:16:55.445949+00
451	page	0005_auto_20190208_0456	2021-02-04 16:16:55.489316+00
452	page	0006_auto_20190220_1928	2021-02-04 16:16:55.515817+00
453	page	0007_auto_20190225_0252	2021-02-04 16:16:55.598366+00
454	page	0008_raw_html_to_json	2021-02-04 16:16:55.93357+00
455	page	0009_auto_20191108_0402	2021-02-04 16:16:55.956362+00
456	page	0010_auto_20200129_0717	2021-02-04 16:16:55.99467+00
457	page	0011_auto_20200217_0350	2021-02-04 16:16:56.015275+00
458	page	0012_auto_20200709_1102	2021-02-04 16:16:56.054506+00
459	page	0013_update_publication_date	2021-02-04 16:16:56.24044+00
460	page	0014_add_metadata	2021-02-04 16:16:56.298868+00
461	payment	0011_auto_20190516_0901	2021-02-04 16:16:56.33644+00
462	payment	0012_transaction_customer_id	2021-02-04 16:16:56.393181+00
463	payment	0013_auto_20190813_0735	2021-02-04 16:16:56.429892+00
464	payment	0014_django_price_2	2021-02-04 16:16:57.093925+00
465	payment	0015_auto_20200203_1116	2021-02-04 16:16:57.345924+00
466	payment	0016_auto_20200423_0314	2021-02-04 16:16:57.639896+00
467	payment	0017_payment_payment_method_type	2021-02-04 16:16:57.723532+00
468	payment	0018_auto_20200810_1415	2021-02-04 16:16:57.777852+00
469	payment	0019_auto_20200812_1101	2021-02-04 16:16:58.040479+00
470	payment	0020_auto_20200902_1249	2021-02-04 16:16:58.521135+00
471	payment	0021_transaction_searchable_key	2021-02-04 16:16:58.558745+00
472	payment	0022_auto_20201104_1458	2021-02-04 16:16:58.690554+00
473	plugins	0003_auto_20200429_0142	2021-02-04 16:16:58.970341+00
474	plugins	0004_drop_support_for_env_vatlayer_access_key	2021-02-04 16:16:59.181991+00
475	plugins	0005_auto_20200810_1415	2021-02-04 16:16:59.209545+00
476	plugins	0006_auto_20200909_1253	2021-02-04 16:16:59.227679+00
477	product	0116_auto_20200225_0237	2021-02-04 16:16:59.298765+00
478	product	0117_auto_20200423_0737	2021-02-04 16:16:59.346064+00
479	product	0118_populate_product_variant_price	2021-02-04 16:17:00.52503+00
480	product	0119_auto_20200709_1102	2021-02-04 16:17:00.790283+00
481	product	0120_auto_20200714_0539	2021-02-04 16:17:01.730819+00
482	product	0121_auto_20200810_1415	2021-02-04 16:17:04.657651+00
483	product	0122_auto_20200828_1135	2021-02-04 16:17:05.392506+00
484	product	0123_auto_20200904_1251	2021-02-04 16:17:05.652204+00
485	product	0124_auto_20200909_0904	2021-02-04 16:17:06.327589+00
486	product	0125_auto_20200916_1511	2021-02-04 16:17:06.48991+00
487	product	0126_product_default_variant	2021-02-04 16:17:06.956308+00
488	product	0127_auto_20201001_0933	2021-02-04 16:17:07.568813+00
489	product	0128_update_publication_date	2021-02-04 16:17:07.956799+00
490	product	0129_add_product_types_and_attributes_perm	2021-02-04 16:17:09.312996+00
491	product	0130_create_product_description_search_vector	2021-02-04 16:17:09.889666+00
492	shipping	0018_default_zones_countries	2021-02-04 16:17:10.061385+00
493	shipping	0019_remove_shippingmethod_meta	2021-02-04 16:17:10.111177+00
494	shipping	0020_auto_20200902_1249	2021-02-04 16:17:10.300283+00
495	warehouse	0008_auto_20200430_0239	2021-02-04 16:17:10.461692+00
496	warehouse	0009_remove_invalid_allocation	2021-02-04 16:17:10.638132+00
497	warehouse	0010_auto_20200709_1102	2021-02-04 16:17:10.697479+00
498	warehouse	0011_auto_20200714_0539	2021-02-04 16:17:10.760662+00
499	webhook	0004_mount_app	2021-02-04 16:17:10.920007+00
500	webhook	0005_drop_manage_webhooks_permission	2021-02-04 16:17:11.152733+00
501	webhook	0006_auto_20200731_1440	2021-02-04 16:17:11.212646+00
502	wishlist	0001_initial	2021-02-04 16:17:11.634712+00
503	account	0006_auto_20160829_0819	2021-02-04 16:17:11.820301+00
504	account	0004_auto_20160114_0419	2021-02-04 16:17:11.827167+00
505	account	0001_initial	2021-02-04 16:17:11.833237+00
506	account	0005_auto_20160205_0651	2021-02-04 16:17:11.838606+00
507	account	0009_auto_20170206_0407	2021-02-04 16:17:11.843411+00
508	account	0011_auto_20171110_0552	2021-02-04 16:17:11.848975+00
509	account	0007_auto_20161115_0940	2021-02-04 16:17:11.855058+00
510	account	0012_auto_20171117_0846	2021-02-04 16:17:11.861315+00
511	account	0016_auto_20180108_0814	2021-02-04 16:17:11.867056+00
512	account	0013_auto_20171120_0521	2021-02-04 16:17:11.872575+00
513	account	0015_auto_20171213_0734	2021-02-04 16:17:11.878378+00
514	account	0008_auto_20161115_1011	2021-02-04 16:17:11.884426+00
515	account	0003_auto_20151104_1102	2021-02-04 16:17:11.890086+00
516	account	0010_auto_20170919_0839	2021-02-04 16:17:11.896141+00
517	account	0002_auto_20150907_0602	2021-02-04 16:17:11.904869+00
518	account	0014_auto_20171129_1004	2021-02-04 16:17:11.912569+00
519	checkout	0002_auto_20161014_1221	2021-02-04 16:17:11.920775+00
520	checkout	0003_auto_20170906_0556	2021-02-04 16:17:11.928051+00
521	checkout	0001_initial	2021-02-04 16:17:11.935401+00
522	checkout	0001_auto_20170113_0435	2021-02-04 16:17:11.942474+00
523	checkout	fix_empty_data_in_lines	2021-02-04 16:17:11.949207+00
524	checkout	0002_auto_20170206_0407	2021-02-04 16:17:11.956469+00
525	checkout	0004_auto_20171129_1004	2021-02-04 16:17:11.963147+00
526	checkout	0005_auto_20180108_0814	2021-02-04 16:17:11.96887+00
527	checkout	0006_auto_20180221_0825	2021-02-04 16:17:11.982079+00
\.


--
-- Data for Name: django_prices_openexchangerates_conversionrate; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.django_prices_openexchangerates_conversionrate (id, to_currency, rate, modified_at) FROM stdin;
\.


--
-- Data for Name: django_prices_vatlayer_ratetypes; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.django_prices_vatlayer_ratetypes (id, types) FROM stdin;
\.


--
-- Data for Name: django_prices_vatlayer_vat; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.django_prices_vatlayer_vat (id, country_code, data) FROM stdin;
\.


--
-- Data for Name: django_site; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.django_site (id, domain, name) FROM stdin;
1	localhost:8000	Saleor e-commerce
\.


--
-- Data for Name: giftcard_giftcard; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.giftcard_giftcard (id, code, created, start_date, end_date, last_used_on, is_active, initial_balance_amount, current_balance_amount, user_id, currency) FROM stdin;
\.


--
-- Data for Name: invoice_invoice; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.invoice_invoice (id, private_metadata, metadata, status, created_at, updated_at, number, created, external_url, invoice_file, order_id, message) FROM stdin;
\.


--
-- Data for Name: invoice_invoiceevent; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.invoice_invoiceevent (id, date, type, parameters, invoice_id, order_id, user_id) FROM stdin;
\.


--
-- Data for Name: menu_menu; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.menu_menu (id, name, slug) FROM stdin;
2	footer	footer
1	navbar	navbar
\.


--
-- Data for Name: menu_menuitem; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.menu_menuitem (id, name, sort_order, url, lft, rght, tree_id, level, category_id, collection_id, menu_id, page_id, parent_id) FROM stdin;
\.


--
-- Data for Name: menu_menuitemtranslation; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.menu_menuitemtranslation (id, language_code, name, menu_item_id) FROM stdin;
\.


--
-- Data for Name: order_fulfillment; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.order_fulfillment (id, tracking_number, created, order_id, fulfillment_order, status, metadata, private_metadata) FROM stdin;
\.


--
-- Data for Name: order_fulfillmentline; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.order_fulfillmentline (id, order_line_id, quantity, fulfillment_id, stock_id) FROM stdin;
\.


--
-- Data for Name: order_order; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.order_order (id, created, tracking_client_id, user_email, token, billing_address_id, shipping_address_id, user_id, total_net_amount, discount_amount, discount_name, voucher_id, language_code, shipping_price_gross_amount, total_gross_amount, shipping_price_net_amount, status, shipping_method_name, shipping_method_id, display_gross_prices, translated_discount_name, customer_note, weight, checkout_token, currency, metadata, private_metadata) FROM stdin;
\.


--
-- Data for Name: order_order_gift_cards; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.order_order_gift_cards (id, order_id, giftcard_id) FROM stdin;
\.


--
-- Data for Name: order_orderevent; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.order_orderevent (id, date, type, order_id, user_id, parameters) FROM stdin;
\.


--
-- Data for Name: order_orderline; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.order_orderline (id, product_name, product_sku, quantity, unit_price_net_amount, unit_price_gross_amount, is_shipping_required, order_id, quantity_fulfilled, variant_id, tax_rate, translated_product_name, currency, translated_variant_name, variant_name) FROM stdin;
\.


--
-- Data for Name: page_page; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.page_page (id, slug, title, content, created, is_published, publication_date, seo_description, seo_title, content_json, metadata, private_metadata) FROM stdin;
\.


--
-- Data for Name: page_pagetranslation; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.page_pagetranslation (id, seo_title, seo_description, language_code, title, content, page_id, content_json) FROM stdin;
\.


--
-- Data for Name: payment_payment; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.payment_payment (id, gateway, is_active, created, modified, charge_status, billing_first_name, billing_last_name, billing_company_name, billing_address_1, billing_address_2, billing_city, billing_city_area, billing_postal_code, billing_country_code, billing_country_area, billing_email, customer_ip_address, cc_brand, cc_exp_month, cc_exp_year, cc_first_digits, cc_last_digits, extra_data, token, currency, total, captured_amount, checkout_id, order_id, to_confirm, payment_method_type, return_url) FROM stdin;
\.


--
-- Data for Name: payment_transaction; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.payment_transaction (id, created, token, kind, is_success, error, currency, amount, gateway_response, payment_id, customer_id, action_required, action_required_data, already_processed, searchable_key) FROM stdin;
\.


--
-- Data for Name: plugins_pluginconfiguration; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.plugins_pluginconfiguration (id, name, description, active, configuration, identifier) FROM stdin;
\.


--
-- Data for Name: product_assignedproductattribute; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.product_assignedproductattribute (id, product_id, assignment_id) FROM stdin;
166	16	537
167	16	540
168	16	542
169	16	546
170	16	538
171	16	544
172	16	545
173	16	541
174	16	543
175	16	547
176	16	539
177	17	537
178	17	540
179	17	542
180	17	546
181	17	538
182	17	544
183	17	545
184	17	541
185	17	543
186	17	547
187	17	539
188	18	537
189	18	540
190	18	542
191	18	546
192	18	538
193	18	544
194	18	545
195	18	541
196	18	543
197	18	547
198	18	539
199	19	422
200	19	425
201	19	428
202	19	420
203	19	423
204	19	418
205	19	427
206	19	419
207	19	426
208	19	421
209	19	424
210	20	433
211	20	436
212	20	439
213	20	440
214	20	431
215	20	434
216	20	429
217	20	438
218	20	430
219	20	437
220	20	432
221	20	435
222	21	433
223	21	436
224	21	439
225	21	440
226	21	431
227	21	434
228	21	429
229	21	438
230	21	430
231	21	437
232	21	432
233	21	435
234	22	441
235	22	444
236	22	446
237	22	448
238	22	451
239	22	442
240	22	449
241	22	447
242	22	450
243	22	445
244	22	452
245	22	443
246	23	422
247	23	425
248	23	428
249	23	420
250	23	423
251	23	418
252	23	427
253	23	419
254	23	426
255	23	421
256	23	424
257	24	422
258	24	425
259	24	428
260	24	420
261	24	423
262	24	418
263	24	427
264	24	419
265	24	426
266	24	421
267	24	424
268	25	553
269	25	556
270	25	559
271	25	551
272	25	554
273	25	548
274	25	550
275	25	549
276	25	557
277	25	558
278	25	552
279	25	555
280	26	553
281	26	556
282	26	559
283	26	551
284	26	554
285	26	548
286	26	550
287	26	549
288	26	557
289	26	558
290	26	552
291	26	555
292	27	553
293	27	556
294	27	559
295	27	551
296	27	554
297	27	548
298	27	550
299	27	549
300	27	557
301	27	558
302	27	552
303	27	555
304	28	553
305	28	556
306	28	559
307	28	551
308	28	554
309	28	548
310	28	550
311	28	549
312	28	557
313	28	558
314	28	552
315	28	555
\.


--
-- Data for Name: product_assignedproductattribute_values; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.product_assignedproductattribute_values (id, assignedproductattribute_id, attributevalue_id) FROM stdin;
163	166	3987
164	167	3999
165	168	4009
166	169	3984
167	170	3996
168	171	3959
169	172	3968
170	173	4002
171	175	3986
172	176	3998
173	177	3987
174	178	3999
175	179	4009
176	180	3984
177	181	3996
178	182	3959
179	183	3968
180	184	4002
181	186	3986
182	187	3998
183	188	3987
184	189	3999
185	190	4009
186	191	3984
187	192	3996
188	193	3959
189	194	3972
190	195	4002
191	197	3986
192	198	3998
193	199	3409
194	200	3424
195	201	3445
196	202	3396
197	203	4095
198	204	3390
199	204	3391
200	205	3436
201	206	3392
202	207	4096
203	208	3407
204	209	3421
205	210	3460
206	211	3477
207	212	3492
208	213	3498
209	214	3451
210	215	3465
211	216	3446
212	216	3447
213	217	3489
214	218	3448
215	219	3480
216	219	3481
217	219	3483
218	219	3484
219	220	3459
220	221	3475
221	222	3460
222	223	3477
223	224	3492
224	225	3498
225	226	3451
226	227	3465
227	228	3446
228	228	3447
229	229	3489
230	230	3448
231	231	3480
232	231	3481
233	231	3483
234	231	3484
235	232	3459
236	233	3475
237	234	3513
238	235	3526
239	238	4097
240	238	3509
241	239	3521
242	244	3511
243	245	3524
244	246	3409
245	247	3425
246	248	3445
247	249	3401
248	250	3413
249	251	3390
250	252	3436
251	253	3392
252	254	3428
253	254	3431
254	255	3407
255	256	3422
256	257	3409
257	258	3424
258	259	3440
259	260	3398
260	261	3413
261	262	3390
262	262	3391
263	263	3436
264	264	3392
265	265	3427
266	266	3407
267	267	3421
268	268	4055
269	269	4069
270	270	4093
271	271	4045
272	272	4059
273	273	4016
274	274	4037
275	275	4026
276	276	4074
277	277	4088
278	277	4085
279	277	4079
280	278	4054
281	279	4068
282	280	4055
283	281	4069
284	282	4093
285	283	4045
286	284	4059
287	285	4016
288	286	4035
289	287	4023
290	288	4074
291	289	4080
292	289	4088
293	290	4054
294	291	4068
295	292	4055
296	293	4069
297	294	4093
298	295	4046
299	296	4060
300	297	4016
301	298	4037
302	299	4019
303	300	4074
304	301	4088
305	302	4054
306	303	4068
307	304	4055
308	305	4069
309	306	4093
310	307	4047
311	308	4060
312	309	4016
313	310	4037
314	311	4019
315	312	4074
316	313	4088
317	314	4054
318	315	4068
\.


--
-- Data for Name: product_assignedvariantattribute; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.product_assignedvariantattribute (id, variant_id, assignment_id) FROM stdin;
\.


--
-- Data for Name: product_assignedvariantattribute_values; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.product_assignedvariantattribute_values (id, assignedvariantattribute_id, attributevalue_id) FROM stdin;
\.


--
-- Data for Name: product_attribute; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.product_attribute (id, slug, name, metadata, private_metadata, input_type, available_in_grid, visible_in_storefront, filterable_in_dashboard, filterable_in_storefront, value_required, storefront_search_position, is_variant_only) FROM stdin;
708	audio-adapter-destination	Destinat pentru	{}	{}	multiselect	t	t	t	t	f	0	f
709	audio-adapter-model	Model adaptor	{}	{}	dropdown	t	t	t	t	f	0	f
710	audio-adapter-connector-type-1	Conector tip 1	{}	{}	dropdown	t	t	t	t	f	0	f
711	audio-adapter-type-connector-1	Tip conector 1	{}	{}	dropdown	t	t	t	t	f	0	f
712	audio-adapter-angle-connector-1	Unghi orientare conector 1	{}	{}	dropdown	t	t	t	t	f	0	f
713	audio-adapter-connector-type-2	Conector tip 2	{}	{}	multiselect	t	t	t	t	f	0	f
714	audio-adapter-type-connector-2	Tip conector 2	{}	{}	multiselect	t	t	t	t	f	0	f
715	audio-adapter-angle-connector-2	Unghi orientare conector 2	{}	{}	dropdown	t	t	t	t	f	0	f
716	audio-adapter-properties	Proprietati	{}	{}	multiselect	t	t	t	t	f	0	f
717	audio-adapter-housing-material	Material carcasa	{}	{}	multiselect	t	t	t	t	f	0	f
718	audio-adapter-base-function	Functia de baza	{}	{}	dropdown	t	t	t	t	f	0	f
719	audio-adapter-colour	Culoare	{}	{}	multiselect	t	t	t	t	f	0	f
720	audio-splitter-destination	Destinat pentru	{}	{}	multiselect	t	t	t	t	f	0	f
721	audio-splitter-model	Model splitter audio	{}	{}	dropdown	t	t	t	t	f	0	f
722	audio-splitter-connector-type-1	Conector tip 1	{}	{}	multiselect	t	t	t	t	f	0	f
723	audio-splitter-type-connector-1	Tip conector 1	{}	{}	multiselect	t	t	t	t	f	0	f
724	audio-splitter-angle-connector-1	Unghi orientare conector 1	{}	{}	multiselect	t	t	t	t	f	0	f
725	audio-splitter-connector-type-2	Conector tip 2	{}	{}	multiselect	t	t	t	t	f	0	f
726	audio-splitter-type-connector-2	Tip conector 2	{}	{}	multiselect	t	t	t	t	f	0	f
727	audio-splitter-angle-connector-2	Unghi orientare conector 2	{}	{}	multiselect	t	t	t	t	f	0	f
728	audio-splitter-properties	Proprietati	{}	{}	multiselect	t	t	t	t	f	0	f
729	audio-splitter-housing-material	Material carcasa	{}	{}	multiselect	t	t	t	t	f	0	f
730	audio-splitter-base-function	Functia de baza	{}	{}	dropdown	t	t	t	t	f	0	f
731	audio-splitter-colour	Culoare	{}	{}	multiselect	t	t	t	t	f	0	f
732	audio-converter-destination	Destinat pentru	{}	{}	multiselect	t	t	t	t	f	0	f
733	audio-converter-model	Model convertor audio	{}	{}	dropdown	t	t	t	t	f	0	f
734	audio-converter-connector-type-1	Conector tip 1	{}	{}	multiselect	t	t	t	t	f	0	f
735	audio-converter-type-connector-1	Tip conector 1	{}	{}	multiselect	t	t	t	t	f	0	f
736	audio-converter-angle-connector-1	Unghi orientare conector 1	{}	{}	multiselect	t	t	t	t	f	0	f
737	audio-converter-connector-type-2	Conector tip 2	{}	{}	multiselect	t	t	t	t	f	0	f
738	audio-converter-type-connector-2	Tip conector 2	{}	{}	multiselect	t	t	t	t	f	0	f
739	audio-converter-angle-connector-2	Unghi orientare conector 2	{}	{}	multiselect	t	t	t	t	f	0	f
740	audio-converter-properties	Proprietati	{}	{}	multiselect	t	t	t	t	f	0	f
741	audio-converter-base-function	Functia de baza	{}	{}	dropdown	t	t	t	t	f	0	f
742	audio-converter-housing-material	Material carcasa	{}	{}	dropdown	t	t	t	t	f	0	f
743	audio-converter-colour	Culoare	{}	{}	multiselect	t	t	t	t	f	0	f
744	video-adapter-destination	Destinat pentru	{}	{}	dropdown	t	t	t	t	f	0	f
745	video-adapter-model	Model adaptor	{}	{}	dropdown	t	t	t	t	f	0	f
746	video-adapter-connector-type-1	Conector tip 1	{}	{}	dropdown	t	t	t	t	f	0	f
747	video-adapter-type-connector-1	Tip conector 1	{}	{}	dropdown	t	t	t	t	f	0	f
748	video-adapter-signal-connector-1	Directie semnal conector 1	{}	{}	dropdown	t	t	t	t	f	0	f
749	video-adapter-angle-connector-1	Unghi orientare conector 1	{}	{}	dropdown	t	t	t	t	f	0	f
750	video-adapter-connector-type-2	Conector tip 2	{}	{}	multiselect	t	t	t	t	f	0	f
751	video-adapter-type-connector-2	Tip conector 2	{}	{}	multiselect	t	t	t	t	f	0	f
752	video-adapter-signal-connector-2	Directie semnal conector 2	{}	{}	dropdown	t	t	t	t	f	0	f
753	video-adapter-angle-connector-2	Unghi orientare conector 2	{}	{}	multiselect	t	t	t	t	f	0	f
754	video-adapter-properties	Proprietati	{}	{}	multiselect	t	t	t	t	f	0	f
755	video-adapter-housing-material	Material carcasa	{}	{}	multiselect	t	t	t	t	f	0	f
756	video-adapter-base-function	Functie de baza	{}	{}	dropdown	t	t	t	t	f	0	f
757	video-adapter-colour	Culoare	{}	{}	multiselect	t	t	t	t	f	0	f
758	video-converter-destination	Destinat pentru	{}	{}	multiselect	t	t	t	t	f	0	f
759	video-converter-model	Model convertor	{}	{}	dropdown	t	t	t	t	f	0	f
760	video-converter-connector-type-1	Conector tip 1	{}	{}	dropdown	t	t	t	t	f	0	f
761	video-converter-type-connector-1	Tip conector 1	{}	{}	dropdown	t	t	t	t	f	0	f
762	video-converter-signal-connector-1	Directie semnal conector 1	{}	{}	dropdown	t	t	t	t	f	0	f
763	video-converter-angle-connector-1	Unghi orientare conector 1	{}	{}	dropdown	t	t	t	t	f	0	f
764	video-converter-connector-type-2	Conector tip 2	{}	{}	multiselect	t	t	t	t	f	0	f
765	video-converter-type-connector-2	Tip conector 2	{}	{}	multiselect	t	t	t	t	f	0	f
766	video-converter-signal-connector-2	Directie semnal conector 2	{}	{}	multiselect	t	t	t	t	f	0	f
767	video-converter-angle-connector-2	Unghi orientare conector 2	{}	{}	multiselect	t	t	t	t	f	0	f
768	video-converter-properties	Proprietati	{}	{}	multiselect	t	t	t	t	f	0	f
769	video-converter-housing-material	Material carcasa	{}	{}	multiselect	t	t	t	t	f	0	f
770	video-converter-base-function	Functie de baza	{}	{}	dropdown	t	t	t	t	f	0	f
771	video-converter-colour	Culoare	{}	{}	multiselect	t	t	t	t	f	0	f
772	video-extension-destination	Destinat pentru	{}	{}	multiselect	t	t	t	t	f	0	f
773	video-extension-model	Model prelungitor	{}	{}	dropdown	t	t	t	t	f	0	f
774	video-extension-connector-type-1	Conector tip 1	{}	{}	dropdown	t	t	t	t	f	0	f
775	video-extension-type-connector-1	Tip conector 1	{}	{}	dropdown	t	t	t	t	f	0	f
776	video-extension-signal-connector-1	Directie semnal conector 1	{}	{}	dropdown	t	t	t	t	f	0	f
777	video-extension-angle-connector-1	Unghi orientare conector 1	{}	{}	dropdown	t	t	t	t	f	0	f
778	video-extension-connector-type-2	Conector tip 2	{}	{}	dropdown	t	t	t	t	f	0	f
779	video-extension-type-connector-2	Tip conector 2	{}	{}	dropdown	t	t	t	t	f	0	f
780	video-extension-signal-connector-2	Directie semnal conector 2	{}	{}	dropdown	t	t	t	t	f	0	f
781	video-extension-angle-connector-2	Unghi orientare conector 2	{}	{}	dropdown	t	t	t	t	f	0	f
782	video-extension-properties	Proprietati	{}	{}	multiselect	t	t	t	t	f	0	f
783	video-extension-housing-material	Material carcasa	{}	{}	multiselect	t	t	t	t	f	0	f
784	video-extension-base-function	Functie de baza	{}	{}	dropdown	t	t	t	t	f	0	f
785	video-extension-colour	Culoare	{}	{}	multiselect	t	t	t	t	f	0	f
786	video-repeater-destination	Destinat pentru	{}	{}	multiselect	t	t	t	t	f	0	f
787	video-repeater-model	Model repetitor	{}	{}	dropdown	t	t	t	t	f	0	f
788	video-repeater-connector-type-1	Conector tip 1	{}	{}	dropdown	t	t	t	t	f	0	f
789	video-repeater-type-connector-1	Tip conector 1	{}	{}	dropdown	t	t	t	t	f	0	f
790	video-repeater-signal-connector-1	Directie semnal conector 1	{}	{}	dropdown	t	t	t	t	f	0	f
791	video-repeater-angle-connector-1	Unghi orientare conector 1	{}	{}	dropdown	t	t	t	t	f	0	f
792	video-repeater-connector-type-2	Conector tip 2	{}	{}	dropdown	t	t	t	t	f	0	f
793	video-repeater-type-connector-2	Tip conector 2	{}	{}	dropdown	t	t	t	t	f	0	f
794	video-repeater-signal-connector-2	Directie semnal conector 2	{}	{}	dropdown	t	t	t	t	f	0	f
795	video-repeater-angle-connector-2	Unghi orientare conector 2	{}	{}	dropdown	t	t	t	t	f	0	f
796	video-repeater-properties	Proprietati	{}	{}	multiselect	t	t	t	t	f	0	f
797	video-repeater-housing-material	Material carcasa	{}	{}	multiselect	t	t	t	t	f	0	f
798	video-repeater-base-function	Functie de baza	{}	{}	dropdown	t	t	t	t	f	0	f
799	video-repeater-colour	Culoare	{}	{}	multiselect	t	t	t	t	f	0	f
800	video-splitter-destination	Destinat pentru	{}	{}	multiselect	t	t	t	t	f	0	f
801	video-splitter-model	Model splitter	{}	{}	dropdown	t	t	t	t	f	0	f
802	video-splitter-connector-type-1	Conector tip 1	{}	{}	dropdown	t	t	t	t	f	0	f
803	video-splitter-type-connector-1	Tip conector 1	{}	{}	dropdown	t	t	t	t	f	0	f
804	video-splitter-signal-connector-1	Directie semnal conector 1	{}	{}	dropdown	t	t	t	t	f	0	f
805	video-splitter-angle-connector-1	Unghi orientare conector 1	{}	{}	dropdown	t	t	t	t	f	0	f
806	video-splitter-connector-type-2	Conector tip 2	{}	{}	multiselect	t	t	t	t	f	0	f
807	video-splitter-type-connector-2	Tip conector 2	{}	{}	multiselect	t	t	t	t	f	0	f
808	video-splitter-signal-connector-2	Directie semnal conector 2	{}	{}	multiselect	t	t	t	t	f	0	f
809	video-splitter-angle-connector-2	Unghi orientare conector 2	{}	{}	multiselect	t	t	t	t	f	0	f
810	video-splitter-properties	Proprietati	{}	{}	multiselect	t	t	t	t	f	0	f
811	video-splitter-housing-material	Material carcasa	{}	{}	multiselect	t	t	t	t	f	0	f
812	video-splitter-base-function	Functie de baza	{}	{}	dropdown	t	t	t	t	f	0	f
813	video-splitter-colour	Culoare	{}	{}	multiselect	t	t	t	t	f	0	f
814	video-switch-destination	Destinat pentru	{}	{}	dropdown	t	t	t	t	f	0	f
815	video-switch-model	Model comutator	{}	{}	dropdown	t	t	t	t	f	0	f
816	video-switch-connector-type-1	Conector tip 1	{}	{}	multiselect	t	t	t	t	f	0	f
817	video-switch-type-connector-1	Tip conector 1	{}	{}	multiselect	t	t	t	t	f	0	f
818	video-switch-signal-connector-1	Directie semnal conector 1	{}	{}	multiselect	t	t	t	t	f	0	f
819	video-switch-angle-connector-1	Unghi orientare conector 1	{}	{}	multiselect	t	t	t	t	f	0	f
820	video-switch-connector-type-2	Conector tip 2	{}	{}	multiselect	t	t	t	t	f	0	f
821	video-switch-type-connector-2	Tip conector 2	{}	{}	multiselect	t	t	t	t	f	0	f
822	video-switch-signal-connector-2	Directie semnal conector 2	{}	{}	multiselect	t	t	t	t	f	0	f
823	video-switch-angle-connector-2	Unghi orientare conector 2	{}	{}	multiselect	t	t	t	t	f	0	f
824	video-switch-properties	Proprietati	{}	{}	multiselect	t	t	t	t	f	0	f
825	video-switch-housing-material	Material carcasa	{}	{}	multiselect	t	t	t	t	f	0	f
826	video-switch-base-function	Functie de baza	{}	{}	dropdown	t	t	t	t	f	0	f
827	video-switch-colour	Culoare	{}	{}	multiselect	t	t	t	t	f	0	f
828	audio-cable-destination	Destinat pentru	{}	{}	multiselect	t	t	t	t	f	0	f
829	audio-cable-length	Lungime	{}	{}	dropdown	t	t	t	t	f	0	f
830	audio-cable-connector-type-1	Conector tip 1	{}	{}	dropdown	t	t	t	t	f	0	f
831	audio-cable-type-connector-1	Tip conector 1	{}	{}	dropdown	t	t	t	t	f	0	f
832	audio-cable-angle-connector-1	Unghi orientare conector 1	{}	{}	dropdown	t	t	t	t	f	0	f
833	audio-cable-connector-type-2	Conector tip 2	{}	{}	multiselect	t	t	t	t	f	0	f
834	audio-cable-type-connector-2	Tip conector 2	{}	{}	dropdown	t	t	t	t	f	0	f
835	audio-cable-angle-connector-2	Unghi orientare conector 2	{}	{}	dropdown	t	t	t	t	f	0	f
836	audio-cable-outer-cover	Invelis exterior cablu	{}	{}	dropdown	t	t	t	t	f	0	f
837	audio-cable-colour	Culoare cablu	{}	{}	dropdown	t	t	t	t	f	0	f
838	audio-cable-properties	Proprietati	{}	{}	multiselect	t	t	t	t	f	0	f
839	video-cable-destination	Destinat pentru	{}	{}	multiselect	t	t	t	t	f	0	f
840	video-cable-model	Model / Versiune	{}	{}	multiselect	t	t	t	t	f	0	f
841	video-cable-length	Lungime	{}	{}	dropdown	t	t	t	t	f	0	f
842	video-cable-connector-type-1	Conector tip 1	{}	{}	dropdown	t	t	t	t	f	0	f
843	video-cable-type-connector-1	Tip conector 1	{}	{}	dropdown	t	t	t	t	f	0	f
844	video-cable-angle-connector-1	Unghi orientare conector 1	{}	{}	dropdown	t	t	t	t	f	0	f
845	video-cable-connector-type-2	Conector tip 2	{}	{}	multiselect	t	t	t	t	f	0	f
846	video-cable-type-connector-2	Tip conector 2	{}	{}	multiselect	t	t	t	t	f	0	f
847	video-cable-angle-connector-2	Unghi orientare conector 2	{}	{}	dropdown	t	t	t	t	f	0	f
848	video-cable-outer-cover	Invelis exterior	{}	{}	multiselect	t	t	t	t	f	0	f
849	video-cable-properties	Proprietati	{}	{}	multiselect	t	t	t	t	f	0	f
850	video-cable-colour	Culoare	{}	{}	multiselect	t	t	t	t	f	0	f
\.


--
-- Data for Name: product_attributeproduct; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.product_attributeproduct (id, attribute_id, product_type_id, sort_order) FROM stdin;
418	708	32	\N
419	709	32	\N
420	710	32	\N
421	711	32	\N
422	712	32	\N
423	713	32	\N
424	714	32	\N
425	715	32	\N
426	716	32	\N
427	717	32	\N
428	719	32	\N
429	720	33	\N
430	721	33	\N
431	722	33	\N
432	723	33	\N
433	724	33	\N
434	725	33	\N
435	726	33	\N
436	727	33	\N
437	728	33	\N
438	729	33	\N
439	730	33	\N
440	731	33	\N
441	736	34	\N
442	737	34	\N
443	738	34	\N
444	739	34	\N
445	740	34	\N
446	741	34	\N
447	742	34	\N
448	743	34	\N
449	732	34	\N
450	733	34	\N
451	734	34	\N
452	735	34	\N
453	744	35	\N
454	745	35	\N
455	746	35	\N
456	747	35	\N
457	748	35	\N
458	749	35	\N
459	750	35	\N
460	751	35	\N
461	752	35	\N
462	753	35	\N
463	754	35	\N
464	755	35	\N
465	756	35	\N
466	757	35	\N
467	768	36	\N
468	769	36	\N
469	770	36	\N
470	771	36	\N
471	758	36	\N
472	759	36	\N
473	760	36	\N
474	761	36	\N
475	762	36	\N
476	763	36	\N
477	764	36	\N
478	765	36	\N
479	766	36	\N
480	767	36	\N
481	772	37	\N
482	773	37	\N
483	774	37	\N
484	775	37	\N
485	776	37	\N
486	777	37	\N
487	778	37	\N
488	779	37	\N
489	780	37	\N
490	781	37	\N
491	782	37	\N
492	783	37	\N
493	784	37	\N
494	785	37	\N
495	786	38	\N
496	787	38	\N
497	788	38	\N
498	789	38	\N
499	790	38	\N
500	791	38	\N
501	792	38	\N
502	793	38	\N
503	794	38	\N
504	795	38	\N
505	796	38	\N
506	797	38	\N
507	798	38	\N
508	799	38	\N
509	800	39	\N
510	801	39	\N
511	802	39	\N
512	803	39	\N
513	804	39	\N
514	805	39	\N
515	806	39	\N
516	807	39	\N
517	808	39	\N
518	809	39	\N
519	810	39	\N
520	811	39	\N
521	812	39	\N
522	813	39	\N
523	814	40	\N
524	815	40	\N
525	816	40	\N
526	817	40	\N
527	818	40	\N
528	819	40	\N
529	820	40	\N
530	821	40	\N
531	822	40	\N
532	823	40	\N
533	824	40	\N
534	825	40	\N
535	826	40	\N
536	827	40	\N
537	832	41	\N
538	833	41	\N
539	834	41	\N
540	835	41	\N
541	836	41	\N
542	837	41	\N
543	838	41	\N
544	828	41	\N
545	829	41	\N
546	830	41	\N
547	831	41	\N
548	839	42	\N
549	840	42	\N
550	841	42	\N
551	842	42	\N
552	843	42	\N
553	844	42	\N
554	845	42	\N
555	846	42	\N
556	847	42	\N
557	848	42	\N
558	849	42	\N
559	850	42	\N
\.


--
-- Data for Name: product_attributetranslation; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.product_attributetranslation (id, language_code, name, attribute_id) FROM stdin;
\.


--
-- Data for Name: product_attributevalue; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.product_attributevalue (id, name, attribute_id, slug, sort_order, value) FROM stdin;
3390	Adaptare semnal	708	adaptare-semnal	0	
3391	Semnal	708	semnal	1	
3392	Cu cablu	709	cu-cablu	0	
3393	Fara cablu	709	fara-cablu	1	
3394	Wireless	709	wireless	2	
3395	Jack 2.5 mm	710	jack-25-mm	0	
3396	Jack 3.5 mm	710	jack-35-mm	1	
3397	Jack 6.3 mm	710	jack-63-mm	2	
3398	USB Tip C	710	usb-tip-c	3	
3399	8-pin Lightning	710	8-pin-lightning	4	
3400	Bluetooth	710	bluetooth	5	
3401	Caseta audio	710	caseta-audio	6	
3402	USB	710	usb	7	
3403	1 x RCA 	710	1-x-rca	8	
3404	2 x RCA	710	2-x-rca	9	
3405	Optic	710	optic	10	
3406	Mama	711	mama	0	
3407	Tata	711	tata	1	
3408	Wireless	711	wireless	2	
3409	Drept	712	drept	0	
3410	La 90 de grade	712	la-90-de-grade	1	
3411	Bluetooth	713	bluetooth	0	
3412	Jack 2.5 mm	713	jack-25-mm	1	
3413	Jack 3.5 mm	713	jack-35-mm	2	
3414	Jack 6.3 mm	713	jack-63-mm	3	
3415	USB Tip C	713	usb-tip-c	4	
3416	8-pin Lightning	713	8-pin-lightning	5	
3417	1 x RCA 	713	1-x-rca	6	
3418	2 x RCA	713	2-x-rca	7	
3419	3 x RCA	713	3-x-rca	8	
3420	Optic	713	optic	9	
3421	Mama	714	mama	0	
3422	Tata	714	tata	1	
3423	Wireless	714	wireless	2	
3424	Drept	715	drept	0	
3425	La 90 de grade	715	la-90-de-grade	1	
3426	Conectori auriti	716	conectori-auriti	0	
3427	Conectori nichelati	716	conectori-nichelati	1	
3428	Conector Jack 3 pini	716	conector-jack-3-pini	2	
3429	Conector Jack 4 pini	716	conector-jack-4-pini	3	
3430	Receptor audio	716	receptor-audio	4	
3431	Stereo	716	stereo	5	
3432	Mono	716	mono	6	
3433	ABS	717	abs	0	
3434	Aluminiu	717	aluminiu	1	
3435	Aliaj	717	aliaj	2	
3436	Plastic	717	plastic	3	
3437	PVC	717	pvc	4	
3438	Metal	717	metal	5	
3439	Adaptor audio	718	adaptor-audio	0	
3440	Alb	719	alb	0	
3441	Albastru	719	albastru	1	
3442	Argintiu	719	argintiu	2	
3443	Auriu	719	auriu	3	
3444	Gri	719	gri	4	
3445	Negru	719	negru	5	
3446	Divizare semnal	720	divizare-semnal	0	
3447	Semnal	720	semnal	1	
3448	Cu cablu	721	cu-cablu	0	
3449	Fara cablu	721	fara-cablu	1	
3450	Jack 2.5 mm	722	jack-25-mm	0	
3451	Jack 3.5 mm	722	jack-35-mm	1	
3452	Jack 6.3 mm	722	jack-63-mm	2	
3453	USB Tip C	722	usb-tip-c	3	
3454	8-pin Lightning	722	8-pin-lightning	4	
3455	1 x RCA 	722	1-x-rca	5	
3456	2 x RCA	722	2-x-rca	6	
3457	Optic	722	optic	7	
3458	Mama	723	mama	0	
3459	Tata	723	tata	1	
3460	Drept	724	drept	0	
3461	La 90 de grade	724	la-90-de-grade	1	
3462	Jack 2.5 mm	725	jack-25-mm	0	
3463	2 x Jack 2.5 mm	725	2-x-jack-25-mm	1	
3464	Jack 3.5 mm	725	jack-35-mm	2	
3465	2 x Jack 3.5 mm	725	2-x-jack-35-mm	3	
3466	3 x Jack 3.5 mm	725	3-x-jack-35-mm	4	
3467	5 x Jack 3.5 mm	725	5-x-jack-35-mm	5	
3468	Jack 6.3 mm	725	jack-63-mm	6	
3469	USB Tip C	725	usb-tip-c	7	
3470	8-pin Lightning	725	8-pin-lightning	8	
3471	1 x RCA 	725	1-x-rca	9	
3472	2 x RCA	725	2-x-rca	10	
3473	3 x RCA	725	3-x-rca	11	
3474	Optic	725	optic	12	
3475	Mama	726	mama	0	
3476	Tata	726	tata	1	
3477	Drept	727	drept	0	
3478	La 90 de grade	727	la-90-de-grade	1	
3479	Conectori auriti	728	conectori-auriti	0	
3480	Conectori nichelati	728	conectori-nichelati	1	
3481	Conector Jack 3 pini	728	conector-jack-3-pini	2	
3482	Conector Jack 4 pini	728	conector-jack-4-pini	3	
3483	Multiplicare semnal	728	multiplicare-semnal	4	
3484	Stereo	728	stereo	5	
3485	Mono	728	mono	6	
3486	ABS	729	abs	0	
3487	Aluminiu	729	aluminiu	1	
3488	Aliaj	729	aliaj	2	
3489	Plastic	729	plastic	3	
3490	PVC	729	pvc	4	
3491	Metal	729	metal	5	
3492	Splitter audio	730	splitter-audio	0	
3493	Alb	731	alb	0	
3494	Albastru	731	albastru	1	
3495	Argintiu	731	argintiu	2	
3496	Auriu	731	auriu	3	
3497	Gri	731	gri	4	
3498	Negru	731	negru	5	
3499	Conversie semnal	732	conversie-semnal	0	
3500	Cu cablu	733	cu-cablu	0	
3501	Fara cablu	733	fara-cablu	1	
3502	Jack 2.5 mm	734	jack-25-mm	0	
3503	Jack 3.5 mm	734	jack-35-mm	1	
3504	Jack 6.3 mm	734	jack-63-mm	2	
3505	USB Tip C	734	usb-tip-c	3	
3506	8-pin Lightning	734	8-pin-lightning	4	
3507	1 x RCA 	734	1-x-rca	5	
3508	2 x RCA	734	2-x-rca	6	
3509	Optic SPDIF	734	optic-spdif	7	
3510	DC jack 5.5 mm	734	dc-jack-55-mm	8	
3511	Mama	735	mama	0	
3512	Tata	735	tata	1	
3513	Drept	736	drept	0	
3514	La 90 de grade	736	la-90-de-grade	1	
3515	Jack 2.5 mm	737	jack-25-mm	0	
3516	Jack 3.5 mm	737	jack-35-mm	1	
3517	Jack 6.3 mm	737	jack-63-mm	2	
3518	USB Tip C	737	usb-tip-c	3	
3519	8-pin Lightning	737	8-pin-lightning	4	
3520	1 x RCA 	737	1-x-rca	5	
3521	2 x RCA	737	2-x-rca	6	
3522	Optic SPDIF	737	optic-spdif	7	
3523	DC jack 5.5 mm	737	dc-jack-55-mm	8	
3524	Mama	738	mama	0	
3525	Tata	738	tata	1	
3526	Drept	739	drept	0	
3527	La 90 de grade	739	la-90-de-grade	1	
3528	Conectori auriti	740	conectori-auriti	0	
3529	Conectori nichelati	740	conectori-nichelati	1	
3530	Conector Jack 3 pini	740	conector-jack-3-pini	2	
3531	Conector Jack 4 pini	740	conector-jack-4-pini	3	
3532	Conversie semnal	740	conversie-semnal	4	
3533	Stereo	740	stereo	5	
3534	Mono	740	mono	6	
3535	Semnal digital la analog	740	semnal-digital-la-analog	7	
3536	Cu alimentator	740	cu-alimentator	8	
3537	Convertor audio	741	convertor-audio	0	
3538	ABS	742	abs	0	
3539	Aluminiu	742	aluminiu	1	
3540	Aliaj	742	aliaj	2	
3541	Plastic	742	plastic	3	
3542	PVC	742	pvc	4	
3543	Metal	742	metal	5	
3544	Alb	743	alb	0	
3545	Albastru	743	albastru	1	
3546	Argintiu	743	argintiu	2	
3547	Auriu	743	auriu	3	
3548	Gri	743	gri	4	
3549	Negru	743	negru	5	
3550	Semnal	744	semnal	0	
3551	Adaptare semnal	744	adaptare-semnal	1	
3552	Cu cablu	745	cu-cablu	0	
3553	Fara cablu	745	fara-cablu	1	
3554	DisplayPort	746	displayport	0	
3555	DVI	746	dvi	1	
3556	HDMI	746	hdmi	2	
3557	microHDMI	746	microhdmi	3	
3558	miniHDMI	746	minihdmi	4	
3559	miniDisplayPort	746	minidisplayport	5	
3560	USB 3.0	746	usb-30	6	
3561	USB 3.0 Tip C	746	usb-30-tip-c	7	
3562	USB 3.1	746	usb-31	8	
3563	USB 3.1 Gen 2	746	usb-31-gen-2	9	
3564	USB 3.1 Tip C	746	usb-31-tip-c	10	
3565	VGA	746	vga	11	
3566	8-pin Lightning	746	8-pin-lightning	12	
3567	Mama	747	mama	0	
3568	Tata	747	tata	1	
3569	intrare semnal	748	intrare-semnal	0	
3570	iesire semnal	748	iesire-semnal	1	
3571	bi-directional	748	bi-directional	2	
3572	Drept	749	drept	0	
3573	La 90 grade	749	la-90-grade	1	
3574	180 grade	749	180-grade	2	
3575	Card Reader	750	card-reader	0	
3576	DisplayPort	750	displayport	1	
3577	DVI	750	dvi	2	
3578	Jack 3.5 mm	750	jack-35-mm	3	
3579	HDMI	750	hdmi	4	
3580	2 X HDMI	750	2-x-hdmi	5	
3581	3 x HDMI	750	3-x-hdmi	6	
3582	4 x HDMI	750	4-x-hdmi	7	
3583	5 x HDMI	750	5-x-hdmi	8	
3584	miniUSB	750	miniusb	9	
3585	microUSB	750	microusb	10	
3586	microHDMI	750	microhdmi	11	
3587	miniHDMI	750	minihdmi	12	
3588	miniDisplayPort	750	minidisplayport	13	
3589	RJ45 	750	rj45	14	
3590	RJ45 Gigabit	750	rj45-gigabit	15	
3591	USB	750	usb	16	
3592	USB Tip C	750	usb-tip-c	17	
3593	USB C PD	750	usb-c-pd	18	
3594	USB 3.0	750	usb-30	19	
3595	USB 3.0 Tip C	750	usb-30-tip-c	20	
3596	USB 3.1	750	usb-31	21	
3597	USB 3.1 Tip C	750	usb-31-tip-c	22	
3598	VGA	750	vga	23	
3599	8-pin Lightning	750	8-pin-lightning	24	
3600	Mama	751	mama	0	
3601	Tata	751	tata	1	
3602	intrare semnal	752	intrare-semnal	0	
3603	iesire semnal	752	iesire-semnal	1	
3604	bi-directional	752	bi-directional	2	
3605	Drept	753	drept	0	
3606	La 90 grade	753	la-90-grade	1	
3607	180 grade	753	180-grade	2	
3608	conector VGA 15 pini	754	conector-vga-15-pini	0	
3609	conector DVI-D 18 + 1 pini	754	conector-dvi-d-18-1-pini	1	
3610	conector DVI 24 + 1 pini	754	conector-dvi-24-1-pini	2	
3611	conector DVI-D 24 + 5 pini	754	conector-dvi-d-24-5-pini	3	
3612	30Hz	754	30hz	4	
3613	60Hz	754	60hz	5	
3614	120Hz	754	120hz	6	
3615	rezolutie HD	754	rezolutie-hd	7	
3616	rezolutie Full HD	754	rezolutie-full-hd	8	
3617	rezolutie 2K	754	rezolutie-2k	9	
3618	rezolutie 4K	754	rezolutie-4k	10	
3619	rezolutie 8K	754	rezolutie-8k	11	
3620	transmisie video	754	transmisie-video	12	
3621	transmisie video si audio	754	transmisie-video-si-audio	13	
3622	ABS	755	abs	0	
3623	Aluminiu	755	aluminiu	1	
3624	Plastic	755	plastic	2	
3625	Metal	755	metal	3	
3626	Policarbonat	755	policarbonat	4	
3627	Adaptor 	756	adaptor	0	
3628	Alb	757	alb	0	
3629	Argintiu	757	argintiu	1	
3630	Albastru	757	albastru	2	
3631	Auriu	757	auriu	3	
3632	Gri	757	gri	4	
3633	Negru	757	negru	5	
3634	Semnal	758	semnal	0	
3635	Convertire semnal	758	convertire-semnal	1	
3636	Cu cablu	759	cu-cablu	0	
3637	Fara cablu	759	fara-cablu	1	
3638	DisplayPort	760	displayport	0	
3639	DVI	760	dvi	1	
3640	DC Jack 5.5 mm	760	dc-jack-55-mm	2	
3641	HDMI	760	hdmi	3	
3642	Jack 3.5 mm	760	jack-35-mm	4	
3643	microHDMI	760	microhdmi	5	
3644	miniHDMI	760	minihdmi	6	
3645	miniDisplayPort	760	minidisplayport	7	
3646	Optic SPDIF	760	optic-spdif	8	
3647	USB 3.0	760	usb-30	9	
3648	USB 3.0 Tip C	760	usb-30-tip-c	10	
3649	USB 3.1	760	usb-31	11	
3650	USB 3.1 Gen 2	760	usb-31-gen-2	12	
3651	USB 3.1 Tip C	760	usb-31-tip-c	13	
3652	VGA	760	vga	14	
3653	8-pin Lightning	760	8-pin-lightning	15	
3654	Mama	761	mama	0	
3655	Tata	761	tata	1	
3656	intrare semnal	762	intrare-semnal	0	
3657	iesire semnal	762	iesire-semnal	1	
3658	bi-directional	762	bi-directional	2	
3659	Drept	763	drept	0	
3660	La 90 grade	763	la-90-grade	1	
3661	DisplayPort	764	displayport	0	
3662	DVI	764	dvi	1	
3663	DC Jack 5.5 mm	764	dc-jack-55-mm	2	
3664	HDMI	764	hdmi	3	
3665	Jack 3.5 mm	764	jack-35-mm	4	
3666	microHDMI	764	microhdmi	5	
3667	miniHDMI	764	minihdmi	6	
3668	miniDisplayPort	764	minidisplayport	7	
3669	Optic  SPDIF	764	optic-spdif	8	
3670	RCA	764	rca	9	
3671	USB 3.0	764	usb-30	10	
3672	USB 3.0 Tip C	764	usb-30-tip-c	11	
3673	USB 3.1	764	usb-31	12	
3674	USB 3.1 Gen 2	764	usb-31-gen-2	13	
3675	USB 3.1 Tip C	764	usb-31-tip-c	14	
3676	VGA	764	vga	15	
3677	8-pin Lightning	764	8-pin-lightning	16	
3678	Mama	765	mama	0	
3679	Tata	765	tata	1	
3680	intrare semnal	766	intrare-semnal	0	
3681	iesire semnal	766	iesire-semnal	1	
3682	bi-directional	766	bi-directional	2	
3683	Drept	767	drept	0	
3684	La 90 grade	767	la-90-grade	1	
3685	ARC	768	arc	0	
3686	3D	768	3d	1	
3687	conector VGA 15 pini	768	conector-vga-15-pini	2	
3688	conector DVI-D 18 + 1 pini	768	conector-dvi-d-18-1-pini	3	
3689	conector DVI 24 + 1 pini	768	conector-dvi-24-1-pini	4	
3690	conector DVI-D 24 + 5 pini	768	conector-dvi-d-24-5-pini	5	
3691	30Hz	768	30hz	6	
3692	60Hz	768	60hz	7	
3693	120Hz	768	120hz	8	
3694	rezolutie HD	768	rezolutie-hd	9	
3695	rezolutie Full HD	768	rezolutie-full-hd	10	
3696	rezolutie 2K	768	rezolutie-2k	11	
3697	rezolutie 4K	768	rezolutie-4k	12	
3698	rezolutie 8K	768	rezolutie-8k	13	
3699	transmisie video	768	transmisie-video	14	
3700	transmisie video si audio	768	transmisie-video-si-audio	15	
3701	ABS	769	abs	0	
3702	Aluminiu	769	aluminiu	1	
3703	Plastic	769	plastic	2	
3704	Metal	769	metal	3	
3705	Policarbonat	769	policarbonat	4	
3706	Convertor	770	convertor	0	
3707	Alb	771	alb	0	
3708	Argintiu	771	argintiu	1	
3709	Albastru	771	albastru	2	
3710	Auriu	771	auriu	3	
3711	Gri	771	gri	4	
3712	Negru	771	negru	5	
3713	Semnal	772	semnal	0	
3714	Prelungire semnal	772	prelungire-semnal	1	
3715	cu cablu	773	cu-cablu	0	
3716	Fara cablu	773	fara-cablu	1	
3717	DisplayPort	774	displayport	0	
3718	DVI	774	dvi	1	
3719	HDMI	774	hdmi	2	
3720	microHDMI	774	microhdmi	3	
3721	miniHDMI	774	minihdmi	4	
3722	miniDisplayPort	774	minidisplayport	5	
3723	VGA	774	vga	6	
3724	Mama	775	mama	0	
3725	intrare semnal	776	intrare-semnal	0	
3726	iesire semnal	776	iesire-semnal	1	
3727	bi-directional	776	bi-directional	2	
3728	Drept	777	drept	0	
3729	La 90 grade	777	la-90-grade	1	
3730	La 180 grade	777	la-180-grade	2	
3731	La 360 grade	777	la-360-grade	3	
3732	DisplayPort	778	displayport	0	
3733	DVI	778	dvi	1	
3734	HDMI	778	hdmi	2	
3735	microHDMI	778	microhdmi	3	
3736	miniHDMI	778	minihdmi	4	
3737	miniDisplayPort	778	minidisplayport	5	
3738	VGA	778	vga	6	
3739	Mama	779	mama	0	
3740	intrare semnal	780	intrare-semnal	0	
3741	iesire semnal	780	iesire-semnal	1	
3742	bi-directional	780	bi-directional	2	
3743	Drept	781	drept	0	
3744	La 90 grade	781	la-90-grade	1	
3745	La 180 grade	781	la-180-grade	2	
3746	La 360 grade	781	la-360-grade	3	
3747	conector VGA 15 pini	782	conector-vga-15-pini	0	
3748	conector DVI-D 18 + 1 pini	782	conector-dvi-d-18-1-pini	1	
3749	conector DVI 24 + 1 pini	782	conector-dvi-24-1-pini	2	
3750	conector DVI-D 24 + 5 pini	782	conector-dvi-d-24-5-pini	3	
3751	30Hz	782	30hz	4	
3752	60Hz	782	60hz	5	
3753	120Hz	782	120hz	6	
3754	rezolutie HD	782	rezolutie-hd	7	
3755	rezolutie Full HD	782	rezolutie-full-hd	8	
3756	rezolutie 2K	782	rezolutie-2k	9	
3757	rezolutie 4K	782	rezolutie-4k	10	
3758	rezolutie 8K	782	rezolutie-8k	11	
3759	transmisie video	782	transmisie-video	12	
3760	transmisie video si audio	782	transmisie-video-si-audio	13	
3761	ABS	783	abs	0	
3762	Aluminiu	783	aluminiu	1	
3763	Plastic	783	plastic	2	
3764	Metal	783	metal	3	
3765	Policarbonat	783	policarbonat	4	
3766	Prelungitor	784	prelungitor	0	
3767	Alb	785	alb	0	
3768	Argintiu	785	argintiu	1	
3769	Albastru	785	albastru	2	
3770	Auriu	785	auriu	3	
3771	Gri	785	gri	4	
3772	Negru	785	negru	5	
3773	Amplificare semnal	786	amplificare-semnal	0	
3774	Semnal	786	semnal	1	
3775	Cu cablu	787	cu-cablu	0	
3776	Fara cablu	787	fara-cablu	1	
3777	DisplayPort	788	displayport	0	
3778	DVI	788	dvi	1	
3779	HDMI	788	hdmi	2	
3780	microHDMI	788	microhdmi	3	
3781	miniHDMI	788	minihdmi	4	
3782	miniDisplayPort	788	minidisplayport	5	
3783	VGA	788	vga	6	
3784	Mama	789	mama	0	
3785	Tata	789	tata	1	
3786	intrare semnal	790	intrare-semnal	0	
3787	iesire semnal	790	iesire-semnal	1	
3788	bi-directional	790	bi-directional	2	
3789	Drept	791	drept	0	
3790	La 90 de grade	791	la-90-de-grade	1	
3791	DisplayPort	792	displayport	0	
3792	DVI	792	dvi	1	
3793	HDMI	792	hdmi	2	
3794	microHDMI	792	microhdmi	3	
3795	miniHDMI	792	minihdmi	4	
3796	miniDisplayPort	792	minidisplayport	5	
3797	VGA	792	vga	6	
3798	Mama	793	mama	0	
3799	Tata	793	tata	1	
3800	intrare semnal	794	intrare-semnal	0	
3801	iesire semnal	794	iesire-semnal	1	
3802	bi-directional	794	bi-directional	2	
3803	Drept	795	drept	0	
3804	La 90 de grade	795	la-90-de-grade	1	
3805	conector VGA 15 pini	796	conector-vga-15-pini	0	
3806	conector DVI-D 18 + 1 pini	796	conector-dvi-d-18-1-pini	1	
3807	conector DVI 24 + 1 pini	796	conector-dvi-24-1-pini	2	
3808	conector DVI-D 24 + 5 pini	796	conector-dvi-d-24-5-pini	3	
3809	30Hz	796	30hz	4	
3810	60Hz	796	60hz	5	
3811	120Hz	796	120hz	6	
3812	rezolutie HD	796	rezolutie-hd	7	
3813	rezolutie Full HD	796	rezolutie-full-hd	8	
3814	rezolutie 2K	796	rezolutie-2k	9	
3815	rezolutie 4K	796	rezolutie-4k	10	
3816	rezolutie 8K	796	rezolutie-8k	11	
3817	transmisie video	796	transmisie-video	12	
3818	transmisie video si audio	796	transmisie-video-si-audio	13	
3819	ABS	797	abs	0	
3820	Aluminiu	797	aluminiu	1	
3821	Plastic	797	plastic	2	
3822	Metal	797	metal	3	
3823	Policarbonat	797	policarbonat	4	
3824	Repetitor	798	repetitor	0	
3825	Alb	799	alb	0	
3826	Argintiu	799	argintiu	1	
3827	Albastru	799	albastru	2	
3828	Auriu	799	auriu	3	
3829	Gri	799	gri	4	
3830	Negru	799	negru	5	
3831	Divizare semnal	800	divizare-semnal	0	
3832	Cu cablu	801	cu-cablu	0	
3833	Fara cablu	801	fara-cablu	1	
3834	DisplayPort	802	displayport	0	
3835	DVI	802	dvi	1	
3836	HDMI	802	hdmi	2	
3837	microHDMI	802	microhdmi	3	
3838	miniHDMI	802	minihdmi	4	
3839	miniDisplayPort	802	minidisplayport	5	
3840	VGA	802	vga	6	
3841	Mama	803	mama	0	
3842	Tata	803	tata	1	
3843	intrare semnal	804	intrare-semnal	0	
3844	iesire semnal	804	iesire-semnal	1	
3845	bi-directional	804	bi-directional	2	
3846	Drept	805	drept	0	
3847	La 90 de grade	805	la-90-de-grade	1	
3848	DisplayPort	806	displayport	0	
3849	DVI	806	dvi	1	
3850	HDMI	806	hdmi	2	
3851	2 X HDMI	806	2-x-hdmi	3	
3852	3 x HDMI	806	3-x-hdmi	4	
3853	4 xHDMI	806	4-xhdmi	5	
3854	5 x HDMI	806	5-x-hdmi	6	
3855	microHDMI	806	microhdmi	7	
3856	miniHDMI	806	minihdmi	8	
3857	miniDisplayPort	806	minidisplayport	9	
3858	VGA	806	vga	10	
3859	Mama	807	mama	0	
3860	Tata	807	tata	1	
3861	intrare semnal	808	intrare-semnal	0	
3862	iesire semnal	808	iesire-semnal	1	
3863	bi-directional	808	bi-directional	2	
3864	Drept	809	drept	0	
3865	La 90 de grade	809	la-90-de-grade	1	
3866	conector VGA 15 pini	810	conector-vga-15-pini	0	
3867	conector DVI-D 18 + 1 pini	810	conector-dvi-d-18-1-pini	1	
3868	conector DVI 24 + 1 pini	810	conector-dvi-24-1-pini	2	
3869	conector DVI-D 24 + 5 pini	810	conector-dvi-d-24-5-pini	3	
3870	30Hz	810	30hz	4	
3871	60Hz	810	60hz	5	
3872	120Hz	810	120hz	6	
3873	rezolutie HD	810	rezolutie-hd	7	
3874	rezolutie Full HD	810	rezolutie-full-hd	8	
3875	rezolutie 2K	810	rezolutie-2k	9	
3876	rezolutie 4K	810	rezolutie-4k	10	
3877	rezolutie 8K	810	rezolutie-8k	11	
3878	telecomanda	810	telecomanda	12	
3879	transmisie video	810	transmisie-video	13	
3880	transmisie video si audio	810	transmisie-video-si-audio	14	
3881	ABS	811	abs	0	
3882	Aluminiu	811	aluminiu	1	
3883	Plastic	811	plastic	2	
3884	Metal	811	metal	3	
3885	Policarbonat	811	policarbonat	4	
3886	Splitter	812	splitter	0	
3887	Alb	813	alb	0	
3888	Argintiu	813	argintiu	1	
3889	Albastru	813	albastru	2	
3890	Auriu	813	auriu	3	
3891	Gri	813	gri	4	
3892	Negru	813	negru	5	
3893	Comutare semnal	814	comutare-semnal	0	
3894	Cu cablu	815	cu-cablu	0	
3895	Fara cablu	815	fara-cablu	1	
3896	DisplayPort	816	displayport	0	
3897	DVI	816	dvi	1	
3898	HDMI	816	hdmi	2	
3899	2 X HDMI	816	2-x-hdmi	3	
3900	3 x HDMI	816	3-x-hdmi	4	
3901	4 xHDMI	816	4-xhdmi	5	
3902	5 x HDMI	816	5-x-hdmi	6	
3903	microHDMI	816	microhdmi	7	
3904	miniHDMI	816	minihdmi	8	
3905	miniDisplayPort	816	minidisplayport	9	
3906	VGA	816	vga	10	
3907	Mama	817	mama	0	
3908	Tata	817	tata	1	
3909	intrare semnal	818	intrare-semnal	0	
3910	iesire semnal	818	iesire-semnal	1	
3911	bi-directional	818	bi-directional	2	
3912	Drept	819	drept	0	
3913	La 90 de grade	819	la-90-de-grade	1	
3914	DisplayPort	820	displayport	0	
3915	DVI	820	dvi	1	
3916	HDMI	820	hdmi	2	
3917	2 X HDMI	820	2-x-hdmi	3	
3918	3 x HDMI	820	3-x-hdmi	4	
3919	4 xHDMI	820	4-xhdmi	5	
3920	5 x HDMI	820	5-x-hdmi	6	
3921	microHDMI	820	microhdmi	7	
3922	miniHDMI	820	minihdmi	8	
3923	miniDisplayPort	820	minidisplayport	9	
3924	VGA	820	vga	10	
3925	Mama	821	mama	0	
3926	Tata	821	tata	1	
3927	intrare semnal	822	intrare-semnal	0	
3928	iesire semnal	822	iesire-semnal	1	
3929	bi-directional	822	bi-directional	2	
3930	Drept	823	drept	0	
3931	La 90 de grade	823	la-90-de-grade	1	
3932	conector VGA 15 pini	824	conector-vga-15-pini	0	
3933	conector DVI-D 18 + 1 pini	824	conector-dvi-d-18-1-pini	1	
3934	conector DVI 24 + 1 pini	824	conector-dvi-24-1-pini	2	
3935	conector DVI-D 24 + 5 pini	824	conector-dvi-d-24-5-pini	3	
3936	30Hz	824	30hz	4	
3937	60Hz	824	60hz	5	
3938	120Hz	824	120hz	6	
3939	rezolutie HD	824	rezolutie-hd	7	
3940	rezolutie Full HD	824	rezolutie-full-hd	8	
3941	rezolutie 2K	824	rezolutie-2k	9	
3942	rezolutie 4K	824	rezolutie-4k	10	
3943	rezolutie 8K	824	rezolutie-8k	11	
3944	telecomanda	824	telecomanda	12	
3945	transmisie video	824	transmisie-video	13	
3946	transmisie video si audio	824	transmisie-video-si-audio	14	
3947	ABS	825	abs	0	
3948	Aluminiu	825	aluminiu	1	
3949	Plastic	825	plastic	2	
3950	Metal	825	metal	3	
3951	Policarbonat	825	policarbonat	4	
3952	Comutator	826	comutator	0	
3953	Alb	827	alb	0	
3954	Argintiu	827	argintiu	1	
3955	Albastru	827	albastru	2	
3956	Auriu	827	auriu	3	
3957	Gri	827	gri	4	
3958	Negru	827	negru	5	
3959	Semnal	828	semnal	0	
3960	Prelungire semnal	828	prelungire-semnal	1	
3961	0.10 m	829	010-m	0	
3962	0.15 m	829	015-m	1	
3963	0.20 m	829	020-m	2	
3964	0.25 m	829	025-m	3	
3965	0.30 m	829	030-m	4	
3966	0.50 m	829	050-m	5	
3967	0.60 m	829	060-m	6	
3968	1 m	829	1-m	7	
3969	1.50 m	829	150-m	8	
3970	2 m	829	2-m	9	
3971	2.50 m	829	250-m	10	
3972	3 m	829	3-m	11	
3973	5 m	829	5-m	12	
3974	10 m	829	10-m	13	
3975	15 m	829	15-m	14	
3976	20 m	829	20-m	15	
3977	Jack 3.5mm	830	jack-35mm	0	
3978	2 x Jack 3.5 mm	830	2-x-jack-35-mm	1	
3979	Jack 2.5mm	830	jack-25mm	2	
3980	Jack 6.3mm	830	jack-63mm	3	
3981	RCA	830	rca	4	
3982	2 x RCA	830	2-x-rca	5	
3983	3 x RCA	830	3-x-rca	6	
3984	Optic Toslink	830	optic-toslink	7	
3985	Mama	831	mama	0	
3986	Tata	831	tata	1	
3987	Drept	832	drept	0	
3988	La 90 de grade	832	la-90-de-grade	1	
3989	Jack 3.5mm	833	jack-35mm	0	
3990	2 x Jack 3.5 mm	833	2-x-jack-35-mm	1	
3991	Jack 2.5mm	833	jack-25mm	2	
3992	Jack 6.3mm	833	jack-63mm	3	
3993	RCA	833	rca	4	
3994	2 x RCA	833	2-x-rca	5	
3995	3 x RCA	833	3-x-rca	6	
3996	Optic Toslink	833	optic-toslink	7	
3997	Mama	834	mama	0	
3998	Tata	834	tata	1	
3999	Drept	835	drept	0	
4000	La 90 de grade	835	la-90-de-grade	1	
4001	PVC	836	pvc	0	
4002	Plastic	836	plastic	1	
4003	Fibre textile impletite	836	fibre-textile-impletite	2	
4004	Piele ecologica	836	piele-ecologica	3	
4005	Siliconic	836	siliconic	4	
4006	Metalic	836	metalic	5	
4007	Alb	837	alb	0	
4008	Albastru	837	albastru	1	
4009	Negru	837	negru	2	
4010	Rosu	837	rosu	3	
4011	Verde	837	verde	4	
4012	conector Jack 3 pini	838	conector-jack-3-pini	0	
4013	conector jack 4 pini	838	conector-jack-4-pini	1	
4014	conectori auriti	838	conectori-auriti	2	
4015	conectori nichelati	838	conectori-nichelati	3	
4016	Semnal	839	semnal	0	
4017	Prelungire semnal	839	prelungire-semnal	1	
4018	Dual Link	840	dual-link	0	
4019	Single Link	840	single-link	1	
4020	v.1.1	840	v11	2	
4021	v.1.2	840	v12	3	
4022	v.1.3	840	v13	4	
4023	v.1.4	840	v14	5	
4024	v.2.0	840	v20	6	
4025	v.2.1	840	v21	7	
4026	universal	840	universal	8	
4027	dedicat	840	dedicat	9	
4028	0.10 m	841	010-m	0	
4029	0.15 m	841	015-m	1	
4030	0.20 m	841	020-m	2	
4031	0.25 m	841	025-m	3	
4032	0.30 m	841	030-m	4	
4033	0.50 m	841	050-m	5	
4034	0.60 m	841	060-m	6	
4035	1 m	841	1-m	7	
4036	1.50 m	841	150-m	8	
4037	1.80 m	841	180-m	9	
4038	2 m	841	2-m	10	
4039	2.50 m	841	250-m	11	
4040	3 m	841	3-m	12	
4041	5 m	841	5-m	13	
4042	10 m	841	10-m	14	
4043	15 m	841	15-m	15	
4044	20 m	841	20-m	16	
4045	DisplayPort	842	displayport	0	
4046	DVI	842	dvi	1	
4047	HDMI	842	hdmi	2	
4048	miniDisplayPort	842	minidisplayport	3	
4049	miniHDMI	842	minihdmi	4	
4050	microHDMI	842	microhdmi	5	
4051	USB Tip C	842	usb-tip-c	6	
4052	VGA	842	vga	7	
4053	Mama	843	mama	0	
4054	Tata	843	tata	1	
4055	Drept	844	drept	0	
4056	La 90 grade	844	la-90-grade	1	
4057	180 grade	844	180-grade	2	
4058	360 grade	844	360-grade	3	
4059	DisplayPort	845	displayport	0	
4060	DVI	845	dvi	1	
4061	HDMI	845	hdmi	2	
4062	miniDisplayPort	845	minidisplayport	3	
4063	miniHDMI	845	minihdmi	4	
4064	microHDMI	845	microhdmi	5	
4065	USB Tip C	845	usb-tip-c	6	
4066	VGA	845	vga	7	
4067	Mama	846	mama	0	
4068	Tata	846	tata	1	
4069	Drept	847	drept	0	
4070	La 90 grade	847	la-90-grade	1	
4071	180 grade	847	180-grade	2	
4072	360 grade	847	360-grade	3	
4073	PVC	848	pvc	0	
4074	Plastic	848	plastic	1	
4075	Fibre textile impletite	848	fibre-textile-impletite	2	
4076	rezolutie HD	849	rezolutie-hd	0	
4077	rezolutie Full HD	849	rezolutie-full-hd	1	
4078	rezolutie 2K	849	rezolutie-2k	2	
4079	rezolutie 4K UHD	849	rezolutie-4k-uhd	3	
4080	rezolutie 8K	849	rezolutie-8k	4	
4081	30Hz	849	30hz	5	
4082	60Hz	849	60hz	6	
4083	120Hz	849	120hz	7	
4084	Ethernet	849	ethernet	8	
4085	ARC	849	arc	9	
4086	3D	849	3d	10	
4087	transmisie video	849	transmisie-video	11	
4088	transmisie video si audio	849	transmisie-video-si-audio	12	
4089	Alb	850	alb	0	
4090	Albastru	850	albastru	1	
4091	Rosu	850	rosu	2	
4092	Gri	850	gri	3	
4093	Negru	850	negru	4	
4094	Verde	850	verde	5	
4095	2 x Jack 3.5 mm	713	2-x-jack-35-mm	10	
4096	Conector Jack 4 pini la 2 x Conector Jack 3 pini	716	conector-jack-4-pini-la-2-x-conector-jack-3-pini	7	
4097	Coaxial	734	coaxial	9	
\.


--
-- Data for Name: product_attributevaluetranslation; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.product_attributevaluetranslation (id, language_code, name, attribute_value_id) FROM stdin;
\.


--
-- Data for Name: product_attributevariant; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.product_attributevariant (id, attribute_id, product_type_id, sort_order) FROM stdin;
\.


--
-- Data for Name: product_category; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.product_category (id, name, slug, description, lft, rght, tree_id, level, parent_id, background_image, seo_description, seo_title, background_image_alt, description_json, metadata, private_metadata) FROM stdin;
1	Cabluri Audio	cabluri-audio		1	2	1	0	\N					{"blocks": [{"key": "4t85v", "data": {}, "text": "Cabluri concepute pentru conexiunea dispozitivelor si accesoriilor de redare a sunetului, cu rol de transmitere a semnalului audio", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}], "entityMap": {}}	{}	{}
2	Conectica Audio	conectica-audio		1	2	2	0	\N					{"blocks": [{"key": "5goir", "data": {}, "text": "Adaptoare, convertoare si elemente pentru realizarea conectarii intre dispozitive si accesorii audio", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}], "entityMap": {}}	{}	{}
3	Cabluri Video Multimedia	cabluri-video-multimedia		1	2	3	0	\N					{"blocks": [{"key": "8j70a", "data": {}, "text": "Cabluri concepute pentru redarea continutului multimedia. Utilizate pentru conectarea la dispozitivele care redau imaginea, cum sunt monitoarele, televizoarele si pentru dispozitive de la care se transmite continut multimedia, cum sunt computerele , laptop-urile , Blu-Ray playere si altele.", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}], "entityMap": {}}	{}	{}
\.


--
-- Data for Name: product_categorytranslation; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.product_categorytranslation (id, seo_title, seo_description, language_code, name, description, category_id, description_json) FROM stdin;
\.


--
-- Data for Name: product_collection; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.product_collection (id, name, slug, background_image, seo_description, seo_title, is_published, description, publication_date, background_image_alt, description_json, metadata, private_metadata) FROM stdin;
\.


--
-- Data for Name: product_collectionproduct; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.product_collectionproduct (id, collection_id, product_id, sort_order) FROM stdin;
\.


--
-- Data for Name: product_collectiontranslation; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.product_collectiontranslation (id, seo_title, seo_description, language_code, name, collection_id, description, description_json) FROM stdin;
\.


--
-- Data for Name: product_digitalcontent; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.product_digitalcontent (id, use_default_settings, automatic_fulfillment, content_type, content_file, max_downloads, url_valid_days, product_variant_id, metadata, private_metadata) FROM stdin;
\.


--
-- Data for Name: product_digitalcontenturl; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.product_digitalcontenturl (id, token, created, download_num, content_id, line_id) FROM stdin;
\.


--
-- Data for Name: product_product; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.product_product (id, name, description, publication_date, updated_at, product_type_id, is_published, category_id, seo_description, seo_title, charge_taxes, weight, description_json, metadata, private_metadata, minimal_variant_price_amount, currency, slug, available_for_purchase, visible_in_listings, default_variant_id, description_plaintext, search_vector) FROM stdin;
16	Cablu audio optic digital , lungime 1 m, Lanberg 42239, 2 conectori tip TosLink tata, negru		2021-02-08	2021-02-08 20:55:01.931958+00	41	t	1			f	\N	{"blocks": [{"key": "e7mbg", "data": {}, "text": "Cablu audio optic digital pentru echipamentele audio care dispun de priza optica digitala. Transporta un flux audio digital de la componente precum CD/DVD/Blu-Ray playere, inregistratoare DAT, computere, console de jocuri, catre un receptor AV precum Home Theater, Sound Bar, Televizor, care poate decoda doua canale de audio PCM fara pierderi necomprimate sau sunet surround 5.1 / 7.1, cum ar fi Dolby Digital sau DTS Surround System.", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "92g2n", "data": {}, "text": "Datorita utilizarii materialelor dupa cele mai inalte standarde calitative, este extrem de durabil si ofera o calitate excelenta a sunetului.", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "8q9qt", "data": {}, "text": "Specificatii:", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "4o2hk", "data": {}, "text": "- tip produs: Cablu audio optic digital TosLink", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "9kbvm", "data": {}, "text": "- destinat pentru : semnal audio", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "fuo2g", "data": {}, "text": "- conectori : 2 x TosLink ( S/PDIF ) tata", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "8ro67", "data": {}, "text": "- lungime cablu : 1 metru", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "sjh4", "data": {}, "text": "- culoare : negru", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "egjc0", "data": {}, "text": "- greutate cu ambalaj : 40 g", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}], "entityMap": {}}	{}	{}	0.000	RON	cablu-audio-optic-digital-lungime-1-m-lanberg-42239-2-conectori-tip-toslink-tata-negru	\N	t	16	Cablu audio optic digital pentru echipamentele audio care dispun de priza optica digitala. Transporta un flux audio digital de la componente precum CD/DVD/Blu-Ray playere, inregistratoare DAT, computere, console de jocuri, catre un receptor AV precum Home Theater, Sound Bar, Televizor, care poate decoda doua canale de audio PCM fara pierderi necomprimate sau sunet surround 5.1 / 7.1, cum ar fi Dolby Digital sau DTS Surround System. Datorita utilizarii materialelor dupa cele mai inalte standarde calitative, este extrem de durabil si ofera o calitate excelenta a sunetului. Specificatii: - tip produs: Cablu audio optic digital TosLink - destinat pentru : semnal audio - conectori : 2 x TosLink ( S/PDIF ) tata - lungime cablu : 1 metru - culoare : negru - greutate cu ambalaj : 40 g 	'1':6A,121B '2':10A,114B '40':128B '42239':9A '5.1':70B '7.1':71B 'ambalaj':127B 'ar':73B 'audio':2A,17B,22B,32B,62B,105B,112B 'av':49B 'bar':54B 'cablu':1A,16B,104B,120B 'calit':89B,97B 'canal':60B 'care':23B,56B 'catr':46B 'cd/dvd/blu-ray':38B 'cele':85B 'component':36B 'computer':42B 'conectori':11A,113B 'consol':43B 'cu':126B 'culoar':123B 'cum':72B 'dat':41B 'datorita':81B 'de':25B,34B,44B,61B,92B 'decoda':58B 'destinat':109B 'digit':4A,19B,33B,76B,107B 'digitala':28B 'dispun':24B 'dolbi':75B 'doua':59B 'dts':78B 'dupa':84B 'durabil':93B 'echipamentel':21B 'est':90B 'excelenta':98B 'extrem':91B 'fara':64B 'fi':74B 'flux':31B 'g':129B 'greutat':125B 'home':51B 'inalt':87B 'inregistratoar':40B 'jocuri':45B 'la':35B 'lanberg':8A 'lungim':5A,119B 'm':7A 'mai':86B 'materialelor':83B 'metru':122B 'necomprim':66B 'negru':15A,124B 'o':96B 'ofera':95B 'optic':3A,18B,106B 'optica':27B 'pcm':63B 'pentru':20B,110B 'pierderi':65B 'player':39B 'poat':57B 'precum':37B,50B 'priza':26B 'produs':103B 'receptor':48B 's/pdif':117B 'sau':67B,77B 'semnal':111B 'si':94B 'sound':53B 'specificatii':101B 'standard':88B 'sunet':68B 'sunetului':100B 'surround':69B,79B 'system':80B 'tata':14A,118B 'televizor':55B 'theater':52B 'tip':12A,102B 'toslink':13A,108B,116B 'transporta':29B 'un':30B,47B 'utilizarii':82B 'x':115B
17	Cablu audio optic digital , lungime 2 m, Lanberg 42240, 2 conectori tip TosLink tata, negru		2021-02-08	2021-02-08 20:58:25.314704+00	41	t	1			f	\N	{"blocks": [{"key": "5k7rl", "data": {}, "text": "Cablu audio optic digital pentru echipamentele audio care dispun de priza optica digitala. Transporta un flux audio digital de la componente precum CD/DVD/Blu-Ray playere, inregistratoare DAT, computere, console de jocuri, catre un receptor AV precum Home Theater, Sound Bar, Televizor, care poate decoda doua canale de audio PCM fara pierderi necomprimate sau sunet surround 5.1 / 7.1, cum ar fi Dolby Digital sau DTS Surround System.", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "ui86", "data": {}, "text": "Datorita utilizarii materialelor dupa cele mai inalte standarde calitative, este extrem de durabil si ofera o calitate excelenta a sunetului.", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "2k2rn", "data": {}, "text": "Specificatii:", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "ft0ah", "data": {}, "text": "- tip produs: Cablu audio optic digital TosLink", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "6elld", "data": {}, "text": "- destinat pentru : semnal audio", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "e71ju", "data": {}, "text": "- conectori : 2 x TosLink (S/PDIF) tata", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "tfi1", "data": {}, "text": "- lungime cablu : 2 metri", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "brkm0", "data": {}, "text": "- culoare : negru", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "ajn2i", "data": {}, "text": "- greutate cu ambalaj : 52 g", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}], "entityMap": {}}	{}	{}	0.000	RON	cablu-audio-optic-digital-lungime-2-m-lanberg-42240-2-conectori-tip-toslink-tata-negru	\N	t	17	Cablu audio optic digital pentru echipamentele audio care dispun de priza optica digitala. Transporta un flux audio digital de la componente precum CD/DVD/Blu-Ray playere, inregistratoare DAT, computere, console de jocuri, catre un receptor AV precum Home Theater, Sound Bar, Televizor, care poate decoda doua canale de audio PCM fara pierderi necomprimate sau sunet surround 5.1 / 7.1, cum ar fi Dolby Digital sau DTS Surround System. Datorita utilizarii materialelor dupa cele mai inalte standarde calitative, este extrem de durabil si ofera o calitate excelenta a sunetului. Specificatii: - tip produs: Cablu audio optic digital TosLink - destinat pentru : semnal audio - conectori : 2 x TosLink (S/PDIF) tata - lungime cablu : 2 metri - culoare : negru - greutate cu ambalaj : 52 g 	'2':6A,10A,114B,121B '42240':9A '5.1':70B '52':128B '7.1':71B 'ambalaj':127B 'ar':73B 'audio':2A,17B,22B,32B,62B,105B,112B 'av':49B 'bar':54B 'cablu':1A,16B,104B,120B 'calit':89B,97B 'canal':60B 'care':23B,56B 'catr':46B 'cd/dvd/blu-ray':38B 'cele':85B 'component':36B 'computer':42B 'conectori':11A,113B 'consol':43B 'cu':126B 'culoar':123B 'cum':72B 'dat':41B 'datorita':81B 'de':25B,34B,44B,61B,92B 'decoda':58B 'destinat':109B 'digit':4A,19B,33B,76B,107B 'digitala':28B 'dispun':24B 'dolbi':75B 'doua':59B 'dts':78B 'dupa':84B 'durabil':93B 'echipamentel':21B 'est':90B 'excelenta':98B 'extrem':91B 'fara':64B 'fi':74B 'flux':31B 'g':129B 'greutat':125B 'home':51B 'inalt':87B 'inregistratoar':40B 'jocuri':45B 'la':35B 'lanberg':8A 'lungim':5A,119B 'm':7A 'mai':86B 'materialelor':83B 'metri':122B 'necomprim':66B 'negru':15A,124B 'o':96B 'ofera':95B 'optic':3A,18B,106B 'optica':27B 'pcm':63B 'pentru':20B,110B 'pierderi':65B 'player':39B 'poat':57B 'precum':37B,50B 'priza':26B 'produs':103B 'receptor':48B 's/pdif':117B 'sau':67B,77B 'semnal':111B 'si':94B 'sound':53B 'specificatii':101B 'standard':88B 'sunet':68B 'sunetului':100B 'surround':69B,79B 'system':80B 'tata':14A,118B 'televizor':55B 'theater':52B 'tip':12A,102B 'toslink':13A,108B,116B 'transporta':29B 'un':30B,47B 'utilizarii':82B 'x':115B
18	Cablu audio optic digital , lungime 3 m, Lanberg 42241, 2 conectori tip TosLink tata, negru		2021-02-10	2021-02-10 04:42:14.309274+00	41	t	1			f	\N	{"blocks": [{"key": "9c8me", "data": {}, "text": "Cablu audio optic digital pentru echipamentele audio care dispun de priza optica digitala. Transporta un flux audio digital de la componente precum CD/DVD/Blu-Ray playere, inregistratoare DAT, computere, console de jocuri, catre un receptor AV precum Home Theater, Sound Bar, Televizor, care poate decoda doua canale de audio PCM fara pierderi necomprimate sau sunet surround 5.1 / 7.1, cum ar fi Dolby Digital sau DTS Surround System.", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "bkffm", "data": {}, "text": "Datorita utilizarii materialelor dupa cele mai inalte standarde calitative, este extrem de durabil si ofera o calitate excelenta a sunetului.", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "4bfc4", "data": {}, "text": "Specificatii:", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "9mv3g", "data": {}, "text": "- tip produs: Cablu audio optic digital TosLink", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "bk3bq", "data": {}, "text": "- destinat pentru : semnal audio", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "7e98c", "data": {}, "text": "- conectori : 2 x TosLink (S/PDIF) tata", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "75u3t", "data": {}, "text": "- lungime cablu : 3 metri", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "bf12f", "data": {}, "text": "- culoare : negru", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "8ekla", "data": {}, "text": "- greutate cu ambalaj : 65 g", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}], "entityMap": {}}	{}	{}	0.000	RON	cablu-audio-optic-digital-lungime-3-m-lanberg-42241-2-conectori-tip-toslink-tata-negru	\N	t	\N	Cablu audio optic digital pentru echipamentele audio care dispun de priza optica digitala. Transporta un flux audio digital de la componente precum CD/DVD/Blu-Ray playere, inregistratoare DAT, computere, console de jocuri, catre un receptor AV precum Home Theater, Sound Bar, Televizor, care poate decoda doua canale de audio PCM fara pierderi necomprimate sau sunet surround 5.1 / 7.1, cum ar fi Dolby Digital sau DTS Surround System. Datorita utilizarii materialelor dupa cele mai inalte standarde calitative, este extrem de durabil si ofera o calitate excelenta a sunetului. Specificatii: - tip produs: Cablu audio optic digital TosLink - destinat pentru : semnal audio - conectori : 2 x TosLink (S/PDIF) tata - lungime cablu : 3 metri - culoare : negru - greutate cu ambalaj : 65 g 	'2':10A,114B '3':6A,121B '42241':9A '5.1':70B '65':128B '7.1':71B 'ambalaj':127B 'ar':73B 'audio':2A,17B,22B,32B,62B,105B,112B 'av':49B 'bar':54B 'cablu':1A,16B,104B,120B 'calit':89B,97B 'canal':60B 'care':23B,56B 'catr':46B 'cd/dvd/blu-ray':38B 'cele':85B 'component':36B 'computer':42B 'conectori':11A,113B 'consol':43B 'cu':126B 'culoar':123B 'cum':72B 'dat':41B 'datorita':81B 'de':25B,34B,44B,61B,92B 'decoda':58B 'destinat':109B 'digit':4A,19B,33B,76B,107B 'digitala':28B 'dispun':24B 'dolbi':75B 'doua':59B 'dts':78B 'dupa':84B 'durabil':93B 'echipamentel':21B 'est':90B 'excelenta':98B 'extrem':91B 'fara':64B 'fi':74B 'flux':31B 'g':129B 'greutat':125B 'home':51B 'inalt':87B 'inregistratoar':40B 'jocuri':45B 'la':35B 'lanberg':8A 'lungim':5A,119B 'm':7A 'mai':86B 'materialelor':83B 'metri':122B 'necomprim':66B 'negru':15A,124B 'o':96B 'ofera':95B 'optic':3A,18B,106B 'optica':27B 'pcm':63B 'pentru':20B,110B 'pierderi':65B 'player':39B 'poat':57B 'precum':37B,50B 'priza':26B 'produs':103B 'receptor':48B 's/pdif':117B 'sau':67B,77B 'semnal':111B 'si':94B 'sound':53B 'specificatii':101B 'standard':88B 'sunet':68B 'sunetului':100B 'surround':69B,79B 'system':80B 'tata':14A,118B 'televizor':55B 'theater':52B 'tip':12A,102B 'toslink':13A,108B,116B 'transporta':29B 'un':30B,47B 'utilizarii':82B 'x':115B
20	Splitter adaptor audio stereo jack 3.5 mm 3 pini tata la 2 x jack 3.5 mm 3 pini mama, Lanberg 40993, cu cablu 10 cm, negru		2021-02-10	2021-02-10 04:51:53.307671+00	33	t	2			f	\N	{"blocks": [{"key": "2as36", "data": {}, "text": "Adaptor audio pentru utilizatorii care au nevoie de 2 fluxuri audio separate folosind 2 porturi mini jack de 3.5 mm mama stereo prin intermediul unui singur cablu cu conector stereo mini jack de 3.5 mm tata.", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "ashu3", "data": {}, "text": "", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "47q6q", "data": {}, "text": "Deosebit de util pentru configuratii cum sunt castile cu amplificatoare stereo cu utilizarea unui singur cablu, sau utilizarea a doua casti audio de la un singur dispozitiv sursa audio de redare (asigurati-va ca sursa si castile sunt de acelasi tip - cu sau fara microfon).", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "36a01", "data": {}, "text": "", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "canhk", "data": {}, "text": "Utilizarile sale includ suport pentru cele mai multe dispozitive audio, cum sunt PC-uri, notebook-uri, laptopuri, televizoare, turnuri audio, playere multimedia si alte tipuri de dispozitive si periferice audio.", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "7si6u", "data": {}, "text": "", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "2es76", "data": {}, "text": "Adaptorul audio Lanberg este definit de o transmisie buna a semnalului, o buna rezistenta la zgomot si mai putine perturbatii audio la semnalul original.", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "6j4rm", "data": {}, "text": "Produsul va satisface asteptarile celor care au nevoie de o calitate audio buna.", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "cl4jn", "data": {}, "text": "", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "cs52a", "data": {}, "text": "Specificatii:", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "70nq4", "data": {}, "text": "- tip produs : Splitter adaptor audio stereo jack 3.5mm tata la 2 x jack 3.5 mm mama", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "9822q", "data": {}, "text": "- destinat pentru : impartire semnal audio", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "64qlr", "data": {}, "text": "- material exterior: PVC, plastic", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "2nm4d", "data": {}, "text": "- culoare : negru", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "9fcq", "data": {}, "text": "- material conectori : nichel", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "qv08", "data": {}, "text": "- conector tip 1 : 1 x jack 3.5 mm 3 pin tata stereo", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "30sao", "data": {}, "text": "- conector tip 2 : 2 x jack 3.5 mm 3 pin mama stereo", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "3e9nj", "data": {}, "text": "- exemplu aplicatie : casti cu amplificator pe un singur cablu", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "8mjpq", "data": {}, "text": "- lungime cablu : 10 cm", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "3kbl9", "data": {}, "text": "- greutate produs : 15 g", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "d2e1i", "data": {}, "text": "- dimensiuni cu ambalaj : 235 x 130 x 10 mm", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "7jvlj", "data": {}, "text": "- greutate colet : 21 g", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}], "entityMap": {}}	{}	{}	0.000	RON	splitter-adaptor-audio-stereo-jack-35-mm-3-pini-tata-la-2-x-jack-35-mm-3-pini-mama-lanberg-40993-cu-cablu-10-cm-negru	\N	t	\N	Adaptor audio pentru utilizatorii care au nevoie de 2 fluxuri audio separate folosind 2 porturi mini jack de 3.5 mm mama stereo prin intermediul unui singur cablu cu conector stereo mini jack de 3.5 mm tata. Deosebit de util pentru configuratii cum sunt castile cu amplificatoare stereo cu utilizarea unui singur cablu, sau utilizarea a doua casti audio de la un singur dispozitiv sursa audio de redare (asigurati-va ca sursa si castile sunt de acelasi tip - cu sau fara microfon). Utilizarile sale includ suport pentru cele mai multe dispozitive audio, cum sunt PC-uri, notebook-uri, laptopuri, televizoare, turnuri audio, playere multimedia si alte tipuri de dispozitive si periferice audio. Adaptorul audio Lanberg este definit de o transmisie buna a semnalului, o buna rezistenta la zgomot si mai putine perturbatii audio la semnalul original. Produsul va satisface asteptarile celor care au nevoie de o calitate audio buna. Specificatii: - tip produs : Splitter adaptor audio stereo jack 3.5mm tata la 2 x jack 3.5 mm mama - destinat pentru : impartire semnal audio - material exterior: PVC, plastic - culoare : negru - material conectori : nichel - conector tip 1 : 1 x jack 3.5 mm 3 pin tata stereo - conector tip 2 : 2 x jack 3.5 mm 3 pin mama stereo - exemplu aplicatie : casti cu amplificator pe un singur cablu - lungime cablu : 10 cm - greutate produs : 15 g - dimensiuni cu ambalaj : 235 x 130 x 10 mm - greutate colet : 21 g 	'1':212B,213B '10':24A,245B,258B '130':256B '15':249B '2':12A,35B,40B,190B,224B,225B '21':262B '235':254B '3':8A,17A,218B,230B '3.5':6A,15A,45B,60B,186B,193B,216B,228B '40993':21A 'acelasi':103B 'adaptor':2A,27B,182B 'adaptorul':141B 'alt':134B 'ambalaj':253B 'amplif':238B 'amplificatoar':72B 'aplicati':235B 'asigurati':95B 'asigurati-va':94B 'asteptaril':168B 'au':32B,171B 'audio':3A,28B,37B,84B,91B,118B,130B,140B,142B,161B,176B,183B,200B 'buna':149B,153B,177B 'ca':97B 'cablu':23A,53B,78B,242B,244B 'calit':175B 'care':31B,170B 'casti':83B,236B 'castil':70B,100B 'cele':114B 'celor':169B 'cm':25A,246B 'colet':261B 'conector':55B,210B,222B 'conectori':208B 'configuratii':67B 'cu':22A,54B,71B,74B,105B,237B,252B 'culoar':205B 'cum':68B,119B 'de':34B,44B,59B,64B,85B,92B,102B,136B,146B,173B 'definit':145B 'deosebit':63B 'destinat':196B 'dimensiuni':251B 'dispozit':117B,137B 'dispozitiv':89B 'doua':82B 'est':144B 'exemplu':234B 'exterior':202B 'fara':107B 'fluxuri':36B 'folosind':39B 'g':250B,263B 'greutat':247B,260B 'impartir':198B 'includ':111B 'intermediul':50B 'jack':5A,14A,43B,58B,185B,192B,215B,227B 'la':11A,86B,155B,162B,189B 'lanberg':20A,143B 'laptopuri':127B 'lungim':243B 'mai':115B,158B 'mama':19A,47B,195B,232B 'materi':201B,207B 'microfon':108B 'mini':42B,57B 'mm':7A,16A,46B,61B,187B,194B,217B,229B,259B 'mult':116B 'multimedia':132B 'negru':26A,206B 'nevoi':33B,172B 'nichel':209B 'notebook':125B 'notebook-uri':124B 'o':147B,152B,174B 'origin':164B 'pc':122B 'pc-uri':121B 'pe':239B 'pentru':29B,66B,113B,197B 'periferic':139B 'perturbatii':160B 'pin':219B,231B 'pini':9A,18A 'plastic':204B 'player':131B 'porturi':41B 'prin':49B 'produs':180B,248B 'produsul':165B 'putin':159B 'pvc':203B 'redar':93B 'rezistenta':154B 'sale':110B 'satisfac':167B 'sau':79B,106B 'semnal':199B 'semnalul':163B 'semnalului':151B 'separ':38B 'si':99B,133B,138B,157B 'singur':52B,77B,88B,241B 'specificatii':178B 'splitter':1A,181B 'stereo':4A,48B,56B,73B,184B,221B,233B 'sunt':69B,101B,120B 'suport':112B 'sursa':90B,98B 'tata':10A,62B,188B,220B 'televizoar':128B 'tip':104B,179B,211B,223B 'tipuri':135B 'transmisi':148B 'turnuri':129B 'un':87B,240B 'unui':51B,76B 'uri':123B,126B 'util':65B 'utilizarea':75B,80B 'utilizaril':109B 'utilizatorii':30B 'va':96B,166B 'x':13A,191B,214B,226B,255B,257B 'zgomot':156B
21	Splitter adaptor audio stereo jack 3.5 mm 3 pini tata la 2 x jack 3.5 mm 3 pini mama, Lanberg 40993, cu cablu 10 cm, alb		2021-02-10	2021-02-10 04:55:11.993671+00	33	t	2			f	\N	{"blocks": [{"key": "7jieb", "data": {}, "text": "Adaptor audio pentru utilizatorii care au nevoie de 2 fluxuri audio separate folosind 2 porturi mini jack de 3.5 mm mama stereo prin intermediul unui singur cablu cu conector stereo mini jack de 3.5 mm tata.", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "dsfrg", "data": {}, "text": "", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "6ij2u", "data": {}, "text": "Deosebit de util pentru configuratii cum sunt castile cu amplificatoare stereo cu utilizarea unui singur cablu, sau utilizarea a doua casti audio de la un singur dispozitiv sursa audio de redare (asigurati-va ca sursa si castile sunt de acelasi tip - cu sau fara microfon).", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "a2qg3", "data": {}, "text": "", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "7317d", "data": {}, "text": "Utilizarile sale includ suport pentru cele mai multe dispozitive audio, cum sunt PC-uri, notebook-uri, laptopuri, televizoare, turnuri audio, playere multimedia si alte tipuri de dispozitive si periferice audio.", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "2lubv", "data": {}, "text": "", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "8pke0", "data": {}, "text": "Adaptorul audio Lanberg este definit de o transmisie buna a semnalului, o buna rezistenta la zgomot si mai putine perturbatii audio la semnalul original.", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "e49ls", "data": {}, "text": "Produsul va satisface asteptarile celor care au nevoie de o calitate audio buna.", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "2nfde", "data": {}, "text": "", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "7n9o7", "data": {}, "text": "Specificatii:", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "1p5qa", "data": {}, "text": "- tip produs : Splitter adaptor audio stereo jack 3.5mm tata la 2 x jack 3.5 mm mama", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "d4knl", "data": {}, "text": "- destinat pentru : impartire semnal audio", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "4g1nf", "data": {}, "text": "- material exterior: PVC, plastic", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "7gmr1", "data": {}, "text": "- culoare : alb", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "e38e5", "data": {}, "text": "- material conectori : nichel", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "2q02t", "data": {}, "text": "- conector tip 1 : 1 x jack 3.5 mm 3 pin tata stereo", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "2or7n", "data": {}, "text": "- conector tip 2 : 2 x jack 3.5 mm 3 pin mama stereo", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "9snud", "data": {}, "text": "- exemplu aplicatie : casti cu amplificator pe un singur cablu", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "8flg4", "data": {}, "text": "- lungime cablu : 10 cm", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "d1a19", "data": {}, "text": "- greutate produs : 15 g", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "6eumk", "data": {}, "text": "- dimensiuni cu ambalaj : 235 x 130 x 10 mm", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "b0o22", "data": {}, "text": "- greutate colet : 21 g", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}], "entityMap": {}}	{}	{}	0.000	RON	splitter-adaptor-audio-stereo-jack-35-mm-3-pini-tata-la-2-x-jack-35-mm-3-pini-mama-lanberg-40993-cu-cablu-10-cm-alb	\N	t	\N	Adaptor audio pentru utilizatorii care au nevoie de 2 fluxuri audio separate folosind 2 porturi mini jack de 3.5 mm mama stereo prin intermediul unui singur cablu cu conector stereo mini jack de 3.5 mm tata. Deosebit de util pentru configuratii cum sunt castile cu amplificatoare stereo cu utilizarea unui singur cablu, sau utilizarea a doua casti audio de la un singur dispozitiv sursa audio de redare (asigurati-va ca sursa si castile sunt de acelasi tip - cu sau fara microfon). Utilizarile sale includ suport pentru cele mai multe dispozitive audio, cum sunt PC-uri, notebook-uri, laptopuri, televizoare, turnuri audio, playere multimedia si alte tipuri de dispozitive si periferice audio. Adaptorul audio Lanberg este definit de o transmisie buna a semnalului, o buna rezistenta la zgomot si mai putine perturbatii audio la semnalul original. Produsul va satisface asteptarile celor care au nevoie de o calitate audio buna. Specificatii: - tip produs : Splitter adaptor audio stereo jack 3.5mm tata la 2 x jack 3.5 mm mama - destinat pentru : impartire semnal audio - material exterior: PVC, plastic - culoare : alb - material conectori : nichel - conector tip 1 : 1 x jack 3.5 mm 3 pin tata stereo - conector tip 2 : 2 x jack 3.5 mm 3 pin mama stereo - exemplu aplicatie : casti cu amplificator pe un singur cablu - lungime cablu : 10 cm - greutate produs : 15 g - dimensiuni cu ambalaj : 235 x 130 x 10 mm - greutate colet : 21 g 	'1':212B,213B '10':24A,245B,258B '130':256B '15':249B '2':12A,35B,40B,190B,224B,225B '21':262B '235':254B '3':8A,17A,218B,230B '3.5':6A,15A,45B,60B,186B,193B,216B,228B '40993':21A 'acelasi':103B 'adaptor':2A,27B,182B 'adaptorul':141B 'alb':26A,206B 'alt':134B 'ambalaj':253B 'amplif':238B 'amplificatoar':72B 'aplicati':235B 'asigurati':95B 'asigurati-va':94B 'asteptaril':168B 'au':32B,171B 'audio':3A,28B,37B,84B,91B,118B,130B,140B,142B,161B,176B,183B,200B 'buna':149B,153B,177B 'ca':97B 'cablu':23A,53B,78B,242B,244B 'calit':175B 'care':31B,170B 'casti':83B,236B 'castil':70B,100B 'cele':114B 'celor':169B 'cm':25A,246B 'colet':261B 'conector':55B,210B,222B 'conectori':208B 'configuratii':67B 'cu':22A,54B,71B,74B,105B,237B,252B 'culoar':205B 'cum':68B,119B 'de':34B,44B,59B,64B,85B,92B,102B,136B,146B,173B 'definit':145B 'deosebit':63B 'destinat':196B 'dimensiuni':251B 'dispozit':117B,137B 'dispozitiv':89B 'doua':82B 'est':144B 'exemplu':234B 'exterior':202B 'fara':107B 'fluxuri':36B 'folosind':39B 'g':250B,263B 'greutat':247B,260B 'impartir':198B 'includ':111B 'intermediul':50B 'jack':5A,14A,43B,58B,185B,192B,215B,227B 'la':11A,86B,155B,162B,189B 'lanberg':20A,143B 'laptopuri':127B 'lungim':243B 'mai':115B,158B 'mama':19A,47B,195B,232B 'materi':201B,207B 'microfon':108B 'mini':42B,57B 'mm':7A,16A,46B,61B,187B,194B,217B,229B,259B 'mult':116B 'multimedia':132B 'nevoi':33B,172B 'nichel':209B 'notebook':125B 'notebook-uri':124B 'o':147B,152B,174B 'origin':164B 'pc':122B 'pc-uri':121B 'pe':239B 'pentru':29B,66B,113B,197B 'periferic':139B 'perturbatii':160B 'pin':219B,231B 'pini':9A,18A 'plastic':204B 'player':131B 'porturi':41B 'prin':49B 'produs':180B,248B 'produsul':165B 'putin':159B 'pvc':203B 'redar':93B 'rezistenta':154B 'sale':110B 'satisfac':167B 'sau':79B,106B 'semnal':199B 'semnalul':163B 'semnalului':151B 'separ':38B 'si':99B,133B,138B,157B 'singur':52B,77B,88B,241B 'specificatii':178B 'splitter':1A,181B 'stereo':4A,48B,56B,73B,184B,221B,233B 'sunt':69B,101B,120B 'suport':112B 'sursa':90B,98B 'tata':10A,62B,188B,220B 'televizoar':128B 'tip':104B,179B,211B,223B 'tipuri':135B 'transmisi':148B 'turnuri':129B 'un':87B,240B 'unui':51B,76B 'uri':123B,126B 'util':65B 'utilizarea':75B,80B 'utilizaril':109B 'utilizatorii':30B 'va':96B,166B 'x':13A,191B,214B,226B,255B,257B 'zgomot':156B
22	Convertor audio digital - analogic, Cablexpert 08257, cu alimentator 5V DC inclus, negru		2021-02-10	2021-02-10 04:59:21.168738+00	34	t	2			f	\N	{"blocks": [{"key": "4j8cv", "data": {}, "text": "Permite utilizarea dispozitivelor audio digitale cu receptoare sau amplificatoare audio analogice.", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "7o59l", "data": {}, "text": "", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "2u2ts", "data": {}, "text": "Converteste un semnal audio digital Coaxial sau Toslink in audio stereo analog (L / R)", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "e5b0b", "data": {}, "text": "", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "bqfca", "data": {}, "text": "Conectori standard de iesire audio RCA (cinch).", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "3rjjm", "data": {}, "text": "", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "6ni95", "data": {}, "text": "Transmisie electromagnetica fara zgomot.", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "eoaav", "data": {}, "text": "", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "9t33m", "data": {}, "text": "Alimentare de curent continuu 5V DC inclusa.", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "6vehq", "data": {}, "text": "", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "brptk", "data": {}, "text": "Specificatii:", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "8c8j", "data": {}, "text": "- tip produs : Convertor audio digital - analogic", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "84iaq", "data": {}, "text": "- destinat pentru : semnal audio, sunet", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "7vvc5", "data": {}, "text": "- Formate audio de intrare : rata de esantionare (sampling rate) la 32, 44.1 , 48 si 96 KHz, 24-bit S/PDIF flux pe canalele stanga si dreapta", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "7u79f", "data": {}, "text": "- Porturi intrare : 1 x RCA (Coaxial) ; 1 x Toslink", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "3qi98", "data": {}, "text": "- Porturi iesire : 2 x RCA audio (L / R)", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "d6hkp", "data": {}, "text": "- Alimentare : 5V DC pana la 2A", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "cor3i", "data": {}, "text": "- Consum de energie: 0,5 W maxim", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "e3fch", "data": {}, "text": "- Temperatura de operare : 0 - 70 grade C", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "2192s", "data": {}, "text": "- dimensiuni produs : 51 x 41 x 26 mm", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "f2s52", "data": {}, "text": "- greutate produs : 78 g", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "1odqf", "data": {}, "text": "- dimensiuni cu ambalaj : 180 x 100 x 30 mm", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}], "entityMap": {}}	{}	{}	0.000	RON	convertor-audio-digital-analogic-cablexpert-08257-cu-alimentator-5v-dc-inclus-negru	\N	t	\N	Permite utilizarea dispozitivelor audio digitale cu receptoare sau amplificatoare audio analogice. Converteste un semnal audio digital Coaxial sau Toslink in audio stereo analog (L / R) Conectori standard de iesire audio RCA (cinch). Transmisie electromagnetica fara zgomot. Alimentare de curent continuu 5V DC inclusa. Specificatii: - tip produs : Convertor audio digital - analogic - destinat pentru : semnal audio, sunet - Formate audio de intrare : rata de esantionare (sampling rate) la 32, 44.1 , 48 si 96 KHz, 24-bit S/PDIF flux pe canalele stanga si dreapta - Porturi intrare : 1 x RCA (Coaxial) ; 1 x Toslink - Porturi iesire : 2 x RCA audio (L / R) - Alimentare : 5V DC pana la 2A - Consum de energie: 0,5 W maxim - Temperatura de operare : 0 - 70 grade C - dimensiuni produs : 51 x 41 x 26 mm - greutate produs : 78 g - dimensiuni cu ambalaj : 180 x 100 x 30 mm 	'0':119B,126B '08257':6A '1':95B,99B '100':147B '180':145B '2':104B '24':84B '26':136B '2a':115B '30':149B '32':78B '41':134B '44.1':79B '48':80B '5':120B '51':132B '5v':9A,53B,111B '70':127B '78':140B '96':82B 'aliment':8A 'alimentar':49B,110B 'ambalaj':144B 'amplificatoar':21B 'analog':4A,35B,62B 'analogic':23B 'audio':2A,16B,22B,27B,33B,42B,60B,66B,69B,107B 'bit':85B 'c':129B 'cablexpert':5A 'canalel':89B 'cinch':44B 'coaxial':29B,98B 'conectori':38B 'consum':116B 'continuu':52B 'convertest':24B 'convertor':1A,59B 'cu':7A,18B,143B 'curent':51B 'dc':10A,54B,112B 'de':40B,50B,70B,73B,117B,124B 'destinat':63B 'digit':3A,28B,61B 'digital':17B 'dimensiuni':130B,142B 'dispozitivelor':15B 'dreapta':92B 'electromagnetica':46B 'energi':118B 'esantionar':74B 'fara':47B 'flux':87B 'format':68B 'g':141B 'grade':128B 'greutat':138B 'iesir':41B,103B 'inclus':11A 'inclusa':55B 'intrar':71B,94B 'khz':83B 'l':36B,108B 'la':77B,114B 'maxim':122B 'mm':137B,150B 'negru':12A 'operar':125B 'pana':113B 'pe':88B 'pentru':64B 'permit':13B 'porturi':93B,102B 'produs':58B,131B,139B 'r':37B,109B 'rata':72B 'rate':76B 'rca':43B,97B,106B 'receptoar':19B 's/pdif':86B 'sampl':75B 'sau':20B,30B 'semnal':26B,65B 'si':81B,91B 'specificatii':56B 'standard':39B 'stanga':90B 'stereo':34B 'sunet':67B 'temperatura':123B 'tip':57B 'toslink':31B,101B 'transmisi':45B 'un':25B 'utilizarea':14B 'w':121B 'x':96B,100B,105B,133B,135B,146B,148B 'zgomot':48B
19	Adaptor audio Jack 3.5 mm tata 4 pini la 2 x Jack 3.5 mm 3 pini mama, Lanberg 40991, cu cablu 20 cm, negru		2021-02-10	2021-03-14 19:59:01.509947+00	32	t	2			f	\N	{"blocks": [{"key": "akfp", "data": {}, "text": " Adaptor audio pentru utilizatorii care necesita 2 fluxuri audio separate. Permite utilizarea a 2 prize mini-jack de 3.5 mm mama prin intermediul unui conector jack de 3.5 mm tata mini-jack.", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "8d9d9", "data": {}, "text": "Deosebit de util pentru utilizarea castilor si a microfonului intr-un singur cablu cu un singur conector jack de 3.5mm.", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "bssib", "data": {}, "text": "", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "4vut", "data": {}, "text": "Potrivit pentru majoritatea dispozitivelor audio, cum ar fi PC-uri, smartphone-uri, notebook-uri, laptop-uri, turnuri audio, televizoare, media playere, proiectoare si alte dispozitive electronice media audio.", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "1np9n", "data": {}, "text": "", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "18sk0", "data": {}, "text": "Adaptorul audio Lanberg este definit de o transmisie buna a semnalului, o buna rezistenta la zgomot si mai putine perturbatii audio la semnalul original. Solutiile Lanberg pentru cabluri si adaptoare audio satisfac chiar si asteptarile ridicate ale profesionistilor, avand o calitate audio ridicata.", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "c910v", "data": {}, "text": "", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "8qkqc", "data": {}, "text": "Specificatii:", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "fhg9j", "data": {}, "text": "- tip produs : Adaptor audio mini-jack 3.5mm 4 pini tata la 2 x mini-jack 3.5 mm 3 pini mama, cu cablu", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "ef2in", "data": {}, "text": "- destinat pentru : casti, microfoane, boxe si alte aplicatii cu semnal audio", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "8v8i1", "data": {}, "text": "- material invelis exterior : PVC, plastic", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "5hacu", "data": {}, "text": "- culoare : negru", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "6hrv5", "data": {}, "text": "- conector tip 1 : 1 x jack 3.5 mm 4 pini tata", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "f755r", "data": {}, "text": "- conector tip 2 : 2 x jack 3.5 mm 3 pini mama ( rosu si verde)", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "3jtqj", "data": {}, "text": "- material conector : nichel", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "esj60", "data": {}, "text": "- exemplu aplicatie : utilizarea castilor si a microfonului pe o conexiune", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "e8cn", "data": {}, "text": "- lungime cablu : 20 cm", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "8bd74", "data": {}, "text": "- greutate produs : 17 g", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "cs5a2", "data": {}, "text": "- dimensiuni cu ambalaj : 240 x 130 x 10 mm", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "4njjk", "data": {}, "text": "- greutate colet : 23 g", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "8d0v1", "data": {}, "text": "", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}], "entityMap": {}}	{}	{}	10.000	RON	adaptor-audio-jack-35-mm-tata-4-pini-la-2-x-jack-35-mm-3-pini-mama-lanberg-40991-cu-cablu-20-cm-negru	\N	t	19	 Adaptor audio pentru utilizatorii care necesita 2 fluxuri audio separate. Permite utilizarea a 2 prize mini-jack de 3.5 mm mama prin intermediul unui conector jack de 3.5 mm tata mini-jack. Deosebit de util pentru utilizarea castilor si a microfonului intr-un singur cablu cu un singur conector jack de 3.5mm. Potrivit pentru majoritatea dispozitivelor audio, cum ar fi PC-uri, smartphone-uri, notebook-uri, laptop-uri, turnuri audio, televizoare, media playere, proiectoare si alte dispozitive electronice media audio. Adaptorul audio Lanberg este definit de o transmisie buna a semnalului, o buna rezistenta la zgomot si mai putine perturbatii audio la semnalul original. Solutiile Lanberg pentru cabluri si adaptoare audio satisfac chiar si asteptarile ridicate ale profesionistilor, avand o calitate audio ridicata. Specificatii: - tip produs : Adaptor audio mini-jack 3.5mm 4 pini tata la 2 x mini-jack 3.5 mm 3 pini mama, cu cablu - destinat pentru : casti, microfoane, boxe si alte aplicatii cu semnal audio - material invelis exterior : PVC, plastic - culoare : negru - conector tip 1 : 1 x jack 3.5 mm 4 pini tata - conector tip 2 : 2 x jack 3.5 mm 3 pini mama ( rosu si verde) - material conector : nichel - exemplu aplicatie : utilizarea castilor si a microfonului pe o conexiune - lungime cablu : 20 cm - greutate produs : 17 g - dimensiuni cu ambalaj : 240 x 130 x 10 mm - greutate colet : 23 g 	'1':202B,203B '10':253B '130':251B '17':244B '2':10A,31B,38B,170B,213B,214B '20':22A,240B '23':257B '240':249B '3':15A,177B,219B '3.5':4A,13A,44B,53B,79B,164B,175B,206B,217B '4':7A,166B,208B '40991':19A 'adaptoar':142B 'adaptor':1A,25B,159B 'adaptorul':113B 'ale':149B 'alt':108B,188B 'ambalaj':248B 'aplicati':229B 'aplicatii':189B 'ar':87B 'asteptaril':147B 'audio':2A,26B,33B,85B,102B,112B,114B,133B,143B,154B,160B,192B 'avand':151B 'box':186B 'buna':121B,125B 'cablu':21A,72B,181B,239B 'cabluri':140B 'calit':153B 'care':29B 'casti':184B 'castilor':64B,231B 'chiar':145B 'cm':23A,241B 'colet':256B 'conector':50B,76B,200B,211B,226B 'conexiun':237B 'cu':20A,73B,180B,190B,247B 'culoar':198B 'cum':86B 'de':43B,52B,60B,78B,118B 'definit':117B 'deosebit':59B 'destinat':182B 'dimensiuni':246B 'dispozit':109B 'dispozitivelor':84B 'electronic':110B 'est':116B 'exemplu':228B 'exterior':195B 'fi':88B 'fluxuri':32B 'g':245B,258B 'greutat':242B,255B 'intermediul':48B 'intr':69B 'intr-un':68B 'inv':194B 'jack':3A,12A,42B,51B,58B,77B,163B,174B,205B,216B 'la':9A,127B,134B,169B 'lanberg':18A,115B,138B 'laptop':99B 'laptop-uri':98B 'lungim':238B 'mai':130B 'majoritatea':83B 'mama':17A,46B,179B,221B 'materi':193B,225B 'media':104B,111B 'microfoan':185B 'microfonului':67B,234B 'mini':41B,57B,162B,173B 'mini-jack':40B,56B,161B,172B 'mm':5A,14A,45B,54B,80B,165B,176B,207B,218B,254B 'necesita':30B 'negru':24A,199B 'nichel':227B 'notebook':96B 'notebook-uri':95B 'o':119B,124B,152B,236B 'origin':136B 'pc':90B 'pc-uri':89B 'pe':235B 'pentru':27B,62B,82B,139B,183B 'permit':35B 'perturbatii':132B 'pini':8A,16A,167B,178B,209B,220B 'plastic':197B 'player':105B 'potrivit':81B 'prin':47B 'prize':39B 'produs':158B,243B 'profesionistilor':150B 'proiectoar':106B 'putin':131B 'pvc':196B 'rezistenta':126B 'ridic':148B 'ridicata':155B 'rosu':222B 'satisfac':144B 'semnal':191B 'semnalul':135B 'semnalului':123B 'separ':34B 'si':65B,107B,129B,141B,146B,187B,223B,232B 'singur':71B,75B 'smartphon':93B 'smartphone-uri':92B 'solutiil':137B 'specificatii':156B 'tata':6A,55B,168B,210B 'televizoar':103B 'tip':157B,201B,212B 'transmisi':120B 'turnuri':101B 'un':70B,74B 'unui':49B 'uri':91B,94B,97B,100B 'util':61B 'utilizarea':36B,63B,230B 'utilizatorii':28B 'verd':224B 'x':11A,171B,204B,215B,250B,252B 'zgomot':128B
24	Cablu adaptor Tip C la jack 3.5mm,AC10TC,alb		2021-02-10	2021-02-10 05:08:13.999125+00	32	t	2			f	\N	{"blocks": [{"key": "7ur0n", "data": {}, "text": "Cablu adaptor Tip C la jack 3.5mm cu lungime de 60mm. Permite folosirea dispozitivelor cu conector jack 3.5mm la dispozitivele cu conector Tip C (de exemplu : casti, boxe, mp3/mp4 player).", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}], "entityMap": {}}	{}	{}	0.000	RON	cablu-adaptor-tip-c-la-jack-35mmac10tcalb	\N	t	24	Cablu adaptor Tip C la jack 3.5mm cu lungime de 60mm. Permite folosirea dispozitivelor cu conector jack 3.5mm la dispozitivele cu conector Tip C (de exemplu : casti, boxe, mp3/mp4 player). 	'3.5':7A,17B,29B '60mm':22B 'ac10tc':9A 'adaptor':2A,12B 'alb':10A 'box':40B 'c':4A,14B,36B 'cablu':1A,11B 'casti':39B 'conector':27B,34B 'cu':19B,26B,33B 'de':21B,37B 'dispozitivel':32B 'dispozitivelor':25B 'exemplu':38B 'folosirea':24B 'jack':6A,16B,28B 'la':5A,15B,31B 'lungim':20B 'mm':8A,18B,30B 'mp3/mp4':41B 'permit':23B 'player':42B 'tip':3A,13B,35B
25	Cablu audio-video, Lanberg 41337, conectori DisplayPort (DP) tata la DisplayPort (DP) tata, lungime 1.8m, rezolutie 4K, negru		2021-02-10	2021-02-10 05:23:08.473313+00	42	t	3			f	\N	{"blocks": [{"key": "1muih", "data": {}, "text": "Asigura transmisia audiovizuala intre dispozitive multimedia, cum ar fi PC-uri, laptop-uri, monitoare, televizoare, servere, NAS , proiectoare , console de jocuri si multe altele, prevazute cu conectori DisplayPort (DP).", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "5b6sh", "data": {}, "text": " Cablul ofera o calitate a imaginii si a sunetului transmis, precum si performante deosebite. Acesta ofera transmisii neintrerupte si de inalta calitate la vizionarea emisiunilor si filmelor TV preferate, la jocuri online sau la proiecte importante de prezentari corporative. ", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "feta6", "data": {}, "text": " Aceasta solutie de cablare ofera cea mai inalta rezolutie de 4K si o experienta de vizionare de neuitat, pastrand in acelasi timp o adancime ridicata a calitatii imaginii si oferind utilizatorilor un continut de calitate.", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "9nhn", "data": {}, "text": "  Utilizarea materialelor de cea mai inalta calitate in cadrul procesului de fabricatie asigura utilizarea sa timp indelungat. ", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "d2nvk", "data": {}, "text": " Caracteristici:", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": [{"style": "BOLD", "length": 14, "offset": 1}]}, {"key": "5v3ta", "data": {}, "text": "2 conectori DisplayPort tata; ", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "bf4cm", "data": {}, "text": "rezolutie maxima 4K; ", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "1fvth", "data": {}, "text": "adancimea de culoare acceptata 8, 10; ", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "8b1uo", "data": {}, "text": "suporta DPCP, HDCP, 12bpc, 36bpp; ", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "cjf98", "data": {}, "text": "viteza de reamprospatare 120 MHz; ", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "5dkd0", "data": {}, "text": "capacitate de transmisie 17.28 Gbps; AWG 32 CU; ", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "2eqi5", "data": {}, "text": "material de izolatie LD-PE; ", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "8gf05", "data": {}, "text": "constructie cablu: 5 perechi, 4C, sarma la sol, folie de protectie, PVC;", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "2o46f", "data": {}, "text": " diametrul jachetei din PVC 5.8mm; ", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "sn3r", "data": {}, "text": "numarul de pini 20; ", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "3f0c", "data": {}, "text": "contacte aurite; ", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "9du63", "data": {}, "text": "rezistenta dielectrica DC 300V/1s; ", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "egq9q", "data": {}, "text": "rezistenta la contact 10Ohm;", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "b5l23", "data": {}, "text": " rezistenta la izolare >= 5m Om; ", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "6b232", "data": {}, "text": "lungime cablu 180cm; ", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "4lvd1", "data": {}, "text": "dimensiuni ambalaj 255x190x25mm; ", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "6biq6", "data": {}, "text": "greutate colet 100g.", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}], "entityMap": {}}	{}	{}	0.000	RON	cablu-audio-video-lanberg-41337-conectori-displayport-dp-tata-la-displayport-dp-tata-lungime-18m-rezolutie-4k-negru	\N	t	\N	Asigura transmisia audiovizuala intre dispozitive multimedia, cum ar fi PC-uri, laptop-uri, monitoare, televizoare, servere, NAS , proiectoare , console de jocuri si multe altele, prevazute cu conectori DisplayPort (DP).  Cablul ofera o calitate a imaginii si a sunetului transmis, precum si performante deosebite. Acesta ofera transmisii neintrerupte si de inalta calitate la vizionarea emisiunilor si filmelor TV preferate, la jocuri online sau la proiecte importante de prezentari corporative.   Aceasta solutie de cablare ofera cea mai inalta rezolutie de 4K si o experienta de vizionare de neuitat, pastrand in acelasi timp o adancime ridicata a calitatii imaginii si oferind utilizatorilor un continut de calitate.   Utilizarea materialelor de cea mai inalta calitate in cadrul procesului de fabricatie asigura utilizarea sa timp indelungat.   Caracteristici: 2 conectori DisplayPort tata;  rezolutie maxima 4K;  adancimea de culoare acceptata 8, 10;  suporta DPCP, HDCP, 12bpc, 36bpp;  viteza de reamprospatare 120 MHz;  capacitate de transmisie 17.28 Gbps; AWG 32 CU;  material de izolatie LD-PE;  constructie cablu: 5 perechi, 4C, sarma la sol, folie de protectie, PVC;  diametrul jachetei din PVC 5.8mm;  numarul de pini 20;  contacte aurite;  rezistenta dielectrica DC 300V/1s;  rezistenta la contact 10Ohm;  rezistenta la izolare >= 5m Om;  lungime cablu 180cm;  dimensiuni ambalaj 255x190x25mm;  greutate colet 100g. 	'1.8':16A '10':156B '100g':226B '10ohm':212B '120':165B '12bpc':160B '17.28':170B '180cm':220B '2':144B '20':202B '255x190x25mm':223B '300v/1s':208B '32':173B '36bpp':161B '41337':6A '4c':185B '4k':19A,101B,150B '5':183B '5.8':197B '5m':216B '8':155B 'acceptata':154B 'aceasta':91B 'acelasi':111B 'acesta':66B 'adancim':114B 'adancimea':151B 'altel':46B 'ambalaj':222B 'ar':28B 'asigura':21B,138B 'audio':3A 'audio-video':2A 'audiovizuala':23B 'aurit':204B 'awg':172B 'cablar':94B 'cablu':1A,182B,219B 'cablul':52B 'cadrul':134B 'calit':55B,73B,125B,132B 'calitatii':117B 'capacit':167B 'caracteristici':143B 'cea':96B,129B 'colet':225B 'conectori':7A,49B,145B 'consol':41B 'constructi':181B 'contact':203B,211B 'continut':123B 'corpor':90B 'cu':48B,174B 'culoar':153B 'cum':27B 'dc':207B 'de':42B,71B,88B,93B,100B,105B,107B,124B,128B,136B,152B,163B,168B,176B,190B,200B 'deosebit':65B 'diametrul':193B 'dielectrica':206B 'dimensiuni':221B 'din':195B 'displayport':8A,12A,50B,146B 'dispozit':25B 'dp':9A,13A,51B 'dpcp':158B 'emisiunilor':76B 'experienta':104B 'fabricati':137B 'fi':29B 'filmelor':78B 'foli':189B 'gbps':171B 'greutat':224B 'hdcp':159B 'imaginii':57B,118B 'important':87B 'inalta':72B,98B,131B 'indelungat':142B 'intr':24B 'izolar':215B 'izolati':177B 'jachetei':194B 'jocuri':43B,82B 'la':11A,74B,81B,85B,187B,210B,214B 'lanberg':5A 'laptop':34B 'laptop-uri':33B 'ld':179B 'ld-pe':178B 'lungim':15A,218B 'm':17A 'mai':97B,130B 'materi':175B 'materialelor':127B 'maxima':149B 'mhz':166B 'mm':198B 'monitoar':36B 'mult':45B 'multimedia':26B 'nas':39B 'negru':20A 'neintrerupt':69B 'neuitat':108B 'numarul':199B 'o':54B,103B,113B 'ofera':53B,67B,95B 'oferind':120B 'om':217B 'onlin':83B 'pastrand':109B 'pc':31B 'pc-uri':30B 'pe':180B 'perechi':184B 'performant':64B 'pini':201B 'precum':62B 'prefer':80B 'prevazut':47B 'prezentari':89B 'procesului':135B 'proiect':86B 'proiectoar':40B 'protecti':191B 'pvc':192B,196B 'reamprospatar':164B 'rezistenta':205B,209B,213B 'rezoluti':18A,99B,148B 'ridicata':115B 'sa':140B 'sarma':186B 'sau':84B 'server':38B 'si':44B,58B,63B,70B,77B,102B,119B 'sol':188B 'soluti':92B 'sunetului':60B 'suporta':157B 'tata':10A,14A,147B 'televizoar':37B 'timp':112B,141B 'transmi':61B 'transmisi':169B 'transmisia':22B 'transmisii':68B 'tv':79B 'un':122B 'uri':32B,35B 'utilizarea':126B,139B 'utilizatorilor':121B 'video':4A 'viteza':162B 'vizionar':106B 'vizionarea':75B
26	Cablu premium DisplayPort tata la DisplayPort tata v.1.4, Lanberg 42898, 1m, 8K 60Hz, HDR, DSC 1.2, negru		2021-02-10	2021-02-10 05:26:38.797504+00	42	t	3			f	\N	{"blocks": [{"key": "fh1hn", "data": {}, "text": " Cablu DisplayPort 1.4 cu rezolutie video maxima de pana la 8K (7680x4320), cu suport pentru latime de banda mare HBR3, latime de banda de 32.4 Gbps, compresie a fluxului de afisaj DSC 1.2, corectarea erorilor FEC si 32 de canale audio.", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}], "entityMap": {}}	{}	{}	0.000	RON	cablu-premium-displayport-tata-la-displayport-tata-v14-lanberg-42898-1m-8k-60hz-hdr-dsc-12-negru	\N	t	\N	 Cablu DisplayPort 1.4 cu rezolutie video maxima de pana la 8K (7680x4320), cu suport pentru latime de banda mare HBR3, latime de banda de 32.4 Gbps, compresie a fluxului de afisaj DSC 1.2, corectarea erorilor FEC si 32 de canale audio. 	'1.2':16A,50B '1.4':20B '1m':11A '32':55B '32.4':42B '42898':10A '60hz':13A '7680x4320':29B '8k':12A,28B 'afisaj':48B 'audio':58B 'banda':35B,40B 'cablu':1A,18B 'canal':57B 'compresi':44B 'corectarea':51B 'cu':21B,30B 'de':25B,34B,39B,41B,47B,56B 'displayport':3A,6A,19B 'dsc':15A,49B 'erorilor':52B 'fec':53B 'fluxului':46B 'gbps':43B 'hbr3':37B 'hdr':14A 'la':5A,27B 'lanberg':9A 'latim':33B,38B 'mare':36B 'maxima':24B 'negru':17A 'pana':26B 'pentru':32B 'premium':2A 'rezoluti':22B 'si':54B 'suport':31B 'tata':4A,7A 'v.1.4':8A 'video':23B
27	Cablu Lanberg 41340, DVI-D (18+1) Single Link tata la DVI-D (18+1) Single Link tata, 1.8m, rezolutie 1440p QHD		2021-02-10	2021-02-10 05:31:28.462416+00	42	t	3			f	\N	{"blocks": [{"key": "c6c95", "data": {}, "text": " Cablul Single-Link DVI 18+1 este solutia ideala pentru transmisia audiovizuala intre dispozitive multimedia, cum ar fi PC-uri, laptop-uri, monitoare, televizoare, servere, NAS , proiectoare, console de jocuri si multe altele. ", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "786i2", "data": {}, "text": " Datorita celor 2 conectori de inalta calitate este posibila conectarea oricarui dispozitiv care accepta conexiune DVI Single-Link. ", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "4lhid", "data": {}, "text": " Cablul ofera o calitate a imaginii si a sunetului transmis, precum si performante deosebite. Acesta ofera transmisii neintrerupte si de inalta calitate la vizionarea emisiunilor si filmelor TV preferate, la jocuri online sau la proiecte importante de prezentari corporative. ", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "ek20p", "data": {}, "text": " Aceasta solutie de cablare ofera o rezolutie de 1440p QHD, depasind experienta vizuala Full HD si o experienta de vizionare de neuitat, pastrand in acelasi timp o adancime ridicata a calitatii imaginii si oferind utilizatorilor un continut de calitate. ", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "pgn3", "data": {}, "text": " Utilizarea materialelor de cea mai inalta calitate in cadrul procesului de fabricatie asigura utilizarea sa timp indelungat. ", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "cs6ku", "data": {}, "text": " Specificatii: ", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "ahe5a", "data": {}, "text": " 2 conectori DVI cu 18+1 pini auriti, un singur link, tata ;", "type": "unordered-list-item", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "5u42c", "data": {}, "text": " rezolutie maxima 1440p QHD; ", "type": "unordered-list-item", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "813hg", "data": {}, "text": "suport de latime de banda de 16.9 Gbps; ", "type": "unordered-list-item", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "2n89f", "data": {}, "text": "AWG 30 CU; material izolatie LD-PE; 2 buc Ferrita din ABS; ", "type": "unordered-list-item", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "fvn6o", "data": {}, "text": "constructia cablurilor: 5 perechi, 4C, conductor de impamantare, straturi de film de protectie, PVC; ", "type": "unordered-list-item", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "btm5o", "data": {}, "text": "lungime cablu 180cm; ", "type": "unordered-list-item", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "504ck", "data": {}, "text": "diametrul invelisului din PVC 7.18mm; ", "type": "unordered-list-item", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "2aujp", "data": {}, "text": "dimensiune conector 55x40x16mm; ", "type": "unordered-list-item", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "2c83c", "data": {}, "text": "dimensiuni ambalaj 230x180x25mm; ", "type": "unordered-list-item", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "f41j5", "data": {}, "text": "greutate colet 229g.", "type": "unordered-list-item", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}], "entityMap": {}}	{}	{}	0.000	RON	cablu-lanberg-41340-dvi-d-181-single-link-tata-la-dvi-d-181-single-link-tata-18m-rezolutie-1440p-qhd	\N	t	\N	 Cablul Single-Link DVI 18+1 este solutia ideala pentru transmisia audiovizuala intre dispozitive multimedia, cum ar fi PC-uri, laptop-uri, monitoare, televizoare, servere, NAS , proiectoare, console de jocuri si multe altele.   Datorita celor 2 conectori de inalta calitate este posibila conectarea oricarui dispozitiv care accepta conexiune DVI Single-Link.   Cablul ofera o calitate a imaginii si a sunetului transmis, precum si performante deosebite. Acesta ofera transmisii neintrerupte si de inalta calitate la vizionarea emisiunilor si filmelor TV preferate, la jocuri online sau la proiecte importante de prezentari corporative.   Aceasta solutie de cablare ofera o rezolutie de 1440p QHD, depasind experienta vizuala Full HD si o experienta de vizionare de neuitat, pastrand in acelasi timp o adancime ridicata a calitatii imaginii si oferind utilizatorilor un continut de calitate.   Utilizarea materialelor de cea mai inalta calitate in cadrul procesului de fabricatie asigura utilizarea sa timp indelungat.   Specificatii:   2 conectori DVI cu 18+1 pini auriti, un singur link, tata ;  rezolutie maxima 1440p QHD;  suport de latime de banda de 16.9 Gbps;  AWG 30 CU; material izolatie LD-PE; 2 buc Ferrita din ABS;  constructia cablurilor: 5 perechi, 4C, conductor de impamantare, straturi de film de protectie, PVC;  lungime cablu 180cm;  diametrul invelisului din PVC 7.18mm;  dimensiune conector 55x40x16mm;  dimensiuni ambalaj 230x180x25mm;  greutate colet 229g. 	'+1':8A,17A,32B,182B '1.8':21A '1440p':24A,128B,191B '16.9':199B '18':7A,16A,31B,181B '180cm':230B '2':64B,177B,209B '229g':245B '230x180x25mm':242B '30':202B '41340':3A '4c':218B '5':216B '55x40x16mm':239B '7.18':235B 'ab':213B 'accepta':75B 'aceasta':120B 'acelasi':144B 'acesta':95B 'adancim':147B 'altel':61B 'ambalaj':241B 'ar':43B 'asigura':171B 'audiovizuala':38B 'auriti':184B 'awg':201B 'banda':197B 'buc':210B 'cablar':123B 'cablu':1A,229B 'cablul':26B,81B 'cablurilor':215B 'cadrul':167B 'calit':68B,84B,102B,158B,165B 'calitatii':150B 'care':74B 'cea':162B 'celor':63B 'colet':244B 'conductor':219B 'conectarea':71B 'conector':238B 'conectori':65B,178B 'conexiun':76B 'consol':56B 'constructia':214B 'continut':156B 'corpor':119B 'cu':180B,203B 'cum':42B 'd':6A,15A 'datorita':62B 'de':57B,66B,100B,117B,122B,127B,138B,140B,157B,161B,169B,194B,196B,198B,220B,223B,225B 'deosebit':94B 'depasind':130B 'diametrul':231B 'dimensiun':237B 'dimensiuni':240B 'din':212B,233B 'dispozit':40B 'dispozitiv':73B 'dvi':5A,14A,30B,77B,179B 'dvi-d':4A,13A 'emisiunilor':105B 'est':33B,69B 'experienta':131B,137B 'fabricati':170B 'ferrita':211B 'fi':44B 'film':224B 'filmelor':107B 'full':133B 'gbps':200B 'greutat':243B 'hd':134B 'ideala':35B 'imaginii':86B,151B 'impamantar':221B 'important':116B 'inalta':67B,101B,164B 'indelungat':175B 'intr':39B 'invelisului':232B 'izolati':205B 'jocuri':58B,111B 'la':12A,103B,110B,114B 'lanberg':2A 'laptop':49B 'laptop-uri':48B 'latim':195B 'ld':207B 'ld-pe':206B 'link':10A,19A,29B,80B,187B 'lungim':228B 'm':22A 'mai':163B 'materi':204B 'materialelor':160B 'maxima':190B 'mm':236B 'monitoar':51B 'mult':60B 'multimedia':41B 'nas':54B 'neintrerupt':98B 'neuitat':141B 'o':83B,125B,136B,146B 'ofera':82B,96B,124B 'oferind':153B 'onlin':112B 'oricarui':72B 'pastrand':142B 'pc':46B 'pc-uri':45B 'pe':208B 'pentru':36B 'perechi':217B 'performant':93B 'pini':183B 'posibila':70B 'precum':91B 'prefer':109B 'prezentari':118B 'procesului':168B 'proiect':115B 'proiectoar':55B 'protecti':226B 'pvc':227B,234B 'qhd':25A,129B,192B 'rezoluti':23A,126B,189B 'ridicata':148B 'sa':173B 'sau':113B 'server':53B 'si':59B,87B,92B,99B,106B,135B,152B 'singl':9A,18A,28B,79B 'single-link':27B,78B 'singur':186B 'soluti':121B 'solutia':34B 'specificatii':176B 'straturi':222B 'sunetului':89B 'suport':193B 'tata':11A,20A,188B 'televizoar':52B 'timp':145B,174B 'transmi':90B 'transmisia':37B 'transmisii':97B 'tv':108B 'un':155B,185B 'uri':47B,50B 'utilizarea':159B,172B 'utilizatorilor':154B 'vizionar':139B 'vizionarea':104B 'vizuala':132B
28	Cablu Lanberg 40275, conector HDMI tata la DVI-D tata (18+1), 1.8m , single link, transmisie digitala, negru		2021-02-10	2021-02-10 05:37:08.39289+00	42	t	3			f	\N	{"blocks": [{"key": "fkts2", "data": {}, "text": " Cablu HDMI - DVI de inalta calitate, cu conectori placati cu aur, pentru transmisia digitala a datelor intre dispozitive cu iesire DVI si dispozitive cu port HDMI. ", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "ar6vo", "data": {}, "text": "Caracteristici: ", "type": "unordered-list-item", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "7gr5a", "data": {}, "text": "conector HDMI tata; ", "type": "unordered-list-item", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "27h6n", "data": {}, "text": "conector DVI-D tata (18+1 pini); ", "type": "unordered-list-item", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "292i6", "data": {}, "text": "lungime cablu 180cm; ", "type": "unordered-list-item", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "4ovac", "data": {}, "text": "dimensiuni produs 240x120x20mm; ", "type": "unordered-list-item", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "b76gv", "data": {}, "text": "greutate produs 115g.", "type": "unordered-list-item", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}], "entityMap": {}}	{}	{}	0.000	RON	cablu-lanberg-40275-conector-hdmi-tata-la-dvi-d-tata-181-18m-single-link-transmisie-digitala-negru	\N	t	\N	 Cablu HDMI - DVI de inalta calitate, cu conectori placati cu aur, pentru transmisia digitala a datelor intre dispozitive cu iesire DVI si dispozitive cu port HDMI.  Caracteristici:  conector HDMI tata;  conector DVI-D tata (18+1 pini);  lungime cablu 180cm;  dimensiuni produs 240x120x20mm;  greutate produs 115g. 	'+1':13A,57B '1.8':14A '115g':67B '18':12A,56B '180cm':61B '240x120x20mm':64B '40275':3A 'aur':31B 'cablu':1A,21B,60B 'calit':26B 'caracteristici':47B 'conector':4A,48B,51B 'conectori':28B 'cu':27B,30B,39B,44B 'd':10A,54B 'datelor':36B 'de':24B 'digitala':19A,34B 'dimensiuni':62B 'dispozit':38B,43B 'dvi':9A,23B,41B,53B 'dvi-d':8A,52B 'greutat':65B 'hdmi':5A,22B,46B,49B 'iesir':40B 'inalta':25B 'intr':37B 'la':7A 'lanberg':2A 'link':17A 'lungim':59B 'm':15A 'negru':20A 'pentru':32B 'pini':58B 'placati':29B 'port':45B 'produs':63B,66B 'si':42B 'singl':16A 'tata':6A,11A,50B,55B 'transmisi':18A 'transmisia':33B
23	Adaptor caseta audio cu AUX jack 3.5mm, portabil, negru		2021-02-10	2021-03-14 20:12:39.546242+00	32	t	2			f	\N	{"blocks": [{"key": "cnck2", "data": {}, "text": "Adaptor caseta audio , pentru conectarea unui player audio la un player cu compartiment pentru caseta audio.", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "1u2nc", "data": {}, "text": "Specificatii:", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "djpv8", "data": {}, "text": " - conectare la player prin mufa jack de 3.5mm,", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "83rlv", "data": {}, "text": "- lungime cablu 88cm; ", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "6egic", "data": {}, "text": "- greutate caseta 35g; ", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}, {"key": "1g277", "data": {}, "text": "- material plastic de culoare neagra", "type": "unstyled", "depth": 0, "entityRanges": [], "inlineStyleRanges": []}], "entityMap": {}}	{}	{}	5.000	RON	adaptor-caseta-audio-cu-aux-jack-35mm-portabil-negru	\N	t	23	Adaptor caseta audio , pentru conectarea unui player audio la un player cu compartiment pentru caseta audio. Specificatii:  - conectare la player prin mufa jack de 3.5mm, - lungime cablu 88cm;  - greutate caseta 35g;  - material plastic de culoare neagra 	'3.5':7A,35B '35g':42B '88cm':39B 'adaptor':1A,11B 'audio':3A,13B,18B,26B 'aux':5A 'cablu':38B 'caseta':2A,12B,25B,41B 'comparti':23B 'conectar':28B 'conectarea':15B 'cu':4A,22B 'culoar':46B 'de':34B,45B 'greutat':40B 'jack':6A,33B 'la':19B,29B 'lungim':37B 'materi':43B 'mm':8A,36B 'mufa':32B 'neagra':47B 'negru':10A 'pentru':14B,24B 'plastic':44B 'player':17B,21B,30B 'portabil':9A 'prin':31B 'specificatii':27B 'un':20B 'unui':16B
\.


--
-- Data for Name: product_productimage; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.product_productimage (id, image, ppoi, alt, sort_order, product_id) FROM stdin;
46	products/CA-TOSL-10CC-0010-BK_01.jpg	0.5x0.5		0	16
47	products/CA-TOSL-10CC-0010-BK_02.jpg	0.5x0.5		1	16
48	products/CA-TOSL-10CC-0010-BK_03.jpg	0.5x0.5		2	16
49	products/CA-TOSL-10CC-0020-BK_01.jpg	0.5x0.5		0	17
50	products/CA-TOSL-10CC-0020-BK_02.jpg	0.5x0.5		1	17
51	products/CA-TOSL-10CC-0020-BK_03.jpg	0.5x0.5		2	17
52	products/CA-TOSL-10CC-0030-BK_01.jpg	0.5x0.5		0	18
53	products/CA-TOSL-10CC-0030-BK_02.jpg	0.5x0.5		1	18
54	products/CA-TOSL-10CC-0030-BK_03.jpg	0.5x0.5		2	18
55	products/AD-0023-BK_01.jpg	0.5x0.5		0	19
56	products/AD-0023-BK_02.jpg	0.5x0.5		1	19
57	products/AD-0024-BK_01.jpg	0.5x0.5		0	20
58	products/AD-0024-BK_02.jpg	0.5x0.5		1	20
59	products/AD-0024-BK_text1.jpg	0.5x0.5		2	20
60	products/AD-0024-W_01.jpg	0.5x0.5		0	21
61	products/AD-0024-W_02.jpg	0.5x0.5		1	21
62	products/AD-0024-W_text1.jpg	0.5x0.5		2	21
63	products/DSC-OPT-RCA-001_01.jpg	0.5x0.5		0	22
64	products/DSC-OPT-RCA-001_02.jpg	0.5x0.5		1	22
65	products/DSC-OPT-RCA-001_03.jpg	0.5x0.5		2	22
66	products/DSC-OPT-RCA-001_04.jpg	0.5x0.5		3	22
67	products/DSC-OPT-RCA-001_05.jpg	0.5x0.5		4	22
68	products/DSC-OPT-RCA-001_06.jpg	0.5x0.5		5	22
69	products/DSC-OPT-RCA-001_07.jpg	0.5x0.5		6	22
70	products/ACCMP3_01.jpg	0.5x0.5		0	23
71	products/ACCMP3_02.jpg	0.5x0.5		1	23
72	products/AC10TC_01.jpg	0.5x0.5		0	24
73	products/AC10TC_02.jpg	0.5x0.5		1	24
74	products/AC10TC_03.jpg	0.5x0.5		2	24
75	products/CA-DPDP-10CC-0018-BK_01.jpg	0.5x0.5		0	25
76	products/CA-DPDP-10CC-0018-BK_02.jpg	0.5x0.5		1	25
77	products/CA-DPDP-10CC-0018-BK_03.jpg	0.5x0.5		2	25
78	products/CA-DPDP-10CC-0018-BK_04.jpg	0.5x0.5		3	25
79	products/CA-DPDP-10CC-0018-BK_05.jpg	0.5x0.5		4	25
80	products/CA-DPDP-10CC-0018-BK_06.jpg	0.5x0.5		5	25
81	products/CA-DPDP-20CU-0010-BK_01.jpg	0.5x0.5		0	26
82	products/CA-DPDP-20CU-0010-BK_02.jpg	0.5x0.5		1	26
83	products/CA-DPDP-20CU-0010-BK_03.jpg	0.5x0.5		2	26
84	products/CA-DPDP-20CU-0010-BK_text1.jpg	0.5x0.5		3	26
85	products/CA-DPDP-20CU-0010-BK_text2.jpg	0.5x0.5		4	26
86	products/CA-DPDP-20CU-0010-BK_text3.jpg	0.5x0.5		5	26
87	products/CA-DVIS-10CC-0018-BK_01.jpg	0.5x0.5		0	27
88	products/CA-DVIS-10CC-0018-BK_02.jpg	0.5x0.5		1	27
89	products/CA-DVIS-10CC-0018-BK_03.jpg	0.5x0.5		2	27
90	products/CA-DVIS-10CC-0018-BK_04.jpg	0.5x0.5		3	27
91	products/CA-DVIS-10CC-0018-BK_05.jpg	0.5x0.5		4	27
92	products/NSK-0419_01.jpg	0.5x0.5		0	28
93	products/NSK-0419_02.jpg	0.5x0.5		1	28
94	products/NSK-0419_03.jpg	0.5x0.5		2	28
95	products/NSK-0419_04.jpg	0.5x0.5		3	28
96	products/NSK-0419_05.jpg	0.5x0.5		4	28
\.


--
-- Data for Name: product_producttranslation; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.product_producttranslation (id, seo_title, seo_description, language_code, name, description, product_id, description_json) FROM stdin;
\.


--
-- Data for Name: product_producttype; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.product_producttype (id, name, has_variants, is_shipping_required, weight, is_digital, metadata, private_metadata, slug) FROM stdin;
32	Adaptor audio	f	t	0	f	{}	{}	audio-adapter
33	Splitter audio	f	t	0	f	{}	{}	audio-splitter
34	Convertor audio	f	t	0	f	{}	{}	audio-converter
35	Adaptor video	f	t	0	f	{}	{}	video-adapter
36	Convertor	f	t	0	f	{}	{}	video-converter
37	Prelungitor 	f	t	0	f	{}	{}	video-extension
38	Repetitor	f	t	0	f	{}	{}	video-repeater
39	Splitter	f	t	0	f	{}	{}	video-splitter
40	Comutator	f	t	0	f	{}	{}	video-switch
41	Cablu audio 	f	t	0	f	{}	{}	audio-cable
42	Cablu video	f	t	0	f	{}	{}	video-cable
\.


--
-- Data for Name: product_productvariant; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.product_productvariant (id, sku, name, product_id, cost_price_amount, track_inventory, weight, metadata, private_metadata, currency, price_amount, sort_order) FROM stdin;
16	CA-TOSL-10CC-0010-BK		16	\N	f	\N	{}	{}	RON	0.000	0
17	CA-TOSL-10CC-0020-BK		17	\N	f	\N	{}	{}	RON	0.000	0
18	CA-TOSL-10CC-0030-BK		18	\N	f	\N	{}	{}	RON	0.000	0
20	AD-0024-BK		20	\N	f	\N	{}	{}	RON	0.000	0
21	AD-0024-W		21	\N	f	\N	{}	{}	RON	0.000	0
22	DSC-OPT-RCA-001		22	\N	f	\N	{}	{}	RON	0.000	0
24	AC10TC		24	\N	f	\N	{}	{}	RON	0.000	0
25	CA-DPDP-10CC-0018-BK		25	\N	f	\N	{}	{}	RON	0.000	0
26	CA-DPDP-20CU-0010-BK		26	\N	f	\N	{}	{}	RON	0.000	0
27	CA-DVIS-10CC-0018-BK		27	\N	f	\N	{}	{}	RON	0.000	0
28	NSK-0419		28	\N	f	\N	{}	{}	RON	0.000	0
19	AD-0023-BK		19	\N	f	\N	{}	{}	RON	10.000	0
23	ACCMP3		23	\N	f	\N	{}	{}	RON	5.000	0
\.


--
-- Data for Name: product_productvarianttranslation; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.product_productvarianttranslation (id, language_code, name, product_variant_id) FROM stdin;
\.


--
-- Data for Name: product_variantimage; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.product_variantimage (id, image_id, variant_id) FROM stdin;
\.


--
-- Data for Name: shipping_shippingmethod; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.shipping_shippingmethod (id, name, maximum_order_price_amount, maximum_order_weight, minimum_order_price_amount, minimum_order_weight, price_amount, type, shipping_zone_id, currency) FROM stdin;
\.


--
-- Data for Name: shipping_shippingmethodtranslation; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.shipping_shippingmethodtranslation (id, language_code, name, shipping_method_id) FROM stdin;
\.


--
-- Data for Name: shipping_shippingzone; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.shipping_shippingzone (id, name, countries, "default") FROM stdin;
\.


--
-- Data for Name: site_authorizationkey; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.site_authorizationkey (id, name, key, password, site_settings_id) FROM stdin;
\.


--
-- Data for Name: site_sitesettings; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.site_sitesettings (id, header_text, description, site_id, bottom_menu_id, top_menu_id, display_gross_prices, include_taxes_in_prices, charge_taxes_on_shipping, track_inventory_by_default, homepage_collection_id, default_weight_unit, automatic_fulfillment_digital_products, default_digital_max_downloads, default_digital_url_valid_days, company_address_id, default_mail_sender_address, default_mail_sender_name, customer_set_password_url) FROM stdin;
1	Test Saleor - a sample shop!		1	2	1	t	t	t	t	\N	kg	f	\N	\N	\N	\N		\N
\.


--
-- Data for Name: site_sitesettingstranslation; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.site_sitesettingstranslation (id, language_code, header_text, description, site_settings_id) FROM stdin;
\.


--
-- Data for Name: warehouse_allocation; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.warehouse_allocation (id, quantity_allocated, order_line_id, stock_id) FROM stdin;
\.


--
-- Data for Name: warehouse_stock; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.warehouse_stock (id, quantity, product_variant_id, warehouse_id) FROM stdin;
\.


--
-- Data for Name: warehouse_warehouse; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.warehouse_warehouse (id, name, company_name, email, address_id, slug) FROM stdin;
\.


--
-- Data for Name: warehouse_warehouse_shipping_zones; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.warehouse_warehouse_shipping_zones (id, warehouse_id, shippingzone_id) FROM stdin;
\.


--
-- Data for Name: webhook_webhook; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.webhook_webhook (id, target_url, is_active, secret_key, app_id, name) FROM stdin;
\.


--
-- Data for Name: webhook_webhookevent; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.webhook_webhookevent (id, event_type, webhook_id) FROM stdin;
\.


--
-- Data for Name: wishlist_wishlist; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.wishlist_wishlist (id, created_at, token, user_id) FROM stdin;
\.


--
-- Data for Name: wishlist_wishlistitem; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.wishlist_wishlistitem (id, created_at, product_id, wishlist_id) FROM stdin;
\.


--
-- Data for Name: wishlist_wishlistitem_variants; Type: TABLE DATA; Schema: public; Owner: saleor
--

COPY public.wishlist_wishlistitem_variants (id, wishlistitem_id, productvariant_id) FROM stdin;
\.


--
-- Name: account_customerevent_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.account_customerevent_id_seq', 1, true);


--
-- Name: account_customernote_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.account_customernote_id_seq', 1, false);


--
-- Name: account_serviceaccount_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.account_serviceaccount_id_seq', 1, true);


--
-- Name: account_serviceaccount_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.account_serviceaccount_permissions_id_seq', 15, true);


--
-- Name: account_serviceaccounttoken_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.account_serviceaccounttoken_id_seq', 1, true);


--
-- Name: account_staffnotificationrecipient_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.account_staffnotificationrecipient_id_seq', 1, false);


--
-- Name: app_appinstallation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.app_appinstallation_id_seq', 1, false);


--
-- Name: app_appinstallation_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.app_appinstallation_permissions_id_seq', 1, false);


--
-- Name: auth_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.auth_group_id_seq', 1, false);


--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.auth_group_permissions_id_seq', 1, false);


--
-- Name: auth_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.auth_permission_id_seq', 315, true);


--
-- Name: cart_cartline_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.cart_cartline_id_seq', 1, false);


--
-- Name: checkout_checkout_gift_cards_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.checkout_checkout_gift_cards_id_seq', 1, false);


--
-- Name: csv_exportevent_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.csv_exportevent_id_seq', 1, false);


--
-- Name: csv_exportfile_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.csv_exportfile_id_seq', 1, false);


--
-- Name: discount_sale_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.discount_sale_categories_id_seq', 1, false);


--
-- Name: discount_sale_collections_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.discount_sale_collections_id_seq', 1, false);


--
-- Name: discount_sale_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.discount_sale_id_seq', 1, false);


--
-- Name: discount_sale_products_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.discount_sale_products_id_seq', 1, false);


--
-- Name: discount_saletranslation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.discount_saletranslation_id_seq', 1, false);


--
-- Name: discount_voucher_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.discount_voucher_categories_id_seq', 1, false);


--
-- Name: discount_voucher_collections_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.discount_voucher_collections_id_seq', 1, false);


--
-- Name: discount_voucher_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.discount_voucher_id_seq', 1, false);


--
-- Name: discount_voucher_products_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.discount_voucher_products_id_seq', 1, false);


--
-- Name: discount_vouchercustomer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.discount_vouchercustomer_id_seq', 1, false);


--
-- Name: discount_vouchertranslation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.discount_vouchertranslation_id_seq', 1, false);


--
-- Name: django_content_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.django_content_type_id_seq', 75, true);


--
-- Name: django_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.django_migrations_id_seq', 527, true);


--
-- Name: django_prices_openexchangerates_conversionrate_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.django_prices_openexchangerates_conversionrate_id_seq', 1, false);


--
-- Name: django_prices_vatlayer_ratetypes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.django_prices_vatlayer_ratetypes_id_seq', 1, false);


--
-- Name: django_prices_vatlayer_vat_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.django_prices_vatlayer_vat_id_seq', 1, false);


--
-- Name: django_site_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.django_site_id_seq', 1, true);


--
-- Name: giftcard_giftcard_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.giftcard_giftcard_id_seq', 1, false);


--
-- Name: invoice_invoice_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.invoice_invoice_id_seq', 1, false);


--
-- Name: invoice_invoiceevent_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.invoice_invoiceevent_id_seq', 1, false);


--
-- Name: menu_menu_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.menu_menu_id_seq', 2, true);


--
-- Name: menu_menuitem_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.menu_menuitem_id_seq', 1, false);


--
-- Name: menu_menuitemtranslation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.menu_menuitemtranslation_id_seq', 1, false);


--
-- Name: order_fulfillment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.order_fulfillment_id_seq', 1, false);


--
-- Name: order_fulfillmentline_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.order_fulfillmentline_id_seq', 1, false);


--
-- Name: order_order_gift_cards_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.order_order_gift_cards_id_seq', 1, false);


--
-- Name: order_order_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.order_order_id_seq', 1, false);


--
-- Name: order_ordereditem_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.order_ordereditem_id_seq', 1, false);


--
-- Name: order_orderevent_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.order_orderevent_id_seq', 1, false);


--
-- Name: page_page_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.page_page_id_seq', 1, false);


--
-- Name: page_pagetranslation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.page_pagetranslation_id_seq', 1, false);


--
-- Name: payment_paymentmethod_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.payment_paymentmethod_id_seq', 1, false);


--
-- Name: payment_transaction_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.payment_transaction_id_seq', 1, false);


--
-- Name: plugins_pluginconfiguration_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.plugins_pluginconfiguration_id_seq', 1, false);


--
-- Name: product_assignedproductattribute_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.product_assignedproductattribute_id_seq', 315, true);


--
-- Name: product_assignedproductattribute_values_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.product_assignedproductattribute_values_id_seq', 318, true);


--
-- Name: product_assignedvariantattribute_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.product_assignedvariantattribute_id_seq', 1, false);


--
-- Name: product_assignedvariantattribute_values_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.product_assignedvariantattribute_values_id_seq', 1, false);


--
-- Name: product_attributechoicevalue_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.product_attributechoicevalue_id_seq', 4097, true);


--
-- Name: product_attributechoicevaluetranslation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.product_attributechoicevaluetranslation_id_seq', 1, false);


--
-- Name: product_attributeproduct_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.product_attributeproduct_id_seq', 559, true);


--
-- Name: product_attributevariant_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.product_attributevariant_id_seq', 1, false);


--
-- Name: product_category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.product_category_id_seq', 3, true);


--
-- Name: product_categorytranslation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.product_categorytranslation_id_seq', 1, false);


--
-- Name: product_collection_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.product_collection_id_seq', 1, false);


--
-- Name: product_collection_products_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.product_collection_products_id_seq', 1, false);


--
-- Name: product_collectiontranslation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.product_collectiontranslation_id_seq', 1, false);


--
-- Name: product_digitalcontent_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.product_digitalcontent_id_seq', 1, false);


--
-- Name: product_digitalcontenturl_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.product_digitalcontenturl_id_seq', 1, false);


--
-- Name: product_product_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.product_product_id_seq', 28, true);


--
-- Name: product_productattribute_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.product_productattribute_id_seq', 850, true);


--
-- Name: product_productattributetranslation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.product_productattributetranslation_id_seq', 1, false);


--
-- Name: product_productclass_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.product_productclass_id_seq', 42, true);


--
-- Name: product_productimage_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.product_productimage_id_seq', 96, true);


--
-- Name: product_producttranslation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.product_producttranslation_id_seq', 1, false);


--
-- Name: product_productvariant_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.product_productvariant_id_seq', 28, true);


--
-- Name: product_productvarianttranslation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.product_productvarianttranslation_id_seq', 1, false);


--
-- Name: product_variantimage_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.product_variantimage_id_seq', 1, false);


--
-- Name: shipping_shippingmethod_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.shipping_shippingmethod_id_seq', 1, false);


--
-- Name: shipping_shippingmethodtranslation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.shipping_shippingmethodtranslation_id_seq', 1, false);


--
-- Name: shipping_shippingzone_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.shipping_shippingzone_id_seq', 1, false);


--
-- Name: site_authorizationkey_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.site_authorizationkey_id_seq', 1, false);


--
-- Name: site_sitesettings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.site_sitesettings_id_seq', 1, true);


--
-- Name: site_sitesettingstranslation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.site_sitesettingstranslation_id_seq', 1, false);


--
-- Name: userprofile_address_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.userprofile_address_id_seq', 5, true);


--
-- Name: userprofile_user_addresses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.userprofile_user_addresses_id_seq', 1, false);


--
-- Name: userprofile_user_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.userprofile_user_groups_id_seq', 1, false);


--
-- Name: userprofile_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.userprofile_user_id_seq', 3, true);


--
-- Name: userprofile_user_user_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.userprofile_user_user_permissions_id_seq', 1, false);


--
-- Name: warehouse_allocation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.warehouse_allocation_id_seq', 1, false);


--
-- Name: warehouse_stock_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.warehouse_stock_id_seq', 1, false);


--
-- Name: warehouse_warehouse_shipping_zones_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.warehouse_warehouse_shipping_zones_id_seq', 1, false);


--
-- Name: webhook_webhook_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.webhook_webhook_id_seq', 1, false);


--
-- Name: webhook_webhookevent_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.webhook_webhookevent_id_seq', 1, false);


--
-- Name: wishlist_wishlist_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.wishlist_wishlist_id_seq', 1, false);


--
-- Name: wishlist_wishlistitem_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.wishlist_wishlistitem_id_seq', 1, false);


--
-- Name: wishlist_wishlistitem_variants_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
--

SELECT pg_catalog.setval('public.wishlist_wishlistitem_variants_id_seq', 1, false);


--
-- Name: account_customerevent account_customerevent_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.account_customerevent
    ADD CONSTRAINT account_customerevent_pkey PRIMARY KEY (id);


--
-- Name: account_customernote account_customernote_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.account_customernote
    ADD CONSTRAINT account_customernote_pkey PRIMARY KEY (id);


--
-- Name: app_app_permissions account_serviceaccount_p_serviceaccount_id_permis_1686b2ab_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.app_app_permissions
    ADD CONSTRAINT account_serviceaccount_p_serviceaccount_id_permis_1686b2ab_uniq UNIQUE (app_id, permission_id);


--
-- Name: app_app_permissions account_serviceaccount_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.app_app_permissions
    ADD CONSTRAINT account_serviceaccount_permissions_pkey PRIMARY KEY (id);


--
-- Name: app_app account_serviceaccount_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.app_app
    ADD CONSTRAINT account_serviceaccount_pkey PRIMARY KEY (id);


--
-- Name: app_apptoken account_serviceaccounttoken_auth_token_key; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.app_apptoken
    ADD CONSTRAINT account_serviceaccounttoken_auth_token_key UNIQUE (auth_token);


--
-- Name: app_apptoken account_serviceaccounttoken_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.app_apptoken
    ADD CONSTRAINT account_serviceaccounttoken_pkey PRIMARY KEY (id);


--
-- Name: account_staffnotificationrecipient account_staffnotificationrecipient_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.account_staffnotificationrecipient
    ADD CONSTRAINT account_staffnotificationrecipient_pkey PRIMARY KEY (id);


--
-- Name: account_staffnotificationrecipient account_staffnotificationrecipient_staff_email_key; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.account_staffnotificationrecipient
    ADD CONSTRAINT account_staffnotificationrecipient_staff_email_key UNIQUE (staff_email);


--
-- Name: account_staffnotificationrecipient account_staffnotificationrecipient_user_id_key; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.account_staffnotificationrecipient
    ADD CONSTRAINT account_staffnotificationrecipient_user_id_key UNIQUE (user_id);


--
-- Name: app_appinstallation_permissions app_appinstallation_perm_appinstallation_id_permi_7b7e0448_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.app_appinstallation_permissions
    ADD CONSTRAINT app_appinstallation_perm_appinstallation_id_permi_7b7e0448_uniq UNIQUE (appinstallation_id, permission_id);


--
-- Name: app_appinstallation_permissions app_appinstallation_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.app_appinstallation_permissions
    ADD CONSTRAINT app_appinstallation_permissions_pkey PRIMARY KEY (id);


--
-- Name: app_appinstallation app_appinstallation_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.app_appinstallation
    ADD CONSTRAINT app_appinstallation_pkey PRIMARY KEY (id);


--
-- Name: auth_group auth_group_name_key; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_name_key UNIQUE (name);


--
-- Name: auth_group_permissions auth_group_permissions_group_id_permission_id_0cd325b0_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_permission_id_0cd325b0_uniq UNIQUE (group_id, permission_id);


--
-- Name: auth_group_permissions auth_group_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_group auth_group_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_pkey PRIMARY KEY (id);


--
-- Name: auth_permission auth_permission_content_type_id_codename_01ab375a_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_codename_01ab375a_uniq UNIQUE (content_type_id, codename);


--
-- Name: auth_permission auth_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);


--
-- Name: checkout_checkout cart_cart_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.checkout_checkout
    ADD CONSTRAINT cart_cart_pkey PRIMARY KEY (token);


--
-- Name: checkout_checkoutline cart_cartline_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.checkout_checkoutline
    ADD CONSTRAINT cart_cartline_pkey PRIMARY KEY (id);


--
-- Name: checkout_checkoutline checkout_cartline_cart_id_variant_id_data_new_de3d8fca_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.checkout_checkoutline
    ADD CONSTRAINT checkout_cartline_cart_id_variant_id_data_new_de3d8fca_uniq UNIQUE (checkout_id, variant_id, data);


--
-- Name: checkout_checkout_gift_cards checkout_checkout_gift_c_checkout_id_giftcard_id_401ba79e_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.checkout_checkout_gift_cards
    ADD CONSTRAINT checkout_checkout_gift_c_checkout_id_giftcard_id_401ba79e_uniq UNIQUE (checkout_id, giftcard_id);


--
-- Name: checkout_checkout_gift_cards checkout_checkout_gift_cards_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.checkout_checkout_gift_cards
    ADD CONSTRAINT checkout_checkout_gift_cards_pkey PRIMARY KEY (id);


--
-- Name: csv_exportevent csv_exportevent_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.csv_exportevent
    ADD CONSTRAINT csv_exportevent_pkey PRIMARY KEY (id);


--
-- Name: csv_exportfile csv_exportfile_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.csv_exportfile
    ADD CONSTRAINT csv_exportfile_pkey PRIMARY KEY (id);


--
-- Name: discount_sale_categories discount_sale_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.discount_sale_categories
    ADD CONSTRAINT discount_sale_categories_pkey PRIMARY KEY (id);


--
-- Name: discount_sale_categories discount_sale_categories_sale_id_category_id_be438401_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.discount_sale_categories
    ADD CONSTRAINT discount_sale_categories_sale_id_category_id_be438401_uniq UNIQUE (sale_id, category_id);


--
-- Name: discount_sale_collections discount_sale_collections_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.discount_sale_collections
    ADD CONSTRAINT discount_sale_collections_pkey PRIMARY KEY (id);


--
-- Name: discount_sale_collections discount_sale_collections_sale_id_collection_id_01b57fc3_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.discount_sale_collections
    ADD CONSTRAINT discount_sale_collections_sale_id_collection_id_01b57fc3_uniq UNIQUE (sale_id, collection_id);


--
-- Name: discount_sale discount_sale_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.discount_sale
    ADD CONSTRAINT discount_sale_pkey PRIMARY KEY (id);


--
-- Name: discount_sale_products discount_sale_products_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.discount_sale_products
    ADD CONSTRAINT discount_sale_products_pkey PRIMARY KEY (id);


--
-- Name: discount_sale_products discount_sale_products_sale_id_product_id_1c2df1f8_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.discount_sale_products
    ADD CONSTRAINT discount_sale_products_sale_id_product_id_1c2df1f8_uniq UNIQUE (sale_id, product_id);


--
-- Name: discount_saletranslation discount_saletranslation_language_code_sale_id_e956163f_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.discount_saletranslation
    ADD CONSTRAINT discount_saletranslation_language_code_sale_id_e956163f_uniq UNIQUE (language_code, sale_id);


--
-- Name: discount_saletranslation discount_saletranslation_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.discount_saletranslation
    ADD CONSTRAINT discount_saletranslation_pkey PRIMARY KEY (id);


--
-- Name: discount_voucher_categories discount_voucher_categor_voucher_id_category_id_bb5f8954_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.discount_voucher_categories
    ADD CONSTRAINT discount_voucher_categor_voucher_id_category_id_bb5f8954_uniq UNIQUE (voucher_id, category_id);


--
-- Name: discount_voucher_categories discount_voucher_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.discount_voucher_categories
    ADD CONSTRAINT discount_voucher_categories_pkey PRIMARY KEY (id);


--
-- Name: discount_voucher discount_voucher_code_key; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.discount_voucher
    ADD CONSTRAINT discount_voucher_code_key UNIQUE (code);


--
-- Name: discount_voucher_collections discount_voucher_collect_voucher_id_collection_id_736b8f24_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.discount_voucher_collections
    ADD CONSTRAINT discount_voucher_collect_voucher_id_collection_id_736b8f24_uniq UNIQUE (voucher_id, collection_id);


--
-- Name: discount_voucher_collections discount_voucher_collections_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.discount_voucher_collections
    ADD CONSTRAINT discount_voucher_collections_pkey PRIMARY KEY (id);


--
-- Name: discount_voucher discount_voucher_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.discount_voucher
    ADD CONSTRAINT discount_voucher_pkey PRIMARY KEY (id);


--
-- Name: discount_voucher_products discount_voucher_products_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.discount_voucher_products
    ADD CONSTRAINT discount_voucher_products_pkey PRIMARY KEY (id);


--
-- Name: discount_voucher_products discount_voucher_products_voucher_id_product_id_2b092ec4_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.discount_voucher_products
    ADD CONSTRAINT discount_voucher_products_voucher_id_product_id_2b092ec4_uniq UNIQUE (voucher_id, product_id);


--
-- Name: discount_vouchercustomer discount_vouchercustomer_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.discount_vouchercustomer
    ADD CONSTRAINT discount_vouchercustomer_pkey PRIMARY KEY (id);


--
-- Name: discount_vouchercustomer discount_vouchercustomer_voucher_id_customer_emai_b7b1d6a1_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.discount_vouchercustomer
    ADD CONSTRAINT discount_vouchercustomer_voucher_id_customer_emai_b7b1d6a1_uniq UNIQUE (voucher_id, customer_email);


--
-- Name: discount_vouchertranslation discount_vouchertranslat_language_code_voucher_id_af4428b5_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.discount_vouchertranslation
    ADD CONSTRAINT discount_vouchertranslat_language_code_voucher_id_af4428b5_uniq UNIQUE (language_code, voucher_id);


--
-- Name: discount_vouchertranslation discount_vouchertranslation_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.discount_vouchertranslation
    ADD CONSTRAINT discount_vouchertranslation_pkey PRIMARY KEY (id);


--
-- Name: django_content_type django_content_type_app_label_model_76bd3d3b_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_app_label_model_76bd3d3b_uniq UNIQUE (app_label, model);


--
-- Name: django_content_type django_content_type_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_pkey PRIMARY KEY (id);


--
-- Name: django_migrations django_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.django_migrations
    ADD CONSTRAINT django_migrations_pkey PRIMARY KEY (id);


--
-- Name: django_prices_openexchangerates_conversionrate django_prices_openexchangerates_conversionrate_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.django_prices_openexchangerates_conversionrate
    ADD CONSTRAINT django_prices_openexchangerates_conversionrate_pkey PRIMARY KEY (id);


--
-- Name: django_prices_openexchangerates_conversionrate django_prices_openexchangerates_conversionrate_to_currency_key; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.django_prices_openexchangerates_conversionrate
    ADD CONSTRAINT django_prices_openexchangerates_conversionrate_to_currency_key UNIQUE (to_currency);


--
-- Name: django_prices_vatlayer_ratetypes django_prices_vatlayer_ratetypes_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.django_prices_vatlayer_ratetypes
    ADD CONSTRAINT django_prices_vatlayer_ratetypes_pkey PRIMARY KEY (id);


--
-- Name: django_prices_vatlayer_vat django_prices_vatlayer_vat_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.django_prices_vatlayer_vat
    ADD CONSTRAINT django_prices_vatlayer_vat_pkey PRIMARY KEY (id);


--
-- Name: django_site django_site_domain_a2e37b91_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.django_site
    ADD CONSTRAINT django_site_domain_a2e37b91_uniq UNIQUE (domain);


--
-- Name: django_site django_site_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.django_site
    ADD CONSTRAINT django_site_pkey PRIMARY KEY (id);


--
-- Name: giftcard_giftcard giftcard_giftcard_code_key; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.giftcard_giftcard
    ADD CONSTRAINT giftcard_giftcard_code_key UNIQUE (code);


--
-- Name: giftcard_giftcard giftcard_giftcard_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.giftcard_giftcard
    ADD CONSTRAINT giftcard_giftcard_pkey PRIMARY KEY (id);


--
-- Name: invoice_invoice invoice_invoice_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.invoice_invoice
    ADD CONSTRAINT invoice_invoice_pkey PRIMARY KEY (id);


--
-- Name: invoice_invoiceevent invoice_invoiceevent_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.invoice_invoiceevent
    ADD CONSTRAINT invoice_invoiceevent_pkey PRIMARY KEY (id);


--
-- Name: menu_menu menu_menu_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.menu_menu
    ADD CONSTRAINT menu_menu_pkey PRIMARY KEY (id);


--
-- Name: menu_menu menu_menu_slug_key; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.menu_menu
    ADD CONSTRAINT menu_menu_slug_key UNIQUE (slug);


--
-- Name: menu_menuitem menu_menuitem_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.menu_menuitem
    ADD CONSTRAINT menu_menuitem_pkey PRIMARY KEY (id);


--
-- Name: menu_menuitemtranslation menu_menuitemtranslation_language_code_menu_item__508dcdd8_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.menu_menuitemtranslation
    ADD CONSTRAINT menu_menuitemtranslation_language_code_menu_item__508dcdd8_uniq UNIQUE (language_code, menu_item_id);


--
-- Name: menu_menuitemtranslation menu_menuitemtranslation_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.menu_menuitemtranslation
    ADD CONSTRAINT menu_menuitemtranslation_pkey PRIMARY KEY (id);


--
-- Name: order_fulfillment order_fulfillment_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.order_fulfillment
    ADD CONSTRAINT order_fulfillment_pkey PRIMARY KEY (id);


--
-- Name: order_fulfillmentline order_fulfillmentline_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.order_fulfillmentline
    ADD CONSTRAINT order_fulfillmentline_pkey PRIMARY KEY (id);


--
-- Name: order_order_gift_cards order_order_gift_cards_order_id_giftcard_id_f58e7356_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.order_order_gift_cards
    ADD CONSTRAINT order_order_gift_cards_order_id_giftcard_id_f58e7356_uniq UNIQUE (order_id, giftcard_id);


--
-- Name: order_order_gift_cards order_order_gift_cards_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.order_order_gift_cards
    ADD CONSTRAINT order_order_gift_cards_pkey PRIMARY KEY (id);


--
-- Name: order_order order_order_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.order_order
    ADD CONSTRAINT order_order_pkey PRIMARY KEY (id);


--
-- Name: order_order order_order_token_key; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.order_order
    ADD CONSTRAINT order_order_token_key UNIQUE (token);


--
-- Name: order_orderline order_ordereditem_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.order_orderline
    ADD CONSTRAINT order_ordereditem_pkey PRIMARY KEY (id);


--
-- Name: order_orderevent order_orderevent_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.order_orderevent
    ADD CONSTRAINT order_orderevent_pkey PRIMARY KEY (id);


--
-- Name: page_page page_page_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.page_page
    ADD CONSTRAINT page_page_pkey PRIMARY KEY (id);


--
-- Name: page_page page_page_slug_key; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.page_page
    ADD CONSTRAINT page_page_slug_key UNIQUE (slug);


--
-- Name: page_pagetranslation page_pagetranslation_language_code_page_id_35685962_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.page_pagetranslation
    ADD CONSTRAINT page_pagetranslation_language_code_page_id_35685962_uniq UNIQUE (language_code, page_id);


--
-- Name: page_pagetranslation page_pagetranslation_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.page_pagetranslation
    ADD CONSTRAINT page_pagetranslation_pkey PRIMARY KEY (id);


--
-- Name: payment_payment payment_paymentmethod_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.payment_payment
    ADD CONSTRAINT payment_paymentmethod_pkey PRIMARY KEY (id);


--
-- Name: payment_transaction payment_transaction_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.payment_transaction
    ADD CONSTRAINT payment_transaction_pkey PRIMARY KEY (id);


--
-- Name: plugins_pluginconfiguration plugins_pluginconfiguration_identifier_3d7349fe_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.plugins_pluginconfiguration
    ADD CONSTRAINT plugins_pluginconfiguration_identifier_3d7349fe_uniq UNIQUE (identifier);


--
-- Name: plugins_pluginconfiguration plugins_pluginconfiguration_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.plugins_pluginconfiguration
    ADD CONSTRAINT plugins_pluginconfiguration_pkey PRIMARY KEY (id);


--
-- Name: product_assignedproductattribute_values product_assignedproducta_assignedproductattribute_ee1fc0ab_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_assignedproductattribute_values
    ADD CONSTRAINT product_assignedproducta_assignedproductattribute_ee1fc0ab_uniq UNIQUE (assignedproductattribute_id, attributevalue_id);


--
-- Name: product_assignedproductattribute product_assignedproducta_product_id_assignment_id_d7f5aab5_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_assignedproductattribute
    ADD CONSTRAINT product_assignedproducta_product_id_assignment_id_d7f5aab5_uniq UNIQUE (product_id, assignment_id);


--
-- Name: product_assignedproductattribute product_assignedproductattribute_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_assignedproductattribute
    ADD CONSTRAINT product_assignedproductattribute_pkey PRIMARY KEY (id);


--
-- Name: product_assignedproductattribute_values product_assignedproductattribute_values_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_assignedproductattribute_values
    ADD CONSTRAINT product_assignedproductattribute_values_pkey PRIMARY KEY (id);


--
-- Name: product_assignedvariantattribute_values product_assignedvarianta_assignedvariantattribute_8ffaee19_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_assignedvariantattribute_values
    ADD CONSTRAINT product_assignedvarianta_assignedvariantattribute_8ffaee19_uniq UNIQUE (assignedvariantattribute_id, attributevalue_id);


--
-- Name: product_assignedvariantattribute product_assignedvarianta_variant_id_assignment_id_16584418_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_assignedvariantattribute
    ADD CONSTRAINT product_assignedvarianta_variant_id_assignment_id_16584418_uniq UNIQUE (variant_id, assignment_id);


--
-- Name: product_assignedvariantattribute product_assignedvariantattribute_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_assignedvariantattribute
    ADD CONSTRAINT product_assignedvariantattribute_pkey PRIMARY KEY (id);


--
-- Name: product_assignedvariantattribute_values product_assignedvariantattribute_values_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_assignedvariantattribute_values
    ADD CONSTRAINT product_assignedvariantattribute_values_pkey PRIMARY KEY (id);


--
-- Name: product_attribute product_attribute_slug_a2ba35f2_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_attribute
    ADD CONSTRAINT product_attribute_slug_a2ba35f2_uniq UNIQUE (slug);


--
-- Name: product_attributevaluetranslation product_attributechoicev_language_code_attribute__9b58af18_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_attributevaluetranslation
    ADD CONSTRAINT product_attributechoicev_language_code_attribute__9b58af18_uniq UNIQUE (language_code, attribute_value_id);


--
-- Name: product_attributevalue product_attributechoicevalue_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_attributevalue
    ADD CONSTRAINT product_attributechoicevalue_pkey PRIMARY KEY (id);


--
-- Name: product_attributevaluetranslation product_attributechoicevaluetranslation_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_attributevaluetranslation
    ADD CONSTRAINT product_attributechoicevaluetranslation_pkey PRIMARY KEY (id);


--
-- Name: product_attributeproduct product_attributeproduct_attribute_id_product_typ_85ea87be_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_attributeproduct
    ADD CONSTRAINT product_attributeproduct_attribute_id_product_typ_85ea87be_uniq UNIQUE (attribute_id, product_type_id);


--
-- Name: product_attributeproduct product_attributeproduct_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_attributeproduct
    ADD CONSTRAINT product_attributeproduct_pkey PRIMARY KEY (id);


--
-- Name: product_attributevalue product_attributevalue_slug_attribute_id_a9b19472_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_attributevalue
    ADD CONSTRAINT product_attributevalue_slug_attribute_id_a9b19472_uniq UNIQUE (slug, attribute_id);


--
-- Name: product_attributevariant product_attributevariant_attribute_id_product_typ_304d6c95_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_attributevariant
    ADD CONSTRAINT product_attributevariant_attribute_id_product_typ_304d6c95_uniq UNIQUE (attribute_id, product_type_id);


--
-- Name: product_attributevariant product_attributevariant_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_attributevariant
    ADD CONSTRAINT product_attributevariant_pkey PRIMARY KEY (id);


--
-- Name: product_category product_category_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_category
    ADD CONSTRAINT product_category_pkey PRIMARY KEY (id);


--
-- Name: product_category product_category_slug_e1f8ccc4_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_category
    ADD CONSTRAINT product_category_slug_e1f8ccc4_uniq UNIQUE (slug);


--
-- Name: product_categorytranslation product_categorytranslat_language_code_category_i_f71fd11d_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_categorytranslation
    ADD CONSTRAINT product_categorytranslat_language_code_category_i_f71fd11d_uniq UNIQUE (language_code, category_id);


--
-- Name: product_categorytranslation product_categorytranslation_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_categorytranslation
    ADD CONSTRAINT product_categorytranslation_pkey PRIMARY KEY (id);


--
-- Name: product_collection product_collection_name_key; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_collection
    ADD CONSTRAINT product_collection_name_key UNIQUE (name);


--
-- Name: product_collection product_collection_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_collection
    ADD CONSTRAINT product_collection_pkey PRIMARY KEY (id);


--
-- Name: product_collectionproduct product_collection_products_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_collectionproduct
    ADD CONSTRAINT product_collection_products_pkey PRIMARY KEY (id);


--
-- Name: product_collection product_collection_slug_ec186116_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_collection
    ADD CONSTRAINT product_collection_slug_ec186116_uniq UNIQUE (slug);


--
-- Name: product_collectionproduct product_collectionproduc_collection_id_product_id_e582d799_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_collectionproduct
    ADD CONSTRAINT product_collectionproduc_collection_id_product_id_e582d799_uniq UNIQUE (collection_id, product_id);


--
-- Name: product_collectiontranslation product_collectiontransl_language_code_collection_b1200cd5_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_collectiontranslation
    ADD CONSTRAINT product_collectiontransl_language_code_collection_b1200cd5_uniq UNIQUE (language_code, collection_id);


--
-- Name: product_collectiontranslation product_collectiontranslation_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_collectiontranslation
    ADD CONSTRAINT product_collectiontranslation_pkey PRIMARY KEY (id);


--
-- Name: product_digitalcontent product_digitalcontent_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_digitalcontent
    ADD CONSTRAINT product_digitalcontent_pkey PRIMARY KEY (id);


--
-- Name: product_digitalcontent product_digitalcontent_product_variant_id_key; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_digitalcontent
    ADD CONSTRAINT product_digitalcontent_product_variant_id_key UNIQUE (product_variant_id);


--
-- Name: product_digitalcontenturl product_digitalcontenturl_line_id_key; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_digitalcontenturl
    ADD CONSTRAINT product_digitalcontenturl_line_id_key UNIQUE (line_id);


--
-- Name: product_digitalcontenturl product_digitalcontenturl_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_digitalcontenturl
    ADD CONSTRAINT product_digitalcontenturl_pkey PRIMARY KEY (id);


--
-- Name: product_digitalcontenturl product_digitalcontenturl_token_key; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_digitalcontenturl
    ADD CONSTRAINT product_digitalcontenturl_token_key UNIQUE (token);


--
-- Name: product_product product_product_default_variant_id_key; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_product
    ADD CONSTRAINT product_product_default_variant_id_key UNIQUE (default_variant_id);


--
-- Name: product_product product_product_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_product
    ADD CONSTRAINT product_product_pkey PRIMARY KEY (id);


--
-- Name: product_product product_product_slug_key; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_product
    ADD CONSTRAINT product_product_slug_key UNIQUE (slug);


--
-- Name: product_attributetranslation product_productattribute_language_code_product_at_58451db2_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_attributetranslation
    ADD CONSTRAINT product_productattribute_language_code_product_at_58451db2_uniq UNIQUE (language_code, attribute_id);


--
-- Name: product_attribute product_productattribute_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_attribute
    ADD CONSTRAINT product_productattribute_pkey PRIMARY KEY (id);


--
-- Name: product_attributetranslation product_productattributetranslation_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_attributetranslation
    ADD CONSTRAINT product_productattributetranslation_pkey PRIMARY KEY (id);


--
-- Name: product_producttype product_productclass_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_producttype
    ADD CONSTRAINT product_productclass_pkey PRIMARY KEY (id);


--
-- Name: product_productimage product_productimage_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_productimage
    ADD CONSTRAINT product_productimage_pkey PRIMARY KEY (id);


--
-- Name: product_producttranslation product_producttranslati_language_code_product_id_b06ba774_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_producttranslation
    ADD CONSTRAINT product_producttranslati_language_code_product_id_b06ba774_uniq UNIQUE (language_code, product_id);


--
-- Name: product_producttranslation product_producttranslation_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_producttranslation
    ADD CONSTRAINT product_producttranslation_pkey PRIMARY KEY (id);


--
-- Name: product_producttype product_producttype_slug_key; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_producttype
    ADD CONSTRAINT product_producttype_slug_key UNIQUE (slug);


--
-- Name: product_productvariant product_productvariant_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_productvariant
    ADD CONSTRAINT product_productvariant_pkey PRIMARY KEY (id);


--
-- Name: product_productvariant product_productvariant_sku_key; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_productvariant
    ADD CONSTRAINT product_productvariant_sku_key UNIQUE (sku);


--
-- Name: product_productvarianttranslation product_productvarianttr_language_code_product_va_cf16d8d0_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_productvarianttranslation
    ADD CONSTRAINT product_productvarianttr_language_code_product_va_cf16d8d0_uniq UNIQUE (language_code, product_variant_id);


--
-- Name: product_productvarianttranslation product_productvarianttranslation_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_productvarianttranslation
    ADD CONSTRAINT product_productvarianttranslation_pkey PRIMARY KEY (id);


--
-- Name: product_variantimage product_variantimage_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_variantimage
    ADD CONSTRAINT product_variantimage_pkey PRIMARY KEY (id);


--
-- Name: product_variantimage product_variantimage_variant_id_image_id_b19f327c_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_variantimage
    ADD CONSTRAINT product_variantimage_variant_id_image_id_b19f327c_uniq UNIQUE (variant_id, image_id);


--
-- Name: shipping_shippingmethod shipping_shippingmethod_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.shipping_shippingmethod
    ADD CONSTRAINT shipping_shippingmethod_pkey PRIMARY KEY (id);


--
-- Name: shipping_shippingmethodtranslation shipping_shippingmethodt_language_code_shipping_m_70e4f786_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.shipping_shippingmethodtranslation
    ADD CONSTRAINT shipping_shippingmethodt_language_code_shipping_m_70e4f786_uniq UNIQUE (language_code, shipping_method_id);


--
-- Name: shipping_shippingmethodtranslation shipping_shippingmethodtranslation_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.shipping_shippingmethodtranslation
    ADD CONSTRAINT shipping_shippingmethodtranslation_pkey PRIMARY KEY (id);


--
-- Name: shipping_shippingzone shipping_shippingzone_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.shipping_shippingzone
    ADD CONSTRAINT shipping_shippingzone_pkey PRIMARY KEY (id);


--
-- Name: site_authorizationkey site_authorizationkey_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.site_authorizationkey
    ADD CONSTRAINT site_authorizationkey_pkey PRIMARY KEY (id);


--
-- Name: site_authorizationkey site_authorizationkey_site_settings_id_name_c5f8d1e6_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.site_authorizationkey
    ADD CONSTRAINT site_authorizationkey_site_settings_id_name_c5f8d1e6_uniq UNIQUE (site_settings_id, name);


--
-- Name: site_sitesettings site_sitesettings_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.site_sitesettings
    ADD CONSTRAINT site_sitesettings_pkey PRIMARY KEY (id);


--
-- Name: site_sitesettings site_sitesettings_site_id_key; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.site_sitesettings
    ADD CONSTRAINT site_sitesettings_site_id_key UNIQUE (site_id);


--
-- Name: site_sitesettingstranslation site_sitesettingstransla_language_code_site_setti_e767d9e7_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.site_sitesettingstranslation
    ADD CONSTRAINT site_sitesettingstransla_language_code_site_setti_e767d9e7_uniq UNIQUE (language_code, site_settings_id);


--
-- Name: site_sitesettingstranslation site_sitesettingstranslation_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.site_sitesettingstranslation
    ADD CONSTRAINT site_sitesettingstranslation_pkey PRIMARY KEY (id);


--
-- Name: account_address userprofile_address_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.account_address
    ADD CONSTRAINT userprofile_address_pkey PRIMARY KEY (id);


--
-- Name: account_user_addresses userprofile_user_addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.account_user_addresses
    ADD CONSTRAINT userprofile_user_addresses_pkey PRIMARY KEY (id);


--
-- Name: account_user_addresses userprofile_user_addresses_user_id_address_id_6cb87bcc_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.account_user_addresses
    ADD CONSTRAINT userprofile_user_addresses_user_id_address_id_6cb87bcc_uniq UNIQUE (user_id, address_id);


--
-- Name: account_user userprofile_user_email_key; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.account_user
    ADD CONSTRAINT userprofile_user_email_key UNIQUE (email);


--
-- Name: account_user_groups userprofile_user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.account_user_groups
    ADD CONSTRAINT userprofile_user_groups_pkey PRIMARY KEY (id);


--
-- Name: account_user_groups userprofile_user_groups_user_id_group_id_90ce1781_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.account_user_groups
    ADD CONSTRAINT userprofile_user_groups_user_id_group_id_90ce1781_uniq UNIQUE (user_id, group_id);


--
-- Name: account_user userprofile_user_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.account_user
    ADD CONSTRAINT userprofile_user_pkey PRIMARY KEY (id);


--
-- Name: account_user_user_permissions userprofile_user_user_pe_user_id_permission_id_706d65c8_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.account_user_user_permissions
    ADD CONSTRAINT userprofile_user_user_pe_user_id_permission_id_706d65c8_uniq UNIQUE (user_id, permission_id);


--
-- Name: account_user_user_permissions userprofile_user_user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.account_user_user_permissions
    ADD CONSTRAINT userprofile_user_user_permissions_pkey PRIMARY KEY (id);


--
-- Name: warehouse_allocation warehouse_allocation_order_line_id_stock_id_aa103861_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.warehouse_allocation
    ADD CONSTRAINT warehouse_allocation_order_line_id_stock_id_aa103861_uniq UNIQUE (order_line_id, stock_id);


--
-- Name: warehouse_allocation warehouse_allocation_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.warehouse_allocation
    ADD CONSTRAINT warehouse_allocation_pkey PRIMARY KEY (id);


--
-- Name: warehouse_stock warehouse_stock_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.warehouse_stock
    ADD CONSTRAINT warehouse_stock_pkey PRIMARY KEY (id);


--
-- Name: warehouse_stock warehouse_stock_warehouse_id_product_variant_id_b04a0a40_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.warehouse_stock
    ADD CONSTRAINT warehouse_stock_warehouse_id_product_variant_id_b04a0a40_uniq UNIQUE (warehouse_id, product_variant_id);


--
-- Name: warehouse_warehouse warehouse_warehouse_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.warehouse_warehouse
    ADD CONSTRAINT warehouse_warehouse_pkey PRIMARY KEY (id);


--
-- Name: warehouse_warehouse_shipping_zones warehouse_warehouse_ship_warehouse_id_shippingzon_e18400fa_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.warehouse_warehouse_shipping_zones
    ADD CONSTRAINT warehouse_warehouse_ship_warehouse_id_shippingzon_e18400fa_uniq UNIQUE (warehouse_id, shippingzone_id);


--
-- Name: warehouse_warehouse_shipping_zones warehouse_warehouse_shipping_zones_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.warehouse_warehouse_shipping_zones
    ADD CONSTRAINT warehouse_warehouse_shipping_zones_pkey PRIMARY KEY (id);


--
-- Name: warehouse_warehouse warehouse_warehouse_slug_key; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.warehouse_warehouse
    ADD CONSTRAINT warehouse_warehouse_slug_key UNIQUE (slug);


--
-- Name: webhook_webhook webhook_webhook_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.webhook_webhook
    ADD CONSTRAINT webhook_webhook_pkey PRIMARY KEY (id);


--
-- Name: webhook_webhookevent webhook_webhookevent_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.webhook_webhookevent
    ADD CONSTRAINT webhook_webhookevent_pkey PRIMARY KEY (id);


--
-- Name: wishlist_wishlist wishlist_wishlist_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.wishlist_wishlist
    ADD CONSTRAINT wishlist_wishlist_pkey PRIMARY KEY (id);


--
-- Name: wishlist_wishlist wishlist_wishlist_token_key; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.wishlist_wishlist
    ADD CONSTRAINT wishlist_wishlist_token_key UNIQUE (token);


--
-- Name: wishlist_wishlist wishlist_wishlist_user_id_key; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.wishlist_wishlist
    ADD CONSTRAINT wishlist_wishlist_user_id_key UNIQUE (user_id);


--
-- Name: wishlist_wishlistitem wishlist_wishlistitem_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.wishlist_wishlistitem
    ADD CONSTRAINT wishlist_wishlistitem_pkey PRIMARY KEY (id);


--
-- Name: wishlist_wishlistitem_variants wishlist_wishlistitem_va_wishlistitem_id_productv_33a1ed29_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.wishlist_wishlistitem_variants
    ADD CONSTRAINT wishlist_wishlistitem_va_wishlistitem_id_productv_33a1ed29_uniq UNIQUE (wishlistitem_id, productvariant_id);


--
-- Name: wishlist_wishlistitem_variants wishlist_wishlistitem_variants_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.wishlist_wishlistitem_variants
    ADD CONSTRAINT wishlist_wishlistitem_variants_pkey PRIMARY KEY (id);


--
-- Name: wishlist_wishlistitem wishlist_wishlistitem_wishlist_id_product_id_3b73b644_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.wishlist_wishlistitem
    ADD CONSTRAINT wishlist_wishlistitem_wishlist_id_product_id_3b73b644_uniq UNIQUE (wishlist_id, product_id);


--
-- Name: account_customerevent_order_id_2d6e2d20; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX account_customerevent_order_id_2d6e2d20 ON public.account_customerevent USING btree (order_id);


--
-- Name: account_customerevent_user_id_b3d6ec36; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX account_customerevent_user_id_b3d6ec36 ON public.account_customerevent USING btree (user_id);


--
-- Name: account_customernote_customer_id_ec50cbf6; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX account_customernote_customer_id_ec50cbf6 ON public.account_customernote USING btree (customer_id);


--
-- Name: account_customernote_date_231c3474; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX account_customernote_date_231c3474 ON public.account_customernote USING btree (date);


--
-- Name: account_customernote_user_id_b10a6c14; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX account_customernote_user_id_b10a6c14 ON public.account_customernote USING btree (user_id);


--
-- Name: account_serviceaccount_permissions_permission_id_449791f0; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX account_serviceaccount_permissions_permission_id_449791f0 ON public.app_app_permissions USING btree (permission_id);


--
-- Name: account_serviceaccount_permissions_serviceaccount_id_ec78f497; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX account_serviceaccount_permissions_serviceaccount_id_ec78f497 ON public.app_app_permissions USING btree (app_id);


--
-- Name: account_serviceaccounttoken_auth_token_e4c38601_like; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX account_serviceaccounttoken_auth_token_e4c38601_like ON public.app_apptoken USING btree (auth_token varchar_pattern_ops);


--
-- Name: account_serviceaccounttoken_service_account_id_a8e6dee8; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX account_serviceaccounttoken_service_account_id_a8e6dee8 ON public.app_apptoken USING btree (app_id);


--
-- Name: account_staffnotificationrecipient_staff_email_a309b82e_like; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX account_staffnotificationrecipient_staff_email_a309b82e_like ON public.account_staffnotificationrecipient USING btree (staff_email varchar_pattern_ops);


--
-- Name: app_appinstallation_permissions_appinstallation_id_f7fe0271; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX app_appinstallation_permissions_appinstallation_id_f7fe0271 ON public.app_appinstallation_permissions USING btree (appinstallation_id);


--
-- Name: app_appinstallation_permissions_permission_id_4ee9f6c8; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX app_appinstallation_permissions_permission_id_4ee9f6c8 ON public.app_appinstallation_permissions USING btree (permission_id);


--
-- Name: auth_group_name_a6ea08ec_like; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX auth_group_name_a6ea08ec_like ON public.auth_group USING btree (name varchar_pattern_ops);


--
-- Name: auth_group_permissions_group_id_b120cbf9; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX auth_group_permissions_group_id_b120cbf9 ON public.auth_group_permissions USING btree (group_id);


--
-- Name: auth_group_permissions_permission_id_84c5c92e; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX auth_group_permissions_permission_id_84c5c92e ON public.auth_group_permissions USING btree (permission_id);


--
-- Name: auth_permission_content_type_id_2f476e4b; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX auth_permission_content_type_id_2f476e4b ON public.auth_permission USING btree (content_type_id);


--
-- Name: cart_cart_billing_address_id_9eb62ddd; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX cart_cart_billing_address_id_9eb62ddd ON public.checkout_checkout USING btree (billing_address_id);


--
-- Name: cart_cart_shipping_address_id_adfddaf9; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX cart_cart_shipping_address_id_adfddaf9 ON public.checkout_checkout USING btree (shipping_address_id);


--
-- Name: cart_cart_shipping_method_id_835c02e0; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX cart_cart_shipping_method_id_835c02e0 ON public.checkout_checkout USING btree (shipping_method_id);


--
-- Name: cart_cart_user_id_9b4220b9; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX cart_cart_user_id_9b4220b9 ON public.checkout_checkout USING btree (user_id);


--
-- Name: cart_cartline_cart_id_c7b9981e; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX cart_cartline_cart_id_c7b9981e ON public.checkout_checkoutline USING btree (checkout_id);


--
-- Name: cart_cartline_product_id_1a54130f; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX cart_cartline_product_id_1a54130f ON public.checkout_checkoutline USING btree (variant_id);


--
-- Name: checkout_checkout_gift_cards_checkout_id_e314728d; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX checkout_checkout_gift_cards_checkout_id_e314728d ON public.checkout_checkout_gift_cards USING btree (checkout_id);


--
-- Name: checkout_checkout_gift_cards_giftcard_id_f5994462; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX checkout_checkout_gift_cards_giftcard_id_f5994462 ON public.checkout_checkout_gift_cards USING btree (giftcard_id);


--
-- Name: csv_exportevent_app_id_8637fcc5; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX csv_exportevent_app_id_8637fcc5 ON public.csv_exportevent USING btree (app_id);


--
-- Name: csv_exportevent_export_file_id_35f6c448; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX csv_exportevent_export_file_id_35f6c448 ON public.csv_exportevent USING btree (export_file_id);


--
-- Name: csv_exportevent_user_id_6111f193; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX csv_exportevent_user_id_6111f193 ON public.csv_exportevent USING btree (user_id);


--
-- Name: csv_exportfile_app_id_bc900999; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX csv_exportfile_app_id_bc900999 ON public.csv_exportfile USING btree (app_id);


--
-- Name: csv_exportfile_user_id_2c9071e6; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX csv_exportfile_user_id_2c9071e6 ON public.csv_exportfile USING btree (user_id);


--
-- Name: discount_sale_categories_category_id_64e132af; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX discount_sale_categories_category_id_64e132af ON public.discount_sale_categories USING btree (category_id);


--
-- Name: discount_sale_categories_sale_id_2aeee4a7; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX discount_sale_categories_sale_id_2aeee4a7 ON public.discount_sale_categories USING btree (sale_id);


--
-- Name: discount_sale_collections_collection_id_f66df9d7; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX discount_sale_collections_collection_id_f66df9d7 ON public.discount_sale_collections USING btree (collection_id);


--
-- Name: discount_sale_collections_sale_id_a912da4a; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX discount_sale_collections_sale_id_a912da4a ON public.discount_sale_collections USING btree (sale_id);


--
-- Name: discount_sale_products_product_id_d42c9636; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX discount_sale_products_product_id_d42c9636 ON public.discount_sale_products USING btree (product_id);


--
-- Name: discount_sale_products_sale_id_10e3a20f; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX discount_sale_products_sale_id_10e3a20f ON public.discount_sale_products USING btree (sale_id);


--
-- Name: discount_saletranslation_sale_id_36a69b0a; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX discount_saletranslation_sale_id_36a69b0a ON public.discount_saletranslation USING btree (sale_id);


--
-- Name: discount_voucher_categories_category_id_fc9d044a; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX discount_voucher_categories_category_id_fc9d044a ON public.discount_voucher_categories USING btree (category_id);


--
-- Name: discount_voucher_categories_voucher_id_19a56338; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX discount_voucher_categories_voucher_id_19a56338 ON public.discount_voucher_categories USING btree (voucher_id);


--
-- Name: discount_voucher_code_ff8dc52c_like; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX discount_voucher_code_ff8dc52c_like ON public.discount_voucher USING btree (code varchar_pattern_ops);


--
-- Name: discount_voucher_collections_collection_id_b9de6b54; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX discount_voucher_collections_collection_id_b9de6b54 ON public.discount_voucher_collections USING btree (collection_id);


--
-- Name: discount_voucher_collections_voucher_id_4ce1fde3; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX discount_voucher_collections_voucher_id_4ce1fde3 ON public.discount_voucher_collections USING btree (voucher_id);


--
-- Name: discount_voucher_products_product_id_4a3131ff; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX discount_voucher_products_product_id_4a3131ff ON public.discount_voucher_products USING btree (product_id);


--
-- Name: discount_voucher_products_voucher_id_8a2e6c3a; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX discount_voucher_products_voucher_id_8a2e6c3a ON public.discount_voucher_products USING btree (voucher_id);


--
-- Name: discount_vouchercustomer_voucher_id_bb55c04f; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX discount_vouchercustomer_voucher_id_bb55c04f ON public.discount_vouchercustomer USING btree (voucher_id);


--
-- Name: discount_vouchertranslation_voucher_id_288246a9; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX discount_vouchertranslation_voucher_id_288246a9 ON public.discount_vouchertranslation USING btree (voucher_id);


--
-- Name: django_prices_openexchan_to_currency_92c4a4e1_like; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX django_prices_openexchan_to_currency_92c4a4e1_like ON public.django_prices_openexchangerates_conversionrate USING btree (to_currency varchar_pattern_ops);


--
-- Name: django_prices_vatlayer_vat_country_code_858b2cc4; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX django_prices_vatlayer_vat_country_code_858b2cc4 ON public.django_prices_vatlayer_vat USING btree (country_code);


--
-- Name: django_prices_vatlayer_vat_country_code_858b2cc4_like; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX django_prices_vatlayer_vat_country_code_858b2cc4_like ON public.django_prices_vatlayer_vat USING btree (country_code varchar_pattern_ops);


--
-- Name: django_site_domain_a2e37b91_like; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX django_site_domain_a2e37b91_like ON public.django_site USING btree (domain varchar_pattern_ops);


--
-- Name: giftcard_giftcard_code_f6fb6be8_like; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX giftcard_giftcard_code_f6fb6be8_like ON public.giftcard_giftcard USING btree (code varchar_pattern_ops);


--
-- Name: giftcard_giftcard_user_id_ce2401b5; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX giftcard_giftcard_user_id_ce2401b5 ON public.giftcard_giftcard USING btree (user_id);


--
-- Name: invoice_invoice_order_id_c5fc9ae9; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX invoice_invoice_order_id_c5fc9ae9 ON public.invoice_invoice USING btree (order_id);


--
-- Name: invoice_invoiceevent_invoice_id_de0632ca; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX invoice_invoiceevent_invoice_id_de0632ca ON public.invoice_invoiceevent USING btree (invoice_id);


--
-- Name: invoice_invoiceevent_order_id_5a337f7a; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX invoice_invoiceevent_order_id_5a337f7a ON public.invoice_invoiceevent USING btree (order_id);


--
-- Name: invoice_invoiceevent_user_id_cd599b8d; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX invoice_invoiceevent_user_id_cd599b8d ON public.invoice_invoiceevent USING btree (user_id);


--
-- Name: menu_menu_slug_98939c4e_like; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX menu_menu_slug_98939c4e_like ON public.menu_menu USING btree (slug varchar_pattern_ops);


--
-- Name: menu_menuitem_category_id_af353a3b; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX menu_menuitem_category_id_af353a3b ON public.menu_menuitem USING btree (category_id);


--
-- Name: menu_menuitem_collection_id_b913b19e; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX menu_menuitem_collection_id_b913b19e ON public.menu_menuitem USING btree (collection_id);


--
-- Name: menu_menuitem_menu_id_f466b139; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX menu_menuitem_menu_id_f466b139 ON public.menu_menuitem USING btree (menu_id);


--
-- Name: menu_menuitem_page_id_a0c8f92d; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX menu_menuitem_page_id_a0c8f92d ON public.menu_menuitem USING btree (page_id);


--
-- Name: menu_menuitem_parent_id_439f55a5; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX menu_menuitem_parent_id_439f55a5 ON public.menu_menuitem USING btree (parent_id);


--
-- Name: menu_menuitem_sort_order_f96ed184; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX menu_menuitem_sort_order_f96ed184 ON public.menu_menuitem USING btree (sort_order);


--
-- Name: menu_menuitem_tree_id_0d2e9c9a; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX menu_menuitem_tree_id_0d2e9c9a ON public.menu_menuitem USING btree (tree_id);


--
-- Name: menu_menuitemtranslation_menu_item_id_3445926c; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX menu_menuitemtranslation_menu_item_id_3445926c ON public.menu_menuitemtranslation USING btree (menu_item_id);


--
-- Name: order_fulfillment_order_id_02695111; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX order_fulfillment_order_id_02695111 ON public.order_fulfillment USING btree (order_id);


--
-- Name: order_fulfillmentline_fulfillment_id_68f3291d; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX order_fulfillmentline_fulfillment_id_68f3291d ON public.order_fulfillmentline USING btree (fulfillment_id);


--
-- Name: order_fulfillmentline_order_line_id_7d40e054; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX order_fulfillmentline_order_line_id_7d40e054 ON public.order_fulfillmentline USING btree (order_line_id);


--
-- Name: order_fulfillmentline_stock_id_da5a99fe; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX order_fulfillmentline_stock_id_da5a99fe ON public.order_fulfillmentline USING btree (stock_id);


--
-- Name: order_order_billing_address_id_8fe537cf; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX order_order_billing_address_id_8fe537cf ON public.order_order USING btree (billing_address_id);


--
-- Name: order_order_gift_cards_giftcard_id_f6844926; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX order_order_gift_cards_giftcard_id_f6844926 ON public.order_order_gift_cards USING btree (giftcard_id);


--
-- Name: order_order_gift_cards_order_id_ce5608c4; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX order_order_gift_cards_order_id_ce5608c4 ON public.order_order_gift_cards USING btree (order_id);


--
-- Name: order_order_shipping_address_id_57e64931; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX order_order_shipping_address_id_57e64931 ON public.order_order USING btree (shipping_address_id);


--
-- Name: order_order_shipping_method_id_2a742834; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX order_order_shipping_method_id_2a742834 ON public.order_order USING btree (shipping_method_id);


--
-- Name: order_order_token_ddb7fb7b_like; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX order_order_token_ddb7fb7b_like ON public.order_order USING btree (token varchar_pattern_ops);


--
-- Name: order_order_user_id_7cf9bc2b; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX order_order_user_id_7cf9bc2b ON public.order_order USING btree (user_id);


--
-- Name: order_order_voucher_id_0748ca22; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX order_order_voucher_id_0748ca22 ON public.order_order USING btree (voucher_id);


--
-- Name: order_orderevent_order_id_09aa7ccd; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX order_orderevent_order_id_09aa7ccd ON public.order_orderevent USING btree (order_id);


--
-- Name: order_orderevent_user_id_1056ac9c; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX order_orderevent_user_id_1056ac9c ON public.order_orderevent USING btree (user_id);


--
-- Name: order_orderline_order_id_eb04ec2d; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX order_orderline_order_id_eb04ec2d ON public.order_orderline USING btree (order_id);


--
-- Name: order_orderline_variant_id_866774cb; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX order_orderline_variant_id_866774cb ON public.order_orderline USING btree (variant_id);


--
-- Name: page_page_slug_d6b7c8ed_like; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX page_page_slug_d6b7c8ed_like ON public.page_page USING btree (slug varchar_pattern_ops);


--
-- Name: page_pagetranslation_page_id_60216ef5; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX page_pagetranslation_page_id_60216ef5 ON public.page_pagetranslation USING btree (page_id);


--
-- Name: payment_paymentmethod_checkout_id_5c0aae3d; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX payment_paymentmethod_checkout_id_5c0aae3d ON public.payment_payment USING btree (checkout_id);


--
-- Name: payment_paymentmethod_order_id_58acb979; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX payment_paymentmethod_order_id_58acb979 ON public.payment_payment USING btree (order_id);


--
-- Name: payment_transaction_payment_method_id_d35e75c1; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX payment_transaction_payment_method_id_d35e75c1 ON public.payment_transaction USING btree (payment_id);


--
-- Name: plugins_pluginconfiguration_identifier_3d7349fe_like; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX plugins_pluginconfiguration_identifier_3d7349fe_like ON public.plugins_pluginconfiguration USING btree (identifier varchar_pattern_ops);


--
-- Name: product_assignedproductatt_assignedproductattribute_i_6d497dfa; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX product_assignedproductatt_assignedproductattribute_i_6d497dfa ON public.product_assignedproductattribute_values USING btree (assignedproductattribute_id);


--
-- Name: product_assignedproductatt_attributevalue_id_5bd29b24; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX product_assignedproductatt_attributevalue_id_5bd29b24 ON public.product_assignedproductattribute_values USING btree (attributevalue_id);


--
-- Name: product_assignedproductattribute_assignment_id_eb2f81a4; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX product_assignedproductattribute_assignment_id_eb2f81a4 ON public.product_assignedproductattribute USING btree (assignment_id);


--
-- Name: product_assignedproductattribute_product_id_68be10a3; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX product_assignedproductattribute_product_id_68be10a3 ON public.product_assignedproductattribute USING btree (product_id);


--
-- Name: product_assignedvariantatt_assignedvariantattribute_i_8d6d62ef; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX product_assignedvariantatt_assignedvariantattribute_i_8d6d62ef ON public.product_assignedvariantattribute_values USING btree (assignedvariantattribute_id);


--
-- Name: product_assignedvariantatt_attributevalue_id_41cc2454; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX product_assignedvariantatt_attributevalue_id_41cc2454 ON public.product_assignedvariantattribute_values USING btree (attributevalue_id);


--
-- Name: product_assignedvariantattribute_assignment_id_8fdbffe8; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX product_assignedvariantattribute_assignment_id_8fdbffe8 ON public.product_assignedvariantattribute USING btree (assignment_id);


--
-- Name: product_assignedvariantattribute_variant_id_27483e6a; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX product_assignedvariantattribute_variant_id_27483e6a ON public.product_assignedvariantattribute USING btree (variant_id);


--
-- Name: product_attribute_slug_a2ba35f2_like; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX product_attribute_slug_a2ba35f2_like ON public.product_attribute USING btree (slug varchar_pattern_ops);


--
-- Name: product_attributechoiceval_attribute_choice_value_id_71c4c0a7; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX product_attributechoiceval_attribute_choice_value_id_71c4c0a7 ON public.product_attributevaluetranslation USING btree (attribute_value_id);


--
-- Name: product_attributechoicevalue_attribute_id_c28c6c92; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX product_attributechoicevalue_attribute_id_c28c6c92 ON public.product_attributevalue USING btree (attribute_id);


--
-- Name: product_attributechoicevalue_slug_e0d2d25b; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX product_attributechoicevalue_slug_e0d2d25b ON public.product_attributevalue USING btree (slug);


--
-- Name: product_attributechoicevalue_slug_e0d2d25b_like; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX product_attributechoicevalue_slug_e0d2d25b_like ON public.product_attributevalue USING btree (slug varchar_pattern_ops);


--
-- Name: product_attributechoicevalue_sort_order_c4c071c4; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX product_attributechoicevalue_sort_order_c4c071c4 ON public.product_attributevalue USING btree (sort_order);


--
-- Name: product_attributeproduct_attribute_id_0051c706; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX product_attributeproduct_attribute_id_0051c706 ON public.product_attributeproduct USING btree (attribute_id);


--
-- Name: product_attributeproduct_product_type_id_54357b3b; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX product_attributeproduct_product_type_id_54357b3b ON public.product_attributeproduct USING btree (product_type_id);


--
-- Name: product_attributeproduct_sort_order_cec8a8e2; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX product_attributeproduct_sort_order_cec8a8e2 ON public.product_attributeproduct USING btree (sort_order);


--
-- Name: product_attributevariant_attribute_id_e47d3bc3; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX product_attributevariant_attribute_id_e47d3bc3 ON public.product_attributevariant USING btree (attribute_id);


--
-- Name: product_attributevariant_product_type_id_ba95c6dd; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX product_attributevariant_product_type_id_ba95c6dd ON public.product_attributevariant USING btree (product_type_id);


--
-- Name: product_attributevariant_sort_order_cf4b00ef; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX product_attributevariant_sort_order_cf4b00ef ON public.product_attributevariant USING btree (sort_order);


--
-- Name: product_category_parent_id_f6860923; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX product_category_parent_id_f6860923 ON public.product_category USING btree (parent_id);


--
-- Name: product_category_slug_e1f8ccc4_like; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX product_category_slug_e1f8ccc4_like ON public.product_category USING btree (slug varchar_pattern_ops);


--
-- Name: product_category_tree_id_f3c46461; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX product_category_tree_id_f3c46461 ON public.product_category USING btree (tree_id);


--
-- Name: product_categorytranslation_category_id_aa8d0917; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX product_categorytranslation_category_id_aa8d0917 ON public.product_categorytranslation USING btree (category_id);


--
-- Name: product_collection_name_03bb818b_like; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX product_collection_name_03bb818b_like ON public.product_collection USING btree (name varchar_pattern_ops);


--
-- Name: product_collection_products_collection_id_0bc817dc; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX product_collection_products_collection_id_0bc817dc ON public.product_collectionproduct USING btree (collection_id);


--
-- Name: product_collection_products_product_id_a45a5b06; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX product_collection_products_product_id_a45a5b06 ON public.product_collectionproduct USING btree (product_id);


--
-- Name: product_collection_slug_ec186116_like; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX product_collection_slug_ec186116_like ON public.product_collection USING btree (slug varchar_pattern_ops);


--
-- Name: product_collectionproduct_sort_order_5e7b55bb; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX product_collectionproduct_sort_order_5e7b55bb ON public.product_collectionproduct USING btree (sort_order);


--
-- Name: product_collectiontranslation_collection_id_cfbbd453; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX product_collectiontranslation_collection_id_cfbbd453 ON public.product_collectiontranslation USING btree (collection_id);


--
-- Name: product_digitalcontenturl_content_id_654197bd; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX product_digitalcontenturl_content_id_654197bd ON public.product_digitalcontenturl USING btree (content_id);


--
-- Name: product_pro_search__e78047_gin; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX product_pro_search__e78047_gin ON public.product_product USING gin (search_vector);


--
-- Name: product_product_category_id_0c725779; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX product_product_category_id_0c725779 ON public.product_product USING btree (category_id);


--
-- Name: product_product_product_class_id_0547c998; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX product_product_product_class_id_0547c998 ON public.product_product USING btree (product_type_id);


--
-- Name: product_product_slug_76cde0ae_like; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX product_product_slug_76cde0ae_like ON public.product_product USING btree (slug varchar_pattern_ops);


--
-- Name: product_productattributetr_product_attribute_id_56b48511; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX product_productattributetr_product_attribute_id_56b48511 ON public.product_attributetranslation USING btree (attribute_id);


--
-- Name: product_productimage_product_id_544084bb; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX product_productimage_product_id_544084bb ON public.product_productimage USING btree (product_id);


--
-- Name: product_productimage_sort_order_dfda9c19; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX product_productimage_sort_order_dfda9c19 ON public.product_productimage USING btree (sort_order);


--
-- Name: product_producttranslation_product_id_2c2c7532; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX product_producttranslation_product_id_2c2c7532 ON public.product_producttranslation USING btree (product_id);


--
-- Name: product_producttype_slug_6871faf2_like; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX product_producttype_slug_6871faf2_like ON public.product_producttype USING btree (slug varchar_pattern_ops);


--
-- Name: product_productvariant_product_id_43c5a310; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX product_productvariant_product_id_43c5a310 ON public.product_productvariant USING btree (product_id);


--
-- Name: product_productvariant_sku_50706818_like; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX product_productvariant_sku_50706818_like ON public.product_productvariant USING btree (sku varchar_pattern_ops);


--
-- Name: product_productvariant_sort_order_d4acf89b; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX product_productvariant_sort_order_d4acf89b ON public.product_productvariant USING btree (sort_order);


--
-- Name: product_productvarianttranslation_product_variant_id_1b144a85; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX product_productvarianttranslation_product_variant_id_1b144a85 ON public.product_productvarianttranslation USING btree (product_variant_id);


--
-- Name: product_variantimage_image_id_bef14106; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX product_variantimage_image_id_bef14106 ON public.product_variantimage USING btree (image_id);


--
-- Name: product_variantimage_variant_id_81123814; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX product_variantimage_variant_id_81123814 ON public.product_variantimage USING btree (variant_id);


--
-- Name: shipping_shippingmethod_shipping_zone_id_265b7413; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX shipping_shippingmethod_shipping_zone_id_265b7413 ON public.shipping_shippingmethod USING btree (shipping_zone_id);


--
-- Name: shipping_shippingmethodtranslation_shipping_method_id_31d925d2; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX shipping_shippingmethodtranslation_shipping_method_id_31d925d2 ON public.shipping_shippingmethodtranslation USING btree (shipping_method_id);


--
-- Name: site_authorizationkey_site_settings_id_d8397c0f; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX site_authorizationkey_site_settings_id_d8397c0f ON public.site_authorizationkey USING btree (site_settings_id);


--
-- Name: site_sitesettings_bottom_menu_id_e2a78098; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX site_sitesettings_bottom_menu_id_e2a78098 ON public.site_sitesettings USING btree (bottom_menu_id);


--
-- Name: site_sitesettings_company_address_id_f0825427; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX site_sitesettings_company_address_id_f0825427 ON public.site_sitesettings USING btree (company_address_id);


--
-- Name: site_sitesettings_homepage_collection_id_82f45d33; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX site_sitesettings_homepage_collection_id_82f45d33 ON public.site_sitesettings USING btree (homepage_collection_id);


--
-- Name: site_sitesettings_top_menu_id_ab6f8c46; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX site_sitesettings_top_menu_id_ab6f8c46 ON public.site_sitesettings USING btree (top_menu_id);


--
-- Name: site_sitesettingstranslation_site_settings_id_ca085ff6; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX site_sitesettingstranslation_site_settings_id_ca085ff6 ON public.site_sitesettingstranslation USING btree (site_settings_id);


--
-- Name: userprofile_user_addresses_address_id_ad7646b4; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX userprofile_user_addresses_address_id_ad7646b4 ON public.account_user_addresses USING btree (address_id);


--
-- Name: userprofile_user_addresses_user_id_bb5aa55e; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX userprofile_user_addresses_user_id_bb5aa55e ON public.account_user_addresses USING btree (user_id);


--
-- Name: userprofile_user_default_billing_address_id_0489abf1; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX userprofile_user_default_billing_address_id_0489abf1 ON public.account_user USING btree (default_billing_address_id);


--
-- Name: userprofile_user_default_shipping_address_id_aae7a203; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX userprofile_user_default_shipping_address_id_aae7a203 ON public.account_user USING btree (default_shipping_address_id);


--
-- Name: userprofile_user_email_b0fb0137_like; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX userprofile_user_email_b0fb0137_like ON public.account_user USING btree (email varchar_pattern_ops);


--
-- Name: userprofile_user_groups_group_id_c7eec74e; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX userprofile_user_groups_group_id_c7eec74e ON public.account_user_groups USING btree (group_id);


--
-- Name: userprofile_user_groups_user_id_5e712a24; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX userprofile_user_groups_user_id_5e712a24 ON public.account_user_groups USING btree (user_id);


--
-- Name: userprofile_user_user_permissions_permission_id_1caa8a71; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX userprofile_user_user_permissions_permission_id_1caa8a71 ON public.account_user_user_permissions USING btree (permission_id);


--
-- Name: userprofile_user_user_permissions_user_id_6d654469; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX userprofile_user_user_permissions_user_id_6d654469 ON public.account_user_user_permissions USING btree (user_id);


--
-- Name: warehouse_allocation_order_line_id_693dcb84; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX warehouse_allocation_order_line_id_693dcb84 ON public.warehouse_allocation USING btree (order_line_id);


--
-- Name: warehouse_allocation_stock_id_73541542; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX warehouse_allocation_stock_id_73541542 ON public.warehouse_allocation USING btree (stock_id);


--
-- Name: warehouse_stock_product_variant_id_bea58a82; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX warehouse_stock_product_variant_id_bea58a82 ON public.warehouse_stock USING btree (product_variant_id);


--
-- Name: warehouse_stock_warehouse_id_cc9d4e5d; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX warehouse_stock_warehouse_id_cc9d4e5d ON public.warehouse_stock USING btree (warehouse_id);


--
-- Name: warehouse_warehouse_address_id_d46e1096; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX warehouse_warehouse_address_id_d46e1096 ON public.warehouse_warehouse USING btree (address_id);


--
-- Name: warehouse_warehouse_shipping_zones_shippingzone_id_aeee255b; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX warehouse_warehouse_shipping_zones_shippingzone_id_aeee255b ON public.warehouse_warehouse_shipping_zones USING btree (shippingzone_id);


--
-- Name: warehouse_warehouse_shipping_zones_warehouse_id_fccd6647; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX warehouse_warehouse_shipping_zones_warehouse_id_fccd6647 ON public.warehouse_warehouse_shipping_zones USING btree (warehouse_id);


--
-- Name: warehouse_warehouse_slug_5ca9c575_like; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX warehouse_warehouse_slug_5ca9c575_like ON public.warehouse_warehouse USING btree (slug varchar_pattern_ops);


--
-- Name: webhook_webhook_service_account_id_1073b057; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX webhook_webhook_service_account_id_1073b057 ON public.webhook_webhook USING btree (app_id);


--
-- Name: webhook_webhookevent_event_type_cd6b8c13; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX webhook_webhookevent_event_type_cd6b8c13 ON public.webhook_webhookevent USING btree (event_type);


--
-- Name: webhook_webhookevent_event_type_cd6b8c13_like; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX webhook_webhookevent_event_type_cd6b8c13_like ON public.webhook_webhookevent USING btree (event_type varchar_pattern_ops);


--
-- Name: webhook_webhookevent_webhook_id_73b5c9e1; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX webhook_webhookevent_webhook_id_73b5c9e1 ON public.webhook_webhookevent USING btree (webhook_id);


--
-- Name: wishlist_wishlistitem_product_id_8309716a; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX wishlist_wishlistitem_product_id_8309716a ON public.wishlist_wishlistitem USING btree (product_id);


--
-- Name: wishlist_wishlistitem_variants_productvariant_id_819ee66b; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX wishlist_wishlistitem_variants_productvariant_id_819ee66b ON public.wishlist_wishlistitem_variants USING btree (productvariant_id);


--
-- Name: wishlist_wishlistitem_variants_wishlistitem_id_ee616761; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX wishlist_wishlistitem_variants_wishlistitem_id_ee616761 ON public.wishlist_wishlistitem_variants USING btree (wishlistitem_id);


--
-- Name: wishlist_wishlistitem_wishlist_id_a052b63d; Type: INDEX; Schema: public; Owner: saleor
--

CREATE INDEX wishlist_wishlistitem_wishlist_id_a052b63d ON public.wishlist_wishlistitem USING btree (wishlist_id);


--
-- Name: product_product title_vector_update; Type: TRIGGER; Schema: public; Owner: saleor
--

CREATE TRIGGER title_vector_update BEFORE INSERT OR UPDATE ON public.product_product FOR EACH ROW EXECUTE FUNCTION tsvector_update_trigger('search_vector', 'pg_catalog.english', 'description_plaintext', 'name');


--
-- Name: product_product tsvectorupdate; Type: TRIGGER; Schema: public; Owner: saleor
--

CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE ON public.product_product FOR EACH ROW EXECUTE FUNCTION public.messages_trigger();


--
-- Name: account_customerevent account_customerevent_order_id_2d6e2d20_fk_order_order_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.account_customerevent
    ADD CONSTRAINT account_customerevent_order_id_2d6e2d20_fk_order_order_id FOREIGN KEY (order_id) REFERENCES public.order_order(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: account_customerevent account_customerevent_user_id_b3d6ec36_fk_account_user_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.account_customerevent
    ADD CONSTRAINT account_customerevent_user_id_b3d6ec36_fk_account_user_id FOREIGN KEY (user_id) REFERENCES public.account_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: account_customernote account_customernote_customer_id_ec50cbf6_fk_account_user_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.account_customernote
    ADD CONSTRAINT account_customernote_customer_id_ec50cbf6_fk_account_user_id FOREIGN KEY (customer_id) REFERENCES public.account_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: account_customernote account_customernote_user_id_b10a6c14_fk_account_user_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.account_customernote
    ADD CONSTRAINT account_customernote_user_id_b10a6c14_fk_account_user_id FOREIGN KEY (user_id) REFERENCES public.account_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: account_staffnotificationrecipient account_staffnotific_user_id_538fa3a4_fk_account_u; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.account_staffnotificationrecipient
    ADD CONSTRAINT account_staffnotific_user_id_538fa3a4_fk_account_u FOREIGN KEY (user_id) REFERENCES public.account_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: account_user_addresses account_user_address_address_id_d218822a_fk_account_a; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.account_user_addresses
    ADD CONSTRAINT account_user_address_address_id_d218822a_fk_account_a FOREIGN KEY (address_id) REFERENCES public.account_address(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: account_user_addresses account_user_addresses_user_id_2fcc8301_fk_account_user_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.account_user_addresses
    ADD CONSTRAINT account_user_addresses_user_id_2fcc8301_fk_account_user_id FOREIGN KEY (user_id) REFERENCES public.account_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: app_app_permissions app_app_permissions_app_id_5941597d_fk_app_app_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.app_app_permissions
    ADD CONSTRAINT app_app_permissions_app_id_5941597d_fk_app_app_id FOREIGN KEY (app_id) REFERENCES public.app_app(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: app_app_permissions app_app_permissions_permission_id_defe4a88_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.app_app_permissions
    ADD CONSTRAINT app_app_permissions_permission_id_defe4a88_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: app_appinstallation_permissions app_appinstallation__appinstallation_id_f7fe0271_fk_app_appin; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.app_appinstallation_permissions
    ADD CONSTRAINT app_appinstallation__appinstallation_id_f7fe0271_fk_app_appin FOREIGN KEY (appinstallation_id) REFERENCES public.app_appinstallation(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: app_appinstallation_permissions app_appinstallation__permission_id_4ee9f6c8_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.app_appinstallation_permissions
    ADD CONSTRAINT app_appinstallation__permission_id_4ee9f6c8_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: app_apptoken app_apptoken_app_id_68561141_fk_app_app_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.app_apptoken
    ADD CONSTRAINT app_apptoken_app_id_68561141_fk_app_app_id FOREIGN KEY (app_id) REFERENCES public.app_app(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permissions auth_group_permissio_permission_id_84c5c92e_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissio_permission_id_84c5c92e_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permissions auth_group_permissions_group_id_b120cbf9_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_b120cbf9_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_permission auth_permission_content_type_id_2f476e4b_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_2f476e4b_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: checkout_checkout cart_cart_billing_address_id_9eb62ddd_fk_account_address_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.checkout_checkout
    ADD CONSTRAINT cart_cart_billing_address_id_9eb62ddd_fk_account_address_id FOREIGN KEY (billing_address_id) REFERENCES public.account_address(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: checkout_checkout cart_cart_shipping_address_id_adfddaf9_fk_account_address_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.checkout_checkout
    ADD CONSTRAINT cart_cart_shipping_address_id_adfddaf9_fk_account_address_id FOREIGN KEY (shipping_address_id) REFERENCES public.account_address(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: checkout_checkoutline cart_cartline_variant_id_dbca56c9_fk_product_productvariant_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.checkout_checkoutline
    ADD CONSTRAINT cart_cartline_variant_id_dbca56c9_fk_product_productvariant_id FOREIGN KEY (variant_id) REFERENCES public.product_productvariant(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: checkout_checkoutline checkout_cartline_checkout_id_41d95a5d_fk_checkout_; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.checkout_checkoutline
    ADD CONSTRAINT checkout_cartline_checkout_id_41d95a5d_fk_checkout_ FOREIGN KEY (checkout_id) REFERENCES public.checkout_checkout(token) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: checkout_checkout_gift_cards checkout_checkout_gi_checkout_id_e314728d_fk_checkout_; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.checkout_checkout_gift_cards
    ADD CONSTRAINT checkout_checkout_gi_checkout_id_e314728d_fk_checkout_ FOREIGN KEY (checkout_id) REFERENCES public.checkout_checkout(token) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: checkout_checkout_gift_cards checkout_checkout_gi_giftcard_id_f5994462_fk_giftcard_; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.checkout_checkout_gift_cards
    ADD CONSTRAINT checkout_checkout_gi_giftcard_id_f5994462_fk_giftcard_ FOREIGN KEY (giftcard_id) REFERENCES public.giftcard_giftcard(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: checkout_checkout checkout_checkout_shipping_method_id_8796abd0_fk_shipping_; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.checkout_checkout
    ADD CONSTRAINT checkout_checkout_shipping_method_id_8796abd0_fk_shipping_ FOREIGN KEY (shipping_method_id) REFERENCES public.shipping_shippingmethod(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: checkout_checkout checkout_checkout_user_id_8b2fe298_fk_account_user_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.checkout_checkout
    ADD CONSTRAINT checkout_checkout_user_id_8b2fe298_fk_account_user_id FOREIGN KEY (user_id) REFERENCES public.account_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: csv_exportevent csv_exportevent_app_id_8637fcc5_fk_app_app_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.csv_exportevent
    ADD CONSTRAINT csv_exportevent_app_id_8637fcc5_fk_app_app_id FOREIGN KEY (app_id) REFERENCES public.app_app(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: csv_exportevent csv_exportevent_export_file_id_35f6c448_fk_csv_exportfile_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.csv_exportevent
    ADD CONSTRAINT csv_exportevent_export_file_id_35f6c448_fk_csv_exportfile_id FOREIGN KEY (export_file_id) REFERENCES public.csv_exportfile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: csv_exportevent csv_exportevent_user_id_6111f193_fk_account_user_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.csv_exportevent
    ADD CONSTRAINT csv_exportevent_user_id_6111f193_fk_account_user_id FOREIGN KEY (user_id) REFERENCES public.account_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: csv_exportfile csv_exportfile_app_id_bc900999_fk_app_app_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.csv_exportfile
    ADD CONSTRAINT csv_exportfile_app_id_bc900999_fk_app_app_id FOREIGN KEY (app_id) REFERENCES public.app_app(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: csv_exportfile csv_exportfile_user_id_2c9071e6_fk_account_user_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.csv_exportfile
    ADD CONSTRAINT csv_exportfile_user_id_2c9071e6_fk_account_user_id FOREIGN KEY (user_id) REFERENCES public.account_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: discount_sale_categories discount_sale_catego_category_id_64e132af_fk_product_c; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.discount_sale_categories
    ADD CONSTRAINT discount_sale_catego_category_id_64e132af_fk_product_c FOREIGN KEY (category_id) REFERENCES public.product_category(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: discount_sale_categories discount_sale_categories_sale_id_2aeee4a7_fk_discount_sale_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.discount_sale_categories
    ADD CONSTRAINT discount_sale_categories_sale_id_2aeee4a7_fk_discount_sale_id FOREIGN KEY (sale_id) REFERENCES public.discount_sale(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: discount_sale_collections discount_sale_collec_collection_id_f66df9d7_fk_product_c; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.discount_sale_collections
    ADD CONSTRAINT discount_sale_collec_collection_id_f66df9d7_fk_product_c FOREIGN KEY (collection_id) REFERENCES public.product_collection(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: discount_sale_collections discount_sale_collections_sale_id_a912da4a_fk_discount_sale_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.discount_sale_collections
    ADD CONSTRAINT discount_sale_collections_sale_id_a912da4a_fk_discount_sale_id FOREIGN KEY (sale_id) REFERENCES public.discount_sale(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: discount_sale_products discount_sale_produc_product_id_d42c9636_fk_product_p; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.discount_sale_products
    ADD CONSTRAINT discount_sale_produc_product_id_d42c9636_fk_product_p FOREIGN KEY (product_id) REFERENCES public.product_product(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: discount_sale_products discount_sale_products_sale_id_10e3a20f_fk_discount_sale_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.discount_sale_products
    ADD CONSTRAINT discount_sale_products_sale_id_10e3a20f_fk_discount_sale_id FOREIGN KEY (sale_id) REFERENCES public.discount_sale(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: discount_saletranslation discount_saletranslation_sale_id_36a69b0a_fk_discount_sale_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.discount_saletranslation
    ADD CONSTRAINT discount_saletranslation_sale_id_36a69b0a_fk_discount_sale_id FOREIGN KEY (sale_id) REFERENCES public.discount_sale(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: discount_voucher_categories discount_voucher_cat_category_id_fc9d044a_fk_product_c; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.discount_voucher_categories
    ADD CONSTRAINT discount_voucher_cat_category_id_fc9d044a_fk_product_c FOREIGN KEY (category_id) REFERENCES public.product_category(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: discount_voucher_categories discount_voucher_cat_voucher_id_19a56338_fk_discount_; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.discount_voucher_categories
    ADD CONSTRAINT discount_voucher_cat_voucher_id_19a56338_fk_discount_ FOREIGN KEY (voucher_id) REFERENCES public.discount_voucher(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: discount_voucher_collections discount_voucher_col_collection_id_b9de6b54_fk_product_c; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.discount_voucher_collections
    ADD CONSTRAINT discount_voucher_col_collection_id_b9de6b54_fk_product_c FOREIGN KEY (collection_id) REFERENCES public.product_collection(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: discount_voucher_collections discount_voucher_col_voucher_id_4ce1fde3_fk_discount_; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.discount_voucher_collections
    ADD CONSTRAINT discount_voucher_col_voucher_id_4ce1fde3_fk_discount_ FOREIGN KEY (voucher_id) REFERENCES public.discount_voucher(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: discount_voucher_products discount_voucher_pro_product_id_4a3131ff_fk_product_p; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.discount_voucher_products
    ADD CONSTRAINT discount_voucher_pro_product_id_4a3131ff_fk_product_p FOREIGN KEY (product_id) REFERENCES public.product_product(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: discount_voucher_products discount_voucher_pro_voucher_id_8a2e6c3a_fk_discount_; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.discount_voucher_products
    ADD CONSTRAINT discount_voucher_pro_voucher_id_8a2e6c3a_fk_discount_ FOREIGN KEY (voucher_id) REFERENCES public.discount_voucher(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: discount_vouchercustomer discount_vouchercust_voucher_id_bb55c04f_fk_discount_; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.discount_vouchercustomer
    ADD CONSTRAINT discount_vouchercust_voucher_id_bb55c04f_fk_discount_ FOREIGN KEY (voucher_id) REFERENCES public.discount_voucher(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: discount_vouchertranslation discount_vouchertran_voucher_id_288246a9_fk_discount_; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.discount_vouchertranslation
    ADD CONSTRAINT discount_vouchertran_voucher_id_288246a9_fk_discount_ FOREIGN KEY (voucher_id) REFERENCES public.discount_voucher(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: giftcard_giftcard giftcard_giftcard_user_id_ce2401b5_fk_account_user_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.giftcard_giftcard
    ADD CONSTRAINT giftcard_giftcard_user_id_ce2401b5_fk_account_user_id FOREIGN KEY (user_id) REFERENCES public.account_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: invoice_invoice invoice_invoice_order_id_c5fc9ae9_fk_order_order_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.invoice_invoice
    ADD CONSTRAINT invoice_invoice_order_id_c5fc9ae9_fk_order_order_id FOREIGN KEY (order_id) REFERENCES public.order_order(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: invoice_invoiceevent invoice_invoiceevent_invoice_id_de0632ca_fk_invoice_invoice_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.invoice_invoiceevent
    ADD CONSTRAINT invoice_invoiceevent_invoice_id_de0632ca_fk_invoice_invoice_id FOREIGN KEY (invoice_id) REFERENCES public.invoice_invoice(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: invoice_invoiceevent invoice_invoiceevent_order_id_5a337f7a_fk_order_order_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.invoice_invoiceevent
    ADD CONSTRAINT invoice_invoiceevent_order_id_5a337f7a_fk_order_order_id FOREIGN KEY (order_id) REFERENCES public.order_order(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: invoice_invoiceevent invoice_invoiceevent_user_id_cd599b8d_fk_account_user_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.invoice_invoiceevent
    ADD CONSTRAINT invoice_invoiceevent_user_id_cd599b8d_fk_account_user_id FOREIGN KEY (user_id) REFERENCES public.account_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: menu_menuitem menu_menuitem_category_id_af353a3b_fk_product_category_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.menu_menuitem
    ADD CONSTRAINT menu_menuitem_category_id_af353a3b_fk_product_category_id FOREIGN KEY (category_id) REFERENCES public.product_category(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: menu_menuitem menu_menuitem_collection_id_b913b19e_fk_product_collection_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.menu_menuitem
    ADD CONSTRAINT menu_menuitem_collection_id_b913b19e_fk_product_collection_id FOREIGN KEY (collection_id) REFERENCES public.product_collection(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: menu_menuitem menu_menuitem_menu_id_f466b139_fk_menu_menu_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.menu_menuitem
    ADD CONSTRAINT menu_menuitem_menu_id_f466b139_fk_menu_menu_id FOREIGN KEY (menu_id) REFERENCES public.menu_menu(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: menu_menuitem menu_menuitem_page_id_a0c8f92d_fk_page_page_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.menu_menuitem
    ADD CONSTRAINT menu_menuitem_page_id_a0c8f92d_fk_page_page_id FOREIGN KEY (page_id) REFERENCES public.page_page(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: menu_menuitem menu_menuitem_parent_id_439f55a5_fk_menu_menuitem_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.menu_menuitem
    ADD CONSTRAINT menu_menuitem_parent_id_439f55a5_fk_menu_menuitem_id FOREIGN KEY (parent_id) REFERENCES public.menu_menuitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: menu_menuitemtranslation menu_menuitemtransla_menu_item_id_3445926c_fk_menu_menu; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.menu_menuitemtranslation
    ADD CONSTRAINT menu_menuitemtransla_menu_item_id_3445926c_fk_menu_menu FOREIGN KEY (menu_item_id) REFERENCES public.menu_menuitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: order_fulfillment order_fulfillment_order_id_02695111_fk_order_order_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.order_fulfillment
    ADD CONSTRAINT order_fulfillment_order_id_02695111_fk_order_order_id FOREIGN KEY (order_id) REFERENCES public.order_order(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: order_fulfillmentline order_fulfillmentlin_fulfillment_id_68f3291d_fk_order_ful; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.order_fulfillmentline
    ADD CONSTRAINT order_fulfillmentlin_fulfillment_id_68f3291d_fk_order_ful FOREIGN KEY (fulfillment_id) REFERENCES public.order_fulfillment(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: order_fulfillmentline order_fulfillmentlin_order_line_id_7d40e054_fk_order_ord; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.order_fulfillmentline
    ADD CONSTRAINT order_fulfillmentlin_order_line_id_7d40e054_fk_order_ord FOREIGN KEY (order_line_id) REFERENCES public.order_orderline(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: order_fulfillmentline order_fulfillmentline_stock_id_da5a99fe_fk_warehouse_stock_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.order_fulfillmentline
    ADD CONSTRAINT order_fulfillmentline_stock_id_da5a99fe_fk_warehouse_stock_id FOREIGN KEY (stock_id) REFERENCES public.warehouse_stock(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: order_order order_order_billing_address_id_8fe537cf_fk_userprofi; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.order_order
    ADD CONSTRAINT order_order_billing_address_id_8fe537cf_fk_userprofi FOREIGN KEY (billing_address_id) REFERENCES public.account_address(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: order_order_gift_cards order_order_gift_car_giftcard_id_f6844926_fk_giftcard_; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.order_order_gift_cards
    ADD CONSTRAINT order_order_gift_car_giftcard_id_f6844926_fk_giftcard_ FOREIGN KEY (giftcard_id) REFERENCES public.giftcard_giftcard(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: order_order_gift_cards order_order_gift_cards_order_id_ce5608c4_fk_order_order_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.order_order_gift_cards
    ADD CONSTRAINT order_order_gift_cards_order_id_ce5608c4_fk_order_order_id FOREIGN KEY (order_id) REFERENCES public.order_order(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: order_order order_order_shipping_address_id_57e64931_fk_userprofi; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.order_order
    ADD CONSTRAINT order_order_shipping_address_id_57e64931_fk_userprofi FOREIGN KEY (shipping_address_id) REFERENCES public.account_address(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: order_order order_order_shipping_method_id_2a742834_fk_shipping_; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.order_order
    ADD CONSTRAINT order_order_shipping_method_id_2a742834_fk_shipping_ FOREIGN KEY (shipping_method_id) REFERENCES public.shipping_shippingmethod(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: order_order order_order_user_id_7cf9bc2b_fk_userprofile_user_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.order_order
    ADD CONSTRAINT order_order_user_id_7cf9bc2b_fk_userprofile_user_id FOREIGN KEY (user_id) REFERENCES public.account_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: order_order order_order_voucher_id_0748ca22_fk_discount_voucher_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.order_order
    ADD CONSTRAINT order_order_voucher_id_0748ca22_fk_discount_voucher_id FOREIGN KEY (voucher_id) REFERENCES public.discount_voucher(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: order_orderevent order_orderevent_order_id_09aa7ccd_fk_order_order_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.order_orderevent
    ADD CONSTRAINT order_orderevent_order_id_09aa7ccd_fk_order_order_id FOREIGN KEY (order_id) REFERENCES public.order_order(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: order_orderevent order_orderevent_user_id_1056ac9c_fk_userprofile_user_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.order_orderevent
    ADD CONSTRAINT order_orderevent_user_id_1056ac9c_fk_userprofile_user_id FOREIGN KEY (user_id) REFERENCES public.account_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: order_orderline order_orderline_order_id_eb04ec2d_fk_order_order_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.order_orderline
    ADD CONSTRAINT order_orderline_order_id_eb04ec2d_fk_order_order_id FOREIGN KEY (order_id) REFERENCES public.order_order(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: order_orderline order_orderline_variant_id_866774cb_fk_product_p; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.order_orderline
    ADD CONSTRAINT order_orderline_variant_id_866774cb_fk_product_p FOREIGN KEY (variant_id) REFERENCES public.product_productvariant(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: page_pagetranslation page_pagetranslation_page_id_60216ef5_fk_page_page_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.page_pagetranslation
    ADD CONSTRAINT page_pagetranslation_page_id_60216ef5_fk_page_page_id FOREIGN KEY (page_id) REFERENCES public.page_page(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: payment_payment payment_payment_checkout_id_1f32e1ab_fk_checkout_checkout_token; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.payment_payment
    ADD CONSTRAINT payment_payment_checkout_id_1f32e1ab_fk_checkout_checkout_token FOREIGN KEY (checkout_id) REFERENCES public.checkout_checkout(token) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: payment_payment payment_payment_order_id_22b45881_fk_order_order_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.payment_payment
    ADD CONSTRAINT payment_payment_order_id_22b45881_fk_order_order_id FOREIGN KEY (order_id) REFERENCES public.order_order(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: payment_transaction payment_transaction_payment_id_df9808d7_fk_payment_payment_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.payment_transaction
    ADD CONSTRAINT payment_transaction_payment_id_df9808d7_fk_payment_payment_id FOREIGN KEY (payment_id) REFERENCES public.payment_payment(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: product_assignedproductattribute_values product_assignedprod_assignedproductattri_6d497dfa_fk_product_a; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_assignedproductattribute_values
    ADD CONSTRAINT product_assignedprod_assignedproductattri_6d497dfa_fk_product_a FOREIGN KEY (assignedproductattribute_id) REFERENCES public.product_assignedproductattribute(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: product_assignedproductattribute product_assignedprod_assignment_id_eb2f81a4_fk_product_a; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_assignedproductattribute
    ADD CONSTRAINT product_assignedprod_assignment_id_eb2f81a4_fk_product_a FOREIGN KEY (assignment_id) REFERENCES public.product_attributeproduct(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: product_assignedproductattribute_values product_assignedprod_attributevalue_id_5bd29b24_fk_product_a; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_assignedproductattribute_values
    ADD CONSTRAINT product_assignedprod_attributevalue_id_5bd29b24_fk_product_a FOREIGN KEY (attributevalue_id) REFERENCES public.product_attributevalue(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: product_assignedproductattribute product_assignedprod_product_id_68be10a3_fk_product_p; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_assignedproductattribute
    ADD CONSTRAINT product_assignedprod_product_id_68be10a3_fk_product_p FOREIGN KEY (product_id) REFERENCES public.product_product(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: product_assignedvariantattribute_values product_assignedvari_assignedvariantattri_8d6d62ef_fk_product_a; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_assignedvariantattribute_values
    ADD CONSTRAINT product_assignedvari_assignedvariantattri_8d6d62ef_fk_product_a FOREIGN KEY (assignedvariantattribute_id) REFERENCES public.product_assignedvariantattribute(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: product_assignedvariantattribute product_assignedvari_assignment_id_8fdbffe8_fk_product_a; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_assignedvariantattribute
    ADD CONSTRAINT product_assignedvari_assignment_id_8fdbffe8_fk_product_a FOREIGN KEY (assignment_id) REFERENCES public.product_attributevariant(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: product_assignedvariantattribute_values product_assignedvari_attributevalue_id_41cc2454_fk_product_a; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_assignedvariantattribute_values
    ADD CONSTRAINT product_assignedvari_attributevalue_id_41cc2454_fk_product_a FOREIGN KEY (attributevalue_id) REFERENCES public.product_attributevalue(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: product_assignedvariantattribute product_assignedvari_variant_id_27483e6a_fk_product_p; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_assignedvariantattribute
    ADD CONSTRAINT product_assignedvari_variant_id_27483e6a_fk_product_p FOREIGN KEY (variant_id) REFERENCES public.product_productvariant(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: product_attributevalue product_attributecho_attribute_id_c28c6c92_fk_product_a; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_attributevalue
    ADD CONSTRAINT product_attributecho_attribute_id_c28c6c92_fk_product_a FOREIGN KEY (attribute_id) REFERENCES public.product_attribute(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: product_attributeproduct product_attributepro_attribute_id_0051c706_fk_product_a; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_attributeproduct
    ADD CONSTRAINT product_attributepro_attribute_id_0051c706_fk_product_a FOREIGN KEY (attribute_id) REFERENCES public.product_attribute(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: product_attributeproduct product_attributepro_product_type_id_54357b3b_fk_product_p; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_attributeproduct
    ADD CONSTRAINT product_attributepro_product_type_id_54357b3b_fk_product_p FOREIGN KEY (product_type_id) REFERENCES public.product_producttype(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: product_attributetranslation product_attributetra_attribute_id_238dabfc_fk_product_a; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_attributetranslation
    ADD CONSTRAINT product_attributetra_attribute_id_238dabfc_fk_product_a FOREIGN KEY (attribute_id) REFERENCES public.product_attribute(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: product_attributevaluetranslation product_attributeval_attribute_value_id_8b2cb275_fk_product_a; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_attributevaluetranslation
    ADD CONSTRAINT product_attributeval_attribute_value_id_8b2cb275_fk_product_a FOREIGN KEY (attribute_value_id) REFERENCES public.product_attributevalue(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: product_attributevariant product_attributevar_attribute_id_e47d3bc3_fk_product_a; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_attributevariant
    ADD CONSTRAINT product_attributevar_attribute_id_e47d3bc3_fk_product_a FOREIGN KEY (attribute_id) REFERENCES public.product_attribute(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: product_attributevariant product_attributevar_product_type_id_ba95c6dd_fk_product_p; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_attributevariant
    ADD CONSTRAINT product_attributevar_product_type_id_ba95c6dd_fk_product_p FOREIGN KEY (product_type_id) REFERENCES public.product_producttype(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: product_category product_category_parent_id_f6860923_fk_product_category_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_category
    ADD CONSTRAINT product_category_parent_id_f6860923_fk_product_category_id FOREIGN KEY (parent_id) REFERENCES public.product_category(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: product_categorytranslation product_categorytran_category_id_aa8d0917_fk_product_c; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_categorytranslation
    ADD CONSTRAINT product_categorytran_category_id_aa8d0917_fk_product_c FOREIGN KEY (category_id) REFERENCES public.product_category(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: product_collectionproduct product_collection_p_collection_id_0bc817dc_fk_product_c; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_collectionproduct
    ADD CONSTRAINT product_collection_p_collection_id_0bc817dc_fk_product_c FOREIGN KEY (collection_id) REFERENCES public.product_collection(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: product_collectionproduct product_collection_p_product_id_a45a5b06_fk_product_p; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_collectionproduct
    ADD CONSTRAINT product_collection_p_product_id_a45a5b06_fk_product_p FOREIGN KEY (product_id) REFERENCES public.product_product(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: product_collectiontranslation product_collectiontr_collection_id_cfbbd453_fk_product_c; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_collectiontranslation
    ADD CONSTRAINT product_collectiontr_collection_id_cfbbd453_fk_product_c FOREIGN KEY (collection_id) REFERENCES public.product_collection(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: product_digitalcontenturl product_digitalconte_content_id_654197bd_fk_product_d; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_digitalcontenturl
    ADD CONSTRAINT product_digitalconte_content_id_654197bd_fk_product_d FOREIGN KEY (content_id) REFERENCES public.product_digitalcontent(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: product_digitalcontenturl product_digitalconte_line_id_82056694_fk_order_ord; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_digitalcontenturl
    ADD CONSTRAINT product_digitalconte_line_id_82056694_fk_order_ord FOREIGN KEY (line_id) REFERENCES public.order_orderline(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: product_digitalcontent product_digitalconte_product_variant_id_211462a5_fk_product_p; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_digitalcontent
    ADD CONSTRAINT product_digitalconte_product_variant_id_211462a5_fk_product_p FOREIGN KEY (product_variant_id) REFERENCES public.product_productvariant(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: product_product product_product_category_id_0c725779_fk_product_category_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_product
    ADD CONSTRAINT product_product_category_id_0c725779_fk_product_category_id FOREIGN KEY (category_id) REFERENCES public.product_category(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: product_product product_product_default_variant_id_bce7dabb_fk_product_p; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_product
    ADD CONSTRAINT product_product_default_variant_id_bce7dabb_fk_product_p FOREIGN KEY (default_variant_id) REFERENCES public.product_productvariant(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: product_product product_product_product_type_id_4bfbbfda_fk_product_p; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_product
    ADD CONSTRAINT product_product_product_type_id_4bfbbfda_fk_product_p FOREIGN KEY (product_type_id) REFERENCES public.product_producttype(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: product_productimage product_productimage_product_id_544084bb_fk_product_product_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_productimage
    ADD CONSTRAINT product_productimage_product_id_544084bb_fk_product_product_id FOREIGN KEY (product_id) REFERENCES public.product_product(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: product_producttranslation product_producttrans_product_id_2c2c7532_fk_product_p; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_producttranslation
    ADD CONSTRAINT product_producttrans_product_id_2c2c7532_fk_product_p FOREIGN KEY (product_id) REFERENCES public.product_product(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: product_productvariant product_productvaria_product_id_43c5a310_fk_product_p; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_productvariant
    ADD CONSTRAINT product_productvaria_product_id_43c5a310_fk_product_p FOREIGN KEY (product_id) REFERENCES public.product_product(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: product_productvarianttranslation product_productvaria_product_variant_id_1b144a85_fk_product_p; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_productvarianttranslation
    ADD CONSTRAINT product_productvaria_product_variant_id_1b144a85_fk_product_p FOREIGN KEY (product_variant_id) REFERENCES public.product_productvariant(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: product_variantimage product_variantimage_image_id_bef14106_fk_product_p; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_variantimage
    ADD CONSTRAINT product_variantimage_image_id_bef14106_fk_product_p FOREIGN KEY (image_id) REFERENCES public.product_productimage(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: product_variantimage product_variantimage_variant_id_81123814_fk_product_p; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.product_variantimage
    ADD CONSTRAINT product_variantimage_variant_id_81123814_fk_product_p FOREIGN KEY (variant_id) REFERENCES public.product_productvariant(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: shipping_shippingmethodtranslation shipping_shippingmet_shipping_method_id_31d925d2_fk_shipping_; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.shipping_shippingmethodtranslation
    ADD CONSTRAINT shipping_shippingmet_shipping_method_id_31d925d2_fk_shipping_ FOREIGN KEY (shipping_method_id) REFERENCES public.shipping_shippingmethod(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: shipping_shippingmethod shipping_shippingmet_shipping_zone_id_265b7413_fk_shipping_; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.shipping_shippingmethod
    ADD CONSTRAINT shipping_shippingmet_shipping_zone_id_265b7413_fk_shipping_ FOREIGN KEY (shipping_zone_id) REFERENCES public.shipping_shippingzone(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: site_authorizationkey site_authorizationke_site_settings_id_d8397c0f_fk_site_site; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.site_authorizationkey
    ADD CONSTRAINT site_authorizationke_site_settings_id_d8397c0f_fk_site_site FOREIGN KEY (site_settings_id) REFERENCES public.site_sitesettings(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: site_sitesettings site_sitesettings_bottom_menu_id_e2a78098_fk_menu_menu_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.site_sitesettings
    ADD CONSTRAINT site_sitesettings_bottom_menu_id_e2a78098_fk_menu_menu_id FOREIGN KEY (bottom_menu_id) REFERENCES public.menu_menu(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: site_sitesettings site_sitesettings_company_address_id_f0825427_fk_account_a; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.site_sitesettings
    ADD CONSTRAINT site_sitesettings_company_address_id_f0825427_fk_account_a FOREIGN KEY (company_address_id) REFERENCES public.account_address(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: site_sitesettings site_sitesettings_homepage_collection__82f45d33_fk_product_c; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.site_sitesettings
    ADD CONSTRAINT site_sitesettings_homepage_collection__82f45d33_fk_product_c FOREIGN KEY (homepage_collection_id) REFERENCES public.product_collection(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: site_sitesettings site_sitesettings_site_id_64dd8ff8_fk_django_site_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.site_sitesettings
    ADD CONSTRAINT site_sitesettings_site_id_64dd8ff8_fk_django_site_id FOREIGN KEY (site_id) REFERENCES public.django_site(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: site_sitesettings site_sitesettings_top_menu_id_ab6f8c46_fk_menu_menu_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.site_sitesettings
    ADD CONSTRAINT site_sitesettings_top_menu_id_ab6f8c46_fk_menu_menu_id FOREIGN KEY (top_menu_id) REFERENCES public.menu_menu(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: site_sitesettingstranslation site_sitesettingstra_site_settings_id_ca085ff6_fk_site_site; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.site_sitesettingstranslation
    ADD CONSTRAINT site_sitesettingstra_site_settings_id_ca085ff6_fk_site_site FOREIGN KEY (site_settings_id) REFERENCES public.site_sitesettings(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: account_user userprofile_user_default_billing_addr_0489abf1_fk_userprofi; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.account_user
    ADD CONSTRAINT userprofile_user_default_billing_addr_0489abf1_fk_userprofi FOREIGN KEY (default_billing_address_id) REFERENCES public.account_address(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: account_user userprofile_user_default_shipping_add_aae7a203_fk_userprofi; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.account_user
    ADD CONSTRAINT userprofile_user_default_shipping_add_aae7a203_fk_userprofi FOREIGN KEY (default_shipping_address_id) REFERENCES public.account_address(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: account_user_groups userprofile_user_groups_group_id_c7eec74e_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.account_user_groups
    ADD CONSTRAINT userprofile_user_groups_group_id_c7eec74e_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: account_user_groups userprofile_user_groups_user_id_5e712a24_fk_userprofile_user_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.account_user_groups
    ADD CONSTRAINT userprofile_user_groups_user_id_5e712a24_fk_userprofile_user_id FOREIGN KEY (user_id) REFERENCES public.account_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: account_user_user_permissions userprofile_user_use_permission_id_1caa8a71_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.account_user_user_permissions
    ADD CONSTRAINT userprofile_user_use_permission_id_1caa8a71_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: account_user_user_permissions userprofile_user_use_user_id_6d654469_fk_userprofi; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.account_user_user_permissions
    ADD CONSTRAINT userprofile_user_use_user_id_6d654469_fk_userprofi FOREIGN KEY (user_id) REFERENCES public.account_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: warehouse_allocation warehouse_allocation_order_line_id_693dcb84_fk_order_ord; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.warehouse_allocation
    ADD CONSTRAINT warehouse_allocation_order_line_id_693dcb84_fk_order_ord FOREIGN KEY (order_line_id) REFERENCES public.order_orderline(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: warehouse_allocation warehouse_allocation_stock_id_73541542_fk_warehouse_stock_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.warehouse_allocation
    ADD CONSTRAINT warehouse_allocation_stock_id_73541542_fk_warehouse_stock_id FOREIGN KEY (stock_id) REFERENCES public.warehouse_stock(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: warehouse_stock warehouse_stock_product_variant_id_bea58a82_fk_product_p; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.warehouse_stock
    ADD CONSTRAINT warehouse_stock_product_variant_id_bea58a82_fk_product_p FOREIGN KEY (product_variant_id) REFERENCES public.product_productvariant(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: warehouse_stock warehouse_stock_warehouse_id_cc9d4e5d_fk_warehouse_warehouse_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.warehouse_stock
    ADD CONSTRAINT warehouse_stock_warehouse_id_cc9d4e5d_fk_warehouse_warehouse_id FOREIGN KEY (warehouse_id) REFERENCES public.warehouse_warehouse(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: warehouse_warehouse_shipping_zones warehouse_warehouse__shippingzone_id_aeee255b_fk_shipping_; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.warehouse_warehouse_shipping_zones
    ADD CONSTRAINT warehouse_warehouse__shippingzone_id_aeee255b_fk_shipping_ FOREIGN KEY (shippingzone_id) REFERENCES public.shipping_shippingzone(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: warehouse_warehouse_shipping_zones warehouse_warehouse__warehouse_id_fccd6647_fk_warehouse; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.warehouse_warehouse_shipping_zones
    ADD CONSTRAINT warehouse_warehouse__warehouse_id_fccd6647_fk_warehouse FOREIGN KEY (warehouse_id) REFERENCES public.warehouse_warehouse(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: warehouse_warehouse warehouse_warehouse_address_id_d46e1096_fk_account_address_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.warehouse_warehouse
    ADD CONSTRAINT warehouse_warehouse_address_id_d46e1096_fk_account_address_id FOREIGN KEY (address_id) REFERENCES public.account_address(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: webhook_webhook webhook_webhook_app_id_604d7610_fk_app_app_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.webhook_webhook
    ADD CONSTRAINT webhook_webhook_app_id_604d7610_fk_app_app_id FOREIGN KEY (app_id) REFERENCES public.app_app(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: webhook_webhookevent webhook_webhookevent_webhook_id_73b5c9e1_fk_webhook_webhook_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.webhook_webhookevent
    ADD CONSTRAINT webhook_webhookevent_webhook_id_73b5c9e1_fk_webhook_webhook_id FOREIGN KEY (webhook_id) REFERENCES public.webhook_webhook(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: wishlist_wishlist wishlist_wishlist_user_id_13f28b16_fk_account_user_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.wishlist_wishlist
    ADD CONSTRAINT wishlist_wishlist_user_id_13f28b16_fk_account_user_id FOREIGN KEY (user_id) REFERENCES public.account_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: wishlist_wishlistitem_variants wishlist_wishlistite_productvariant_id_819ee66b_fk_product_p; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.wishlist_wishlistitem_variants
    ADD CONSTRAINT wishlist_wishlistite_productvariant_id_819ee66b_fk_product_p FOREIGN KEY (productvariant_id) REFERENCES public.product_productvariant(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: wishlist_wishlistitem wishlist_wishlistite_wishlist_id_a052b63d_fk_wishlist_; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.wishlist_wishlistitem
    ADD CONSTRAINT wishlist_wishlistite_wishlist_id_a052b63d_fk_wishlist_ FOREIGN KEY (wishlist_id) REFERENCES public.wishlist_wishlist(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: wishlist_wishlistitem_variants wishlist_wishlistite_wishlistitem_id_ee616761_fk_wishlist_; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.wishlist_wishlistitem_variants
    ADD CONSTRAINT wishlist_wishlistite_wishlistitem_id_ee616761_fk_wishlist_ FOREIGN KEY (wishlistitem_id) REFERENCES public.wishlist_wishlistitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: wishlist_wishlistitem wishlist_wishlistitem_product_id_8309716a_fk_product_product_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
--

ALTER TABLE ONLY public.wishlist_wishlistitem
    ADD CONSTRAINT wishlist_wishlistitem_product_id_8309716a_fk_product_product_id FOREIGN KEY (product_id) REFERENCES public.product_product(id) DEFERRABLE INITIALLY DEFERRED;


--
-- PostgreSQL database dump complete
--

