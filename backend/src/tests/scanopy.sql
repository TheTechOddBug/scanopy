--
-- PostgreSQL database dump
--

\restrict vtksb0ELwzvsxhxgxgLqrLloUPNbC0seeKqf5FW5fNJ6nHjGutcYbRpqsmv4vhl

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
ALTER TABLE IF EXISTS ONLY public.discovery DROP CONSTRAINT IF EXISTS discovery_network_id_fkey;
ALTER TABLE IF EXISTS ONLY public.discovery DROP CONSTRAINT IF EXISTS discovery_daemon_id_fkey;
ALTER TABLE IF EXISTS ONLY public.daemons DROP CONSTRAINT IF EXISTS daemons_network_id_fkey;
ALTER TABLE IF EXISTS ONLY public.bindings DROP CONSTRAINT IF EXISTS bindings_service_id_fkey;
ALTER TABLE IF EXISTS ONLY public.bindings DROP CONSTRAINT IF EXISTS bindings_port_id_fkey;
ALTER TABLE IF EXISTS ONLY public.bindings DROP CONSTRAINT IF EXISTS bindings_network_id_fkey;
ALTER TABLE IF EXISTS ONLY public.bindings DROP CONSTRAINT IF EXISTS bindings_interface_id_fkey;
ALTER TABLE IF EXISTS ONLY public.api_keys DROP CONSTRAINT IF EXISTS api_keys_network_id_fkey;
DROP TRIGGER IF EXISTS trigger_remove_deleted_tag_from_entities ON public.tags;
DROP INDEX IF EXISTS public.idx_users_organization;
DROP INDEX IF EXISTS public.idx_users_oidc_provider_subject;
DROP INDEX IF EXISTS public.idx_users_email_lower;
DROP INDEX IF EXISTS public.idx_user_network_access_user;
DROP INDEX IF EXISTS public.idx_user_network_access_network;
DROP INDEX IF EXISTS public.idx_topologies_network;
DROP INDEX IF EXISTS public.idx_tags_organization;
DROP INDEX IF EXISTS public.idx_tags_org_name;
DROP INDEX IF EXISTS public.idx_subnets_network;
DROP INDEX IF EXISTS public.idx_shares_topology;
DROP INDEX IF EXISTS public.idx_shares_network;
DROP INDEX IF EXISTS public.idx_shares_enabled;
DROP INDEX IF EXISTS public.idx_services_network;
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
DROP INDEX IF EXISTS public.idx_interfaces_host;
DROP INDEX IF EXISTS public.idx_hosts_network;
DROP INDEX IF EXISTS public.idx_groups_network;
DROP INDEX IF EXISTS public.idx_group_bindings_group;
DROP INDEX IF EXISTS public.idx_group_bindings_binding;
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
ALTER TABLE IF EXISTS ONLY public.discovery DROP CONSTRAINT IF EXISTS discovery_pkey;
ALTER TABLE IF EXISTS ONLY public.daemons DROP CONSTRAINT IF EXISTS daemons_pkey;
ALTER TABLE IF EXISTS ONLY public.bindings DROP CONSTRAINT IF EXISTS bindings_pkey;
ALTER TABLE IF EXISTS ONLY public.api_keys DROP CONSTRAINT IF EXISTS api_keys_pkey;
ALTER TABLE IF EXISTS ONLY public.api_keys DROP CONSTRAINT IF EXISTS api_keys_key_key;
ALTER TABLE IF EXISTS ONLY public._sqlx_migrations DROP CONSTRAINT IF EXISTS _sqlx_migrations_pkey;
DROP TABLE IF EXISTS tower_sessions.session;
DROP TABLE IF EXISTS public.users;
DROP TABLE IF EXISTS public.user_network_access;
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
DROP TABLE IF EXISTS public.discovery;
DROP TABLE IF EXISTS public.daemons;
DROP TABLE IF EXISTS public.bindings;
DROP TABLE IF EXISTS public.api_keys;
DROP TABLE IF EXISTS public._sqlx_migrations;
DROP FUNCTION IF EXISTS public.remove_deleted_tag_from_entities();
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


--
-- Name: remove_deleted_tag_from_entities(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.remove_deleted_tag_from_entities() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Remove the deleted tag ID from all entity tags arrays
    UPDATE users SET tags = array_remove(tags, OLD.id), updated_at = NOW() WHERE OLD.id = ANY(tags);
    UPDATE discovery SET tags = array_remove(tags, OLD.id), updated_at = NOW() WHERE OLD.id = ANY(tags);
    UPDATE hosts SET tags = array_remove(tags, OLD.id), updated_at = NOW() WHERE OLD.id = ANY(tags);
    UPDATE networks SET tags = array_remove(tags, OLD.id), updated_at = NOW() WHERE OLD.id = ANY(tags);
    UPDATE subnets SET tags = array_remove(tags, OLD.id), updated_at = NOW() WHERE OLD.id = ANY(tags);
    UPDATE groups SET tags = array_remove(tags, OLD.id), updated_at = NOW() WHERE OLD.id = ANY(tags);
    UPDATE daemons SET tags = array_remove(tags, OLD.id), updated_at = NOW() WHERE OLD.id = ANY(tags);
    UPDATE services SET tags = array_remove(tags, OLD.id), updated_at = NOW() WHERE OLD.id = ANY(tags);
    UPDATE api_keys SET tags = array_remove(tags, OLD.id), updated_at = NOW() WHERE OLD.id = ANY(tags);
    UPDATE topologies SET tags = array_remove(tags, OLD.id), updated_at = NOW() WHERE OLD.id = ANY(tags);

    RETURN OLD;
END;
$$;


ALTER FUNCTION public.remove_deleted_tag_from_entities() OWNER TO postgres;

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
    is_enabled boolean DEFAULT true NOT NULL,
    tags uuid[] DEFAULT '{}'::uuid[] NOT NULL
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
    tags uuid[] DEFAULT '{}'::uuid[] NOT NULL
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
    updated_at timestamp with time zone NOT NULL,
    tags uuid[] DEFAULT '{}'::uuid[] NOT NULL
);


