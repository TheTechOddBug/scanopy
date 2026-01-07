--
-- PostgreSQL database dump
--

\restrict 9eKUU15ihr6xigFXjWtxeUAaYUHfqMzujCcdXkhmB706ydGnQKiq1Mxi6PceWEo

-- Dumped from database version 17.7
-- Dumped by pg_dump version 17.7

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

ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_organization_id_fkey;
ALTER TABLE IF EXISTS ONLY public.user_network_access DROP CONSTRAINT IF EXISTS user_network_access_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.user_network_access DROP CONSTRAINT IF EXISTS user_network_access_network_id_fkey;
ALTER TABLE IF EXISTS ONLY public.user_api_keys DROP CONSTRAINT IF EXISTS user_api_keys_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.user_api_keys DROP CONSTRAINT IF EXISTS user_api_keys_organization_id_fkey;
ALTER TABLE IF EXISTS ONLY public.user_api_key_network_access DROP CONSTRAINT IF EXISTS user_api_key_network_access_network_id_fkey;
ALTER TABLE IF EXISTS ONLY public.user_api_key_network_access DROP CONSTRAINT IF EXISTS user_api_key_network_access_api_key_id_fkey;
ALTER TABLE IF EXISTS ONLY public.topologies DROP CONSTRAINT IF EXISTS topologies_network_id_fkey;
ALTER TABLE IF EXISTS ONLY public.tags DROP CONSTRAINT IF EXISTS tags_organization_id_fkey;
ALTER TABLE IF EXISTS ONLY public.subnets DROP CONSTRAINT IF EXISTS subnets_network_id_fkey;
ALTER TABLE IF EXISTS ONLY public.shares DROP CONSTRAINT IF EXISTS shares_topology_id_fkey;
ALTER TABLE IF EXISTS ONLY public.shares DROP CONSTRAINT IF EXISTS shares_network_id_fkey;
ALTER TABLE IF EXISTS ONLY public.shares DROP CONSTRAINT IF EXISTS shares_created_by_fkey;
ALTER TABLE IF EXISTS ONLY public.services DROP CONSTRAINT IF EXISTS services_network_id_fkey;
ALTER TABLE IF EXISTS ONLY public.services DROP CONSTRAINT IF EXISTS services_host_id_fkey;
ALTER TABLE IF EXISTS ONLY public.ports DROP CONSTRAINT IF EXISTS ports_network_id_fkey;
ALTER TABLE IF EXISTS ONLY public.ports DROP CONSTRAINT IF EXISTS ports_host_id_fkey;
ALTER TABLE IF EXISTS ONLY public.networks DROP CONSTRAINT IF EXISTS organization_id_fkey;
ALTER TABLE IF EXISTS ONLY public.invites DROP CONSTRAINT IF EXISTS invites_organization_id_fkey;
ALTER TABLE IF EXISTS ONLY public.invites DROP CONSTRAINT IF EXISTS invites_created_by_fkey;
ALTER TABLE IF EXISTS ONLY public.interfaces DROP CONSTRAINT IF EXISTS interfaces_subnet_id_fkey;
ALTER TABLE IF EXISTS ONLY public.interfaces DROP CONSTRAINT IF EXISTS interfaces_network_id_fkey;
ALTER TABLE IF EXISTS ONLY public.interfaces DROP CONSTRAINT IF EXISTS interfaces_host_id_fkey;
ALTER TABLE IF EXISTS ONLY public.hosts DROP CONSTRAINT IF EXISTS hosts_network_id_fkey;
ALTER TABLE IF EXISTS ONLY public.groups DROP CONSTRAINT IF EXISTS groups_network_id_fkey;
ALTER TABLE IF EXISTS ONLY public.group_bindings DROP CONSTRAINT IF EXISTS group_bindings_group_id_fkey;
ALTER TABLE IF EXISTS ONLY public.group_bindings DROP CONSTRAINT IF EXISTS group_bindings_binding_id_fkey;
ALTER TABLE IF EXISTS ONLY public.entity_tags DROP CONSTRAINT IF EXISTS entity_tags_tag_id_fkey;
ALTER TABLE IF EXISTS ONLY public.discovery DROP CONSTRAINT IF EXISTS discovery_network_id_fkey;
ALTER TABLE IF EXISTS ONLY public.discovery DROP CONSTRAINT IF EXISTS discovery_daemon_id_fkey;
ALTER TABLE IF EXISTS ONLY public.daemons DROP CONSTRAINT IF EXISTS daemons_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.daemons DROP CONSTRAINT IF EXISTS daemons_network_id_fkey;
ALTER TABLE IF EXISTS ONLY public.bindings DROP CONSTRAINT IF EXISTS bindings_service_id_fkey;
ALTER TABLE IF EXISTS ONLY public.bindings DROP CONSTRAINT IF EXISTS bindings_port_id_fkey;
ALTER TABLE IF EXISTS ONLY public.bindings DROP CONSTRAINT IF EXISTS bindings_network_id_fkey;
ALTER TABLE IF EXISTS ONLY public.bindings DROP CONSTRAINT IF EXISTS bindings_interface_id_fkey;
ALTER TABLE IF EXISTS ONLY public.api_keys DROP CONSTRAINT IF EXISTS api_keys_network_id_fkey;
DROP INDEX IF EXISTS public.idx_users_organization;
DROP INDEX IF EXISTS public.idx_users_oidc_provider_subject;
DROP INDEX IF EXISTS public.idx_users_email_lower;
DROP INDEX IF EXISTS public.idx_user_network_access_user;
DROP INDEX IF EXISTS public.idx_user_network_access_network;
DROP INDEX IF EXISTS public.idx_user_api_keys_user;
DROP INDEX IF EXISTS public.idx_user_api_keys_org;
DROP INDEX IF EXISTS public.idx_user_api_keys_key;
DROP INDEX IF EXISTS public.idx_user_api_key_network_access_network;
DROP INDEX IF EXISTS public.idx_user_api_key_network_access_key;
DROP INDEX IF EXISTS public.idx_topologies_network;
DROP INDEX IF EXISTS public.idx_tags_organization;
DROP INDEX IF EXISTS public.idx_tags_org_name;
DROP INDEX IF EXISTS public.idx_subnets_network;
DROP INDEX IF EXISTS public.idx_shares_topology;
DROP INDEX IF EXISTS public.idx_shares_network;
DROP INDEX IF EXISTS public.idx_shares_enabled;
DROP INDEX IF EXISTS public.idx_services_network;
DROP INDEX IF EXISTS public.idx_services_host_position;
DROP INDEX IF EXISTS public.idx_services_host_id;
DROP INDEX IF EXISTS public.idx_ports_number;
DROP INDEX IF EXISTS public.idx_ports_network;
DROP INDEX IF EXISTS public.idx_ports_host;
DROP INDEX IF EXISTS public.idx_organizations_stripe_customer;
DROP INDEX IF EXISTS public.idx_networks_owner_organization;
DROP INDEX IF EXISTS public.idx_invites_organization;
DROP INDEX IF EXISTS public.idx_invites_expires_at;
DROP INDEX IF EXISTS public.idx_interfaces_subnet;
DROP INDEX IF EXISTS public.idx_interfaces_network;
DROP INDEX IF EXISTS public.idx_interfaces_host_mac;
DROP INDEX IF EXISTS public.idx_interfaces_host;
DROP INDEX IF EXISTS public.idx_hosts_network;
DROP INDEX IF EXISTS public.idx_groups_network;
DROP INDEX IF EXISTS public.idx_group_bindings_group;
DROP INDEX IF EXISTS public.idx_group_bindings_binding;
DROP INDEX IF EXISTS public.idx_entity_tags_tag_id;
DROP INDEX IF EXISTS public.idx_entity_tags_entity;
DROP INDEX IF EXISTS public.idx_discovery_network;
DROP INDEX IF EXISTS public.idx_discovery_daemon;
DROP INDEX IF EXISTS public.idx_daemons_network;
DROP INDEX IF EXISTS public.idx_daemon_host_id;
DROP INDEX IF EXISTS public.idx_bindings_service;
DROP INDEX IF EXISTS public.idx_bindings_port;
DROP INDEX IF EXISTS public.idx_bindings_network;
DROP INDEX IF EXISTS public.idx_bindings_interface;
DROP INDEX IF EXISTS public.idx_api_keys_network;
DROP INDEX IF EXISTS public.idx_api_keys_key;
ALTER TABLE IF EXISTS ONLY tower_sessions.session DROP CONSTRAINT IF EXISTS session_pkey;
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_pkey;
ALTER TABLE IF EXISTS ONLY public.user_network_access DROP CONSTRAINT IF EXISTS user_network_access_user_id_network_id_key;
ALTER TABLE IF EXISTS ONLY public.user_network_access DROP CONSTRAINT IF EXISTS user_network_access_pkey;
ALTER TABLE IF EXISTS ONLY public.user_api_keys DROP CONSTRAINT IF EXISTS user_api_keys_pkey;
ALTER TABLE IF EXISTS ONLY public.user_api_keys DROP CONSTRAINT IF EXISTS user_api_keys_key_key;
ALTER TABLE IF EXISTS ONLY public.user_api_key_network_access DROP CONSTRAINT IF EXISTS user_api_key_network_access_pkey;
ALTER TABLE IF EXISTS ONLY public.user_api_key_network_access DROP CONSTRAINT IF EXISTS user_api_key_network_access_api_key_id_network_id_key;
ALTER TABLE IF EXISTS ONLY public.topologies DROP CONSTRAINT IF EXISTS topologies_pkey;
ALTER TABLE IF EXISTS ONLY public.tags DROP CONSTRAINT IF EXISTS tags_pkey;
ALTER TABLE IF EXISTS ONLY public.subnets DROP CONSTRAINT IF EXISTS subnets_pkey;
ALTER TABLE IF EXISTS ONLY public.shares DROP CONSTRAINT IF EXISTS shares_pkey;
ALTER TABLE IF EXISTS ONLY public.services DROP CONSTRAINT IF EXISTS services_pkey;
ALTER TABLE IF EXISTS ONLY public.ports DROP CONSTRAINT IF EXISTS ports_pkey;
ALTER TABLE IF EXISTS ONLY public.ports DROP CONSTRAINT IF EXISTS ports_host_id_port_number_protocol_key;
ALTER TABLE IF EXISTS ONLY public.organizations DROP CONSTRAINT IF EXISTS organizations_pkey;
ALTER TABLE IF EXISTS ONLY public.networks DROP CONSTRAINT IF EXISTS networks_pkey;
ALTER TABLE IF EXISTS ONLY public.invites DROP CONSTRAINT IF EXISTS invites_pkey;
ALTER TABLE IF EXISTS ONLY public.interfaces DROP CONSTRAINT IF EXISTS interfaces_pkey;
ALTER TABLE IF EXISTS ONLY public.interfaces DROP CONSTRAINT IF EXISTS interfaces_host_id_subnet_id_ip_address_key;
ALTER TABLE IF EXISTS ONLY public.hosts DROP CONSTRAINT IF EXISTS hosts_pkey;
ALTER TABLE IF EXISTS ONLY public.groups DROP CONSTRAINT IF EXISTS groups_pkey;
ALTER TABLE IF EXISTS ONLY public.group_bindings DROP CONSTRAINT IF EXISTS group_bindings_pkey;
ALTER TABLE IF EXISTS ONLY public.group_bindings DROP CONSTRAINT IF EXISTS group_bindings_group_id_binding_id_key;
ALTER TABLE IF EXISTS ONLY public.entity_tags DROP CONSTRAINT IF EXISTS entity_tags_pkey;
ALTER TABLE IF EXISTS ONLY public.entity_tags DROP CONSTRAINT IF EXISTS entity_tags_entity_id_entity_type_tag_id_key;
ALTER TABLE IF EXISTS ONLY public.discovery DROP CONSTRAINT IF EXISTS discovery_pkey;
ALTER TABLE IF EXISTS ONLY public.daemons DROP CONSTRAINT IF EXISTS daemons_pkey;
ALTER TABLE IF EXISTS ONLY public.bindings DROP CONSTRAINT IF EXISTS bindings_pkey;
ALTER TABLE IF EXISTS ONLY public.api_keys DROP CONSTRAINT IF EXISTS api_keys_pkey;
ALTER TABLE IF EXISTS ONLY public.api_keys DROP CONSTRAINT IF EXISTS api_keys_key_key;
ALTER TABLE IF EXISTS ONLY public._sqlx_migrations DROP CONSTRAINT IF EXISTS _sqlx_migrations_pkey;
DROP TABLE IF EXISTS tower_sessions.session;
DROP TABLE IF EXISTS public.users;
DROP TABLE IF EXISTS public.user_network_access;
DROP TABLE IF EXISTS public.user_api_keys;
DROP TABLE IF EXISTS public.user_api_key_network_access;
DROP TABLE IF EXISTS public.topologies;
DROP TABLE IF EXISTS public.tags;
DROP TABLE IF EXISTS public.subnets;
DROP TABLE IF EXISTS public.shares;
DROP TABLE IF EXISTS public.services;
DROP TABLE IF EXISTS public.ports;
DROP TABLE IF EXISTS public.organizations;
DROP TABLE IF EXISTS public.networks;
DROP TABLE IF EXISTS public.invites;
DROP TABLE IF EXISTS public.interfaces;
DROP TABLE IF EXISTS public.hosts;
DROP TABLE IF EXISTS public.groups;
DROP TABLE IF EXISTS public.group_bindings;
DROP TABLE IF EXISTS public.entity_tags;
DROP TABLE IF EXISTS public.discovery;
DROP TABLE IF EXISTS public.daemons;
DROP TABLE IF EXISTS public.bindings;
DROP TABLE IF EXISTS public.api_keys;
DROP TABLE IF EXISTS public._sqlx_migrations;
DROP EXTENSION IF EXISTS pgcrypto;
DROP SCHEMA IF EXISTS tower_sessions;
--
-- Name: tower_sessions; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA tower_sessions;


