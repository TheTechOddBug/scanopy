--
-- PostgreSQL database dump
--

\restrict eonVCHCW8Bu2udMiluekm1BbRRsc0I7JMNaGOV3QIfgZ07fLdYCdkXaQ9hfF9au

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
20251006215000	users	2026-01-10 16:43:52.598133+00	t	\\x4f13ce14ff67ef0b7145987c7b22b588745bf9fbb7b673450c26a0f2f9a36ef8ca980e456c8d77cfb1b2d7a4577a64d7	3504024
20251006215100	networks	2026-01-10 16:43:52.602686+00	t	\\xeaa5a07a262709f64f0c59f31e25519580c79e2d1a523ce72736848946a34b17dd9adc7498eaf90551af6b7ec6d4e0e3	4730794
20251006215151	create hosts	2026-01-10 16:43:52.607797+00	t	\\x6ec7487074c0724932d21df4cf1ed66645313cf62c159a7179e39cbc261bcb81a24f7933a0e3cf58504f2a90fc5c1962	3893160
20251006215155	create subnets	2026-01-10 16:43:52.612053+00	t	\\xefb5b25742bd5f4489b67351d9f2494a95f307428c911fd8c5f475bfb03926347bdc269bbd048d2ddb06336945b27926	3735816
20251006215201	create groups	2026-01-10 16:43:52.616142+00	t	\\x0a7032bf4d33a0baf020e905da865cde240e2a09dda2f62aa535b2c5d4b26b20be30a3286f1b5192bd94cd4a5dbb5bcd	4050042
20251006215204	create daemons	2026-01-10 16:43:52.620524+00	t	\\xcfea93403b1f9cf9aac374711d4ac72d8a223e3c38a1d2a06d9edb5f94e8a557debac3668271f8176368eadc5105349f	4780096
20251006215212	create services	2026-01-10 16:43:52.62567+00	t	\\xd5b07f82fc7c9da2782a364d46078d7d16b5c08df70cfbf02edcfe9b1b24ab6024ad159292aeea455f15cfd1f4740c1d	4829958
20251029193448	user-auth	2026-01-10 16:43:52.63083+00	t	\\xfde8161a8db89d51eeade7517d90a41d560f19645620f2298f78f116219a09728b18e91251ae31e46a47f6942d5a9032	5961632
20251030044828	daemon api	2026-01-10 16:43:52.637087+00	t	\\x181eb3541f51ef5b038b2064660370775d1b364547a214a20dde9c9d4bb95a1c273cd4525ef29e61fa65a3eb4fee0400	1485003
20251030170438	host-hide	2026-01-10 16:43:52.638877+00	t	\\x87c6fda7f8456bf610a78e8e98803158caa0e12857c5bab466a5bb0004d41b449004a68e728ca13f17e051f662a15454	1175866
20251102224919	create discovery	2026-01-10 16:43:52.640359+00	t	\\xb32a04abb891aba48f92a059fae7341442355ca8e4af5d109e28e2a4f79ee8e11b2a8f40453b7f6725c2dd6487f26573	10913197
20251106235621	normalize-daemon-cols	2026-01-10 16:43:52.651581+00	t	\\x5b137118d506e2708097c432358bf909265b3cf3bacd662b02e2c81ba589a9e0100631c7801cffd9c57bb10a6674fb3b	1900889
20251107034459	api keys	2026-01-10 16:43:52.653803+00	t	\\x3133ec043c0c6e25b6e55f7da84cae52b2a72488116938a2c669c8512c2efe72a74029912bcba1f2a2a0a8b59ef01dde	8231891
20251107222650	oidc-auth	2026-01-10 16:43:52.66234+00	t	\\xd349750e0298718cbcd98eaff6e152b3fb45c3d9d62d06eedeb26c75452e9ce1af65c3e52c9f2de4bd532939c2f31096	26207685
20251110181948	orgs-billing	2026-01-10 16:43:52.688995+00	t	\\x5bbea7a2dfc9d00213bd66b473289ddd66694eff8a4f3eaab937c985b64c5f8c3ad2d64e960afbb03f335ac6766687aa	10726508
20251113223656	group-enhancements	2026-01-10 16:43:52.700049+00	t	\\xbe0699486d85df2bd3edc1f0bf4f1f096d5b6c5070361702c4d203ec2bb640811be88bb1979cfe51b40805ad84d1de65	1094189
20251117032720	daemon-mode	2026-01-10 16:43:52.701454+00	t	\\xdd0d899c24b73d70e9970e54b2c748d6b6b55c856ca0f8590fe990da49cc46c700b1ce13f57ff65abd6711f4bd8a6481	1131994
20251118143058	set-default-plan	2026-01-10 16:43:52.702886+00	t	\\xd19142607aef84aac7cfb97d60d29bda764d26f513f2c72306734c03cec2651d23eee3ce6cacfd36ca52dbddc462f917	1202631
20251118225043	save-topology	2026-01-10 16:43:52.704378+00	t	\\x011a594740c69d8d0f8b0149d49d1b53cfbf948b7866ebd84403394139cb66a44277803462846b06e762577adc3e61a3	8921478
20251123232748	network-permissions	2026-01-10 16:43:52.71362+00	t	\\x161be7ae5721c06523d6488606f1a7b1f096193efa1183ecdd1c2c9a4a9f4cad4884e939018917314aaf261d9a3f97ae	2783047
20251125001342	billing-updates	2026-01-10 16:43:52.716688+00	t	\\xa235d153d95aeb676e3310a52ccb69dfbd7ca36bba975d5bbca165ceeec7196da12119f23597ea5276c364f90f23db1e	903417
20251128035448	org-onboarding-status	2026-01-10 16:43:52.717871+00	t	\\x1d7a7e9bf23b5078250f31934d1bc47bbaf463ace887e7746af30946e843de41badfc2b213ed64912a18e07b297663d8	1541027
20251129180942	nfs-consolidate	2026-01-10 16:43:52.719708+00	t	\\xb38f41d30699a475c2b967f8e43156f3b49bb10341bddbde01d9fb5ba805f6724685e27e53f7e49b6c8b59e29c74f98e	1187227
20251206052641	discovery-progress	2026-01-10 16:43:52.721178+00	t	\\x9d433b7b8c58d0d5437a104497e5e214febb2d1441a3ad7c28512e7497ed14fb9458e0d4ff786962a59954cb30da1447	1613232
20251206202200	plan-fix	2026-01-10 16:43:52.723079+00	t	\\x242f6699dbf485cf59a8d1b8cd9d7c43aeef635a9316be815a47e15238c5e4af88efaa0daf885be03572948dc0c9edac	987194
20251207061341	daemon-url	2026-01-10 16:43:52.724362+00	t	\\x01172455c4f2d0d57371d18ef66d2ab3b7a8525067ef8a86945c616982e6ce06f5ea1e1560a8f20dadcd5be2223e6df1	2336663
20251210045929	tags	2026-01-10 16:43:52.727018+00	t	\\xe3dde83d39f8552b5afcdc1493cddfeffe077751bf55472032bc8b35fc8fc2a2caa3b55b4c2354ace7de03c3977982db	9254482
20251210175035	terms	2026-01-10 16:43:52.737054+00	t	\\xe47f0cf7aba1bffa10798bede953da69fd4bfaebf9c75c76226507c558a3595c6bfc6ac8920d11398dbdf3b762769992	948715
20251213025048	hash-keys	2026-01-10 16:43:52.738319+00	t	\\xfc7cbb8ce61f0c225322297f7459dcbe362242b9001c06cb874b7f739cea7ae888d8f0cfaed6623bcbcb9ec54c8cd18b	9698219
20251214050638	scanopy	2026-01-10 16:43:52.74833+00	t	\\x0108bb39832305f024126211710689adc48d973ff66e5e59ff49468389b75c1ff95d1fbbb7bdb50e33ec1333a1f29ea6	1468182
20251215215724	topo-scanopy-fix	2026-01-10 16:43:52.750111+00	t	\\xed88a4b71b3c9b61d46322b5053362e5a25a9293cd3c420c9df9fcaeb3441254122b8a18f58c297f535c842b8a8b0a38	817496
20251217153736	category rename	2026-01-10 16:43:52.751251+00	t	\\x03af7ec905e11a77e25038a3c272645da96014da7c50c585a25cea3f9a7579faba3ff45114a5e589d144c9550ba42421	1735871
20251218053111	invite-persistence	2026-01-10 16:43:52.753301+00	t	\\x21d12f48b964acfd600f88e70ceb14abd9cf2a8a10db2eae2a6d8f44cf7d20749f93293631e6123e92b7c3c1793877c2	5290218
20251219211216	create shares	2026-01-10 16:43:52.758917+00	t	\\x036485debd3536f9e58ead728f461b925585911acf565970bf3b2ab295b12a2865606d6a56d334c5641dcd42adeb3d68	6711882
20251220170928	permissions-cleanup	2026-01-10 16:43:52.766004+00	t	\\x632f7b6702b494301e0d36fd3b900686b1a7f9936aef8c084b5880f1152b8256a125566e2b5ac40216eaadd3c4c64a03	1491966
20251220180000	commercial-to-community	2026-01-10 16:43:52.76782+00	t	\\x26fc298486c225f2f01271d611418377c403183ae51daf32fef104ec07c027f2017d138910c4fbfb5f49819a5f4194d6	844808
20251221010000	cleanup subnet type	2026-01-10 16:43:52.768981+00	t	\\xb521121f3fd3a10c0de816977ac2a2ffb6118f34f8474ffb9058722abc0dc4cf5cbec83bc6ee49e79a68e6b715087f40	1009295
20251221020000	remove host target	2026-01-10 16:43:52.770309+00	t	\\x77b5f8872705676ca81a5704bd1eaee90b9a52b404bdaa27a23da2ffd4858d3e131680926a5a00ad2a0d7a24ba229046	1008733
20251221030000	user network access	2026-01-10 16:43:52.771622+00	t	\\x5c23f5bb6b0b8ca699a17eee6730c4197a006ca21fecc79136a5e5697b9211a81b4cd08ceda70dace6a26408d021ff3a	6851272
20251221040000	interfaces table	2026-01-10 16:43:52.778819+00	t	\\xf7977b6f1e7e5108c614397d03a38c9bd9243fdc422575ec29610366a0c88f443de2132185878d8e291f06a50a8c3244	9652092
20251221050000	ports table	2026-01-10 16:43:52.788805+00	t	\\xdf72f9306b405be7be62c39003ef38408115e740b120f24e8c78b8e136574fff7965c52023b3bc476899613fa5f4fe35	9794538
20251221060000	bindings table	2026-01-10 16:43:52.79893+00	t	\\x933648a724bd179c7f47305e4080db85342d48712cde39374f0f88cde9d7eba8fe5fafba360937331e2a8178dec420c4	11638220
20251221070000	group bindings	2026-01-10 16:43:52.810883+00	t	\\x697475802f6c42e38deee6596f4ba786b09f7b7cd91742fbc5696dd0f9b3ddfce90dd905153f2b1a9e82f959f5a88302	7183513
20251222020000	tag cascade delete	2026-01-10 16:43:52.818422+00	t	\\xabfb48c0da8522f5c8ea6d482eb5a5f4562ed41f6160a5915f0fd477c7dd0517aa84760ef99ab3a5db3e0f21b0c69b5f	1277665
20251223232524	network remove default	2026-01-10 16:43:52.820093+00	t	\\x7099fe4e52405e46269d7ce364050da930b481e72484ad3c4772fd2911d2d505476d659fa9f400c63bc287512d033e18	1090456
20251225100000	color enum	2026-01-10 16:43:52.821521+00	t	\\x62cecd9d79a49835a3bea68a7959ab62aa0c1aaa7e2940dec6a7f8a714362df3649f0c1f9313672d9268295ed5a1cfa9	1409081
20251227010000	topology snapshot migration	2026-01-10 16:43:52.823214+00	t	\\xc042591d254869c0e79c8b52a9ede680fd26f094e2c385f5f017e115f5e3f31ad155f4885d095344f2642ebb70755d54	4466600
20251228010000	user api keys	2026-01-10 16:43:52.828014+00	t	\\xa41adb558a5b9d94a4e17af3f16839b83f7da072dbeac9251b12d8a84c7bec6df008009acf246468712a975bb36bb5f5	12205781
20251230160000	daemon version and maintainer	2026-01-10 16:43:52.840561+00	t	\\xafed3d9f00adb8c1b0896fb663af801926c218472a0a197f90ecdaa13305a78846a9e15af0043ec010328ba533fca68f	3071635
20260103000000	service position	2026-01-10 16:43:52.843971+00	t	\\x19d00e8c8b300d1c74d721931f4d771ec7bc4e06db0d6a78126e00785586fdc4bcff5b832eeae2fce0cb8d01e12a7fb5	2590698
20260106000000	interface mac index	2026-01-10 16:43:52.847522+00	t	\\xa26248372a1e31af46a9c6fbdaef178982229e2ceeb90cc6a289d5764f87a38747294b3adf5f21276b5d171e42bdb6ac	1909536
20260106204402	entity tags junction	2026-01-10 16:43:52.849765+00	t	\\xf73c604f9f0b8db065d990a861684b0dbd62c3ef9bead120c68431c933774de56491a53f021e79f09801680152f5a08a	13497012
20260108033856	fix entity tags json format	2026-01-10 16:43:52.863577+00	t	\\x197eaa063d4f96dd0e897ad8fd96cc1ba9a54dda40a93a5c12eac14597e4dea4c806dd0a527736fb5807b7a8870d9916	1828504
\.