ALTER TABLE public.discovery OWNER TO postgres;

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
    tags uuid[] DEFAULT '{}'::uuid[] NOT NULL,
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
    hidden boolean DEFAULT false,
    tags uuid[] DEFAULT '{}'::uuid[] NOT NULL
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
    organization_id uuid NOT NULL,
    tags uuid[] DEFAULT '{}'::uuid[] NOT NULL
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
    tags uuid[] DEFAULT '{}'::uuid[] NOT NULL
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
    source jsonb NOT NULL,
    tags uuid[] DEFAULT '{}'::uuid[] NOT NULL
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
20251006215000	users	2025-12-28 17:02:02.898913+00	t	\\x4f13ce14ff67ef0b7145987c7b22b588745bf9fbb7b673450c26a0f2f9a36ef8ca980e456c8d77cfb1b2d7a4577a64d7	3743176
20251006215100	networks	2025-12-28 17:02:02.904786+00	t	\\xeaa5a07a262709f64f0c59f31e25519580c79e2d1a523ce72736848946a34b17dd9adc7498eaf90551af6b7ec6d4e0e3	6279454
20251006215151	create hosts	2025-12-28 17:02:02.911644+00	t	\\x6ec7487074c0724932d21df4cf1ed66645313cf62c159a7179e39cbc261bcb81a24f7933a0e3cf58504f2a90fc5c1962	4446801
20251006215155	create subnets	2025-12-28 17:02:02.916649+00	t	\\xefb5b25742bd5f4489b67351d9f2494a95f307428c911fd8c5f475bfb03926347bdc269bbd048d2ddb06336945b27926	4135178
20251006215201	create groups	2025-12-28 17:02:02.922648+00	t	\\x0a7032bf4d33a0baf020e905da865cde240e2a09dda2f62aa535b2c5d4b26b20be30a3286f1b5192bd94cd4a5dbb5bcd	4114639
20251006215204	create daemons	2025-12-28 17:02:02.927175+00	t	\\xcfea93403b1f9cf9aac374711d4ac72d8a223e3c38a1d2a06d9edb5f94e8a557debac3668271f8176368eadc5105349f	4242118
20251006215212	create services	2025-12-28 17:02:02.93189+00	t	\\xd5b07f82fc7c9da2782a364d46078d7d16b5c08df70cfbf02edcfe9b1b24ab6024ad159292aeea455f15cfd1f4740c1d	4792896
20251029193448	user-auth	2025-12-28 17:02:02.937359+00	t	\\xfde8161a8db89d51eeade7517d90a41d560f19645620f2298f78f116219a09728b18e91251ae31e46a47f6942d5a9032	8761082
20251030044828	daemon api	2025-12-28 17:02:02.947518+00	t	\\x181eb3541f51ef5b038b2064660370775d1b364547a214a20dde9c9d4bb95a1c273cd4525ef29e61fa65a3eb4fee0400	1641554
20251030170438	host-hide	2025-12-28 17:02:02.94947+00	t	\\x87c6fda7f8456bf610a78e8e98803158caa0e12857c5bab466a5bb0004d41b449004a68e728ca13f17e051f662a15454	1058045
20251102224919	create discovery	2025-12-28 17:02:02.952148+00	t	\\xb32a04abb891aba48f92a059fae7341442355ca8e4af5d109e28e2a4f79ee8e11b2a8f40453b7f6725c2dd6487f26573	13512170
20251106235621	normalize-daemon-cols	2025-12-28 17:02:02.96628+00	t	\\x5b137118d506e2708097c432358bf909265b3cf3bacd662b02e2c81ba589a9e0100631c7801cffd9c57bb10a6674fb3b	2311715
20251107034459	api keys	2025-12-28 17:02:02.969995+00	t	\\x3133ec043c0c6e25b6e55f7da84cae52b2a72488116938a2c669c8512c2efe72a74029912bcba1f2a2a0a8b59ef01dde	9947557
20251107222650	oidc-auth	2025-12-28 17:02:02.980467+00	t	\\xd349750e0298718cbcd98eaff6e152b3fb45c3d9d62d06eedeb26c75452e9ce1af65c3e52c9f2de4bd532939c2f31096	38847638
20251110181948	orgs-billing	2025-12-28 17:02:03.01981+00	t	\\x5bbea7a2dfc9d00213bd66b473289ddd66694eff8a4f3eaab937c985b64c5f8c3ad2d64e960afbb03f335ac6766687aa	11803250
20251113223656	group-enhancements	2025-12-28 17:02:03.032157+00	t	\\xbe0699486d85df2bd3edc1f0bf4f1f096d5b6c5070361702c4d203ec2bb640811be88bb1979cfe51b40805ad84d1de65	1178339
20251117032720	daemon-mode	2025-12-28 17:02:03.034032+00	t	\\xdd0d899c24b73d70e9970e54b2c748d6b6b55c856ca0f8590fe990da49cc46c700b1ce13f57ff65abd6711f4bd8a6481	1438966
20251118143058	set-default-plan	2025-12-28 17:02:03.035766+00	t	\\xd19142607aef84aac7cfb97d60d29bda764d26f513f2c72306734c03cec2651d23eee3ce6cacfd36ca52dbddc462f917	1107888
20251118225043	save-topology	2025-12-28 17:02:03.037483+00	t	\\x011a594740c69d8d0f8b0149d49d1b53cfbf948b7866ebd84403394139cb66a44277803462846b06e762577adc3e61a3	9799360
20251123232748	network-permissions	2025-12-28 17:02:03.047927+00	t	\\x161be7ae5721c06523d6488606f1a7b1f096193efa1183ecdd1c2c9a4a9f4cad4884e939018917314aaf261d9a3f97ae	3287797
20251125001342	billing-updates	2025-12-28 17:02:03.051639+00	t	\\xa235d153d95aeb676e3310a52ccb69dfbd7ca36bba975d5bbca165ceeec7196da12119f23597ea5276c364f90f23db1e	1211582
20251128035448	org-onboarding-status	2025-12-28 17:02:03.053787+00	t	\\x1d7a7e9bf23b5078250f31934d1bc47bbaf463ace887e7746af30946e843de41badfc2b213ed64912a18e07b297663d8	1452952
20251129180942	nfs-consolidate	2025-12-28 17:02:03.055916+00	t	\\xb38f41d30699a475c2b967f8e43156f3b49bb10341bddbde01d9fb5ba805f6724685e27e53f7e49b6c8b59e29c74f98e	2136677
20251206052641	discovery-progress	2025-12-28 17:02:03.058627+00	t	\\x9d433b7b8c58d0d5437a104497e5e214febb2d1441a3ad7c28512e7497ed14fb9458e0d4ff786962a59954cb30da1447	3269671
20251206202200	plan-fix	2025-12-28 17:02:03.063665+00	t	\\x242f6699dbf485cf59a8d1b8cd9d7c43aeef635a9316be815a47e15238c5e4af88efaa0daf885be03572948dc0c9edac	3319205
20251207061341	daemon-url	2025-12-28 17:02:03.070613+00	t	\\x01172455c4f2d0d57371d18ef66d2ab3b7a8525067ef8a86945c616982e6ce06f5ea1e1560a8f20dadcd5be2223e6df1	3150991
20251210045929	tags	2025-12-28 17:02:03.074171+00	t	\\xe3dde83d39f8552b5afcdc1493cddfeffe077751bf55472032bc8b35fc8fc2a2caa3b55b4c2354ace7de03c3977982db	11457225
20251210175035	terms	2025-12-28 17:02:03.086067+00	t	\\xe47f0cf7aba1bffa10798bede953da69fd4bfaebf9c75c76226507c558a3595c6bfc6ac8920d11398dbdf3b762769992	1534072
20251213025048	hash-keys	2025-12-28 17:02:03.088208+00	t	\\xfc7cbb8ce61f0c225322297f7459dcbe362242b9001c06cb874b7f739cea7ae888d8f0cfaed6623bcbcb9ec54c8cd18b	443571688
20251214050638	scanopy	2025-12-28 17:02:03.532271+00	t	\\x0108bb39832305f024126211710689adc48d973ff66e5e59ff49468389b75c1ff95d1fbbb7bdb50e33ec1333a1f29ea6	38305466
20251215215724	topo-scanopy-fix	2025-12-28 17:02:03.571827+00	t	\\xed88a4b71b3c9b61d46322b5053362e5a25a9293cd3c420c9df9fcaeb3441254122b8a18f58c297f535c842b8a8b0a38	788221
20251217153736	category rename	2025-12-28 17:02:03.574257+00	t	\\x03af7ec905e11a77e25038a3c272645da96014da7c50c585a25cea3f9a7579faba3ff45114a5e589d144c9550ba42421	60705890
20251218053111	invite-persistence	2025-12-28 17:02:03.635801+00	t	\\x21d12f48b964acfd600f88e70ceb14abd9cf2a8a10db2eae2a6d8f44cf7d20749f93293631e6123e92b7c3c1793877c2	48402442
20251219211216	create shares	2025-12-28 17:02:03.731646+00	t	\\x036485debd3536f9e58ead728f461b925585911acf565970bf3b2ab295b12a2865606d6a56d334c5641dcd42adeb3d68	51185534
20251220170928	permissions-cleanup	2025-12-28 17:02:03.823252+00	t	\\x632f7b6702b494301e0d36fd3b900686b1a7f9936aef8c084b5880f1152b8256a125566e2b5ac40216eaadd3c4c64a03	2290235
20251220180000	commercial-to-community	2025-12-28 17:02:03.82587+00	t	\\x26fc298486c225f2f01271d611418377c403183ae51daf32fef104ec07c027f2017d138910c4fbfb5f49819a5f4194d6	1481345
20251221010000	cleanup subnet type	2025-12-28 17:02:03.827866+00	t	\\xb521121f3fd3a10c0de816977ac2a2ffb6118f34f8474ffb9058722abc0dc4cf5cbec83bc6ee49e79a68e6b715087f40	1251296
20251221020000	remove host target	2025-12-28 17:02:03.829516+00	t	\\x77b5f8872705676ca81a5704bd1eaee90b9a52b404bdaa27a23da2ffd4858d3e131680926a5a00ad2a0d7a24ba229046	1046764
20251221030000	user network access	2025-12-28 17:02:03.830897+00	t	\\x5c23f5bb6b0b8ca699a17eee6730c4197a006ca21fecc79136a5e5697b9211a81b4cd08ceda70dace6a26408d021ff3a	8766312
20251221040000	interfaces table	2025-12-28 17:02:03.840034+00	t	\\xf7977b6f1e7e5108c614397d03a38c9bd9243fdc422575ec29610366a0c88f443de2132185878d8e291f06a50a8c3244	9971723
20251221050000	ports table	2025-12-28 17:02:03.850869+00	t	\\xdf72f9306b405be7be62c39003ef38408115e740b120f24e8c78b8e136574fff7965c52023b3bc476899613fa5f4fe35	8816176
20251221060000	bindings table	2025-12-28 17:02:03.860218+00	t	\\x933648a724bd179c7f47305e4080db85342d48712cde39374f0f88cde9d7eba8fe5fafba360937331e2a8178dec420c4	11026461
20251221070000	group bindings	2025-12-28 17:02:03.871912+00	t	\\x697475802f6c42e38deee6596f4ba786b09f7b7cd91742fbc5696dd0f9b3ddfce90dd905153f2b1a9e82f959f5a88302	6694840
20251222020000	tag cascade delete	2025-12-28 17:02:03.879158+00	t	\\xabfb48c0da8522f5c8ea6d482eb5a5f4562ed41f6160a5915f0fd477c7dd0517aa84760ef99ab3a5db3e0f21b0c69b5f	1894096
20251223232524	network remove default	2025-12-28 17:02:03.881515+00	t	\\x7099fe4e52405e46269d7ce364050da930b481e72484ad3c4772fd2911d2d505476d659fa9f400c63bc287512d033e18	1176369
20251225100000	color enum	2025-12-28 17:02:03.883061+00	t	\\x62cecd9d79a49835a3bea68a7959ab62aa0c1aaa7e2940dec6a7f8a714362df3649f0c1f9313672d9268295ed5a1cfa9	1669576
20251227010000	topology snapshot migration	2025-12-28 17:02:03.885456+00	t	\\xc042591d254869c0e79c8b52a9ede680fd26f094e2c385f5f017e115f5e3f31ad155f4885d095344f2642ebb70755d54	9785800
\.


