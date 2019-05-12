--
-- PostgreSQL database dump
--

-- Dumped from database version 11.2
-- Dumped by pg_dump version 11.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'SQL_ASCII';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: oc_accounts; Type: TABLE; Schema: public; Owner: oc_gingertech3
--

CREATE TABLE public.oc_accounts (
    uid character varying(64) DEFAULT ''::character varying NOT NULL,
    data text DEFAULT ''::text NOT NULL
);


ALTER TABLE public.oc_accounts OWNER TO oc_gingertech3;

--
-- Name: oc_activity; Type: TABLE; Schema: public; Owner: oc_gingertech3
--

CREATE TABLE public.oc_activity (
    activity_id bigint NOT NULL,
    "timestamp" integer DEFAULT 0 NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    type character varying(255) DEFAULT NULL::character varying,
    "user" character varying(64) DEFAULT NULL::character varying,
    affecteduser character varying(64) NOT NULL,
    app character varying(32) NOT NULL,
    subject character varying(255) NOT NULL,
    subjectparams text NOT NULL,
    message character varying(255) DEFAULT NULL::character varying,
    messageparams text,
    file character varying(4000) DEFAULT NULL::character varying,
    link character varying(4000) DEFAULT NULL::character varying,
    object_type character varying(255) DEFAULT NULL::character varying,
    object_id bigint DEFAULT 0 NOT NULL
);


ALTER TABLE public.oc_activity OWNER TO oc_gingertech3;

--
-- Name: oc_activity_activity_id_seq; Type: SEQUENCE; Schema: public; Owner: oc_gingertech3
--

CREATE SEQUENCE public.oc_activity_activity_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.oc_activity_activity_id_seq OWNER TO oc_gingertech3;

--
-- Name: oc_activity_activity_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: oc_gingertech3
--

ALTER SEQUENCE public.oc_activity_activity_id_seq OWNED BY public.oc_activity.activity_id;


--
-- Name: oc_activity_mq; Type: TABLE; Schema: public; Owner: oc_gingertech3
--

CREATE TABLE public.oc_activity_mq (
    mail_id bigint NOT NULL,
    amq_timestamp integer DEFAULT 0 NOT NULL,
    amq_latest_send integer DEFAULT 0 NOT NULL,
    amq_type character varying(255) NOT NULL,
    amq_affecteduser character varying(64) NOT NULL,
    amq_appid character varying(255) NOT NULL,
    amq_subject character varying(255) NOT NULL,
    amq_subjectparams character varying(4000) NOT NULL,
    object_type character varying(255) DEFAULT NULL::character varying,
    object_id bigint DEFAULT 0 NOT NULL
);


ALTER TABLE public.oc_activity_mq OWNER TO oc_gingertech3;

--
-- Name: oc_activity_mq_mail_id_seq; Type: SEQUENCE; Schema: public; Owner: oc_gingertech3
--

CREATE SEQUENCE public.oc_activity_mq_mail_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.oc_activity_mq_mail_id_seq OWNER TO oc_gingertech3;

--
-- Name: oc_activity_mq_mail_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: oc_gingertech3
--

ALTER SEQUENCE public.oc_activity_mq_mail_id_seq OWNED BY public.oc_activity_mq.mail_id;


--
-- Name: oc_addressbookchanges; Type: TABLE; Schema: public; Owner: oc_gingertech3
--

CREATE TABLE public.oc_addressbookchanges (
    id bigint NOT NULL,
    uri character varying(255) DEFAULT NULL::character varying,
    synctoken integer DEFAULT 1 NOT NULL,
    addressbookid bigint NOT NULL,
    operation smallint NOT NULL
);


ALTER TABLE public.oc_addressbookchanges OWNER TO oc_gingertech3;

--
-- Name: oc_addressbookchanges_id_seq; Type: SEQUENCE; Schema: public; Owner: oc_gingertech3
--

CREATE SEQUENCE public.oc_addressbookchanges_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.oc_addressbookchanges_id_seq OWNER TO oc_gingertech3;

--
-- Name: oc_addressbookchanges_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: oc_gingertech3
--

ALTER SEQUENCE public.oc_addressbookchanges_id_seq OWNED BY public.oc_addressbookchanges.id;


--
-- Name: oc_addressbooks; Type: TABLE; Schema: public; Owner: oc_gingertech3
--