ALTER SCHEMA tower_sessions OWNER TO postgres;

--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: _sqlx_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public._sqlx_migrations (
    version bigint NOT NULL,
    description text NOT NULL,
    installed_on timestamp with time zone DEFAULT now() NOT NULL,
    success boolean NOT NULL,
    checksum bytea NOT NULL,
    execution_time bigint NOT NULL
);


ALTER TABLE public._sqlx_migrations OWNER TO postgres;

--
-- Name: api_keys; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.api_keys (
    id uuid NOT NULL,
    key text NOT NULL,
    network_id uuid NOT NULL,
    name text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    last_used timestamp with time zone,
    expires_at timestamp with time zone,
    is_enabled boolean DEFAULT true NOT NULL
);


ALTER TABLE public.api_keys OWNER TO postgres;

--
-- Name: bindings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bindings (
    id uuid NOT NULL,
    network_id uuid NOT NULL,
    service_id uuid NOT NULL,
    binding_type text NOT NULL,
    interface_id uuid,
    port_id uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT bindings_binding_type_check CHECK ((binding_type = ANY (ARRAY['Interface'::text, 'Port'::text]))),
    CONSTRAINT valid_binding CHECK ((((binding_type = 'Interface'::text) AND (interface_id IS NOT NULL) AND (port_id IS NULL)) OR ((binding_type = 'Port'::text) AND (port_id IS NOT NULL))))
);


ALTER TABLE public.bindings OWNER TO postgres;

--
-- Name: daemons; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.daemons (
    id uuid NOT NULL,
    network_id uuid NOT NULL,
    host_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    last_seen timestamp with time zone NOT NULL,
    capabilities jsonb DEFAULT '{}'::jsonb,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    mode text DEFAULT '"Push"'::text,
    url text NOT NULL,
    name text,
    version text,
    user_id uuid NOT NULL
);


ALTER TABLE public.daemons OWNER TO postgres;