--
-- Data for Name: api_keys; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.api_keys (id, key, network_id, name, created_at, updated_at, last_used, expires_at, is_enabled) FROM stdin;
f3aee878-45d1-4a32-8a77-4ac197f0e24f	db556784cca39dee4c33e976b6021fd92c58456402e96c9bdc5ba2336b6e94a3	461c7231-c9a7-4a98-907e-5df83c7cf84d	Integrated Daemon API Key	2026-01-10 16:43:58.289472+00	2026-01-10 16:43:58.289472+00	2026-01-10 16:45:57.58711+00	\N	t
\.


--
-- Data for Name: bindings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bindings (id, network_id, service_id, binding_type, interface_id, port_id, created_at, updated_at) FROM stdin;
46602e52-55d6-4be1-b962-a314af80178b	461c7231-c9a7-4a98-907e-5df83c7cf84d	80c0ced7-ad40-4db7-9c9f-451ca8a99350	Port	8a9e8dcf-a7e2-49b9-b112-2d38a8e945c8	76a8e6fb-6bc1-488b-8f28-d2bca599720c	2026-01-10 16:43:58.428218+00	2026-01-10 16:43:58.428218+00
af394cd8-7e1b-41f7-9b7e-10859202623f	461c7231-c9a7-4a98-907e-5df83c7cf84d	285c8d22-2c94-49da-8889-a99a420ba534	Port	50b7e405-0281-4dd8-bba6-af2a2b334c04	b83bc21d-d9dd-4e87-9190-f8d897c9a877	2026-01-10 16:44:35.780354+00	2026-01-10 16:44:35.780354+00
408aa80a-dd1e-4efa-9c01-9ba7ae1cc9f1	461c7231-c9a7-4a98-907e-5df83c7cf84d	63431e53-2bbe-4c25-8b13-a73cb2618b49	Port	23128cd1-aba2-4a69-ba44-1b3b12c4d5f3	617125ec-544b-4481-acf8-b0274e1e4d6f	2026-01-10 16:44:37.411752+00	2026-01-10 16:44:37.411752+00
7a3c3f8e-2b62-48d2-a5fe-b1850783cd11	461c7231-c9a7-4a98-907e-5df83c7cf84d	9a146cde-ca31-4f62-bbc8-66be2970d6c0	Port	cb68599e-a091-4a74-872a-25839896684b	e69075ff-180b-445a-a58a-d7299142bf4a	2026-01-10 16:45:05.693184+00	2026-01-10 16:45:05.693184+00
df4fea6c-04b4-4742-bbac-1c37628fd8c4	461c7231-c9a7-4a98-907e-5df83c7cf84d	9a146cde-ca31-4f62-bbc8-66be2970d6c0	Port	cb68599e-a091-4a74-872a-25839896684b	1a6554de-4f17-40c7-baf0-04287db0bca0	2026-01-10 16:45:05.693185+00	2026-01-10 16:45:05.693185+00
0c197a53-b909-43cf-89d9-4a297162a623	461c7231-c9a7-4a98-907e-5df83c7cf84d	1739299b-a2ff-4baf-ac60-27f27f54a144	Port	95610cab-c538-4707-962e-ccbe0f2ff6b6	6ade283c-566e-4e4b-b7a8-afa14e2321b4	2026-01-10 16:45:13.329557+00	2026-01-10 16:45:13.329557+00
8b52d810-2bc7-4de3-9a5d-f67135df6810	461c7231-c9a7-4a98-907e-5df83c7cf84d	40157f70-5487-4141-a828-98e21f2c05ab	Port	95610cab-c538-4707-962e-ccbe0f2ff6b6	58c02e19-f3e6-49ec-8670-dc3e2b90d47e	2026-01-10 16:45:18.048612+00	2026-01-10 16:45:18.048612+00
b3f002e0-94a8-439a-a542-252ce7713158	461c7231-c9a7-4a98-907e-5df83c7cf84d	e410f013-fad9-459a-bf41-a2fcb0f0da57	Port	95610cab-c538-4707-962e-ccbe0f2ff6b6	4cd31861-8394-4237-898b-54eb19a8d5aa	2026-01-10 16:45:27.214709+00	2026-01-10 16:45:27.214709+00
3ad8706c-bc50-49e0-993a-b031b7e326a6	461c7231-c9a7-4a98-907e-5df83c7cf84d	b95f6674-63ca-421c-a58f-cbc68577e6a8	Port	95610cab-c538-4707-962e-ccbe0f2ff6b6	c1121f55-11c1-4dcd-9c7c-6adb55f45b19	2026-01-10 16:45:27.214906+00	2026-01-10 16:45:27.214906+00
\.