--
-- Data for Name: api_keys; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.api_keys (id, key, network_id, name, created_at, updated_at, last_used, expires_at, is_enabled, tags) FROM stdin;
7b39d304-35a9-428f-a949-0e4afca0d74d	f7e3fb103867d68791cc62892a136de1b4c55d07e625f6349993809e373d9555	c394efe3-6cba-4409-a937-ce03c1d8f599	Integrated Daemon API Key	2025-12-28 17:02:05.396642+00	2025-12-28 17:03:30.0195+00	2025-12-28 17:03:30.018597+00	\N	t	{}
\.


--
-- Data for Name: bindings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bindings (id, network_id, service_id, binding_type, interface_id, port_id, created_at, updated_at) FROM stdin;
56d24ea2-7b1a-4c36-83b7-d288a99a631b	c394efe3-6cba-4409-a937-ce03c1d8f599	089ada77-bd5c-4dad-be6d-a213a99325ae	Port	f6fc38ca-ddd3-46f6-85ab-a94bd994ea05	f9d9c8cb-d2a8-4419-acec-f27c9018d01b	2025-12-28 17:02:05.590626+00	2025-12-28 17:02:05.590626+00
a8b16eb1-9962-4680-b78a-029633c91e87	c394efe3-6cba-4409-a937-ce03c1d8f599	1539b872-a880-4dc3-8feb-bac7f28241c3	Port	affd57ac-b91f-4733-a7f6-09bc0647a5ee	c7ee7425-d3b5-429b-a8c1-ddd0329fded2	2025-12-28 17:02:25.837102+00	2025-12-28 17:02:25.837102+00
d88b25bc-9b26-4e14-a11e-60849c32a266	c394efe3-6cba-4409-a937-ce03c1d8f599	860b739b-9728-4110-a0bd-f93ce243112a	Port	834e5409-355c-4d5b-a399-9252eddf6c53	d6672c4f-cf3b-4767-84d6-6bdc2462099f	2025-12-28 17:03:07.293895+00	2025-12-28 17:03:07.293895+00
2144c4d2-6d73-48a8-a967-982f6bd97554	c394efe3-6cba-4409-a937-ce03c1d8f599	0abe66e1-ce26-4f0a-a42e-f130857a1b98	Port	66ddb373-9157-4a30-b666-88020e7d8399	b52b55bc-5c02-403c-a0e7-5b0ddbeed68d	2025-12-28 17:02:40.569698+00	2025-12-28 17:02:40.569698+00
7af90e74-26ee-428c-8eac-a5e6578bd241	c394efe3-6cba-4409-a937-ce03c1d8f599	38347847-bb6a-4ff8-8bce-026741ca9d2f	Port	66ddb373-9157-4a30-b666-88020e7d8399	7f50b722-f560-45a8-a2c7-44244df85285	2025-12-28 17:02:52.798388+00	2025-12-28 17:02:52.798388+00
2230346e-e988-41ad-aa57-f661f13f1eb8	c394efe3-6cba-4409-a937-ce03c1d8f599	392f679a-f0f1-405d-8481-c1a8284a6f63	Port	28289ee1-cde1-40ab-9860-8206c29bf957	8b6a36c7-6cc0-4e43-8e2c-2782d21fb89d	2025-12-28 17:03:17.577926+00	2025-12-28 17:03:17.577926+00
cbe4adea-d1c1-4b3b-8de7-634c6cfac455	c394efe3-6cba-4409-a937-ce03c1d8f599	1000629e-952c-4133-a66f-169d342f22a7	Port	28289ee1-cde1-40ab-9860-8206c29bf957	685e51f0-6a51-4b47-bd2f-c2e65737f507	2025-12-28 17:03:17.578078+00	2025-12-28 17:03:17.578078+00
f3c7ed16-cafa-4316-93d3-0fd15c8544fb	c394efe3-6cba-4409-a937-ce03c1d8f599	508f4afd-40bc-415d-82da-f5f5bbb84931	Port	28289ee1-cde1-40ab-9860-8206c29bf957	a712bfa5-a19c-487b-b04f-17c12e9a6746	2025-12-28 17:03:29.963682+00	2025-12-28 17:03:29.963682+00
fe867acc-c203-46ec-9d4e-f99012558ce8	c394efe3-6cba-4409-a937-ce03c1d8f599	0d534c3e-ab08-4c7e-8a58-7747b4f832cc	Port	28289ee1-cde1-40ab-9860-8206c29bf957	be920c77-bc8e-40c1-b0d9-fe2a65b9f00d	2025-12-28 17:03:29.964309+00	2025-12-28 17:03:29.964309+00
\.


--
-- Data for Name: daemons; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.daemons (id, network_id, host_id, created_at, last_seen, capabilities, updated_at, mode, url, name, tags) FROM stdin;
9ef4add6-d1c7-4367-9ff8-895c1ff4cc36	c394efe3-6cba-4409-a937-ce03c1d8f599	de3f5c6b-f9de-4f95-bad2-ce5ad10d9d1c	2025-12-28 17:02:05.447583+00	2025-12-28 17:03:21.88116+00	{"has_docker_socket": false, "interfaced_subnet_ids": ["23a71aa8-32b1-40e4-a9ad-87ba4c77347d"]}	2025-12-28 17:03:21.881738+00	"Push"	http://172.25.0.4:60073	scanopy-daemon	{}
\.


--
-- Data for Name: discovery; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.discovery (id, network_id, daemon_id, run_type, discovery_type, name, created_at, updated_at, tags) FROM stdin;
ca15c14a-aab4-4602-b421-07d25d1fbcc8	c394efe3-6cba-4409-a937-ce03c1d8f599	9ef4add6-d1c7-4367-9ff8-895c1ff4cc36	{"type": "Scheduled", "enabled": true, "last_run": null, "cron_schedule": "0 0 0 * * *"}	{"type": "SelfReport", "host_id": "de3f5c6b-f9de-4f95-bad2-ce5ad10d9d1c"}	Self Report	2025-12-28 17:02:05.453836+00	2025-12-28 17:02:05.453836+00	{}
4025542d-ffa2-4c9e-8077-6cdb3fb4f1d9	c394efe3-6cba-4409-a937-ce03c1d8f599	9ef4add6-d1c7-4367-9ff8-895c1ff4cc36	{"type": "Scheduled", "enabled": true, "last_run": null, "cron_schedule": "0 0 0 * * *"}	{"type": "Network", "subnet_ids": null, "host_naming_fallback": "BestService"}	Network Discovery	2025-12-28 17:02:05.460952+00	2025-12-28 17:02:05.460952+00	{}
87f5d260-46e0-40da-b35b-754311159f03	c394efe3-6cba-4409-a937-ce03c1d8f599	9ef4add6-d1c7-4367-9ff8-895c1ff4cc36	{"type": "Historical", "results": {"error": null, "phase": "Complete", "progress": 100, "daemon_id": "9ef4add6-d1c7-4367-9ff8-895c1ff4cc36", "network_id": "c394efe3-6cba-4409-a937-ce03c1d8f599", "session_id": "8ad1b89a-5993-4db3-8936-42a9c467b9bd", "started_at": "2025-12-28T17:02:05.460597229Z", "finished_at": "2025-12-28T17:02:05.637973401Z", "discovery_type": {"type": "SelfReport", "host_id": "de3f5c6b-f9de-4f95-bad2-ce5ad10d9d1c"}}}	{"type": "SelfReport", "host_id": "de3f5c6b-f9de-4f95-bad2-ce5ad10d9d1c"}	Self Report	2025-12-28 17:02:05.460597+00	2025-12-28 17:02:05.640541+00	{}
40da73b5-9ffa-4a0c-8f35-a3b835144118	c394efe3-6cba-4409-a937-ce03c1d8f599	9ef4add6-d1c7-4367-9ff8-895c1ff4cc36	{"type": "Historical", "results": {"error": null, "phase": "Complete", "progress": 100, "daemon_id": "9ef4add6-d1c7-4367-9ff8-895c1ff4cc36", "network_id": "c394efe3-6cba-4409-a937-ce03c1d8f599", "session_id": "a14ce38c-0cb8-487b-a44a-4043b7b2a4b9", "started_at": "2025-12-28T17:02:05.652432578Z", "finished_at": "2025-12-28T17:03:30.016504001Z", "discovery_type": {"type": "Network", "subnet_ids": null, "host_naming_fallback": "BestService"}}}	{"type": "Network", "subnet_ids": null, "host_naming_fallback": "BestService"}	Network Discovery	2025-12-28 17:02:05.652432+00	2025-12-28 17:03:30.018848+00	{}
\.