--
-- Name: discovery; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.discovery (
    id uuid NOT NULL,
    network_id uuid NOT NULL,
    daemon_id uuid NOT NULL,
    run_type jsonb NOT NULL,
    discovery_type jsonb NOT NULL,
    name text NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.discovery OWNER TO postgres;

--
-- Name: entity_tags; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.entity_tags (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    entity_id uuid NOT NULL,
    entity_type character varying(50) NOT NULL,
    tag_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.entity_tags OWNER TO postgres;

--
-- Name: group_bindings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.group_bindings (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    group_id uuid NOT NULL,
    binding_id uuid NOT NULL,
    "position" integer NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.group_bindings OWNER TO postgres;

--
-- Name: groups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.groups (
    id uuid NOT NULL,
    network_id uuid NOT NULL,
    name text NOT NULL,
    description text,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    source jsonb NOT NULL,
    color text NOT NULL,
    edge_style text DEFAULT '"SmoothStep"'::text,
    group_type text NOT NULL
);


ALTER TABLE public.groups OWNER TO postgres;

--
-- Name: hosts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hosts (
    id uuid NOT NULL,
    network_id uuid NOT NULL,
    name text NOT NULL,
    hostname text,
    description text,
    source jsonb NOT NULL,
    virtualization jsonb,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    hidden boolean DEFAULT false
);


ALTER TABLE public.hosts OWNER TO postgres;

--
-- Name: interfaces; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.interfaces (
    id uuid NOT NULL,
    network_id uuid NOT NULL,
    host_id uuid NOT NULL,
    subnet_id uuid NOT NULL,
    ip_address inet NOT NULL,
    mac_address macaddr,
    name text,
    "position" integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.interfaces OWNER TO postgres;

--
-- Name: invites; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.invites (
    id uuid NOT NULL,
    organization_id uuid NOT NULL,
    permissions text NOT NULL,
    network_ids uuid[] NOT NULL,
    url text NOT NULL,
    created_by uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    send_to text
);


ALTER TABLE public.invites OWNER TO postgres;

--
-- Name: networks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.networks (
    id uuid NOT NULL,
    name text NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    organization_id uuid NOT NULL
);


ALTER TABLE public.networks OWNER TO postgres;

--
-- Name: COLUMN networks.organization_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.networks.organization_id IS 'The organization that owns and pays for this network';


--
-- Name: organizations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.organizations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    stripe_customer_id text,
    plan jsonb NOT NULL,
    plan_status text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    onboarding jsonb DEFAULT '[]'::jsonb
);


ALTER TABLE public.organizations OWNER TO postgres;

--
-- Name: TABLE organizations; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.organizations IS 'Organizations that own networks and have Stripe subscriptions';


--
-- Name: COLUMN organizations.plan; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.organizations.plan IS 'The current billing plan for the organization (e.g., Community, Pro)';


--
-- Name: ports; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ports (
    id uuid NOT NULL,
    network_id uuid NOT NULL,
    host_id uuid NOT NULL,
    port_number integer NOT NULL,
    protocol text NOT NULL,
    port_type text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT ports_port_number_check CHECK (((port_number >= 0) AND (port_number <= 65535))),
    CONSTRAINT ports_protocol_check CHECK ((protocol = ANY (ARRAY['Tcp'::text, 'Udp'::text])))
);


ALTER TABLE public.ports OWNER TO postgres;

--
-- Name: services; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.services (
    id uuid NOT NULL,
    network_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    name text NOT NULL,
    host_id uuid NOT NULL,
    service_definition text NOT NULL,
    virtualization jsonb,
    source jsonb NOT NULL,
    "position" integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.services OWNER TO postgres;

--
-- Name: shares; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shares (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    topology_id uuid NOT NULL,
    network_id uuid NOT NULL,
    created_by uuid NOT NULL,
    name text NOT NULL,
    is_enabled boolean DEFAULT true NOT NULL,
    expires_at timestamp with time zone,
    password_hash text,
    allowed_domains text[],
    options jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.shares OWNER TO postgres;

--
-- Name: subnets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.subnets (
    id uuid NOT NULL,
    network_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    cidr text NOT NULL,
    name text NOT NULL,
    description text,
    subnet_type text NOT NULL,
    source jsonb NOT NULL
);


ALTER TABLE public.subnets OWNER TO postgres;

--
-- Name: tags; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tags (
    id uuid NOT NULL,
    organization_id uuid NOT NULL,
    name text NOT NULL,
    description text,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    color text NOT NULL
);


ALTER TABLE public.tags OWNER TO postgres;

--
-- Name: topologies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.topologies (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    network_id uuid NOT NULL,
    name text NOT NULL,
    edges jsonb NOT NULL,
    nodes jsonb NOT NULL,
    options jsonb NOT NULL,
    hosts jsonb NOT NULL,
    subnets jsonb NOT NULL,
    services jsonb NOT NULL,
    groups jsonb NOT NULL,
    is_stale boolean,
    last_refreshed timestamp with time zone DEFAULT now() NOT NULL,
    is_locked boolean,
    locked_at timestamp with time zone,
    locked_by uuid,
    removed_hosts uuid[],
    removed_services uuid[],
    removed_subnets uuid[],
    removed_groups uuid[],
    parent_id uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    tags uuid[] DEFAULT '{}'::uuid[] NOT NULL,
    interfaces jsonb DEFAULT '[]'::jsonb NOT NULL,
    removed_interfaces uuid[] DEFAULT '{}'::uuid[],
    ports jsonb DEFAULT '[]'::jsonb NOT NULL,
    removed_ports uuid[] DEFAULT '{}'::uuid[],
    bindings jsonb DEFAULT '[]'::jsonb NOT NULL,
    removed_bindings uuid[] DEFAULT '{}'::uuid[]
);


ALTER TABLE public.topologies OWNER TO postgres;

--
-- Name: user_api_key_network_access; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_api_key_network_access (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    api_key_id uuid NOT NULL,
    network_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.user_api_key_network_access OWNER TO postgres;

--
-- Name: user_api_keys; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_api_keys (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    key text NOT NULL,
    user_id uuid NOT NULL,
    organization_id uuid NOT NULL,
    permissions text DEFAULT 'Viewer'::text NOT NULL,
    name text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    last_used timestamp with time zone,
    expires_at timestamp with time zone,
    is_enabled boolean DEFAULT true NOT NULL
);


ALTER TABLE public.user_api_keys OWNER TO postgres;

--
-- Name: user_network_access; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_network_access (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    network_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.user_network_access OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    password_hash text,
    oidc_provider text,
    oidc_subject text,
    oidc_linked_at timestamp with time zone,
    email text NOT NULL,
    organization_id uuid NOT NULL,
    permissions text DEFAULT 'Member'::text NOT NULL,
    tags uuid[] DEFAULT '{}'::uuid[] NOT NULL,
    terms_accepted_at timestamp with time zone
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: COLUMN users.organization_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.users.organization_id IS 'The single organization this user belongs to';


--
-- Name: COLUMN users.permissions; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.users.permissions IS 'User role within their organization: Owner, Member, Viewer';


--
-- Name: session; Type: TABLE; Schema: tower_sessions; Owner: postgres
--

CREATE TABLE tower_sessions.session (
    id text NOT NULL,
    data bytea NOT NULL,
    expiry_date timestamp with time zone NOT NULL
);


ALTER TABLE tower_sessions.session OWNER TO postgres;

--
-- Data for Name: _sqlx_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public._sqlx_migrations (version, description, installed_on, success, checksum, execution_time) FROM stdin;
20251006215000	users	2026-01-07 19:35:35.391642+00	t	\\x4f13ce14ff67ef0b7145987c7b22b588745bf9fbb7b673450c26a0f2f9a36ef8ca980e456c8d77cfb1b2d7a4577a64d7	3633891
20251006215100	networks	2026-01-07 19:35:35.396987+00	t	\\xeaa5a07a262709f64f0c59f31e25519580c79e2d1a523ce72736848946a34b17dd9adc7498eaf90551af6b7ec6d4e0e3	5567895
20251006215151	create hosts	2026-01-07 19:35:35.402999+00	t	\\x6ec7487074c0724932d21df4cf1ed66645313cf62c159a7179e39cbc261bcb81a24f7933a0e3cf58504f2a90fc5c1962	3764073
20251006215155	create subnets	2026-01-07 19:35:35.407081+00	t	\\xefb5b25742bd5f4489b67351d9f2494a95f307428c911fd8c5f475bfb03926347bdc269bbd048d2ddb06336945b27926	3750445
20251006215201	create groups	2026-01-07 19:35:35.411151+00	t	\\x0a7032bf4d33a0baf020e905da865cde240e2a09dda2f62aa535b2c5d4b26b20be30a3286f1b5192bd94cd4a5dbb5bcd	3763482
20251006215204	create daemons	2026-01-07 19:35:35.41527+00	t	\\xcfea93403b1f9cf9aac374711d4ac72d8a223e3c38a1d2a06d9edb5f94e8a557debac3668271f8176368eadc5105349f	4329016
20251006215212	create services	2026-01-07 19:35:35.419939+00	t	\\xd5b07f82fc7c9da2782a364d46078d7d16b5c08df70cfbf02edcfe9b1b24ab6024ad159292aeea455f15cfd1f4740c1d	4907494
20251029193448	user-auth	2026-01-07 19:35:35.42532+00	t	\\xfde8161a8db89d51eeade7517d90a41d560f19645620f2298f78f116219a09728b18e91251ae31e46a47f6942d5a9032	6007093
20251030044828	daemon api	2026-01-07 19:35:35.43164+00	t	\\x181eb3541f51ef5b038b2064660370775d1b364547a214a20dde9c9d4bb95a1c273cd4525ef29e61fa65a3eb4fee0400	1478475
20251030170438	host-hide	2026-01-07 19:35:35.433458+00	t	\\x87c6fda7f8456bf610a78e8e98803158caa0e12857c5bab466a5bb0004d41b449004a68e728ca13f17e051f662a15454	1210355
20251102224919	create discovery	2026-01-07 19:35:35.434941+00	t	\\xb32a04abb891aba48f92a059fae7341442355ca8e4af5d109e28e2a4f79ee8e11b2a8f40453b7f6725c2dd6487f26573	12129025
20251106235621	normalize-daemon-cols	2026-01-07 19:35:35.44748+00	t	\\x5b137118d506e2708097c432358bf909265b3cf3bacd662b02e2c81ba589a9e0100631c7801cffd9c57bb10a6674fb3b	1759060
20251107034459	api keys	2026-01-07 19:35:35.449585+00	t	\\x3133ec043c0c6e25b6e55f7da84cae52b2a72488116938a2c669c8512c2efe72a74029912bcba1f2a2a0a8b59ef01dde	9084166
20251107222650	oidc-auth	2026-01-07 19:35:35.458993+00	t	\\xd349750e0298718cbcd98eaff6e152b3fb45c3d9d62d06eedeb26c75452e9ce1af65c3e52c9f2de4bd532939c2f31096	28932188
20251110181948	orgs-billing	2026-01-07 19:35:35.488352+00	t	\\x5bbea7a2dfc9d00213bd66b473289ddd66694eff8a4f3eaab937c985b64c5f8c3ad2d64e960afbb03f335ac6766687aa	10883920
20251113223656	group-enhancements	2026-01-07 19:35:35.499586+00	t	\\xbe0699486d85df2bd3edc1f0bf4f1f096d5b6c5070361702c4d203ec2bb640811be88bb1979cfe51b40805ad84d1de65	1068742
20251117032720	daemon-mode	2026-01-07 19:35:35.50096+00	t	\\xdd0d899c24b73d70e9970e54b2c748d6b6b55c856ca0f8590fe990da49cc46c700b1ce13f57ff65abd6711f4bd8a6481	1214050
20251118143058	set-default-plan	2026-01-07 19:35:35.502524+00	t	\\xd19142607aef84aac7cfb97d60d29bda764d26f513f2c72306734c03cec2651d23eee3ce6cacfd36ca52dbddc462f917	1186240
20251118225043	save-topology	2026-01-07 19:35:35.504083+00	t	\\x011a594740c69d8d0f8b0149d49d1b53cfbf948b7866ebd84403394139cb66a44277803462846b06e762577adc3e61a3	9081343
20251123232748	network-permissions	2026-01-07 19:35:35.513528+00	t	\\x161be7ae5721c06523d6488606f1a7b1f096193efa1183ecdd1c2c9a4a9f4cad4884e939018917314aaf261d9a3f97ae	2717130
20251125001342	billing-updates	2026-01-07 19:35:35.51667+00	t	\\xa235d153d95aeb676e3310a52ccb69dfbd7ca36bba975d5bbca165ceeec7196da12119f23597ea5276c364f90f23db1e	977381
20251128035448	org-onboarding-status	2026-01-07 19:35:35.518031+00	t	\\x1d7a7e9bf23b5078250f31934d1bc47bbaf463ace887e7746af30946e843de41badfc2b213ed64912a18e07b297663d8	1834288
20251129180942	nfs-consolidate	2026-01-07 19:35:35.520432+00	t	\\xb38f41d30699a475c2b967f8e43156f3b49bb10341bddbde01d9fb5ba805f6724685e27e53f7e49b6c8b59e29c74f98e	1291817
20251206052641	discovery-progress	2026-01-07 19:35:35.522008+00	t	\\x9d433b7b8c58d0d5437a104497e5e214febb2d1441a3ad7c28512e7497ed14fb9458e0d4ff786962a59954cb30da1447	1680523
20251206202200	plan-fix	2026-01-07 19:35:35.524158+00	t	\\x242f6699dbf485cf59a8d1b8cd9d7c43aeef635a9316be815a47e15238c5e4af88efaa0daf885be03572948dc0c9edac	1043505
20251207061341	daemon-url	2026-01-07 19:35:35.525695+00	t	\\x01172455c4f2d0d57371d18ef66d2ab3b7a8525067ef8a86945c616982e6ce06f5ea1e1560a8f20dadcd5be2223e6df1	2400352
20251210045929	tags	2026-01-07 19:35:35.528423+00	t	\\xe3dde83d39f8552b5afcdc1493cddfeffe077751bf55472032bc8b35fc8fc2a2caa3b55b4c2354ace7de03c3977982db	8848067
20251210175035	terms	2026-01-07 19:35:35.537681+00	t	\\xe47f0cf7aba1bffa10798bede953da69fd4bfaebf9c75c76226507c558a3595c6bfc6ac8920d11398dbdf3b762769992	895608
20251213025048	hash-keys	2026-01-07 19:35:35.538892+00	t	\\xfc7cbb8ce61f0c225322297f7459dcbe362242b9001c06cb874b7f739cea7ae888d8f0cfaed6623bcbcb9ec54c8cd18b	11227550
20251214050638	scanopy	2026-01-07 19:35:35.550442+00	t	\\x0108bb39832305f024126211710689adc48d973ff66e5e59ff49468389b75c1ff95d1fbbb7bdb50e33ec1333a1f29ea6	1382015
20251215215724	topo-scanopy-fix	2026-01-07 19:35:35.552224+00	t	\\xed88a4b71b3c9b61d46322b5053362e5a25a9293cd3c420c9df9fcaeb3441254122b8a18f58c297f535c842b8a8b0a38	729830
20251217153736	category rename	2026-01-07 19:35:35.553227+00	t	\\x03af7ec905e11a77e25038a3c272645da96014da7c50c585a25cea3f9a7579faba3ff45114a5e589d144c9550ba42421	1747747
20251218053111	invite-persistence	2026-01-07 19:35:35.555271+00	t	\\x21d12f48b964acfd600f88e70ceb14abd9cf2a8a10db2eae2a6d8f44cf7d20749f93293631e6123e92b7c3c1793877c2	5183679
20251219211216	create shares	2026-01-07 19:35:35.560785+00	t	\\x036485debd3536f9e58ead728f461b925585911acf565970bf3b2ab295b12a2865606d6a56d334c5641dcd42adeb3d68	7251771
20251220170928	permissions-cleanup	2026-01-07 19:35:35.56835+00	t	\\x632f7b6702b494301e0d36fd3b900686b1a7f9936aef8c084b5880f1152b8256a125566e2b5ac40216eaadd3c4c64a03	1394829
20251220180000	commercial-to-community	2026-01-07 19:35:35.570033+00	t	\\x26fc298486c225f2f01271d611418377c403183ae51daf32fef104ec07c027f2017d138910c4fbfb5f49819a5f4194d6	781516
20251221010000	cleanup subnet type	2026-01-07 19:35:35.571082+00	t	\\xb521121f3fd3a10c0de816977ac2a2ffb6118f34f8474ffb9058722abc0dc4cf5cbec83bc6ee49e79a68e6b715087f40	831439
20251221020000	remove host target	2026-01-07 19:35:35.572228+00	t	\\x77b5f8872705676ca81a5704bd1eaee90b9a52b404bdaa27a23da2ffd4858d3e131680926a5a00ad2a0d7a24ba229046	987600
20251221030000	user network access	2026-01-07 19:35:35.573521+00	t	\\x5c23f5bb6b0b8ca699a17eee6730c4197a006ca21fecc79136a5e5697b9211a81b4cd08ceda70dace6a26408d021ff3a	7690930
20251221040000	interfaces table	2026-01-07 19:35:35.581561+00	t	\\xf7977b6f1e7e5108c614397d03a38c9bd9243fdc422575ec29610366a0c88f443de2132185878d8e291f06a50a8c3244	9715442
20251221050000	ports table	2026-01-07 19:35:35.591644+00	t	\\xdf72f9306b405be7be62c39003ef38408115e740b120f24e8c78b8e136574fff7965c52023b3bc476899613fa5f4fe35	8929230
20251221060000	bindings table	2026-01-07 19:35:35.6009+00	t	\\x933648a724bd179c7f47305e4080db85342d48712cde39374f0f88cde9d7eba8fe5fafba360937331e2a8178dec420c4	11064747
20251221070000	group bindings	2026-01-07 19:35:35.612396+00	t	\\x697475802f6c42e38deee6596f4ba786b09f7b7cd91742fbc5696dd0f9b3ddfce90dd905153f2b1a9e82f959f5a88302	6280139
20251222020000	tag cascade delete	2026-01-07 19:35:35.619001+00	t	\\xabfb48c0da8522f5c8ea6d482eb5a5f4562ed41f6160a5915f0fd477c7dd0517aa84760ef99ab3a5db3e0f21b0c69b5f	1430826
20251223232524	network remove default	2026-01-07 19:35:35.62075+00	t	\\x7099fe4e52405e46269d7ce364050da930b481e72484ad3c4772fd2911d2d505476d659fa9f400c63bc287512d033e18	1019492
20251225100000	color enum	2026-01-07 19:35:35.622077+00	t	\\x62cecd9d79a49835a3bea68a7959ab62aa0c1aaa7e2940dec6a7f8a714362df3649f0c1f9313672d9268295ed5a1cfa9	1367388
20251227010000	topology snapshot migration	2026-01-07 19:35:35.623743+00	t	\\xc042591d254869c0e79c8b52a9ede680fd26f094e2c385f5f017e115f5e3f31ad155f4885d095344f2642ebb70755d54	4275446
20251228010000	user api keys	2026-01-07 19:35:35.628368+00	t	\\xa41adb558a5b9d94a4e17af3f16839b83f7da072dbeac9251b12d8a84c7bec6df008009acf246468712a975bb36bb5f5	12340303
20251230160000	daemon version and maintainer	2026-01-07 19:35:35.640995+00	t	\\xafed3d9f00adb8c1b0896fb663af801926c218472a0a197f90ecdaa13305a78846a9e15af0043ec010328ba533fca68f	2887630
20260103000000	service position	2026-01-07 19:35:35.64421+00	t	\\x19d00e8c8b300d1c74d721931f4d771ec7bc4e06db0d6a78126e00785586fdc4bcff5b832eeae2fce0cb8d01e12a7fb5	2243511
20260106000000	interface mac index	2026-01-07 19:35:35.646776+00	t	\\xa26248372a1e31af46a9c6fbdaef178982229e2ceeb90cc6a289d5764f87a38747294b3adf5f21276b5d171e42bdb6ac	1886465
20260106204402	entity tags junction	2026-01-07 19:35:35.648946+00	t	\\xf73c604f9f0b8db065d990a861684b0dbd62c3ef9bead120c68431c933774de56491a53f021e79f09801680152f5a08a	13838615
\.


--
-- Data for Name: api_keys; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.api_keys (id, key, network_id, name, created_at, updated_at, last_used, expires_at, is_enabled) FROM stdin;
dbbc8747-a297-412a-b350-3f28844685dd	49d8188be179428b92b2a4182fbbf1379999e6aefe250006ba086cb6351b5614	f4494e39-5ebe-4540-8c82-1059e132c8b6	Integrated Daemon API Key	2026-01-07 19:35:37.009715+00	2026-01-07 19:37:32.367327+00	2026-01-07 19:37:32.366058+00	\N	t
\.


--
-- Data for Name: bindings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bindings (id, network_id, service_id, binding_type, interface_id, port_id, created_at, updated_at) FROM stdin;
f5b174cf-f8ee-4cf6-869e-32049661e24d	f4494e39-5ebe-4540-8c82-1059e132c8b6	179e13b8-48a6-4a48-8490-ad6a9ffa5f16	Port	9da790c7-0f47-471c-8d44-b66caf5656e9	16852751-442e-413f-a381-057fcf604451	2026-01-07 19:35:37.267208+00	2026-01-07 19:35:37.267208+00
8bd752a0-6e51-42c5-bc45-361305b726df	f4494e39-5ebe-4540-8c82-1059e132c8b6	caee98f4-6b8c-4641-96e9-f2ea14ee4650	Port	55958cb2-ebc5-409a-bad4-43e5121ce3c0	90717c76-fa3a-46f2-9a26-2b38ea5aee6a	2026-01-07 19:36:13.551232+00	2026-01-07 19:36:13.551232+00
464efae3-ee85-4e21-897c-eca4aebd683b	f4494e39-5ebe-4540-8c82-1059e132c8b6	3a539491-5d42-4369-a205-d54fab8658a7	Port	8acb7f85-3d65-45dc-ba49-a381865f4ce9	49a2c14e-4d59-4cba-9af1-1abd6eaf0b83	2026-01-07 19:36:20.994454+00	2026-01-07 19:36:20.994454+00
3f47817b-4322-404d-b720-b44c1e112d38	f4494e39-5ebe-4540-8c82-1059e132c8b6	d61a9771-ba18-48ef-bceb-63c5f8316b3a	Port	76f471e1-f042-4bdb-98d0-c80419519c9e	4d116cc4-8323-4606-ac2d-045df6a3f9f9	2026-01-07 19:36:42.960867+00	2026-01-07 19:36:42.960867+00
6c8b93bd-daa8-41a2-aaeb-941e8b02bda9	f4494e39-5ebe-4540-8c82-1059e132c8b6	d61a9771-ba18-48ef-bceb-63c5f8316b3a	Port	76f471e1-f042-4bdb-98d0-c80419519c9e	a9d0d54e-3bed-4e9c-b818-7a7425315a94	2026-01-07 19:36:42.960868+00	2026-01-07 19:36:42.960868+00
6662930a-daa6-4fb3-8ea8-7b557bb17203	f4494e39-5ebe-4540-8c82-1059e132c8b6	c040931b-b951-413b-8a94-47799a2aafd4	Port	ad9cad19-9017-4a2e-b44d-80d544e872a1	e9d4132d-16a2-4081-be7c-7f6d148fb661	2026-01-07 19:36:54.297716+00	2026-01-07 19:36:54.297716+00
e8ada640-70ce-43aa-92a8-897fec48f9d0	f4494e39-5ebe-4540-8c82-1059e132c8b6	5a8560f7-0d2a-48c1-ae2b-daf88213e803	Port	ad9cad19-9017-4a2e-b44d-80d544e872a1	d8c9bccc-1498-4ef1-9e85-95312e6cc45f	2026-01-07 19:36:54.298155+00	2026-01-07 19:36:54.298155+00
b8e20a8c-c9ec-4572-b1a1-80330516c3e7	f4494e39-5ebe-4540-8c82-1059e132c8b6	1775cb7e-173b-4578-85e1-39f4042de58c	Port	ad9cad19-9017-4a2e-b44d-80d544e872a1	4fa8510a-5b1e-4db4-94c3-efed56e4e4ff	2026-01-07 19:37:01.883118+00	2026-01-07 19:37:01.883118+00
6b842a4a-482f-4fd7-8534-27a07a947271	f4494e39-5ebe-4540-8c82-1059e132c8b6	758c04c0-0b47-43ae-8e31-1042f1e3d8e2	Port	ad9cad19-9017-4a2e-b44d-80d544e872a1	4423dddd-a55d-4e0a-b30e-c37ff6be8c95	2026-01-07 19:37:01.883616+00	2026-01-07 19:37:01.883616+00
\.


--
-- Data for Name: daemons; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.daemons (id, network_id, host_id, created_at, last_seen, capabilities, updated_at, mode, url, name, version, user_id) FROM stdin;
4e13af8d-1722-43b7-8997-d120125da472	f4494e39-5ebe-4540-8c82-1059e132c8b6	8d2b3e28-5476-4481-8063-7d9a748acd17	2026-01-07 19:35:37.111353+00	2026-01-07 19:37:22.420299+00	{"has_docker_socket": false, "interfaced_subnet_ids": ["b5a6c86d-3afd-4c99-a90b-47604c21625c"]}	2026-01-07 19:37:22.421362+00	"Push"	http://172.25.0.4:60073	scanopy-daemon	0.13.2	afb5e9da-5588-458f-8afc-3f413c985a58
\.


--
-- Data for Name: discovery; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.discovery (id, network_id, daemon_id, run_type, discovery_type, name, created_at, updated_at) FROM stdin;
a926fc7f-f24b-4225-9bca-7db7e762878c	f4494e39-5ebe-4540-8c82-1059e132c8b6	4e13af8d-1722-43b7-8997-d120125da472	{"type": "Scheduled", "enabled": true, "last_run": null, "cron_schedule": "0 0 0 * * *"}	{"type": "SelfReport", "host_id": "8d2b3e28-5476-4481-8063-7d9a748acd17"}	Self Report	2026-01-07 19:35:37.121384+00	2026-01-07 19:35:37.121384+00
417635bf-718e-4b40-87c4-e6729d3a7303	f4494e39-5ebe-4540-8c82-1059e132c8b6	4e13af8d-1722-43b7-8997-d120125da472	{"type": "Scheduled", "enabled": true, "last_run": null, "cron_schedule": "0 0 0 * * *"}	{"type": "Network", "subnet_ids": null, "host_naming_fallback": "BestService"}	Network Discovery	2026-01-07 19:35:37.129612+00	2026-01-07 19:35:37.129612+00
772bd10f-04d5-47ba-8217-d4ef49921d0e	f4494e39-5ebe-4540-8c82-1059e132c8b6	4e13af8d-1722-43b7-8997-d120125da472	{"type": "Historical", "results": {"error": null, "phase": "Complete", "progress": 100, "daemon_id": "4e13af8d-1722-43b7-8997-d120125da472", "network_id": "f4494e39-5ebe-4540-8c82-1059e132c8b6", "session_id": "1b38e106-8908-4721-a2da-2ff4e8050fdd", "started_at": "2026-01-07T19:35:37.129206573Z", "finished_at": "2026-01-07T19:35:37.310658052Z", "discovery_type": {"type": "SelfReport", "host_id": "8d2b3e28-5476-4481-8063-7d9a748acd17"}}}	{"type": "SelfReport", "host_id": "8d2b3e28-5476-4481-8063-7d9a748acd17"}	Self Report	2026-01-07 19:35:37.129206+00	2026-01-07 19:35:37.316989+00
5fae312f-4c9a-4a09-8b1d-e0eda45d13e4	f4494e39-5ebe-4540-8c82-1059e132c8b6	4e13af8d-1722-43b7-8997-d120125da472	{"type": "Historical", "results": {"error": null, "phase": "Complete", "progress": 100, "daemon_id": "4e13af8d-1722-43b7-8997-d120125da472", "network_id": "f4494e39-5ebe-4540-8c82-1059e132c8b6", "session_id": "2bcaf1b3-d5f4-4e7f-b8c0-17f097e99883", "started_at": "2026-01-07T19:35:37.332272036Z", "finished_at": "2026-01-07T19:37:32.364671012Z", "discovery_type": {"type": "Network", "subnet_ids": null, "host_naming_fallback": "BestService"}}}	{"type": "Network", "subnet_ids": null, "host_naming_fallback": "BestService"}	Network Discovery	2026-01-07 19:35:37.332272+00	2026-01-07 19:37:32.367918+00
\.


--
-- Data for Name: entity_tags; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.entity_tags (id, entity_id, entity_type, tag_id, created_at) FROM stdin;
\.


--
-- Data for Name: group_bindings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.group_bindings (id, group_id, binding_id, "position", created_at) FROM stdin;
\.


--
-- Data for Name: groups; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.groups (id, network_id, name, description, created_at, updated_at, source, color, edge_style, group_type) FROM stdin;
79d350d0-e5ad-4878-8af1-7f255ab0a9d8	f4494e39-5ebe-4540-8c82-1059e132c8b6		\N	2026-01-07 19:37:32.37815+00	2026-01-07 19:37:32.37815+00	{"type": "Manual"}	Yellow	"SmoothStep"	RequestPath
\.


--
-- Data for Name: hosts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.hosts (id, network_id, name, hostname, description, source, virtualization, created_at, updated_at, hidden) FROM stdin;
8d2b3e28-5476-4481-8063-7d9a748acd17	f4494e39-5ebe-4540-8c82-1059e132c8b6	scanopy-daemon	5dad2fb671da	\N	{"type": "Discovery", "metadata": [{"date": "2026-01-07T19:35:37.267188939Z", "type": "SelfReport", "host_id": "8d2b3e28-5476-4481-8063-7d9a748acd17", "daemon_id": "4e13af8d-1722-43b7-8997-d120125da472"}]}	null	2026-01-07 19:35:37.105211+00	2026-01-07 19:35:37.280693+00	f
c9c31972-719b-4a02-b8a3-95120a4a6f0a	f4494e39-5ebe-4540-8c82-1059e132c8b6	scanopy-postgres-dev-1.scanopy_scanopy-dev	scanopy-postgres-dev-1.scanopy_scanopy-dev	\N	{"type": "Discovery", "metadata": [{"date": "2026-01-07T19:35:58.584145535Z", "type": "Network", "daemon_id": "4e13af8d-1722-43b7-8997-d120125da472", "subnet_ids": null, "host_naming_fallback": "BestService"}]}	null	2026-01-07 19:35:58.584146+00	2026-01-07 19:35:58.584146+00	f
9e1fc80f-15a2-4950-be6f-87490e0a8683	f4494e39-5ebe-4540-8c82-1059e132c8b6	scanopy-server-1.scanopy_scanopy-dev	scanopy-server-1.scanopy_scanopy-dev	\N	{"type": "Discovery", "metadata": [{"date": "2026-01-07T19:36:13.655053663Z", "type": "Network", "daemon_id": "4e13af8d-1722-43b7-8997-d120125da472", "subnet_ids": null, "host_naming_fallback": "BestService"}]}	null	2026-01-07 19:36:13.655054+00	2026-01-07 19:36:13.655054+00	f
12de8180-8c3e-4be2-9641-44d67ec3687c	f4494e39-5ebe-4540-8c82-1059e132c8b6	homeassistant-discovery.scanopy_scanopy-dev	homeassistant-discovery.scanopy_scanopy-dev	\N	{"type": "Discovery", "metadata": [{"date": "2026-01-07T19:36:28.332392103Z", "type": "Network", "daemon_id": "4e13af8d-1722-43b7-8997-d120125da472", "subnet_ids": null, "host_naming_fallback": "BestService"}]}	null	2026-01-07 19:36:28.332393+00	2026-01-07 19:36:28.332393+00	f
1c54f5c4-ca0f-486c-92b0-e12590c30719	f4494e39-5ebe-4540-8c82-1059e132c8b6	runnervmh13bl	runnervmh13bl	\N	{"type": "Discovery", "metadata": [{"date": "2026-01-07T19:36:47.018397197Z", "type": "Network", "daemon_id": "4e13af8d-1722-43b7-8997-d120125da472", "subnet_ids": null, "host_naming_fallback": "BestService"}]}	null	2026-01-07 19:36:47.018398+00	2026-01-07 19:36:47.018398+00	f
\.


--
-- Data for Name: interfaces; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.interfaces (id, network_id, host_id, subnet_id, ip_address, mac_address, name, "position", created_at, updated_at) FROM stdin;
9da790c7-0f47-471c-8d44-b66caf5656e9	f4494e39-5ebe-4540-8c82-1059e132c8b6	8d2b3e28-5476-4481-8063-7d9a748acd17	b5a6c86d-3afd-4c99-a90b-47604c21625c	172.25.0.4	9a:0c:8d:63:c4:c8	eth0	0	2026-01-07 19:35:37.129431+00	2026-01-07 19:35:37.129431+00
55958cb2-ebc5-409a-bad4-43e5121ce3c0	f4494e39-5ebe-4540-8c82-1059e132c8b6	c9c31972-719b-4a02-b8a3-95120a4a6f0a	b5a6c86d-3afd-4c99-a90b-47604c21625c	172.25.0.6	06:09:00:73:87:6b	\N	0	2026-01-07 19:35:58.58412+00	2026-01-07 19:35:58.58412+00
8acb7f85-3d65-45dc-ba49-a381865f4ce9	f4494e39-5ebe-4540-8c82-1059e132c8b6	9e1fc80f-15a2-4950-be6f-87490e0a8683	b5a6c86d-3afd-4c99-a90b-47604c21625c	172.25.0.3	12:87:bb:62:6c:35	\N	0	2026-01-07 19:36:13.655022+00	2026-01-07 19:36:13.655022+00
76f471e1-f042-4bdb-98d0-c80419519c9e	f4494e39-5ebe-4540-8c82-1059e132c8b6	12de8180-8c3e-4be2-9641-44d67ec3687c	b5a6c86d-3afd-4c99-a90b-47604c21625c	172.25.0.5	c2:03:67:fb:d7:8c	\N	0	2026-01-07 19:36:28.332367+00	2026-01-07 19:36:28.332367+00
ad9cad19-9017-4a2e-b44d-80d544e872a1	f4494e39-5ebe-4540-8c82-1059e132c8b6	1c54f5c4-ca0f-486c-92b0-e12590c30719	b5a6c86d-3afd-4c99-a90b-47604c21625c	172.25.0.1	82:22:97:b2:90:c3	\N	0	2026-01-07 19:36:47.018366+00	2026-01-07 19:36:47.018366+00
\.


--
-- Data for Name: invites; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.invites (id, organization_id, permissions, network_ids, url, created_by, created_at, updated_at, expires_at, send_to) FROM stdin;
\.


--
-- Data for Name: networks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.networks (id, name, created_at, updated_at, organization_id) FROM stdin;
f4494e39-5ebe-4540-8c82-1059e132c8b6	My Network	2026-01-07 19:35:36.990914+00	2026-01-07 19:35:36.990914+00	5345fc29-5946-40e7-8cfd-b31cbcc67afe
\.


--
-- Data for Name: organizations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.organizations (id, name, stripe_customer_id, plan, plan_status, created_at, updated_at, onboarding) FROM stdin;
5345fc29-5946-40e7-8cfd-b31cbcc67afe	My Organization	\N	{"rate": "Month", "type": "Community", "base_cents": 0, "trial_days": 0}	active	2026-01-07 19:35:36.984452+00	2026-01-07 19:37:33.205303+00	["OnboardingModalCompleted", "FirstDaemonRegistered", "FirstApiKeyCreated"]
\.


--
-- Data for Name: ports; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ports (id, network_id, host_id, port_number, protocol, port_type, created_at, updated_at) FROM stdin;
16852751-442e-413f-a381-057fcf604451	f4494e39-5ebe-4540-8c82-1059e132c8b6	8d2b3e28-5476-4481-8063-7d9a748acd17	60073	Tcp	Custom	2026-01-07 19:35:37.266997+00	2026-01-07 19:35:37.266997+00
90717c76-fa3a-46f2-9a26-2b38ea5aee6a	f4494e39-5ebe-4540-8c82-1059e132c8b6	c9c31972-719b-4a02-b8a3-95120a4a6f0a	5432	Tcp	PostgreSQL	2026-01-07 19:36:13.551221+00	2026-01-07 19:36:13.551221+00
49a2c14e-4d59-4cba-9af1-1abd6eaf0b83	f4494e39-5ebe-4540-8c82-1059e132c8b6	9e1fc80f-15a2-4950-be6f-87490e0a8683	60072	Tcp	Custom	2026-01-07 19:36:20.994445+00	2026-01-07 19:36:20.994445+00
4d116cc4-8323-4606-ac2d-045df6a3f9f9	f4494e39-5ebe-4540-8c82-1059e132c8b6	12de8180-8c3e-4be2-9641-44d67ec3687c	8123	Tcp	Custom	2026-01-07 19:36:42.960856+00	2026-01-07 19:36:42.960856+00
a9d0d54e-3bed-4e9c-b818-7a7425315a94	f4494e39-5ebe-4540-8c82-1059e132c8b6	12de8180-8c3e-4be2-9641-44d67ec3687c	18555	Tcp	Custom	2026-01-07 19:36:42.960862+00	2026-01-07 19:36:42.960862+00
e9d4132d-16a2-4081-be7c-7f6d148fb661	f4494e39-5ebe-4540-8c82-1059e132c8b6	1c54f5c4-ca0f-486c-92b0-e12590c30719	8123	Tcp	Custom	2026-01-07 19:36:54.297706+00	2026-01-07 19:36:54.297706+00
d8c9bccc-1498-4ef1-9e85-95312e6cc45f	f4494e39-5ebe-4540-8c82-1059e132c8b6	1c54f5c4-ca0f-486c-92b0-e12590c30719	60072	Tcp	Custom	2026-01-07 19:36:54.298152+00	2026-01-07 19:36:54.298152+00
4fa8510a-5b1e-4db4-94c3-efed56e4e4ff	f4494e39-5ebe-4540-8c82-1059e132c8b6	1c54f5c4-ca0f-486c-92b0-e12590c30719	22	Tcp	Ssh	2026-01-07 19:37:01.883107+00	2026-01-07 19:37:01.883107+00
4423dddd-a55d-4e0a-b30e-c37ff6be8c95	f4494e39-5ebe-4540-8c82-1059e132c8b6	1c54f5c4-ca0f-486c-92b0-e12590c30719	5435	Tcp	Custom	2026-01-07 19:37:01.883611+00	2026-01-07 19:37:01.883611+00
\.


--
-- Data for Name: services; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.services (id, network_id, created_at, updated_at, name, host_id, service_definition, virtualization, source, "position") FROM stdin;
179e13b8-48a6-4a48-8490-ad6a9ffa5f16	f4494e39-5ebe-4540-8c82-1059e132c8b6	2026-01-07 19:35:37.267212+00	2026-01-07 19:35:37.267212+00	Scanopy Daemon	8d2b3e28-5476-4481-8063-7d9a748acd17	"Scanopy Daemon"	null	{"type": "DiscoveryWithMatch", "details": {"reason": {"data": "Scanopy Daemon self-report", "type": "reason"}, "confidence": "Certain"}, "metadata": [{"date": "2026-01-07T19:35:37.267211752Z", "type": "SelfReport", "host_id": "8d2b3e28-5476-4481-8063-7d9a748acd17", "daemon_id": "4e13af8d-1722-43b7-8997-d120125da472"}]}	0
caee98f4-6b8c-4641-96e9-f2ea14ee4650	f4494e39-5ebe-4540-8c82-1059e132c8b6	2026-01-07 19:36:13.551237+00	2026-01-07 19:36:13.551237+00	PostgreSQL	c9c31972-719b-4a02-b8a3-95120a4a6f0a	"PostgreSQL"	null	{"type": "DiscoveryWithMatch", "details": {"reason": {"data": ["Generic service", [{"data": "Port 5432/tcp is open", "type": "reason"}]], "type": "container"}, "confidence": "NotApplicable"}, "metadata": [{"date": "2026-01-07T19:36:13.551214190Z", "type": "Network", "daemon_id": "4e13af8d-1722-43b7-8997-d120125da472", "subnet_ids": null, "host_naming_fallback": "BestService"}]}	0
3a539491-5d42-4369-a205-d54fab8658a7	f4494e39-5ebe-4540-8c82-1059e132c8b6	2026-01-07 19:36:20.994457+00	2026-01-07 19:36:20.994457+00	Scanopy Server	9e1fc80f-15a2-4950-be6f-87490e0a8683	"Scanopy Server"	null	{"type": "DiscoveryWithMatch", "details": {"reason": {"data": "Response for 172.25.0.3:60072/api/health contained \\"scanopy\\" in body", "type": "reason"}, "confidence": "High"}, "metadata": [{"date": "2026-01-07T19:36:20.994439095Z", "type": "Network", "daemon_id": "4e13af8d-1722-43b7-8997-d120125da472", "subnet_ids": null, "host_naming_fallback": "BestService"}]}	0
d61a9771-ba18-48ef-bceb-63c5f8316b3a	f4494e39-5ebe-4540-8c82-1059e132c8b6	2026-01-07 19:36:42.960871+00	2026-01-07 19:36:42.960871+00	Unclaimed Open Ports	12de8180-8c3e-4be2-9641-44d67ec3687c	"Unclaimed Open Ports"	null	{"type": "DiscoveryWithMatch", "details": {"reason": {"data": ["Generic service", [{"data": "Has unbound open ports", "type": "reason"}]], "type": "container"}, "confidence": "NotApplicable"}, "metadata": [{"date": "2026-01-07T19:36:42.960849127Z", "type": "Network", "daemon_id": "4e13af8d-1722-43b7-8997-d120125da472", "subnet_ids": null, "host_naming_fallback": "BestService"}]}	0
c040931b-b951-413b-8a94-47799a2aafd4	f4494e39-5ebe-4540-8c82-1059e132c8b6	2026-01-07 19:36:54.297719+00	2026-01-07 19:36:54.297719+00	Home Assistant	1c54f5c4-ca0f-486c-92b0-e12590c30719	"Home Assistant"	null	{"type": "DiscoveryWithMatch", "details": {"reason": {"data": "Response for 172.25.0.1:8123/ contained \\"home assistant\\" in body", "type": "reason"}, "confidence": "High"}, "metadata": [{"date": "2026-01-07T19:36:54.297699656Z", "type": "Network", "daemon_id": "4e13af8d-1722-43b7-8997-d120125da472", "subnet_ids": null, "host_naming_fallback": "BestService"}]}	0
5a8560f7-0d2a-48c1-ae2b-daf88213e803	f4494e39-5ebe-4540-8c82-1059e132c8b6	2026-01-07 19:36:54.298157+00	2026-01-07 19:36:54.298157+00	Scanopy Server	1c54f5c4-ca0f-486c-92b0-e12590c30719	"Scanopy Server"	null	{"type": "DiscoveryWithMatch", "details": {"reason": {"data": "Response for 172.25.0.1:60072/api/health contained \\"scanopy\\" in body", "type": "reason"}, "confidence": "High"}, "metadata": [{"date": "2026-01-07T19:36:54.298151117Z", "type": "Network", "daemon_id": "4e13af8d-1722-43b7-8997-d120125da472", "subnet_ids": null, "host_naming_fallback": "BestService"}]}	1
1775cb7e-173b-4578-85e1-39f4042de58c	f4494e39-5ebe-4540-8c82-1059e132c8b6	2026-01-07 19:37:01.883123+00	2026-01-07 19:37:01.883123+00	SSH	1c54f5c4-ca0f-486c-92b0-e12590c30719	"SSH"	null	{"type": "DiscoveryWithMatch", "details": {"reason": {"data": ["Generic service", [{"data": "Port 22/tcp is open", "type": "reason"}]], "type": "container"}, "confidence": "NotApplicable"}, "metadata": [{"date": "2026-01-07T19:37:01.883101594Z", "type": "Network", "daemon_id": "4e13af8d-1722-43b7-8997-d120125da472", "subnet_ids": null, "host_naming_fallback": "BestService"}]}	2
758c04c0-0b47-43ae-8e31-1042f1e3d8e2	f4494e39-5ebe-4540-8c82-1059e132c8b6	2026-01-07 19:37:01.883619+00	2026-01-07 19:37:01.883619+00	Unclaimed Open Ports	1c54f5c4-ca0f-486c-92b0-e12590c30719	"Unclaimed Open Ports"	null	{"type": "DiscoveryWithMatch", "details": {"reason": {"data": ["Generic service", [{"data": "Has unbound open ports", "type": "reason"}]], "type": "container"}, "confidence": "NotApplicable"}, "metadata": [{"date": "2026-01-07T19:37:01.883609360Z", "type": "Network", "daemon_id": "4e13af8d-1722-43b7-8997-d120125da472", "subnet_ids": null, "host_naming_fallback": "BestService"}]}	3
\.


--
-- Data for Name: shares; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.shares (id, topology_id, network_id, created_by, name, is_enabled, expires_at, password_hash, allowed_domains, options, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: subnets; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.subnets (id, network_id, created_at, updated_at, cidr, name, description, subnet_type, source) FROM stdin;
4a145044-1926-42ee-97df-4368d6c45992	f4494e39-5ebe-4540-8c82-1059e132c8b6	2026-01-07 19:35:36.992364+00	2026-01-07 19:35:36.992364+00	"0.0.0.0/0"	Internet	This subnet uses the 0.0.0.0/0 CIDR as an organizational container for services running on the internet (e.g., public DNS servers, cloud services, etc.).	Internet	{"type": "System"}
0c4d9e73-edde-4fa7-a882-4315fa5b6428	f4494e39-5ebe-4540-8c82-1059e132c8b6	2026-01-07 19:35:36.992368+00	2026-01-07 19:35:36.992368+00	"0.0.0.0/0"	Remote Network	This subnet uses the 0.0.0.0/0 CIDR as an organizational container for hosts on remote networks (e.g., mobile connections, friend's networks, public WiFi, etc.).	Remote	{"type": "System"}
b5a6c86d-3afd-4c99-a90b-47604c21625c	f4494e39-5ebe-4540-8c82-1059e132c8b6	2026-01-07 19:35:37.129407+00	2026-01-07 19:35:37.129407+00	"172.25.0.0/28"	172.25.0.0/28	\N	Lan	{"type": "Discovery", "metadata": [{"date": "2026-01-07T19:35:37.129406275Z", "type": "SelfReport", "host_id": "8d2b3e28-5476-4481-8063-7d9a748acd17", "daemon_id": "4e13af8d-1722-43b7-8997-d120125da472"}]}
\.


--
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tags (id, organization_id, name, description, created_at, updated_at, color) FROM stdin;
80731a53-d8bb-4b8f-abe5-e50d0033badd	5345fc29-5946-40e7-8cfd-b31cbcc67afe	New Tag	\N	2026-01-07 19:37:32.385322+00	2026-01-07 19:37:32.385322+00	Yellow
\.


--
-- Data for Name: topologies; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.topologies (id, network_id, name, edges, nodes, options, hosts, subnets, services, groups, is_stale, last_refreshed, is_locked, locked_at, locked_by, removed_hosts, removed_services, removed_subnets, removed_groups, parent_id, created_at, updated_at, tags, interfaces, removed_interfaces, ports, removed_ports, bindings, removed_bindings) FROM stdin;
523bc9a6-99f1-46d2-8331-eadb0ea60bf2	f4494e39-5ebe-4540-8c82-1059e132c8b6	My Topology	[]	[]	{"local": {"no_fade_edges": false, "hide_edge_types": [], "left_zone_title": "Infrastructure", "hide_resize_handles": false}, "request": {"hide_ports": false, "hide_service_categories": [], "show_gateway_in_left_zone": true, "group_docker_bridges_by_host": true, "left_zone_service_categories": ["DNS", "ReverseProxy"], "hide_vm_title_on_docker_container": false}}	[{"id": "8d2b3e28-5476-4481-8063-7d9a748acd17", "name": "scanopy-daemon", "tags": [], "hidden": false, "source": {"type": "Discovery", "metadata": [{"date": "2026-01-07T19:35:37.267188939Z", "type": "SelfReport", "host_id": "8d2b3e28-5476-4481-8063-7d9a748acd17", "daemon_id": "4e13af8d-1722-43b7-8997-d120125da472"}]}, "hostname": "5dad2fb671da", "created_at": "2026-01-07T19:35:37.105211Z", "network_id": "f4494e39-5ebe-4540-8c82-1059e132c8b6", "updated_at": "2026-01-07T19:35:37.280693Z", "description": null, "virtualization": null}, {"id": "c9c31972-719b-4a02-b8a3-95120a4a6f0a", "name": "scanopy-postgres-dev-1.scanopy_scanopy-dev", "tags": [], "hidden": false, "source": {"type": "Discovery", "metadata": [{"date": "2026-01-07T19:35:58.584145535Z", "type": "Network", "daemon_id": "4e13af8d-1722-43b7-8997-d120125da472", "subnet_ids": null, "host_naming_fallback": "BestService"}]}, "hostname": "scanopy-postgres-dev-1.scanopy_scanopy-dev", "created_at": "2026-01-07T19:35:58.584146Z", "network_id": "f4494e39-5ebe-4540-8c82-1059e132c8b6", "updated_at": "2026-01-07T19:35:58.584146Z", "description": null, "virtualization": null}, {"id": "9e1fc80f-15a2-4950-be6f-87490e0a8683", "name": "scanopy-server-1.scanopy_scanopy-dev", "tags": [], "hidden": false, "source": {"type": "Discovery", "metadata": [{"date": "2026-01-07T19:36:13.655053663Z", "type": "Network", "daemon_id": "4e13af8d-1722-43b7-8997-d120125da472", "subnet_ids": null, "host_naming_fallback": "BestService"}]}, "hostname": "scanopy-server-1.scanopy_scanopy-dev", "created_at": "2026-01-07T19:36:13.655054Z", "network_id": "f4494e39-5ebe-4540-8c82-1059e132c8b6", "updated_at": "2026-01-07T19:36:13.655054Z", "description": null, "virtualization": null}, {"id": "12de8180-8c3e-4be2-9641-44d67ec3687c", "name": "homeassistant-discovery.scanopy_scanopy-dev", "tags": [], "hidden": false, "source": {"type": "Discovery", "metadata": [{"date": "2026-01-07T19:36:28.332392103Z", "type": "Network", "daemon_id": "4e13af8d-1722-43b7-8997-d120125da472", "subnet_ids": null, "host_naming_fallback": "BestService"}]}, "hostname": "homeassistant-discovery.scanopy_scanopy-dev", "created_at": "2026-01-07T19:36:28.332393Z", "network_id": "f4494e39-5ebe-4540-8c82-1059e132c8b6", "updated_at": "2026-01-07T19:36:28.332393Z", "description": null, "virtualization": null}, {"id": "1c54f5c4-ca0f-486c-92b0-e12590c30719", "name": "runnervmh13bl", "tags": [], "hidden": false, "source": {"type": "Discovery", "metadata": [{"date": "2026-01-07T19:36:47.018397197Z", "type": "Network", "daemon_id": "4e13af8d-1722-43b7-8997-d120125da472", "subnet_ids": null, "host_naming_fallback": "BestService"}]}, "hostname": "runnervmh13bl", "created_at": "2026-01-07T19:36:47.018398Z", "network_id": "f4494e39-5ebe-4540-8c82-1059e132c8b6", "updated_at": "2026-01-07T19:36:47.018398Z", "description": null, "virtualization": null}]	[{"id": "4a145044-1926-42ee-97df-4368d6c45992", "cidr": "0.0.0.0/0", "name": "Internet", "tags": [], "source": {"type": "System"}, "created_at": "2026-01-07T19:35:36.992364Z", "network_id": "f4494e39-5ebe-4540-8c82-1059e132c8b6", "updated_at": "2026-01-07T19:35:36.992364Z", "description": "This subnet uses the 0.0.0.0/0 CIDR as an organizational container for services running on the internet (e.g., public DNS servers, cloud services, etc.).", "subnet_type": "Internet"}, {"id": "0c4d9e73-edde-4fa7-a882-4315fa5b6428", "cidr": "0.0.0.0/0", "name": "Remote Network", "tags": [], "source": {"type": "System"}, "created_at": "2026-01-07T19:35:36.992368Z", "network_id": "f4494e39-5ebe-4540-8c82-1059e132c8b6", "updated_at": "2026-01-07T19:35:36.992368Z", "description": "This subnet uses the 0.0.0.0/0 CIDR as an organizational container for hosts on remote networks (e.g., mobile connections, friend's networks, public WiFi, etc.).", "subnet_type": "Remote"}, {"id": "b5a6c86d-3afd-4c99-a90b-47604c21625c", "cidr": "172.25.0.0/28", "name": "172.25.0.0/28", "tags": [], "source": {"type": "Discovery", "metadata": [{"date": "2026-01-07T19:35:37.129406275Z", "type": "SelfReport", "host_id": "8d2b3e28-5476-4481-8063-7d9a748acd17", "daemon_id": "4e13af8d-1722-43b7-8997-d120125da472"}]}, "created_at": "2026-01-07T19:35:37.129407Z", "network_id": "f4494e39-5ebe-4540-8c82-1059e132c8b6", "updated_at": "2026-01-07T19:35:37.129407Z", "description": null, "subnet_type": "Lan"}]	[{"id": "179e13b8-48a6-4a48-8490-ad6a9ffa5f16", "name": "Scanopy Daemon", "tags": [], "source": {"type": "DiscoveryWithMatch", "details": {"reason": {"data": "Scanopy Daemon self-report", "type": "reason"}, "confidence": "Certain"}, "metadata": [{"date": "2026-01-07T19:35:37.267211752Z", "type": "SelfReport", "host_id": "8d2b3e28-5476-4481-8063-7d9a748acd17", "daemon_id": "4e13af8d-1722-43b7-8997-d120125da472"}]}, "host_id": "8d2b3e28-5476-4481-8063-7d9a748acd17", "bindings": [{"id": "f5b174cf-f8ee-4cf6-869e-32049661e24d", "type": "Port", "port_id": "16852751-442e-413f-a381-057fcf604451", "created_at": "2026-01-07T19:35:37.267208Z", "network_id": "f4494e39-5ebe-4540-8c82-1059e132c8b6", "service_id": "179e13b8-48a6-4a48-8490-ad6a9ffa5f16", "updated_at": "2026-01-07T19:35:37.267208Z", "interface_id": "9da790c7-0f47-471c-8d44-b66caf5656e9"}], "position": 0, "created_at": "2026-01-07T19:35:37.267212Z", "network_id": "f4494e39-5ebe-4540-8c82-1059e132c8b6", "updated_at": "2026-01-07T19:35:37.267212Z", "virtualization": null, "service_definition": "Scanopy Daemon"}, {"id": "caee98f4-6b8c-4641-96e9-f2ea14ee4650", "name": "PostgreSQL", "tags": [], "source": {"type": "DiscoveryWithMatch", "details": {"reason": {"data": ["Generic service", [{"data": "Port 5432/tcp is open", "type": "reason"}]], "type": "container"}, "confidence": "NotApplicable"}, "metadata": [{"date": "2026-01-07T19:36:13.551214190Z", "type": "Network", "daemon_id": "4e13af8d-1722-43b7-8997-d120125da472", "subnet_ids": null, "host_naming_fallback": "BestService"}]}, "host_id": "c9c31972-719b-4a02-b8a3-95120a4a6f0a", "bindings": [{"id": "8bd752a0-6e51-42c5-bc45-361305b726df", "type": "Port", "port_id": "90717c76-fa3a-46f2-9a26-2b38ea5aee6a", "created_at": "2026-01-07T19:36:13.551232Z", "network_id": "f4494e39-5ebe-4540-8c82-1059e132c8b6", "service_id": "caee98f4-6b8c-4641-96e9-f2ea14ee4650", "updated_at": "2026-01-07T19:36:13.551232Z", "interface_id": "55958cb2-ebc5-409a-bad4-43e5121ce3c0"}], "position": 0, "created_at": "2026-01-07T19:36:13.551237Z", "network_id": "f4494e39-5ebe-4540-8c82-1059e132c8b6", "updated_at": "2026-01-07T19:36:13.551237Z", "virtualization": null, "service_definition": "PostgreSQL"}, {"id": "3a539491-5d42-4369-a205-d54fab8658a7", "name": "Scanopy Server", "tags": [], "source": {"type": "DiscoveryWithMatch", "details": {"reason": {"data": "Response for 172.25.0.3:60072/api/health contained \\"scanopy\\" in body", "type": "reason"}, "confidence": "High"}, "metadata": [{"date": "2026-01-07T19:36:20.994439095Z", "type": "Network", "daemon_id": "4e13af8d-1722-43b7-8997-d120125da472", "subnet_ids": null, "host_naming_fallback": "BestService"}]}, "host_id": "9e1fc80f-15a2-4950-be6f-87490e0a8683", "bindings": [{"id": "464efae3-ee85-4e21-897c-eca4aebd683b", "type": "Port", "port_id": "49a2c14e-4d59-4cba-9af1-1abd6eaf0b83", "created_at": "2026-01-07T19:36:20.994454Z", "network_id": "f4494e39-5ebe-4540-8c82-1059e132c8b6", "service_id": "3a539491-5d42-4369-a205-d54fab8658a7", "updated_at": "2026-01-07T19:36:20.994454Z", "interface_id": "8acb7f85-3d65-45dc-ba49-a381865f4ce9"}], "position": 0, "created_at": "2026-01-07T19:36:20.994457Z", "network_id": "f4494e39-5ebe-4540-8c82-1059e132c8b6", "updated_at": "2026-01-07T19:36:20.994457Z", "virtualization": null, "service_definition": "Scanopy Server"}, {"id": "d61a9771-ba18-48ef-bceb-63c5f8316b3a", "name": "Unclaimed Open Ports", "tags": [], "source": {"type": "DiscoveryWithMatch", "details": {"reason": {"data": ["Generic service", [{"data": "Has unbound open ports", "type": "reason"}]], "type": "container"}, "confidence": "NotApplicable"}, "metadata": [{"date": "2026-01-07T19:36:42.960849127Z", "type": "Network", "daemon_id": "4e13af8d-1722-43b7-8997-d120125da472", "subnet_ids": null, "host_naming_fallback": "BestService"}]}, "host_id": "12de8180-8c3e-4be2-9641-44d67ec3687c", "bindings": [{"id": "3f47817b-4322-404d-b720-b44c1e112d38", "type": "Port", "port_id": "4d116cc4-8323-4606-ac2d-045df6a3f9f9", "created_at": "2026-01-07T19:36:42.960867Z", "network_id": "f4494e39-5ebe-4540-8c82-1059e132c8b6", "service_id": "d61a9771-ba18-48ef-bceb-63c5f8316b3a", "updated_at": "2026-01-07T19:36:42.960867Z", "interface_id": "76f471e1-f042-4bdb-98d0-c80419519c9e"}, {"id": "6c8b93bd-daa8-41a2-aaeb-941e8b02bda9", "type": "Port", "port_id": "a9d0d54e-3bed-4e9c-b818-7a7425315a94", "created_at": "2026-01-07T19:36:42.960868Z", "network_id": "f4494e39-5ebe-4540-8c82-1059e132c8b6", "service_id": "d61a9771-ba18-48ef-bceb-63c5f8316b3a", "updated_at": "2026-01-07T19:36:42.960868Z", "interface_id": "76f471e1-f042-4bdb-98d0-c80419519c9e"}], "position": 0, "created_at": "2026-01-07T19:36:42.960871Z", "network_id": "f4494e39-5ebe-4540-8c82-1059e132c8b6", "updated_at": "2026-01-07T19:36:42.960871Z", "virtualization": null, "service_definition": "Unclaimed Open Ports"}, {"id": "c040931b-b951-413b-8a94-47799a2aafd4", "name": "Home Assistant", "tags": [], "source": {"type": "DiscoveryWithMatch", "details": {"reason": {"data": "Response for 172.25.0.1:8123/ contained \\"home assistant\\" in body", "type": "reason"}, "confidence": "High"}, "metadata": [{"date": "2026-01-07T19:36:54.297699656Z", "type": "Network", "daemon_id": "4e13af8d-1722-43b7-8997-d120125da472", "subnet_ids": null, "host_naming_fallback": "BestService"}]}, "host_id": "1c54f5c4-ca0f-486c-92b0-e12590c30719", "bindings": [{"id": "6662930a-daa6-4fb3-8ea8-7b557bb17203", "type": "Port", "port_id": "e9d4132d-16a2-4081-be7c-7f6d148fb661", "created_at": "2026-01-07T19:36:54.297716Z", "network_id": "f4494e39-5ebe-4540-8c82-1059e132c8b6", "service_id": "c040931b-b951-413b-8a94-47799a2aafd4", "updated_at": "2026-01-07T19:36:54.297716Z", "interface_id": "ad9cad19-9017-4a2e-b44d-80d544e872a1"}], "position": 0, "created_at": "2026-01-07T19:36:54.297719Z", "network_id": "f4494e39-5ebe-4540-8c82-1059e132c8b6", "updated_at": "2026-01-07T19:36:54.297719Z", "virtualization": null, "service_definition": "Home Assistant"}, {"id": "5a8560f7-0d2a-48c1-ae2b-daf88213e803", "name": "Scanopy Server", "tags": [], "source": {"type": "DiscoveryWithMatch", "details": {"reason": {"data": "Response for 172.25.0.1:60072/api/health contained \\"scanopy\\" in body", "type": "reason"}, "confidence": "High"}, "metadata": [{"date": "2026-01-07T19:36:54.298151117Z", "type": "Network", "daemon_id": "4e13af8d-1722-43b7-8997-d120125da472", "subnet_ids": null, "host_naming_fallback": "BestService"}]}, "host_id": "1c54f5c4-ca0f-486c-92b0-e12590c30719", "bindings": [{"id": "e8ada640-70ce-43aa-92a8-897fec48f9d0", "type": "Port", "port_id": "d8c9bccc-1498-4ef1-9e85-95312e6cc45f", "created_at": "2026-01-07T19:36:54.298155Z", "network_id": "f4494e39-5ebe-4540-8c82-1059e132c8b6", "service_id": "5a8560f7-0d2a-48c1-ae2b-daf88213e803", "updated_at": "2026-01-07T19:36:54.298155Z", "interface_id": "ad9cad19-9017-4a2e-b44d-80d544e872a1"}], "position": 1, "created_at": "2026-01-07T19:36:54.298157Z", "network_id": "f4494e39-5ebe-4540-8c82-1059e132c8b6", "updated_at": "2026-01-07T19:36:54.298157Z", "virtualization": null, "service_definition": "Scanopy Server"}, {"id": "1775cb7e-173b-4578-85e1-39f4042de58c", "name": "SSH", "tags": [], "source": {"type": "DiscoveryWithMatch", "details": {"reason": {"data": ["Generic service", [{"data": "Port 22/tcp is open", "type": "reason"}]], "type": "container"}, "confidence": "NotApplicable"}, "metadata": [{"date": "2026-01-07T19:37:01.883101594Z", "type": "Network", "daemon_id": "4e13af8d-1722-43b7-8997-d120125da472", "subnet_ids": null, "host_naming_fallback": "BestService"}]}, "host_id": "1c54f5c4-ca0f-486c-92b0-e12590c30719", "bindings": [{"id": "b8e20a8c-c9ec-4572-b1a1-80330516c3e7", "type": "Port", "port_id": "4fa8510a-5b1e-4db4-94c3-efed56e4e4ff", "created_at": "2026-01-07T19:37:01.883118Z", "network_id": "f4494e39-5ebe-4540-8c82-1059e132c8b6", "service_id": "1775cb7e-173b-4578-85e1-39f4042de58c", "updated_at": "2026-01-07T19:37:01.883118Z", "interface_id": "ad9cad19-9017-4a2e-b44d-80d544e872a1"}], "position": 2, "created_at": "2026-01-07T19:37:01.883123Z", "network_id": "f4494e39-5ebe-4540-8c82-1059e132c8b6", "updated_at": "2026-01-07T19:37:01.883123Z", "virtualization": null, "service_definition": "SSH"}, {"id": "758c04c0-0b47-43ae-8e31-1042f1e3d8e2", "name": "Unclaimed Open Ports", "tags": [], "source": {"type": "DiscoveryWithMatch", "details": {"reason": {"data": ["Generic service", [{"data": "Has unbound open ports", "type": "reason"}]], "type": "container"}, "confidence": "NotApplicable"}, "metadata": [{"date": "2026-01-07T19:37:01.883609360Z", "type": "Network", "daemon_id": "4e13af8d-1722-43b7-8997-d120125da472", "subnet_ids": null, "host_naming_fallback": "BestService"}]}, "host_id": "1c54f5c4-ca0f-486c-92b0-e12590c30719", "bindings": [{"id": "6b842a4a-482f-4fd7-8534-27a07a947271", "type": "Port", "port_id": "4423dddd-a55d-4e0a-b30e-c37ff6be8c95", "created_at": "2026-01-07T19:37:01.883616Z", "network_id": "f4494e39-5ebe-4540-8c82-1059e132c8b6", "service_id": "758c04c0-0b47-43ae-8e31-1042f1e3d8e2", "updated_at": "2026-01-07T19:37:01.883616Z", "interface_id": "ad9cad19-9017-4a2e-b44d-80d544e872a1"}], "position": 3, "created_at": "2026-01-07T19:37:01.883619Z", "network_id": "f4494e39-5ebe-4540-8c82-1059e132c8b6", "updated_at": "2026-01-07T19:37:01.883619Z", "virtualization": null, "service_definition": "Unclaimed Open Ports"}]	[{"id": "79d350d0-e5ad-4878-8af1-7f255ab0a9d8", "name": "", "tags": [], "color": "Yellow", "source": {"type": "Manual"}, "created_at": "2026-01-07T19:37:32.378150Z", "edge_style": "SmoothStep", "group_type": "RequestPath", "network_id": "f4494e39-5ebe-4540-8c82-1059e132c8b6", "updated_at": "2026-01-07T19:37:32.378150Z", "binding_ids": [], "description": null}]	t	2026-01-07 19:35:37.007911+00	f	\N	\N	{1eeb5d5e-4851-44fe-86c8-291097a7d14b,2701644f-a8f5-4e41-a54e-c92dedce716e,1b7ab6ed-0ce2-41b9-b826-056a02dce3f0}	{b3cd24af-df42-47f5-88d7-a628f7443197}	{46936b73-464c-4093-862f-4a222528f098}	{174977d5-19fb-4239-a461-a08497c6865a}	\N	2026-01-07 19:35:36.996235+00	2026-01-07 19:37:34.548597+00	{}	[]	{}	[]	{}	[]	{}
\.


--
-- Data for Name: user_api_key_network_access; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_api_key_network_access (id, api_key_id, network_id, created_at) FROM stdin;
\.


--
-- Data for Name: user_api_keys; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_api_keys (id, key, user_id, organization_id, permissions, name, created_at, updated_at, last_used, expires_at, is_enabled) FROM stdin;
\.


--
-- Data for Name: user_network_access; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_network_access (id, user_id, network_id, created_at) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, created_at, updated_at, password_hash, oidc_provider, oidc_subject, oidc_linked_at, email, organization_id, permissions, tags, terms_accepted_at) FROM stdin;
afb5e9da-5588-458f-8afc-3f413c985a58	2026-01-07 19:35:36.987756+00	2026-01-07 19:35:36.987756+00	$argon2id$v=19$m=19456,t=2,p=1$IKPqPEET89SVsqL0hOMMhw$xjUVkucRll9gthMx6tZhrTBgDr3eV7fdD3RR3y65KTQ	\N	\N	\N	user@gmail.com	5345fc29-5946-40e7-8cfd-b31cbcc67afe	Owner	{}	\N
f0995220-bc8f-4837-a2ff-fc3c367283e6	2026-01-07 19:37:33.733915+00	2026-01-07 19:37:33.733915+00	\N	\N	\N	\N	user@example.com	5345fc29-5946-40e7-8cfd-b31cbcc67afe	Owner	{}	\N
\.


--
-- Data for Name: session; Type: TABLE DATA; Schema: tower_sessions; Owner: postgres
--

COPY tower_sessions.session (id, data, expiry_date) FROM stdin;
gXvcljlr0iGnx7i9IiRW4Q	\\x93c410e1562422bdb8c7a721d26b3996dc7b8181a7757365725f6964d92461666235653964612d353538382d343538662d386166632d33663431336339383561353899cd07ea0e132325ce08281c95000000	2026-01-14 19:35:37.136846+00
gNO8iYI8XBtRR3N1DMnSjA	\\x93c4108cd2c90c757347511b5c3c8289bcd38082a7757365725f6964d92461666235653964612d353538382d343538662d386166632d336634313363393835613538ad70656e64696e675f736574757082a86e6574776f726b739182a46e616d65aa4d79204e6574776f726baa6e6574776f726b5f6964d92432396230613132652d613066342d346537342d383834652d306361653863326234326132a86f72675f6e616d65af4d79204f7267616e697a6174696f6e99cd07ea0e132520ce38c4b3d0000000	2026-01-14 19:37:32.952415+00
\.


--
-- Name: _sqlx_migrations _sqlx_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._sqlx_migrations
    ADD CONSTRAINT _sqlx_migrations_pkey PRIMARY KEY (version);


--
-- Name: api_keys api_keys_key_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.api_keys
    ADD CONSTRAINT api_keys_key_key UNIQUE (key);


--
-- Name: api_keys api_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.api_keys
    ADD CONSTRAINT api_keys_pkey PRIMARY KEY (id);


--
-- Name: bindings bindings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bindings
    ADD CONSTRAINT bindings_pkey PRIMARY KEY (id);


--
-- Name: daemons daemons_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.daemons
    ADD CONSTRAINT daemons_pkey PRIMARY KEY (id);


--
-- Name: discovery discovery_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discovery
    ADD CONSTRAINT discovery_pkey PRIMARY KEY (id);


--
-- Name: entity_tags entity_tags_entity_id_entity_type_tag_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.entity_tags
    ADD CONSTRAINT entity_tags_entity_id_entity_type_tag_id_key UNIQUE (entity_id, entity_type, tag_id);


--
-- Name: entity_tags entity_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.entity_tags
    ADD CONSTRAINT entity_tags_pkey PRIMARY KEY (id);


--
-- Name: group_bindings group_bindings_group_id_binding_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_bindings
    ADD CONSTRAINT group_bindings_group_id_binding_id_key UNIQUE (group_id, binding_id);


--
-- Name: group_bindings group_bindings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_bindings
    ADD CONSTRAINT group_bindings_pkey PRIMARY KEY (id);


--
-- Name: groups groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.groups
    ADD CONSTRAINT groups_pkey PRIMARY KEY (id);


--
-- Name: hosts hosts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hosts
    ADD CONSTRAINT hosts_pkey PRIMARY KEY (id);


--
-- Name: interfaces interfaces_host_id_subnet_id_ip_address_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.interfaces
    ADD CONSTRAINT interfaces_host_id_subnet_id_ip_address_key UNIQUE (host_id, subnet_id, ip_address);


--
-- Name: interfaces interfaces_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.interfaces
    ADD CONSTRAINT interfaces_pkey PRIMARY KEY (id);


--
-- Name: invites invites_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invites
    ADD CONSTRAINT invites_pkey PRIMARY KEY (id);


--
-- Name: networks networks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.networks
    ADD CONSTRAINT networks_pkey PRIMARY KEY (id);


--
-- Name: organizations organizations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT organizations_pkey PRIMARY KEY (id);


--
-- Name: ports ports_host_id_port_number_protocol_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ports
    ADD CONSTRAINT ports_host_id_port_number_protocol_key UNIQUE (host_id, port_number, protocol);


--
-- Name: ports ports_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ports
    ADD CONSTRAINT ports_pkey PRIMARY KEY (id);


--
-- Name: services services_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_pkey PRIMARY KEY (id);


--
-- Name: shares shares_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shares
    ADD CONSTRAINT shares_pkey PRIMARY KEY (id);


--
-- Name: subnets subnets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subnets
    ADD CONSTRAINT subnets_pkey PRIMARY KEY (id);


--
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: topologies topologies_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.topologies
    ADD CONSTRAINT topologies_pkey PRIMARY KEY (id);


--
-- Name: user_api_key_network_access user_api_key_network_access_api_key_id_network_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_api_key_network_access
    ADD CONSTRAINT user_api_key_network_access_api_key_id_network_id_key UNIQUE (api_key_id, network_id);


--
-- Name: user_api_key_network_access user_api_key_network_access_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_api_key_network_access
    ADD CONSTRAINT user_api_key_network_access_pkey PRIMARY KEY (id);


--
-- Name: user_api_keys user_api_keys_key_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_api_keys
    ADD CONSTRAINT user_api_keys_key_key UNIQUE (key);


--
-- Name: user_api_keys user_api_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_api_keys
    ADD CONSTRAINT user_api_keys_pkey PRIMARY KEY (id);


--
-- Name: user_network_access user_network_access_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_network_access
    ADD CONSTRAINT user_network_access_pkey PRIMARY KEY (id);


--
-- Name: user_network_access user_network_access_user_id_network_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_network_access
    ADD CONSTRAINT user_network_access_user_id_network_id_key UNIQUE (user_id, network_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: session session_pkey; Type: CONSTRAINT; Schema: tower_sessions; Owner: postgres
--

ALTER TABLE ONLY tower_sessions.session
    ADD CONSTRAINT session_pkey PRIMARY KEY (id);


--
-- Name: idx_api_keys_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_api_keys_key ON public.api_keys USING btree (key);


--
-- Name: idx_api_keys_network; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_api_keys_network ON public.api_keys USING btree (network_id);


--
-- Name: idx_bindings_interface; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_bindings_interface ON public.bindings USING btree (interface_id);


--
-- Name: idx_bindings_network; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_bindings_network ON public.bindings USING btree (network_id);


--
-- Name: idx_bindings_port; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_bindings_port ON public.bindings USING btree (port_id);


--
-- Name: idx_bindings_service; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_bindings_service ON public.bindings USING btree (service_id);


--
-- Name: idx_daemon_host_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_daemon_host_id ON public.daemons USING btree (host_id);


--
-- Name: idx_daemons_network; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_daemons_network ON public.daemons USING btree (network_id);


--
-- Name: idx_discovery_daemon; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_discovery_daemon ON public.discovery USING btree (daemon_id);


--
-- Name: idx_discovery_network; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_discovery_network ON public.discovery USING btree (network_id);


--
-- Name: idx_entity_tags_entity; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_entity_tags_entity ON public.entity_tags USING btree (entity_id, entity_type);


--
-- Name: idx_entity_tags_tag_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_entity_tags_tag_id ON public.entity_tags USING btree (tag_id);


--
-- Name: idx_group_bindings_binding; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_group_bindings_binding ON public.group_bindings USING btree (binding_id);


--
-- Name: idx_group_bindings_group; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_group_bindings_group ON public.group_bindings USING btree (group_id);


--
-- Name: idx_groups_network; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_groups_network ON public.groups USING btree (network_id);


--
-- Name: idx_hosts_network; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_hosts_network ON public.hosts USING btree (network_id);


--
-- Name: idx_interfaces_host; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_interfaces_host ON public.interfaces USING btree (host_id);


--
-- Name: idx_interfaces_host_mac; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_interfaces_host_mac ON public.interfaces USING btree (host_id, mac_address) WHERE (mac_address IS NOT NULL);


--
-- Name: idx_interfaces_network; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_interfaces_network ON public.interfaces USING btree (network_id);


--
-- Name: idx_interfaces_subnet; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_interfaces_subnet ON public.interfaces USING btree (subnet_id);


--
-- Name: idx_invites_expires_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_invites_expires_at ON public.invites USING btree (expires_at);


--
-- Name: idx_invites_organization; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_invites_organization ON public.invites USING btree (organization_id);


--
-- Name: idx_networks_owner_organization; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_networks_owner_organization ON public.networks USING btree (organization_id);


--
-- Name: idx_organizations_stripe_customer; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_organizations_stripe_customer ON public.organizations USING btree (stripe_customer_id);


--
-- Name: idx_ports_host; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_ports_host ON public.ports USING btree (host_id);


--
-- Name: idx_ports_network; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_ports_network ON public.ports USING btree (network_id);


--
-- Name: idx_ports_number; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_ports_number ON public.ports USING btree (port_number);


--
-- Name: idx_services_host_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_services_host_id ON public.services USING btree (host_id);


--
-- Name: idx_services_host_position; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_services_host_position ON public.services USING btree (host_id, "position");


--
-- Name: idx_services_network; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_services_network ON public.services USING btree (network_id);


--
-- Name: idx_shares_enabled; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_shares_enabled ON public.shares USING btree (is_enabled) WHERE (is_enabled = true);


--
-- Name: idx_shares_network; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_shares_network ON public.shares USING btree (network_id);


--
-- Name: idx_shares_topology; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_shares_topology ON public.shares USING btree (topology_id);


--
-- Name: idx_subnets_network; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_subnets_network ON public.subnets USING btree (network_id);


--
-- Name: idx_tags_org_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_tags_org_name ON public.tags USING btree (organization_id, name);


--
-- Name: idx_tags_organization; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_tags_organization ON public.tags USING btree (organization_id);


--
-- Name: idx_topologies_network; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_topologies_network ON public.topologies USING btree (network_id);


--
-- Name: idx_user_api_key_network_access_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_user_api_key_network_access_key ON public.user_api_key_network_access USING btree (api_key_id);


--
-- Name: idx_user_api_key_network_access_network; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_user_api_key_network_access_network ON public.user_api_key_network_access USING btree (network_id);


--
-- Name: idx_user_api_keys_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_user_api_keys_key ON public.user_api_keys USING btree (key);


--
-- Name: idx_user_api_keys_org; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_user_api_keys_org ON public.user_api_keys USING btree (organization_id);


--
-- Name: idx_user_api_keys_user; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_user_api_keys_user ON public.user_api_keys USING btree (user_id);


--
-- Name: idx_user_network_access_network; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_user_network_access_network ON public.user_network_access USING btree (network_id);


--
-- Name: idx_user_network_access_user; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_user_network_access_user ON public.user_network_access USING btree (user_id);


--
-- Name: idx_users_email_lower; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_users_email_lower ON public.users USING btree (lower(email));


--
-- Name: idx_users_oidc_provider_subject; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_users_oidc_provider_subject ON public.users USING btree (oidc_provider, oidc_subject) WHERE ((oidc_provider IS NOT NULL) AND (oidc_subject IS NOT NULL));


--
-- Name: idx_users_organization; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_users_organization ON public.users USING btree (organization_id);


--
-- Name: api_keys api_keys_network_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.api_keys
    ADD CONSTRAINT api_keys_network_id_fkey FOREIGN KEY (network_id) REFERENCES public.networks(id) ON DELETE CASCADE;


--
-- Name: bindings bindings_interface_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bindings
    ADD CONSTRAINT bindings_interface_id_fkey FOREIGN KEY (interface_id) REFERENCES public.interfaces(id) ON DELETE CASCADE;


--
-- Name: bindings bindings_network_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bindings
    ADD CONSTRAINT bindings_network_id_fkey FOREIGN KEY (network_id) REFERENCES public.networks(id) ON DELETE CASCADE;


--
-- Name: bindings bindings_port_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bindings
    ADD CONSTRAINT bindings_port_id_fkey FOREIGN KEY (port_id) REFERENCES public.ports(id) ON DELETE CASCADE;


--
-- Name: bindings bindings_service_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bindings
    ADD CONSTRAINT bindings_service_id_fkey FOREIGN KEY (service_id) REFERENCES public.services(id) ON DELETE CASCADE;


--
-- Name: daemons daemons_network_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.daemons
    ADD CONSTRAINT daemons_network_id_fkey FOREIGN KEY (network_id) REFERENCES public.networks(id) ON DELETE CASCADE;


--
-- Name: daemons daemons_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.daemons
    ADD CONSTRAINT daemons_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: discovery discovery_daemon_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discovery
    ADD CONSTRAINT discovery_daemon_id_fkey FOREIGN KEY (daemon_id) REFERENCES public.daemons(id) ON DELETE CASCADE;


--
-- Name: discovery discovery_network_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discovery
    ADD CONSTRAINT discovery_network_id_fkey FOREIGN KEY (network_id) REFERENCES public.networks(id) ON DELETE CASCADE;


--
-- Name: entity_tags entity_tags_tag_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.entity_tags
    ADD CONSTRAINT entity_tags_tag_id_fkey FOREIGN KEY (tag_id) REFERENCES public.tags(id) ON DELETE CASCADE;


--
-- Name: group_bindings group_bindings_binding_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_bindings
    ADD CONSTRAINT group_bindings_binding_id_fkey FOREIGN KEY (binding_id) REFERENCES public.bindings(id) ON DELETE CASCADE;


--
-- Name: group_bindings group_bindings_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_bindings
    ADD CONSTRAINT group_bindings_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.groups(id) ON DELETE CASCADE;


--
-- Name: groups groups_network_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.groups
    ADD CONSTRAINT groups_network_id_fkey FOREIGN KEY (network_id) REFERENCES public.networks(id) ON DELETE CASCADE;


--
-- Name: hosts hosts_network_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hosts
    ADD CONSTRAINT hosts_network_id_fkey FOREIGN KEY (network_id) REFERENCES public.networks(id) ON DELETE CASCADE;


--
-- Name: interfaces interfaces_host_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.interfaces
    ADD CONSTRAINT interfaces_host_id_fkey FOREIGN KEY (host_id) REFERENCES public.hosts(id) ON DELETE CASCADE;


--
-- Name: interfaces interfaces_network_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.interfaces
    ADD CONSTRAINT interfaces_network_id_fkey FOREIGN KEY (network_id) REFERENCES public.networks(id) ON DELETE CASCADE;


--
-- Name: interfaces interfaces_subnet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.interfaces
    ADD CONSTRAINT interfaces_subnet_id_fkey FOREIGN KEY (subnet_id) REFERENCES public.subnets(id) ON DELETE CASCADE;


--
-- Name: invites invites_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invites
    ADD CONSTRAINT invites_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: invites invites_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invites
    ADD CONSTRAINT invites_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: networks organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.networks
    ADD CONSTRAINT organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: ports ports_host_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ports
    ADD CONSTRAINT ports_host_id_fkey FOREIGN KEY (host_id) REFERENCES public.hosts(id) ON DELETE CASCADE;


--
-- Name: ports ports_network_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ports
    ADD CONSTRAINT ports_network_id_fkey FOREIGN KEY (network_id) REFERENCES public.networks(id) ON DELETE CASCADE;


--
-- Name: services services_host_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_host_id_fkey FOREIGN KEY (host_id) REFERENCES public.hosts(id) ON DELETE CASCADE;


--
-- Name: services services_network_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_network_id_fkey FOREIGN KEY (network_id) REFERENCES public.networks(id) ON DELETE CASCADE;


--
-- Name: shares shares_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shares
    ADD CONSTRAINT shares_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: shares shares_network_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shares
    ADD CONSTRAINT shares_network_id_fkey FOREIGN KEY (network_id) REFERENCES public.networks(id) ON DELETE CASCADE;


--
-- Name: shares shares_topology_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shares
    ADD CONSTRAINT shares_topology_id_fkey FOREIGN KEY (topology_id) REFERENCES public.topologies(id) ON DELETE CASCADE;


--
-- Name: subnets subnets_network_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subnets
    ADD CONSTRAINT subnets_network_id_fkey FOREIGN KEY (network_id) REFERENCES public.networks(id) ON DELETE CASCADE;


--
-- Name: tags tags_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: topologies topologies_network_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.topologies
    ADD CONSTRAINT topologies_network_id_fkey FOREIGN KEY (network_id) REFERENCES public.networks(id) ON DELETE CASCADE;


--
-- Name: user_api_key_network_access user_api_key_network_access_api_key_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_api_key_network_access
    ADD CONSTRAINT user_api_key_network_access_api_key_id_fkey FOREIGN KEY (api_key_id) REFERENCES public.user_api_keys(id) ON DELETE CASCADE;


--
-- Name: user_api_key_network_access user_api_key_network_access_network_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_api_key_network_access
    ADD CONSTRAINT user_api_key_network_access_network_id_fkey FOREIGN KEY (network_id) REFERENCES public.networks(id) ON DELETE CASCADE;


--
-- Name: user_api_keys user_api_keys_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_api_keys
    ADD CONSTRAINT user_api_keys_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: user_api_keys user_api_keys_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_api_keys
    ADD CONSTRAINT user_api_keys_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: user_network_access user_network_access_network_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_network_access
    ADD CONSTRAINT user_network_access_network_id_fkey FOREIGN KEY (network_id) REFERENCES public.networks(id) ON DELETE CASCADE;


--
-- Name: user_network_access user_network_access_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_network_access
    ADD CONSTRAINT user_network_access_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: users users_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict 9eKUU15ihr6xigFXjWtxeUAaYUHfqMzujCcdXkhmB706ydGnQKiq1Mxi6PceWEo