--
-- Data for Name: daemons; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.daemons (id, network_id, host_id, created_at, last_seen, capabilities, updated_at, mode, url, name, version, user_id) FROM stdin;
12dbd539-15ef-419c-aae7-da90f3a4bbce	461c7231-c9a7-4a98-907e-5df83c7cf84d	ce156291-844a-4340-b721-b91fadc33497	2026-01-10 16:43:58.394965+00	2026-01-10 16:45:40.78641+00	{"has_docker_socket": false, "interfaced_subnet_ids": ["3c12df74-1de4-4681-b34f-a998fe3f7249"]}	2026-01-10 16:43:58.394965+00	"Push"	http://172.25.0.4:60073	scanopy-daemon	0.13.4	ae118265-c62e-4ef5-a94a-bcc7a3d542e0
\.


--
-- Data for Name: discovery; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.discovery (id, network_id, daemon_id, run_type, discovery_type, name, created_at, updated_at) FROM stdin;
060ec5ce-6496-4427-9559-9f08158ea6e0	461c7231-c9a7-4a98-907e-5df83c7cf84d	12dbd539-15ef-419c-aae7-da90f3a4bbce	{"type": "Scheduled", "enabled": true, "last_run": null, "cron_schedule": "0 0 0 * * *"}	{"type": "SelfReport", "host_id": "ce156291-844a-4340-b721-b91fadc33497"}	Self Report	2026-01-10 16:43:58.402789+00	2026-01-10 16:43:58.402789+00
e1ea4375-35fa-44bc-a64f-975a5fcb684e	461c7231-c9a7-4a98-907e-5df83c7cf84d	12dbd539-15ef-419c-aae7-da90f3a4bbce	{"type": "Scheduled", "enabled": true, "last_run": null, "cron_schedule": "0 0 0 * * *"}	{"type": "Network", "subnet_ids": null, "host_naming_fallback": "BestService"}	Network Discovery	2026-01-10 16:43:58.41096+00	2026-01-10 16:43:58.41096+00
e8469b22-a178-47b6-8fd9-89883f0691f5	461c7231-c9a7-4a98-907e-5df83c7cf84d	12dbd539-15ef-419c-aae7-da90f3a4bbce	{"type": "Historical", "results": {"error": null, "phase": "Complete", "progress": 100, "daemon_id": "12dbd539-15ef-419c-aae7-da90f3a4bbce", "network_id": "461c7231-c9a7-4a98-907e-5df83c7cf84d", "session_id": "f743a411-2eb9-4a35-a83d-33eb9474c8cd", "started_at": "2026-01-10T16:43:58.410409949Z", "finished_at": "2026-01-10T16:43:58.473080078Z", "discovery_type": {"type": "SelfReport", "host_id": "ce156291-844a-4340-b721-b91fadc33497"}}}	{"type": "SelfReport", "host_id": "ce156291-844a-4340-b721-b91fadc33497"}	Self Report	2026-01-10 16:43:58.410409+00	2026-01-10 16:43:58.533449+00
d7bd5525-70c8-4495-bb1f-4467609f82a5	461c7231-c9a7-4a98-907e-5df83c7cf84d	12dbd539-15ef-419c-aae7-da90f3a4bbce	{"type": "Historical", "results": {"error": null, "phase": "Complete", "progress": 100, "daemon_id": "12dbd539-15ef-419c-aae7-da90f3a4bbce", "network_id": "461c7231-c9a7-4a98-907e-5df83c7cf84d", "session_id": "661ced74-7570-42b5-b460-4c6628cf0767", "started_at": "2026-01-10T16:43:58.554053278Z", "finished_at": "2026-01-10T16:45:57.585814893Z", "discovery_type": {"type": "Network", "subnet_ids": null, "host_naming_fallback": "BestService"}}}	{"type": "Network", "subnet_ids": null, "host_naming_fallback": "BestService"}	Network Discovery	2026-01-10 16:43:58.554053+00	2026-01-10 16:45:57.588963+00
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
b7dfc692-5e49-4d1e-97ec-9675972b1e29	461c7231-c9a7-4a98-907e-5df83c7cf84d		\N	2026-01-10 16:45:57.603702+00	2026-01-10 16:45:57.603702+00	{"type": "Manual"}	Yellow	"SmoothStep"	RequestPath
\.