--
-- Data for Name: group_bindings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.group_bindings (id, group_id, binding_id, "position", created_at) FROM stdin;
\.


--
-- Data for Name: groups; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.groups (id, network_id, name, description, created_at, updated_at, source, color, edge_style, tags, group_type) FROM stdin;
8680500d-87ee-4eed-a10a-ab62d130e20c	c394efe3-6cba-4409-a937-ce03c1d8f599		\N	2025-12-28 17:03:30.031996+00	2025-12-28 17:03:30.031996+00	{"type": "Manual"}	Yellow	"SmoothStep"	{}	RequestPath
\.


--
-- Data for Name: hosts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.hosts (id, network_id, name, hostname, description, source, virtualization, created_at, updated_at, hidden, tags) FROM stdin;
de3f5c6b-f9de-4f95-bad2-ce5ad10d9d1c	c394efe3-6cba-4409-a937-ce03c1d8f599	scanopy-daemon	955e1353ae81	\N	{"type": "Discovery", "metadata": [{"date": "2025-12-28T17:02:05.590607862Z", "type": "SelfReport", "host_id": "de3f5c6b-f9de-4f95-bad2-ce5ad10d9d1c", "daemon_id": "9ef4add6-d1c7-4367-9ff8-895c1ff4cc36"}]}	null	2025-12-28 17:02:05.443762+00	2025-12-28 17:02:05.6038+00	f	{}
f478740d-1019-49c9-b984-f12aa7b2fb09	c394efe3-6cba-4409-a937-ce03c1d8f599	scanopy-server-1.scanopy_scanopy-dev	scanopy-server-1.scanopy_scanopy-dev	\N	{"type": "Discovery", "metadata": [{"date": "2025-12-28T17:02:23.563334244Z", "type": "Network", "daemon_id": "9ef4add6-d1c7-4367-9ff8-895c1ff4cc36", "subnet_ids": null, "host_naming_fallback": "BestService"}]}	null	2025-12-28 17:02:23.563335+00	2025-12-28 17:02:23.563335+00	f	{}
07e7afbe-7deb-40e8-a258-68216627fb5d	c394efe3-6cba-4409-a937-ce03c1d8f599	scanopy-postgres-dev-1.scanopy_scanopy-dev	scanopy-postgres-dev-1.scanopy_scanopy-dev	\N	{"type": "Discovery", "metadata": [{"date": "2025-12-28T17:02:52.799029808Z", "type": "Network", "daemon_id": "9ef4add6-d1c7-4367-9ff8-895c1ff4cc36", "subnet_ids": null, "host_naming_fallback": "BestService"}]}	null	2025-12-28 17:02:52.79903+00	2025-12-28 17:02:52.79903+00	f	{}
0d666645-37c4-4686-abd5-a27b2c094081	c394efe3-6cba-4409-a937-ce03c1d8f599	homeassistant-discovery.scanopy_scanopy-dev	homeassistant-discovery.scanopy_scanopy-dev	\N	{"type": "Discovery", "metadata": [{"date": "2025-12-28T17:02:38.320212041Z", "type": "Network", "daemon_id": "9ef4add6-d1c7-4367-9ff8-895c1ff4cc36", "subnet_ids": null, "host_naming_fallback": "BestService"}]}	null	2025-12-28 17:02:38.320213+00	2025-12-28 17:02:38.320213+00	f	{}
72917db7-a1f3-4ccd-b71d-9e28c6fd5f05	c394efe3-6cba-4409-a937-ce03c1d8f599	runnervmh13bl	runnervmh13bl	\N	{"type": "Discovery", "metadata": [{"date": "2025-12-28T17:03:15.361674793Z", "type": "Network", "daemon_id": "9ef4add6-d1c7-4367-9ff8-895c1ff4cc36", "subnet_ids": null, "host_naming_fallback": "BestService"}]}	null	2025-12-28 17:03:15.361675+00	2025-12-28 17:03:15.361675+00	f	{}
\.


--
-- Data for Name: interfaces; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.interfaces (id, network_id, host_id, subnet_id, ip_address, mac_address, name, "position", created_at, updated_at) FROM stdin;
f6fc38ca-ddd3-46f6-85ab-a94bd994ea05	c394efe3-6cba-4409-a937-ce03c1d8f599	de3f5c6b-f9de-4f95-bad2-ce5ad10d9d1c	23a71aa8-32b1-40e4-a9ad-87ba4c77347d	172.25.0.4	ae:b7:14:59:6d:78	eth0	0	2025-12-28 17:02:05.460796+00	2025-12-28 17:02:05.460796+00
affd57ac-b91f-4733-a7f6-09bc0647a5ee	c394efe3-6cba-4409-a937-ce03c1d8f599	f478740d-1019-49c9-b984-f12aa7b2fb09	23a71aa8-32b1-40e4-a9ad-87ba4c77347d	172.25.0.3	6a:95:c6:79:e8:40	\N	0	2025-12-28 17:02:23.563309+00	2025-12-28 17:02:23.563309+00
834e5409-355c-4d5b-a399-9252eddf6c53	c394efe3-6cba-4409-a937-ce03c1d8f599	07e7afbe-7deb-40e8-a258-68216627fb5d	23a71aa8-32b1-40e4-a9ad-87ba4c77347d	172.25.0.6	6a:ad:2a:62:9f:ff	\N	0	2025-12-28 17:02:52.799013+00	2025-12-28 17:02:52.799013+00
66ddb373-9157-4a30-b666-88020e7d8399	c394efe3-6cba-4409-a937-ce03c1d8f599	0d666645-37c4-4686-abd5-a27b2c094081	23a71aa8-32b1-40e4-a9ad-87ba4c77347d	172.25.0.5	06:7f:fa:19:73:89	\N	0	2025-12-28 17:02:38.32019+00	2025-12-28 17:02:38.32019+00
28289ee1-cde1-40ab-9860-8206c29bf957	c394efe3-6cba-4409-a937-ce03c1d8f599	72917db7-a1f3-4ccd-b71d-9e28c6fd5f05	23a71aa8-32b1-40e4-a9ad-87ba4c77347d	172.25.0.1	ce:2c:7f:0e:4e:49	\N	0	2025-12-28 17:03:15.361652+00	2025-12-28 17:03:15.361652+00
\.


--
-- Data for Name: invites; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.invites (id, organization_id, permissions, network_ids, url, created_by, created_at, updated_at, expires_at, send_to) FROM stdin;
\.


--
-- Data for Name: networks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.networks (id, name, created_at, updated_at, organization_id, tags) FROM stdin;
c394efe3-6cba-4409-a937-ce03c1d8f599	My Network	2025-12-28 17:02:05.33875+00	2025-12-28 17:02:05.33875+00	79863250-553a-4f03-bf34-e1537fcdf7d7	{}
\.


--
-- Data for Name: organizations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.organizations (id, name, stripe_customer_id, plan, plan_status, created_at, updated_at, onboarding) FROM stdin;
79863250-553a-4f03-bf34-e1537fcdf7d7	My Organization	\N	{"rate": "Month", "type": "Community", "base_cents": 0, "trial_days": 0}	active	2025-12-28 17:02:05.332907+00	2025-12-28 17:03:30.913363+00	["OnboardingModalCompleted", "FirstDaemonRegistered", "FirstApiKeyCreated"]
\.