CREATE TABLE public.oc_addressbooks (
    id bigint NOT NULL,
    principaluri character varying(255) DEFAULT NULL::character varying,
    displayname character varying(255) DEFAULT NULL::character varying,
    uri character varying(255) DEFAULT NULL::character varying,
    description character varying(255) DEFAULT NULL::character varying,
    synctoken integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.oc_addressbooks OWNER TO oc_gingertech3;

--
-- Name: oc_addressbooks_id_seq; Type: SEQUENCE; Schema: public; Owner: oc_gingertech3
--

CREATE SEQUENCE public.oc_addressbooks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.oc_addressbooks_id_seq OWNER TO oc_gingertech3;

--
-- Name: oc_addressbooks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: oc_gingertech3
--

ALTER SEQUENCE public.oc_addressbooks_id_seq OWNED BY public.oc_addressbooks.id;


--
-- Name: oc_appconfig; Type: TABLE; Schema: public; Owner: oc_gingertech3
--

CREATE TABLE public.oc_appconfig (
    appid character varying(32) DEFAULT ''::character varying NOT NULL,
    configkey character varying(64) DEFAULT ''::character varying NOT NULL,
    configvalue text
);


ALTER TABLE public.oc_appconfig OWNER TO oc_gingertech3;

--
-- Name: oc_authtoken; Type: TABLE; Schema: public; Owner: oc_gingertech3
--

CREATE TABLE public.oc_authtoken (
    id bigint NOT NULL,
    uid character varying(64) DEFAULT ''::character varying NOT NULL,
    login_name character varying(64) DEFAULT ''::character varying NOT NULL,
    password text,
    name text DEFAULT ''::text NOT NULL,
    token character varying(200) DEFAULT ''::character varying NOT NULL,
    type smallint DEFAULT 0 NOT NULL,
    remember smallint DEFAULT 0 NOT NULL,
    last_activity integer DEFAULT 0 NOT NULL,
    last_check integer DEFAULT 0 NOT NULL,
    scope text,
    expires integer,
    private_key text,
    public_key text,
    version smallint DEFAULT 1 NOT NULL,
    password_invalid boolean DEFAULT false NOT NULL
);


ALTER TABLE public.oc_authtoken OWNER TO oc_gingertech3;

--
-- Name: oc_authtoken_id_seq; Type: SEQUENCE; Schema: public; Owner: oc_gingertech3
--

CREATE SEQUENCE public.oc_authtoken_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.oc_authtoken_id_seq OWNER TO oc_gingertech3;

--
-- Name: oc_authtoken_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: oc_gingertech3
--

ALTER SEQUENCE public.oc_authtoken_id_seq OWNED BY public.oc_authtoken.id;


--
-- Name: oc_bruteforce_attempts; Type: TABLE; Schema: public; Owner: oc_gingertech3
--

CREATE TABLE public.oc_bruteforce_attempts (
    id bigint NOT NULL,
    action character varying(64) DEFAULT ''::character varying NOT NULL,
    occurred integer DEFAULT 0 NOT NULL,
    ip character varying(255) DEFAULT ''::character varying NOT NULL,
    subnet character varying(255) DEFAULT ''::character varying NOT NULL,
    metadata character varying(255) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.oc_bruteforce_attempts OWNER TO oc_gingertech3;

--
-- Name: oc_bruteforce_attempts_id_seq; Type: SEQUENCE; Schema: public; Owner: oc_gingertech3
--

CREATE SEQUENCE public.oc_bruteforce_attempts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.oc_bruteforce_attempts_id_seq OWNER TO oc_gingertech3;

--
-- Name: oc_bruteforce_attempts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: oc_gingertech3
--

ALTER SEQUENCE public.oc_bruteforce_attempts_id_seq OWNED BY public.oc_bruteforce_attempts.id;


--
-- Name: oc_calendar_invitations; Type: TABLE; Schema: public; Owner: oc_gingertech3
--

CREATE TABLE public.oc_calendar_invitations (
    id bigint NOT NULL,
    uid character varying(255) NOT NULL,
    recurrenceid character varying(255) DEFAULT NULL::character varying,
    attendee character varying(255) NOT NULL,
    organizer character varying(255) NOT NULL,
    sequence bigint,
    token character varying(60) NOT NULL,
    expiration bigint NOT NULL
);


ALTER TABLE public.oc_calendar_invitations OWNER TO oc_gingertech3;

--
-- Name: oc_calendar_invitations_id_seq; Type: SEQUENCE; Schema: public; Owner: oc_gingertech3
--

CREATE SEQUENCE public.oc_calendar_invitations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.oc_calendar_invitations_id_seq OWNER TO oc_gingertech3;

--
-- Name: oc_calendar_invitations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: oc_gingertech3
--

ALTER SEQUENCE public.oc_calendar_invitations_id_seq OWNED BY public.oc_calendar_invitations.id;


--
-- Name: oc_calendar_resources; Type: TABLE; Schema: public; Owner: oc_gingertech3
--

CREATE TABLE public.oc_calendar_resources (
    id bigint NOT NULL,
    backend_id character varying(64) DEFAULT NULL::character varying,
    resource_id character varying(64) DEFAULT NULL::character varying,
    email character varying(255) DEFAULT NULL::character varying,
    displayname character varying(255) DEFAULT NULL::character varying,
    group_restrictions character varying(4000) DEFAULT NULL::character varying
);


ALTER TABLE public.oc_calendar_resources OWNER TO oc_gingertech3;

--
-- Name: oc_calendar_resources_id_seq; Type: SEQUENCE; Schema: public; Owner: oc_gingertech3
--

CREATE SEQUENCE public.oc_calendar_resources_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.oc_calendar_resources_id_seq OWNER TO oc_gingertech3;

--
-- Name: oc_calendar_resources_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: oc_gingertech3
--

ALTER SEQUENCE public.oc_calendar_resources_id_seq OWNED BY public.oc_calendar_resources.id;


--
-- Name: oc_calendar_rooms; Type: TABLE; Schema: public; Owner: oc_gingertech3
--

CREATE TABLE public.oc_calendar_rooms (
    id bigint NOT NULL,
    backend_id character varying(64) DEFAULT NULL::character varying,
    resource_id character varying(64) DEFAULT NULL::character varying,
    email character varying(255) DEFAULT NULL::character varying,
    displayname character varying(255) DEFAULT NULL::character varying,
    group_restrictions character varying(4000) DEFAULT NULL::character varying
);


ALTER TABLE public.oc_calendar_rooms OWNER TO oc_gingertech3;

--
-- Name: oc_calendar_rooms_id_seq; Type: SEQUENCE; Schema: public; Owner: oc_gingertech3
--

CREATE SEQUENCE public.oc_calendar_rooms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.oc_calendar_rooms_id_seq OWNER TO oc_gingertech3;

--
-- Name: oc_calendar_rooms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: oc_gingertech3
--

ALTER SEQUENCE public.oc_calendar_rooms_id_seq OWNED BY public.oc_calendar_rooms.id;


--
-- Name: oc_calendarchanges; Type: TABLE; Schema: public; Owner: oc_gingertech3
--

CREATE TABLE public.oc_calendarchanges (
    id bigint NOT NULL,
    uri character varying(255) DEFAULT NULL::character varying,
    synctoken integer DEFAULT 1 NOT NULL,
    calendarid bigint NOT NULL,
    operation smallint NOT NULL,
    calendartype integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.oc_calendarchanges OWNER TO oc_gingertech3;

--
-- Name: oc_calendarchanges_id_seq; Type: SEQUENCE; Schema: public; Owner: oc_gingertech3
--

CREATE SEQUENCE public.oc_calendarchanges_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.oc_calendarchanges_id_seq OWNER TO oc_gingertech3;

--
-- Name: oc_calendarchanges_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: oc_gingertech3
--

ALTER SEQUENCE public.oc_calendarchanges_id_seq OWNED BY public.oc_calendarchanges.id;


--
-- Name: oc_calendarobjects; Type: TABLE; Schema: public; Owner: oc_gingertech3
--

CREATE TABLE public.oc_calendarobjects (
    id bigint NOT NULL,
    calendardata bytea,
    uri character varying(255) DEFAULT NULL::character varying,
    calendarid bigint NOT NULL,
    lastmodified integer,
    etag character varying(32) DEFAULT NULL::character varying,
    size bigint NOT NULL,
    componenttype character varying(8) DEFAULT NULL::character varying,
    firstoccurence bigint,
    lastoccurence bigint,
    uid character varying(255) DEFAULT NULL::character varying,
    classification integer DEFAULT 0,
    calendartype integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.oc_calendarobjects OWNER TO oc_gingertech3;

--
-- Name: oc_calendarobjects_id_seq; Type: SEQUENCE; Schema: public; Owner: oc_gingertech3
--

CREATE SEQUENCE public.oc_calendarobjects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.oc_calendarobjects_id_seq OWNER TO oc_gingertech3;

--
-- Name: oc_calendarobjects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: oc_gingertech3
--

ALTER SEQUENCE public.oc_calendarobjects_id_seq OWNED BY public.oc_calendarobjects.id;


--
-- Name: oc_calendarobjects_props; Type: TABLE; Schema: public; Owner: oc_gingertech3
--

CREATE TABLE public.oc_calendarobjects_props (
    id bigint NOT NULL,
    calendarid bigint DEFAULT 0 NOT NULL,
    objectid bigint DEFAULT 0 NOT NULL,
    name character varying(64) DEFAULT NULL::character varying,
    parameter character varying(64) DEFAULT NULL::character varying,
    value character varying(255) DEFAULT NULL::character varying,
    calendartype integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.oc_calendarobjects_props OWNER TO oc_gingertech3;

--
-- Name: oc_calendarobjects_props_id_seq; Type: SEQUENCE; Schema: public; Owner: oc_gingertech3
--

CREATE SEQUENCE public.oc_calendarobjects_props_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.oc_calendarobjects_props_id_seq OWNER TO oc_gingertech3;

--
-- Name: oc_calendarobjects_props_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: oc_gingertech3
--

ALTER SEQUENCE public.oc_calendarobjects_props_id_seq OWNED BY public.oc_calendarobjects_props.id;


--
-- Name: oc_calendars; Type: TABLE; Schema: public; Owner: oc_gingertech3
--

CREATE TABLE public.oc_calendars (
    id bigint NOT NULL,
    principaluri character varying(255) DEFAULT NULL::character varying,
    displayname character varying(255) DEFAULT NULL::character varying,
    uri character varying(255) DEFAULT NULL::character varying,
    synctoken integer DEFAULT 1 NOT NULL,
    description character varying(255) DEFAULT NULL::character varying,
    calendarorder integer DEFAULT 0 NOT NULL,
    calendarcolor character varying(255) DEFAULT NULL::character varying,
    timezone text,
    components character varying(64) DEFAULT NULL::character varying,
    transparent smallint DEFAULT 0 NOT NULL
);


ALTER TABLE public.oc_calendars OWNER TO oc_gingertech3;

--
-- Name: oc_calendars_id_seq; Type: SEQUENCE; Schema: public; Owner: oc_gingertech3
--

CREATE SEQUENCE public.oc_calendars_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.oc_calendars_id_seq OWNER TO oc_gingertech3;

--
-- Name: oc_calendars_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: oc_gingertech3
--

ALTER SEQUENCE public.oc_calendars_id_seq OWNED BY public.oc_calendars.id;


--
-- Name: oc_calendarsubscriptions; Type: TABLE; Schema: public; Owner: oc_gingertech3
--

CREATE TABLE public.oc_calendarsubscriptions (
    id bigint NOT NULL,
    uri character varying(255) DEFAULT NULL::character varying,
    principaluri character varying(255) DEFAULT NULL::character varying,
    displayname character varying(100) DEFAULT NULL::character varying,
    refreshrate character varying(10) DEFAULT NULL::character varying,
    calendarorder integer DEFAULT 0 NOT NULL,
    calendarcolor character varying(255) DEFAULT NULL::character varying,
    striptodos smallint,
    stripalarms smallint,
    stripattachments smallint,
    lastmodified integer,
    synctoken integer DEFAULT 1 NOT NULL,
    source text
);


ALTER TABLE public.oc_calendarsubscriptions OWNER TO oc_gingertech3;

--
-- Name: oc_calendarsubscriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: oc_gingertech3
--

CREATE SEQUENCE public.oc_calendarsubscriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.oc_calendarsubscriptions_id_seq OWNER TO oc_gingertech3;

--
-- Name: oc_calendarsubscriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: oc_gingertech3
--

ALTER SEQUENCE public.oc_calendarsubscriptions_id_seq OWNED BY public.oc_calendarsubscriptions.id;


--
-- Name: oc_cards; Type: TABLE; Schema: public; Owner: oc_gingertech3
--

CREATE TABLE public.oc_cards (
    id bigint NOT NULL,
    addressbookid bigint DEFAULT 0 NOT NULL,
    carddata bytea,
    uri character varying(255) DEFAULT NULL::character varying,
    lastmodified bigint,
    etag character varying(32) DEFAULT NULL::character varying,
    size bigint NOT NULL,
    uid character varying(255) DEFAULT NULL::character varying
);


ALTER TABLE public.oc_cards OWNER TO oc_gingertech3;

--
-- Name: oc_cards_id_seq; Type: SEQUENCE; Schema: public; Owner: oc_gingertech3
--

CREATE SEQUENCE public.oc_cards_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.oc_cards_id_seq OWNER TO oc_gingertech3;

--
-- Name: oc_cards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: oc_gingertech3
--

ALTER SEQUENCE public.oc_cards_id_seq OWNED BY public.oc_cards.id;


--
-- Name: oc_cards_properties; Type: TABLE; Schema: public; Owner: oc_gingertech3
--

CREATE TABLE public.oc_cards_properties (
    id bigint NOT NULL,
    addressbookid bigint DEFAULT 0 NOT NULL,
    cardid bigint DEFAULT 0 NOT NULL,
    name character varying(64) DEFAULT NULL::character varying,
    value character varying(255) DEFAULT NULL::character varying,
    preferred integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.oc_cards_properties OWNER TO oc_gingertech3;

--
-- Name: oc_cards_properties_id_seq; Type: SEQUENCE; Schema: public; Owner: oc_gingertech3
--

CREATE SEQUENCE public.oc_cards_properties_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.oc_cards_properties_id_seq OWNER TO oc_gingertech3;

--
-- Name: oc_cards_properties_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: oc_gingertech3
--

ALTER SEQUENCE public.oc_cards_properties_id_seq OWNED BY public.oc_cards_properties.id;


--
-- Name: oc_comments; Type: TABLE; Schema: public; Owner: oc_gingertech3
--

CREATE TABLE public.oc_comments (
    id bigint NOT NULL,
    parent_id bigint DEFAULT 0 NOT NULL,
    topmost_parent_id bigint DEFAULT 0 NOT NULL,
    children_count integer DEFAULT 0 NOT NULL,
    actor_type character varying(64) DEFAULT ''::character varying NOT NULL,
    actor_id character varying(64) DEFAULT ''::character varying NOT NULL,
    message text,
    verb character varying(64) DEFAULT NULL::character varying,
    creation_timestamp timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    latest_child_timestamp timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    object_type character varying(64) DEFAULT ''::character varying NOT NULL,
    object_id character varying(64) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.oc_comments OWNER TO oc_gingertech3;

--
-- Name: oc_comments_id_seq; Type: SEQUENCE; Schema: public; Owner: oc_gingertech3
--

CREATE SEQUENCE public.oc_comments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.oc_comments_id_seq OWNER TO oc_gingertech3;

--
-- Name: oc_comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: oc_gingertech3
--

ALTER SEQUENCE public.oc_comments_id_seq OWNED BY public.oc_comments.id;


--
-- Name: oc_comments_read_markers; Type: TABLE; Schema: public; Owner: oc_gingertech3
--

CREATE TABLE public.oc_comments_read_markers (
    user_id character varying(64) DEFAULT ''::character varying NOT NULL,
    marker_datetime timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    object_type character varying(64) DEFAULT ''::character varying NOT NULL,
    object_id character varying(64) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.oc_comments_read_markers OWNER TO oc_gingertech3;

--
-- Name: oc_credentials; Type: TABLE; Schema: public; Owner: oc_gingertech3
--

CREATE TABLE public.oc_credentials (
    "user" character varying(64) NOT NULL,
    identifier character varying(64) NOT NULL,
    credentials text
);


ALTER TABLE public.oc_credentials OWNER TO oc_gingertech3;

--
-- Name: oc_dav_shares; Type: TABLE; Schema: public; Owner: oc_gingertech3
--

CREATE TABLE public.oc_dav_shares (
    id bigint NOT NULL,
    principaluri character varying(255) DEFAULT NULL::character varying,
    type character varying(255) DEFAULT NULL::character varying,
    access smallint,
    resourceid bigint NOT NULL,
    publicuri character varying(255) DEFAULT NULL::character varying
);


ALTER TABLE public.oc_dav_shares OWNER TO oc_gingertech3;

--
-- Name: oc_dav_shares_id_seq; Type: SEQUENCE; Schema: public; Owner: oc_gingertech3
--

CREATE SEQUENCE public.oc_dav_shares_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.oc_dav_shares_id_seq OWNER TO oc_gingertech3;

--
-- Name: oc_dav_shares_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: oc_gingertech3
--

ALTER SEQUENCE public.oc_dav_shares_id_seq OWNED BY public.oc_dav_shares.id;


--
-- Name: oc_directlink; Type: TABLE; Schema: public; Owner: oc_gingertech3
--

CREATE TABLE public.oc_directlink (
    id bigint NOT NULL,
    user_id character varying(64) DEFAULT NULL::character varying,
    file_id bigint NOT NULL,
    token character varying(60) DEFAULT NULL::character varying,
    expiration bigint NOT NULL
);


ALTER TABLE public.oc_directlink OWNER TO oc_gingertech3;

--
-- Name: oc_directlink_id_seq; Type: SEQUENCE; Schema: public; Owner: oc_gingertech3
--

CREATE SEQUENCE public.oc_directlink_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.oc_directlink_id_seq OWNER TO oc_gingertech3;

--
-- Name: oc_directlink_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: oc_gingertech3
--

ALTER SEQUENCE public.oc_directlink_id_seq OWNED BY public.oc_directlink.id;


--
-- Name: oc_federated_reshares; Type: TABLE; Schema: public; Owner: oc_gingertech3
--

CREATE TABLE public.oc_federated_reshares (
    share_id integer NOT NULL,
    remote_id integer NOT NULL
);


ALTER TABLE public.oc_federated_reshares OWNER TO oc_gingertech3;

--
-- Name: COLUMN oc_federated_reshares.remote_id; Type: COMMENT; Schema: public; Owner: oc_gingertech3
--

COMMENT ON COLUMN public.oc_federated_reshares.remote_id IS 'share ID at the remote server';


--
-- Name: oc_file_locks; Type: TABLE; Schema: public; Owner: oc_gingertech3
--

CREATE TABLE public.oc_file_locks (
    id bigint NOT NULL,
    lock integer DEFAULT 0 NOT NULL,
    key character varying(64) NOT NULL,
    ttl integer DEFAULT '-1'::integer NOT NULL
);


ALTER TABLE public.oc_file_locks OWNER TO oc_gingertech3;

--
-- Name: oc_file_locks_id_seq; Type: SEQUENCE; Schema: public; Owner: oc_gingertech3
--

CREATE SEQUENCE public.oc_file_locks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.oc_file_locks_id_seq OWNER TO oc_gingertech3;

--
-- Name: oc_file_locks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: oc_gingertech3
--

ALTER SEQUENCE public.oc_file_locks_id_seq OWNED BY public.oc_file_locks.id;


--
-- Name: oc_filecache; Type: TABLE; Schema: public; Owner: oc_gingertech3
--

CREATE TABLE public.oc_filecache (
    fileid bigint NOT NULL,
    storage bigint DEFAULT 0 NOT NULL,
    path character varying(4000) DEFAULT NULL::character varying,
    path_hash character varying(32) DEFAULT ''::character varying NOT NULL,
    parent bigint DEFAULT 0 NOT NULL,
    name character varying(250) DEFAULT NULL::character varying,
    mimetype bigint DEFAULT 0 NOT NULL,
    mimepart bigint DEFAULT 0 NOT NULL,
    size bigint DEFAULT 0 NOT NULL,
    mtime integer DEFAULT 0 NOT NULL,
    storage_mtime integer DEFAULT 0 NOT NULL,
    encrypted integer DEFAULT 0 NOT NULL,
    unencrypted_size bigint DEFAULT 0 NOT NULL,
    etag character varying(40) DEFAULT NULL::character varying,
    permissions integer DEFAULT 0,
    checksum character varying(255) DEFAULT NULL::character varying
);


ALTER TABLE public.oc_filecache OWNER TO oc_gingertech3;

--
-- Name: oc_filecache_fileid_seq; Type: SEQUENCE; Schema: public; Owner: oc_gingertech3
--

CREATE SEQUENCE public.oc_filecache_fileid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.oc_filecache_fileid_seq OWNER TO oc_gingertech3;

--
-- Name: oc_filecache_fileid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: oc_gingertech3
--

ALTER SEQUENCE public.oc_filecache_fileid_seq OWNED BY public.oc_filecache.fileid;


--
-- Name: oc_files_trash; Type: TABLE; Schema: public; Owner: oc_gingertech3
--

CREATE TABLE public.oc_files_trash (
    auto_id integer NOT NULL,
    id character varying(250) DEFAULT ''::character varying NOT NULL,
    "user" character varying(64) DEFAULT ''::character varying NOT NULL,
    "timestamp" character varying(12) DEFAULT ''::character varying NOT NULL,
    location character varying(512) DEFAULT ''::character varying NOT NULL,
    type character varying(4) DEFAULT NULL::character varying,
    mime character varying(255) DEFAULT NULL::character varying
);


ALTER TABLE public.oc_files_trash OWNER TO oc_gingertech3;

--
-- Name: oc_files_trash_auto_id_seq; Type: SEQUENCE; Schema: public; Owner: oc_gingertech3
--

CREATE SEQUENCE public.oc_files_trash_auto_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.oc_files_trash_auto_id_seq OWNER TO oc_gingertech3;

--
-- Name: oc_files_trash_auto_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: oc_gingertech3
--

ALTER SEQUENCE public.oc_files_trash_auto_id_seq OWNED BY public.oc_files_trash.auto_id;


--
-- Name: oc_flow_checks; Type: TABLE; Schema: public; Owner: oc_gingertech3
--

CREATE TABLE public.oc_flow_checks (
    id integer NOT NULL,
    class character varying(256) NOT NULL,
    operator character varying(16) NOT NULL,
    value text,
    hash character varying(32) NOT NULL
);


ALTER TABLE public.oc_flow_checks OWNER TO oc_gingertech3;

--
-- Name: oc_flow_checks_id_seq; Type: SEQUENCE; Schema: public; Owner: oc_gingertech3
--

CREATE SEQUENCE public.oc_flow_checks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.oc_flow_checks_id_seq OWNER TO oc_gingertech3;

--
-- Name: oc_flow_checks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: oc_gingertech3
--

ALTER SEQUENCE public.oc_flow_checks_id_seq OWNED BY public.oc_flow_checks.id;


--
-- Name: oc_flow_operations; Type: TABLE; Schema: public; Owner: oc_gingertech3
--

CREATE TABLE public.oc_flow_operations (
    id integer NOT NULL,
    class character varying(256) NOT NULL,
    name character varying(256) NOT NULL,
    checks text,
    operation text
);


ALTER TABLE public.oc_flow_operations OWNER TO oc_gingertech3;

--
-- Name: oc_flow_operations_id_seq; Type: SEQUENCE; Schema: public; Owner: oc_gingertech3
--

CREATE SEQUENCE public.oc_flow_operations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.oc_flow_operations_id_seq OWNER TO oc_gingertech3;

--
-- Name: oc_flow_operations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: oc_gingertech3
--

ALTER SEQUENCE public.oc_flow_operations_id_seq OWNED BY public.oc_flow_operations.id;


--
-- Name: oc_group_admin; Type: TABLE; Schema: public; Owner: oc_gingertech3
--

CREATE TABLE public.oc_group_admin (
    gid character varying(64) DEFAULT ''::character varying NOT NULL,
    uid character varying(64) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.oc_group_admin OWNER TO oc_gingertech3;

--
-- Name: oc_group_user; Type: TABLE; Schema: public; Owner: oc_gingertech3
--

CREATE TABLE public.oc_group_user (
    gid character varying(64) DEFAULT ''::character varying NOT NULL,
    uid character varying(64) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.oc_group_user OWNER TO oc_gingertech3;

--
-- Name: oc_groups; Type: TABLE; Schema: public; Owner: oc_gingertech3
--

CREATE TABLE public.oc_groups (
    gid character varying(64) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.oc_groups OWNER TO oc_gingertech3;

--
-- Name: oc_jobs; Type: TABLE; Schema: public; Owner: oc_gingertech3
--

CREATE TABLE public.oc_jobs (
    id bigint NOT NULL,
    class character varying(255) DEFAULT ''::character varying NOT NULL,
    argument character varying(4000) DEFAULT ''::character varying NOT NULL,
    last_run integer DEFAULT 0,
    last_checked integer DEFAULT 0,
    reserved_at integer DEFAULT 0,
    execution_duration integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.oc_jobs OWNER TO oc_gingertech3;

--
-- Name: oc_jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: oc_gingertech3
--

CREATE SEQUENCE public.oc_jobs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.oc_jobs_id_seq OWNER TO oc_gingertech3;

--
-- Name: oc_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: oc_gingertech3
--

ALTER SEQUENCE public.oc_jobs_id_seq OWNED BY public.oc_jobs.id;


--
-- Name: oc_migrations; Type: TABLE; Schema: public; Owner: oc_gingertech3
--

CREATE TABLE public.oc_migrations (
    app character varying(255) NOT NULL,
    version character varying(255) NOT NULL
);


ALTER TABLE public.oc_migrations OWNER TO oc_gingertech3;

--
-- Name: oc_mimetypes; Type: TABLE; Schema: public; Owner: oc_gingertech3
--

CREATE TABLE public.oc_mimetypes (
    id bigint NOT NULL,
    mimetype character varying(255) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.oc_mimetypes OWNER TO oc_gingertech3;

--
-- Name: oc_mimetypes_id_seq; Type: SEQUENCE; Schema: public; Owner: oc_gingertech3
--

CREATE SEQUENCE public.oc_mimetypes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.oc_mimetypes_id_seq OWNER TO oc_gingertech3;

--
-- Name: oc_mimetypes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: oc_gingertech3
--

ALTER SEQUENCE public.oc_mimetypes_id_seq OWNED BY public.oc_mimetypes.id;


--
-- Name: oc_mounts; Type: TABLE; Schema: public; Owner: oc_gingertech3
--

CREATE TABLE public.oc_mounts (
    id bigint NOT NULL,
    storage_id integer NOT NULL,
    root_id integer NOT NULL,
    user_id character varying(64) NOT NULL,
    mount_point character varying(4000) NOT NULL,
    mount_id integer
);


ALTER TABLE public.oc_mounts OWNER TO oc_gingertech3;

--
-- Name: oc_mounts_id_seq; Type: SEQUENCE; Schema: public; Owner: oc_gingertech3
--

CREATE SEQUENCE public.oc_mounts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.oc_mounts_id_seq OWNER TO oc_gingertech3;

--
-- Name: oc_mounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: oc_gingertech3
--

ALTER SEQUENCE public.oc_mounts_id_seq OWNED BY public.oc_mounts.id;


--
-- Name: oc_notifications; Type: TABLE; Schema: public; Owner: oc_gingertech3
--

CREATE TABLE public.oc_notifications (
    notification_id integer NOT NULL,
    app character varying(32) NOT NULL,
    "user" character varying(64) NOT NULL,
    "timestamp" integer DEFAULT 0 NOT NULL,
    object_type character varying(64) NOT NULL,
    object_id character varying(64) NOT NULL,
    subject character varying(64) NOT NULL,
    subject_parameters text,
    message character varying(64) DEFAULT NULL::character varying,
    message_parameters text,
    link character varying(4000) DEFAULT NULL::character varying,
    icon character varying(4000) DEFAULT NULL::character varying,
    actions text
);


ALTER TABLE public.oc_notifications OWNER TO oc_gingertech3;

--
-- Name: oc_notifications_notification_id_seq; Type: SEQUENCE; Schema: public; Owner: oc_gingertech3
--

CREATE SEQUENCE public.oc_notifications_notification_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.oc_notifications_notification_id_seq OWNER TO oc_gingertech3;

--
-- Name: oc_notifications_notification_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: oc_gingertech3
--

ALTER SEQUENCE public.oc_notifications_notification_id_seq OWNED BY public.oc_notifications.notification_id;


--
-- Name: oc_notifications_pushtokens; Type: TABLE; Schema: public; Owner: oc_gingertech3
--

CREATE TABLE public.oc_notifications_pushtokens (
    uid character varying(64) NOT NULL,
    token integer DEFAULT 0 NOT NULL,
    deviceidentifier character varying(128) NOT NULL,
    devicepublickey character varying(512) NOT NULL,
    devicepublickeyhash character varying(128) NOT NULL,
    pushtokenhash character varying(128) NOT NULL,
    proxyserver character varying(256) NOT NULL,
    apptype character varying(32) DEFAULT 'unknown'::character varying NOT NULL
);


ALTER TABLE public.oc_notifications_pushtokens OWNER TO oc_gingertech3;

--
-- Name: oc_oauth2_access_tokens; Type: TABLE; Schema: public; Owner: oc_gingertech3
--

CREATE TABLE public.oc_oauth2_access_tokens (
    id integer NOT NULL,
    token_id integer NOT NULL,
    client_id integer NOT NULL,
    hashed_code character varying(128) NOT NULL,
    encrypted_token character varying(786) NOT NULL
);


ALTER TABLE public.oc_oauth2_access_tokens OWNER TO oc_gingertech3;

--
-- Name: oc_oauth2_access_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: oc_gingertech3
--

CREATE SEQUENCE public.oc_oauth2_access_tokens_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.oc_oauth2_access_tokens_id_seq OWNER TO oc_gingertech3;

--
-- Name: oc_oauth2_access_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: oc_gingertech3
--

ALTER SEQUENCE public.oc_oauth2_access_tokens_id_seq OWNED BY public.oc_oauth2_access_tokens.id;


--
-- Name: oc_oauth2_clients; Type: TABLE; Schema: public; Owner: oc_gingertech3
--

CREATE TABLE public.oc_oauth2_clients (
    id integer NOT NULL,
    name character varying(64) NOT NULL,
    redirect_uri character varying(2000) NOT NULL,
    client_identifier character varying(64) NOT NULL,
    secret character varying(64) NOT NULL
);


ALTER TABLE public.oc_oauth2_clients OWNER TO oc_gingertech3;

--
-- Name: oc_oauth2_clients_id_seq; Type: SEQUENCE; Schema: public; Owner: oc_gingertech3
--

CREATE SEQUENCE public.oc_oauth2_clients_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.oc_oauth2_clients_id_seq OWNER TO oc_gingertech3;

--
-- Name: oc_oauth2_clients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: oc_gingertech3
--

ALTER SEQUENCE public.oc_oauth2_clients_id_seq OWNED BY public.oc_oauth2_clients.id;


--
-- Name: oc_preferences; Type: TABLE; Schema: public; Owner: oc_gingertech3
--

CREATE TABLE public.oc_preferences (
    userid character varying(64) DEFAULT ''::character varying NOT NULL,
    appid character varying(32) DEFAULT ''::character varying NOT NULL,
    configkey character varying(64) DEFAULT ''::character varying NOT NULL,
    configvalue text
);


ALTER TABLE public.oc_preferences OWNER TO oc_gingertech3;

--
-- Name: oc_properties; Type: TABLE; Schema: public; Owner: oc_gingertech3
--

CREATE TABLE public.oc_properties (
    id bigint NOT NULL,
    userid character varying(64) DEFAULT ''::character varying NOT NULL,
    propertypath character varying(255) DEFAULT ''::character varying NOT NULL,
    propertyname character varying(255) DEFAULT ''::character varying NOT NULL,
    propertyvalue text NOT NULL
);


ALTER TABLE public.oc_properties OWNER TO oc_gingertech3;

--
-- Name: oc_properties_id_seq; Type: SEQUENCE; Schema: public; Owner: oc_gingertech3
--

CREATE SEQUENCE public.oc_properties_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.oc_properties_id_seq OWNER TO oc_gingertech3;

--
-- Name: oc_properties_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: oc_gingertech3
--

ALTER SEQUENCE public.oc_properties_id_seq OWNED BY public.oc_properties.id;


--
-- Name: oc_schedulingobjects; Type: TABLE; Schema: public; Owner: oc_gingertech3
--

CREATE TABLE public.oc_schedulingobjects (
    id bigint NOT NULL,
    principaluri character varying(255) DEFAULT NULL::character varying,
    calendardata bytea,
    uri character varying(255) DEFAULT NULL::character varying,
    lastmodified integer,
    etag character varying(32) DEFAULT NULL::character varying,
    size bigint NOT NULL
);


ALTER TABLE public.oc_schedulingobjects OWNER TO oc_gingertech3;

--
-- Name: oc_schedulingobjects_id_seq; Type: SEQUENCE; Schema: public; Owner: oc_gingertech3
--

CREATE SEQUENCE public.oc_schedulingobjects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.oc_schedulingobjects_id_seq OWNER TO oc_gingertech3;

--
-- Name: oc_schedulingobjects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: oc_gingertech3
--

ALTER SEQUENCE public.oc_schedulingobjects_id_seq OWNED BY public.oc_schedulingobjects.id;


--
-- Name: oc_share; Type: TABLE; Schema: public; Owner: oc_gingertech3
--

CREATE TABLE public.oc_share (
    id bigint NOT NULL,
    share_type smallint DEFAULT 0 NOT NULL,
    share_with character varying(255) DEFAULT NULL::character varying,
    password character varying(255) DEFAULT NULL::character varying,
    uid_owner character varying(64) DEFAULT ''::character varying NOT NULL,
    uid_initiator character varying(64) DEFAULT NULL::character varying,
    parent bigint,
    item_type character varying(64) DEFAULT ''::character varying NOT NULL,
    item_source character varying(255) DEFAULT NULL::character varying,
    item_target character varying(255) DEFAULT NULL::character varying,
    file_source bigint,
    file_target character varying(512) DEFAULT NULL::character varying,
    permissions smallint DEFAULT 0 NOT NULL,
    stime bigint DEFAULT 0 NOT NULL,
    accepted smallint DEFAULT 0 NOT NULL,
    expiration timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    token character varying(32) DEFAULT NULL::character varying,
    mail_send smallint DEFAULT 0 NOT NULL,
    share_name character varying(64) DEFAULT NULL::character varying,
    password_by_talk boolean DEFAULT false NOT NULL,
    note text,
    hide_download smallint DEFAULT 0 NOT NULL,
    label character varying(255) DEFAULT NULL::character varying
);


ALTER TABLE public.oc_share OWNER TO oc_gingertech3;

--
-- Name: oc_share_external; Type: TABLE; Schema: public; Owner: oc_gingertech3
--

CREATE TABLE public.oc_share_external (
    id integer NOT NULL,
    parent integer DEFAULT '-1'::integer,
    share_type integer,
    remote character varying(512) NOT NULL,
    remote_id integer DEFAULT '-1'::integer NOT NULL,
    share_token character varying(64) NOT NULL,
    password character varying(64) DEFAULT NULL::character varying,
    name character varying(64) NOT NULL,
    owner character varying(64) NOT NULL,
    "user" character varying(64) NOT NULL,
    mountpoint character varying(4000) NOT NULL,
    mountpoint_hash character varying(32) NOT NULL,
    accepted integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.oc_share_external OWNER TO oc_gingertech3;

--
-- Name: COLUMN oc_share_external.remote; Type: COMMENT; Schema: public; Owner: oc_gingertech3
--

COMMENT ON COLUMN public.oc_share_external.remote IS 'Url of the remove owncloud instance';


--
-- Name: COLUMN oc_share_external.share_token; Type: COMMENT; Schema: public; Owner: oc_gingertech3
--

COMMENT ON COLUMN public.oc_share_external.share_token IS 'Public share token';


--
-- Name: COLUMN oc_share_external.password; Type: COMMENT; Schema: public; Owner: oc_gingertech3
--

COMMENT ON COLUMN public.oc_share_external.password IS 'Optional password for the public share';


--
-- Name: COLUMN oc_share_external.name; Type: COMMENT; Schema: public; Owner: oc_gingertech3
--

COMMENT ON COLUMN public.oc_share_external.name IS 'Original name on the remote server';


--
-- Name: COLUMN oc_share_external.owner; Type: COMMENT; Schema: public; Owner: oc_gingertech3
--

COMMENT ON COLUMN public.oc_share_external.owner IS 'User that owns the public share on the remote server';


--
-- Name: COLUMN oc_share_external."user"; Type: COMMENT; Schema: public; Owner: oc_gingertech3
--

COMMENT ON COLUMN public.oc_share_external."user" IS 'Local user which added the external share';


--
-- Name: COLUMN oc_share_external.mountpoint; Type: COMMENT; Schema: public; Owner: oc_gingertech3
--

COMMENT ON COLUMN public.oc_share_external.mountpoint IS 'Full path where the share is mounted';


--
-- Name: COLUMN oc_share_external.mountpoint_hash; Type: COMMENT; Schema: public; Owner: oc_gingertech3
--

COMMENT ON COLUMN public.oc_share_external.mountpoint_hash IS 'md5 hash of the mountpoint';


--
-- Name: oc_share_external_id_seq; Type: SEQUENCE; Schema: public; Owner: oc_gingertech3
--

CREATE SEQUENCE public.oc_share_external_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.oc_share_external_id_seq OWNER TO oc_gingertech3;

--
-- Name: oc_share_external_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: oc_gingertech3
--

ALTER SEQUENCE public.oc_share_external_id_seq OWNED BY public.oc_share_external.id;


--
-- Name: oc_share_id_seq; Type: SEQUENCE; Schema: public; Owner: oc_gingertech3
--

CREATE SEQUENCE public.oc_share_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.oc_share_id_seq OWNER TO oc_gingertech3;

--
-- Name: oc_share_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: oc_gingertech3
--

ALTER SEQUENCE public.oc_share_id_seq OWNED BY public.oc_share.id;


--
-- Name: oc_storages; Type: TABLE; Schema: public; Owner: oc_gingertech3
--

CREATE TABLE public.oc_storages (
    numeric_id bigint NOT NULL,
    id character varying(64) DEFAULT NULL::character varying,
    available integer DEFAULT 1 NOT NULL,
    last_checked integer
);


ALTER TABLE public.oc_storages OWNER TO oc_gingertech3;

--
-- Name: oc_storages_numeric_id_seq; Type: SEQUENCE; Schema: public; Owner: oc_gingertech3
--

CREATE SEQUENCE public.oc_storages_numeric_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.oc_storages_numeric_id_seq OWNER TO oc_gingertech3;

--
-- Name: oc_storages_numeric_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: oc_gingertech3
--

ALTER SEQUENCE public.oc_storages_numeric_id_seq OWNED BY public.oc_storages.numeric_id;


--
-- Name: oc_systemtag; Type: TABLE; Schema: public; Owner: oc_gingertech3
--

CREATE TABLE public.oc_systemtag (
    id bigint NOT NULL,
    name character varying(64) DEFAULT ''::character varying NOT NULL,
    visibility smallint DEFAULT 1 NOT NULL,
    editable smallint DEFAULT 1 NOT NULL
);


ALTER TABLE public.oc_systemtag OWNER TO oc_gingertech3;

--
-- Name: oc_systemtag_group; Type: TABLE; Schema: public; Owner: oc_gingertech3
--

CREATE TABLE public.oc_systemtag_group (
    gid character varying(255) NOT NULL,
    systemtagid bigint DEFAULT 0 NOT NULL
);


ALTER TABLE public.oc_systemtag_group OWNER TO oc_gingertech3;

--
-- Name: oc_systemtag_id_seq; Type: SEQUENCE; Schema: public; Owner: oc_gingertech3
--

CREATE SEQUENCE public.oc_systemtag_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.oc_systemtag_id_seq OWNER TO oc_gingertech3;

--
-- Name: oc_systemtag_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: oc_gingertech3
--

ALTER SEQUENCE public.oc_systemtag_id_seq OWNED BY public.oc_systemtag.id;


--
-- Name: oc_systemtag_object_mapping; Type: TABLE; Schema: public; Owner: oc_gingertech3
--

CREATE TABLE public.oc_systemtag_object_mapping (
    objectid character varying(64) DEFAULT ''::character varying NOT NULL,
    objecttype character varying(64) DEFAULT ''::character varying NOT NULL,
    systemtagid bigint DEFAULT 0 NOT NULL
);


ALTER TABLE public.oc_systemtag_object_mapping OWNER TO oc_gingertech3;

--
-- Name: oc_trusted_servers; Type: TABLE; Schema: public; Owner: oc_gingertech3
--

CREATE TABLE public.oc_trusted_servers (
    id integer NOT NULL,
    url character varying(512) NOT NULL,
    url_hash character varying(255) DEFAULT ''::character varying NOT NULL,
    token character varying(128) DEFAULT NULL::character varying,
    shared_secret character varying(256) DEFAULT NULL::character varying,
    status integer DEFAULT 2 NOT NULL,
    sync_token character varying(512) DEFAULT NULL::character varying
);


ALTER TABLE public.oc_trusted_servers OWNER TO oc_gingertech3;

--
-- Name: COLUMN oc_trusted_servers.url; Type: COMMENT; Schema: public; Owner: oc_gingertech3
--

COMMENT ON COLUMN public.oc_trusted_servers.url IS 'Url of trusted server';


--
-- Name: COLUMN oc_trusted_servers.url_hash; Type: COMMENT; Schema: public; Owner: oc_gingertech3
--

COMMENT ON COLUMN public.oc_trusted_servers.url_hash IS 'sha1 hash of the url without the protocol';


--
-- Name: COLUMN oc_trusted_servers.token; Type: COMMENT; Schema: public; Owner: oc_gingertech3
--

COMMENT ON COLUMN public.oc_trusted_servers.token IS 'token used to exchange the shared secret';


--
-- Name: COLUMN oc_trusted_servers.shared_secret; Type: COMMENT; Schema: public; Owner: oc_gingertech3
--

COMMENT ON COLUMN public.oc_trusted_servers.shared_secret IS 'shared secret used to authenticate';


--
-- Name: COLUMN oc_trusted_servers.status; Type: COMMENT; Schema: public; Owner: oc_gingertech3
--

COMMENT ON COLUMN public.oc_trusted_servers.status IS 'current status of the connection';


--
-- Name: COLUMN oc_trusted_servers.sync_token; Type: COMMENT; Schema: public; Owner: oc_gingertech3
--

COMMENT ON COLUMN public.oc_trusted_servers.sync_token IS 'cardDav sync token';


--
-- Name: oc_trusted_servers_id_seq; Type: SEQUENCE; Schema: public; Owner: oc_gingertech3
--

CREATE SEQUENCE public.oc_trusted_servers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.oc_trusted_servers_id_seq OWNER TO oc_gingertech3;

--
-- Name: oc_trusted_servers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: oc_gingertech3
--

ALTER SEQUENCE public.oc_trusted_servers_id_seq OWNED BY public.oc_trusted_servers.id;


--
-- Name: oc_twofactor_backupcodes; Type: TABLE; Schema: public; Owner: oc_gingertech3
--

CREATE TABLE public.oc_twofactor_backupcodes (
    id bigint NOT NULL,
    user_id character varying(64) NOT NULL,
    code character varying(128) NOT NULL,
    used smallint DEFAULT 0 NOT NULL
);


ALTER TABLE public.oc_twofactor_backupcodes OWNER TO oc_gingertech3;

--
-- Name: oc_twofactor_backupcodes_id_seq; Type: SEQUENCE; Schema: public; Owner: oc_gingertech3
--

CREATE SEQUENCE public.oc_twofactor_backupcodes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.oc_twofactor_backupcodes_id_seq OWNER TO oc_gingertech3;

--
-- Name: oc_twofactor_backupcodes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: oc_gingertech3
--

ALTER SEQUENCE public.oc_twofactor_backupcodes_id_seq OWNED BY public.oc_twofactor_backupcodes.id;


--
-- Name: oc_twofactor_providers; Type: TABLE; Schema: public; Owner: oc_gingertech3
--

CREATE TABLE public.oc_twofactor_providers (
    provider_id character varying(32) NOT NULL,
    uid character varying(64) NOT NULL,
    enabled smallint NOT NULL
);


ALTER TABLE public.oc_twofactor_providers OWNER TO oc_gingertech3;

--
-- Name: oc_users; Type: TABLE; Schema: public; Owner: oc_gingertech3
--

CREATE TABLE public.oc_users (
    uid character varying(64) DEFAULT ''::character varying NOT NULL,
    displayname character varying(64) DEFAULT NULL::character varying,
    password character varying(255) DEFAULT ''::character varying NOT NULL,
    uid_lower character varying(64) DEFAULT ''::character varying
);


ALTER TABLE public.oc_users OWNER TO oc_gingertech3;

--
-- Name: oc_vcategory; Type: TABLE; Schema: public; Owner: oc_gingertech3
--

CREATE TABLE public.oc_vcategory (
    id bigint NOT NULL,
    uid character varying(64) DEFAULT ''::character varying NOT NULL,
    type character varying(64) DEFAULT ''::character varying NOT NULL,
    category character varying(255) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.oc_vcategory OWNER TO oc_gingertech3;

--
-- Name: oc_vcategory_id_seq; Type: SEQUENCE; Schema: public; Owner: oc_gingertech3
--

CREATE SEQUENCE public.oc_vcategory_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.oc_vcategory_id_seq OWNER TO oc_gingertech3;

--
-- Name: oc_vcategory_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: oc_gingertech3
--

ALTER SEQUENCE public.oc_vcategory_id_seq OWNED BY public.oc_vcategory.id;


--
-- Name: oc_vcategory_to_object; Type: TABLE; Schema: public; Owner: oc_gingertech3
--

CREATE TABLE public.oc_vcategory_to_object (
    categoryid bigint DEFAULT 0 NOT NULL,
    objid bigint DEFAULT 0 NOT NULL,
    type character varying(64) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.oc_vcategory_to_object OWNER TO oc_gingertech3;

--
-- Name: oc_whats_new; Type: TABLE; Schema: public; Owner: oc_gingertech3
--

CREATE TABLE public.oc_whats_new (
    id integer NOT NULL,
    version character varying(64) DEFAULT '11'::character varying NOT NULL,
    etag character varying(64) DEFAULT ''::character varying NOT NULL,
    last_check integer DEFAULT 0 NOT NULL,
    data text DEFAULT ''::text NOT NULL
);


ALTER TABLE public.oc_whats_new OWNER TO oc_gingertech3;

--
-- Name: oc_whats_new_id_seq; Type: SEQUENCE; Schema: public; Owner: oc_gingertech3
--

CREATE SEQUENCE public.oc_whats_new_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.oc_whats_new_id_seq OWNER TO oc_gingertech3;

--
-- Name: oc_whats_new_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: oc_gingertech3
--

ALTER SEQUENCE public.oc_whats_new_id_seq OWNED BY public.oc_whats_new.id;


--
-- Name: oc_activity activity_id; Type: DEFAULT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_activity ALTER COLUMN activity_id SET DEFAULT nextval('public.oc_activity_activity_id_seq'::regclass);


--
-- Name: oc_activity_mq mail_id; Type: DEFAULT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_activity_mq ALTER COLUMN mail_id SET DEFAULT nextval('public.oc_activity_mq_mail_id_seq'::regclass);


--
-- Name: oc_addressbookchanges id; Type: DEFAULT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_addressbookchanges ALTER COLUMN id SET DEFAULT nextval('public.oc_addressbookchanges_id_seq'::regclass);


--
-- Name: oc_addressbooks id; Type: DEFAULT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_addressbooks ALTER COLUMN id SET DEFAULT nextval('public.oc_addressbooks_id_seq'::regclass);


--
-- Name: oc_authtoken id; Type: DEFAULT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_authtoken ALTER COLUMN id SET DEFAULT nextval('public.oc_authtoken_id_seq'::regclass);


--
-- Name: oc_bruteforce_attempts id; Type: DEFAULT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_bruteforce_attempts ALTER COLUMN id SET DEFAULT nextval('public.oc_bruteforce_attempts_id_seq'::regclass);


--
-- Name: oc_calendar_invitations id; Type: DEFAULT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_calendar_invitations ALTER COLUMN id SET DEFAULT nextval('public.oc_calendar_invitations_id_seq'::regclass);


--
-- Name: oc_calendar_resources id; Type: DEFAULT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_calendar_resources ALTER COLUMN id SET DEFAULT nextval('public.oc_calendar_resources_id_seq'::regclass);


--
-- Name: oc_calendar_rooms id; Type: DEFAULT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_calendar_rooms ALTER COLUMN id SET DEFAULT nextval('public.oc_calendar_rooms_id_seq'::regclass);


--
-- Name: oc_calendarchanges id; Type: DEFAULT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_calendarchanges ALTER COLUMN id SET DEFAULT nextval('public.oc_calendarchanges_id_seq'::regclass);


--
-- Name: oc_calendarobjects id; Type: DEFAULT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_calendarobjects ALTER COLUMN id SET DEFAULT nextval('public.oc_calendarobjects_id_seq'::regclass);


--
-- Name: oc_calendarobjects_props id; Type: DEFAULT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_calendarobjects_props ALTER COLUMN id SET DEFAULT nextval('public.oc_calendarobjects_props_id_seq'::regclass);


--
-- Name: oc_calendars id; Type: DEFAULT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_calendars ALTER COLUMN id SET DEFAULT nextval('public.oc_calendars_id_seq'::regclass);


--
-- Name: oc_calendarsubscriptions id; Type: DEFAULT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_calendarsubscriptions ALTER COLUMN id SET DEFAULT nextval('public.oc_calendarsubscriptions_id_seq'::regclass);


--
-- Name: oc_cards id; Type: DEFAULT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_cards ALTER COLUMN id SET DEFAULT nextval('public.oc_cards_id_seq'::regclass);


--
-- Name: oc_cards_properties id; Type: DEFAULT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_cards_properties ALTER COLUMN id SET DEFAULT nextval('public.oc_cards_properties_id_seq'::regclass);


--
-- Name: oc_comments id; Type: DEFAULT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_comments ALTER COLUMN id SET DEFAULT nextval('public.oc_comments_id_seq'::regclass);


--
-- Name: oc_dav_shares id; Type: DEFAULT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_dav_shares ALTER COLUMN id SET DEFAULT nextval('public.oc_dav_shares_id_seq'::regclass);


--
-- Name: oc_directlink id; Type: DEFAULT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_directlink ALTER COLUMN id SET DEFAULT nextval('public.oc_directlink_id_seq'::regclass);


--
-- Name: oc_file_locks id; Type: DEFAULT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_file_locks ALTER COLUMN id SET DEFAULT nextval('public.oc_file_locks_id_seq'::regclass);


--
-- Name: oc_filecache fileid; Type: DEFAULT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_filecache ALTER COLUMN fileid SET DEFAULT nextval('public.oc_filecache_fileid_seq'::regclass);


--
-- Name: oc_files_trash auto_id; Type: DEFAULT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_files_trash ALTER COLUMN auto_id SET DEFAULT nextval('public.oc_files_trash_auto_id_seq'::regclass);


--
-- Name: oc_flow_checks id; Type: DEFAULT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_flow_checks ALTER COLUMN id SET DEFAULT nextval('public.oc_flow_checks_id_seq'::regclass);


--
-- Name: oc_flow_operations id; Type: DEFAULT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_flow_operations ALTER COLUMN id SET DEFAULT nextval('public.oc_flow_operations_id_seq'::regclass);


--
-- Name: oc_jobs id; Type: DEFAULT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_jobs ALTER COLUMN id SET DEFAULT nextval('public.oc_jobs_id_seq'::regclass);


--
-- Name: oc_mimetypes id; Type: DEFAULT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_mimetypes ALTER COLUMN id SET DEFAULT nextval('public.oc_mimetypes_id_seq'::regclass);


--
-- Name: oc_mounts id; Type: DEFAULT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_mounts ALTER COLUMN id SET DEFAULT nextval('public.oc_mounts_id_seq'::regclass);


--
-- Name: oc_notifications notification_id; Type: DEFAULT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_notifications ALTER COLUMN notification_id SET DEFAULT nextval('public.oc_notifications_notification_id_seq'::regclass);


--
-- Name: oc_oauth2_access_tokens id; Type: DEFAULT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_oauth2_access_tokens ALTER COLUMN id SET DEFAULT nextval('public.oc_oauth2_access_tokens_id_seq'::regclass);


--
-- Name: oc_oauth2_clients id; Type: DEFAULT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_oauth2_clients ALTER COLUMN id SET DEFAULT nextval('public.oc_oauth2_clients_id_seq'::regclass);


--
-- Name: oc_properties id; Type: DEFAULT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_properties ALTER COLUMN id SET DEFAULT nextval('public.oc_properties_id_seq'::regclass);


--
-- Name: oc_schedulingobjects id; Type: DEFAULT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_schedulingobjects ALTER COLUMN id SET DEFAULT nextval('public.oc_schedulingobjects_id_seq'::regclass);


--
-- Name: oc_share id; Type: DEFAULT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_share ALTER COLUMN id SET DEFAULT nextval('public.oc_share_id_seq'::regclass);


--
-- Name: oc_share_external id; Type: DEFAULT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_share_external ALTER COLUMN id SET DEFAULT nextval('public.oc_share_external_id_seq'::regclass);


--
-- Name: oc_storages numeric_id; Type: DEFAULT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_storages ALTER COLUMN numeric_id SET DEFAULT nextval('public.oc_storages_numeric_id_seq'::regclass);


--
-- Name: oc_systemtag id; Type: DEFAULT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_systemtag ALTER COLUMN id SET DEFAULT nextval('public.oc_systemtag_id_seq'::regclass);


--
-- Name: oc_trusted_servers id; Type: DEFAULT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_trusted_servers ALTER COLUMN id SET DEFAULT nextval('public.oc_trusted_servers_id_seq'::regclass);


--
-- Name: oc_twofactor_backupcodes id; Type: DEFAULT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_twofactor_backupcodes ALTER COLUMN id SET DEFAULT nextval('public.oc_twofactor_backupcodes_id_seq'::regclass);


--
-- Name: oc_vcategory id; Type: DEFAULT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_vcategory ALTER COLUMN id SET DEFAULT nextval('public.oc_vcategory_id_seq'::regclass);


--
-- Name: oc_whats_new id; Type: DEFAULT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_whats_new ALTER COLUMN id SET DEFAULT nextval('public.oc_whats_new_id_seq'::regclass);


--
-- Data for Name: oc_accounts; Type: TABLE DATA; Schema: public; Owner: oc_gingertech3
--

COPY public.oc_accounts (uid, data) FROM stdin;
GingerTech	{"displayname":{"value":"GingerTech","scope":"contacts","verified":"0"},"address":{"value":"","scope":"private","verified":"0"},"website":{"value":"","scope":"private","verified":"0"},"email":{"value":null,"scope":"contacts","verified":"0"},"avatar":{"scope":"contacts"},"phone":{"value":"","scope":"private","verified":"0"},"twitter":{"value":"","scope":"private","verified":"0"}}
\.


--
-- Data for Name: oc_activity; Type: TABLE DATA; Schema: public; Owner: oc_gingertech3
--

COPY public.oc_activity (activity_id, "timestamp", priority, type, "user", affecteduser, app, subject, subjectparams, message, messageparams, file, link, object_type, object_id) FROM stdin;
\.


--
-- Data for Name: oc_activity_mq; Type: TABLE DATA; Schema: public; Owner: oc_gingertech3
--

COPY public.oc_activity_mq (mail_id, amq_timestamp, amq_latest_send, amq_type, amq_affecteduser, amq_appid, amq_subject, amq_subjectparams, object_type, object_id) FROM stdin;
\.


--
-- Data for Name: oc_addressbookchanges; Type: TABLE DATA; Schema: public; Owner: oc_gingertech3
--

COPY public.oc_addressbookchanges (id, uri, synctoken, addressbookid, operation) FROM stdin;
\.


--
-- Data for Name: oc_addressbooks; Type: TABLE DATA; Schema: public; Owner: oc_gingertech3
--

COPY public.oc_addressbooks (id, principaluri, displayname, uri, description, synctoken) FROM stdin;
\.


--
-- Data for Name: oc_appconfig; Type: TABLE DATA; Schema: public; Owner: oc_gingertech3
--

COPY public.oc_appconfig (appid, configkey, configvalue) FROM stdin;
core	installedat	1557650328.7179
core	lastupdatedat	1557650328.7324
core	vendor	nextcloud
cloud_federation_api	installed_version	0.1.0
cloud_federation_api	types	filesystem
cloud_federation_api	enabled	yes
theming	installed_version	1.6.0
theming	types	logging
theming	enabled	yes
support	installed_version	1.0.0
support	types	
support	enabled	yes
password_policy	installed_version	1.5.0
password_policy	types	
password_policy	enabled	yes
files_pdfviewer	installed_version	1.4.0
files_pdfviewer	types	
files_pdfviewer	enabled	yes
twofactor_backupcodes	installed_version	1.4.1
twofactor_backupcodes	types	
twofactor_backupcodes	enabled	yes
workflowengine	installed_version	1.5.0
workflowengine	types	filesystem
workflowengine	enabled	yes
nextcloud_announcements	installed_version	1.4.0
nextcloud_announcements	types	logging
nextcloud_announcements	enabled	yes
serverinfo	installed_version	1.5.0
serverinfo	types	
serverinfo	enabled	yes
lookup_server_connector	installed_version	1.3.0
lookup_server_connector	types	authentication
lookup_server_connector	enabled	yes
files_videoplayer	installed_version	1.4.0
files_videoplayer	types	
files_videoplayer	enabled	yes
dav	installed_version	1.8.1
core	public_webdav	dav/appinfo/v1/publicwebdav.php
dav	types	filesystem
dav	enabled	yes
systemtags	installed_version	1.5.0
systemtags	types	logging
systemtags	enabled	yes
notifications	installed_version	2.3.0
notifications	types	logging
notifications	enabled	yes
survey_client	installed_version	1.3.0
survey_client	types	
survey_client	enabled	yes
comments	installed_version	1.5.0
comments	types	logging
comments	enabled	yes
files_trashbin	installed_version	1.5.0
files_trashbin	types	filesystem,dav
files_trashbin	enabled	yes
logreader	installed_version	2.0.0
logreader	types	
logreader	enabled	yes
files_texteditor	installed_version	2.7.0
files_texteditor	types	
files_texteditor	enabled	yes
updatenotification	installed_version	1.5.0
updatenotification	types	
updatenotification	enabled	yes
sharebymail	installed_version	1.5.0
sharebymail	types	filesystem
sharebymail	enabled	yes
provisioning_api	installed_version	1.5.0
provisioning_api	types	prevent_group_restriction
provisioning_api	enabled	yes
oauth2	installed_version	1.3.0
oauth2	types	authentication
oauth2	enabled	yes
gallery	installed_version	18.2.0
gallery	types	
gallery	enabled	yes
federatedfilesharing	installed_version	1.5.0
federatedfilesharing	types	
federatedfilesharing	enabled	yes
files_versions	installed_version	1.8.0
files_versions	types	filesystem,dav
files_versions	enabled	yes
federation	installed_version	1.5.0
federation	types	authentication
federation	enabled	yes
activity	installed_version	2.8.2
activity	types	filesystem
activity	enabled	yes
files	installed_version	1.10.0
files	types	filesystem
files	enabled	yes
accessibility	installed_version	1.1.0
accessibility	types	
accessibility	enabled	yes
files_sharing	installed_version	1.7.0
core	public_files	files_sharing/public.php
files_sharing	types	filesystem
files_sharing	enabled	yes
firstrunwizard	installed_version	2.4.0
firstrunwizard	types	logging
firstrunwizard	enabled	yes
bruteforcesettings	installed_version	1.3.0
bruteforcesettings	types	
bruteforcesettings	enabled	yes
core	installed.bundles	["CoreBundle"]
core	oc.integritycheck.checker	{"core":{"EXTRA_FILE":{".webapp-nextcloud-15.0.7":{"expected":"","current":false}}}}
theming	cachebuster	8
theming	slogan	the best cloud
backgroundjob	lastjob	11
theming	name	GingerTech Cloud
core	scss.variables	d7ed337e9312699a90d9c2f345db0b56
core	lastcron	1557650627
theming	color	#000000
\.


--
-- Data for Name: oc_authtoken; Type: TABLE DATA; Schema: public; Owner: oc_gingertech3
--

COPY public.oc_authtoken (id, uid, login_name, password, name, token, type, remember, last_activity, last_check, scope, expires, private_key, public_key, version, password_invalid) FROM stdin;
1	GingerTech	GingerTech	ac11f2b489be372ab3696b7a537eb9ca|Q0vZih1p0Y2BqVxB|bf827d14eb735a35443599e88a94e9f11ec6c4f88b7e59727255b1f28c01ae84be6b69bae9f08bf451fef35683ba80bebd39fd6dc23d9d836cb2420a219f2eb6	Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:66.0) Gecko/20100101 Firefox/66.0	c741fc11a1cc748c1b126adbe0b1f0c47da4ee7b896ad03ebcc1084d90ec186dcf6dd880f50038cd1a8ea7ca02117dd0fb1b05c861b6c3ed0adac270b14a33cf	0	0	1557650366	1557650366	\N	\N	\N	\N	1	f
2	GingerTech	GingerTech	dP+GzMyhAcCo65mOOJH7DzKXfTg5yMswzV+8G+OLY8O/Z2KcIsTEZ0PdOYnA/YpIm6E0sVZnNrZykLUYecF8J2hLt6QPK2zduUsK5b6SNxy3ldCbAfvA/tBpTgoycd5mlzKdl+L9UP67yLUvJCBFUUxuN5YmtRx7NvP9He+dnaJS3wHIE5kmRvkkmyNB459IyGEpCOwASIoG447nSCOQ9dwyLXIQxEpRomoSFe4QpOw/NCYtTXil/Y2q8iIlf/4wbemiqsiFBQxKG+aKWr2Z1bFoBEdVjVEMeWxWGUenlfwo9tVNw8+wAZYR+dMt6jSCdzH+Bs+JgQDZ2W/MC6BDeQ==	Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:66.0) Gecko/20100101 Firefox/66.0	2ea0ac919abfb0d14aa8e9c97fbc419569ea990632c854fe1156b9bb17f0cb52ec7e59c2a7af0c24f76f643f0d20062e6ff46f3a9cf98ff7245e369925ad1c2a	0	1	1557650687	1557650423	\N	\N	da21b9884bd7c0eeedcd0cd2914817028ae7669d285cb0f34bc48391c7cbde874e179fe1d9904dcdfd5145a91300321e8faed241a7dd74f437f7e0fdbff0de22bd78d80f8c1151e3b660e230b2ce388c4877fbdb38e0cffb5c7432005f804f2f077c9c53c6af1f7f6731585b5e242269f29c05004a156c8cca88b587b5242d012db406ee0d30be4497c1f0f9ceaec7f7a06f7d0b42ba48a9a714fd404fe87a82309fa4a376bd75782eb53370f40905855d85ae3796245154dae96a97f37340ec4a8bb3bf58883f317a9a34ed319940bae3d1a923abedff1351338babd2c056d34705fa2ebf0493e1d72f1abf38f5c4a1501c266b49c64e74093a07fd8923afa83572d0651b883afe37195e22167f2e038fc51da1bac1e1513249265cd7f54678fc898541c65fb63fba32e2f613cd11f8510deb8ce839b43be04da66cd3af090849c5340d4aec3ac943624820984d36610847075fd678598061bd9987da8d004c65d5daa4223b72bc7ed08b11cc54dd6ff93a51e581bfb0874817a620a1d381e04e88c8edf12a3b2766963bbfba6eb8b9037cef8a1c41a04bdb1ae299857763f0333e21670bffa0494bef7de08835573a2acd8d85894e753353ab341f033986c1e64efd11e89f52c25f3356c3c69a16e852d91b9743e2d19077ec52d5fbb97fd7f54f40bfe298fdd3b2f366fe8e3df04e1fe2d294623cc163660c71d720b2727a344b281226b7c6a705dddcd450007ab41d0e2099d36ee686137de598d408ca4155fd9e077fce5f5458755e4763d88e5b235e9f46fa5390e3262a3d91fb7eb16cdae8c3b3bdd0cf36f8ed90801941c38c1c3fc8dafb2259a372aa3418927b992449f01d4ebc80ae37db8251c05f9078876860e8c4548b504e53896e8604f23b5aa4dcfb08fd1feaca25ab237c1159e40701c383a9677e13a799eb3f66e22b65b7d77e97bf91c68ecc29ea8861c4e3f6e1cf689462b8a71fd035b1416f6370aefd11c51aca9aac5bd859674e6e3bed3cd06c2915f8965f7af15dab633a13582bfede674d7f9fdb4ee5136428ebe266d440407372e04c49036c8005378a7fb81eaf7ac1e50e68448edb8dd6167fe8710bc8621288be2cf787c2d166eefecfe26f9f3a011742f6bd597ac7bbacdb63c9dec7a3a429b380bcf790f5654160092cbd8218ee6bb285b3a51e0f98ba430ff5632a0364fe2919b0c4d3053fcde66cf51dab9deacca7d3e735f07e8ffa871078b3a40215f600940ed9efd7d96980e97114009cc5c0f51832ec601e07c61e12bdb326c08bd7d6ca3dfda4d8104a5ea7a1ce555b7c1beb2cb06b1e40596fc478c63c24409d34a000aca5771d2d4a9e7b5c504aa24a86b69702b5595b4b28bee1a0e1f0a8767e35cd64de58f4d9b0531992388f8831284e05a6a1784312d2c212399cbe267178a3969319bb888e3baf55dae5c35d0874fbeb59c2b0c078b0252234b0bfec32f359a6e35dc22a5f3ebb96eeed3292568d84028a1b202f6fceb19127874de45b4c3a46675500016069c446321c8c549502281c2905a7ea85c771fc753b4f6a2d0d8b788a9e776134abf2a5c8253ffef5fcd0e9183e2802e05aedd63bc0a403b55a46b3ec53dd237919da247a622695c50b887448c4b4403dbf5601f4db0602a93e4e22e982f1e4c8f829471b6e73a04f6b0dc2bf8030fa2ee9d4255ba086b785d2778e021a39ffed38ea0870330123029542162855ce51720f52983f9014e360a56be8dc98fb4257425e6a78a4b256d79fd671b6c5bc378e0822d752e0f7b5bb0f05b43eb80b516e8c196e9ce1a7128f88b4413e3592cc68fa3aa8e1cc9bd43b16375634921bd2efe7dd32e82d2f54e4d6a450d59a0e9b036ba9ae9a74165c12785ca0a13ec127d6ca67d2f8f4b874b77d74a760b888841c2b346811a0c36d343a0189292a2f990958041f98b0f9479e1877e12d8f0670a9117e91d323ce60c19909f3ee589a6c33bc0bc83ca91dd47254ae35751e16ee507dd9d84eb29e6215eafa10dff48ee50bb86db94e9874f90a51ffa3afe3b6295d9ff7862f2273e6b3a697d2de0d84f303bd39b7b6ccb80350de5f9d46822d6d1e1d180e013488869d7f9791f118155d7a20f6e8230cb25f9c97dcadb5d825e92c7a00870b488b7627463c8230d71727b6a6c7b74358a5abfb229ea5b2952abcdcca4685def86534a9707964162d4cc1e09c84ac8aa1c0295692784e30ed1e301e12b98480e482c9368cf72b8dd4f84455dcfca73ebdc15d296c79494bc56a52a794e1d1b547c8c0175e1c74cabb7a71b4a86f94a38bfb30c98ae18c34e255b6aaa209b2ba9243aef13a5f67edf0ef96aec6cc465ac8c3fcadaa1bfe3650d187c961dbce917a10d4ea52e0f1f033beed5f6fac43e5433e0af37e028e72cee80449400aa522ee3f|LChhLC+5XmLLJeB6|5b222c5b0b819ca4a1a0414bc98685e7fc3e99473d07b915e96db20b643c558fab8d941e30034f962507afa44e215c8d87116e4386fedd7423319e9daca93699	-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAm32/xDIBjMnOv56KyAvt\nTS19UjOjDIe0yT8OLcHRGnIOzbCTYuujlQ0x6ZLqB+bRzHNRQcSgARJCCrlJBvxv\np4E3mj+g0tZylj0cRZE/gaPG1xOAdpgClWTDqT/pmW3hDQKN3P6NC/fYYj6iz6jJ\nd8o8np/6uCY1PDHSXJoKwroz71E4YbqK0S7NsEW7i1i2NW9OPyacj5qzrQesEk4+\nXk4m+1ZYaJ1bPWVnokWSstc3xI8GrKcncIywBXsdN3qBrL2YGKFF+CLaavbioW0i\ngq35mBqNe2A3XsrPNaGrUxaSdK/mbrLj9auCUCTRONpz4cPsHwWxEeKm6xSLnwXH\ngwIDAQAB\n-----END PUBLIC KEY-----\n	2	f
\.


--
-- Data for Name: oc_bruteforce_attempts; Type: TABLE DATA; Schema: public; Owner: oc_gingertech3
--

COPY public.oc_bruteforce_attempts (id, action, occurred, ip, subnet, metadata) FROM stdin;
\.


--
-- Data for Name: oc_calendar_invitations; Type: TABLE DATA; Schema: public; Owner: oc_gingertech3
--

COPY public.oc_calendar_invitations (id, uid, recurrenceid, attendee, organizer, sequence, token, expiration) FROM stdin;
\.


--
-- Data for Name: oc_calendar_resources; Type: TABLE DATA; Schema: public; Owner: oc_gingertech3
--

COPY public.oc_calendar_resources (id, backend_id, resource_id, email, displayname, group_restrictions) FROM stdin;
\.


--
-- Data for Name: oc_calendar_rooms; Type: TABLE DATA; Schema: public; Owner: oc_gingertech3
--

COPY public.oc_calendar_rooms (id, backend_id, resource_id, email, displayname, group_restrictions) FROM stdin;
\.


--
-- Data for Name: oc_calendarchanges; Type: TABLE DATA; Schema: public; Owner: oc_gingertech3
--

COPY public.oc_calendarchanges (id, uri, synctoken, calendarid, operation, calendartype) FROM stdin;
\.


--
-- Data for Name: oc_calendarobjects; Type: TABLE DATA; Schema: public; Owner: oc_gingertech3
--

COPY public.oc_calendarobjects (id, calendardata, uri, calendarid, lastmodified, etag, size, componenttype, firstoccurence, lastoccurence, uid, classification, calendartype) FROM stdin;
\.


--
-- Data for Name: oc_calendarobjects_props; Type: TABLE DATA; Schema: public; Owner: oc_gingertech3
--

COPY public.oc_calendarobjects_props (id, calendarid, objectid, name, parameter, value, calendartype) FROM stdin;
\.


--
-- Data for Name: oc_calendars; Type: TABLE DATA; Schema: public; Owner: oc_gingertech3
--

COPY public.oc_calendars (id, principaluri, displayname, uri, synctoken, description, calendarorder, calendarcolor, timezone, components, transparent) FROM stdin;
\.


--
-- Data for Name: oc_calendarsubscriptions; Type: TABLE DATA; Schema: public; Owner: oc_gingertech3
--

COPY public.oc_calendarsubscriptions (id, uri, principaluri, displayname, refreshrate, calendarorder, calendarcolor, striptodos, stripalarms, stripattachments, lastmodified, synctoken, source) FROM stdin;
\.


--
-- Data for Name: oc_cards; Type: TABLE DATA; Schema: public; Owner: oc_gingertech3
--

COPY public.oc_cards (id, addressbookid, carddata, uri, lastmodified, etag, size, uid) FROM stdin;
\.


--
-- Data for Name: oc_cards_properties; Type: TABLE DATA; Schema: public; Owner: oc_gingertech3
--

COPY public.oc_cards_properties (id, addressbookid, cardid, name, value, preferred) FROM stdin;
\.


--
-- Data for Name: oc_comments; Type: TABLE DATA; Schema: public; Owner: oc_gingertech3
--

COPY public.oc_comments (id, parent_id, topmost_parent_id, children_count, actor_type, actor_id, message, verb, creation_timestamp, latest_child_timestamp, object_type, object_id) FROM stdin;
\.


--
-- Data for Name: oc_comments_read_markers; Type: TABLE DATA; Schema: public; Owner: oc_gingertech3
--

COPY public.oc_comments_read_markers (user_id, marker_datetime, object_type, object_id) FROM stdin;
\.


--
-- Data for Name: oc_credentials; Type: TABLE DATA; Schema: public; Owner: oc_gingertech3
--

COPY public.oc_credentials ("user", identifier, credentials) FROM stdin;
\.


--
-- Data for Name: oc_dav_shares; Type: TABLE DATA; Schema: public; Owner: oc_gingertech3
--

COPY public.oc_dav_shares (id, principaluri, type, access, resourceid, publicuri) FROM stdin;
\.


--
-- Data for Name: oc_directlink; Type: TABLE DATA; Schema: public; Owner: oc_gingertech3
--

COPY public.oc_directlink (id, user_id, file_id, token, expiration) FROM stdin;
\.


--
-- Data for Name: oc_federated_reshares; Type: TABLE DATA; Schema: public; Owner: oc_gingertech3
--

COPY public.oc_federated_reshares (share_id, remote_id) FROM stdin;
\.


--
-- Data for Name: oc_file_locks; Type: TABLE DATA; Schema: public; Owner: oc_gingertech3
--

COPY public.oc_file_locks (id, lock, key, ttl) FROM stdin;
3	0	files/6ab18a67ef695bd502239a9bc6b8ef45	1557654037
1	0	files/d45cfce9a52f478c800deb061282ce66	1557654036
2	0	files/5ee62af6b264924c716527e41e0ba0e5	1557654036
4	0	files/e8ac88ae0dd6a50c6fa2d593ac67f314	1557654037
7	0	files/75f46e289c4aac7690de1aeb5f0fe297	1557654184
8	0	files/81beb91bb4e05a515d1f544bd44938dd	1557654184
\.


--
-- Data for Name: oc_filecache; Type: TABLE DATA; Schema: public; Owner: oc_gingertech3
--

COPY public.oc_filecache (fileid, storage, path, path_hash, parent, name, mimetype, mimepart, size, mtime, storage_mtime, encrypted, unencrypted_size, etag, permissions, checksum) FROM stdin;
256	1	appdata_ocgmgdeym2id/css/files/e8ed-a382-merged.css.deps	a7922023a37d855c53cbada9fb870cb9	103	e8ed-a382-merged.css.deps	15	3	672	1557650623	1557650623	0	0	d6922b64d7be2a1176e7369bde879e95	27	
5	1	appdata_ocgmgdeym2id/preview	e7f36bb9aa56b1009e2e1b6ff77c09e0	2	preview	2	1	96743	1557650439	1557650437	0	0	5cd7dc0779283	31	
257	1	appdata_ocgmgdeym2id/css/files/e8ed-a382-merged.css.gzip	6ce3599ed5aab3dfe245fdb74d80d96a	103	e8ed-a382-merged.css.gzip	16	3	5278	1557650623	1557650623	0	0	8026493a76a534647c2187a6c17e2be5	27	
12	2	files/Documents/User Data Manifesto.pdf	5e60cf6ee166400ac56993095e207c56	8	User Data Manifesto.pdf	5	3	36861	1557650366	1557650366	0	0	1e360f9b100a2a840ba6b36ba4c60baa	27	
8	2	files/Documents	0ad78ba05b6961d92f7970b2b3922eca	7	Documents	2	1	2644688	1557650366	1557650366	0	0	5cd7dbbe12d80	31	
4	1	appdata_ocgmgdeym2id/appstore/apps.json	53f5537e68b71451577efa7ee8364cbb	3	apps.json	4	3	991106	1557650362	1557650362	0	0	addfeb0193192f6869f0132807b5348f	27	
3	1	appdata_ocgmgdeym2id/appstore	74d704a80d78dbb3c4b4084f928de055	2	appstore	2	1	991106	1557650362	1557650360	0	0	5cd7dbbab4693	31	
14	2	files/Photos/Nut.jpg	aa8daeb975e1d39412954fd5cd41adb4	13	Nut.jpg	10	9	955026	1557650366	1557650366	0	0	82d435e64b73371ca61de456fb6d73e2	27	
15	2	files/Photos/Nextcloud Community.jpg	ee47a9ab6cce8e8e0d4021d5eb51e3d8	13	Nextcloud Community.jpg	10	9	797325	1557650366	1557650366	0	0	b7286b9b07de43ade40c97dff068cf0c	27	
16	2	files/Photos/Coast.jpg	a6fe87299d78b207e9b7aba0f0cb8a0a	13	Coast.jpg	10	9	819766	1557650366	1557650366	0	0	f32e3f142a33eb528c0827e88e7b9dd2	27	
17	2	files/Photos/Hummingbird.jpg	e077463269c404ae0f6f8ea7f2d7a326	13	Hummingbird.jpg	10	9	585219	1557650366	1557650366	0	0	06ccbfdce66574dfefab4f90f0320a3b	27	
13	2	files/Photos	d01bb67e7b71dd49fd06bad922f521c9	7	Photos	2	1	3157336	1557650366	1557650366	0	0	5cd7dbbe552e3	31	
18	2	files/Nextcloud.mp4	77a79c09b93e57cba23c11eb0e6048a6	7	Nextcloud.mp4	12	11	462413	1557650366	1557650366	0	0	c58427c656b3409529a2ff571a6ddeca	27	
19	2	files/Nextcloud Manual.pdf	2bc58a43566a8edde804a4a97a9c7469	7	Nextcloud Manual.pdf	5	3	6630961	1557650366	1557650366	0	0	51ade06b2485268095e5877563a76f7a	27	
20	2	files/Nextcloud.png	2bcc0ff06465ef1bfc4a868efde1e485	7	Nextcloud.png	13	9	37042	1557650366	1557650366	0	0	ad56299f52c5e7e92a6e29c50c3ae7fa	27	
9	2	files/Documents/Nextcloud Flyer.pdf	dda5bc1db7ea6619926b0dac54e69262	8	Nextcloud Flyer.pdf	5	3	2529331	1557650365	1557650365	0	0	1b711e64f34c2c742d948c47b17f0e0c	27	
10	2	files/Documents/About.odt	b2ee7d56df9f34a0195d4b611376e885	8	About.odt	6	3	77422	1557650365	1557650365	0	0	0a266afbabc0d993d6ab1b1972116f63	27	
7	2	files	45b963397aa40d4a0063e0d85e4fe7a1	6	files	2	1	12932440	1557650366	1557650366	0	0	5cd7dbbeaaae6	31	
11	2	files/Documents/About.txt	9da7b739e7a65d74793b2881da521169	8	About.txt	8	7	1074	1557650366	1557650366	0	0	746e0c11217e936cded0f534e46c76ff	27	
24	1	appdata_ocgmgdeym2id/js/core/merged-template-prepend.js	4354939a57805a878740277c0fbc4aa0	23	merged-template-prepend.js	14	3	158477	1557650414	1557650414	0	0	2d0ef6b49fc5ac09fc48b36c90be023b	27	
25	1	appdata_ocgmgdeym2id/js/core/merged-template-prepend.js.deps	9aa016818db4954c55fb308bb2f1e20e	23	merged-template-prepend.js.deps	15	3	1626	1557650414	1557650414	0	0	c9c4c123b2ca238f7b7eef1b0f8bf250	27	
26	1	appdata_ocgmgdeym2id/js/core/merged-template-prepend.js.gzip	0f72cc418864f42fddb85d4439e2a298	23	merged-template-prepend.js.gzip	16	3	42513	1557650414	1557650414	0	0	77717c21b1cc79aa45dab80a555776f7	27	
28	1	appdata_ocgmgdeym2id/js/core/merged-share-backend.js.deps	401f001d53a53066d0da25224c297933	23	merged-share-backend.js.deps	15	3	871	1557650414	1557650414	0	0	536a2db200f2e7cb3e8ee43a393b526a	27	
27	1	appdata_ocgmgdeym2id/js/core/merged-share-backend.js	beefd117f624c3d7a285c6df2f1d8194	23	merged-share-backend.js	14	3	207019	1557650414	1557650414	0	0	8a9242b9636b96ae8ad9c88db26d6ae4	27	
29	1	appdata_ocgmgdeym2id/js/core/merged-share-backend.js.gzip	f37968bb9c1bd123c0c0ed0bb1a6b451	23	merged-share-backend.js.gzip	16	3	31418	1557650414	1557650414	0	0	e4af3e13693a81119a76a9a44e4ebbd4	27	
31	1	appdata_ocgmgdeym2id/js/core/merged-login.js.deps	5549eced74344017c21867945a564528	23	merged-login.js.deps	15	3	323	1557650414	1557650414	0	0	cff2db0ff8b2805af906b8af441b0ad0	27	
30	1	appdata_ocgmgdeym2id/js/core/merged-login.js	f5388e77d5f99cd83e1192ab900d8738	23	merged-login.js	14	3	7624	1557650414	1557650414	0	0	62d3918ee39f2cf990b9bf5e9c2b110c	27	
32	1	appdata_ocgmgdeym2id/js/core/merged-login.js.gzip	e32940252fd1085424fbea2a51b7abb1	23	merged-login.js.gzip	16	3	2322	1557650415	1557650415	0	0	c69a496dc97a7485abf9cfa1e9785e66	27	
6	2		d41d8cd98f00b204e9800998ecf8427e	-1		2	1	12932440	1557650423	1557650423	0	0	5cd7dbf73a994	23	
23	1	appdata_ocgmgdeym2id/js/core	c7bed835cfa129bc8105e105e64314ed	22	core	2	1	484181	1557650426	1557650425	0	0	5cd7dbfa24165	31	
22	1	appdata_ocgmgdeym2id/js	974a6162cca29f3d6c64fef82a4dc9ba	2	js	2	1	2284964	1557650426	1557650426	0	0	5cd7dbfa6f64e	31	
41	2	cache	0fea6a13c52b4d4725368f24b045ca84	6	cache	2	1	0	1557650423	1557650423	0	0	5cd7dbf73270e	31	
255	1	appdata_ocgmgdeym2id/css/files/e8ed-a382-merged.css	c79e863214d87378855c08281e235820	103	e8ed-a382-merged.css	17	7	26759	1557650623	1557650623	0	0	c756c89bb889d004b770a0687f4036c2	27	
259	1	appdata_ocgmgdeym2id/css/files_trashbin/35c3-a382-trash.css.deps	c4eff4e145170f341fa212585c34eb0e	107	35c3-a382-trash.css.deps	15	3	256	1557650623	1557650623	0	0	1f230a657e47e14cd589d3a82688b42d	27	
33	1	appdata_ocgmgdeym2id/css	d60614ef7eba4c97c75d8452c7f76bae	2	css	2	1	-436	1557650626	1557650611	0	0	5cd7dcc273946	31	
43	1	appdata_ocgmgdeym2id/avatar/GingerTech	67ec075d99b46bbbb0f54703c83dc036	42	GingerTech	2	1	19702	1557650556	1557650556	0	0	5cd7dc7cd6330	31	
46	1	appdata_ocgmgdeym2id/js/files/merged-index.js.deps	918a711619ae4f6a4f432180d3de6819	44	merged-index.js.deps	15	3	2669	1557650423	1557650423	0	0	4666944a31e855a2a63e7e4c8d94b741	27	
47	1	appdata_ocgmgdeym2id/js/files/merged-index.js.gzip	d3dbdcc5676aac1eb84751352139cdc6	44	merged-index.js.gzip	16	3	87287	1557650423	1557650423	0	0	d71fae091322f8bedb506b84418abe0f	27	
45	1	appdata_ocgmgdeym2id/js/files/merged-index.js	91e51f5b43552a68c7767fed87f4671a	44	merged-index.js	14	3	381031	1557650423	1557650423	0	0	621f16bb09564a16c6499f4346e47fea	27	
51	1	appdata_ocgmgdeym2id/js/activity/activity-sidebar.js.gzip	904154e7b642c90d08109957de0e9b5a	48	activity-sidebar.js.gzip	16	3	4924	1557650424	1557650424	0	0	d190e1930110a3dd22d465837c491634	27	
44	1	appdata_ocgmgdeym2id/js/files	494b8f8c8f45e19083fbecd0537d48e5	22	files	2	1	470987	1557650423	1557650423	0	0	5cd7dbf7c5782	31	
49	1	appdata_ocgmgdeym2id/js/activity/activity-sidebar.js	d94730235408cc580bc784d9aa2e6cb4	48	activity-sidebar.js	14	3	27440	1557650423	1557650423	0	0	2101ef3a4d53aa41261a9573f5d22c03	27	
48	1	appdata_ocgmgdeym2id/js/activity	0834a00641d101d6c06e62ec4642f264	22	activity	2	1	33024	1557650424	1557650423	0	0	5cd7dbf81482c	31	
50	1	appdata_ocgmgdeym2id/js/activity/activity-sidebar.js.deps	f5a9d59e97d3ed3363b3507beeb40554	48	activity-sidebar.js.deps	15	3	660	1557650424	1557650424	0	0	c0eb870efa8a7a26da65da646ac421d4	27	
54	1	appdata_ocgmgdeym2id/js/comments/merged.js.deps	d8ac784e02f33fd2f78ddcc299612a89	52	merged.js.deps	15	3	1248	1557650424	1557650424	0	0	1ca8fc1ee87231da17c028452aeb6491	27	
55	1	appdata_ocgmgdeym2id/js/comments/merged.js.gzip	3050c76e98e4701146fff2b81b39d555	52	merged.js.gzip	16	3	20087	1557650424	1557650424	0	0	6350a3858d3fb7cf7994d0f156716f18	27	
53	1	appdata_ocgmgdeym2id/js/comments/merged.js	9022c65ea39651335dd5a52ba5f132be	52	merged.js	14	3	80228	1557650424	1557650424	0	0	1aaaa9190a9670b0be8bdb546e8cde5f	27	
57	1	appdata_ocgmgdeym2id/js/files_versions/merged.js	64585779d2ceced6bcf2702cd205742e	56	merged.js	14	3	16630	1557650424	1557650424	0	0	51246c2d62c8413ede68dafe77e9aa6c	27	
52	1	appdata_ocgmgdeym2id/js/comments	58109bd69745b52ab7c061aff1ddb9d8	22	comments	2	1	101563	1557650424	1557650424	0	0	5cd7dbf857b3b	31	
59	1	appdata_ocgmgdeym2id/js/files_versions/merged.js.gzip	22a7a48678341820d2cd0ad5d2ee8034	56	merged.js.gzip	16	3	3922	1557650424	1557650424	0	0	a75d993cffe10a1dbb07f83213b05b71	27	
58	1	appdata_ocgmgdeym2id/js/files_versions/merged.js.deps	7378f6cc7716f25ecba7e81a8927ebd9	56	merged.js.deps	15	3	583	1557650424	1557650424	0	0	55affa41de2b296d16652c441125658b	27	
56	1	appdata_ocgmgdeym2id/js/files_versions	1bdc94d1ac252ad6f794ef4b8cd2ac45	22	files_versions	2	1	21135	1557650424	1557650424	0	0	5cd7dbf898a8e	31	
61	1	appdata_ocgmgdeym2id/js/files_sharing/additionalScripts.js	c47619adc4c51011f5a88684442730da	60	additionalScripts.js	14	3	14613	1557650424	1557650424	0	0	12d8a07cf1b3b5e84a21537dcff4e3fa	27	
62	1	appdata_ocgmgdeym2id/js/files_sharing/additionalScripts.js.deps	1337ae98a57991064eefa77a4da56705	60	additionalScripts.js.deps	15	3	392	1557650424	1557650424	0	0	82fec48360ebdba65eaa9087786fba65	27	
63	1	appdata_ocgmgdeym2id/js/files_sharing/additionalScripts.js.gzip	c3f195ea1cf234575e9c92f6329cbe38	60	additionalScripts.js.gzip	16	3	4487	1557650424	1557650424	0	0	ffd6c9bbdffcb98f06b5efe2d6ddc570	27	
219	1	appdata_ocgmgdeym2id/css/theming/ca9f-a382-theming.css	909f2d90e0444236973c2bad1081f0fc	35	ca9f-a382-theming.css	17	7	975	1557650586	1557650586	0	0	d1599a989949ab0f5d6dc0696e21f3a1	27	
220	1	appdata_ocgmgdeym2id/css/theming/ca9f-a382-theming.css.deps	3d0de8c0d4f7efcd1722b5ad8036518d	35	ca9f-a382-theming.css.deps	15	3	251	1557650586	1557650586	0	0	c4dbc3d9e5872d3e371227d69beca8a3	27	
35	1	appdata_ocgmgdeym2id/css/theming	9c2c2dcd6ec0ec3c9d2046ef64c58e63	33	theming	2	1	1602	1557650586	1557650586	0	0	5cd7dc9a7facb	31	
221	1	appdata_ocgmgdeym2id/css/theming/ca9f-a382-theming.css.gzip	12c592ba70b074db847bb20fcb9a0b2a	35	ca9f-a382-theming.css.gzip	16	3	376	1557650586	1557650586	0	0	444ef06ec713bd6efb87c38df62aa350	27	
258	1	appdata_ocgmgdeym2id/css/files_trashbin/35c3-a382-trash.css	5c63a29dcc41d5f1ab9da39fcceef588	107	35c3-a382-trash.css	17	7	344	1557650623	1557650623	0	0	0804c55e55712b629a922dfb6c39d929	27	
260	1	appdata_ocgmgdeym2id/css/files_trashbin/35c3-a382-trash.css.gzip	fc6c751ed243b1bb115c11694fd731c3	107	35c3-a382-trash.css.gzip	16	3	161	1557650623	1557650623	0	0	ab0b94b0abfb8344ade7790935757087	27	
67	1	appdata_ocgmgdeym2id/js/files_texteditor/merged.js.gzip	fb5b76771845f3254f747ef6b9de2895	64	merged.js.gzip	16	3	139163	1557650425	1557650425	0	0	53440fd4a5f575ae0043ebc86d40166b	27	
261	1	appdata_ocgmgdeym2id/css/activity/15ac-a382-style.css	c961fc5c643dc360c80fb885afa8cd55	111	15ac-a382-style.css	17	7	3260	1557650624	1557650624	0	0	dd8262e35d4fc32a26abf49dae01f91c	27	
262	1	appdata_ocgmgdeym2id/css/activity/15ac-a382-style.css.deps	64452b22af3ad41682b1fc2aa5648af4	111	15ac-a382-style.css.deps	15	3	250	1557650624	1557650624	0	0	8b1874b5adffed2e2d8e13cfb38e7190	27	
263	1	appdata_ocgmgdeym2id/css/activity/15ac-a382-style.css.gzip	9196f1b8997e6bcd08d6e27da5c93467	111	15ac-a382-style.css.gzip	16	3	1125	1557650624	1557650624	0	0	8dcd7813429bf622064bfbf2878c6f4f	27	
60	1	appdata_ocgmgdeym2id/js/files_sharing	2e6f5bb494a427bdc93452970332f2d3	22	files_sharing	2	1	19492	1557650424	1557650424	0	0	5cd7dbf8d9368	31	
265	1	appdata_ocgmgdeym2id/css/comments/35c3-a382-autocomplete.css.deps	46ab6faf4009b4cc3331e0d9566dca7e	115	35c3-a382-autocomplete.css.deps	15	3	257	1557650624	1557650624	0	0	e0a4dd0706773f7f00cef12efc1c72d4	27	
64	1	appdata_ocgmgdeym2id/js/files_texteditor	773f01a92247a5d9477d2f899f5279bb	22	files_texteditor	2	1	839501	1557650425	1557650425	0	0	5cd7dbf95c885	31	
79	1	appdata_ocgmgdeym2id/css/core	ba271cad59d3d60ee43eccc6c97b38f5	33	core	2	1	-436	1557650626	1557650625	0	0	5cd7dcc2156fc	31	
71	1	appdata_ocgmgdeym2id/js/gallery/scripts-for-file-app.js.gzip	9ff8a0b1cadb6cd01aff245e44e7a6d8	68	scripts-for-file-app.js.gzip	16	3	55971	1557650425	1557650425	0	0	f830eeac15861073aa289219c49678bd	27	
65	1	appdata_ocgmgdeym2id/js/files_texteditor/merged.js	d6929a8b7f8f13bd97eb1547d1b8547c	64	merged.js	14	3	699916	1557650425	1557650425	0	0	7d787025dd6be6e66e6af3f1e2289d05	27	
66	1	appdata_ocgmgdeym2id/js/files_texteditor/merged.js.deps	a1e1a3ce64e75277f3e10df05fc3d497	64	merged.js.deps	15	3	422	1557650425	1557650425	0	0	e0e54f748ee2ad2cce4b90bfb813ef59	27	
68	1	appdata_ocgmgdeym2id/js/gallery	fd3649e1d97bc79bf72281986b1d289a	22	gallery	2	1	290861	1557650425	1557650425	0	0	5cd7dbf9de3c4	31	
69	1	appdata_ocgmgdeym2id/js/gallery/scripts-for-file-app.js	2fb352dc21751af1c1ed3c51a69c7149	68	scripts-for-file-app.js	14	3	233904	1557650425	1557650425	0	0	554513300ff8d8d9c434658fe7e81aca	27	
78	1	appdata_ocgmgdeym2id/js/systemtags/merged.js.gzip	33898273bc45f78e1f3a24fd0b19418c	75	merged.js.gzip	16	3	5360	1557650426	1557650426	0	0	01fcaece8b2ee2c6caa8c2a9b0a57b56	27	
70	1	appdata_ocgmgdeym2id/js/gallery/scripts-for-file-app.js.deps	6dea84e269d8cdc966060c15d8ef0b86	68	scripts-for-file-app.js.deps	15	3	986	1557650425	1557650425	0	0	57e9b5de44c2fe1c4f9de71ff9c46ece	27	
72	1	appdata_ocgmgdeym2id/js/core/merged.js	fb921bef87a16fa65b60f330a2e66eaf	23	merged.js	14	3	25390	1557650426	1557650426	0	0	42a23bf00520cae33fff6d2b99683724	27	
73	1	appdata_ocgmgdeym2id/js/core/merged.js.deps	4dcb967ca17314c883a089ccfb500085	23	merged.js.deps	15	3	676	1557650426	1557650426	0	0	561cdd72619c477c21b799aefce7b762	27	
74	1	appdata_ocgmgdeym2id/js/core/merged.js.gzip	10885a697c24c74ebcaf38382be4f14e	23	merged.js.gzip	16	3	5922	1557650426	1557650426	0	0	7f60e894891349e6aa10d6f0703ec9f9	27	
75	1	appdata_ocgmgdeym2id/js/systemtags	9879056b0a1e019b4c42fbde69db1d3d	22	systemtags	2	1	24220	1557650426	1557650426	0	0	5cd7dbfa6f64e	31	
76	1	appdata_ocgmgdeym2id/js/systemtags/merged.js	5708ff9332f65e145c4ff6fb6ee5dfb0	75	merged.js	14	3	18287	1557650426	1557650426	0	0	cf1a3f506d2377ff1636ef4e30ca31c2	27	
77	1	appdata_ocgmgdeym2id/js/systemtags/merged.js.deps	995e018f6db64e214cb136efa7bf625a	75	merged.js.deps	15	3	573	1557650426	1557650426	0	0	1ddcc7298159cd8a4807bd2cffdab5cf	27	
237	1	appdata_ocgmgdeym2id/css/core/3108-a382-jquery-ui-fixes.css	231b2408a5da04ccd16c28f65d94b7b2	79	3108-a382-jquery-ui-fixes.css	17	7	4978	1557650597	1557650597	0	0	0df55ff8cd5bde8d58939a2339e1d697	27	
238	1	appdata_ocgmgdeym2id/css/core/3108-a382-jquery-ui-fixes.css.deps	5f4c03166fbcbb7596cb355ad76952d0	79	3108-a382-jquery-ui-fixes.css.deps	15	3	250	1557650597	1557650597	0	0	2ac8d3e1d33cdf72d6f3493420316df4	27	
239	1	appdata_ocgmgdeym2id/css/core/3108-a382-jquery-ui-fixes.css.gzip	9c5909d829c54a1f051142bd4473ef4f	79	3108-a382-jquery-ui-fixes.css.gzip	16	3	933	1557650597	1557650597	0	0	b0c0f3886d01670fc8fbdc171a043ae8	27	
240	1	appdata_ocgmgdeym2id/css/settings/3108-a382-settings.css	171ce635186fa0f70c244898004393fc	146	3108-a382-settings.css	17	7	28349	1557650598	1557650598	0	0	c502a36071042743508c138257ef7455	27	
241	1	appdata_ocgmgdeym2id/css/settings/3108-a382-settings.css.deps	54ea0a935e9054bf78c6ad16f111aaf8	146	3108-a382-settings.css.deps	15	3	247	1557650598	1557650598	0	0	61d91b4df1740d7386d332ed3300d81c	27	
242	1	appdata_ocgmgdeym2id/css/settings/3108-a382-settings.css.gzip	3a779fb4c2551158b8b25e383b504a10	146	3108-a382-settings.css.gzip	16	3	5939	1557650598	1557650598	0	0	0025b53fbd123cf288e991a3f55e9e13	27	
107	1	appdata_ocgmgdeym2id/css/files_trashbin	468a5ce029a0d505c55a823113082a3f	33	files_trashbin	2	1	761	1557650623	1557650623	0	0	5cd7dcbfb8673	31	
103	1	appdata_ocgmgdeym2id/css/files	281a340f6ade5c57a4098ef4d27f21a3	33	files	2	1	32709	1557650623	1557650623	0	0	5cd7dcbf62015	31	
270	1	appdata_ocgmgdeym2id/css/files_sharing/6a15-a382-mergedAdditionalStyles.css	14d9158a61ebecda6e3e2c8e6e7be879	122	6a15-a382-mergedAdditionalStyles.css	17	7	5371	1557650625	1557650625	0	0	b9ecc8c4e4d076c0c080fcf01d00123c	27	
111	1	appdata_ocgmgdeym2id/css/activity	38902d9db083ec2f25a81d2b1e2125aa	33	activity	2	1	5460	1557650624	1557650623	0	0	5cd7dcc024aab	31	
267	1	appdata_ocgmgdeym2id/css/comments/35c3-a382-comments.css	c30dfbffce25efd399b4185640819784	115	35c3-a382-comments.css	17	7	5297	1557650624	1557650624	0	0	a0a0a0d644f395d0028eb2d51e00eabe	27	
264	1	appdata_ocgmgdeym2id/css/comments/35c3-a382-autocomplete.css	87713acd6ef6c0881575950e96c86872	115	35c3-a382-autocomplete.css	17	7	1211	1557650624	1557650624	0	0	3f49ea639385e8f6cd3b76cf1a09f4a3	27	
271	1	appdata_ocgmgdeym2id/css/files_sharing/6a15-a382-mergedAdditionalStyles.css.deps	edc1a3ad871e295aa8858d8e977d8adc	122	6a15-a382-mergedAdditionalStyles.css.deps	15	3	473	1557650625	1557650625	0	0	fd897cc2976dba2537eb175e458803e7	27	
266	1	appdata_ocgmgdeym2id/css/comments/35c3-a382-autocomplete.css.gzip	717e61d39aa2a0766c5fd74a8a815fa1	115	35c3-a382-autocomplete.css.gzip	16	3	434	1557650624	1557650624	0	0	c58e0d35dacc1b637ced51c56b8ce74f	27	
268	1	appdata_ocgmgdeym2id/css/comments/35c3-a382-comments.css.deps	e752c0de2dd883481de106eafec9b444	115	35c3-a382-comments.css.deps	15	3	253	1557650624	1557650624	0	0	f88c69489de7f95b2c663de218c85673	27	
272	1	appdata_ocgmgdeym2id/css/files_sharing/6a15-a382-mergedAdditionalStyles.css.gzip	ebcf3facba39da35ed6ac74d30ccfd72	122	6a15-a382-mergedAdditionalStyles.css.gzip	16	3	1425	1557650625	1557650625	0	0	2bd2e337e6ac6441ca86b18165cc3466	27	
269	1	appdata_ocgmgdeym2id/css/comments/35c3-a382-comments.css.gzip	ecf469ad11e908a875e0809f9f7771df	115	35c3-a382-comments.css.gzip	16	3	1192	1557650624	1557650624	0	0	6bf1b63aba08901b6b24067c9c4bc5c3	27	
115	1	appdata_ocgmgdeym2id/css/comments	36ab640ebe493d0f01c5ab15ba246c98	33	comments	2	1	8644	1557650624	1557650624	0	0	5cd7dcc0ded63	31	
273	1	appdata_ocgmgdeym2id/css/files_texteditor/b1d7-a382-merged.css	88ab3bea0a784f5d03a272678afac902	126	b1d7-a382-merged.css	17	7	4178	1557650625	1557650625	0	0	f11b150ae379a1b0a153a84a531be926	27	
274	1	appdata_ocgmgdeym2id/css/files_texteditor/b1d7-a382-merged.css.deps	c864626399e097593ba2949b81688955	126	b1d7-a382-merged.css.deps	15	3	565	1557650625	1557650625	0	0	030344bec6d505afc3145ea877a4dab9	27	
275	1	appdata_ocgmgdeym2id/css/files_texteditor/b1d7-a382-merged.css.gzip	0e5a843e95e9c08b6ec19b4525273618	126	b1d7-a382-merged.css.gzip	16	3	1268	1557650625	1557650625	0	0	da80c7c33b9f6cb870cc617a02bf80e9	27	
276	1	appdata_ocgmgdeym2id/css/core/3108-a382-systemtags.css	3d7373ea591a4998b7f0e83cf9d65ad9	79	3108-a382-systemtags.css	17	7	1403	1557650625	1557650625	0	0	253e3fd6de4b96f5e225a648e2c57e2c	27	
277	1	appdata_ocgmgdeym2id/css/core/3108-a382-systemtags.css.deps	564d58bc99ab15b7121dd13fccd0943e	79	3108-a382-systemtags.css.deps	15	3	245	1557650626	1557650626	0	0	d62f2ee4741f8323287b5d74b14d4e9f	27	
278	1	appdata_ocgmgdeym2id/css/core/3108-a382-systemtags.css.gzip	56578dc41521de45a577aeeef16a39c5	79	3108-a382-systemtags.css.gzip	16	3	385	1557650626	1557650626	0	0	bf2b396b473dcae9b13cff4698feddb5	27	
34	1	appdata_ocgmgdeym2id/css/icons	533e163263d2a15ee9f039dd4c3cdf44	33	icons	2	1	129897	1557650626	1557650585	0	0	5cd7dcc24b557	31	
93	1	appdata_ocgmgdeym2id/css/notifications	e97a72ac1c7855401f604b78715ccdfb	33	notifications	2	1	4584	1557650588	1557650587	0	0	5cd7dc9c08bc5	31	
279	1	appdata_ocgmgdeym2id/css/systemtags/35c3-a382-systemtagsfilelist.css	350cdf3f902e1f3e51d03afeecb6074e	133	35c3-a382-systemtagsfilelist.css	17	7	296	1557650626	1557650626	0	0	ff0896ef783d3e17081ca974317978a0	27	
280	1	appdata_ocgmgdeym2id/css/systemtags/35c3-a382-systemtagsfilelist.css.deps	0900a3f9fe1578dc522427e1638ffacd	133	35c3-a382-systemtagsfilelist.css.deps	15	3	265	1557650626	1557650626	0	0	40c314fc12f4ba5df0fdc5a837376b68	27	
281	1	appdata_ocgmgdeym2id/css/systemtags/35c3-a382-systemtagsfilelist.css.gzip	b65abfcaeede559d248f1292f72055fe	133	35c3-a382-systemtagsfilelist.css.gzip	16	3	210	1557650626	1557650626	0	0	f2f3f02f82d20d772e3cce59a01e909a	27	
243	1	appdata_ocgmgdeym2id/theming/8	7bc14482b1d90e29fcf15e39ba242972	21	8	2	1	1560	1557650628	1557650628	0	0	5cd7dcc4583f8	31	
244	1	appdata_ocgmgdeym2id/theming/8/icon-core-filetypes_folder.svg	7fa6a4b699551cd0a285ab717a68206f	243	icon-core-filetypes_folder.svg	18	9	255	1557650599	1557650599	0	0	bbebd2cd4e1d218f5f82244f02e0c831	27	
89	1	appdata_ocgmgdeym2id/css/firstrunwizard	bdcd8131c1e5aab62b12da4520b4361a	33	firstrunwizard	2	1	10803	1557650608	1557650608	0	0	5cd7dcb0d5814	31	
133	1	appdata_ocgmgdeym2id/css/systemtags	63b5268ac1a2627f1b44d70371c78ecc	33	systemtags	2	1	771	1557650626	1557650626	0	0	5cd7dcc273946	31	
122	1	appdata_ocgmgdeym2id/css/files_sharing	a53166f9c24c4ca3001e76f45e90353d	33	files_sharing	2	1	7269	1557650625	1557650625	0	0	5cd7dcc158f05	31	
282	1	appdata_ocgmgdeym2id/theming/8/icon-core-filetypes_application-pdf.svg	73e5ef5283465f8743b25ec29a54b727	243	icon-core-filetypes_application-pdf.svg	18	9	676	1557650628	1557650628	0	0	03a894bc46ce826d8a5fc6b29b279499	27	
126	1	appdata_ocgmgdeym2id/css/files_texteditor	72bcb64ef860bfc3958e70228671e5ca	33	files_texteditor	2	1	6011	1557650625	1557650625	0	0	5cd7dcc1b1047	31	
245	1	appdata_ocgmgdeym2id/css/activity/15ac-a382-settings.css	f6ebe26e25a22bc90fbdc3bb40d45d89	111	15ac-a382-settings.css	17	7	377	1557650605	1557650605	0	0	ab05d80348e2032fc78842c267b618f3	27	
246	1	appdata_ocgmgdeym2id/css/activity/15ac-a382-settings.css.deps	d46e1a801afdc451495a63f90d73e521	111	15ac-a382-settings.css.deps	15	3	253	1557650605	1557650605	0	0	8c2c75717a26570047c9b4176a16fbcb	27	
247	1	appdata_ocgmgdeym2id/css/activity/15ac-a382-settings.css.gzip	0ebcc143517f7dad3c69442a85df1ca0	111	15ac-a382-settings.css.gzip	16	3	195	1557650605	1557650605	0	0	6e0e2815ef7cee90bbfcfec5d354ede6	27	
137	1	files_external	c270928b685e7946199afdfb898d27ea	1	files_external	2	1	0	1557650436	1557650436	0	0	5cd7dc04c740d	31	
140	1	appdata_ocgmgdeym2id/preview/20/500-500-max.png	74db287b6c5548ff7c16e8fc988bdf35	138	500-500-max.png	13	9	64951	1557650437	1557650437	0	0	e593f3aa45118025dd5bd090e249d029	27	
145	1	appdata_ocgmgdeym2id/preview/20/256-256-crop.png	784819f4b6afd060b780db3ef42066a6	138	256-256-crop.png	13	9	31792	1557650439	1557650439	0	0	50df7a72ecbd300a4c3e1225c36215f4	27	
138	1	appdata_ocgmgdeym2id/preview/20	dc347b4693f13915e6b3042ed78151d9	5	20	2	1	96743	1557650439	1557650439	0	0	5cd7dc0779283	31	
283	1	appdata_ocgmgdeym2id/theming/8/icon-core-filetypes_video.svg	2b9ef53b9aa11d2952550779cd7cc979	243	icon-core-filetypes_video.svg	18	9	277	1557650628	1557650628	0	0	5032b881f5161cf14980a9d8d15f304c	27	
2	1	appdata_ocgmgdeym2id	798c584047c44150605de3b154105cca	1	appdata_ocgmgdeym2id	2	1	3804304	1557650628	1557650423	0	0	5cd7dcc4583f8	31	
250	1	appdata_ocgmgdeym2id/css/firstrunwizard/0d6d-a382-colorbox.css.gzip	a6db2b800c0cf4212f88cfcc3148df16	89	0d6d-a382-colorbox.css.gzip	16	3	578	1557650608	1557650608	0	0	6ed28c7de1e0f175234af9b7a6366a14	27	
248	1	appdata_ocgmgdeym2id/css/firstrunwizard/0d6d-a382-colorbox.css	532f344a24ad102d7121fa3a7399d990	89	0d6d-a382-colorbox.css	17	7	1681	1557650608	1557650608	0	0	eefd01a7a0df56a524260e292759712d	27	
249	1	appdata_ocgmgdeym2id/css/firstrunwizard/0d6d-a382-colorbox.css.deps	5ab8276044b1d2449d1f32933c2f6538	89	0d6d-a382-colorbox.css.deps	15	3	259	1557650608	1557650608	0	0	ba1deedaec6c5a11ea4d0d3f73933a7f	27	
1	1		d41d8cd98f00b204e9800998ecf8427e	-1		2	1	3804304	1557650628	1557650436	0	0	5cd7dcc4583f8	23	
21	1	appdata_ocgmgdeym2id/theming	8c5299d0d2fb92780eb5d8ee1048d98f	2	theming	2	1	1560	1557650628	1557650599	0	0	5cd7dcc4583f8	31	
284	1	appdata_ocgmgdeym2id/theming/8/icon-core-filetypes_image.svg	00c3cc665edecb736dcaa2aad819f0d6	243	icon-core-filetypes_image.svg	18	9	352	1557650628	1557650628	0	0	7a6d9cc46693e717bc022e75c306727d	27	
228	1	appdata_ocgmgdeym2id/css/notifications/70e2-a382-styles.css	a72368cf0a3f485fcecc45a03e13f25f	93	70e2-a382-styles.css	17	7	3471	1557650587	1557650587	0	0	a0e44484b34542641dfd9e1dbcf99828	27	
231	1	appdata_ocgmgdeym2id/css/core/3108-a382-jquery.ocdialog.css	e716e1da88f55e0d37a144d2e5832a4d	79	3108-a382-jquery.ocdialog.css	17	7	1499	1557650588	1557650588	0	0	23e7c84631d2eb321ed673a4fbd5e2fb	27	
225	1	appdata_ocgmgdeym2id/css/firstrunwizard/0d6d-a382-firstrunwizard.css	14bb0c486af9478ac796c6b08b1d680d	89	0d6d-a382-firstrunwizard.css	17	7	6251	1557650587	1557650587	0	0	fc7d57249fd042a68f43edbb531e60fe	27	
226	1	appdata_ocgmgdeym2id/css/firstrunwizard/0d6d-a382-firstrunwizard.css.deps	0caee243331e19e3757b06a393ff46ca	89	0d6d-a382-firstrunwizard.css.deps	15	3	361	1557650587	1557650587	0	0	869bbe0455bbd3b40bb34093e9f29977	27	
229	1	appdata_ocgmgdeym2id/css/notifications/70e2-a382-styles.css.deps	e771ffa0137fea828d581e9318770bed	93	70e2-a382-styles.css.deps	15	3	256	1557650587	1557650587	0	0	1865d9baa3c2e3160efb6d231f6fb9c0	27	
223	1	appdata_ocgmgdeym2id/css/core/3108-a382-server.css	a7eb7fc0cc4cb28d7bff28afb3d10d05	79	3108-a382-server.css	17	7	131691	1557650587	1557650587	0	0	fe40531529f0d5c80eb2eac8d2eaab18	27	
224	1	appdata_ocgmgdeym2id/css/core/3108-a382-server.css.deps	6d98a01665f898e256f9c2caa2b38d2a	79	3108-a382-server.css.deps	15	3	1095	1557650587	1557650587	0	0	ec105e4b70481b58393eca802279c0d7	27	
227	1	appdata_ocgmgdeym2id/css/firstrunwizard/0d6d-a382-firstrunwizard.css.gzip	599a93a47af69bd5eb530bbb9df98b52	89	0d6d-a382-firstrunwizard.css.gzip	16	3	1673	1557650587	1557650587	0	0	44b7d0347388924c515c901d77dbd8ac	27	
222	1	appdata_ocgmgdeym2id/css/core/3108-a382-server.css.gzip	e7d61f399dabe3958c5069c2796de281	79	3108-a382-server.css.gzip	16	3	18897	1557650587	1557650587	0	0	5232cef2e74ea564fe1eb4e1d57200f1	27	
236	1	appdata_ocgmgdeym2id/css/core/3108-a382-results.css.gzip	562b1c81f57a1f7a8ea6489e50f33d07	79	3108-a382-results.css.gzip	16	3	504	1557650588	1557650588	0	0	7cc0da7f3270462dbfc07b07efcfbab8	27	
230	1	appdata_ocgmgdeym2id/css/notifications/70e2-a382-styles.css.gzip	b6b4bab67fca7bf316ca73e04004f7db	93	70e2-a382-styles.css.gzip	16	3	857	1557650588	1557650588	0	0	17691d36977b5cc967dc03a44d777463	27	
232	1	appdata_ocgmgdeym2id/css/core/3108-a382-jquery.ocdialog.css.deps	749ef603985d7c6f519ae4b097ac6e68	79	3108-a382-jquery.ocdialog.css.deps	15	3	250	1557650588	1557650588	0	0	7374a59c8cbad7114ead8df4ad28858a	27	
233	1	appdata_ocgmgdeym2id/css/core/3108-a382-jquery.ocdialog.css.gzip	3ab5478d88f6ebe5e4d269c8861ab848	79	3108-a382-jquery.ocdialog.css.gzip	16	3	615	1557650588	1557650588	0	0	f5c5023b82beaf9859bacbc6e2479e83	27	
234	1	appdata_ocgmgdeym2id/css/core/3108-a382-results.css	2e8f3103f0918c5e632397bb192e79a6	79	3108-a382-results.css	17	7	1189	1557650588	1557650588	0	0	60ee26b5fdcb75fcdc3a1ae30ef7e1bd	27	
235	1	appdata_ocgmgdeym2id/css/core/3108-a382-results.css.deps	d85d6f1f116f430c40ef644d0932fa0a	79	3108-a382-results.css.deps	15	3	250	1557650588	1557650588	0	0	45ce7e121da44533740816f13862b14e	27	
252	1	appdata_ocgmgdeym2id/css/accessibility/7d23-a382-style.css	c35f9ee677c4ffab2ff65492d71e6b1a	251	7d23-a382-style.css	17	7	1070	1557650611	1557650611	0	0	f102785f1cc08a637562159ebbf7c4c1	27	
253	1	appdata_ocgmgdeym2id/css/accessibility/7d23-a382-style.css.deps	108e9209d81b387b58c28c43218fed22	251	7d23-a382-style.css.deps	15	3	255	1557650612	1557650612	0	0	2867b532369809dd3cc5240641bead86	27	
254	1	appdata_ocgmgdeym2id/css/accessibility/7d23-a382-style.css.gzip	401d9fb44de5fc949295267a518a5be2	251	7d23-a382-style.css.gzip	16	3	478	1557650612	1557650612	0	0	3b55ae5183ff37986ce119f4d88240a4	27	
251	1	appdata_ocgmgdeym2id/css/accessibility	c558e2df0f34c555c2fb21476b01e2cc	33	accessibility	2	1	1803	1557650612	1557650611	0	0	5cd7dcb448dbe	31	
214	1	appdata_ocgmgdeym2id/css/core/3108-a382-css-variables.css	950f54c6bc02a7e755d3e78368d63eb9	79	3108-a382-css-variables.css	17	7	952	1557650585	1557650585	0	0	c3f2aafaa0933567354e8fd9909e43e0	27	
215	1	appdata_ocgmgdeym2id/css/core/3108-a382-css-variables.css.deps	86bddd5750566c82d72558658be7c67f	79	3108-a382-css-variables.css.deps	15	3	248	1557650586	1557650586	0	0	1f40683e3ebda964956c67c7ae380a90	27	
217	1	appdata_ocgmgdeym2id/css/icons/icons-vars.css	da81d8efbc0de94493a824d4ff5eab22	34	icons-vars.css	17	7	113248	1557650626	1557650626	0	0	2358b6bfc07aa619c7c24b1ec8bc6be1	27	
216	1	appdata_ocgmgdeym2id/css/icons/icons-list.template	8f60905c380737ef51363b8d3e689410	34	icons-list.template	15	3	16649	1557650626	1557650626	0	0	9eb9016fd88d8a0ae966d7eaaa97ccde	27	
150	1	appdata_ocgmgdeym2id/avatar/GingerTech/avatar.png	7dba8c338fa9463b6bba2020c0a33a80	43	avatar.png	13	9	17153	1557650550	1557650550	0	0	6605c814e2a6429fde013d13a08594ec	27	
151	1	appdata_ocgmgdeym2id/avatar/GingerTech/generated	a761818fa59682ee6d96faa18549e04e	43	generated	15	3	0	1557650550	1557650550	0	0	1b9dfced5d2bcb7a8d08bbbf67d9d7d3	27	
218	1	appdata_ocgmgdeym2id/css/core/3108-a382-css-variables.css.gzip	35f2898b925e188d8563fd310618030f	79	3108-a382-css-variables.css.gzip	16	3	432	1557650586	1557650586	0	0	4f2f400464ceb3cfb40744f506dab0c5	27	
152	1	appdata_ocgmgdeym2id/avatar/GingerTech/avatar.145.png	0d790ab7561b41ea2ea1e78bfcf55e7a	43	avatar.145.png	13	9	2092	1557650550	1557650550	0	0	5845b8c74b0408fe6d35ffc1ad59fb54	27	
156	1	appdata_ocgmgdeym2id/avatar/GingerTech/avatar.32.png	25df9f51805dda5bb4c47ad7bdb6921e	43	avatar.32.png	13	9	457	1557650556	1557650556	0	0	f3d2a0aeb1de65c4b10a03497b2b6276	27	
42	1	appdata_ocgmgdeym2id/avatar	0b27e73f9b6fa7773dc17e3ab24f9c1d	2	avatar	2	1	19702	1557650556	1557650423	0	0	5cd7dc7cd6330	31	
146	1	appdata_ocgmgdeym2id/css/settings	6bf1d046519126804a07f130f64fed63	33	settings	2	1	34535	1557650598	1557650598	0	0	5cd7dca6b1040	31	
\.


--
-- Data for Name: oc_files_trash; Type: TABLE DATA; Schema: public; Owner: oc_gingertech3
--

COPY public.oc_files_trash (auto_id, id, "user", "timestamp", location, type, mime) FROM stdin;
\.


--
-- Data for Name: oc_flow_checks; Type: TABLE DATA; Schema: public; Owner: oc_gingertech3
--

COPY public.oc_flow_checks (id, class, operator, value, hash) FROM stdin;
\.


--
-- Data for Name: oc_flow_operations; Type: TABLE DATA; Schema: public; Owner: oc_gingertech3
--

COPY public.oc_flow_operations (id, class, name, checks, operation) FROM stdin;
\.


--
-- Data for Name: oc_group_admin; Type: TABLE DATA; Schema: public; Owner: oc_gingertech3
--

COPY public.oc_group_admin (gid, uid) FROM stdin;
\.


--
-- Data for Name: oc_group_user; Type: TABLE DATA; Schema: public; Owner: oc_gingertech3
--

COPY public.oc_group_user (gid, uid) FROM stdin;
admin	GingerTech
\.


--
-- Data for Name: oc_groups; Type: TABLE DATA; Schema: public; Owner: oc_gingertech3
--

COPY public.oc_groups (gid) FROM stdin;
admin
\.


--
-- Data for Name: oc_jobs; Type: TABLE DATA; Schema: public; Owner: oc_gingertech3
--

COPY public.oc_jobs (id, class, argument, last_run, last_checked, reserved_at, execution_duration) FROM stdin;
12	OCA\\Activity\\BackgroundJob\\ExpireActivities	null	0	1557650358	0	0
13	OCA\\Files\\BackgroundJob\\ScanFiles	null	0	1557650359	0	0
14	OCA\\Files\\BackgroundJob\\DeleteOrphanedItems	null	0	1557650359	0	0
15	OCA\\Files\\BackgroundJob\\CleanupFileLocks	null	0	1557650359	0	0
16	OCA\\Files_Sharing\\DeleteOrphanedSharesJob	null	0	1557650359	0	0
17	OCA\\Files_Sharing\\ExpireSharesJob	null	0	1557650359	0	0
18	OCA\\Files_Sharing\\BackgroundJob\\FederatedSharesDiscoverJob	null	0	1557650359	0	0
19	OC\\Authentication\\Token\\DefaultTokenCleanupJob	null	0	1557650365	0	0
20	OC\\Log\\Rotate	null	0	1557650365	0	0
21	OC\\Preview\\BackgroundCleanupJob	null	0	1557650365	0	0
1	OCA\\Support\\BackgroundJobs\\CheckSubscription	null	1557650415	1557650415	0	0
22	OCA\\FirstRunWizard\\Notification\\BackgroundJob	{"uid":"GingerTech"}	0	1557650423	0	0
2	OCA\\NextcloudAnnouncements\\Cron\\Crawler	null	1557650436	1557650436	0	1
3	OCA\\DAV\\BackgroundJob\\CleanupDirectLinksJob	null	1557650548	1557650548	0	0
4	OCA\\DAV\\BackgroundJob\\UpdateCalendarResourcesRoomsBackgroundJob	null	1557650556	1557650556	0	0
5	OCA\\DAV\\BackgroundJob\\CleanupInvitationTokenJob	null	1557650599	1557650599	0	0
7	OCA\\Files_Trashbin\\BackgroundJob\\ExpireTrash	null	1557650606	1557650606	0	0
8	OCA\\UpdateNotification\\Notification\\BackgroundJob	null	1557650609	1557650609	0	0
9	OCA\\Files_Versions\\BackgroundJob\\ExpireVersions	null	1557650612	1557650612	0	0
10	OCA\\Federation\\SyncJob	null	1557650618	1557650618	0	0
11	OCA\\Activity\\BackgroundJob\\EmailNotification	null	1557650627	1557650627	0	0
\.


--
-- Data for Name: oc_migrations; Type: TABLE DATA; Schema: public; Owner: oc_gingertech3
--

COPY public.oc_migrations (app, version) FROM stdin;
core	13000Date20170705121758
core	13000Date20170718121200
core	13000Date20170814074715
core	13000Date20170919121250
core	13000Date20170926101637
core	14000Date20180129121024
core	14000Date20180404140050
core	14000Date20180516101403
core	14000Date20180518120534
core	14000Date20180522074438
core	14000Date20180626223656
core	14000Date20180710092004
core	14000Date20180712153140
core	15000Date20180926101451
core	15000Date20181015062942
core	15000Date20181029084625
twofactor_backupcodes	1002Date20170607104347
twofactor_backupcodes	1002Date20170607113030
twofactor_backupcodes	1002Date20170919123342
twofactor_backupcodes	1002Date20170926101419
twofactor_backupcodes	1002Date20180821043638
dav	1004Date20170825134824
dav	1004Date20170919104507
dav	1004Date20170924124212
dav	1004Date20170926103422
dav	1005Date20180413093149
dav	1005Date20180530124431
dav	1006Date20180619154313
dav	1006Date20180628111625
dav	1008Date20181030113700
dav	1008Date20181105104826
dav	1008Date20181105104833
dav	1008Date20181105110300
dav	1008Date20181105112049
dav	1008Date20181114084440
activity	2006Date20170808154933
activity	2006Date20170808155040
activity	2006Date20170919095939
activity	2007Date20181107114613
activity	2008Date20181011095117
\.


--
-- Data for Name: oc_mimetypes; Type: TABLE DATA; Schema: public; Owner: oc_gingertech3
--

COPY public.oc_mimetypes (id, mimetype) FROM stdin;
1	httpd
2	httpd/unix-directory
3	application
4	application/json
5	application/pdf
6	application/vnd.oasis.opendocument.text
7	text
8	text/plain
9	image
10	image/jpeg
11	video
12	video/mp4
13	image/png
14	application/javascript
15	application/octet-stream
16	application/x-gzip
17	text/css
18	image/svg+xml
\.


--
-- Data for Name: oc_mounts; Type: TABLE DATA; Schema: public; Owner: oc_gingertech3
--

COPY public.oc_mounts (id, storage_id, root_id, user_id, mount_point, mount_id) FROM stdin;
1	2	6	GingerTech	/GingerTech/	\N
\.


--
-- Data for Name: oc_notifications; Type: TABLE DATA; Schema: public; Owner: oc_gingertech3
--

COPY public.oc_notifications (notification_id, app, "user", "timestamp", object_type, object_id, subject, subject_parameters, message, message_parameters, link, icon, actions) FROM stdin;
1	survey_client	GingerTech	1557650604	dummy	23	updated	[]		[]			[{"label":"enable","link":"http:\\/\\/172.16.16.7\\/nextcloud\\/ocs\\/v2.php\\/apps\\/survey_client\\/api\\/v1\\/monthly","type":"POST","primary":true},{"label":"disable","link":"http:\\/\\/172.16.16.7\\/nextcloud\\/ocs\\/v2.php\\/apps\\/survey_client\\/api\\/v1\\/monthly","type":"DELETE","primary":false}]
\.


--
-- Data for Name: oc_notifications_pushtokens; Type: TABLE DATA; Schema: public; Owner: oc_gingertech3
--

COPY public.oc_notifications_pushtokens (uid, token, deviceidentifier, devicepublickey, devicepublickeyhash, pushtokenhash, proxyserver, apptype) FROM stdin;
\.


--
-- Data for Name: oc_oauth2_access_tokens; Type: TABLE DATA; Schema: public; Owner: oc_gingertech3
--

COPY public.oc_oauth2_access_tokens (id, token_id, client_id, hashed_code, encrypted_token) FROM stdin;
\.


--
-- Data for Name: oc_oauth2_clients; Type: TABLE DATA; Schema: public; Owner: oc_gingertech3
--

COPY public.oc_oauth2_clients (id, name, redirect_uri, client_identifier, secret) FROM stdin;
\.


--
-- Data for Name: oc_preferences; Type: TABLE DATA; Schema: public; Owner: oc_gingertech3
--

COPY public.oc_preferences (userid, appid, configkey, configvalue) FROM stdin;
GingerTech	core	lang	en
GingerTech	login	lastLogin	1557650423
GingerTech	core	timezone	America/Los_Angeles
GingerTech	login_token	KtCiiBVnGtbt8OemgGizD1/uBCxUcukI	1557650423
GingerTech	firstrunwizard	show	0
GingerTech	files	show_hidden	1
GingerTech	avatar	generated	true
GingerTech	accessibility	theme	themedark
GingerTech	accessibility	icons-css	c10b636f5fd21bc6bb702e3dd5836296
\.


--
-- Data for Name: oc_properties; Type: TABLE DATA; Schema: public; Owner: oc_gingertech3
--

COPY public.oc_properties (id, userid, propertypath, propertyname, propertyvalue) FROM stdin;
\.


--
-- Data for Name: oc_schedulingobjects; Type: TABLE DATA; Schema: public; Owner: oc_gingertech3
--

COPY public.oc_schedulingobjects (id, principaluri, calendardata, uri, lastmodified, etag, size) FROM stdin;
\.


--
-- Data for Name: oc_share; Type: TABLE DATA; Schema: public; Owner: oc_gingertech3
--

COPY public.oc_share (id, share_type, share_with, password, uid_owner, uid_initiator, parent, item_type, item_source, item_target, file_source, file_target, permissions, stime, accepted, expiration, token, mail_send, share_name, password_by_talk, note, hide_download, label) FROM stdin;
\.


--
-- Data for Name: oc_share_external; Type: TABLE DATA; Schema: public; Owner: oc_gingertech3
--

COPY public.oc_share_external (id, parent, share_type, remote, remote_id, share_token, password, name, owner, "user", mountpoint, mountpoint_hash, accepted) FROM stdin;
\.


--
-- Data for Name: oc_storages; Type: TABLE DATA; Schema: public; Owner: oc_gingertech3
--

COPY public.oc_storages (numeric_id, id, available, last_checked) FROM stdin;
1	local::/var/www/localhost/htdocs/nextcloud/data/	1	\N
2	home::GingerTech	1	\N
\.


--
-- Data for Name: oc_systemtag; Type: TABLE DATA; Schema: public; Owner: oc_gingertech3
--

COPY public.oc_systemtag (id, name, visibility, editable) FROM stdin;
\.


--
-- Data for Name: oc_systemtag_group; Type: TABLE DATA; Schema: public; Owner: oc_gingertech3
--

COPY public.oc_systemtag_group (gid, systemtagid) FROM stdin;
\.


--
-- Data for Name: oc_systemtag_object_mapping; Type: TABLE DATA; Schema: public; Owner: oc_gingertech3
--

COPY public.oc_systemtag_object_mapping (objectid, objecttype, systemtagid) FROM stdin;
\.


--
-- Data for Name: oc_trusted_servers; Type: TABLE DATA; Schema: public; Owner: oc_gingertech3
--

COPY public.oc_trusted_servers (id, url, url_hash, token, shared_secret, status, sync_token) FROM stdin;
\.


--
-- Data for Name: oc_twofactor_backupcodes; Type: TABLE DATA; Schema: public; Owner: oc_gingertech3
--

COPY public.oc_twofactor_backupcodes (id, user_id, code, used) FROM stdin;
\.


--
-- Data for Name: oc_twofactor_providers; Type: TABLE DATA; Schema: public; Owner: oc_gingertech3
--

COPY public.oc_twofactor_providers (provider_id, uid, enabled) FROM stdin;
backup_codes	GingerTech	0
\.


--
-- Data for Name: oc_users; Type: TABLE DATA; Schema: public; Owner: oc_gingertech3
--

COPY public.oc_users (uid, displayname, password, uid_lower) FROM stdin;
GingerTech	\N	1|$2y$10$tykD.ytBauDQGygJz9NpD.kGyCidUcaHchLnAyd5fUT3hnboV7qIa	gingertech
\.


--
-- Data for Name: oc_vcategory; Type: TABLE DATA; Schema: public; Owner: oc_gingertech3
--

COPY public.oc_vcategory (id, uid, type, category) FROM stdin;
\.


--
-- Data for Name: oc_vcategory_to_object; Type: TABLE DATA; Schema: public; Owner: oc_gingertech3
--

COPY public.oc_vcategory_to_object (categoryid, objid, type) FROM stdin;
\.


--
-- Data for Name: oc_whats_new; Type: TABLE DATA; Schema: public; Owner: oc_gingertech3
--

COPY public.oc_whats_new (id, version, etag, last_check, data) FROM stdin;
\.


--
-- Name: oc_activity_activity_id_seq; Type: SEQUENCE SET; Schema: public; Owner: oc_gingertech3
--

SELECT pg_catalog.setval('public.oc_activity_activity_id_seq', 1, false);


--
-- Name: oc_activity_mq_mail_id_seq; Type: SEQUENCE SET; Schema: public; Owner: oc_gingertech3
--

SELECT pg_catalog.setval('public.oc_activity_mq_mail_id_seq', 1, false);


--
-- Name: oc_addressbookchanges_id_seq; Type: SEQUENCE SET; Schema: public; Owner: oc_gingertech3
--

SELECT pg_catalog.setval('public.oc_addressbookchanges_id_seq', 1, false);


--
-- Name: oc_addressbooks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: oc_gingertech3
--

SELECT pg_catalog.setval('public.oc_addressbooks_id_seq', 1, false);


--
-- Name: oc_authtoken_id_seq; Type: SEQUENCE SET; Schema: public; Owner: oc_gingertech3
--

SELECT pg_catalog.setval('public.oc_authtoken_id_seq', 2, true);


--
-- Name: oc_bruteforce_attempts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: oc_gingertech3
--

SELECT pg_catalog.setval('public.oc_bruteforce_attempts_id_seq', 1, false);


--
-- Name: oc_calendar_invitations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: oc_gingertech3
--

SELECT pg_catalog.setval('public.oc_calendar_invitations_id_seq', 1, false);


--
-- Name: oc_calendar_resources_id_seq; Type: SEQUENCE SET; Schema: public; Owner: oc_gingertech3
--

SELECT pg_catalog.setval('public.oc_calendar_resources_id_seq', 1, false);


--
-- Name: oc_calendar_rooms_id_seq; Type: SEQUENCE SET; Schema: public; Owner: oc_gingertech3
--

SELECT pg_catalog.setval('public.oc_calendar_rooms_id_seq', 1, false);


--
-- Name: oc_calendarchanges_id_seq; Type: SEQUENCE SET; Schema: public; Owner: oc_gingertech3
--

SELECT pg_catalog.setval('public.oc_calendarchanges_id_seq', 1, false);


--
-- Name: oc_calendarobjects_id_seq; Type: SEQUENCE SET; Schema: public; Owner: oc_gingertech3
--

SELECT pg_catalog.setval('public.oc_calendarobjects_id_seq', 1, false);


--
-- Name: oc_calendarobjects_props_id_seq; Type: SEQUENCE SET; Schema: public; Owner: oc_gingertech3
--

SELECT pg_catalog.setval('public.oc_calendarobjects_props_id_seq', 1, false);


--
-- Name: oc_calendars_id_seq; Type: SEQUENCE SET; Schema: public; Owner: oc_gingertech3
--

SELECT pg_catalog.setval('public.oc_calendars_id_seq', 1, false);


--
-- Name: oc_calendarsubscriptions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: oc_gingertech3
--

SELECT pg_catalog.setval('public.oc_calendarsubscriptions_id_seq', 1, false);


--
-- Name: oc_cards_id_seq; Type: SEQUENCE SET; Schema: public; Owner: oc_gingertech3
--

SELECT pg_catalog.setval('public.oc_cards_id_seq', 1, false);


--
-- Name: oc_cards_properties_id_seq; Type: SEQUENCE SET; Schema: public; Owner: oc_gingertech3
--

SELECT pg_catalog.setval('public.oc_cards_properties_id_seq', 1, false);


--
-- Name: oc_comments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: oc_gingertech3
--

SELECT pg_catalog.setval('public.oc_comments_id_seq', 1, false);


--
-- Name: oc_dav_shares_id_seq; Type: SEQUENCE SET; Schema: public; Owner: oc_gingertech3
--

SELECT pg_catalog.setval('public.oc_dav_shares_id_seq', 1, false);


--
-- Name: oc_directlink_id_seq; Type: SEQUENCE SET; Schema: public; Owner: oc_gingertech3
--

SELECT pg_catalog.setval('public.oc_directlink_id_seq', 1, false);


--
-- Name: oc_file_locks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: oc_gingertech3
--

SELECT pg_catalog.setval('public.oc_file_locks_id_seq', 8, true);


--
-- Name: oc_filecache_fileid_seq; Type: SEQUENCE SET; Schema: public; Owner: oc_gingertech3
--

SELECT pg_catalog.setval('public.oc_filecache_fileid_seq', 284, true);


--
-- Name: oc_files_trash_auto_id_seq; Type: SEQUENCE SET; Schema: public; Owner: oc_gingertech3
--

SELECT pg_catalog.setval('public.oc_files_trash_auto_id_seq', 1, false);


--
-- Name: oc_flow_checks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: oc_gingertech3
--

SELECT pg_catalog.setval('public.oc_flow_checks_id_seq', 1, false);


--
-- Name: oc_flow_operations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: oc_gingertech3
--

SELECT pg_catalog.setval('public.oc_flow_operations_id_seq', 1, false);


--
-- Name: oc_jobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: oc_gingertech3
--

SELECT pg_catalog.setval('public.oc_jobs_id_seq', 22, true);


--
-- Name: oc_mimetypes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: oc_gingertech3
--

SELECT pg_catalog.setval('public.oc_mimetypes_id_seq', 19, true);


--
-- Name: oc_mounts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: oc_gingertech3
--

SELECT pg_catalog.setval('public.oc_mounts_id_seq', 1, true);


--
-- Name: oc_notifications_notification_id_seq; Type: SEQUENCE SET; Schema: public; Owner: oc_gingertech3
--

SELECT pg_catalog.setval('public.oc_notifications_notification_id_seq', 1, true);


--
-- Name: oc_oauth2_access_tokens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: oc_gingertech3
--

SELECT pg_catalog.setval('public.oc_oauth2_access_tokens_id_seq', 1, false);


--
-- Name: oc_oauth2_clients_id_seq; Type: SEQUENCE SET; Schema: public; Owner: oc_gingertech3
--

SELECT pg_catalog.setval('public.oc_oauth2_clients_id_seq', 1, false);


--
-- Name: oc_properties_id_seq; Type: SEQUENCE SET; Schema: public; Owner: oc_gingertech3
--

SELECT pg_catalog.setval('public.oc_properties_id_seq', 1, false);


--
-- Name: oc_schedulingobjects_id_seq; Type: SEQUENCE SET; Schema: public; Owner: oc_gingertech3
--

SELECT pg_catalog.setval('public.oc_schedulingobjects_id_seq', 1, false);


--
-- Name: oc_share_external_id_seq; Type: SEQUENCE SET; Schema: public; Owner: oc_gingertech3
--

SELECT pg_catalog.setval('public.oc_share_external_id_seq', 1, false);


--
-- Name: oc_share_id_seq; Type: SEQUENCE SET; Schema: public; Owner: oc_gingertech3
--

SELECT pg_catalog.setval('public.oc_share_id_seq', 1, false);


--
-- Name: oc_storages_numeric_id_seq; Type: SEQUENCE SET; Schema: public; Owner: oc_gingertech3
--

SELECT pg_catalog.setval('public.oc_storages_numeric_id_seq', 2, true);


--
-- Name: oc_systemtag_id_seq; Type: SEQUENCE SET; Schema: public; Owner: oc_gingertech3
--

SELECT pg_catalog.setval('public.oc_systemtag_id_seq', 1, false);


--
-- Name: oc_trusted_servers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: oc_gingertech3
--

SELECT pg_catalog.setval('public.oc_trusted_servers_id_seq', 1, false);


--
-- Name: oc_twofactor_backupcodes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: oc_gingertech3
--

SELECT pg_catalog.setval('public.oc_twofactor_backupcodes_id_seq', 1, false);


--
-- Name: oc_vcategory_id_seq; Type: SEQUENCE SET; Schema: public; Owner: oc_gingertech3
--

SELECT pg_catalog.setval('public.oc_vcategory_id_seq', 1, false);


--
-- Name: oc_whats_new_id_seq; Type: SEQUENCE SET; Schema: public; Owner: oc_gingertech3
--

SELECT pg_catalog.setval('public.oc_whats_new_id_seq', 1, false);


--
-- Name: oc_accounts oc_accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_accounts
    ADD CONSTRAINT oc_accounts_pkey PRIMARY KEY (uid);


--
-- Name: oc_activity_mq oc_activity_mq_pkey; Type: CONSTRAINT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_activity_mq
    ADD CONSTRAINT oc_activity_mq_pkey PRIMARY KEY (mail_id);


--
-- Name: oc_activity oc_activity_pkey; Type: CONSTRAINT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_activity
    ADD CONSTRAINT oc_activity_pkey PRIMARY KEY (activity_id);


--
-- Name: oc_addressbookchanges oc_addressbookchanges_pkey; Type: CONSTRAINT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_addressbookchanges
    ADD CONSTRAINT oc_addressbookchanges_pkey PRIMARY KEY (id);


--
-- Name: oc_addressbooks oc_addressbooks_pkey; Type: CONSTRAINT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_addressbooks
    ADD CONSTRAINT oc_addressbooks_pkey PRIMARY KEY (id);


--
-- Name: oc_appconfig oc_appconfig_pkey; Type: CONSTRAINT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_appconfig
    ADD CONSTRAINT oc_appconfig_pkey PRIMARY KEY (appid, configkey);


--
-- Name: oc_authtoken oc_authtoken_pkey; Type: CONSTRAINT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_authtoken
    ADD CONSTRAINT oc_authtoken_pkey PRIMARY KEY (id);


--
-- Name: oc_bruteforce_attempts oc_bruteforce_attempts_pkey; Type: CONSTRAINT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_bruteforce_attempts
    ADD CONSTRAINT oc_bruteforce_attempts_pkey PRIMARY KEY (id);


--
-- Name: oc_calendar_invitations oc_calendar_invitations_pkey; Type: CONSTRAINT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_calendar_invitations
    ADD CONSTRAINT oc_calendar_invitations_pkey PRIMARY KEY (id);


--
-- Name: oc_calendar_resources oc_calendar_resources_pkey; Type: CONSTRAINT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_calendar_resources
    ADD CONSTRAINT oc_calendar_resources_pkey PRIMARY KEY (id);


--
-- Name: oc_calendar_rooms oc_calendar_rooms_pkey; Type: CONSTRAINT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_calendar_rooms
    ADD CONSTRAINT oc_calendar_rooms_pkey PRIMARY KEY (id);


--
-- Name: oc_calendarchanges oc_calendarchanges_pkey; Type: CONSTRAINT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_calendarchanges
    ADD CONSTRAINT oc_calendarchanges_pkey PRIMARY KEY (id);


--
-- Name: oc_calendarobjects oc_calendarobjects_pkey; Type: CONSTRAINT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_calendarobjects
    ADD CONSTRAINT oc_calendarobjects_pkey PRIMARY KEY (id);


--
-- Name: oc_calendarobjects_props oc_calendarobjects_props_pkey; Type: CONSTRAINT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_calendarobjects_props
    ADD CONSTRAINT oc_calendarobjects_props_pkey PRIMARY KEY (id);


--
-- Name: oc_calendars oc_calendars_pkey; Type: CONSTRAINT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_calendars
    ADD CONSTRAINT oc_calendars_pkey PRIMARY KEY (id);


--
-- Name: oc_calendarsubscriptions oc_calendarsubscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_calendarsubscriptions
    ADD CONSTRAINT oc_calendarsubscriptions_pkey PRIMARY KEY (id);


--
-- Name: oc_cards oc_cards_pkey; Type: CONSTRAINT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_cards
    ADD CONSTRAINT oc_cards_pkey PRIMARY KEY (id);


--
-- Name: oc_cards_properties oc_cards_properties_pkey; Type: CONSTRAINT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_cards_properties
    ADD CONSTRAINT oc_cards_properties_pkey PRIMARY KEY (id);


--
-- Name: oc_comments oc_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_comments
    ADD CONSTRAINT oc_comments_pkey PRIMARY KEY (id);


--
-- Name: oc_credentials oc_credentials_pkey; Type: CONSTRAINT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_credentials
    ADD CONSTRAINT oc_credentials_pkey PRIMARY KEY ("user", identifier);


--
-- Name: oc_dav_shares oc_dav_shares_pkey; Type: CONSTRAINT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_dav_shares
    ADD CONSTRAINT oc_dav_shares_pkey PRIMARY KEY (id);


--
-- Name: oc_directlink oc_directlink_pkey; Type: CONSTRAINT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_directlink
    ADD CONSTRAINT oc_directlink_pkey PRIMARY KEY (id);


--
-- Name: oc_file_locks oc_file_locks_pkey; Type: CONSTRAINT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_file_locks
    ADD CONSTRAINT oc_file_locks_pkey PRIMARY KEY (id);


--
-- Name: oc_filecache oc_filecache_pkey; Type: CONSTRAINT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_filecache
    ADD CONSTRAINT oc_filecache_pkey PRIMARY KEY (fileid);


--
-- Name: oc_files_trash oc_files_trash_pkey; Type: CONSTRAINT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_files_trash
    ADD CONSTRAINT oc_files_trash_pkey PRIMARY KEY (auto_id);


--
-- Name: oc_flow_checks oc_flow_checks_pkey; Type: CONSTRAINT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_flow_checks
    ADD CONSTRAINT oc_flow_checks_pkey PRIMARY KEY (id);


--
-- Name: oc_flow_operations oc_flow_operations_pkey; Type: CONSTRAINT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_flow_operations
    ADD CONSTRAINT oc_flow_operations_pkey PRIMARY KEY (id);


--
-- Name: oc_group_admin oc_group_admin_pkey; Type: CONSTRAINT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_group_admin
    ADD CONSTRAINT oc_group_admin_pkey PRIMARY KEY (gid, uid);


--
-- Name: oc_group_user oc_group_user_pkey; Type: CONSTRAINT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_group_user
    ADD CONSTRAINT oc_group_user_pkey PRIMARY KEY (gid, uid);


--
-- Name: oc_groups oc_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_groups
    ADD CONSTRAINT oc_groups_pkey PRIMARY KEY (gid);


--
-- Name: oc_jobs oc_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_jobs
    ADD CONSTRAINT oc_jobs_pkey PRIMARY KEY (id);


--
-- Name: oc_migrations oc_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_migrations
    ADD CONSTRAINT oc_migrations_pkey PRIMARY KEY (app, version);


--
-- Name: oc_mimetypes oc_mimetypes_pkey; Type: CONSTRAINT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_mimetypes
    ADD CONSTRAINT oc_mimetypes_pkey PRIMARY KEY (id);


--
-- Name: oc_mounts oc_mounts_pkey; Type: CONSTRAINT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_mounts
    ADD CONSTRAINT oc_mounts_pkey PRIMARY KEY (id);


--
-- Name: oc_notifications oc_notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_notifications
    ADD CONSTRAINT oc_notifications_pkey PRIMARY KEY (notification_id);


--
-- Name: oc_oauth2_access_tokens oc_oauth2_access_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_oauth2_access_tokens
    ADD CONSTRAINT oc_oauth2_access_tokens_pkey PRIMARY KEY (id);


--
-- Name: oc_oauth2_clients oc_oauth2_clients_pkey; Type: CONSTRAINT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_oauth2_clients
    ADD CONSTRAINT oc_oauth2_clients_pkey PRIMARY KEY (id);


--
-- Name: oc_preferences oc_preferences_pkey; Type: CONSTRAINT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_preferences
    ADD CONSTRAINT oc_preferences_pkey PRIMARY KEY (userid, appid, configkey);


--
-- Name: oc_properties oc_properties_pkey; Type: CONSTRAINT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_properties
    ADD CONSTRAINT oc_properties_pkey PRIMARY KEY (id);


--
-- Name: oc_schedulingobjects oc_schedulingobjects_pkey; Type: CONSTRAINT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_schedulingobjects
    ADD CONSTRAINT oc_schedulingobjects_pkey PRIMARY KEY (id);


--
-- Name: oc_share_external oc_share_external_pkey; Type: CONSTRAINT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_share_external
    ADD CONSTRAINT oc_share_external_pkey PRIMARY KEY (id);


--
-- Name: oc_share oc_share_pkey; Type: CONSTRAINT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_share
    ADD CONSTRAINT oc_share_pkey PRIMARY KEY (id);


--
-- Name: oc_storages oc_storages_pkey; Type: CONSTRAINT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_storages
    ADD CONSTRAINT oc_storages_pkey PRIMARY KEY (numeric_id);


--
-- Name: oc_systemtag_group oc_systemtag_group_pkey; Type: CONSTRAINT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_systemtag_group
    ADD CONSTRAINT oc_systemtag_group_pkey PRIMARY KEY (gid, systemtagid);


--
-- Name: oc_systemtag oc_systemtag_pkey; Type: CONSTRAINT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_systemtag
    ADD CONSTRAINT oc_systemtag_pkey PRIMARY KEY (id);


--
-- Name: oc_trusted_servers oc_trusted_servers_pkey; Type: CONSTRAINT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_trusted_servers
    ADD CONSTRAINT oc_trusted_servers_pkey PRIMARY KEY (id);


--
-- Name: oc_twofactor_backupcodes oc_twofactor_backupcodes_pkey; Type: CONSTRAINT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_twofactor_backupcodes
    ADD CONSTRAINT oc_twofactor_backupcodes_pkey PRIMARY KEY (id);


--
-- Name: oc_twofactor_providers oc_twofactor_providers_pkey; Type: CONSTRAINT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_twofactor_providers
    ADD CONSTRAINT oc_twofactor_providers_pkey PRIMARY KEY (provider_id, uid);


--
-- Name: oc_users oc_users_pkey; Type: CONSTRAINT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_users
    ADD CONSTRAINT oc_users_pkey PRIMARY KEY (uid);


--
-- Name: oc_vcategory oc_vcategory_pkey; Type: CONSTRAINT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_vcategory
    ADD CONSTRAINT oc_vcategory_pkey PRIMARY KEY (id);


--
-- Name: oc_vcategory_to_object oc_vcategory_to_object_pkey; Type: CONSTRAINT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_vcategory_to_object
    ADD CONSTRAINT oc_vcategory_to_object_pkey PRIMARY KEY (categoryid, objid, type);


--
-- Name: oc_whats_new oc_whats_new_pkey; Type: CONSTRAINT; Schema: public; Owner: oc_gingertech3
--

ALTER TABLE ONLY public.oc_whats_new
    ADD CONSTRAINT oc_whats_new_pkey PRIMARY KEY (id);


--
-- Name: activity_filter; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE INDEX activity_filter ON public.oc_activity USING btree (affecteduser, type, app, "timestamp");


--
-- Name: activity_filter_by; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE INDEX activity_filter_by ON public.oc_activity USING btree (affecteduser, "user", "timestamp");


--
-- Name: activity_object; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE INDEX activity_object ON public.oc_activity USING btree (object_type, object_id);


--
-- Name: activity_time; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE INDEX activity_time ON public.oc_activity USING btree ("timestamp");


--
-- Name: activity_user_time; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE INDEX activity_user_time ON public.oc_activity USING btree (affecteduser, "timestamp");


--
-- Name: addressbook_index; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE UNIQUE INDEX addressbook_index ON public.oc_addressbooks USING btree (principaluri, uri);


--
-- Name: addressbookid_synctoken; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE INDEX addressbookid_synctoken ON public.oc_addressbookchanges USING btree (addressbookid, synctoken);


--
-- Name: amp_latest_send_time; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE INDEX amp_latest_send_time ON public.oc_activity_mq USING btree (amq_latest_send);


--
-- Name: amp_timestamp_time; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE INDEX amp_timestamp_time ON public.oc_activity_mq USING btree (amq_timestamp);


--
-- Name: amp_user; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE INDEX amp_user ON public.oc_activity_mq USING btree (amq_affecteduser);


--
-- Name: appconfig_appid_key; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE INDEX appconfig_appid_key ON public.oc_appconfig USING btree (appid);


--
-- Name: appconfig_config_key_index; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE INDEX appconfig_config_key_index ON public.oc_appconfig USING btree (configkey);


--
-- Name: authtoken_last_activity_index; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE INDEX authtoken_last_activity_index ON public.oc_authtoken USING btree (last_activity);


--
-- Name: authtoken_token_index; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE UNIQUE INDEX authtoken_token_index ON public.oc_authtoken USING btree (token);


--
-- Name: authtoken_uid_index; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE INDEX authtoken_uid_index ON public.oc_authtoken USING btree (uid);


--
-- Name: authtoken_version_index; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE INDEX authtoken_version_index ON public.oc_authtoken USING btree (version);


--
-- Name: bruteforce_attempts_ip; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE INDEX bruteforce_attempts_ip ON public.oc_bruteforce_attempts USING btree (ip);


--
-- Name: bruteforce_attempts_subnet; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE INDEX bruteforce_attempts_subnet ON public.oc_bruteforce_attempts USING btree (subnet);


--
-- Name: calendar_invitation_tokens; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE INDEX calendar_invitation_tokens ON public.oc_calendar_invitations USING btree (token);


--
-- Name: calendar_resources_bkdrsc; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE INDEX calendar_resources_bkdrsc ON public.oc_calendar_resources USING btree (backend_id, resource_id);


--
-- Name: calendar_resources_email; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE INDEX calendar_resources_email ON public.oc_calendar_resources USING btree (email);


--
-- Name: calendar_resources_name; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE INDEX calendar_resources_name ON public.oc_calendar_resources USING btree (displayname);


--
-- Name: calendar_rooms_bkdrsc; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE INDEX calendar_rooms_bkdrsc ON public.oc_calendar_rooms USING btree (backend_id, resource_id);


--
-- Name: calendar_rooms_email; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE INDEX calendar_rooms_email ON public.oc_calendar_rooms USING btree (email);


--
-- Name: calendar_rooms_name; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE INDEX calendar_rooms_name ON public.oc_calendar_rooms USING btree (displayname);


--
-- Name: calendarobject_index; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE INDEX calendarobject_index ON public.oc_calendarobjects_props USING btree (objectid, calendartype);


--
-- Name: calendarobject_name_index; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE INDEX calendarobject_name_index ON public.oc_calendarobjects_props USING btree (name, calendartype);


--
-- Name: calendarobject_value_index; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE INDEX calendarobject_value_index ON public.oc_calendarobjects_props USING btree (value, calendartype);


--
-- Name: calendars_index; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE UNIQUE INDEX calendars_index ON public.oc_calendars USING btree (principaluri, uri);


--
-- Name: calid_type_synctoken; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE INDEX calid_type_synctoken ON public.oc_calendarchanges USING btree (calendarid, calendartype, synctoken);


--
-- Name: calobjects_index; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE UNIQUE INDEX calobjects_index ON public.oc_calendarobjects USING btree (calendarid, calendartype, uri);


--
-- Name: calsub_index; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE UNIQUE INDEX calsub_index ON public.oc_calendarsubscriptions USING btree (principaluri, uri);


--
-- Name: card_contactid_index; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE INDEX card_contactid_index ON public.oc_cards_properties USING btree (cardid);


--
-- Name: card_name_index; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE INDEX card_name_index ON public.oc_cards_properties USING btree (name);


--
-- Name: card_value_index; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE INDEX card_value_index ON public.oc_cards_properties USING btree (value);


--
-- Name: category_index; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE INDEX category_index ON public.oc_vcategory USING btree (category);


--
-- Name: comments_actor_index; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE INDEX comments_actor_index ON public.oc_comments USING btree (actor_type, actor_id);


--
-- Name: comments_marker_index; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE UNIQUE INDEX comments_marker_index ON public.oc_comments_read_markers USING btree (user_id, object_type, object_id);


--
-- Name: comments_marker_object_index; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE INDEX comments_marker_object_index ON public.oc_comments_read_markers USING btree (object_type, object_id);


--
-- Name: comments_object_index; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE INDEX comments_object_index ON public.oc_comments USING btree (object_type, object_id, creation_timestamp);


--
-- Name: comments_parent_id_index; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE INDEX comments_parent_id_index ON public.oc_comments USING btree (parent_id);


--
-- Name: comments_topmost_parent_id_idx; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE INDEX comments_topmost_parent_id_idx ON public.oc_comments USING btree (topmost_parent_id);


--
-- Name: credentials_user; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE INDEX credentials_user ON public.oc_credentials USING btree ("user");


--
-- Name: dav_shares_index; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE UNIQUE INDEX dav_shares_index ON public.oc_dav_shares USING btree (principaluri, resourceid, type, publicuri);


--
-- Name: directlink_expiration_idx; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE INDEX directlink_expiration_idx ON public.oc_directlink USING btree (expiration);


--
-- Name: directlink_token_idx; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE INDEX directlink_token_idx ON public.oc_directlink USING btree (token);


--
-- Name: file_source_index; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE INDEX file_source_index ON public.oc_share USING btree (file_source);


--
-- Name: flow_unique_hash; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE UNIQUE INDEX flow_unique_hash ON public.oc_flow_checks USING btree (hash);


--
-- Name: fs_mtime; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE INDEX fs_mtime ON public.oc_filecache USING btree (mtime);


--
-- Name: fs_parent_name_hash; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE INDEX fs_parent_name_hash ON public.oc_filecache USING btree (parent, name);


--
-- Name: fs_storage_mimepart; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE INDEX fs_storage_mimepart ON public.oc_filecache USING btree (storage, mimepart);


--
-- Name: fs_storage_mimetype; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE INDEX fs_storage_mimetype ON public.oc_filecache USING btree (storage, mimetype);


--
-- Name: fs_storage_path_hash; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE UNIQUE INDEX fs_storage_path_hash ON public.oc_filecache USING btree (storage, path_hash);


--
-- Name: fs_storage_size; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE INDEX fs_storage_size ON public.oc_filecache USING btree (storage, size, fileid);


--
-- Name: group_admin_uid; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE INDEX group_admin_uid ON public.oc_group_admin USING btree (uid);


--
-- Name: gu_uid_index; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE INDEX gu_uid_index ON public.oc_group_user USING btree (uid);


--
-- Name: id_index; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE INDEX id_index ON public.oc_files_trash USING btree (id);


--
-- Name: idx_811f5cfa8b26c2e9; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE INDEX idx_811f5cfa8b26c2e9 ON public.oc_cards_properties USING btree (addressbookid);


--
-- Name: idx_e98f2ec48b26c2e9; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE INDEX idx_e98f2ec48b26c2e9 ON public.oc_cards USING btree (addressbookid);


--
-- Name: initiator_index; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE INDEX initiator_index ON public.oc_share USING btree (uid_initiator);


--
-- Name: item_share_type_index; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE INDEX item_share_type_index ON public.oc_share USING btree (item_type, share_type);


--
-- Name: job_class_index; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE INDEX job_class_index ON public.oc_jobs USING btree (class);


--
-- Name: lock_key_index; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE UNIQUE INDEX lock_key_index ON public.oc_file_locks USING btree (key);


--
-- Name: lock_ttl_index; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE INDEX lock_ttl_index ON public.oc_file_locks USING btree (ttl);


--
-- Name: mapping; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE UNIQUE INDEX mapping ON public.oc_systemtag_object_mapping USING btree (objecttype, objectid, systemtagid);


--
-- Name: mimetype_id_index; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE UNIQUE INDEX mimetype_id_index ON public.oc_mimetypes USING btree (mimetype);


--
-- Name: mounts_mount_id_index; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE INDEX mounts_mount_id_index ON public.oc_mounts USING btree (mount_id);


--
-- Name: mounts_root_index; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE INDEX mounts_root_index ON public.oc_mounts USING btree (root_id);


--
-- Name: mounts_storage_index; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE INDEX mounts_storage_index ON public.oc_mounts USING btree (storage_id);


--
-- Name: mounts_user_index; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE INDEX mounts_user_index ON public.oc_mounts USING btree (user_id);


--
-- Name: mounts_user_root_index; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE UNIQUE INDEX mounts_user_root_index ON public.oc_mounts USING btree (user_id, root_id);


--
-- Name: oauth2_access_client_id_idx; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE INDEX oauth2_access_client_id_idx ON public.oc_oauth2_access_tokens USING btree (client_id);


--
-- Name: oauth2_access_hash_idx; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE UNIQUE INDEX oauth2_access_hash_idx ON public.oc_oauth2_access_tokens USING btree (hashed_code);


--
-- Name: oauth2_client_id_idx; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE INDEX oauth2_client_id_idx ON public.oc_oauth2_clients USING btree (client_identifier);


--
-- Name: oc_notifications_app; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE INDEX oc_notifications_app ON public.oc_notifications USING btree (app);


--
-- Name: oc_notifications_object; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE INDEX oc_notifications_object ON public.oc_notifications USING btree (object_type, object_id);


--
-- Name: oc_notifications_timestamp; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE INDEX oc_notifications_timestamp ON public.oc_notifications USING btree ("timestamp");


--
-- Name: oc_notifications_user; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE INDEX oc_notifications_user ON public.oc_notifications USING btree ("user");


--
-- Name: oc_notifpushtoken; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE UNIQUE INDEX oc_notifpushtoken ON public.oc_notifications_pushtokens USING btree (uid, token);


--
-- Name: owner_index; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE INDEX owner_index ON public.oc_share USING btree (uid_owner);


--
-- Name: parent_index; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE INDEX parent_index ON public.oc_share USING btree (parent);


--
-- Name: property_index; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE INDEX property_index ON public.oc_properties USING btree (userid);


--
-- Name: sh_external_mp; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE UNIQUE INDEX sh_external_mp ON public.oc_share_external USING btree ("user", mountpoint_hash);


--
-- Name: sh_external_user; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE INDEX sh_external_user ON public.oc_share_external USING btree ("user");


--
-- Name: share_id_index; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE UNIQUE INDEX share_id_index ON public.oc_federated_reshares USING btree (share_id);


--
-- Name: share_with_index; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE INDEX share_with_index ON public.oc_share USING btree (share_with);


--
-- Name: storages_id_index; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE UNIQUE INDEX storages_id_index ON public.oc_storages USING btree (id);


--
-- Name: tag_ident; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE UNIQUE INDEX tag_ident ON public.oc_systemtag USING btree (name, visibility, editable);


--
-- Name: timestamp_index; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE INDEX timestamp_index ON public.oc_files_trash USING btree ("timestamp");


--
-- Name: token_index; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE INDEX token_index ON public.oc_share USING btree (token);


--
-- Name: twofactor_backupcodes_uid; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE INDEX twofactor_backupcodes_uid ON public.oc_twofactor_backupcodes USING btree (user_id);


--
-- Name: type_index; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE INDEX type_index ON public.oc_vcategory USING btree (type);


--
-- Name: uid_index; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE INDEX uid_index ON public.oc_vcategory USING btree (uid);


--
-- Name: uniq_333a1dc2bf1cd3c3; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE UNIQUE INDEX uniq_333a1dc2bf1cd3c3 ON public.oc_whats_new USING btree (version);


--
-- Name: url_hash; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE UNIQUE INDEX url_hash ON public.oc_trusted_servers USING btree (url_hash);


--
-- Name: user_index; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE INDEX user_index ON public.oc_files_trash USING btree ("user");


--
-- Name: user_uid_lower; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE INDEX user_uid_lower ON public.oc_users USING btree (uid_lower);


--
-- Name: vcategory_objectd_index; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE INDEX vcategory_objectd_index ON public.oc_vcategory_to_object USING btree (objid, type);


--
-- Name: version_etag_idx; Type: INDEX; Schema: public; Owner: oc_gingertech3
--

CREATE INDEX version_etag_idx ON public.oc_whats_new USING btree (version, etag);


--
-- PostgreSQL database dump complete
--