--
-- Data for Name: hosts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.hosts (id, network_id, name, hostname, description, source, virtualization, created_at, updated_at, hidden) FROM stdin;
ce156291-844a-4340-b721-b91fadc33497	461c7231-c9a7-4a98-907e-5df83c7cf84d	scanopy-daemon	662426eb4860	\N	{"type": "Discovery", "metadata": [{"date": "2026-01-10T16:43:58.428202342Z", "type": "SelfReport", "host_id": "ce156291-844a-4340-b721-b91fadc33497", "daemon_id": "12dbd539-15ef-419c-aae7-da90f3a4bbce"}]}	null	2026-01-10 16:43:58.390112+00	2026-01-10 16:43:58.390112+00	f
7b17ccaf-7a84-4c24-9fde-c3d53d520569	461c7231-c9a7-4a98-907e-5df83c7cf84d	scanopy-postgres-dev-1.scanopy_scanopy-dev	scanopy-postgres-dev-1.scanopy_scanopy-dev	\N	{"type": "Discovery", "metadata": [{"date": "2026-01-10T16:44:20.502694946Z", "type": "Network", "daemon_id": "12dbd539-15ef-419c-aae7-da90f3a4bbce", "subnet_ids": null, "host_naming_fallback": "BestService"}]}	null	2026-01-10 16:44:20.502695+00	2026-01-10 16:44:20.502695+00	f
59f07f06-13ea-475b-b50f-e03c93be493e	461c7231-c9a7-4a98-907e-5df83c7cf84d	scanopy-server-1.scanopy_scanopy-dev	scanopy-server-1.scanopy_scanopy-dev	\N	{"type": "Discovery", "metadata": [{"date": "2026-01-10T16:44:35.896715169Z", "type": "Network", "daemon_id": "12dbd539-15ef-419c-aae7-da90f3a4bbce", "subnet_ids": null, "host_naming_fallback": "BestService"}]}	null	2026-01-10 16:44:35.896716+00	2026-01-10 16:44:35.896716+00	f
ef6924e3-b81d-4411-be87-5ae76faf5669	461c7231-c9a7-4a98-907e-5df83c7cf84d	homeassistant-discovery.scanopy_scanopy-dev	homeassistant-discovery.scanopy_scanopy-dev	\N	{"type": "Discovery", "metadata": [{"date": "2026-01-10T16:44:50.762798135Z", "type": "Network", "daemon_id": "12dbd539-15ef-419c-aae7-da90f3a4bbce", "subnet_ids": null, "host_naming_fallback": "BestService"}]}	null	2026-01-10 16:44:50.762799+00	2026-01-10 16:44:50.762799+00	f
8e81205a-9b33-456c-8951-5f742d48e0fe	461c7231-c9a7-4a98-907e-5df83c7cf84d	runnervmi13qx	runnervmi13qx	\N	{"type": "Discovery", "metadata": [{"date": "2026-01-10T16:45:11.750115576Z", "type": "Network", "daemon_id": "12dbd539-15ef-419c-aae7-da90f3a4bbce", "subnet_ids": null, "host_naming_fallback": "BestService"}]}	null	2026-01-10 16:45:11.750116+00	2026-01-10 16:45:11.750116+00	f
\.


--
-- Data for Name: interfaces; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.interfaces (id, network_id, host_id, subnet_id, ip_address, mac_address, name, "position", created_at, updated_at) FROM stdin;
8a9e8dcf-a7e2-49b9-b112-2d38a8e945c8	461c7231-c9a7-4a98-907e-5df83c7cf84d	ce156291-844a-4340-b721-b91fadc33497	3c12df74-1de4-4681-b34f-a998fe3f7249	172.25.0.4	c2:9b:a6:d2:87:81	eth0	0	2026-01-10 16:43:58.410749+00	2026-01-10 16:43:58.410749+00
50b7e405-0281-4dd8-bba6-af2a2b334c04	461c7231-c9a7-4a98-907e-5df83c7cf84d	7b17ccaf-7a84-4c24-9fde-c3d53d520569	3c12df74-1de4-4681-b34f-a998fe3f7249	172.25.0.6	36:bb:68:d4:dd:8e	\N	0	2026-01-10 16:44:20.502665+00	2026-01-10 16:44:20.502665+00
23128cd1-aba2-4a69-ba44-1b3b12c4d5f3	461c7231-c9a7-4a98-907e-5df83c7cf84d	59f07f06-13ea-475b-b50f-e03c93be493e	3c12df74-1de4-4681-b34f-a998fe3f7249	172.25.0.3	0e:98:a2:bc:f1:40	\N	0	2026-01-10 16:44:35.896684+00	2026-01-10 16:44:35.896684+00
cb68599e-a091-4a74-872a-25839896684b	461c7231-c9a7-4a98-907e-5df83c7cf84d	ef6924e3-b81d-4411-be87-5ae76faf5669	3c12df74-1de4-4681-b34f-a998fe3f7249	172.25.0.5	82:41:30:4c:72:15	\N	0	2026-01-10 16:44:50.762775+00	2026-01-10 16:44:50.762775+00
95610cab-c538-4707-962e-ccbe0f2ff6b6	461c7231-c9a7-4a98-907e-5df83c7cf84d	8e81205a-9b33-456c-8951-5f742d48e0fe	3c12df74-1de4-4681-b34f-a998fe3f7249	172.25.0.1	d2:55:e8:7f:cf:6f	\N	0	2026-01-10 16:45:11.750086+00	2026-01-10 16:45:11.750086+00
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
461c7231-c9a7-4a98-907e-5df83c7cf84d	My Network	2026-01-10 16:43:58.226927+00	2026-01-10 16:43:58.226927+00	94bd3438-e3cc-484d-a259-9339471b07ad
\.


--
-- Data for Name: organizations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.organizations (id, name, stripe_customer_id, plan, plan_status, created_at, updated_at, onboarding) FROM stdin;
94bd3438-e3cc-484d-a259-9339471b07ad	My Organization	\N	{"rate": "Month", "type": "Community", "base_cents": 0, "trial_days": 0}	active	2026-01-10 16:43:58.049874+00	2026-01-10 16:43:58.049874+00	["OnboardingModalCompleted", "FirstDaemonRegistered", "FirstApiKeyCreated"]
\.


--
-- Data for Name: ports; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ports (id, network_id, host_id, port_number, protocol, port_type, created_at, updated_at) FROM stdin;
76a8e6fb-6bc1-488b-8f28-d2bca599720c	461c7231-c9a7-4a98-907e-5df83c7cf84d	ce156291-844a-4340-b721-b91fadc33497	60073	Tcp	Custom	2026-01-10 16:43:58.428002+00	2026-01-10 16:43:58.428002+00
b83bc21d-d9dd-4e87-9190-f8d897c9a877	461c7231-c9a7-4a98-907e-5df83c7cf84d	7b17ccaf-7a84-4c24-9fde-c3d53d520569	5432	Tcp	PostgreSQL	2026-01-10 16:44:35.780343+00	2026-01-10 16:44:35.780343+00
617125ec-544b-4481-acf8-b0274e1e4d6f	461c7231-c9a7-4a98-907e-5df83c7cf84d	59f07f06-13ea-475b-b50f-e03c93be493e	60072	Tcp	Custom	2026-01-10 16:44:37.411742+00	2026-01-10 16:44:37.411742+00
e69075ff-180b-445a-a58a-d7299142bf4a	461c7231-c9a7-4a98-907e-5df83c7cf84d	ef6924e3-b81d-4411-be87-5ae76faf5669	8123	Tcp	Custom	2026-01-10 16:45:05.693171+00	2026-01-10 16:45:05.693171+00
1a6554de-4f17-40c7-baf0-04287db0bca0	461c7231-c9a7-4a98-907e-5df83c7cf84d	ef6924e3-b81d-4411-be87-5ae76faf5669	18555	Tcp	Custom	2026-01-10 16:45:05.693179+00	2026-01-10 16:45:05.693179+00
6ade283c-566e-4e4b-b7a8-afa14e2321b4	461c7231-c9a7-4a98-907e-5df83c7cf84d	8e81205a-9b33-456c-8951-5f742d48e0fe	60072	Tcp	Custom	2026-01-10 16:45:13.329547+00	2026-01-10 16:45:13.329547+00
58c02e19-f3e6-49ec-8670-dc3e2b90d47e	461c7231-c9a7-4a98-907e-5df83c7cf84d	8e81205a-9b33-456c-8951-5f742d48e0fe	8123	Tcp	Custom	2026-01-10 16:45:18.048601+00	2026-01-10 16:45:18.048601+00
4cd31861-8394-4237-898b-54eb19a8d5aa	461c7231-c9a7-4a98-907e-5df83c7cf84d	8e81205a-9b33-456c-8951-5f742d48e0fe	22	Tcp	Ssh	2026-01-10 16:45:27.214698+00	2026-01-10 16:45:27.214698+00
c1121f55-11c1-4dcd-9c7c-6adb55f45b19	461c7231-c9a7-4a98-907e-5df83c7cf84d	8e81205a-9b33-456c-8951-5f742d48e0fe	5435	Tcp	Custom	2026-01-10 16:45:27.214902+00	2026-01-10 16:45:27.214902+00
\.