--
-- Data for Name: ports; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ports (id, network_id, host_id, port_number, protocol, port_type, created_at, updated_at) FROM stdin;
f9d9c8cb-d2a8-4419-acec-f27c9018d01b	c394efe3-6cba-4409-a937-ce03c1d8f599	de3f5c6b-f9de-4f95-bad2-ce5ad10d9d1c	60073	Tcp	Custom	2025-12-28 17:02:05.590412+00	2025-12-28 17:02:05.590412+00
c7ee7425-d3b5-429b-a8c1-ddd0329fded2	c394efe3-6cba-4409-a937-ce03c1d8f599	f478740d-1019-49c9-b984-f12aa7b2fb09	60072	Tcp	Custom	2025-12-28 17:02:25.83709+00	2025-12-28 17:02:25.83709+00
d6672c4f-cf3b-4767-84d6-6bdc2462099f	c394efe3-6cba-4409-a937-ce03c1d8f599	07e7afbe-7deb-40e8-a258-68216627fb5d	5432	Tcp	PostgreSQL	2025-12-28 17:03:07.293886+00	2025-12-28 17:03:07.293886+00
b52b55bc-5c02-403c-a0e7-5b0ddbeed68d	c394efe3-6cba-4409-a937-ce03c1d8f599	0d666645-37c4-4686-abd5-a27b2c094081	8123	Tcp	Custom	2025-12-28 17:02:40.569686+00	2025-12-28 17:02:40.569686+00
7f50b722-f560-45a8-a2c7-44244df85285	c394efe3-6cba-4409-a937-ce03c1d8f599	0d666645-37c4-4686-abd5-a27b2c094081	18555	Tcp	Custom	2025-12-28 17:02:52.798376+00	2025-12-28 17:02:52.798376+00
8b6a36c7-6cc0-4e43-8e2c-2782d21fb89d	c394efe3-6cba-4409-a937-ce03c1d8f599	72917db7-a1f3-4ccd-b71d-9e28c6fd5f05	60072	Tcp	Custom	2025-12-28 17:03:17.577913+00	2025-12-28 17:03:17.577913+00
685e51f0-6a51-4b47-bd2f-c2e65737f507	c394efe3-6cba-4409-a937-ce03c1d8f599	72917db7-a1f3-4ccd-b71d-9e28c6fd5f05	8123	Tcp	Custom	2025-12-28 17:03:17.578073+00	2025-12-28 17:03:17.578073+00
a712bfa5-a19c-487b-b04f-17c12e9a6746	c394efe3-6cba-4409-a937-ce03c1d8f599	72917db7-a1f3-4ccd-b71d-9e28c6fd5f05	22	Tcp	Ssh	2025-12-28 17:03:29.963672+00	2025-12-28 17:03:29.963672+00
be920c77-bc8e-40c1-b0d9-fe2a65b9f00d	c394efe3-6cba-4409-a937-ce03c1d8f599	72917db7-a1f3-4ccd-b71d-9e28c6fd5f05	5435	Tcp	Custom	2025-12-28 17:03:29.964305+00	2025-12-28 17:03:29.964305+00
\.


--
-- Data for Name: services; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.services (id, network_id, created_at, updated_at, name, host_id, service_definition, virtualization, source, tags) FROM stdin;
089ada77-bd5c-4dad-be6d-a213a99325ae	c394efe3-6cba-4409-a937-ce03c1d8f599	2025-12-28 17:02:05.59063+00	2025-12-28 17:02:05.59063+00	Scanopy Daemon	de3f5c6b-f9de-4f95-bad2-ce5ad10d9d1c	"Scanopy Daemon"	null	{"type": "DiscoveryWithMatch", "details": {"reason": {"data": "Scanopy Daemon self-report", "type": "reason"}, "confidence": "Certain"}, "metadata": [{"date": "2025-12-28T17:02:05.590629302Z", "type": "SelfReport", "host_id": "de3f5c6b-f9de-4f95-bad2-ce5ad10d9d1c", "daemon_id": "9ef4add6-d1c7-4367-9ff8-895c1ff4cc36"}]}	{}
1539b872-a880-4dc3-8feb-bac7f28241c3	c394efe3-6cba-4409-a937-ce03c1d8f599	2025-12-28 17:02:25.837105+00	2025-12-28 17:02:25.837105+00	Scanopy Server	f478740d-1019-49c9-b984-f12aa7b2fb09	"Scanopy Server"	null	{"type": "DiscoveryWithMatch", "details": {"reason": {"data": "Response for 172.25.0.3:60072/api/health contained \\"scanopy\\" in body", "type": "reason"}, "confidence": "High"}, "metadata": [{"date": "2025-12-28T17:02:25.837085435Z", "type": "Network", "daemon_id": "9ef4add6-d1c7-4367-9ff8-895c1ff4cc36", "subnet_ids": null, "host_naming_fallback": "BestService"}]}	{}
860b739b-9728-4110-a0bd-f93ce243112a	c394efe3-6cba-4409-a937-ce03c1d8f599	2025-12-28 17:03:07.293898+00	2025-12-28 17:03:07.293898+00	PostgreSQL	07e7afbe-7deb-40e8-a258-68216627fb5d	"PostgreSQL"	null	{"type": "DiscoveryWithMatch", "details": {"reason": {"data": ["Generic service", [{"data": "Port 5432/tcp is open", "type": "reason"}]], "type": "container"}, "confidence": "NotApplicable"}, "metadata": [{"date": "2025-12-28T17:03:07.293881769Z", "type": "Network", "daemon_id": "9ef4add6-d1c7-4367-9ff8-895c1ff4cc36", "subnet_ids": null, "host_naming_fallback": "BestService"}]}	{}
0abe66e1-ce26-4f0a-a42e-f130857a1b98	c394efe3-6cba-4409-a937-ce03c1d8f599	2025-12-28 17:02:40.569716+00	2025-12-28 17:02:40.569716+00	Home Assistant	0d666645-37c4-4686-abd5-a27b2c094081	"Home Assistant"	null	{"type": "DiscoveryWithMatch", "details": {"reason": {"data": "Response for 172.25.0.5:8123/ contained \\"home assistant\\" in body", "type": "reason"}, "confidence": "High"}, "metadata": [{"date": "2025-12-28T17:02:40.569681036Z", "type": "Network", "daemon_id": "9ef4add6-d1c7-4367-9ff8-895c1ff4cc36", "subnet_ids": null, "host_naming_fallback": "BestService"}]}	{}
38347847-bb6a-4ff8-8bce-026741ca9d2f	c394efe3-6cba-4409-a937-ce03c1d8f599	2025-12-28 17:02:52.798392+00	2025-12-28 17:02:52.798392+00	Unclaimed Open Ports	0d666645-37c4-4686-abd5-a27b2c094081	"Unclaimed Open Ports"	null	{"type": "DiscoveryWithMatch", "details": {"reason": {"data": ["Generic service", [{"data": "Has unbound open ports", "type": "reason"}]], "type": "container"}, "confidence": "NotApplicable"}, "metadata": [{"date": "2025-12-28T17:02:52.798371249Z", "type": "Network", "daemon_id": "9ef4add6-d1c7-4367-9ff8-895c1ff4cc36", "subnet_ids": null, "host_naming_fallback": "BestService"}]}	{}
392f679a-f0f1-405d-8481-c1a8284a6f63	c394efe3-6cba-4409-a937-ce03c1d8f599	2025-12-28 17:03:17.577929+00	2025-12-28 17:03:17.577929+00	Scanopy Server	72917db7-a1f3-4ccd-b71d-9e28c6fd5f05	"Scanopy Server"	null	{"type": "DiscoveryWithMatch", "details": {"reason": {"data": "Response for 172.25.0.1:60072/api/health contained \\"scanopy\\" in body", "type": "reason"}, "confidence": "High"}, "metadata": [{"date": "2025-12-28T17:03:17.577908927Z", "type": "Network", "daemon_id": "9ef4add6-d1c7-4367-9ff8-895c1ff4cc36", "subnet_ids": null, "host_naming_fallback": "BestService"}]}	{}
1000629e-952c-4133-a66f-169d342f22a7	c394efe3-6cba-4409-a937-ce03c1d8f599	2025-12-28 17:03:17.57808+00	2025-12-28 17:03:17.57808+00	Home Assistant	72917db7-a1f3-4ccd-b71d-9e28c6fd5f05	"Home Assistant"	null	{"type": "DiscoveryWithMatch", "details": {"reason": {"data": "Response for 172.25.0.1:8123/ contained \\"home assistant\\" in body", "type": "reason"}, "confidence": "High"}, "metadata": [{"date": "2025-12-28T17:03:17.578071550Z", "type": "Network", "daemon_id": "9ef4add6-d1c7-4367-9ff8-895c1ff4cc36", "subnet_ids": null, "host_naming_fallback": "BestService"}]}	{}
508f4afd-40bc-415d-82da-f5f5bbb84931	c394efe3-6cba-4409-a937-ce03c1d8f599	2025-12-28 17:03:29.963686+00	2025-12-28 17:03:29.963686+00	SSH	72917db7-a1f3-4ccd-b71d-9e28c6fd5f05	"SSH"	null	{"type": "DiscoveryWithMatch", "details": {"reason": {"data": ["Generic service", [{"data": "Port 22/tcp is open", "type": "reason"}]], "type": "container"}, "confidence": "NotApplicable"}, "metadata": [{"date": "2025-12-28T17:03:29.963667905Z", "type": "Network", "daemon_id": "9ef4add6-d1c7-4367-9ff8-895c1ff4cc36", "subnet_ids": null, "host_naming_fallback": "BestService"}]}	{}
0d534c3e-ab08-4c7e-8a58-7747b4f832cc	c394efe3-6cba-4409-a937-ce03c1d8f599	2025-12-28 17:03:29.964312+00	2025-12-28 17:03:29.964312+00	Unclaimed Open Ports	72917db7-a1f3-4ccd-b71d-9e28c6fd5f05	"Unclaimed Open Ports"	null	{"type": "DiscoveryWithMatch", "details": {"reason": {"data": ["Generic service", [{"data": "Has unbound open ports", "type": "reason"}]], "type": "container"}, "confidence": "NotApplicable"}, "metadata": [{"date": "2025-12-28T17:03:29.964303080Z", "type": "Network", "daemon_id": "9ef4add6-d1c7-4367-9ff8-895c1ff4cc36", "subnet_ids": null, "host_naming_fallback": "BestService"}]}	{}
\.


--
-- Data for Name: shares; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.shares (id, topology_id, network_id, created_by, name, is_enabled, expires_at, password_hash, allowed_domains, options, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: subnets; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.subnets (id, network_id, created_at, updated_at, cidr, name, description, subnet_type, source, tags) FROM stdin;
c3c66128-881f-4ba6-9851-d496e458a9e7	c394efe3-6cba-4409-a937-ce03c1d8f599	2025-12-28 17:02:05.34063+00	2025-12-28 17:02:05.34063+00	"0.0.0.0/0"	Internet	This subnet uses the 0.0.0.0/0 CIDR as an organizational container for services running on the internet (e.g., public DNS servers, cloud services, etc.).	Internet	{"type": "System"}	{}
6318d0d9-c021-4d05-b1a9-7d30cbf12114	c394efe3-6cba-4409-a937-ce03c1d8f599	2025-12-28 17:02:05.340633+00	2025-12-28 17:02:05.340633+00	"0.0.0.0/0"	Remote Network	This subnet uses the 0.0.0.0/0 CIDR as an organizational container for hosts on remote networks (e.g., mobile connections, friend's networks, public WiFi, etc.).	Remote	{"type": "System"}	{}
23a71aa8-32b1-40e4-a9ad-87ba4c77347d	c394efe3-6cba-4409-a937-ce03c1d8f599	2025-12-28 17:02:05.460774+00	2025-12-28 17:02:05.460774+00	"172.25.0.0/28"	172.25.0.0/28	\N	Lan	{"type": "Discovery", "metadata": [{"date": "2025-12-28T17:02:05.460773047Z", "type": "SelfReport", "host_id": "de3f5c6b-f9de-4f95-bad2-ce5ad10d9d1c", "daemon_id": "9ef4add6-d1c7-4367-9ff8-895c1ff4cc36"}]}	{}
\.


--
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tags (id, organization_id, name, description, created_at, updated_at, color) FROM stdin;
cb655f33-6e32-4fa2-9e73-fa0471414602	79863250-553a-4f03-bf34-e1537fcdf7d7	New Tag	\N	2025-12-28 17:03:30.04378+00	2025-12-28 17:03:30.04378+00	Yellow
\.


--
-- Data for Name: topologies; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.topologies (id, network_id, name, edges, nodes, options, hosts, subnets, services, groups, is_stale, last_refreshed, is_locked, locked_at, locked_by, removed_hosts, removed_services, removed_subnets, removed_groups, parent_id, created_at, updated_at, tags, interfaces, removed_interfaces, ports, removed_ports, bindings, removed_bindings) FROM stdin;
74b90801-84e1-4e04-889f-6c6461acae15	c394efe3-6cba-4409-a937-ce03c1d8f599	My Topology	[]	[]	{"local": {"no_fade_edges": false, "hide_edge_types": [], "left_zone_title": "Infrastructure", "hide_resize_handles": false}, "request": {"hide_ports": false, "hide_service_categories": [], "show_gateway_in_left_zone": true, "group_docker_bridges_by_host": true, "left_zone_service_categories": ["DNS", "ReverseProxy"], "hide_vm_title_on_docker_container": false}}	[{"id": "de3f5c6b-f9de-4f95-bad2-ce5ad10d9d1c", "name": "scanopy-daemon", "tags": [], "hidden": false, "source": {"type": "Discovery", "metadata": [{"date": "2025-12-28T17:02:05.590607862Z", "type": "SelfReport", "host_id": "de3f5c6b-f9de-4f95-bad2-ce5ad10d9d1c", "daemon_id": "9ef4add6-d1c7-4367-9ff8-895c1ff4cc36"}]}, "hostname": "955e1353ae81", "created_at": "2025-12-28T17:02:05.443762Z", "network_id": "c394efe3-6cba-4409-a937-ce03c1d8f599", "updated_at": "2025-12-28T17:02:05.603800Z", "description": null, "virtualization": null}, {"id": "f478740d-1019-49c9-b984-f12aa7b2fb09", "name": "scanopy-server-1.scanopy_scanopy-dev", "tags": [], "hidden": false, "source": {"type": "Discovery", "metadata": [{"date": "2025-12-28T17:02:23.563334244Z", "type": "Network", "daemon_id": "9ef4add6-d1c7-4367-9ff8-895c1ff4cc36", "subnet_ids": null, "host_naming_fallback": "BestService"}]}, "hostname": "scanopy-server-1.scanopy_scanopy-dev", "created_at": "2025-12-28T17:02:23.563335Z", "network_id": "c394efe3-6cba-4409-a937-ce03c1d8f599", "updated_at": "2025-12-28T17:02:23.563335Z", "description": null, "virtualization": null}, {"id": "0d666645-37c4-4686-abd5-a27b2c094081", "name": "homeassistant-discovery.scanopy_scanopy-dev", "tags": [], "hidden": false, "source": {"type": "Discovery", "metadata": [{"date": "2025-12-28T17:02:38.320212041Z", "type": "Network", "daemon_id": "9ef4add6-d1c7-4367-9ff8-895c1ff4cc36", "subnet_ids": null, "host_naming_fallback": "BestService"}]}, "hostname": "homeassistant-discovery.scanopy_scanopy-dev", "created_at": "2025-12-28T17:02:38.320213Z", "network_id": "c394efe3-6cba-4409-a937-ce03c1d8f599", "updated_at": "2025-12-28T17:02:38.320213Z", "description": null, "virtualization": null}, {"id": "07e7afbe-7deb-40e8-a258-68216627fb5d", "name": "scanopy-postgres-dev-1.scanopy_scanopy-dev", "tags": [], "hidden": false, "source": {"type": "Discovery", "metadata": [{"date": "2025-12-28T17:02:52.799029808Z", "type": "Network", "daemon_id": "9ef4add6-d1c7-4367-9ff8-895c1ff4cc36", "subnet_ids": null, "host_naming_fallback": "BestService"}]}, "hostname": "scanopy-postgres-dev-1.scanopy_scanopy-dev", "created_at": "2025-12-28T17:02:52.799030Z", "network_id": "c394efe3-6cba-4409-a937-ce03c1d8f599", "updated_at": "2025-12-28T17:02:52.799030Z", "description": null, "virtualization": null}, {"id": "72917db7-a1f3-4ccd-b71d-9e28c6fd5f05", "name": "runnervmh13bl", "tags": [], "hidden": false, "source": {"type": "Discovery", "metadata": [{"date": "2025-12-28T17:03:15.361674793Z", "type": "Network", "daemon_id": "9ef4add6-d1c7-4367-9ff8-895c1ff4cc36", "subnet_ids": null, "host_naming_fallback": "BestService"}]}, "hostname": "runnervmh13bl", "created_at": "2025-12-28T17:03:15.361675Z", "network_id": "c394efe3-6cba-4409-a937-ce03c1d8f599", "updated_at": "2025-12-28T17:03:15.361675Z", "description": null, "virtualization": null}]	[{"id": "c3c66128-881f-4ba6-9851-d496e458a9e7", "cidr": "0.0.0.0/0", "name": "Internet", "tags": [], "source": {"type": "System"}, "created_at": "2025-12-28T17:02:05.340630Z", "network_id": "c394efe3-6cba-4409-a937-ce03c1d8f599", "updated_at": "2025-12-28T17:02:05.340630Z", "description": "This subnet uses the 0.0.0.0/0 CIDR as an organizational container for services running on the internet (e.g., public DNS servers, cloud services, etc.).", "subnet_type": "Internet"}, {"id": "6318d0d9-c021-4d05-b1a9-7d30cbf12114", "cidr": "0.0.0.0/0", "name": "Remote Network", "tags": [], "source": {"type": "System"}, "created_at": "2025-12-28T17:02:05.340633Z", "network_id": "c394efe3-6cba-4409-a937-ce03c1d8f599", "updated_at": "2025-12-28T17:02:05.340633Z", "description": "This subnet uses the 0.0.0.0/0 CIDR as an organizational container for hosts on remote networks (e.g., mobile connections, friend's networks, public WiFi, etc.).", "subnet_type": "Remote"}, {"id": "23a71aa8-32b1-40e4-a9ad-87ba4c77347d", "cidr": "172.25.0.0/28", "name": "172.25.0.0/28", "tags": [], "source": {"type": "Discovery", "metadata": [{"date": "2025-12-28T17:02:05.460773047Z", "type": "SelfReport", "host_id": "de3f5c6b-f9de-4f95-bad2-ce5ad10d9d1c", "daemon_id": "9ef4add6-d1c7-4367-9ff8-895c1ff4cc36"}]}, "created_at": "2025-12-28T17:02:05.460774Z", "network_id": "c394efe3-6cba-4409-a937-ce03c1d8f599", "updated_at": "2025-12-28T17:02:05.460774Z", "description": null, "subnet_type": "Lan"}]	[{"id": "089ada77-bd5c-4dad-be6d-a213a99325ae", "name": "Scanopy Daemon", "tags": [], "source": {"type": "DiscoveryWithMatch", "details": {"reason": {"data": "Scanopy Daemon self-report", "type": "reason"}, "confidence": "Certain"}, "metadata": [{"date": "2025-12-28T17:02:05.590629302Z", "type": "SelfReport", "host_id": "de3f5c6b-f9de-4f95-bad2-ce5ad10d9d1c", "daemon_id": "9ef4add6-d1c7-4367-9ff8-895c1ff4cc36"}]}, "host_id": "de3f5c6b-f9de-4f95-bad2-ce5ad10d9d1c", "bindings": [{"id": "56d24ea2-7b1a-4c36-83b7-d288a99a631b", "type": "Port", "port_id": "f9d9c8cb-d2a8-4419-acec-f27c9018d01b", "created_at": "2025-12-28T17:02:05.590626Z", "network_id": "c394efe3-6cba-4409-a937-ce03c1d8f599", "service_id": "089ada77-bd5c-4dad-be6d-a213a99325ae", "updated_at": "2025-12-28T17:02:05.590626Z", "interface_id": "f6fc38ca-ddd3-46f6-85ab-a94bd994ea05"}], "created_at": "2025-12-28T17:02:05.590630Z", "network_id": "c394efe3-6cba-4409-a937-ce03c1d8f599", "updated_at": "2025-12-28T17:02:05.590630Z", "virtualization": null, "service_definition": "Scanopy Daemon"}, {"id": "1539b872-a880-4dc3-8feb-bac7f28241c3", "name": "Scanopy Server", "tags": [], "source": {"type": "DiscoveryWithMatch", "details": {"reason": {"data": "Response for 172.25.0.3:60072/api/health contained \\"scanopy\\" in body", "type": "reason"}, "confidence": "High"}, "metadata": [{"date": "2025-12-28T17:02:25.837085435Z", "type": "Network", "daemon_id": "9ef4add6-d1c7-4367-9ff8-895c1ff4cc36", "subnet_ids": null, "host_naming_fallback": "BestService"}]}, "host_id": "f478740d-1019-49c9-b984-f12aa7b2fb09", "bindings": [{"id": "a8b16eb1-9962-4680-b78a-029633c91e87", "type": "Port", "port_id": "c7ee7425-d3b5-429b-a8c1-ddd0329fded2", "created_at": "2025-12-28T17:02:25.837102Z", "network_id": "c394efe3-6cba-4409-a937-ce03c1d8f599", "service_id": "1539b872-a880-4dc3-8feb-bac7f28241c3", "updated_at": "2025-12-28T17:02:25.837102Z", "interface_id": "affd57ac-b91f-4733-a7f6-09bc0647a5ee"}], "created_at": "2025-12-28T17:02:25.837105Z", "network_id": "c394efe3-6cba-4409-a937-ce03c1d8f599", "updated_at": "2025-12-28T17:02:25.837105Z", "virtualization": null, "service_definition": "Scanopy Server"}, {"id": "0abe66e1-ce26-4f0a-a42e-f130857a1b98", "name": "Home Assistant", "tags": [], "source": {"type": "DiscoveryWithMatch", "details": {"reason": {"data": "Response for 172.25.0.5:8123/ contained \\"home assistant\\" in body", "type": "reason"}, "confidence": "High"}, "metadata": [{"date": "2025-12-28T17:02:40.569681036Z", "type": "Network", "daemon_id": "9ef4add6-d1c7-4367-9ff8-895c1ff4cc36", "subnet_ids": null, "host_naming_fallback": "BestService"}]}, "host_id": "0d666645-37c4-4686-abd5-a27b2c094081", "bindings": [{"id": "2144c4d2-6d73-48a8-a967-982f6bd97554", "type": "Port", "port_id": "b52b55bc-5c02-403c-a0e7-5b0ddbeed68d", "created_at": "2025-12-28T17:02:40.569698Z", "network_id": "c394efe3-6cba-4409-a937-ce03c1d8f599", "service_id": "0abe66e1-ce26-4f0a-a42e-f130857a1b98", "updated_at": "2025-12-28T17:02:40.569698Z", "interface_id": "66ddb373-9157-4a30-b666-88020e7d8399"}], "created_at": "2025-12-28T17:02:40.569716Z", "network_id": "c394efe3-6cba-4409-a937-ce03c1d8f599", "updated_at": "2025-12-28T17:02:40.569716Z", "virtualization": null, "service_definition": "Home Assistant"}, {"id": "38347847-bb6a-4ff8-8bce-026741ca9d2f", "name": "Unclaimed Open Ports", "tags": [], "source": {"type": "DiscoveryWithMatch", "details": {"reason": {"data": ["Generic service", [{"data": "Has unbound open ports", "type": "reason"}]], "type": "container"}, "confidence": "NotApplicable"}, "metadata": [{"date": "2025-12-28T17:02:52.798371249Z", "type": "Network", "daemon_id": "9ef4add6-d1c7-4367-9ff8-895c1ff4cc36", "subnet_ids": null, "host_naming_fallback": "BestService"}]}, "host_id": "0d666645-37c4-4686-abd5-a27b2c094081", "bindings": [{"id": "7af90e74-26ee-428c-8eac-a5e6578bd241", "type": "Port", "port_id": "7f50b722-f560-45a8-a2c7-44244df85285", "created_at": "2025-12-28T17:02:52.798388Z", "network_id": "c394efe3-6cba-4409-a937-ce03c1d8f599", "service_id": "38347847-bb6a-4ff8-8bce-026741ca9d2f", "updated_at": "2025-12-28T17:02:52.798388Z", "interface_id": "66ddb373-9157-4a30-b666-88020e7d8399"}], "created_at": "2025-12-28T17:02:52.798392Z", "network_id": "c394efe3-6cba-4409-a937-ce03c1d8f599", "updated_at": "2025-12-28T17:02:52.798392Z", "virtualization": null, "service_definition": "Unclaimed Open Ports"}, {"id": "860b739b-9728-4110-a0bd-f93ce243112a", "name": "PostgreSQL", "tags": [], "source": {"type": "DiscoveryWithMatch", "details": {"reason": {"data": ["Generic service", [{"data": "Port 5432/tcp is open", "type": "reason"}]], "type": "container"}, "confidence": "NotApplicable"}, "metadata": [{"date": "2025-12-28T17:03:07.293881769Z", "type": "Network", "daemon_id": "9ef4add6-d1c7-4367-9ff8-895c1ff4cc36", "subnet_ids": null, "host_naming_fallback": "BestService"}]}, "host_id": "07e7afbe-7deb-40e8-a258-68216627fb5d", "bindings": [{"id": "d88b25bc-9b26-4e14-a11e-60849c32a266", "type": "Port", "port_id": "d6672c4f-cf3b-4767-84d6-6bdc2462099f", "created_at": "2025-12-28T17:03:07.293895Z", "network_id": "c394efe3-6cba-4409-a937-ce03c1d8f599", "service_id": "860b739b-9728-4110-a0bd-f93ce243112a", "updated_at": "2025-12-28T17:03:07.293895Z", "interface_id": "834e5409-355c-4d5b-a399-9252eddf6c53"}], "created_at": "2025-12-28T17:03:07.293898Z", "network_id": "c394efe3-6cba-4409-a937-ce03c1d8f599", "updated_at": "2025-12-28T17:03:07.293898Z", "virtualization": null, "service_definition": "PostgreSQL"}, {"id": "392f679a-f0f1-405d-8481-c1a8284a6f63", "name": "Scanopy Server", "tags": [], "source": {"type": "DiscoveryWithMatch", "details": {"reason": {"data": "Response for 172.25.0.1:60072/api/health contained \\"scanopy\\" in body", "type": "reason"}, "confidence": "High"}, "metadata": [{"date": "2025-12-28T17:03:17.577908927Z", "type": "Network", "daemon_id": "9ef4add6-d1c7-4367-9ff8-895c1ff4cc36", "subnet_ids": null, "host_naming_fallback": "BestService"}]}, "host_id": "72917db7-a1f3-4ccd-b71d-9e28c6fd5f05", "bindings": [{"id": "2230346e-e988-41ad-aa57-f661f13f1eb8", "type": "Port", "port_id": "8b6a36c7-6cc0-4e43-8e2c-2782d21fb89d", "created_at": "2025-12-28T17:03:17.577926Z", "network_id": "c394efe3-6cba-4409-a937-ce03c1d8f599", "service_id": "392f679a-f0f1-405d-8481-c1a8284a6f63", "updated_at": "2025-12-28T17:03:17.577926Z", "interface_id": "28289ee1-cde1-40ab-9860-8206c29bf957"}], "created_at": "2025-12-28T17:03:17.577929Z", "network_id": "c394efe3-6cba-4409-a937-ce03c1d8f599", "updated_at": "2025-12-28T17:03:17.577929Z", "virtualization": null, "service_definition": "Scanopy Server"}, {"id": "1000629e-952c-4133-a66f-169d342f22a7", "name": "Home Assistant", "tags": [], "source": {"type": "DiscoveryWithMatch", "details": {"reason": {"data": "Response for 172.25.0.1:8123/ contained \\"home assistant\\" in body", "type": "reason"}, "confidence": "High"}, "metadata": [{"date": "2025-12-28T17:03:17.578071550Z", "type": "Network", "daemon_id": "9ef4add6-d1c7-4367-9ff8-895c1ff4cc36", "subnet_ids": null, "host_naming_fallback": "BestService"}]}, "host_id": "72917db7-a1f3-4ccd-b71d-9e28c6fd5f05", "bindings": [{"id": "cbe4adea-d1c1-4b3b-8de7-634c6cfac455", "type": "Port", "port_id": "685e51f0-6a51-4b47-bd2f-c2e65737f507", "created_at": "2025-12-28T17:03:17.578078Z", "network_id": "c394efe3-6cba-4409-a937-ce03c1d8f599", "service_id": "1000629e-952c-4133-a66f-169d342f22a7", "updated_at": "2025-12-28T17:03:17.578078Z", "interface_id": "28289ee1-cde1-40ab-9860-8206c29bf957"}], "created_at": "2025-12-28T17:03:17.578080Z", "network_id": "c394efe3-6cba-4409-a937-ce03c1d8f599", "updated_at": "2025-12-28T17:03:17.578080Z", "virtualization": null, "service_definition": "Home Assistant"}, {"id": "508f4afd-40bc-415d-82da-f5f5bbb84931", "name": "SSH", "tags": [], "source": {"type": "DiscoveryWithMatch", "details": {"reason": {"data": ["Generic service", [{"data": "Port 22/tcp is open", "type": "reason"}]], "type": "container"}, "confidence": "NotApplicable"}, "metadata": [{"date": "2025-12-28T17:03:29.963667905Z", "type": "Network", "daemon_id": "9ef4add6-d1c7-4367-9ff8-895c1ff4cc36", "subnet_ids": null, "host_naming_fallback": "BestService"}]}, "host_id": "72917db7-a1f3-4ccd-b71d-9e28c6fd5f05", "bindings": [{"id": "f3c7ed16-cafa-4316-93d3-0fd15c8544fb", "type": "Port", "port_id": "a712bfa5-a19c-487b-b04f-17c12e9a6746", "created_at": "2025-12-28T17:03:29.963682Z", "network_id": "c394efe3-6cba-4409-a937-ce03c1d8f599", "service_id": "508f4afd-40bc-415d-82da-f5f5bbb84931", "updated_at": "2025-12-28T17:03:29.963682Z", "interface_id": "28289ee1-cde1-40ab-9860-8206c29bf957"}], "created_at": "2025-12-28T17:03:29.963686Z", "network_id": "c394efe3-6cba-4409-a937-ce03c1d8f599", "updated_at": "2025-12-28T17:03:29.963686Z", "virtualization": null, "service_definition": "SSH"}, {"id": "0d534c3e-ab08-4c7e-8a58-7747b4f832cc", "name": "Unclaimed Open Ports", "tags": [], "source": {"type": "DiscoveryWithMatch", "details": {"reason": {"data": ["Generic service", [{"data": "Has unbound open ports", "type": "reason"}]], "type": "container"}, "confidence": "NotApplicable"}, "metadata": [{"date": "2025-12-28T17:03:29.964303080Z", "type": "Network", "daemon_id": "9ef4add6-d1c7-4367-9ff8-895c1ff4cc36", "subnet_ids": null, "host_naming_fallback": "BestService"}]}, "host_id": "72917db7-a1f3-4ccd-b71d-9e28c6fd5f05", "bindings": [{"id": "fe867acc-c203-46ec-9d4e-f99012558ce8", "type": "Port", "port_id": "be920c77-bc8e-40c1-b0d9-fe2a65b9f00d", "created_at": "2025-12-28T17:03:29.964309Z", "network_id": "c394efe3-6cba-4409-a937-ce03c1d8f599", "service_id": "0d534c3e-ab08-4c7e-8a58-7747b4f832cc", "updated_at": "2025-12-28T17:03:29.964309Z", "interface_id": "28289ee1-cde1-40ab-9860-8206c29bf957"}], "created_at": "2025-12-28T17:03:29.964312Z", "network_id": "c394efe3-6cba-4409-a937-ce03c1d8f599", "updated_at": "2025-12-28T17:03:29.964312Z", "virtualization": null, "service_definition": "Unclaimed Open Ports"}]	[{"id": "8680500d-87ee-4eed-a10a-ab62d130e20c", "name": "", "tags": [], "color": "Yellow", "source": {"type": "Manual"}, "created_at": "2025-12-28T17:03:30.031996Z", "edge_style": "SmoothStep", "group_type": "RequestPath", "network_id": "c394efe3-6cba-4409-a937-ce03c1d8f599", "updated_at": "2025-12-28T17:03:30.031996Z", "binding_ids": [], "description": null}]	t	2025-12-28 17:02:05.394611+00	f	\N	\N	{a2c2ea96-a3b1-423e-b01d-392a98a3ebf2,779e5546-0a98-485b-8387-b3256e0bd789,e4da1337-fedf-4367-9380-31be8a22347c}	{96d69fb4-9352-4db8-913d-d5ef4ca9a27c}	{57bdb177-2049-4f63-921f-c3658fd181b9}	{fc3b699b-d153-498a-8a32-06af3c78f090}	\N	2025-12-28 17:02:05.344548+00	2025-12-28 17:03:31.790192+00	{}	[]	{}	[]	{}	[]	{}
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
12136210-0136-49ee-b6e9-0414e5954552	2025-12-28 17:02:05.33591+00	2025-12-28 17:02:05.33591+00	$argon2id$v=19$m=19456,t=2,p=1$lnCkmc0J7h9TrbTW5YDWEA$KkzcGahyfq0BfCrAw5MTyxgml47Hv1wMxqh+8u+n4OI	\N	\N	\N	user@gmail.com	79863250-553a-4f03-bf34-e1537fcdf7d7	Owner	{}	\N
\.


--
-- Data for Name: session; Type: TABLE DATA; Schema: tower_sessions; Owner: postgres
--

COPY tower_sessions.session (id, data, expiry_date) FROM stdin;
JbsH_TzhS2ZmRUGgagSK-Q	\\x93c410f98a046aa0414566664be13cfd07bb2581a7757365725f6964d92431323133363231302d303133362d343965652d623665392d30343134653539353435353299cd07ea1b110205ce1e1694f6000000	2026-01-27 17:02:05.504796+00
jgTcUrQa8ATJnuL6zKpEmw	\\x93c4109b44aaccfae29ec904f01ab452dc048e82a7757365725f6964d92431323133363231302d303133362d343965652d623665392d303431346535393534353532ad70656e64696e675f736574757082a86e6574776f726b739182a46e616d65aa4d79204e6574776f726baa6e6574776f726b5f6964d92436323934306165622d633433632d343738332d613932362d656237393930646664633436a86f72675f6e616d65af4d79204f7267616e697a6174696f6e99cd07ea1b11031ece26603413000000	2026-01-27 17:03:30.643838+00
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
-- Name: tags trigger_remove_deleted_tag_from_entities; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_remove_deleted_tag_from_entities BEFORE DELETE ON public.tags FOR EACH ROW EXECUTE FUNCTION public.remove_deleted_tag_from_entities();


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

\unrestrict vtksb0ELwzvsxhxgxgLqrLloUPNbC0seeKqf5FW5fNJ6nHjGutcYbRpqsmv4vhl