--
-- Data for Name: services; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.services (id, network_id, created_at, updated_at, name, host_id, service_definition, virtualization, source, "position") FROM stdin;
80c0ced7-ad40-4db7-9c9f-451ca8a99350	461c7231-c9a7-4a98-907e-5df83c7cf84d	2026-01-10 16:43:58.428222+00	2026-01-10 16:43:58.428222+00	Scanopy Daemon	ce156291-844a-4340-b721-b91fadc33497	"Scanopy Daemon"	null	{"type": "DiscoveryWithMatch", "details": {"reason": {"data": "Scanopy Daemon self-report", "type": "reason"}, "confidence": "Certain"}, "metadata": [{"date": "2026-01-10T16:43:58.428221097Z", "type": "SelfReport", "host_id": "ce156291-844a-4340-b721-b91fadc33497", "daemon_id": "12dbd539-15ef-419c-aae7-da90f3a4bbce"}]}	0
285c8d22-2c94-49da-8889-a99a420ba534	461c7231-c9a7-4a98-907e-5df83c7cf84d	2026-01-10 16:44:35.780359+00	2026-01-10 16:44:35.780359+00	PostgreSQL	7b17ccaf-7a84-4c24-9fde-c3d53d520569	"PostgreSQL"	null	{"type": "DiscoveryWithMatch", "details": {"reason": {"data": ["Generic service", [{"data": "Port 5432/tcp is open", "type": "reason"}]], "type": "container"}, "confidence": "NotApplicable"}, "metadata": [{"date": "2026-01-10T16:44:35.780336946Z", "type": "Network", "daemon_id": "12dbd539-15ef-419c-aae7-da90f3a4bbce", "subnet_ids": null, "host_naming_fallback": "BestService"}]}	0
63431e53-2bbe-4c25-8b13-a73cb2618b49	461c7231-c9a7-4a98-907e-5df83c7cf84d	2026-01-10 16:44:37.411755+00	2026-01-10 16:44:37.411755+00	Scanopy Server	59f07f06-13ea-475b-b50f-e03c93be493e	"Scanopy Server"	null	{"type": "DiscoveryWithMatch", "details": {"reason": {"data": "Response for 172.25.0.3:60072/api/health contained \\"scanopy\\" in body", "type": "reason"}, "confidence": "High"}, "metadata": [{"date": "2026-01-10T16:44:37.411724476Z", "type": "Network", "daemon_id": "12dbd539-15ef-419c-aae7-da90f3a4bbce", "subnet_ids": null, "host_naming_fallback": "BestService"}]}	0
9a146cde-ca31-4f62-bbc8-66be2970d6c0	461c7231-c9a7-4a98-907e-5df83c7cf84d	2026-01-10 16:45:05.69319+00	2026-01-10 16:45:05.69319+00	Unclaimed Open Ports	ef6924e3-b81d-4411-be87-5ae76faf5669	"Unclaimed Open Ports"	null	{"type": "DiscoveryWithMatch", "details": {"reason": {"data": ["Generic service", [{"data": "Has unbound open ports", "type": "reason"}]], "type": "container"}, "confidence": "NotApplicable"}, "metadata": [{"date": "2026-01-10T16:45:05.693165565Z", "type": "Network", "daemon_id": "12dbd539-15ef-419c-aae7-da90f3a4bbce", "subnet_ids": null, "host_naming_fallback": "BestService"}]}	0
1739299b-a2ff-4baf-ac60-27f27f54a144	461c7231-c9a7-4a98-907e-5df83c7cf84d	2026-01-10 16:45:13.329561+00	2026-01-10 16:45:13.329561+00	Scanopy Server	8e81205a-9b33-456c-8951-5f742d48e0fe	"Scanopy Server"	null	{"type": "DiscoveryWithMatch", "details": {"reason": {"data": "Response for 172.25.0.1:60072/api/health contained \\"scanopy\\" in body", "type": "reason"}, "confidence": "High"}, "metadata": [{"date": "2026-01-10T16:45:13.329541511Z", "type": "Network", "daemon_id": "12dbd539-15ef-419c-aae7-da90f3a4bbce", "subnet_ids": null, "host_naming_fallback": "BestService"}]}	0
40157f70-5487-4141-a828-98e21f2c05ab	461c7231-c9a7-4a98-907e-5df83c7cf84d	2026-01-10 16:45:18.048615+00	2026-01-10 16:45:18.048615+00	Home Assistant	8e81205a-9b33-456c-8951-5f742d48e0fe	"Home Assistant"	null	{"type": "DiscoveryWithMatch", "details": {"reason": {"data": "Response for 172.25.0.1:8123/ contained \\"home assistant\\" in body", "type": "reason"}, "confidence": "High"}, "metadata": [{"date": "2026-01-10T16:45:18.048595388Z", "type": "Network", "daemon_id": "12dbd539-15ef-419c-aae7-da90f3a4bbce", "subnet_ids": null, "host_naming_fallback": "BestService"}]}	1
e410f013-fad9-459a-bf41-a2fcb0f0da57	461c7231-c9a7-4a98-907e-5df83c7cf84d	2026-01-10 16:45:27.214714+00	2026-01-10 16:45:27.214714+00	SSH	8e81205a-9b33-456c-8951-5f742d48e0fe	"SSH"	null	{"type": "DiscoveryWithMatch", "details": {"reason": {"data": ["Generic service", [{"data": "Port 22/tcp is open", "type": "reason"}]], "type": "container"}, "confidence": "NotApplicable"}, "metadata": [{"date": "2026-01-10T16:45:27.214692690Z", "type": "Network", "daemon_id": "12dbd539-15ef-419c-aae7-da90f3a4bbce", "subnet_ids": null, "host_naming_fallback": "BestService"}]}	2
b95f6674-63ca-421c-a58f-cbc68577e6a8	461c7231-c9a7-4a98-907e-5df83c7cf84d	2026-01-10 16:45:27.21491+00	2026-01-10 16:45:27.21491+00	Unclaimed Open Ports	8e81205a-9b33-456c-8951-5f742d48e0fe	"Unclaimed Open Ports"	null	{"type": "DiscoveryWithMatch", "details": {"reason": {"data": ["Generic service", [{"data": "Has unbound open ports", "type": "reason"}]], "type": "container"}, "confidence": "NotApplicable"}, "metadata": [{"date": "2026-01-10T16:45:27.214899957Z", "type": "Network", "daemon_id": "12dbd539-15ef-419c-aae7-da90f3a4bbce", "subnet_ids": null, "host_naming_fallback": "BestService"}]}	3
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
e299748d-8789-49a2-b2b2-eb5de8c5ea6d	461c7231-c9a7-4a98-907e-5df83c7cf84d	2026-01-10 16:43:58.271538+00	2026-01-10 16:43:58.271538+00	"0.0.0.0/0"	Internet	This subnet uses the 0.0.0.0/0 CIDR as an organizational container for services running on the internet (e.g., public DNS servers, cloud services, etc.).	Internet	{"type": "System"}
48415fe7-c58a-42de-9e0b-ae5a3feb3bd0	461c7231-c9a7-4a98-907e-5df83c7cf84d	2026-01-10 16:43:58.271542+00	2026-01-10 16:43:58.271542+00	"0.0.0.0/0"	Remote Network	This subnet uses the 0.0.0.0/0 CIDR as an organizational container for hosts on remote networks (e.g., mobile connections, friend's networks, public WiFi, etc.).	Remote	{"type": "System"}
3c12df74-1de4-4681-b34f-a998fe3f7249	461c7231-c9a7-4a98-907e-5df83c7cf84d	2026-01-10 16:43:58.410702+00	2026-01-10 16:43:58.410702+00	"172.25.0.0/28"	172.25.0.0/28	\N	Lan	{"type": "Discovery", "metadata": [{"date": "2026-01-10T16:43:58.410700021Z", "type": "SelfReport", "host_id": "ce156291-844a-4340-b721-b91fadc33497", "daemon_id": "12dbd539-15ef-419c-aae7-da90f3a4bbce"}]}
\.


--
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tags (id, organization_id, name, description, created_at, updated_at, color) FROM stdin;
4dd71c48-68c7-4622-9725-8c9fa18b1f3a	94bd3438-e3cc-484d-a259-9339471b07ad	New Tag	\N	2026-01-10 16:45:57.611824+00	2026-01-10 16:45:57.611824+00	Yellow
\.


--
-- Data for Name: topologies; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.topologies (id, network_id, name, edges, nodes, options, hosts, subnets, services, groups, is_stale, last_refreshed, is_locked, locked_at, locked_by, removed_hosts, removed_services, removed_subnets, removed_groups, parent_id, created_at, updated_at, tags, interfaces, removed_interfaces, ports, removed_ports, bindings, removed_bindings) FROM stdin;
312ff253-e5c8-4d69-8c00-d6173eaecf55	461c7231-c9a7-4a98-907e-5df83c7cf84d	My Topology	[]	[]	{"local": {"no_fade_edges": false, "hide_edge_types": [], "left_zone_title": "Infrastructure", "hide_resize_handles": false}, "request": {"hide_ports": false, "hide_service_categories": [], "show_gateway_in_left_zone": true, "group_docker_bridges_by_host": true, "left_zone_service_categories": ["DNS", "ReverseProxy"], "hide_vm_title_on_docker_container": false}}	[{"id": "ce156291-844a-4340-b721-b91fadc33497", "name": "scanopy-daemon", "tags": [], "hidden": false, "source": {"type": "Discovery", "metadata": [{"date": "2026-01-10T16:43:58.428202342Z", "type": "SelfReport", "host_id": "ce156291-844a-4340-b721-b91fadc33497", "daemon_id": "12dbd539-15ef-419c-aae7-da90f3a4bbce"}]}, "hostname": "662426eb4860", "created_at": "2026-01-10T16:43:58.390112Z", "network_id": "461c7231-c9a7-4a98-907e-5df83c7cf84d", "updated_at": "2026-01-10T16:43:58.390112Z", "description": null, "virtualization": null}, {"id": "7b17ccaf-7a84-4c24-9fde-c3d53d520569", "name": "scanopy-postgres-dev-1.scanopy_scanopy-dev", "tags": [], "hidden": false, "source": {"type": "Discovery", "metadata": [{"date": "2026-01-10T16:44:20.502694946Z", "type": "Network", "daemon_id": "12dbd539-15ef-419c-aae7-da90f3a4bbce", "subnet_ids": null, "host_naming_fallback": "BestService"}]}, "hostname": "scanopy-postgres-dev-1.scanopy_scanopy-dev", "created_at": "2026-01-10T16:44:20.502695Z", "network_id": "461c7231-c9a7-4a98-907e-5df83c7cf84d", "updated_at": "2026-01-10T16:44:20.502695Z", "description": null, "virtualization": null}, {"id": "59f07f06-13ea-475b-b50f-e03c93be493e", "name": "scanopy-server-1.scanopy_scanopy-dev", "tags": [], "hidden": false, "source": {"type": "Discovery", "metadata": [{"date": "2026-01-10T16:44:35.896715169Z", "type": "Network", "daemon_id": "12dbd539-15ef-419c-aae7-da90f3a4bbce", "subnet_ids": null, "host_naming_fallback": "BestService"}]}, "hostname": "scanopy-server-1.scanopy_scanopy-dev", "created_at": "2026-01-10T16:44:35.896716Z", "network_id": "461c7231-c9a7-4a98-907e-5df83c7cf84d", "updated_at": "2026-01-10T16:44:35.896716Z", "description": null, "virtualization": null}, {"id": "ef6924e3-b81d-4411-be87-5ae76faf5669", "name": "homeassistant-discovery.scanopy_scanopy-dev", "tags": [], "hidden": false, "source": {"type": "Discovery", "metadata": [{"date": "2026-01-10T16:44:50.762798135Z", "type": "Network", "daemon_id": "12dbd539-15ef-419c-aae7-da90f3a4bbce", "subnet_ids": null, "host_naming_fallback": "BestService"}]}, "hostname": "homeassistant-discovery.scanopy_scanopy-dev", "created_at": "2026-01-10T16:44:50.762799Z", "network_id": "461c7231-c9a7-4a98-907e-5df83c7cf84d", "updated_at": "2026-01-10T16:44:50.762799Z", "description": null, "virtualization": null}, {"id": "8e81205a-9b33-456c-8951-5f742d48e0fe", "name": "runnervmi13qx", "tags": [], "hidden": false, "source": {"type": "Discovery", "metadata": [{"date": "2026-01-10T16:45:11.750115576Z", "type": "Network", "daemon_id": "12dbd539-15ef-419c-aae7-da90f3a4bbce", "subnet_ids": null, "host_naming_fallback": "BestService"}]}, "hostname": "runnervmi13qx", "created_at": "2026-01-10T16:45:11.750116Z", "network_id": "461c7231-c9a7-4a98-907e-5df83c7cf84d", "updated_at": "2026-01-10T16:45:11.750116Z", "description": null, "virtualization": null}, {"id": "498134a1-9429-480e-a951-fdaaaffc7ca6", "name": "Service Test Host", "tags": [], "hidden": false, "source": {"type": "Manual"}, "hostname": "service-test.local", "created_at": "2026-01-10T16:45:58.306477Z", "network_id": "461c7231-c9a7-4a98-907e-5df83c7cf84d", "updated_at": "2026-01-10T16:45:58.306477Z", "description": null, "virtualization": null}]	[{"id": "e299748d-8789-49a2-b2b2-eb5de8c5ea6d", "cidr": "0.0.0.0/0", "name": "Internet", "tags": [], "source": {"type": "System"}, "created_at": "2026-01-10T16:43:58.271538Z", "network_id": "461c7231-c9a7-4a98-907e-5df83c7cf84d", "updated_at": "2026-01-10T16:43:58.271538Z", "description": "This subnet uses the 0.0.0.0/0 CIDR as an organizational container for services running on the internet (e.g., public DNS servers, cloud services, etc.).", "subnet_type": "Internet"}, {"id": "48415fe7-c58a-42de-9e0b-ae5a3feb3bd0", "cidr": "0.0.0.0/0", "name": "Remote Network", "tags": [], "source": {"type": "System"}, "created_at": "2026-01-10T16:43:58.271542Z", "network_id": "461c7231-c9a7-4a98-907e-5df83c7cf84d", "updated_at": "2026-01-10T16:43:58.271542Z", "description": "This subnet uses the 0.0.0.0/0 CIDR as an organizational container for hosts on remote networks (e.g., mobile connections, friend's networks, public WiFi, etc.).", "subnet_type": "Remote"}, {"id": "3c12df74-1de4-4681-b34f-a998fe3f7249", "cidr": "172.25.0.0/28", "name": "172.25.0.0/28", "tags": [], "source": {"type": "Discovery", "metadata": [{"date": "2026-01-10T16:43:58.410700021Z", "type": "SelfReport", "host_id": "ce156291-844a-4340-b721-b91fadc33497", "daemon_id": "12dbd539-15ef-419c-aae7-da90f3a4bbce"}]}, "created_at": "2026-01-10T16:43:58.410702Z", "network_id": "461c7231-c9a7-4a98-907e-5df83c7cf84d", "updated_at": "2026-01-10T16:43:58.410702Z", "description": null, "subnet_type": "Lan"}]	[{"id": "80c0ced7-ad40-4db7-9c9f-451ca8a99350", "name": "Scanopy Daemon", "tags": [], "source": {"type": "DiscoveryWithMatch", "details": {"reason": {"data": "Scanopy Daemon self-report", "type": "reason"}, "confidence": "Certain"}, "metadata": [{"date": "2026-01-10T16:43:58.428221097Z", "type": "SelfReport", "host_id": "ce156291-844a-4340-b721-b91fadc33497", "daemon_id": "12dbd539-15ef-419c-aae7-da90f3a4bbce"}]}, "host_id": "ce156291-844a-4340-b721-b91fadc33497", "bindings": [{"id": "46602e52-55d6-4be1-b962-a314af80178b", "type": "Port", "port_id": "76a8e6fb-6bc1-488b-8f28-d2bca599720c", "created_at": "2026-01-10T16:43:58.428218Z", "network_id": "461c7231-c9a7-4a98-907e-5df83c7cf84d", "service_id": "80c0ced7-ad40-4db7-9c9f-451ca8a99350", "updated_at": "2026-01-10T16:43:58.428218Z", "interface_id": "8a9e8dcf-a7e2-49b9-b112-2d38a8e945c8"}], "position": 0, "created_at": "2026-01-10T16:43:58.428222Z", "network_id": "461c7231-c9a7-4a98-907e-5df83c7cf84d", "updated_at": "2026-01-10T16:43:58.428222Z", "virtualization": null, "service_definition": "Scanopy Daemon"}, {"id": "285c8d22-2c94-49da-8889-a99a420ba534", "name": "PostgreSQL", "tags": [], "source": {"type": "DiscoveryWithMatch", "details": {"reason": {"data": ["Generic service", [{"data": "Port 5432/tcp is open", "type": "reason"}]], "type": "container"}, "confidence": "NotApplicable"}, "metadata": [{"date": "2026-01-10T16:44:35.780336946Z", "type": "Network", "daemon_id": "12dbd539-15ef-419c-aae7-da90f3a4bbce", "subnet_ids": null, "host_naming_fallback": "BestService"}]}, "host_id": "7b17ccaf-7a84-4c24-9fde-c3d53d520569", "bindings": [{"id": "af394cd8-7e1b-41f7-9b7e-10859202623f", "type": "Port", "port_id": "b83bc21d-d9dd-4e87-9190-f8d897c9a877", "created_at": "2026-01-10T16:44:35.780354Z", "network_id": "461c7231-c9a7-4a98-907e-5df83c7cf84d", "service_id": "285c8d22-2c94-49da-8889-a99a420ba534", "updated_at": "2026-01-10T16:44:35.780354Z", "interface_id": "50b7e405-0281-4dd8-bba6-af2a2b334c04"}], "position": 0, "created_at": "2026-01-10T16:44:35.780359Z", "network_id": "461c7231-c9a7-4a98-907e-5df83c7cf84d", "updated_at": "2026-01-10T16:44:35.780359Z", "virtualization": null, "service_definition": "PostgreSQL"}, {"id": "63431e53-2bbe-4c25-8b13-a73cb2618b49", "name": "Scanopy Server", "tags": [], "source": {"type": "DiscoveryWithMatch", "details": {"reason": {"data": "Response for 172.25.0.3:60072/api/health contained \\"scanopy\\" in body", "type": "reason"}, "confidence": "High"}, "metadata": [{"date": "2026-01-10T16:44:37.411724476Z", "type": "Network", "daemon_id": "12dbd539-15ef-419c-aae7-da90f3a4bbce", "subnet_ids": null, "host_naming_fallback": "BestService"}]}, "host_id": "59f07f06-13ea-475b-b50f-e03c93be493e", "bindings": [{"id": "408aa80a-dd1e-4efa-9c01-9ba7ae1cc9f1", "type": "Port", "port_id": "617125ec-544b-4481-acf8-b0274e1e4d6f", "created_at": "2026-01-10T16:44:37.411752Z", "network_id": "461c7231-c9a7-4a98-907e-5df83c7cf84d", "service_id": "63431e53-2bbe-4c25-8b13-a73cb2618b49", "updated_at": "2026-01-10T16:44:37.411752Z", "interface_id": "23128cd1-aba2-4a69-ba44-1b3b12c4d5f3"}], "position": 0, "created_at": "2026-01-10T16:44:37.411755Z", "network_id": "461c7231-c9a7-4a98-907e-5df83c7cf84d", "updated_at": "2026-01-10T16:44:37.411755Z", "virtualization": null, "service_definition": "Scanopy Server"}, {"id": "9a146cde-ca31-4f62-bbc8-66be2970d6c0", "name": "Unclaimed Open Ports", "tags": [], "source": {"type": "DiscoveryWithMatch", "details": {"reason": {"data": ["Generic service", [{"data": "Has unbound open ports", "type": "reason"}]], "type": "container"}, "confidence": "NotApplicable"}, "metadata": [{"date": "2026-01-10T16:45:05.693165565Z", "type": "Network", "daemon_id": "12dbd539-15ef-419c-aae7-da90f3a4bbce", "subnet_ids": null, "host_naming_fallback": "BestService"}]}, "host_id": "ef6924e3-b81d-4411-be87-5ae76faf5669", "bindings": [{"id": "7a3c3f8e-2b62-48d2-a5fe-b1850783cd11", "type": "Port", "port_id": "e69075ff-180b-445a-a58a-d7299142bf4a", "created_at": "2026-01-10T16:45:05.693184Z", "network_id": "461c7231-c9a7-4a98-907e-5df83c7cf84d", "service_id": "9a146cde-ca31-4f62-bbc8-66be2970d6c0", "updated_at": "2026-01-10T16:45:05.693184Z", "interface_id": "cb68599e-a091-4a74-872a-25839896684b"}, {"id": "df4fea6c-04b4-4742-bbac-1c37628fd8c4", "type": "Port", "port_id": "1a6554de-4f17-40c7-baf0-04287db0bca0", "created_at": "2026-01-10T16:45:05.693185Z", "network_id": "461c7231-c9a7-4a98-907e-5df83c7cf84d", "service_id": "9a146cde-ca31-4f62-bbc8-66be2970d6c0", "updated_at": "2026-01-10T16:45:05.693185Z", "interface_id": "cb68599e-a091-4a74-872a-25839896684b"}], "position": 0, "created_at": "2026-01-10T16:45:05.693190Z", "network_id": "461c7231-c9a7-4a98-907e-5df83c7cf84d", "updated_at": "2026-01-10T16:45:05.693190Z", "virtualization": null, "service_definition": "Unclaimed Open Ports"}, {"id": "1739299b-a2ff-4baf-ac60-27f27f54a144", "name": "Scanopy Server", "tags": [], "source": {"type": "DiscoveryWithMatch", "details": {"reason": {"data": "Response for 172.25.0.1:60072/api/health contained \\"scanopy\\" in body", "type": "reason"}, "confidence": "High"}, "metadata": [{"date": "2026-01-10T16:45:13.329541511Z", "type": "Network", "daemon_id": "12dbd539-15ef-419c-aae7-da90f3a4bbce", "subnet_ids": null, "host_naming_fallback": "BestService"}]}, "host_id": "8e81205a-9b33-456c-8951-5f742d48e0fe", "bindings": [{"id": "0c197a53-b909-43cf-89d9-4a297162a623", "type": "Port", "port_id": "6ade283c-566e-4e4b-b7a8-afa14e2321b4", "created_at": "2026-01-10T16:45:13.329557Z", "network_id": "461c7231-c9a7-4a98-907e-5df83c7cf84d", "service_id": "1739299b-a2ff-4baf-ac60-27f27f54a144", "updated_at": "2026-01-10T16:45:13.329557Z", "interface_id": "95610cab-c538-4707-962e-ccbe0f2ff6b6"}], "position": 0, "created_at": "2026-01-10T16:45:13.329561Z", "network_id": "461c7231-c9a7-4a98-907e-5df83c7cf84d", "updated_at": "2026-01-10T16:45:13.329561Z", "virtualization": null, "service_definition": "Scanopy Server"}, {"id": "40157f70-5487-4141-a828-98e21f2c05ab", "name": "Home Assistant", "tags": [], "source": {"type": "DiscoveryWithMatch", "details": {"reason": {"data": "Response for 172.25.0.1:8123/ contained \\"home assistant\\" in body", "type": "reason"}, "confidence": "High"}, "metadata": [{"date": "2026-01-10T16:45:18.048595388Z", "type": "Network", "daemon_id": "12dbd539-15ef-419c-aae7-da90f3a4bbce", "subnet_ids": null, "host_naming_fallback": "BestService"}]}, "host_id": "8e81205a-9b33-456c-8951-5f742d48e0fe", "bindings": [{"id": "8b52d810-2bc7-4de3-9a5d-f67135df6810", "type": "Port", "port_id": "58c02e19-f3e6-49ec-8670-dc3e2b90d47e", "created_at": "2026-01-10T16:45:18.048612Z", "network_id": "461c7231-c9a7-4a98-907e-5df83c7cf84d", "service_id": "40157f70-5487-4141-a828-98e21f2c05ab", "updated_at": "2026-01-10T16:45:18.048612Z", "interface_id": "95610cab-c538-4707-962e-ccbe0f2ff6b6"}], "position": 1, "created_at": "2026-01-10T16:45:18.048615Z", "network_id": "461c7231-c9a7-4a98-907e-5df83c7cf84d", "updated_at": "2026-01-10T16:45:18.048615Z", "virtualization": null, "service_definition": "Home Assistant"}, {"id": "e410f013-fad9-459a-bf41-a2fcb0f0da57", "name": "SSH", "tags": [], "source": {"type": "DiscoveryWithMatch", "details": {"reason": {"data": ["Generic service", [{"data": "Port 22/tcp is open", "type": "reason"}]], "type": "container"}, "confidence": "NotApplicable"}, "metadata": [{"date": "2026-01-10T16:45:27.214692690Z", "type": "Network", "daemon_id": "12dbd539-15ef-419c-aae7-da90f3a4bbce", "subnet_ids": null, "host_naming_fallback": "BestService"}]}, "host_id": "8e81205a-9b33-456c-8951-5f742d48e0fe", "bindings": [{"id": "b3f002e0-94a8-439a-a542-252ce7713158", "type": "Port", "port_id": "4cd31861-8394-4237-898b-54eb19a8d5aa", "created_at": "2026-01-10T16:45:27.214709Z", "network_id": "461c7231-c9a7-4a98-907e-5df83c7cf84d", "service_id": "e410f013-fad9-459a-bf41-a2fcb0f0da57", "updated_at": "2026-01-10T16:45:27.214709Z", "interface_id": "95610cab-c538-4707-962e-ccbe0f2ff6b6"}], "position": 2, "created_at": "2026-01-10T16:45:27.214714Z", "network_id": "461c7231-c9a7-4a98-907e-5df83c7cf84d", "updated_at": "2026-01-10T16:45:27.214714Z", "virtualization": null, "service_definition": "SSH"}, {"id": "b95f6674-63ca-421c-a58f-cbc68577e6a8", "name": "Unclaimed Open Ports", "tags": [], "source": {"type": "DiscoveryWithMatch", "details": {"reason": {"data": ["Generic service", [{"data": "Has unbound open ports", "type": "reason"}]], "type": "container"}, "confidence": "NotApplicable"}, "metadata": [{"date": "2026-01-10T16:45:27.214899957Z", "type": "Network", "daemon_id": "12dbd539-15ef-419c-aae7-da90f3a4bbce", "subnet_ids": null, "host_naming_fallback": "BestService"}]}, "host_id": "8e81205a-9b33-456c-8951-5f742d48e0fe", "bindings": [{"id": "3ad8706c-bc50-49e0-993a-b031b7e326a6", "type": "Port", "port_id": "c1121f55-11c1-4dcd-9c7c-6adb55f45b19", "created_at": "2026-01-10T16:45:27.214906Z", "network_id": "461c7231-c9a7-4a98-907e-5df83c7cf84d", "service_id": "b95f6674-63ca-421c-a58f-cbc68577e6a8", "updated_at": "2026-01-10T16:45:27.214906Z", "interface_id": "95610cab-c538-4707-962e-ccbe0f2ff6b6"}], "position": 3, "created_at": "2026-01-10T16:45:27.214910Z", "network_id": "461c7231-c9a7-4a98-907e-5df83c7cf84d", "updated_at": "2026-01-10T16:45:27.214910Z", "virtualization": null, "service_definition": "Unclaimed Open Ports"}]	[{"id": "b7dfc692-5e49-4d1e-97ec-9675972b1e29", "name": "", "tags": [], "color": "Yellow", "source": {"type": "Manual"}, "created_at": "2026-01-10T16:45:57.603702Z", "edge_style": "SmoothStep", "group_type": "RequestPath", "network_id": "461c7231-c9a7-4a98-907e-5df83c7cf84d", "updated_at": "2026-01-10T16:45:57.603702Z", "binding_ids": [], "description": null}]	t	2026-01-10 16:43:58.287627+00	f	\N	\N	{3541d786-4ee6-465d-b227-734325d74b3e,498134a1-9429-480e-a951-fdaaaffc7ca6,cad4ad2f-3f50-40fb-9b0a-c16e725385aa}	{516980cf-9946-49e6-987a-1038f58a8912}	{1fd2fbce-592d-40eb-83e8-47883e99b34f}	{85d3d809-c51a-4263-bead-61de3d976b75}	\N	2026-01-10 16:43:58.276123+00	2026-01-10 16:43:58.276123+00	{}	[]	{}	[]	{}	[]	{}
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
ae118265-c62e-4ef5-a94a-bcc7a3d542e0	2026-01-10 16:43:58.178969+00	2026-01-10 16:43:58.178969+00	$argon2id$v=19$m=19456,t=2,p=1$0yfH7IZ/CnvuPnb5GM7+Bg$I6hFr8oj46YGlzwrxK1yPc6OVPqVYOSGWmtL5OKl8F8	\N	\N	\N	user@gmail.com	94bd3438-e3cc-484d-a259-9339471b07ad	Owner	{}	\N
1ad1d4ec-a774-4e3a-8680-4fdf11f8e559	2026-01-10 16:45:59.002366+00	2026-01-10 16:45:59.002366+00	\N	\N	\N	\N	user@example.com	94bd3438-e3cc-484d-a259-9339471b07ad	Owner	{}	\N
\.


--
-- Data for Name: session; Type: TABLE DATA; Schema: tower_sessions; Owner: postgres
--

COPY tower_sessions.session (id, data, expiry_date) FROM stdin;
J4H0HBCjouAZ-RDM1d9Q1Q	\\x93c410d550dfd5cc10f919e0a2a3101cf4812781a7757365725f6964d92461653131383236352d633632652d346566352d613934612d62636337613364353432653099cd07ea11102b3ace18ec099b000000	2026-01-17 16:43:58.418122+00
ohX_pOZu3xBOCzjGHA-OBQ	\\x93c410058e0f1cc6380b4e10df6ee6a4ff15a282a7757365725f6964d92461653131383236352d633632652d346566352d613934612d626363376133643534326530ad70656e64696e675f736574757082a86e6574776f726b739182a46e616d65aa4d79204e6574776f726baa6e6574776f726b5f6964d92433613731303865382d383933342d343231322d383531332d373165336534303034313430a86f72675f6e616d65af4d79204f7267616e697a6174696f6e99cd07ea11102d3ace0c3557b0000000	2026-01-17 16:45:58.204822+00
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

\unrestrict eonVCHCW8Bu2udMiluekm1BbRRsc0I7JMNaGOV3QIfgZ07fLdYCdkXaQ9hfF9au

