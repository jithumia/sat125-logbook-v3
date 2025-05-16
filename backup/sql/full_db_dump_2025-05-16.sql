--
-- PostgreSQL database dump
--

-- Dumped from database version 15.8
-- Dumped by pg_dump version 15.8

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
-- Name: _realtime; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA _realtime;


ALTER SCHEMA _realtime OWNER TO postgres;

--
-- Name: auth; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA auth;


ALTER SCHEMA auth OWNER TO supabase_admin;

--
-- Name: extensions; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA extensions;


ALTER SCHEMA extensions OWNER TO postgres;

--
-- Name: graphql; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA graphql;


ALTER SCHEMA graphql OWNER TO supabase_admin;

--
-- Name: graphql_public; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA graphql_public;


ALTER SCHEMA graphql_public OWNER TO supabase_admin;

--
-- Name: pg_net; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_net WITH SCHEMA extensions;


--
-- Name: EXTENSION pg_net; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_net IS 'Async HTTP';


--
-- Name: pgbouncer; Type: SCHEMA; Schema: -; Owner: pgbouncer
--

CREATE SCHEMA pgbouncer;


ALTER SCHEMA pgbouncer OWNER TO pgbouncer;

--
-- Name: pgsodium; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA pgsodium;


ALTER SCHEMA pgsodium OWNER TO supabase_admin;

--
-- Name: pgsodium; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgsodium WITH SCHEMA pgsodium;


--
-- Name: EXTENSION pgsodium; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgsodium IS 'Pgsodium is a modern cryptography library for Postgres.';


--
-- Name: realtime; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA realtime;


ALTER SCHEMA realtime OWNER TO supabase_admin;

--
-- Name: storage; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA storage;


ALTER SCHEMA storage OWNER TO supabase_admin;

--
-- Name: supabase_functions; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA supabase_functions;


ALTER SCHEMA supabase_functions OWNER TO supabase_admin;

--
-- Name: supabase_migrations; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA supabase_migrations;


ALTER SCHEMA supabase_migrations OWNER TO postgres;

--
-- Name: vault; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA vault;


ALTER SCHEMA vault OWNER TO supabase_admin;

--
-- Name: pg_graphql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_graphql WITH SCHEMA graphql;


--
-- Name: EXTENSION pg_graphql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_graphql IS 'pg_graphql: GraphQL support';


--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA extensions;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA extensions;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: pgjwt; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgjwt WITH SCHEMA extensions;


--
-- Name: EXTENSION pgjwt; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgjwt IS 'JSON Web Token API for Postgresql';


--
-- Name: supabase_vault; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS supabase_vault WITH SCHEMA vault;


--
-- Name: EXTENSION supabase_vault; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION supabase_vault IS 'Supabase Vault Extension';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA extensions;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: aal_level; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.aal_level AS ENUM (
    'aal1',
    'aal2',
    'aal3'
);


ALTER TYPE auth.aal_level OWNER TO supabase_auth_admin;

--
-- Name: code_challenge_method; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.code_challenge_method AS ENUM (
    's256',
    'plain'
);


ALTER TYPE auth.code_challenge_method OWNER TO supabase_auth_admin;

--
-- Name: factor_status; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.factor_status AS ENUM (
    'unverified',
    'verified'
);


ALTER TYPE auth.factor_status OWNER TO supabase_auth_admin;

--
-- Name: factor_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.factor_type AS ENUM (
    'totp',
    'webauthn',
    'phone'
);


ALTER TYPE auth.factor_type OWNER TO supabase_auth_admin;

--
-- Name: one_time_token_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.one_time_token_type AS ENUM (
    'confirmation_token',
    'reauthentication_token',
    'recovery_token',
    'email_change_token_new',
    'email_change_token_current',
    'phone_change_token'
);


ALTER TYPE auth.one_time_token_type OWNER TO supabase_auth_admin;

--
-- Name: log_category; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.log_category AS ENUM (
    'error',
    'general',
    'downtime',
    'workorder',
    'data-collection',
    'shift',
    'data-mc',
    'data-sc'
);


ALTER TYPE public.log_category OWNER TO postgres;

--
-- Name: shift_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.shift_type AS ENUM (
    'morning',
    'afternoon',
    'night'
);


ALTER TYPE public.shift_type OWNER TO postgres;

--
-- Name: status_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.status_type AS ENUM (
    'open',
    'in_progress',
    'closed',
    'pending'
);


ALTER TYPE public.status_type OWNER TO postgres;

--
-- Name: action; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.action AS ENUM (
    'INSERT',
    'UPDATE',
    'DELETE',
    'TRUNCATE',
    'ERROR'
);


ALTER TYPE realtime.action OWNER TO supabase_admin;

--
-- Name: equality_op; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.equality_op AS ENUM (
    'eq',
    'neq',
    'lt',
    'lte',
    'gt',
    'gte',
    'in'
);


ALTER TYPE realtime.equality_op OWNER TO supabase_admin;

--
-- Name: user_defined_filter; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.user_defined_filter AS (
	column_name text,
	op realtime.equality_op,
	value text
);


ALTER TYPE realtime.user_defined_filter OWNER TO supabase_admin;

--
-- Name: wal_column; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.wal_column AS (
	name text,
	type_name text,
	type_oid oid,
	value jsonb,
	is_pkey boolean,
	is_selectable boolean
);


ALTER TYPE realtime.wal_column OWNER TO supabase_admin;

--
-- Name: wal_rls; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.wal_rls AS (
	wal jsonb,
	is_rls_enabled boolean,
	subscription_ids uuid[],
	errors text[]
);


ALTER TYPE realtime.wal_rls OWNER TO supabase_admin;

--
-- Name: email(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.email() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.email', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'email')
  )::text
$$;


ALTER FUNCTION auth.email() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION email(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.email() IS 'Deprecated. Use auth.jwt() -> ''email'' instead.';


--
-- Name: jwt(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.jwt() RETURNS jsonb
    LANGUAGE sql STABLE
    AS $$
  select 
    coalesce(
        nullif(current_setting('request.jwt.claim', true), ''),
        nullif(current_setting('request.jwt.claims', true), '')
    )::jsonb
$$;


ALTER FUNCTION auth.jwt() OWNER TO supabase_auth_admin;

--
-- Name: role(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.role() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.role', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'role')
  )::text
$$;


ALTER FUNCTION auth.role() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION role(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.role() IS 'Deprecated. Use auth.jwt() -> ''role'' instead.';


--
-- Name: uid(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.uid() RETURNS uuid
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.sub', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'sub')
  )::uuid
$$;


ALTER FUNCTION auth.uid() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION uid(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.uid() IS 'Deprecated. Use auth.jwt() -> ''sub'' instead.';


--
-- Name: grant_pg_cron_access(); Type: FUNCTION; Schema: extensions; Owner: postgres
--

CREATE FUNCTION extensions.grant_pg_cron_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_cron'
  )
  THEN
    grant usage on schema cron to postgres with grant option;

    alter default privileges in schema cron grant all on tables to postgres with grant option;
    alter default privileges in schema cron grant all on functions to postgres with grant option;
    alter default privileges in schema cron grant all on sequences to postgres with grant option;

    alter default privileges for user supabase_admin in schema cron grant all
        on sequences to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on tables to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on functions to postgres with grant option;

    grant all privileges on all tables in schema cron to postgres with grant option;
    revoke all on table cron.job from postgres;
    grant select on table cron.job to postgres with grant option;
  END IF;
END;
$$;


ALTER FUNCTION extensions.grant_pg_cron_access() OWNER TO postgres;

--
-- Name: FUNCTION grant_pg_cron_access(); Type: COMMENT; Schema: extensions; Owner: postgres
--

COMMENT ON FUNCTION extensions.grant_pg_cron_access() IS 'Grants access to pg_cron';


--
-- Name: grant_pg_graphql_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_graphql_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
DECLARE
    func_is_graphql_resolve bool;
BEGIN
    func_is_graphql_resolve = (
        SELECT n.proname = 'resolve'
        FROM pg_event_trigger_ddl_commands() AS ev
        LEFT JOIN pg_catalog.pg_proc AS n
        ON ev.objid = n.oid
    );

    IF func_is_graphql_resolve
    THEN
        -- Update public wrapper to pass all arguments through to the pg_graphql resolve func
        DROP FUNCTION IF EXISTS graphql_public.graphql;
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language sql
        as $$
            select graphql.resolve(
                query := query,
                variables := coalesce(variables, '{}'),
                "operationName" := "operationName",
                extensions := extensions
            );
        $$;

        -- This hook executes when `graphql.resolve` is created. That is not necessarily the last
        -- function in the extension so we need to grant permissions on existing entities AND
        -- update default permissions to any others that are created after `graphql.resolve`
        grant usage on schema graphql to postgres, anon, authenticated, service_role;
        grant select on all tables in schema graphql to postgres, anon, authenticated, service_role;
        grant execute on all functions in schema graphql to postgres, anon, authenticated, service_role;
        grant all on all sequences in schema graphql to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on tables to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on functions to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on sequences to postgres, anon, authenticated, service_role;

        -- Allow postgres role to allow granting usage on graphql and graphql_public schemas to custom roles
        grant usage on schema graphql_public to postgres with grant option;
        grant usage on schema graphql to postgres with grant option;
    END IF;

END;
$_$;


ALTER FUNCTION extensions.grant_pg_graphql_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_graphql_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_graphql_access() IS 'Grants access to pg_graphql';


--
-- Name: grant_pg_net_access(); Type: FUNCTION; Schema: extensions; Owner: postgres
--

CREATE FUNCTION extensions.grant_pg_net_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_net'
  )
  THEN
    GRANT USAGE ON SCHEMA net TO supabase_functions_admin, postgres, anon, authenticated, service_role;

    ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;
    ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;

    ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;
    ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;

    REVOKE ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
    REVOKE ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;

    GRANT EXECUTE ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
    GRANT EXECUTE ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
  END IF;
END;
$$;


ALTER FUNCTION extensions.grant_pg_net_access() OWNER TO postgres;

--
-- Name: FUNCTION grant_pg_net_access(); Type: COMMENT; Schema: extensions; Owner: postgres
--

COMMENT ON FUNCTION extensions.grant_pg_net_access() IS 'Grants access to pg_net';


--
-- Name: pgrst_ddl_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.pgrst_ddl_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  cmd record;
BEGIN
  FOR cmd IN SELECT * FROM pg_event_trigger_ddl_commands()
  LOOP
    IF cmd.command_tag IN (
      'CREATE SCHEMA', 'ALTER SCHEMA'
    , 'CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO', 'ALTER TABLE'
    , 'CREATE FOREIGN TABLE', 'ALTER FOREIGN TABLE'
    , 'CREATE VIEW', 'ALTER VIEW'
    , 'CREATE MATERIALIZED VIEW', 'ALTER MATERIALIZED VIEW'
    , 'CREATE FUNCTION', 'ALTER FUNCTION'
    , 'CREATE TRIGGER'
    , 'CREATE TYPE', 'ALTER TYPE'
    , 'CREATE RULE'
    , 'COMMENT'
    )
    -- don't notify in case of CREATE TEMP table or other objects created on pg_temp
    AND cmd.schema_name is distinct from 'pg_temp'
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_ddl_watch() OWNER TO supabase_admin;

--
-- Name: pgrst_drop_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.pgrst_drop_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  obj record;
BEGIN
  FOR obj IN SELECT * FROM pg_event_trigger_dropped_objects()
  LOOP
    IF obj.object_type IN (
      'schema'
    , 'table'
    , 'foreign table'
    , 'view'
    , 'materialized view'
    , 'function'
    , 'trigger'
    , 'type'
    , 'rule'
    )
    AND obj.is_temporary IS false -- no pg_temp objects
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_drop_watch() OWNER TO supabase_admin;

--
-- Name: set_graphql_placeholder(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.set_graphql_placeholder() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
    DECLARE
    graphql_is_dropped bool;
    BEGIN
    graphql_is_dropped = (
        SELECT ev.schema_name = 'graphql_public'
        FROM pg_event_trigger_dropped_objects() AS ev
        WHERE ev.schema_name = 'graphql_public'
    );

    IF graphql_is_dropped
    THEN
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language plpgsql
        as $$
            DECLARE
                server_version float;
            BEGIN
                server_version = (SELECT (SPLIT_PART((select version()), ' ', 2))::float);

                IF server_version >= 14 THEN
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql extension is not enabled.'
                            )
                        )
                    );
                ELSE
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql is only available on projects running Postgres 14 onwards.'
                            )
                        )
                    );
                END IF;
            END;
        $$;
    END IF;

    END;
$_$;


ALTER FUNCTION extensions.set_graphql_placeholder() OWNER TO supabase_admin;

--
-- Name: FUNCTION set_graphql_placeholder(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.set_graphql_placeholder() IS 'Reintroduces placeholder function for graphql_public.graphql';


--
-- Name: get_auth(text); Type: FUNCTION; Schema: pgbouncer; Owner: supabase_admin
--

CREATE FUNCTION pgbouncer.get_auth(p_usename text) RETURNS TABLE(username text, password text)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RAISE WARNING 'PgBouncer auth request: %', p_usename;

    RETURN QUERY
    SELECT usename::TEXT, passwd::TEXT FROM pg_catalog.pg_shadow
    WHERE usename = p_usename;
END;
$$;


ALTER FUNCTION pgbouncer.get_auth(p_usename text) OWNER TO supabase_admin;

--
-- Name: check_active_shift(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.check_active_shift() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Check if there's already an active shift
  IF EXISTS (
    SELECT 1 FROM active_shifts 
    WHERE id != COALESCE(NEW.id, '00000000-0000-0000-0000-000000000000')
  ) THEN
    RAISE EXCEPTION 'Another shift is already active';
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.check_active_shift() OWNER TO postgres;

--
-- Name: check_active_shifts(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.check_active_shifts() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM public.active_shifts 
        WHERE shift_type = NEW.shift_type 
        AND id != NEW.id
    ) THEN
        RAISE EXCEPTION 'Another shift is already active for this shift type';
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.check_active_shifts() OWNER TO postgres;

--
-- Name: cleanup_shifts(uuid[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.cleanup_shifts(shift_ids uuid[]) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Delete the shift engineers first
    DELETE FROM public.shift_engineers
    WHERE shift_id = ANY(shift_ids);
    
    -- Then delete the active shift
    DELETE FROM public.active_shifts
    WHERE id = ANY(shift_ids);
END;
$$;


ALTER FUNCTION public.cleanup_shifts(shift_ids uuid[]) OWNER TO postgres;

--
-- Name: restore_active_shift_on_end_log_delete(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.restore_active_shift_on_end_log_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  start_log RECORD;
  end_log RECORD;
  existing_active_shift RECORD;
  salesforce_number TEXT;
BEGIN
  -- Only act if the deleted log is a 'shift ended' log
  IF OLD.category = 'shift' AND OLD.description ILIKE '%shift ended%' THEN
    -- Find the most recent 'shift started' log for the same shift_type before the deleted end log
    SELECT * INTO start_log
    FROM log_entries
    WHERE category = 'shift'
      AND shift_type = OLD.shift_type
      AND created_at < OLD.created_at
      AND description ILIKE '%shift started%'
    ORDER BY created_at DESC
    LIMIT 1;

    IF start_log IS NOT NULL THEN
      -- Check if there is any other 'shift ended' log after this start log
      SELECT * INTO end_log
      FROM log_entries
      WHERE category = 'shift'
        AND shift_type = OLD.shift_type
        AND created_at > start_log.created_at
        AND description ILIKE '%shift ended%'
      ORDER BY created_at ASC
      LIMIT 1;

      -- Only restore if there is no other end log after the start log
      IF end_log IS NULL THEN
        -- Check if an active shift already exists
        SELECT * INTO existing_active_shift
        FROM active_shifts
        WHERE shift_type = start_log.shift_type
        ORDER BY started_at DESC
        LIMIT 1;

        IF existing_active_shift IS NULL THEN
          -- Extract Salesforce number from the description if possible
          salesforce_number := regexp_replace(start_log.description, '.*SF#: ([^\\)]*).*', '\\1');

          -- Insert the active shift
          INSERT INTO active_shifts (shift_type, started_by, salesforce_number, started_at)
          VALUES (start_log.shift_type, start_log.user_id, salesforce_number, start_log.created_at);
        END IF;
      END IF;
    END IF;
  END IF;
  RETURN OLD;
END;
$$;


ALTER FUNCTION public.restore_active_shift_on_end_log_delete() OWNER TO postgres;

--
-- Name: start_new_shift(public.shift_type, uuid, text, uuid[], text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.start_new_shift(p_shift_type public.shift_type, p_started_by uuid, p_salesforce_number text, p_engineer_ids uuid[], p_description text) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  v_shift_id uuid;
  v_result json;
  v_existing_shifts uuid[];
BEGIN
  -- Start transaction
  BEGIN
    -- Get IDs of any existing active shifts
    SELECT array_agg(id)
    INTO v_existing_shifts
    FROM active_shifts;

    -- Only perform cleanup if there are existing shifts
    IF v_existing_shifts IS NOT NULL AND array_length(v_existing_shifts, 1) > 0 THEN
      -- Delete shift engineers first due to foreign key constraint
      DELETE FROM shift_engineers
      WHERE shift_id = ANY(v_existing_shifts);

      -- Then delete the active shifts
      DELETE FROM active_shifts
      WHERE id = ANY(v_existing_shifts);
    END IF;

    -- Create new active shift
    INSERT INTO active_shifts (
      shift_type,
      started_at,
      started_by,
      salesforce_number
    ) VALUES (
      p_shift_type,
      now(),
      p_started_by,
      p_salesforce_number
    ) RETURNING id INTO v_shift_id;

    -- Add engineers to shift
    INSERT INTO shift_engineers (shift_id, engineer_id)
    SELECT v_shift_id, unnest(p_engineer_ids);

    -- Create log entry
    INSERT INTO log_entries (
      shift_type,
      category,
      description,
      user_id
    ) VALUES (
      p_shift_type,
      'shift',
      p_description,
      p_started_by
    );

    -- Get the complete shift data
    SELECT row_to_json(t)
    INTO v_result
    FROM (
      SELECT a.*, 
        (
          SELECT json_agg(row_to_json(e))
          FROM (
            SELECT eng.*
            FROM engineers eng
            JOIN shift_engineers se ON se.engineer_id = eng.id
            WHERE se.shift_id = a.id
          ) e
        ) as engineers
      FROM active_shifts a
      WHERE a.id = v_shift_id
    ) t;

    RETURN v_result;
  EXCEPTION
    WHEN OTHERS THEN
      -- Rollback is automatic
      RAISE;
  END;
END;
$$;


ALTER FUNCTION public.start_new_shift(p_shift_type public.shift_type, p_started_by uuid, p_salesforce_number text, p_engineer_ids uuid[], p_description text) OWNER TO postgres;

--
-- Name: upsert_log_suggestion(public.log_category, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.upsert_log_suggestion(p_category public.log_category, p_description text) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  -- Validate inputs
  IF p_description IS NULL OR trim(p_description) = '' THEN
    RAISE EXCEPTION 'Description cannot be empty';
  END IF;

  -- Insert or update the suggestion
  INSERT INTO log_suggestions (
    category,
    description,
    usage_count,
    last_used
  )
  VALUES (
    p_category,
    trim(p_description),
    1,
    now()
  )
  ON CONFLICT (category, description) 
  DO UPDATE SET 
    usage_count = log_suggestions.usage_count + 1,
    last_used = now();

EXCEPTION
  WHEN OTHERS THEN
    -- Add context to the error
    RAISE EXCEPTION 'Error in upsert_log_suggestion: %', SQLERRM;
END;
$$;


ALTER FUNCTION public.upsert_log_suggestion(p_category public.log_category, p_description text) OWNER TO postgres;

--
-- Name: apply_rls(jsonb, integer); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer DEFAULT (1024 * 1024)) RETURNS SETOF realtime.wal_rls
    LANGUAGE plpgsql
    AS $$
declare
-- Regclass of the table e.g. public.notes
entity_ regclass = (quote_ident(wal ->> 'schema') || '.' || quote_ident(wal ->> 'table'))::regclass;

-- I, U, D, T: insert, update ...
action realtime.action = (
    case wal ->> 'action'
        when 'I' then 'INSERT'
        when 'U' then 'UPDATE'
        when 'D' then 'DELETE'
        else 'ERROR'
    end
);

-- Is row level security enabled for the table
is_rls_enabled bool = relrowsecurity from pg_class where oid = entity_;

subscriptions realtime.subscription[] = array_agg(subs)
    from
        realtime.subscription subs
    where
        subs.entity = entity_;

-- Subscription vars
roles regrole[] = array_agg(distinct us.claims_role::text)
    from
        unnest(subscriptions) us;

working_role regrole;
claimed_role regrole;
claims jsonb;

subscription_id uuid;
subscription_has_access bool;
visible_to_subscription_ids uuid[] = '{}';

-- structured info for wal's columns
columns realtime.wal_column[];
-- previous identity values for update/delete
old_columns realtime.wal_column[];

error_record_exceeds_max_size boolean = octet_length(wal::text) > max_record_bytes;

-- Primary jsonb output for record
output jsonb;

begin
perform set_config('role', null, true);

columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'columns') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

old_columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'identity') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

for working_role in select * from unnest(roles) loop

    -- Update `is_selectable` for columns and old_columns
    columns =
        array_agg(
            (
                c.name,
                c.type_name,
                c.type_oid,
                c.value,
                c.is_pkey,
                pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
            )::realtime.wal_column
        )
        from
            unnest(columns) c;

    old_columns =
            array_agg(
                (
                    c.name,
                    c.type_name,
                    c.type_oid,
                    c.value,
                    c.is_pkey,
                    pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
                )::realtime.wal_column
            )
            from
                unnest(old_columns) c;

    if action <> 'DELETE' and count(1) = 0 from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            -- subscriptions is already filtered by entity
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 400: Bad Request, no primary key']
        )::realtime.wal_rls;

    -- The claims role does not have SELECT permission to the primary key of entity
    elsif action <> 'DELETE' and sum(c.is_selectable::int) <> count(1) from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 401: Unauthorized']
        )::realtime.wal_rls;

    else
        output = jsonb_build_object(
            'schema', wal ->> 'schema',
            'table', wal ->> 'table',
            'type', action,
            'commit_timestamp', to_char(
                ((wal ->> 'timestamp')::timestamptz at time zone 'utc'),
                'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"'
            ),
            'columns', (
                select
                    jsonb_agg(
                        jsonb_build_object(
                            'name', pa.attname,
                            'type', pt.typname
                        )
                        order by pa.attnum asc
                    )
                from
                    pg_attribute pa
                    join pg_type pt
                        on pa.atttypid = pt.oid
                where
                    attrelid = entity_
                    and attnum > 0
                    and pg_catalog.has_column_privilege(working_role, entity_, pa.attname, 'SELECT')
            )
        )
        -- Add "record" key for insert and update
        || case
            when action in ('INSERT', 'UPDATE') then
                jsonb_build_object(
                    'record',
                    (
                        select
                            jsonb_object_agg(
                                -- if unchanged toast, get column name and value from old record
                                coalesce((c).name, (oc).name),
                                case
                                    when (c).name is null then (oc).value
                                    else (c).value
                                end
                            )
                        from
                            unnest(columns) c
                            full outer join unnest(old_columns) oc
                                on (c).name = (oc).name
                        where
                            coalesce((c).is_selectable, (oc).is_selectable)
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                    )
                )
            else '{}'::jsonb
        end
        -- Add "old_record" key for update and delete
        || case
            when action = 'UPDATE' then
                jsonb_build_object(
                        'old_record',
                        (
                            select jsonb_object_agg((c).name, (c).value)
                            from unnest(old_columns) c
                            where
                                (c).is_selectable
                                and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                        )
                    )
            when action = 'DELETE' then
                jsonb_build_object(
                    'old_record',
                    (
                        select jsonb_object_agg((c).name, (c).value)
                        from unnest(old_columns) c
                        where
                            (c).is_selectable
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                            and ( not is_rls_enabled or (c).is_pkey ) -- if RLS enabled, we can't secure deletes so filter to pkey
                    )
                )
            else '{}'::jsonb
        end;

        -- Create the prepared statement
        if is_rls_enabled and action <> 'DELETE' then
            if (select 1 from pg_prepared_statements where name = 'walrus_rls_stmt' limit 1) > 0 then
                deallocate walrus_rls_stmt;
            end if;
            execute realtime.build_prepared_statement_sql('walrus_rls_stmt', entity_, columns);
        end if;

        visible_to_subscription_ids = '{}';

        for subscription_id, claims in (
                select
                    subs.subscription_id,
                    subs.claims
                from
                    unnest(subscriptions) subs
                where
                    subs.entity = entity_
                    and subs.claims_role = working_role
                    and (
                        realtime.is_visible_through_filters(columns, subs.filters)
                        or (
                          action = 'DELETE'
                          and realtime.is_visible_through_filters(old_columns, subs.filters)
                        )
                    )
        ) loop

            if not is_rls_enabled or action = 'DELETE' then
                visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
            else
                -- Check if RLS allows the role to see the record
                perform
                    -- Trim leading and trailing quotes from working_role because set_config
                    -- doesn't recognize the role as valid if they are included
                    set_config('role', trim(both '"' from working_role::text), true),
                    set_config('request.jwt.claims', claims::text, true);

                execute 'execute walrus_rls_stmt' into subscription_has_access;

                if subscription_has_access then
                    visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
                end if;
            end if;
        end loop;

        perform set_config('role', null, true);

        return next (
            output,
            is_rls_enabled,
            visible_to_subscription_ids,
            case
                when error_record_exceeds_max_size then array['Error 413: Payload Too Large']
                else '{}'
            end
        )::realtime.wal_rls;

    end if;
end loop;

perform set_config('role', null, true);
end;
$$;


ALTER FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) OWNER TO supabase_admin;

--
-- Name: broadcast_changes(text, text, text, text, text, record, record, text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text DEFAULT 'ROW'::text) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    -- Declare a variable to hold the JSONB representation of the row
    row_data jsonb := '{}'::jsonb;
BEGIN
    IF level = 'STATEMENT' THEN
        RAISE EXCEPTION 'function can only be triggered for each row, not for each statement';
    END IF;
    -- Check the operation type and handle accordingly
    IF operation = 'INSERT' OR operation = 'UPDATE' OR operation = 'DELETE' THEN
        row_data := jsonb_build_object('old_record', OLD, 'record', NEW, 'operation', operation, 'table', table_name, 'schema', table_schema);
        PERFORM realtime.send (row_data, event_name, topic_name);
    ELSE
        RAISE EXCEPTION 'Unexpected operation type: %', operation;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Failed to process the row: %', SQLERRM;
END;

$$;


ALTER FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) OWNER TO supabase_admin;

--
-- Name: build_prepared_statement_sql(text, regclass, realtime.wal_column[]); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) RETURNS text
    LANGUAGE sql
    AS $$
      /*
      Builds a sql string that, if executed, creates a prepared statement to
      tests retrive a row from *entity* by its primary key columns.
      Example
          select realtime.build_prepared_statement_sql('public.notes', '{"id"}'::text[], '{"bigint"}'::text[])
      */
          select
      'prepare ' || prepared_statement_name || ' as
          select
              exists(
                  select
                      1
                  from
                      ' || entity || '
                  where
                      ' || string_agg(quote_ident(pkc.name) || '=' || quote_nullable(pkc.value #>> '{}') , ' and ') || '
              )'
          from
              unnest(columns) pkc
          where
              pkc.is_pkey
          group by
              entity
      $$;


ALTER FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) OWNER TO supabase_admin;

--
-- Name: cast(text, regtype); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime."cast"(val text, type_ regtype) RETURNS jsonb
    LANGUAGE plpgsql IMMUTABLE
    AS $$
    declare
      res jsonb;
    begin
      execute format('select to_jsonb(%L::'|| type_::text || ')', val)  into res;
      return res;
    end
    $$;


ALTER FUNCTION realtime."cast"(val text, type_ regtype) OWNER TO supabase_admin;

--
-- Name: check_equality_op(realtime.equality_op, regtype, text, text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $$
      /*
      Casts *val_1* and *val_2* as type *type_* and check the *op* condition for truthiness
      */
      declare
          op_symbol text = (
              case
                  when op = 'eq' then '='
                  when op = 'neq' then '!='
                  when op = 'lt' then '<'
                  when op = 'lte' then '<='
                  when op = 'gt' then '>'
                  when op = 'gte' then '>='
                  when op = 'in' then '= any'
                  else 'UNKNOWN OP'
              end
          );
          res boolean;
      begin
          execute format(
              'select %L::'|| type_::text || ' ' || op_symbol
              || ' ( %L::'
              || (
                  case
                      when op = 'in' then type_::text || '[]'
                      else type_::text end
              )
              || ')', val_1, val_2) into res;
          return res;
      end;
      $$;


ALTER FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) OWNER TO supabase_admin;

--
-- Name: is_visible_through_filters(realtime.wal_column[], realtime.user_defined_filter[]); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$
    /*
    Should the record be visible (true) or filtered out (false) after *filters* are applied
    */
        select
            -- Default to allowed when no filters present
            $2 is null -- no filters. this should not happen because subscriptions has a default
            or array_length($2, 1) is null -- array length of an empty array is null
            or bool_and(
                coalesce(
                    realtime.check_equality_op(
                        op:=f.op,
                        type_:=coalesce(
                            col.type_oid::regtype, -- null when wal2json version <= 2.4
                            col.type_name::regtype
                        ),
                        -- cast jsonb to text
                        val_1:=col.value #>> '{}',
                        val_2:=f.value
                    ),
                    false -- if null, filter does not match
                )
            )
        from
            unnest(filters) f
            join unnest(columns) col
                on f.column_name = col.name;
    $_$;


ALTER FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) OWNER TO supabase_admin;

--
-- Name: list_changes(name, name, integer, integer); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) RETURNS SETOF realtime.wal_rls
    LANGUAGE sql
    SET log_min_messages TO 'fatal'
    AS $$
      with pub as (
        select
          concat_ws(
            ',',
            case when bool_or(pubinsert) then 'insert' else null end,
            case when bool_or(pubupdate) then 'update' else null end,
            case when bool_or(pubdelete) then 'delete' else null end
          ) as w2j_actions,
          coalesce(
            string_agg(
              realtime.quote_wal2json(format('%I.%I', schemaname, tablename)::regclass),
              ','
            ) filter (where ppt.tablename is not null and ppt.tablename not like '% %'),
            ''
          ) w2j_add_tables
        from
          pg_publication pp
          left join pg_publication_tables ppt
            on pp.pubname = ppt.pubname
        where
          pp.pubname = publication
        group by
          pp.pubname
        limit 1
      ),
      w2j as (
        select
          x.*, pub.w2j_add_tables
        from
          pub,
          pg_logical_slot_get_changes(
            slot_name, null, max_changes,
            'include-pk', 'true',
            'include-transaction', 'false',
            'include-timestamp', 'true',
            'include-type-oids', 'true',
            'format-version', '2',
            'actions', pub.w2j_actions,
            'add-tables', pub.w2j_add_tables
          ) x
      )
      select
        xyz.wal,
        xyz.is_rls_enabled,
        xyz.subscription_ids,
        xyz.errors
      from
        w2j,
        realtime.apply_rls(
          wal := w2j.data::jsonb,
          max_record_bytes := max_record_bytes
        ) xyz(wal, is_rls_enabled, subscription_ids, errors)
      where
        w2j.w2j_add_tables <> ''
        and xyz.subscription_ids[1] is not null
    $$;


ALTER FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) OWNER TO supabase_admin;

--
-- Name: quote_wal2json(regclass); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.quote_wal2json(entity regclass) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
      select
        (
          select string_agg('' || ch,'')
          from unnest(string_to_array(nsp.nspname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
        )
        || '.'
        || (
          select string_agg('' || ch,'')
          from unnest(string_to_array(pc.relname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
          )
      from
        pg_class pc
        join pg_namespace nsp
          on pc.relnamespace = nsp.oid
      where
        pc.oid = entity
    $$;


ALTER FUNCTION realtime.quote_wal2json(entity regclass) OWNER TO supabase_admin;

--
-- Name: send(jsonb, text, text, boolean); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  BEGIN
    -- Set the topic configuration
    EXECUTE format('SET LOCAL realtime.topic TO %L', topic);

    -- Attempt to insert the message
    INSERT INTO realtime.messages (payload, event, topic, private, extension)
    VALUES (payload, event, topic, private, 'broadcast');
  EXCEPTION
    WHEN OTHERS THEN
      -- Capture and notify the error
      PERFORM pg_notify(
          'realtime:system',
          jsonb_build_object(
              'error', SQLERRM,
              'function', 'realtime.send',
              'event', event,
              'topic', topic,
              'private', private
          )::text
      );
  END;
END;
$$;


ALTER FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) OWNER TO supabase_admin;

--
-- Name: subscription_check_filters(); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.subscription_check_filters() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    /*
    Validates that the user defined filters for a subscription:
    - refer to valid columns that the claimed role may access
    - values are coercable to the correct column type
    */
    declare
        col_names text[] = coalesce(
                array_agg(c.column_name order by c.ordinal_position),
                '{}'::text[]
            )
            from
                information_schema.columns c
            where
                format('%I.%I', c.table_schema, c.table_name)::regclass = new.entity
                and pg_catalog.has_column_privilege(
                    (new.claims ->> 'role'),
                    format('%I.%I', c.table_schema, c.table_name)::regclass,
                    c.column_name,
                    'SELECT'
                );
        filter realtime.user_defined_filter;
        col_type regtype;

        in_val jsonb;
    begin
        for filter in select * from unnest(new.filters) loop
            -- Filtered column is valid
            if not filter.column_name = any(col_names) then
                raise exception 'invalid column for filter %', filter.column_name;
            end if;

            -- Type is sanitized and safe for string interpolation
            col_type = (
                select atttypid::regtype
                from pg_catalog.pg_attribute
                where attrelid = new.entity
                      and attname = filter.column_name
            );
            if col_type is null then
                raise exception 'failed to lookup type for column %', filter.column_name;
            end if;

            -- Set maximum number of entries for in filter
            if filter.op = 'in'::realtime.equality_op then
                in_val = realtime.cast(filter.value, (col_type::text || '[]')::regtype);
                if coalesce(jsonb_array_length(in_val), 0) > 100 then
                    raise exception 'too many values for `in` filter. Maximum 100';
                end if;
            else
                -- raises an exception if value is not coercable to type
                perform realtime.cast(filter.value, col_type);
            end if;

        end loop;

        -- Apply consistent order to filters so the unique constraint on
        -- (subscription_id, entity, filters) can't be tricked by a different filter order
        new.filters = coalesce(
            array_agg(f order by f.column_name, f.op, f.value),
            '{}'
        ) from unnest(new.filters) f;

        return new;
    end;
    $$;


ALTER FUNCTION realtime.subscription_check_filters() OWNER TO supabase_admin;

--
-- Name: to_regrole(text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.to_regrole(role_name text) RETURNS regrole
    LANGUAGE sql IMMUTABLE
    AS $$ select role_name::regrole $$;


ALTER FUNCTION realtime.to_regrole(role_name text) OWNER TO supabase_admin;

--
-- Name: topic(); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.topic() RETURNS text
    LANGUAGE sql STABLE
    AS $$
select nullif(current_setting('realtime.topic', true), '')::text;
$$;


ALTER FUNCTION realtime.topic() OWNER TO supabase_realtime_admin;

--
-- Name: can_insert_object(text, text, uuid, jsonb); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO "storage"."objects" ("bucket_id", "name", "owner", "metadata") VALUES (bucketid, name, owner, metadata);
  -- hack to rollback the successful insert
  RAISE sqlstate 'PT200' using
  message = 'ROLLBACK',
  detail = 'rollback successful insert';
END
$$;


ALTER FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) OWNER TO supabase_storage_admin;

--
-- Name: extension(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.extension(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
_filename text;
BEGIN
	select string_to_array(name, '/') into _parts;
	select _parts[array_length(_parts,1)] into _filename;
	-- @todo return the last part instead of 2
	return reverse(split_part(reverse(_filename), '.', 1));
END
$$;


ALTER FUNCTION storage.extension(name text) OWNER TO supabase_storage_admin;

--
-- Name: filename(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.filename(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
	select string_to_array(name, '/') into _parts;
	return _parts[array_length(_parts,1)];
END
$$;


ALTER FUNCTION storage.filename(name text) OWNER TO supabase_storage_admin;

--
-- Name: foldername(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.foldername(name text) RETURNS text[]
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
	select string_to_array(name, '/') into _parts;
	return _parts[1:array_length(_parts,1)-1];
END
$$;


ALTER FUNCTION storage.foldername(name text) OWNER TO supabase_storage_admin;

--
-- Name: get_size_by_bucket(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_size_by_bucket() RETURNS TABLE(size bigint, bucket_id text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    return query
        select sum((metadata->>'size')::int) as size, obj.bucket_id
        from "storage".objects as obj
        group by obj.bucket_id;
END
$$;


ALTER FUNCTION storage.get_size_by_bucket() OWNER TO supabase_storage_admin;

--
-- Name: list_multipart_uploads_with_delimiter(text, text, text, integer, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, next_key_token text DEFAULT ''::text, next_upload_token text DEFAULT ''::text) RETURNS TABLE(key text, id text, created_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN QUERY EXECUTE
        'SELECT DISTINCT ON(key COLLATE "C") * from (
            SELECT
                CASE
                    WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                        substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1)))
                    ELSE
                        key
                END AS key, id, created_at
            FROM
                storage.s3_multipart_uploads
            WHERE
                bucket_id = $5 AND
                key ILIKE $1 || ''%'' AND
                CASE
                    WHEN $4 != '''' AND $6 = '''' THEN
                        CASE
                            WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                                substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1))) COLLATE "C" > $4
                            ELSE
                                key COLLATE "C" > $4
                            END
                    ELSE
                        true
                END AND
                CASE
                    WHEN $6 != '''' THEN
                        id COLLATE "C" > $6
                    ELSE
                        true
                    END
            ORDER BY
                key COLLATE "C" ASC, created_at ASC) as e order by key COLLATE "C" LIMIT $3'
        USING prefix_param, delimiter_param, max_keys, next_key_token, bucket_id, next_upload_token;
END;
$_$;


ALTER FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer, next_key_token text, next_upload_token text) OWNER TO supabase_storage_admin;

--
-- Name: list_objects_with_delimiter(text, text, text, integer, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.list_objects_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, start_after text DEFAULT ''::text, next_token text DEFAULT ''::text) RETURNS TABLE(name text, id uuid, metadata jsonb, updated_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN QUERY EXECUTE
        'SELECT DISTINCT ON(name COLLATE "C") * from (
            SELECT
                CASE
                    WHEN position($2 IN substring(name from length($1) + 1)) > 0 THEN
                        substring(name from 1 for length($1) + position($2 IN substring(name from length($1) + 1)))
                    ELSE
                        name
                END AS name, id, metadata, updated_at
            FROM
                storage.objects
            WHERE
                bucket_id = $5 AND
                name ILIKE $1 || ''%'' AND
                CASE
                    WHEN $6 != '''' THEN
                    name COLLATE "C" > $6
                ELSE true END
                AND CASE
                    WHEN $4 != '''' THEN
                        CASE
                            WHEN position($2 IN substring(name from length($1) + 1)) > 0 THEN
                                substring(name from 1 for length($1) + position($2 IN substring(name from length($1) + 1))) COLLATE "C" > $4
                            ELSE
                                name COLLATE "C" > $4
                            END
                    ELSE
                        true
                END
            ORDER BY
                name COLLATE "C" ASC) as e order by name COLLATE "C" LIMIT $3'
        USING prefix_param, delimiter_param, max_keys, next_token, bucket_id, start_after;
END;
$_$;


ALTER FUNCTION storage.list_objects_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer, start_after text, next_token text) OWNER TO supabase_storage_admin;

--
-- Name: operation(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.operation() RETURNS text
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN current_setting('storage.operation', true);
END;
$$;


ALTER FUNCTION storage.operation() OWNER TO supabase_storage_admin;

--
-- Name: search(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
declare
  v_order_by text;
  v_sort_order text;
begin
  case
    when sortcolumn = 'name' then
      v_order_by = 'name';
    when sortcolumn = 'updated_at' then
      v_order_by = 'updated_at';
    when sortcolumn = 'created_at' then
      v_order_by = 'created_at';
    when sortcolumn = 'last_accessed_at' then
      v_order_by = 'last_accessed_at';
    else
      v_order_by = 'name';
  end case;

  case
    when sortorder = 'asc' then
      v_sort_order = 'asc';
    when sortorder = 'desc' then
      v_sort_order = 'desc';
    else
      v_sort_order = 'asc';
  end case;

  v_order_by = v_order_by || ' ' || v_sort_order;

  return query execute
    'with folders as (
       select path_tokens[$1] as folder
       from storage.objects
         where objects.name ilike $2 || $3 || ''%''
           and bucket_id = $4
           and array_length(objects.path_tokens, 1) <> $1
       group by folder
       order by folder ' || v_sort_order || '
     )
     (select folder as "name",
            null as id,
            null as updated_at,
            null as created_at,
            null as last_accessed_at,
            null as metadata from folders)
     union all
     (select path_tokens[$1] as "name",
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata
     from storage.objects
     where objects.name ilike $2 || $3 || ''%''
       and bucket_id = $4
       and array_length(objects.path_tokens, 1) = $1
     order by ' || v_order_by || ')
     limit $5
     offset $6' using levels, prefix, search, bucketname, limits, offsets;
end;
$_$;


ALTER FUNCTION storage.search(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text) OWNER TO supabase_storage_admin;

--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW; 
END;
$$;


ALTER FUNCTION storage.update_updated_at_column() OWNER TO supabase_storage_admin;

--
-- Name: http_request(); Type: FUNCTION; Schema: supabase_functions; Owner: supabase_functions_admin
--

CREATE FUNCTION supabase_functions.http_request() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'supabase_functions'
    AS $$
  DECLARE
    request_id bigint;
    payload jsonb;
    url text := TG_ARGV[0]::text;
    method text := TG_ARGV[1]::text;
    headers jsonb DEFAULT '{}'::jsonb;
    params jsonb DEFAULT '{}'::jsonb;
    timeout_ms integer DEFAULT 1000;
  BEGIN
    IF url IS NULL OR url = 'null' THEN
      RAISE EXCEPTION 'url argument is missing';
    END IF;

    IF method IS NULL OR method = 'null' THEN
      RAISE EXCEPTION 'method argument is missing';
    END IF;

    IF TG_ARGV[2] IS NULL OR TG_ARGV[2] = 'null' THEN
      headers = '{"Content-Type": "application/json"}'::jsonb;
    ELSE
      headers = TG_ARGV[2]::jsonb;
    END IF;

    IF TG_ARGV[3] IS NULL OR TG_ARGV[3] = 'null' THEN
      params = '{}'::jsonb;
    ELSE
      params = TG_ARGV[3]::jsonb;
    END IF;

    IF TG_ARGV[4] IS NULL OR TG_ARGV[4] = 'null' THEN
      timeout_ms = 1000;
    ELSE
      timeout_ms = TG_ARGV[4]::integer;
    END IF;

    CASE
      WHEN method = 'GET' THEN
        SELECT http_get INTO request_id FROM net.http_get(
          url,
          params,
          headers,
          timeout_ms
        );
      WHEN method = 'POST' THEN
        payload = jsonb_build_object(
          'old_record', OLD,
          'record', NEW,
          'type', TG_OP,
          'table', TG_TABLE_NAME,
          'schema', TG_TABLE_SCHEMA
        );

        SELECT http_post INTO request_id FROM net.http_post(
          url,
          payload,
          params,
          headers,
          timeout_ms
        );
      ELSE
        RAISE EXCEPTION 'method argument % is invalid', method;
    END CASE;

    INSERT INTO supabase_functions.hooks
      (hook_table_id, hook_name, request_id)
    VALUES
      (TG_RELID, TG_NAME, request_id);

    RETURN NEW;
  END
$$;


ALTER FUNCTION supabase_functions.http_request() OWNER TO supabase_functions_admin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: extensions; Type: TABLE; Schema: _realtime; Owner: supabase_admin
--

CREATE TABLE _realtime.extensions (
    id uuid NOT NULL,
    type text,
    settings jsonb,
    tenant_external_id text,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


ALTER TABLE _realtime.extensions OWNER TO supabase_admin;

--
-- Name: schema_migrations; Type: TABLE; Schema: _realtime; Owner: supabase_admin
--

CREATE TABLE _realtime.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


ALTER TABLE _realtime.schema_migrations OWNER TO supabase_admin;

--
-- Name: tenants; Type: TABLE; Schema: _realtime; Owner: supabase_admin
--

CREATE TABLE _realtime.tenants (
    id uuid NOT NULL,
    name text,
    external_id text,
    jwt_secret text,
    max_concurrent_users integer DEFAULT 200 NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    max_events_per_second integer DEFAULT 100 NOT NULL,
    postgres_cdc_default text DEFAULT 'postgres_cdc_rls'::text,
    max_bytes_per_second integer DEFAULT 100000 NOT NULL,
    max_channels_per_client integer DEFAULT 100 NOT NULL,
    max_joins_per_second integer DEFAULT 500 NOT NULL,
    suspend boolean DEFAULT false,
    jwt_jwks jsonb,
    notify_private_alpha boolean DEFAULT false,
    private_only boolean DEFAULT false NOT NULL
);


ALTER TABLE _realtime.tenants OWNER TO supabase_admin;

--
-- Name: audit_log_entries; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.audit_log_entries (
    instance_id uuid,
    id uuid NOT NULL,
    payload json,
    created_at timestamp with time zone,
    ip_address character varying(64) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE auth.audit_log_entries OWNER TO supabase_auth_admin;

--
-- Name: TABLE audit_log_entries; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.audit_log_entries IS 'Auth: Audit trail for user actions.';


--
-- Name: flow_state; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.flow_state (
    id uuid NOT NULL,
    user_id uuid,
    auth_code text NOT NULL,
    code_challenge_method auth.code_challenge_method NOT NULL,
    code_challenge text NOT NULL,
    provider_type text NOT NULL,
    provider_access_token text,
    provider_refresh_token text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    authentication_method text NOT NULL,
    auth_code_issued_at timestamp with time zone
);


ALTER TABLE auth.flow_state OWNER TO supabase_auth_admin;

--
-- Name: TABLE flow_state; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.flow_state IS 'stores metadata for pkce logins';


--
-- Name: identities; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.identities (
    provider_id text NOT NULL,
    user_id uuid NOT NULL,
    identity_data jsonb NOT NULL,
    provider text NOT NULL,
    last_sign_in_at timestamp with time zone,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    email text GENERATED ALWAYS AS (lower((identity_data ->> 'email'::text))) STORED,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE auth.identities OWNER TO supabase_auth_admin;

--
-- Name: TABLE identities; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.identities IS 'Auth: Stores identities associated to a user.';


--
-- Name: COLUMN identities.email; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.identities.email IS 'Auth: Email is a generated column that references the optional email property in the identity_data';


--
-- Name: instances; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.instances (
    id uuid NOT NULL,
    uuid uuid,
    raw_base_config text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


ALTER TABLE auth.instances OWNER TO supabase_auth_admin;

--
-- Name: TABLE instances; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.instances IS 'Auth: Manages users across multiple sites.';


--
-- Name: mfa_amr_claims; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_amr_claims (
    session_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    authentication_method text NOT NULL,
    id uuid NOT NULL
);


ALTER TABLE auth.mfa_amr_claims OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_amr_claims; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_amr_claims IS 'auth: stores authenticator method reference claims for multi factor authentication';


--
-- Name: mfa_challenges; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_challenges (
    id uuid NOT NULL,
    factor_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    verified_at timestamp with time zone,
    ip_address inet NOT NULL,
    otp_code text,
    web_authn_session_data jsonb
);


ALTER TABLE auth.mfa_challenges OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_challenges; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_challenges IS 'auth: stores metadata about challenge requests made';


--
-- Name: mfa_factors; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_factors (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    friendly_name text,
    factor_type auth.factor_type NOT NULL,
    status auth.factor_status NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    secret text,
    phone text,
    last_challenged_at timestamp with time zone,
    web_authn_credential jsonb,
    web_authn_aaguid uuid
);


ALTER TABLE auth.mfa_factors OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_factors; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_factors IS 'auth: stores metadata about factors';


--
-- Name: one_time_tokens; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.one_time_tokens (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    token_type auth.one_time_token_type NOT NULL,
    token_hash text NOT NULL,
    relates_to text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT one_time_tokens_token_hash_check CHECK ((char_length(token_hash) > 0))
);


ALTER TABLE auth.one_time_tokens OWNER TO supabase_auth_admin;

--
-- Name: refresh_tokens; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.refresh_tokens (
    instance_id uuid,
    id bigint NOT NULL,
    token character varying(255),
    user_id character varying(255),
    revoked boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    parent character varying(255),
    session_id uuid
);


ALTER TABLE auth.refresh_tokens OWNER TO supabase_auth_admin;

--
-- Name: TABLE refresh_tokens; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.refresh_tokens IS 'Auth: Store of tokens used to refresh JWT tokens once they expire.';


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE; Schema: auth; Owner: supabase_auth_admin
--

CREATE SEQUENCE auth.refresh_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auth.refresh_tokens_id_seq OWNER TO supabase_auth_admin;

--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: supabase_auth_admin
--

ALTER SEQUENCE auth.refresh_tokens_id_seq OWNED BY auth.refresh_tokens.id;


--
-- Name: saml_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.saml_providers (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    entity_id text NOT NULL,
    metadata_xml text NOT NULL,
    metadata_url text,
    attribute_mapping jsonb,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    name_id_format text,
    CONSTRAINT "entity_id not empty" CHECK ((char_length(entity_id) > 0)),
    CONSTRAINT "metadata_url not empty" CHECK (((metadata_url = NULL::text) OR (char_length(metadata_url) > 0))),
    CONSTRAINT "metadata_xml not empty" CHECK ((char_length(metadata_xml) > 0))
);


ALTER TABLE auth.saml_providers OWNER TO supabase_auth_admin;

--
-- Name: TABLE saml_providers; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.saml_providers IS 'Auth: Manages SAML Identity Provider connections.';


--
-- Name: saml_relay_states; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.saml_relay_states (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    request_id text NOT NULL,
    for_email text,
    redirect_to text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    flow_state_id uuid,
    CONSTRAINT "request_id not empty" CHECK ((char_length(request_id) > 0))
);


ALTER TABLE auth.saml_relay_states OWNER TO supabase_auth_admin;

--
-- Name: TABLE saml_relay_states; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.saml_relay_states IS 'Auth: Contains SAML Relay State information for each Service Provider initiated login.';


--
-- Name: schema_migrations; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.schema_migrations (
    version character varying(255) NOT NULL
);


ALTER TABLE auth.schema_migrations OWNER TO supabase_auth_admin;

--
-- Name: TABLE schema_migrations; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.schema_migrations IS 'Auth: Manages updates to the auth system.';


--
-- Name: sessions; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sessions (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    factor_id uuid,
    aal auth.aal_level,
    not_after timestamp with time zone,
    refreshed_at timestamp without time zone,
    user_agent text,
    ip inet,
    tag text
);


ALTER TABLE auth.sessions OWNER TO supabase_auth_admin;

--
-- Name: TABLE sessions; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sessions IS 'Auth: Stores session data associated to a user.';


--
-- Name: COLUMN sessions.not_after; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sessions.not_after IS 'Auth: Not after is a nullable column that contains a timestamp after which the session should be regarded as expired.';


--
-- Name: sso_domains; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sso_domains (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    domain text NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "domain not empty" CHECK ((char_length(domain) > 0))
);


ALTER TABLE auth.sso_domains OWNER TO supabase_auth_admin;

--
-- Name: TABLE sso_domains; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sso_domains IS 'Auth: Manages SSO email address domain mapping to an SSO Identity Provider.';


--
-- Name: sso_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sso_providers (
    id uuid NOT NULL,
    resource_id text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "resource_id not empty" CHECK (((resource_id = NULL::text) OR (char_length(resource_id) > 0)))
);


ALTER TABLE auth.sso_providers OWNER TO supabase_auth_admin;

--
-- Name: TABLE sso_providers; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sso_providers IS 'Auth: Manages SSO identity provider information; see saml_providers for SAML.';


--
-- Name: COLUMN sso_providers.resource_id; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sso_providers.resource_id IS 'Auth: Uniquely identifies a SSO provider according to a user-chosen resource ID (case insensitive), useful in infrastructure as code.';


--
-- Name: users; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.users (
    instance_id uuid,
    id uuid NOT NULL,
    aud character varying(255),
    role character varying(255),
    email character varying(255),
    encrypted_password character varying(255),
    email_confirmed_at timestamp with time zone,
    invited_at timestamp with time zone,
    confirmation_token character varying(255),
    confirmation_sent_at timestamp with time zone,
    recovery_token character varying(255),
    recovery_sent_at timestamp with time zone,
    email_change_token_new character varying(255),
    email_change character varying(255),
    email_change_sent_at timestamp with time zone,
    last_sign_in_at timestamp with time zone,
    raw_app_meta_data jsonb,
    raw_user_meta_data jsonb,
    is_super_admin boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    phone text DEFAULT NULL::character varying,
    phone_confirmed_at timestamp with time zone,
    phone_change text DEFAULT ''::character varying,
    phone_change_token character varying(255) DEFAULT ''::character varying,
    phone_change_sent_at timestamp with time zone,
    confirmed_at timestamp with time zone GENERATED ALWAYS AS (LEAST(email_confirmed_at, phone_confirmed_at)) STORED,
    email_change_token_current character varying(255) DEFAULT ''::character varying,
    email_change_confirm_status smallint DEFAULT 0,
    banned_until timestamp with time zone,
    reauthentication_token character varying(255) DEFAULT ''::character varying,
    reauthentication_sent_at timestamp with time zone,
    is_sso_user boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone,
    is_anonymous boolean DEFAULT false NOT NULL,
    CONSTRAINT users_email_change_confirm_status_check CHECK (((email_change_confirm_status >= 0) AND (email_change_confirm_status <= 2)))
);


ALTER TABLE auth.users OWNER TO supabase_auth_admin;

--
-- Name: TABLE users; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.users IS 'Auth: Stores user login data within a secure schema.';


--
-- Name: COLUMN users.is_sso_user; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.users.is_sso_user IS 'Auth: Set this column to true when the account comes from SSO. These accounts can have duplicate emails.';


--
-- Name: access_requests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.access_requests (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    name text NOT NULL,
    email text NOT NULL,
    role text NOT NULL,
    message text,
    status text DEFAULT 'pending'::text,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    CONSTRAINT access_requests_status_check CHECK ((status = ANY (ARRAY['pending'::text, 'approved'::text, 'rejected'::text])))
);


ALTER TABLE public.access_requests OWNER TO postgres;

--
-- Name: active_shifts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.active_shifts (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    shift_type public.shift_type NOT NULL,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    started_by uuid NOT NULL,
    salesforce_number text NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);


ALTER TABLE public.active_shifts OWNER TO postgres;

--
-- Name: attachments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.attachments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    user_id uuid NOT NULL,
    log_entry_id uuid NOT NULL,
    file_name text NOT NULL,
    file_type text,
    file_size bigint,
    file_path text NOT NULL,
    public_url text,
    CONSTRAINT valid_file_size CHECK ((file_size > 0))
);


ALTER TABLE public.attachments OWNER TO postgres;

--
-- Name: engineers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.engineers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    user_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.engineers OWNER TO postgres;

--
-- Name: log_entries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.log_entries (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    shift_type public.shift_type NOT NULL,
    category public.log_category NOT NULL,
    description text NOT NULL,
    user_id uuid NOT NULL,
    case_number text,
    case_status public.status_type,
    workorder_number text,
    workorder_status public.status_type,
    mc_setpoint numeric,
    yoke_temperature numeric,
    arc_current numeric,
    filament_current numeric,
    p1e_x_width numeric,
    p1e_y_width numeric,
    p2e_x_width double precision,
    p2e_y_width double precision,
    removed_source_number integer,
    removed_filament_current double precision,
    removed_arc_current double precision,
    removed_filament_counter double precision,
    inserted_source_number integer,
    inserted_filament_current double precision,
    inserted_arc_current double precision,
    inserted_filament_counter double precision,
    filament_hours double precision,
    engineers uuid[],
    dt_start_time timestamp with time zone,
    dt_end_time timestamp with time zone,
    dt_duration integer,
    workorder_title text,
    preferred_start_time timestamp without time zone,
    shift_id character varying(32),
    downtime_id character varying
);


ALTER TABLE public.log_entries OWNER TO postgres;

--
-- Name: COLUMN log_entries.downtime_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.log_entries.downtime_id IS 'dt id from svmx';


--
-- Name: log_suggestions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.log_suggestions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    category public.log_category NOT NULL,
    description text NOT NULL,
    usage_count integer DEFAULT 1,
    created_at timestamp with time zone DEFAULT now(),
    last_used timestamp with time zone DEFAULT now()
);


ALTER TABLE public.log_suggestions OWNER TO postgres;

--
-- Name: profiles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.profiles (
    id uuid NOT NULL,
    is_admin boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);


ALTER TABLE public.profiles OWNER TO postgres;

--
-- Name: shift_engineers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shift_engineers (
    shift_id uuid NOT NULL,
    engineer_id uuid NOT NULL
);


ALTER TABLE public.shift_engineers OWNER TO postgres;

--
-- Name: shift_notes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shift_notes (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    shift_type public.shift_type NOT NULL,
    note text NOT NULL,
    user_id uuid NOT NULL
);


ALTER TABLE public.shift_notes OWNER TO postgres;

--
-- Name: workorders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workorders (
    id bigint NOT NULL,
    workorder_number text NOT NULL,
    location text,
    workorder_title text,
    prefered_start_time timestamp with time zone,
    days_between_today_and_pst integer,
    status text DEFAULT 'open'::text,
    source text DEFAULT 'imported'::text,
    created_at timestamp with time zone DEFAULT now(),
    workorder_id character varying(18),
    updated_at timestamp with time zone,
    workorder_category text
);


ALTER TABLE public.workorders OWNER TO postgres;

--
-- Name: workorders_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.workorders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.workorders_id_seq OWNER TO postgres;

--
-- Name: workorders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.workorders_id_seq OWNED BY public.workorders.id;


--
-- Name: messages; Type: TABLE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TABLE realtime.messages (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
)
PARTITION BY RANGE (inserted_at);


ALTER TABLE realtime.messages OWNER TO supabase_realtime_admin;

--
-- Name: messages_2025_05_15; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2025_05_15 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2025_05_15 OWNER TO supabase_admin;

--
-- Name: messages_2025_05_16; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2025_05_16 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2025_05_16 OWNER TO supabase_admin;

--
-- Name: messages_2025_05_17; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2025_05_17 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2025_05_17 OWNER TO supabase_admin;

--
-- Name: messages_2025_05_18; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2025_05_18 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2025_05_18 OWNER TO supabase_admin;

--
-- Name: messages_2025_05_19; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2025_05_19 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2025_05_19 OWNER TO supabase_admin;

--
-- Name: schema_migrations; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


ALTER TABLE realtime.schema_migrations OWNER TO supabase_admin;

--
-- Name: subscription; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.subscription (
    id bigint NOT NULL,
    subscription_id uuid NOT NULL,
    entity regclass NOT NULL,
    filters realtime.user_defined_filter[] DEFAULT '{}'::realtime.user_defined_filter[] NOT NULL,
    claims jsonb NOT NULL,
    claims_role regrole GENERATED ALWAYS AS (realtime.to_regrole((claims ->> 'role'::text))) STORED NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);


ALTER TABLE realtime.subscription OWNER TO supabase_admin;

--
-- Name: subscription_id_seq; Type: SEQUENCE; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE realtime.subscription ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME realtime.subscription_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: buckets; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets (
    id text NOT NULL,
    name text NOT NULL,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    public boolean DEFAULT false,
    avif_autodetection boolean DEFAULT false,
    file_size_limit bigint,
    allowed_mime_types text[],
    owner_id text
);


ALTER TABLE storage.buckets OWNER TO supabase_storage_admin;

--
-- Name: COLUMN buckets.owner; Type: COMMENT; Schema: storage; Owner: supabase_storage_admin
--

COMMENT ON COLUMN storage.buckets.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: migrations; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.migrations (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    hash character varying(40) NOT NULL,
    executed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE storage.migrations OWNER TO supabase_storage_admin;

--
-- Name: objects; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.objects (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    bucket_id text,
    name text,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    last_accessed_at timestamp with time zone DEFAULT now(),
    metadata jsonb,
    path_tokens text[] GENERATED ALWAYS AS (string_to_array(name, '/'::text)) STORED,
    version text,
    owner_id text,
    user_metadata jsonb
);


ALTER TABLE storage.objects OWNER TO supabase_storage_admin;

--
-- Name: COLUMN objects.owner; Type: COMMENT; Schema: storage; Owner: supabase_storage_admin
--

COMMENT ON COLUMN storage.objects.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: s3_multipart_uploads; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.s3_multipart_uploads (
    id text NOT NULL,
    in_progress_size bigint DEFAULT 0 NOT NULL,
    upload_signature text NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    version text NOT NULL,
    owner_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    user_metadata jsonb
);


ALTER TABLE storage.s3_multipart_uploads OWNER TO supabase_storage_admin;

--
-- Name: s3_multipart_uploads_parts; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.s3_multipart_uploads_parts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    upload_id text NOT NULL,
    size bigint DEFAULT 0 NOT NULL,
    part_number integer NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    etag text NOT NULL,
    owner_id text,
    version text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE storage.s3_multipart_uploads_parts OWNER TO supabase_storage_admin;

--
-- Name: hooks; Type: TABLE; Schema: supabase_functions; Owner: supabase_functions_admin
--

CREATE TABLE supabase_functions.hooks (
    id bigint NOT NULL,
    hook_table_id integer NOT NULL,
    hook_name text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    request_id bigint
);


ALTER TABLE supabase_functions.hooks OWNER TO supabase_functions_admin;

--
-- Name: TABLE hooks; Type: COMMENT; Schema: supabase_functions; Owner: supabase_functions_admin
--

COMMENT ON TABLE supabase_functions.hooks IS 'Supabase Functions Hooks: Audit trail for triggered hooks.';


--
-- Name: hooks_id_seq; Type: SEQUENCE; Schema: supabase_functions; Owner: supabase_functions_admin
--

CREATE SEQUENCE supabase_functions.hooks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE supabase_functions.hooks_id_seq OWNER TO supabase_functions_admin;

--
-- Name: hooks_id_seq; Type: SEQUENCE OWNED BY; Schema: supabase_functions; Owner: supabase_functions_admin
--

ALTER SEQUENCE supabase_functions.hooks_id_seq OWNED BY supabase_functions.hooks.id;


--
-- Name: migrations; Type: TABLE; Schema: supabase_functions; Owner: supabase_functions_admin
--

CREATE TABLE supabase_functions.migrations (
    version text NOT NULL,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE supabase_functions.migrations OWNER TO supabase_functions_admin;

--
-- Name: schema_migrations; Type: TABLE; Schema: supabase_migrations; Owner: postgres
--

CREATE TABLE supabase_migrations.schema_migrations (
    version text NOT NULL,
    statements text[],
    name text
);


ALTER TABLE supabase_migrations.schema_migrations OWNER TO postgres;

--
-- Name: messages_2025_05_15; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2025_05_15 FOR VALUES FROM ('2025-05-15 00:00:00') TO ('2025-05-16 00:00:00');


--
-- Name: messages_2025_05_16; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2025_05_16 FOR VALUES FROM ('2025-05-16 00:00:00') TO ('2025-05-17 00:00:00');


--
-- Name: messages_2025_05_17; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2025_05_17 FOR VALUES FROM ('2025-05-17 00:00:00') TO ('2025-05-18 00:00:00');


--
-- Name: messages_2025_05_18; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2025_05_18 FOR VALUES FROM ('2025-05-18 00:00:00') TO ('2025-05-19 00:00:00');


--
-- Name: messages_2025_05_19; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2025_05_19 FOR VALUES FROM ('2025-05-19 00:00:00') TO ('2025-05-20 00:00:00');


--
-- Name: refresh_tokens id; Type: DEFAULT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens ALTER COLUMN id SET DEFAULT nextval('auth.refresh_tokens_id_seq'::regclass);


--
-- Name: workorders id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workorders ALTER COLUMN id SET DEFAULT nextval('public.workorders_id_seq'::regclass);


--
-- Name: hooks id; Type: DEFAULT; Schema: supabase_functions; Owner: supabase_functions_admin
--

ALTER TABLE ONLY supabase_functions.hooks ALTER COLUMN id SET DEFAULT nextval('supabase_functions.hooks_id_seq'::regclass);


--
-- Data for Name: extensions; Type: TABLE DATA; Schema: _realtime; Owner: supabase_admin
--

COPY _realtime.extensions (id, type, settings, tenant_external_id, inserted_at, updated_at) FROM stdin;
fb617c24-53bd-4872-a55d-1fa81e4cb05f	postgres_cdc_rls	{"region": "us-east-1", "db_host": "zIzfXzA9HjdY2dDhSW0e+zU+Y91MxFyTh/9L9BV79ypPNrrhma6I8nd28t/mto4/", "db_name": "sWBpZNdjggEPTQVlI52Zfw==", "db_port": "+enMDFi1J/3IrrquHHwUmA==", "db_user": "uxbEq/zz8DXVD53TOI1zmw==", "slot_name": "supabase_realtime_replication_slot", "db_password": "sWBpZNdjggEPTQVlI52Zfw==", "publication": "supabase_realtime", "ssl_enforced": false, "poll_interval_ms": 100, "poll_max_changes": 100, "poll_max_record_bytes": 1048576}	realtime-dev	2025-05-16 05:35:20	2025-05-16 05:35:20
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: _realtime; Owner: supabase_admin
--

COPY _realtime.schema_migrations (version, inserted_at) FROM stdin;
20210706140551	2025-05-16 05:34:56
20220329161857	2025-05-16 05:34:56
20220410212326	2025-05-16 05:34:56
20220506102948	2025-05-16 05:34:56
20220527210857	2025-05-16 05:34:56
20220815211129	2025-05-16 05:34:56
20220815215024	2025-05-16 05:34:56
20220818141501	2025-05-16 05:34:56
20221018173709	2025-05-16 05:34:56
20221102172703	2025-05-16 05:34:56
20221223010058	2025-05-16 05:34:56
20230110180046	2025-05-16 05:34:56
20230810220907	2025-05-16 05:34:56
20230810220924	2025-05-16 05:34:56
20231024094642	2025-05-16 05:34:56
20240306114423	2025-05-16 05:34:56
20240418082835	2025-05-16 05:34:56
20240625211759	2025-05-16 05:34:56
20240704172020	2025-05-16 05:34:56
20240902173232	2025-05-16 05:34:56
20241106103258	2025-05-16 05:34:56
\.


--
-- Data for Name: tenants; Type: TABLE DATA; Schema: _realtime; Owner: supabase_admin
--

COPY _realtime.tenants (id, name, external_id, jwt_secret, max_concurrent_users, inserted_at, updated_at, max_events_per_second, postgres_cdc_default, max_bytes_per_second, max_channels_per_client, max_joins_per_second, suspend, jwt_jwks, notify_private_alpha, private_only) FROM stdin;
eded4c76-a37b-4f7e-8db2-fd11bf979d2e	realtime-dev	realtime-dev	iNjicxc4+llvc9wovDvqymwfnj9teWMlyOIbJ8Fh6j2WNU8CIJ2ZgjR6MUIKqSmeDmvpsKLsZ9jgXJmQPpwL8w==	200	2025-05-16 05:35:20	2025-05-16 05:35:20	100	postgres_cdc_rls	100000	100	100	f	{"keys": [{"k": "c3VwZXItc2VjcmV0LWp3dC10b2tlbi13aXRoLWF0LWxlYXN0LTMyLWNoYXJhY3RlcnMtbG9uZw", "kty": "oct"}]}	f	f
\.


--
-- Data for Name: audit_log_entries; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) FROM stdin;
00000000-0000-0000-0000-000000000000	f61df229-38f7-4630-9605-e09d4a7ed884	{"action":"user_signedup","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"jithinkv2013@gmail.com","user_id":"2105fce5-5a56-4e33-9a70-24652124605a","user_phone":""}}	2025-05-16 05:59:14.837493+00	
00000000-0000-0000-0000-000000000000	91614451-1925-4951-8cbc-f075ea2fd239	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-16 06:42:24.205977+00	
00000000-0000-0000-0000-000000000000	47188ad7-b5ec-45da-904c-70f07a8b8ee9	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"jithinkv2013@gmail.com","user_id":"2105fce5-5a56-4e33-9a70-24652124605a","user_phone":""}}	2025-05-16 06:13:50.588965+00	
00000000-0000-0000-0000-000000000000	feb99cc8-1e30-4e36-8176-89b4925dae0c	{"action":"user_signedup","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-03-29 22:04:12.917993+00	
00000000-0000-0000-0000-000000000000	94a7d808-5da5-4a11-af80-f9137d612489	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-29 22:04:12.925604+00	
00000000-0000-0000-0000-000000000000	4fddd496-4acc-4eb5-9e4f-5873517cc1d0	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-29 22:13:44.210903+00	
00000000-0000-0000-0000-000000000000	83736c2f-0629-47d1-b0ff-fce8b56da5a7	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-03-29 22:25:29.497474+00	
00000000-0000-0000-0000-000000000000	c1bdef23-81b3-4fcd-98e2-21be418485af	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-29 22:25:35.134641+00	
00000000-0000-0000-0000-000000000000	dad2a95d-78e9-44b6-864c-c572b8b79e46	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-03-29 22:29:50.542304+00	
00000000-0000-0000-0000-000000000000	7bf89763-bdb2-495f-84bb-87b208e9475b	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-29 22:29:54.903196+00	
00000000-0000-0000-0000-000000000000	252293f8-70f7-4984-8546-32f70710679c	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-03-29 22:56:33.464457+00	
00000000-0000-0000-0000-000000000000	baa0f7f4-2b44-484e-9978-05f87d5d35d1	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-29 22:56:38.360232+00	
00000000-0000-0000-0000-000000000000	8f4fcf1d-467e-4756-aa4c-2126c0ba348c	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-03-29 23:01:13.117155+00	
00000000-0000-0000-0000-000000000000	77e24dbe-4d83-4b0d-8715-0417b66c8895	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-29 23:02:38.653107+00	
00000000-0000-0000-0000-000000000000	fbd7eea3-50ea-4752-887b-b6a50ff255ad	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-03-29 23:19:19.089022+00	
00000000-0000-0000-0000-000000000000	895b707c-5a2e-4e93-8ccc-287eb24fc702	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-29 23:27:55.363164+00	
00000000-0000-0000-0000-000000000000	008a2689-0c54-4077-b674-0994682a79da	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-30 00:07:19.227856+00	
00000000-0000-0000-0000-000000000000	8b85065b-0ccc-4c5b-91a5-ebca5495c923	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-30 00:26:43.415538+00	
00000000-0000-0000-0000-000000000000	f39f797f-6762-4197-aafd-7d92d0c9eb28	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-30 00:26:43.416487+00	
00000000-0000-0000-0000-000000000000	fa3e6d9b-70cd-47d4-bdc0-d2a4863193b5	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-03-30 00:58:36.428997+00	
00000000-0000-0000-0000-000000000000	bfb13a5d-17c8-407a-8c8d-e9f65f0350bf	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-30 00:58:44.098045+00	
00000000-0000-0000-0000-000000000000	0cebd512-ab2f-4c48-929c-0c2838968bdd	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-30 01:57:42.621632+00	
00000000-0000-0000-0000-000000000000	2dcfdfa4-930c-48d3-82ac-50b3e0a9c9f0	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-30 01:57:42.63136+00	
00000000-0000-0000-0000-000000000000	ff2336fd-c011-47c9-aff4-a9a16283d65f	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-30 02:52:15.531397+00	
00000000-0000-0000-0000-000000000000	16eb703f-8085-42ca-bbdd-24c85d2d218e	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-30 02:56:08.07964+00	
00000000-0000-0000-0000-000000000000	4c53e017-c10b-4e06-9646-9fe7f068e7b0	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-30 02:56:08.081325+00	
00000000-0000-0000-0000-000000000000	992ab7a0-6e8a-4156-a3a1-c6b90f42dbd4	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-03-30 02:56:38.526636+00	
00000000-0000-0000-0000-000000000000	d5887632-7f4d-4c0a-a462-a7ff2327ee71	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-30 02:56:43.153577+00	
00000000-0000-0000-0000-000000000000	19645fb9-3783-4b8b-91f0-fe4f80b39d19	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-30 03:54:54.83062+00	
00000000-0000-0000-0000-000000000000	4332fe25-6915-42f4-8d8c-504c2ff54139	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-30 03:54:54.836095+00	
00000000-0000-0000-0000-000000000000	6d400c4b-e5f0-48a5-91d4-3f43fdd8b2b2	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-30 04:04:51.910835+00	
00000000-0000-0000-0000-000000000000	597ce11d-c6ff-4841-b7da-73ef80dfb1c2	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-30 04:10:26.009948+00	
00000000-0000-0000-0000-000000000000	3e256cc5-89c6-4d41-9a88-5e699b41c86e	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-30 05:18:45.631621+00	
00000000-0000-0000-0000-000000000000	4efe050c-1733-4cf7-b352-a4e0efe58da1	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-30 05:18:45.632561+00	
00000000-0000-0000-0000-000000000000	41bd0488-5b08-4731-9d28-4c28a76759b8	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-30 07:33:44.404145+00	
00000000-0000-0000-0000-000000000000	62af83ac-f78d-4a6b-8e9f-e47102924e7c	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-30 07:33:44.405145+00	
00000000-0000-0000-0000-000000000000	ebd370e7-21bb-4a8f-8c43-c9fcc817875b	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-30 08:38:32.969639+00	
00000000-0000-0000-0000-000000000000	7630e708-fc63-444c-9989-61d029c84cc6	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-30 08:38:32.970685+00	
00000000-0000-0000-0000-000000000000	2cad2f86-92de-4c62-9967-e9357f9da64e	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-30 09:39:01.540707+00	
00000000-0000-0000-0000-000000000000	c5f7be77-d7bd-4083-a3ef-156dca810383	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-30 09:39:01.54176+00	
00000000-0000-0000-0000-000000000000	81585c7a-9ad6-49de-908b-b7abee052a1e	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-30 09:53:11.315544+00	
00000000-0000-0000-0000-000000000000	ae0b134b-6f92-43ba-be44-9cc701fe7dec	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-30 10:00:10.72966+00	
00000000-0000-0000-0000-000000000000	1092cfbc-b6be-43d5-a469-7f4e1dc23755	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-30 10:00:44.929173+00	
00000000-0000-0000-0000-000000000000	2d3c5b12-2882-4506-b5bf-47116479f65d	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-30 10:37:25.89256+00	
00000000-0000-0000-0000-000000000000	08d8efc3-e997-4df1-873b-d805e7f35575	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-30 10:37:25.894285+00	
00000000-0000-0000-0000-000000000000	ab07a7b2-4174-4040-88f4-54abcd21a46a	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-30 10:51:28.440325+00	
00000000-0000-0000-0000-000000000000	7b988315-c262-44d5-b088-0d5174fa0189	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-30 10:51:28.441242+00	
00000000-0000-0000-0000-000000000000	2ba505a4-d1bc-4e5b-8238-73989e21bfe4	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-30 15:11:45.142927+00	
00000000-0000-0000-0000-000000000000	51ea999a-1dad-45c5-9653-fd02a9a10f7d	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-30 15:15:17.297831+00	
00000000-0000-0000-0000-000000000000	f7ee17db-edfb-4d2c-9ad3-2d128057ff33	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-30 15:15:17.298772+00	
00000000-0000-0000-0000-000000000000	08df69d6-338d-48f4-8e6e-0737c2416cf9	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-30 16:19:48.620414+00	
00000000-0000-0000-0000-000000000000	9fdd83f9-b77a-4daa-b70f-e79d0c2d83ae	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-30 16:19:48.621344+00	
00000000-0000-0000-0000-000000000000	538f16ec-7142-4189-a144-4b6524c536dd	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-30 16:19:50.307536+00	
00000000-0000-0000-0000-000000000000	aad08f17-6d5f-4b59-a45d-c49faec29b20	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-30 16:19:50.308197+00	
00000000-0000-0000-0000-000000000000	efa1a460-dbff-40aa-9be5-489d66429f42	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-30 17:23:23.079297+00	
00000000-0000-0000-0000-000000000000	f25858c7-1553-4c03-9a33-c79969d05c1d	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-30 17:23:23.09033+00	
00000000-0000-0000-0000-000000000000	543b4d2b-3caa-4194-97f3-cfb806aa1e86	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-30 17:23:24.819028+00	
00000000-0000-0000-0000-000000000000	187f9a2f-8118-449b-b63a-5500a38adfc3	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-30 17:23:24.820273+00	
00000000-0000-0000-0000-000000000000	d287bd2d-6480-4bff-a099-f12556332ff9	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-30 18:24:41.691732+00	
00000000-0000-0000-0000-000000000000	0944bd04-4390-4e79-ab05-70f884f3261c	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-30 18:24:41.69403+00	
00000000-0000-0000-0000-000000000000	dff5425c-76ef-45f1-b611-3abdefe0816e	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-30 18:24:51.50261+00	
00000000-0000-0000-0000-000000000000	e99beb11-dce7-4e34-9a1e-e6f1e78c9809	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-30 18:24:51.503917+00	
00000000-0000-0000-0000-000000000000	0d53f12e-1489-4e11-9de5-81766413a877	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-30 18:51:51.343896+00	
00000000-0000-0000-0000-000000000000	0dda31ad-50d7-40d9-941e-2b099d2bdde7	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-30 18:58:09.363691+00	
00000000-0000-0000-0000-000000000000	b2d2cbae-43e5-4064-ac8c-0064698770d8	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-30 19:23:34.901731+00	
00000000-0000-0000-0000-000000000000	06a5d284-1b59-47d5-a007-2e2d26c87d8b	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-30 19:23:34.903764+00	
00000000-0000-0000-0000-000000000000	3eb95ca1-2eb2-40cc-8f45-20fc0e3d8530	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-31 18:12:31.283199+00	
00000000-0000-0000-0000-000000000000	fc5c14e7-eae0-4228-90ce-5dbb6d78711e	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-31 18:12:31.300239+00	
00000000-0000-0000-0000-000000000000	b6804979-665f-4ae6-bc90-4a19fb4e9b12	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-03-31 18:12:35.075826+00	
00000000-0000-0000-0000-000000000000	f8c3e9f0-79ab-4a82-b35d-46f45dc191e4	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-31 18:12:37.606685+00	
00000000-0000-0000-0000-000000000000	4f0f4ebf-29c9-423b-a43f-5be26f4b028f	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-31 18:13:21.227429+00	
00000000-0000-0000-0000-000000000000	53637207-bd5d-4244-b99a-c7f478655e50	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-31 18:36:09.754173+00	
00000000-0000-0000-0000-000000000000	97a4d31b-f182-4212-8a82-5f3d95bef4b4	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-31 19:11:11.796429+00	
00000000-0000-0000-0000-000000000000	7ed949b4-3979-4760-882a-80e89fdbd212	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-31 19:11:11.798157+00	
00000000-0000-0000-0000-000000000000	0f86166c-2402-49e1-9971-33393c45611a	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-31 19:11:54.579258+00	
00000000-0000-0000-0000-000000000000	19230855-3153-4fe0-b239-51dbb468e2c5	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-31 19:11:54.579894+00	
00000000-0000-0000-0000-000000000000	c247d1a2-730e-417a-9c79-c5469f8265bf	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-31 23:40:53.905259+00	
00000000-0000-0000-0000-000000000000	cb0dc2bc-184e-46db-a001-b2014fcc5e01	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-31 23:40:53.906185+00	
00000000-0000-0000-0000-000000000000	1574549e-13b2-419a-a6d5-962506790fa1	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-03-31 23:41:38.017881+00	
00000000-0000-0000-0000-000000000000	19062993-8c01-4b4e-b178-1e2d4b14b132	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-31 23:41:51.514136+00	
00000000-0000-0000-0000-000000000000	a1f0eecb-6333-4d39-8d24-aea670f03383	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-03-31 23:41:51.514789+00	
00000000-0000-0000-0000-000000000000	5001b455-dd03-40cb-8b72-d3c490a90638	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-03-31 23:45:17.481343+00	
00000000-0000-0000-0000-000000000000	1703f438-1056-4d9b-9418-2949e58c43b8	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-04-01 05:32:45.752546+00	
00000000-0000-0000-0000-000000000000	199997a6-d55e-486c-ba10-e12634cfda6c	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-04-01 05:32:47.752412+00	
00000000-0000-0000-0000-000000000000	3a1812e7-6595-43f0-8392-e022d69c8ea4	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-04-01 05:32:57.758659+00	
00000000-0000-0000-0000-000000000000	43f88ca6-1d90-4e5d-a746-aace46d0131f	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-04-01 05:33:48.889576+00	
00000000-0000-0000-0000-000000000000	08347360-febc-4da3-a952-ef09af8c5aa9	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-04-01 05:35:18.321654+00	
00000000-0000-0000-0000-000000000000	b5c55e57-b16f-4cea-8de9-6f1734bdf971	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-04-01 07:09:38.177579+00	
00000000-0000-0000-0000-000000000000	20594792-f679-4b24-8b8f-c3704c98ec40	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-04-01 07:36:43.222611+00	
00000000-0000-0000-0000-000000000000	9b73abaf-848b-4a1e-9d98-be7a75e65ec1	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-04-01 07:36:58.143057+00	
00000000-0000-0000-0000-000000000000	0336a998-4603-44d5-9583-2b0954a06e64	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-04-01 07:38:54.28177+00	
00000000-0000-0000-0000-000000000000	23611701-e65e-4ecd-9a08-34f86ea1a394	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-04-01 07:45:08.617218+00	
00000000-0000-0000-0000-000000000000	1ebecf06-3357-4389-9509-bef71376f314	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-04-01 07:50:47.788414+00	
00000000-0000-0000-0000-000000000000	ca793d85-f226-4969-bc4b-6443416afccb	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-04-01 07:59:21.208625+00	
00000000-0000-0000-0000-000000000000	54c87d3d-4ae5-49f7-819e-9869ce88d328	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-04-01 21:02:08.668158+00	
00000000-0000-0000-0000-000000000000	63f9f01e-9a61-414a-adc4-c72739d7b39e	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-01 22:00:40.243103+00	
00000000-0000-0000-0000-000000000000	ce325478-217d-45db-a5ce-de23e3497be4	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-01 22:00:40.246669+00	
00000000-0000-0000-0000-000000000000	92674abe-48b9-414e-a78d-c18c981a6a28	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-04-02 00:56:55.738304+00	
00000000-0000-0000-0000-000000000000	b70f838b-0248-4593-af96-6ebfcb83f858	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-02 02:15:12.926702+00	
00000000-0000-0000-0000-000000000000	0c5e67bb-d404-4604-bc62-27d4636ff26b	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-02 02:15:12.929009+00	
00000000-0000-0000-0000-000000000000	0daa5e3a-28f7-49df-944d-e1b522965e20	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-04-02 07:01:13.345448+00	
00000000-0000-0000-0000-000000000000	1d48dcc7-11e1-4ef3-b217-4440201890ef	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-02 08:00:06.641686+00	
00000000-0000-0000-0000-000000000000	08ded061-e65c-4b42-b5aa-6dbd67c5c5d5	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-02 08:00:06.646584+00	
00000000-0000-0000-0000-000000000000	a1e92061-0050-4732-b0bd-ca4e6d279516	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-03 05:13:05.892899+00	
00000000-0000-0000-0000-000000000000	d875357a-e43b-45c7-a18f-6226b7f7acb8	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-03 05:13:05.916841+00	
00000000-0000-0000-0000-000000000000	2dfb9bb1-aa06-4336-90ac-2eb2b90418fe	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-04-03 05:13:08.561693+00	
00000000-0000-0000-0000-000000000000	ce08e56f-e262-4081-840b-b84d5fac2a91	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-04-03 05:13:22.004392+00	
00000000-0000-0000-0000-000000000000	1ab1a259-fc36-46f2-9e7e-88c60b9e7709	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-04-03 05:22:20.467899+00	
00000000-0000-0000-0000-000000000000	f2dda5aa-2590-484d-b7d9-15d4a0f4ff02	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-03 06:11:38.993067+00	
00000000-0000-0000-0000-000000000000	3ca95b20-9519-42ce-bee3-88b68626f434	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-03 06:11:38.995195+00	
00000000-0000-0000-0000-000000000000	8f64c214-78f0-49bc-b2cc-d3da767455e0	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-03 07:10:13.835589+00	
00000000-0000-0000-0000-000000000000	e5df1922-d2c5-4603-933e-7867bddccc05	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-03 07:10:13.849822+00	
00000000-0000-0000-0000-000000000000	1c1e34ed-26a0-48f7-b2ac-ee4c71a0743a	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-03 07:23:58.568673+00	
00000000-0000-0000-0000-000000000000	4c3423f1-3d68-4c30-a6fe-8b9e74747a65	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-03 07:23:58.570264+00	
00000000-0000-0000-0000-000000000000	8bc5e24a-e4ad-43c2-bee2-96997d5fd3ae	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-03 08:09:13.046673+00	
00000000-0000-0000-0000-000000000000	4b36b44f-a346-49e2-99c0-4a702805e0c0	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-03 08:09:13.048955+00	
00000000-0000-0000-0000-000000000000	f88d0be4-b759-4885-a0fa-7e561fe46c75	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-03 09:08:13.035026+00	
00000000-0000-0000-0000-000000000000	0d672a53-c29f-4156-85d4-9ed216f937f9	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-03 09:08:13.037899+00	
00000000-0000-0000-0000-000000000000	91ed2968-a482-4078-b879-737fe5222b33	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-03 10:09:25.780991+00	
00000000-0000-0000-0000-000000000000	071bcfe2-6416-4903-a496-d45c6967f8e6	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-03 10:09:25.784922+00	
00000000-0000-0000-0000-000000000000	df116bb3-48c9-4aa2-b922-926ece440dc9	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-03 11:09:13.043712+00	
00000000-0000-0000-0000-000000000000	844597c0-57a3-4f77-8e8b-19efa35ddf54	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-03 11:09:13.045859+00	
00000000-0000-0000-0000-000000000000	22567764-5af8-43ca-9c20-8161a9aaf310	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-05 04:36:45.758276+00	
00000000-0000-0000-0000-000000000000	3ff9a7cf-27a3-49ea-b7bd-a5fce01178bd	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-05 04:36:45.785545+00	
00000000-0000-0000-0000-000000000000	d72ce66c-973d-4497-85c2-9a5e803c65ad	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-11 08:18:13.576467+00	
00000000-0000-0000-0000-000000000000	662d5dc9-6214-4bb2-89d3-7657e26c380a	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-11 08:18:13.605037+00	
00000000-0000-0000-0000-000000000000	f542d3dd-efb0-4137-b886-6b1f29ed96d6	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-11 10:50:57.626852+00	
00000000-0000-0000-0000-000000000000	1d9b7301-47e0-401b-8721-2100bad931bc	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-11 10:50:57.648854+00	
00000000-0000-0000-0000-000000000000	cb05d3e5-f12b-4df9-a500-3828130e87a4	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-11 13:16:20.858014+00	
00000000-0000-0000-0000-000000000000	5c3a9f92-a187-4b61-9d08-9a485e46bc16	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-11 13:16:20.865257+00	
00000000-0000-0000-0000-000000000000	d2c71362-ede6-4a12-92c1-a9afd7eb1504	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-15 11:13:04.892031+00	
00000000-0000-0000-0000-000000000000	f39822dd-c511-487c-b3ea-cbc9953bf058	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-15 11:13:04.9246+00	
00000000-0000-0000-0000-000000000000	550db780-c3d3-4e30-9289-6b211f74fb06	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-04-15 11:13:06.039992+00	
00000000-0000-0000-0000-000000000000	45aeda52-bdb0-41f9-beb7-9dc2744f6de7	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-15 12:11:46.215852+00	
00000000-0000-0000-0000-000000000000	cfff1636-3e32-4f98-879e-295fb48319e5	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-15 12:11:46.217905+00	
00000000-0000-0000-0000-000000000000	d6698dd8-20b8-4020-b3ca-7fdfdbeb9f2a	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-15 13:10:46.256245+00	
00000000-0000-0000-0000-000000000000	61a54ff1-93af-48bc-b71d-6340c1398c96	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-15 13:10:46.258351+00	
00000000-0000-0000-0000-000000000000	34ed520e-fc42-42e0-968e-9501d2e2a6b3	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-15 14:09:22.254588+00	
00000000-0000-0000-0000-000000000000	39d55642-653c-4b68-a585-d80a9f3bcb9b	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-15 14:09:22.255584+00	
00000000-0000-0000-0000-000000000000	ebf82898-f713-4acd-988d-30536f343201	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-15 15:08:46.415089+00	
00000000-0000-0000-0000-000000000000	b80427de-430d-428d-9da7-c3805909f946	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-15 15:08:46.416774+00	
00000000-0000-0000-0000-000000000000	7512fba2-caa1-48ae-9a19-a2c38e2794cd	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-15 16:30:44.651201+00	
00000000-0000-0000-0000-000000000000	4a1d032f-1377-4083-85e0-65eb194f2f2d	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-15 16:30:44.653801+00	
00000000-0000-0000-0000-000000000000	57469577-1ad8-4877-80fa-3a41a449c55b	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-16 16:47:37.351729+00	
00000000-0000-0000-0000-000000000000	8f74a72b-6f57-4692-bf40-651878b1858d	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-16 16:47:37.367908+00	
00000000-0000-0000-0000-000000000000	ddded643-891d-4fb9-950a-6323ce317d81	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-04-16 16:50:02.99385+00	
00000000-0000-0000-0000-000000000000	c703341b-53a7-45b9-9d87-cb54653297d7	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-04-16 16:50:09.550107+00	
00000000-0000-0000-0000-000000000000	22687d24-5cd3-42ba-9e57-57c97e9fda4b	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-04-16 16:50:39.554721+00	
00000000-0000-0000-0000-000000000000	a1cd30cf-e86d-4d46-a89d-2b38fd149146	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-04-26 13:14:24.892613+00	
00000000-0000-0000-0000-000000000000	5d6256cf-acf8-40c0-a6a2-283cdecd36c5	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-04-26 13:30:11.801675+00	
00000000-0000-0000-0000-000000000000	0d5bb541-a313-4435-b8b8-23e0276d7a34	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-04-26 13:30:34.182267+00	
00000000-0000-0000-0000-000000000000	b711092f-9c8f-424f-9683-f13213ee4611	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-04-26 13:30:52.164783+00	
00000000-0000-0000-0000-000000000000	8f7dc846-a8e5-4568-8c55-b3d7500d4ae9	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-04-26 13:50:10.730628+00	
00000000-0000-0000-0000-000000000000	b49e6420-c06d-40ea-8345-480234e5f361	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-04-26 14:11:35.98124+00	
00000000-0000-0000-0000-000000000000	bda60587-c5b0-44c1-9eaf-50a19e341665	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-04-26 14:11:41.581102+00	
00000000-0000-0000-0000-000000000000	4946dc22-f3d2-42ad-b021-309a8d3a2ba6	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-04-26 14:30:06.645497+00	
00000000-0000-0000-0000-000000000000	09de7d7f-63ed-4eb6-ae01-5930aff5f4e7	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-04-26 14:45:35.842857+00	
00000000-0000-0000-0000-000000000000	50cb33dc-335a-4037-98b3-d49ad9221e94	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-04-26 14:52:05.244137+00	
00000000-0000-0000-0000-000000000000	71130e0f-7383-4449-9e5c-ab401aba9f92	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-04-26 14:52:09.165117+00	
00000000-0000-0000-0000-000000000000	e64b815e-df45-4d88-984e-bb7905de6f6f	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-04-26 15:01:51.651436+00	
00000000-0000-0000-0000-000000000000	90357992-0feb-463d-b3d9-ca5c3ed6a019	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-04-26 15:10:41.784075+00	
00000000-0000-0000-0000-000000000000	eeadf8d6-f5e2-4aaf-8e50-c73b2811d078	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-04-26 15:10:45.195063+00	
00000000-0000-0000-0000-000000000000	273bf408-6587-4b92-aac4-3623330dfad5	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-04-26 15:14:14.39518+00	
00000000-0000-0000-0000-000000000000	fa74e729-1c0e-4adf-8a13-c68c02dd55d6	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-04-26 15:41:44.258584+00	
00000000-0000-0000-0000-000000000000	0ef0f64d-d913-4b60-b47a-86d7eff0c712	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-04-26 15:41:47.547964+00	
00000000-0000-0000-0000-000000000000	77c89432-ec1f-45ea-8604-007743663276	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-04-26 16:24:44.455563+00	
00000000-0000-0000-0000-000000000000	e3276264-115f-4633-9e77-a25ba24adda6	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-26 16:39:55.021048+00	
00000000-0000-0000-0000-000000000000	e118b074-ebf3-4a3b-9875-5c8a97473897	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-26 16:39:55.023661+00	
00000000-0000-0000-0000-000000000000	255764ea-66ac-420b-bf1d-33eae555dc82	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-26 17:23:22.739298+00	
00000000-0000-0000-0000-000000000000	51d38fc1-30e6-4204-b5b8-a86701682471	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-26 17:23:22.744298+00	
00000000-0000-0000-0000-000000000000	004fd313-c45d-42c5-8126-36447b9ddbd7	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-26 17:38:18.367624+00	
00000000-0000-0000-0000-000000000000	e3d044c4-2c54-48ca-9a8e-2163e11ff23d	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-26 17:38:18.370033+00	
00000000-0000-0000-0000-000000000000	803caae9-09f7-4469-9c78-8ab6ed8a4dd4	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-04-26 17:55:06.195994+00	
00000000-0000-0000-0000-000000000000	5d5e9f6f-2090-4aaf-85bb-41ac69ec3bbc	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-04-26 17:55:10.085634+00	
00000000-0000-0000-0000-000000000000	d4ed06db-25c9-442e-90be-e8e7767a26f6	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-26 18:53:48.026063+00	
00000000-0000-0000-0000-000000000000	04150248-7fd8-42a6-a5a6-3adb26153310	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-26 18:53:48.028225+00	
00000000-0000-0000-0000-000000000000	55c7ca43-e894-485d-9da9-802cd58b6dd3	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-26 19:52:33.065984+00	
00000000-0000-0000-0000-000000000000	7badb61f-3ef8-4ecc-9d46-7f9a11ac4b10	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-26 19:52:33.06798+00	
00000000-0000-0000-0000-000000000000	54d9c6ff-0f46-4028-86a3-bf0ce4e053b5	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-26 20:51:07.197908+00	
00000000-0000-0000-0000-000000000000	e6e9f19c-59b3-48f6-a144-e79d8fc76cf1	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-26 20:51:07.199618+00	
00000000-0000-0000-0000-000000000000	826593db-0956-41df-9bd8-3d1a59c5c145	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-26 21:49:53.10113+00	
00000000-0000-0000-0000-000000000000	43101e83-26aa-4bbf-9021-61f6f5f6d93c	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-26 21:49:53.102626+00	
00000000-0000-0000-0000-000000000000	daf41c33-d8e5-4513-9c78-cd35b8588c67	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-04-28 00:57:30.357994+00	
00000000-0000-0000-0000-000000000000	1a06c275-931f-4c64-a9ca-8afb030081ed	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-04-28 00:57:47.827148+00	
00000000-0000-0000-0000-000000000000	e4860dd1-0013-4d48-ad5f-8d259e9144ba	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-04-28 01:07:52.706083+00	
00000000-0000-0000-0000-000000000000	495c7a64-76a1-464c-8069-2a2781fca399	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-28 01:56:10.432425+00	
00000000-0000-0000-0000-000000000000	31863bf8-9b55-48aa-b0b3-1ee5493d621c	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-28 01:56:10.435211+00	
00000000-0000-0000-0000-000000000000	51d7236a-7d92-4a60-b6f3-057ab1f56c4d	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-28 01:56:17.470088+00	
00000000-0000-0000-0000-000000000000	24124dcb-5fbc-4dd5-8880-f7e0e7844bcb	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-28 01:56:17.472707+00	
00000000-0000-0000-0000-000000000000	dc8dc172-bcd3-45b9-8405-00c77da545a8	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-28 02:06:08.571206+00	
00000000-0000-0000-0000-000000000000	70b9d948-b9b5-42c8-b2ec-7353405b5897	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-28 02:06:08.573413+00	
00000000-0000-0000-0000-000000000000	72e54238-120b-4af8-a5e1-6e466a2be70d	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-04-28 02:34:21.036775+00	
00000000-0000-0000-0000-000000000000	e137a912-4419-484f-bee0-755ab7963512	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-28 02:54:17.618986+00	
00000000-0000-0000-0000-000000000000	ea92ad35-8c1f-43fb-8b32-e6153c380135	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-28 02:54:17.62213+00	
00000000-0000-0000-0000-000000000000	fe799d88-f294-410f-b7d5-5764e600fc44	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-28 02:55:06.426479+00	
00000000-0000-0000-0000-000000000000	a44e40dd-f316-4a98-82de-bde231314978	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-28 02:55:06.429041+00	
00000000-0000-0000-0000-000000000000	77fe2f13-660c-4b4d-a5c9-5fb170501663	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-28 03:32:54.139254+00	
00000000-0000-0000-0000-000000000000	dcf2b8a2-a01d-484e-b8fb-8276e25eb654	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-28 03:32:54.142806+00	
00000000-0000-0000-0000-000000000000	df8f646c-3450-4c10-9646-c3171a7ce14f	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-28 03:52:41.427783+00	
00000000-0000-0000-0000-000000000000	d74d9e01-facf-46b7-ae85-e4b548335b46	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-28 03:52:41.430688+00	
00000000-0000-0000-0000-000000000000	bc664d20-3988-4fea-b4a5-dab33c55cb7c	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-28 03:53:33.629048+00	
00000000-0000-0000-0000-000000000000	51936a52-7d45-4284-b181-3e6c38174cc4	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-28 03:53:33.629649+00	
00000000-0000-0000-0000-000000000000	ecf9261b-38f2-4700-afc5-d4ec3429de29	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-28 04:50:49.629048+00	
00000000-0000-0000-0000-000000000000	fac0cf57-9c5f-48f2-84cf-96a5228524f9	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-28 04:50:49.631288+00	
00000000-0000-0000-0000-000000000000	8be6074a-ee52-4c15-a879-c36fed442b24	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-28 04:52:09.338639+00	
00000000-0000-0000-0000-000000000000	d0346571-3c54-4749-a6e2-dbf0c867495b	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-28 04:52:09.339448+00	
00000000-0000-0000-0000-000000000000	fa10e0fd-502e-421a-949c-5759941597ac	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-28 05:36:08.790704+00	
00000000-0000-0000-0000-000000000000	7fdae32e-360d-4ac1-856d-1aab96402786	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-28 05:36:08.791551+00	
00000000-0000-0000-0000-000000000000	9a5c4c20-8df1-4b56-9fa6-d4cad2fa0fd1	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-28 05:48:51.765551+00	
00000000-0000-0000-0000-000000000000	846fb01a-330f-4bc2-8dbb-fb68c0550c20	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-28 05:48:51.766484+00	
00000000-0000-0000-0000-000000000000	304636c6-9190-4aec-8232-f0e015aefebf	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-28 05:50:46.541176+00	
00000000-0000-0000-0000-000000000000	b20c578f-fe2a-405f-9c7a-34bf6b73bde3	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-28 05:50:46.54466+00	
00000000-0000-0000-0000-000000000000	e961fa4e-be20-47e6-9310-b745fc9b5338	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-04-28 05:54:06.180275+00	
00000000-0000-0000-0000-000000000000	229bca35-213e-4174-8b88-c04e15a5774b	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-04-28 05:54:13.971586+00	
00000000-0000-0000-0000-000000000000	24c25062-62a8-40f4-a209-99582eb19ede	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-04-28 06:18:56.61164+00	
00000000-0000-0000-0000-000000000000	a388628d-d668-4617-9a6c-129383461359	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-04-28 06:19:29.714291+00	
00000000-0000-0000-0000-000000000000	85a2fbf7-caaa-4dcf-8934-a73675bf754b	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-04-28 06:24:46.016784+00	
00000000-0000-0000-0000-000000000000	21bc8ebf-291c-46fb-8af7-b71eaba27baa	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-04-28 06:27:22.501765+00	
00000000-0000-0000-0000-000000000000	91c34ed3-06d7-4c6c-835b-64220c4ab130	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-04-28 06:28:27.895478+00	
00000000-0000-0000-0000-000000000000	71d6f00a-0dc3-4e31-8ae8-373ff7dd3b6b	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-04-28 06:37:59.53399+00	
00000000-0000-0000-0000-000000000000	f91e1da7-5062-4ee0-84c9-ba55ac575897	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-04-28 06:38:01.833595+00	
00000000-0000-0000-0000-000000000000	54e29849-4ef9-4881-9bc9-5b9f4253207c	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-04-28 06:38:24.419778+00	
00000000-0000-0000-0000-000000000000	cf172f73-0826-4ce7-b7e0-2619445d517e	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-04-28 06:38:29.660012+00	
00000000-0000-0000-0000-000000000000	3f67ec5a-8cf2-4b94-9c95-50086b185f1e	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-04-28 06:38:47.903532+00	
00000000-0000-0000-0000-000000000000	817c9fdb-8daf-4866-8ccf-bcf1ae187523	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-04-28 06:42:52.312626+00	
00000000-0000-0000-0000-000000000000	4c815b0b-521a-4f47-8679-d32ee1b3d591	{"action":"user_signedup","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"test1@gmail.com","user_id":"a307b4de-bfd4-4da4-947d-43e3ba763b74","user_phone":""}}	2025-04-28 06:44:29.723447+00	
00000000-0000-0000-0000-000000000000	70a08ece-b01e-4802-ae10-7f43976e5f2b	{"action":"login","actor_id":"a307b4de-bfd4-4da4-947d-43e3ba763b74","actor_username":"test1@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-04-28 06:45:03.976311+00	
00000000-0000-0000-0000-000000000000	9f3efffb-88cc-42d9-acba-e362667434d9	{"action":"logout","actor_id":"a307b4de-bfd4-4da4-947d-43e3ba763b74","actor_username":"test1@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-04-28 06:45:10.523766+00	
00000000-0000-0000-0000-000000000000	dd2e3d9f-66e3-4081-8ef3-71a1eedf1a96	{"action":"user_invited","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"supabase_admin","actor_via_sso":false,"log_type":"team","traits":{"user_email":"jithin.palottukandy@iba-group.com","user_id":"9acfef72-5118-449f-ad68-73fe2f21a7fd"}}	2025-04-28 06:48:46.556106+00	
00000000-0000-0000-0000-000000000000	84805f52-245b-4ce2-b8be-17bcedc3c909	{"action":"user_signedup","actor_id":"9acfef72-5118-449f-ad68-73fe2f21a7fd","actor_username":"jithin.palottukandy@iba-group.com","actor_via_sso":false,"log_type":"team"}	2025-04-28 06:49:18.40093+00	
00000000-0000-0000-0000-000000000000	6554b16c-194c-44e9-a817-c1a6a3c296d4	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"jithin.palottukandy@iba-group.com","user_id":"9acfef72-5118-449f-ad68-73fe2f21a7fd","user_phone":""}}	2025-04-28 06:50:25.841827+00	
00000000-0000-0000-0000-000000000000	3adc6b4d-e62a-46be-8ec0-e56afa9d0951	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"test1@gmail.com","user_id":"a307b4de-bfd4-4da4-947d-43e3ba763b74","user_phone":""}}	2025-04-28 06:52:46.658598+00	
00000000-0000-0000-0000-000000000000	9ba19617-0b1f-47ea-9b72-64455193322a	{"action":"user_invited","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"supabase_admin","actor_via_sso":false,"log_type":"team","traits":{"user_email":"jithin.palottukandy@iba-group.com","user_id":"19cea6d2-b142-43b7-901a-83b20dacbb5e"}}	2025-04-28 06:53:23.109768+00	
00000000-0000-0000-0000-000000000000	f16066cd-476c-4a48-a870-957f669d0c4f	{"action":"user_signedup","actor_id":"19cea6d2-b142-43b7-901a-83b20dacbb5e","actor_username":"jithin.palottukandy@iba-group.com","actor_via_sso":false,"log_type":"team"}	2025-04-28 06:54:59.79313+00	
00000000-0000-0000-0000-000000000000	3c2f9f23-c067-446a-a753-b53bb5f42bd8	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"jithin.palottukandy@iba-group.com","user_id":"19cea6d2-b142-43b7-901a-83b20dacbb5e","user_phone":""}}	2025-04-28 06:57:13.515061+00	
00000000-0000-0000-0000-000000000000	44f93609-d2d0-4960-8b48-daa81cb8aa9b	{"action":"user_signedup","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"jithin.palottukandy@iba-group.com","user_id":"fd9e3f57-185e-404e-83c7-226ba75fa308","user_phone":""}}	2025-04-28 06:57:37.050821+00	
00000000-0000-0000-0000-000000000000	5c06f358-a4bc-4e4e-b585-8f45a82f3966	{"action":"login","actor_id":"fd9e3f57-185e-404e-83c7-226ba75fa308","actor_username":"jithin.palottukandy@iba-group.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-04-28 06:57:52.275411+00	
00000000-0000-0000-0000-000000000000	46371b51-a099-4b6a-8697-fa92d30f3747	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-04-28 06:58:23.368124+00	
00000000-0000-0000-0000-000000000000	037c583d-9119-45c7-9e65-45f054c8c6af	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-04-28 06:59:36.13864+00	
00000000-0000-0000-0000-000000000000	146b3e6a-48d4-4829-b3c2-cd0997cf1daf	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-04-28 06:59:58.528439+00	
00000000-0000-0000-0000-000000000000	472ca5f7-d328-4aac-a622-e471a383721d	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-28 07:58:09.999193+00	
00000000-0000-0000-0000-000000000000	9d385e51-ef4e-419b-b4ef-45e9ab66440c	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-28 07:58:10.002956+00	
00000000-0000-0000-0000-000000000000	0fa0599b-9994-4ef3-8154-606d20dec485	{"action":"token_refreshed","actor_id":"fd9e3f57-185e-404e-83c7-226ba75fa308","actor_username":"jithin.palottukandy@iba-group.com","actor_via_sso":false,"log_type":"token"}	2025-04-28 08:23:23.868733+00	
00000000-0000-0000-0000-000000000000	272e5074-4009-4a33-9682-2bbd1fbd1994	{"action":"token_revoked","actor_id":"fd9e3f57-185e-404e-83c7-226ba75fa308","actor_username":"jithin.palottukandy@iba-group.com","actor_via_sso":false,"log_type":"token"}	2025-04-28 08:23:23.872265+00	
00000000-0000-0000-0000-000000000000	67194c09-c599-4662-a0fe-feca8dc0ebdb	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-04-28 08:33:44.932475+00	
00000000-0000-0000-0000-000000000000	dd877e16-16a3-47f9-8c7e-eb361cc5511e	{"action":"token_refreshed","actor_id":"fd9e3f57-185e-404e-83c7-226ba75fa308","actor_username":"jithin.palottukandy@iba-group.com","actor_via_sso":false,"log_type":"token"}	2025-04-28 09:26:04.917206+00	
00000000-0000-0000-0000-000000000000	bb6f6ee0-2b30-40d7-bb53-0564d1219166	{"action":"token_revoked","actor_id":"fd9e3f57-185e-404e-83c7-226ba75fa308","actor_username":"jithin.palottukandy@iba-group.com","actor_via_sso":false,"log_type":"token"}	2025-04-28 09:26:04.919068+00	
00000000-0000-0000-0000-000000000000	08474302-f067-4efe-8edb-836abcc6acbb	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"jithin.palottukandy@iba-group.com","user_id":"fd9e3f57-185e-404e-83c7-226ba75fa308","user_phone":""}}	2025-04-28 12:14:40.976781+00	
00000000-0000-0000-0000-000000000000	39033146-708b-49ba-a78a-3fad59b42c9d	{"action":"user_signedup","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"test@abc.com","user_id":"6531cf15-e8e5-4cca-9886-822f2aa40060","user_phone":""}}	2025-04-28 12:15:24.522734+00	
00000000-0000-0000-0000-000000000000	109f1c32-31af-445d-831c-8891c00cb2de	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-04-28 12:19:35.199004+00	
00000000-0000-0000-0000-000000000000	e6030724-6278-4ce0-b11b-9731c0c5f4df	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-04-28 12:21:08.956778+00	
00000000-0000-0000-0000-000000000000	3ce9000a-d555-4787-886b-c2aec38f53ea	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-04-28 12:21:25.835407+00	
00000000-0000-0000-0000-000000000000	f2e0c493-bf45-4207-8a24-82bf33608b27	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-04-28 13:13:30.159256+00	
00000000-0000-0000-0000-000000000000	099942cd-554d-4078-a087-570a73d272f1	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-04-28 13:14:14.662449+00	
00000000-0000-0000-0000-000000000000	9f049970-8b13-4e13-9651-d90b30eb9489	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-04-28 13:14:23.395421+00	
00000000-0000-0000-0000-000000000000	f5d400c3-dae9-4669-9366-52f2e5fd4887	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-04-28 13:24:13.385188+00	
00000000-0000-0000-0000-000000000000	c9e74ec6-11cc-4d3e-ba87-fd3b9e7ef347	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-28 14:22:16.292966+00	
00000000-0000-0000-0000-000000000000	38e946fb-66f1-49f5-9ef9-10cb6f2d689f	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-28 14:22:16.295176+00	
00000000-0000-0000-0000-000000000000	4fd1bf38-57e8-4510-8ae7-fd397a6bcddc	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-04-28 14:45:32.124606+00	
00000000-0000-0000-0000-000000000000	9b2e3428-ee1b-4256-87c2-f995c26b507e	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-04-28 15:19:08.26938+00	
00000000-0000-0000-0000-000000000000	6e303d8e-57a8-482f-80c4-4204c795ddcc	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-04-28 15:20:46.227412+00	
00000000-0000-0000-0000-000000000000	d0f58f0a-1f99-42c9-9a73-32cedd04119c	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-04-28 15:21:24.088587+00	
00000000-0000-0000-0000-000000000000	7ee5e08c-422e-4a9c-9ac8-eeb49039fe45	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-28 16:19:14.731206+00	
00000000-0000-0000-0000-000000000000	78c9bf7b-f581-4b98-b7ae-4fd53848ade0	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-28 16:19:14.733527+00	
00000000-0000-0000-0000-000000000000	2007c84d-a5ba-465f-a82a-70fb5c41e58e	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-28 16:19:35.310618+00	
00000000-0000-0000-0000-000000000000	46082449-9d37-42a7-94f3-d56ad0a93dd4	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-28 16:19:35.311162+00	
00000000-0000-0000-0000-000000000000	38ff3838-233a-41e6-ba95-95180ee724b9	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-28 17:17:33.825718+00	
00000000-0000-0000-0000-000000000000	f3371172-79bd-4284-b095-19cc50428200	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-28 17:17:33.827436+00	
00000000-0000-0000-0000-000000000000	5f4286e0-aff4-42f1-8f3b-7a3d3a76f304	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-28 17:19:05.142526+00	
00000000-0000-0000-0000-000000000000	c9423262-5e85-4dea-9426-1f403c4a33e9	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-28 17:19:05.143333+00	
00000000-0000-0000-0000-000000000000	7cf387e4-f186-4327-88bc-e24c3a08ef53	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-04-28 17:23:01.822758+00	
00000000-0000-0000-0000-000000000000	839d2007-f0df-491f-9b70-5e8f245c5093	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-04-28 17:23:07.106618+00	
00000000-0000-0000-0000-000000000000	208c4460-f3d9-4514-9c7d-831a6ae9612d	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-04-28 17:44:00.861242+00	
00000000-0000-0000-0000-000000000000	b8615f03-c485-419c-a113-2e787d26c2d9	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-04-28 18:05:41.472194+00	
00000000-0000-0000-0000-000000000000	dd94b713-dd99-4044-ae05-ae4222189810	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-04-28 18:06:48.129032+00	
00000000-0000-0000-0000-000000000000	ecc85dc3-d240-49b9-8790-ca38ae028eb1	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-28 19:04:49.922473+00	
00000000-0000-0000-0000-000000000000	346711ad-ee61-4aaa-ae73-1adfda170215	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-28 19:04:49.92344+00	
00000000-0000-0000-0000-000000000000	f1a957fa-e542-4086-adf1-c72bcad4718d	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-04-29 00:33:18.146473+00	
00000000-0000-0000-0000-000000000000	60f765dd-3415-48aa-934e-909f6e0fef7a	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-04-29 00:33:23.370767+00	
00000000-0000-0000-0000-000000000000	c3bb282b-d8a8-4793-9183-727f8b548172	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-04-29 00:33:32.486542+00	
00000000-0000-0000-0000-000000000000	e3e39288-5506-4505-a85d-af9dcf22a8df	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-04-29 00:34:24.563984+00	
00000000-0000-0000-0000-000000000000	88e13e43-c563-49e4-9753-290d057d31af	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-04-29 01:07:35.018645+00	
00000000-0000-0000-0000-000000000000	33fcf98e-4e94-4cf1-8753-2bcb71dce65b	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-04-29 01:28:46.447765+00	
00000000-0000-0000-0000-000000000000	aa48c9cd-c269-43c7-8298-3e27fd9b144e	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-29 01:32:26.247444+00	
00000000-0000-0000-0000-000000000000	aadfc2ca-a325-4be7-84cb-fe4dd3814ca9	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-29 01:32:26.25064+00	
00000000-0000-0000-0000-000000000000	4ebe6da3-4c98-4d8c-a88b-3de2c6a89cc1	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-29 01:42:24.959142+00	
00000000-0000-0000-0000-000000000000	a7710c85-4296-4b9d-a6f7-fc81dd0a988e	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-29 01:42:24.963249+00	
00000000-0000-0000-0000-000000000000	1f114d67-16ba-4214-9a2a-9eb795d1c9cf	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-29 02:40:28.263718+00	
00000000-0000-0000-0000-000000000000	d7a3d8af-3f43-4bbd-a0b3-1e82da27103d	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-29 02:40:28.268069+00	
00000000-0000-0000-0000-000000000000	bbf14fb6-1252-40c9-bad4-cb02a710c3aa	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-29 02:50:08.485605+00	
00000000-0000-0000-0000-000000000000	ac885622-c38d-422a-9a51-4181e64a2156	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-29 02:50:08.486525+00	
00000000-0000-0000-0000-000000000000	665502a4-21a6-434f-8883-1e2e5a173d8e	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-29 03:03:10.471449+00	
00000000-0000-0000-0000-000000000000	14e318ef-2be8-49b2-907e-eb0efb524f09	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-29 03:03:10.473878+00	
00000000-0000-0000-0000-000000000000	ed5ddb2a-a043-4460-8378-8f0e3143f8d4	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-29 03:38:37.995653+00	
00000000-0000-0000-0000-000000000000	9f655505-7230-4420-89ec-44e984c5a412	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-29 03:38:37.997436+00	
00000000-0000-0000-0000-000000000000	a1a57c57-ff3b-4bd3-a1a3-3a100eabcdd1	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-29 04:04:48.478327+00	
00000000-0000-0000-0000-000000000000	289481ba-1a14-4a75-af3b-7d1c97528e37	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-29 04:04:48.480265+00	
00000000-0000-0000-0000-000000000000	a4449784-7292-4eee-b233-77b5492ac2bd	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-29 04:06:26.47488+00	
00000000-0000-0000-0000-000000000000	e8231771-e573-4e99-a9f6-5148a442a986	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-29 04:06:26.477029+00	
00000000-0000-0000-0000-000000000000	7907bbab-c715-486b-8bf0-c0e62a810998	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-29 04:36:53.09098+00	
00000000-0000-0000-0000-000000000000	8ace8f5b-3af7-44e8-96e5-553ab55d0194	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-29 04:36:53.092652+00	
00000000-0000-0000-0000-000000000000	0acb65d3-63ed-42d3-b2b9-318bf37586f2	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-29 05:03:44.149966+00	
00000000-0000-0000-0000-000000000000	189a6219-8bfd-4561-b890-ba053633b559	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-29 05:03:44.150888+00	
00000000-0000-0000-0000-000000000000	9beee159-727f-48a0-9bd9-d69a0db66e41	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-29 05:35:15.381222+00	
00000000-0000-0000-0000-000000000000	11e4fb53-735f-44c2-9503-a280d3ecf7ed	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-29 05:35:15.383522+00	
00000000-0000-0000-0000-000000000000	831b3539-4d29-40fb-a5cf-d3f25983ebce	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-29 06:02:18.331243+00	
00000000-0000-0000-0000-000000000000	ddf608e1-a43d-490e-a64e-79eaaf8814b2	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-29 06:02:18.332058+00	
00000000-0000-0000-0000-000000000000	11fc1308-a0c1-4e9a-ae52-c965722c1c5d	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-29 06:33:17.711497+00	
00000000-0000-0000-0000-000000000000	4d7f83e3-501f-4c1a-94a6-e64af175d9e4	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-29 06:33:17.714431+00	
00000000-0000-0000-0000-000000000000	79db854e-0ba6-43bb-942f-5ee5df977b3d	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-29 07:01:17.84161+00	
00000000-0000-0000-0000-000000000000	32420099-a25f-42ec-9521-261039c62366	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-29 07:01:17.848275+00	
00000000-0000-0000-0000-000000000000	281ec9b1-d52f-43f8-b57c-7b21205d7783	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-29 07:31:26.381601+00	
00000000-0000-0000-0000-000000000000	7bda9ec4-d873-4e33-a35a-5f92ffd8f6d5	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-29 07:31:26.383954+00	
00000000-0000-0000-0000-000000000000	56bf8bb4-9b86-4562-b910-0711c78de2fd	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-29 07:59:21.231949+00	
00000000-0000-0000-0000-000000000000	5cc0b3b5-b465-467f-bac9-8a7d189c0f46	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-29 07:59:21.23286+00	
00000000-0000-0000-0000-000000000000	318122a6-6d0b-4c5a-8c75-83f17b2adb11	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-29 08:29:33.441397+00	
00000000-0000-0000-0000-000000000000	94c2f9d3-4b30-4ded-a40f-056e7f40d7c8	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-04-29 08:29:33.443011+00	
00000000-0000-0000-0000-000000000000	387dd2fb-59b1-4d61-acf1-98063277d686	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-04-29 08:39:20.118223+00	
00000000-0000-0000-0000-000000000000	bb6238c7-213d-4e09-a331-6b2cba0732b9	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-04-29 08:39:29.586656+00	
00000000-0000-0000-0000-000000000000	ea16a673-97c6-4bba-8214-38efda464deb	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-04-29 08:42:59.378969+00	
00000000-0000-0000-0000-000000000000	dba2773a-1c40-4b47-a055-9b593b186a01	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-01 10:26:49.867841+00	
00000000-0000-0000-0000-000000000000	450d5ceb-12a0-4278-a0d8-a96d637f4700	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-01 10:54:01.94045+00	
00000000-0000-0000-0000-000000000000	d6070bb8-512a-4c1b-812e-6da9ba874088	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-01 10:57:34.138992+00	
00000000-0000-0000-0000-000000000000	63c7f4f9-28ec-423c-8b3c-8664b996e371	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-01 11:56:00.076284+00	
00000000-0000-0000-0000-000000000000	00b15934-3f8b-465a-92d2-e13271135675	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-01 11:56:00.084264+00	
00000000-0000-0000-0000-000000000000	63e64e47-fdd9-4375-9f53-b6c73b496b14	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-01 12:54:35.010759+00	
00000000-0000-0000-0000-000000000000	8afebc1d-961b-4576-b482-c7fb81d48b82	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-01 12:54:35.012651+00	
00000000-0000-0000-0000-000000000000	cc2d69d3-b75f-418d-8933-ef06f1771a98	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-01 13:53:17.463179+00	
00000000-0000-0000-0000-000000000000	a3d9bbb5-2138-4004-87dd-259124cdbb34	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-01 13:53:17.465255+00	
00000000-0000-0000-0000-000000000000	8dc4e163-6fbe-4970-8eac-a7133cd04167	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-02 01:42:53.779264+00	
00000000-0000-0000-0000-000000000000	7f721653-c34c-41e6-84c6-cab9a49a0bb3	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-02 02:08:17.099778+00	
00000000-0000-0000-0000-000000000000	8a27851b-05fd-4e1e-ba9a-af2c6d0db021	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-02 02:41:03.820753+00	
00000000-0000-0000-0000-000000000000	2d501b17-5dcb-4213-8b09-275353041f84	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-02 02:41:03.821653+00	
00000000-0000-0000-0000-000000000000	4b78f660-9bad-451b-a52b-8ba4d6d6634b	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-02 03:18:51.185419+00	
00000000-0000-0000-0000-000000000000	4aebc12a-56d6-46ea-bcab-e6943cbe39e3	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-02 03:23:43.241786+00	
00000000-0000-0000-0000-000000000000	d6f6d64b-1f99-4ce4-b9e3-86e154b29304	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-02 03:23:43.243368+00	
00000000-0000-0000-0000-000000000000	188de465-83ef-468f-a99d-2911f787b218	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-02 03:59:02.924061+00	
00000000-0000-0000-0000-000000000000	1654183a-8115-437e-950c-435f1c7f4df1	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-02 04:01:01.819733+00	
00000000-0000-0000-0000-000000000000	f26f629f-6e11-48e0-94eb-4c18f9d6277f	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-02 04:03:10.669426+00	
00000000-0000-0000-0000-000000000000	ec9a86e3-d80d-442f-b3a0-a4aa4f48d9a0	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-02 04:03:14.315616+00	
00000000-0000-0000-0000-000000000000	e0699468-cc5a-4a9d-8277-95ea115ac909	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-02 04:17:51.624778+00	
00000000-0000-0000-0000-000000000000	84c5b680-02dc-4457-9235-82925c7883bb	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-02 05:01:16.407901+00	
00000000-0000-0000-0000-000000000000	a6609a83-5f9a-4f5b-9c29-0eedb9c4420e	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-02 05:01:16.410816+00	
00000000-0000-0000-0000-000000000000	1e25edcb-1eea-4675-9da0-944ba2f776d6	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-02 05:17:04.64444+00	
00000000-0000-0000-0000-000000000000	4717d9e0-e1c6-4258-95db-6dbf962eb568	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-02 05:17:04.647091+00	
00000000-0000-0000-0000-000000000000	e5ed6868-b84c-49c9-a420-4fafee6fb40a	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-02 05:59:23.721877+00	
00000000-0000-0000-0000-000000000000	9a845e2b-ac6c-4316-b244-98d555a04808	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-02 05:59:23.724745+00	
00000000-0000-0000-0000-000000000000	c46771f9-190e-4b08-8b0e-e2ffe6e182a1	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-02 06:15:39.265503+00	
00000000-0000-0000-0000-000000000000	9a8c0002-6f8e-4f3c-beb3-649554694248	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-02 06:15:39.270502+00	
00000000-0000-0000-0000-000000000000	2a3819ff-30a2-4994-ad7b-e8dc7db0e065	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-02 06:43:16.823837+00	
00000000-0000-0000-0000-000000000000	4dbdc5ee-2c11-44de-bd72-37a6cf4bfac6	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-02 06:57:37.594313+00	
00000000-0000-0000-0000-000000000000	1d903ae9-31db-445a-915e-9ccf5ab4d6b6	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-02 06:57:37.597012+00	
00000000-0000-0000-0000-000000000000	c176baea-20a3-45e1-8f5e-d3de74e7d87f	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-02 07:41:37.581255+00	
00000000-0000-0000-0000-000000000000	8a963ca7-5b80-40fb-948f-12bdcf1d66fe	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-02 07:41:37.586817+00	
00000000-0000-0000-0000-000000000000	9eada1ec-f09e-4550-abef-d0bc11ef1e1f	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-02 07:56:04.997109+00	
00000000-0000-0000-0000-000000000000	bb1827ca-17e9-44f7-915f-13647921a81a	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-02 07:56:04.998762+00	
00000000-0000-0000-0000-000000000000	2f4a64a0-149d-45c2-b58b-7ca7c014e980	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-02 08:16:59.789756+00	
00000000-0000-0000-0000-000000000000	35a7af67-4bb8-485e-baeb-98b9288e24b3	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-02 08:17:12.413594+00	
00000000-0000-0000-0000-000000000000	487ff007-8613-48ed-a744-cfab3a7ce149	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-02 08:20:28.660024+00	
00000000-0000-0000-0000-000000000000	b6459719-f19b-4dce-bea6-e96524edeca1	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-02 08:50:29.644611+00	
00000000-0000-0000-0000-000000000000	e6e5f6f5-5f8d-4f16-9525-60a90e483c91	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-02 09:15:28.110583+00	
00000000-0000-0000-0000-000000000000	232bdb71-a19c-4001-bbdd-03ec0dee2777	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-02 09:15:28.113389+00	
00000000-0000-0000-0000-000000000000	d9d8da05-7d65-466a-a565-7e1d8b81b540	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-02 10:39:22.616808+00	
00000000-0000-0000-0000-000000000000	25594829-8c86-4ca1-8144-56f7ae38c55b	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-02 10:39:22.621837+00	
00000000-0000-0000-0000-000000000000	769adfad-49cc-4d61-ae5a-cd8cd2ca05e3	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-02 10:40:04.695099+00	
00000000-0000-0000-0000-000000000000	35add1c1-a263-4378-a7b4-c4b017ed3d0a	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-02 10:40:04.695695+00	
00000000-0000-0000-0000-000000000000	133ca947-dfc2-4759-ac63-4fa43956491b	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-05 05:11:29.155269+00	
00000000-0000-0000-0000-000000000000	87372afd-22cd-4ab3-a2a0-23795bedc918	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-05 05:11:29.169451+00	
00000000-0000-0000-0000-000000000000	1db915c5-8c87-4e0a-af50-35dedd1afdb7	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-05 05:11:40.280145+00	
00000000-0000-0000-0000-000000000000	4f1090cf-1e20-427c-96c8-fa82e9ca531c	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-05 05:11:46.479384+00	
00000000-0000-0000-0000-000000000000	a7c65902-7352-4e31-a0bd-a665e16841e9	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-05 05:11:49.586927+00	
00000000-0000-0000-0000-000000000000	0e1315f9-8ce2-4ad1-ab3d-c9475a4a1571	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-05 05:12:08.779836+00	
00000000-0000-0000-0000-000000000000	4139f45f-3c7d-48c7-8c8b-5c648ffd6af0	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-05 05:22:13.625257+00	
00000000-0000-0000-0000-000000000000	f0062b1d-ca68-4d1b-9d31-bc551a6af472	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-05 06:17:01.209819+00	
00000000-0000-0000-0000-000000000000	bba74bff-3d82-417c-8dc2-2c6d7bd03f4c	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-05 06:17:01.222721+00	
00000000-0000-0000-0000-000000000000	bf1bd1b8-47b2-46e6-b8ee-e85d37e02bf3	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-05 06:17:53.358615+00	
00000000-0000-0000-0000-000000000000	908f47bc-1fc0-4def-80ea-c7aab83b3e11	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-05 06:20:27.86352+00	
00000000-0000-0000-0000-000000000000	4cc101dc-8d53-408f-b39b-5fdcd2ad931f	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-05 06:20:27.864217+00	
00000000-0000-0000-0000-000000000000	0e6ad65e-352e-4047-acab-81a4da81b457	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-05 07:16:39.404558+00	
00000000-0000-0000-0000-000000000000	034eb7c8-85a7-4a33-8975-0af46f6e7cf7	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-05 07:16:39.409136+00	
00000000-0000-0000-0000-000000000000	33536f17-2e5b-40e4-a594-f30adf9bc2b6	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-05 07:18:40.086383+00	
00000000-0000-0000-0000-000000000000	a1c888c9-3cad-4b25-8355-25cd4f473611	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-05 07:18:40.089682+00	
00000000-0000-0000-0000-000000000000	156d0218-3e41-488d-97eb-509084d21862	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-05 08:15:09.941431+00	
00000000-0000-0000-0000-000000000000	b504cb06-b328-4853-80ee-642f96e48cd5	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-05 08:15:09.944764+00	
00000000-0000-0000-0000-000000000000	7faf24c7-be6a-46b8-a439-08ee299b6290	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-05 08:20:31.837226+00	
00000000-0000-0000-0000-000000000000	84afde3c-54b4-449f-99b7-347a89c3c0a7	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-05 08:20:31.842797+00	
00000000-0000-0000-0000-000000000000	954129c7-1df4-4932-a308-aa2a2d23fbb3	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-05 09:13:53.709608+00	
00000000-0000-0000-0000-000000000000	c81faf77-b643-4d16-8fe4-f024135de2c0	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-05 09:13:53.712326+00	
00000000-0000-0000-0000-000000000000	3341411f-59c3-4a91-b40a-eb2addeff298	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-05 09:25:51.502823+00	
00000000-0000-0000-0000-000000000000	ad3e1134-5477-47c7-90d9-b3fbc1449eac	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-05 09:56:22.342855+00	
00000000-0000-0000-0000-000000000000	c4fbcd15-9cf9-43e2-bc90-054c497f9757	{"action":"user_signedup","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"rupesh.sakthivel@iba-group.com","user_id":"6e6376f2-9648-4c72-80f2-809adfe63988","user_phone":""}}	2025-05-05 09:57:32.497769+00	
00000000-0000-0000-0000-000000000000	4cf8b276-e11a-438e-b440-93b006f666aa	{"action":"login","actor_id":"6e6376f2-9648-4c72-80f2-809adfe63988","actor_username":"rupesh.sakthivel@iba-group.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-05 09:57:51.679065+00	
00000000-0000-0000-0000-000000000000	9f526bea-df75-4f9f-9d83-da454951ac31	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-05 10:02:30.724866+00	
00000000-0000-0000-0000-000000000000	9f02f66e-10d3-41fe-af2e-a5c480c881b2	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-05 10:09:55.710075+00	
00000000-0000-0000-0000-000000000000	137fe277-a99b-44e9-a33e-c04c0d4a8dff	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-05 10:34:11.816526+00	
00000000-0000-0000-0000-000000000000	ba6c2120-fe1c-4d22-9797-376e5e92a68e	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-05 10:36:08.712929+00	
00000000-0000-0000-0000-000000000000	0cd48da7-01a9-40e3-bf46-6d07cc7eb714	{"action":"token_refreshed","actor_id":"6e6376f2-9648-4c72-80f2-809adfe63988","actor_username":"rupesh.sakthivel@iba-group.com","actor_via_sso":false,"log_type":"token"}	2025-05-05 10:56:11.071368+00	
00000000-0000-0000-0000-000000000000	bbc05ad5-5c22-4dc6-9b70-9daf67d297d2	{"action":"token_revoked","actor_id":"6e6376f2-9648-4c72-80f2-809adfe63988","actor_username":"rupesh.sakthivel@iba-group.com","actor_via_sso":false,"log_type":"token"}	2025-05-05 10:56:11.074771+00	
00000000-0000-0000-0000-000000000000	46f6b0bb-6ad7-4b6c-ad0a-470d273b1c72	{"action":"login","actor_id":"6e6376f2-9648-4c72-80f2-809adfe63988","actor_username":"rupesh.sakthivel@iba-group.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-05 10:56:31.870536+00	
00000000-0000-0000-0000-000000000000	3ffb0799-d717-4bb3-8569-88f2086037ab	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-05 11:45:07.325365+00	
00000000-0000-0000-0000-000000000000	bc90ffee-5f38-46a3-87b0-023d5784c7e8	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-05 11:45:07.333832+00	
00000000-0000-0000-0000-000000000000	015e4e20-a3e9-48bb-86c7-7062a0b89783	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-05 11:46:52.525127+00	
00000000-0000-0000-0000-000000000000	e4141923-49ea-462d-b925-d38b5a87a1ce	{"action":"token_refreshed","actor_id":"6e6376f2-9648-4c72-80f2-809adfe63988","actor_username":"rupesh.sakthivel@iba-group.com","actor_via_sso":false,"log_type":"token"}	2025-05-05 11:58:47.428681+00	
00000000-0000-0000-0000-000000000000	3fae56a3-7ee3-4e1d-a4b4-4d441d0435ec	{"action":"token_revoked","actor_id":"6e6376f2-9648-4c72-80f2-809adfe63988","actor_username":"rupesh.sakthivel@iba-group.com","actor_via_sso":false,"log_type":"token"}	2025-05-05 11:58:47.431873+00	
00000000-0000-0000-0000-000000000000	fbb309c3-8295-45ba-8d26-c022e121a221	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-05 12:12:18.761761+00	
00000000-0000-0000-0000-000000000000	f157cd20-7270-41f5-9bac-5a949ddc9fd3	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-05 12:13:12.007478+00	
00000000-0000-0000-0000-000000000000	fa04631f-5fb0-4f76-9403-ec31646f4b88	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"test@abc.com","user_id":"6531cf15-e8e5-4cca-9886-822f2aa40060","user_phone":""}}	2025-05-07 05:06:44.073159+00	
00000000-0000-0000-0000-000000000000	4a07b7e0-9b6e-401c-b9d5-7f76425c72a5	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-07 05:20:26.419633+00	
00000000-0000-0000-0000-000000000000	e0fa3ecd-34ce-4c5e-94b4-32b680027288	{"action":"user_invited","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"jithin.palottukandy@iba-group.com","user_id":"b6cae1db-3164-4e4d-81df-5c05e94d8f45"}}	2025-05-07 05:24:28.155364+00	
00000000-0000-0000-0000-000000000000	11383a61-0e3d-4d49-b2e1-64c605a3acab	{"action":"user_signedup","actor_id":"b6cae1db-3164-4e4d-81df-5c05e94d8f45","actor_username":"jithin.palottukandy@iba-group.com","actor_via_sso":false,"log_type":"team"}	2025-05-07 05:25:52.731952+00	
00000000-0000-0000-0000-000000000000	82819bef-55ea-416b-b8d5-4d6035d55f76	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"jithin.palottukandy@iba-group.com","user_id":"b6cae1db-3164-4e4d-81df-5c05e94d8f45","user_phone":""}}	2025-05-07 05:26:09.18128+00	
00000000-0000-0000-0000-000000000000	8e8b1090-71c9-4e42-a84a-6c460615584c	{"action":"user_invited","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"jithin.palottukandy@iba-group.com","user_id":"9a6389ff-f024-4c6e-90c9-a16147d69d4f"}}	2025-05-07 05:28:44.524567+00	
00000000-0000-0000-0000-000000000000	0f3f4bb9-76bb-4190-ae9c-385db351b2aa	{"action":"user_signedup","actor_id":"9a6389ff-f024-4c6e-90c9-a16147d69d4f","actor_username":"jithin.palottukandy@iba-group.com","actor_via_sso":false,"log_type":"team"}	2025-05-07 05:29:04.331736+00	
00000000-0000-0000-0000-000000000000	aa77b7d4-e51b-440e-bc72-b477473d916b	{"action":"user_recovery_requested","actor_id":"9a6389ff-f024-4c6e-90c9-a16147d69d4f","actor_username":"jithin.palottukandy@iba-group.com","actor_via_sso":false,"log_type":"user"}	2025-05-07 05:29:52.215553+00	
00000000-0000-0000-0000-000000000000	babacb3d-85d4-4325-9aef-45f1822fc43b	{"action":"login","actor_id":"9a6389ff-f024-4c6e-90c9-a16147d69d4f","actor_username":"jithin.palottukandy@iba-group.com","actor_via_sso":false,"log_type":"account"}	2025-05-07 05:30:08.408461+00	
00000000-0000-0000-0000-000000000000	b05d3e97-e0b3-42f9-8ccd-0f15792446e0	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-07 05:30:15.212967+00	
00000000-0000-0000-0000-000000000000	dd208176-85e4-4f64-b105-4713bd4ebbbb	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"jithin.palottukandy@iba-group.com","user_id":"9a6389ff-f024-4c6e-90c9-a16147d69d4f","user_phone":""}}	2025-05-07 05:30:35.728141+00	
00000000-0000-0000-0000-000000000000	b8b72b83-036e-42b2-b0cf-ba85d3361e77	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-07 06:13:32.423731+00	
00000000-0000-0000-0000-000000000000	15d44dd0-b45f-4310-8a3a-d1287c4cc7f1	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-07 07:12:55.656044+00	
00000000-0000-0000-0000-000000000000	7bca65b1-ae2b-413d-89cc-e4e370f335f0	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-07 07:12:55.668493+00	
00000000-0000-0000-0000-000000000000	9e616e9c-94fb-4436-8e42-1747236371c9	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-07 07:27:08.395694+00	
00000000-0000-0000-0000-000000000000	ff514cfe-8f12-446a-8da6-2e56bb71b60f	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-07 07:27:12.653162+00	
00000000-0000-0000-0000-000000000000	b667e769-92af-4c33-bb97-724638edb670	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-07 07:50:27.114804+00	
00000000-0000-0000-0000-000000000000	973ceccf-b3e5-46cb-bfc9-894e3048e643	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-07 08:38:08.740701+00	
00000000-0000-0000-0000-000000000000	f300164a-99f1-4353-8723-3953e217c878	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-07 09:15:01.548191+00	
00000000-0000-0000-0000-000000000000	6cd8c4ab-28d9-4cbf-a232-489d9884441d	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-07 09:35:43.765959+00	
00000000-0000-0000-0000-000000000000	18a447b6-066b-4b28-8d8b-6300a9d0a2e0	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-07 09:35:43.768529+00	
00000000-0000-0000-0000-000000000000	adb8bf1a-4b44-426f-be7c-bdc83a381c2b	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-07 09:35:59.864038+00	
00000000-0000-0000-0000-000000000000	3b85f3b9-247f-4437-8ba3-58ac7a8e55d0	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-07 10:35:08.999471+00	
00000000-0000-0000-0000-000000000000	b4a3fa32-b5d8-409e-8bcd-227e8d045598	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-07 10:35:09.003931+00	
00000000-0000-0000-0000-000000000000	0b53e3bb-9e83-40d4-ac6e-3c2dd77dbcbc	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-07 11:35:03.095023+00	
00000000-0000-0000-0000-000000000000	da623606-24e4-4c79-bc64-6d2b02fad07a	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-07 11:35:03.099433+00	
00000000-0000-0000-0000-000000000000	265ac915-102f-4339-969a-6f3c84c06912	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-07 11:35:21.640274+00	
00000000-0000-0000-0000-000000000000	712ff3d5-7e15-4aab-ac27-d9aa33051173	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-08 04:11:16.678839+00	
00000000-0000-0000-0000-000000000000	41736617-f118-46cc-96e3-69a726581ec8	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-08 04:11:16.707343+00	
00000000-0000-0000-0000-000000000000	78f6e8d4-41ac-4810-9ea9-66d3f43321f7	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-08 04:11:52.607134+00	
00000000-0000-0000-0000-000000000000	4c93d2a1-dcc6-436b-98e0-bc396c9d32d4	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-08 05:22:12.928005+00	
00000000-0000-0000-0000-000000000000	b5e22846-5834-459b-82e6-e1c46a434707	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-08 05:22:12.93147+00	
00000000-0000-0000-0000-000000000000	3a74ea15-6a21-4d98-a2b4-8384431d4eb3	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-08 05:54:24.465586+00	
00000000-0000-0000-0000-000000000000	dac00d07-d090-41b9-9486-344c829d2eff	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-08 05:57:15.005754+00	
00000000-0000-0000-0000-000000000000	e6653710-38f4-4561-840f-36251fb1af1e	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-08 07:17:54.127579+00	
00000000-0000-0000-0000-000000000000	08169d03-8ac4-4be4-967c-cb204e799d55	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-08 07:17:54.134893+00	
00000000-0000-0000-0000-000000000000	be6aa925-571a-413f-aebc-9b3feb49cd3e	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-08 08:17:42.226733+00	
00000000-0000-0000-0000-000000000000	bd208559-a6b4-4110-a422-fc9d559cb058	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-08 08:17:42.232999+00	
00000000-0000-0000-0000-000000000000	0c451d08-7510-4288-959e-1aa472e16ba0	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-08 08:17:54.562121+00	
00000000-0000-0000-0000-000000000000	2f4d8a25-f2f7-4a08-a3cd-9259623303eb	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-08 09:17:58.952884+00	
00000000-0000-0000-0000-000000000000	78d9d36f-96a7-4b85-9e72-30162777fbe1	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-08 09:17:58.960939+00	
00000000-0000-0000-0000-000000000000	2f4775bf-e614-477c-bbf5-db8a97bb89e6	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-08 10:17:38.857755+00	
00000000-0000-0000-0000-000000000000	0324a800-3161-4a40-8218-8d65a6bbb8aa	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-08 10:17:38.865098+00	
00000000-0000-0000-0000-000000000000	d1505b15-96c0-4c8a-99f9-8ad646906410	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-08 10:19:06.13597+00	
00000000-0000-0000-0000-000000000000	b6d579c9-039b-4849-bb90-da1c3d18b583	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-08 11:17:11.980525+00	
00000000-0000-0000-0000-000000000000	6c72f7fb-4dfb-48fd-b6dd-52565a73e7b0	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-08 11:17:11.985476+00	
00000000-0000-0000-0000-000000000000	aeed39e7-8661-49d7-a153-b821fa10782a	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-08 12:15:30.882198+00	
00000000-0000-0000-0000-000000000000	cdba475a-60f5-4249-9941-f34d3e82a279	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-08 12:15:30.885812+00	
00000000-0000-0000-0000-000000000000	222b9885-fa45-417c-ba0c-c9c4c2bcd4a0	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-08 13:21:51.283229+00	
00000000-0000-0000-0000-000000000000	4f4a1a15-a5b8-463a-aadf-ac4d7d6f094d	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-08 14:20:00.597415+00	
00000000-0000-0000-0000-000000000000	33982aeb-8b39-4e56-b06d-f41da50672ea	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-08 14:20:00.605138+00	
00000000-0000-0000-0000-000000000000	f57a8382-9d33-4f4f-b00b-c4ceed94b75a	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-08 14:53:29.558013+00	
00000000-0000-0000-0000-000000000000	8816427c-8299-4fa9-b6c1-e41c4085391b	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-08 15:02:15.263935+00	
00000000-0000-0000-0000-000000000000	dfc3560a-925c-47a6-9688-8ec13d2bb318	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-08 15:02:19.830375+00	
00000000-0000-0000-0000-000000000000	74f58e56-136e-4476-918e-4c3d983b9525	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-08 15:05:31.131759+00	
00000000-0000-0000-0000-000000000000	b2a4b40e-bbee-452d-957f-3896e4a9521a	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-09 00:08:36.193601+00	
00000000-0000-0000-0000-000000000000	11e82743-7609-4d3d-b5e7-41af32217454	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-09 00:33:13.312306+00	
00000000-0000-0000-0000-000000000000	691eccaa-5d12-4b60-89b4-c50766533d18	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-09 00:33:20.473897+00	
00000000-0000-0000-0000-000000000000	a43e390d-a5c6-40f5-832d-36713a1e0d27	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-09 01:31:38.372943+00	
00000000-0000-0000-0000-000000000000	95adefcd-9c09-40c2-8d15-22e6237bcc78	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-09 01:31:38.378981+00	
00000000-0000-0000-0000-000000000000	1d277068-436f-4d09-993b-78d3b3745cc2	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-09 01:33:39.311861+00	
00000000-0000-0000-0000-000000000000	891d5e81-0a44-4f28-bd93-dbc0b131e77f	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-09 02:32:43.746779+00	
00000000-0000-0000-0000-000000000000	f29b87f4-42a6-4ff0-b642-06c34f02139a	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-09 02:32:43.751306+00	
00000000-0000-0000-0000-000000000000	cc5327aa-67e6-4bcf-b1c5-82b364beaf15	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-09 02:45:32.473819+00	
00000000-0000-0000-0000-000000000000	f13a3cc8-9829-439b-8423-e2b478524749	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-09 03:30:49.056141+00	
00000000-0000-0000-0000-000000000000	0a571555-6a8a-494d-8597-2b8694a4577c	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-09 03:30:49.059403+00	
00000000-0000-0000-0000-000000000000	26e410df-9cf8-4b3d-988d-6dba1e26098b	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-09 03:43:57.604548+00	
00000000-0000-0000-0000-000000000000	076d745a-8eda-4c01-9130-1fa2d7fa66cb	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-09 03:43:57.608056+00	
00000000-0000-0000-0000-000000000000	6db1b2c3-78af-437e-8a3e-bc936f037618	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-09 03:56:25.186156+00	
00000000-0000-0000-0000-000000000000	8719c504-35ed-4723-94fa-4750941c6786	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-09 04:33:04.753114+00	
00000000-0000-0000-0000-000000000000	57ddfa63-2984-4617-abfa-ace959a9f0a3	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-09 04:33:04.757292+00	
00000000-0000-0000-0000-000000000000	e6b37953-4eae-4f17-ad59-8524293a9dba	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-09 04:42:15.980358+00	
00000000-0000-0000-0000-000000000000	ff9bf6be-7545-4f2b-8790-53b68e6918bd	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-09 04:42:15.986141+00	
00000000-0000-0000-0000-000000000000	c32f2c66-cbda-4331-959e-f496ca6c07e0	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-09 04:55:13.937372+00	
00000000-0000-0000-0000-000000000000	9d1973d1-9630-440c-af2c-efc8ebd947ac	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-09 04:55:13.940552+00	
00000000-0000-0000-0000-000000000000	39033d06-a368-4cb5-bdc7-06375bb1e062	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-09 05:31:11.191702+00	
00000000-0000-0000-0000-000000000000	b789c8dd-b986-4587-9a6e-3344e8d7aa4c	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-09 05:31:11.199596+00	
00000000-0000-0000-0000-000000000000	b3bbf677-519b-4876-98d1-b8928e026545	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-09 05:40:36.433006+00	
00000000-0000-0000-0000-000000000000	b25e2c2a-1a2b-4192-8bda-f1d8db5ad49d	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-09 05:40:36.436175+00	
00000000-0000-0000-0000-000000000000	fda69827-0981-44d5-b200-9593e0d88df0	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-09 06:29:57.720665+00	
00000000-0000-0000-0000-000000000000	a35584aa-72e0-4035-a41d-dd8b41efab64	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-09 06:29:57.729559+00	
00000000-0000-0000-0000-000000000000	f2ac08c9-7d2f-4a46-b4dc-da2a6f9b6039	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-09 06:38:53.63366+00	
00000000-0000-0000-0000-000000000000	c10282d9-bd87-4eec-a72f-49cb3b9fb2d1	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-09 06:38:53.636649+00	
00000000-0000-0000-0000-000000000000	fc476498-33f3-4aa7-b4f1-a649e7663c44	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-09 06:42:32.294883+00	
00000000-0000-0000-0000-000000000000	213a2e81-bd08-4bec-a6c2-7c10b0dcb4f7	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-09 06:54:47.050301+00	
00000000-0000-0000-0000-000000000000	4d661dd2-bb88-4df4-bd70-133003ab456c	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-09 07:40:55.084042+00	
00000000-0000-0000-0000-000000000000	e4330ca3-72e5-4ed9-bbbb-a7b85166377a	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-09 07:40:55.090639+00	
00000000-0000-0000-0000-000000000000	619fcaa8-82e9-4845-bc15-a8a6ef772f57	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-09 07:59:32.460629+00	
00000000-0000-0000-0000-000000000000	9f5f82ec-6957-43c8-83e3-d71676949aa4	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-09 07:59:32.463763+00	
00000000-0000-0000-0000-000000000000	d2174c6a-d0ff-4eec-b5c1-dda27e48b405	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-09 07:59:45.203506+00	
00000000-0000-0000-0000-000000000000	800a924e-000d-45f5-a811-1f8a839c26ba	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-09 08:55:02.188309+00	
00000000-0000-0000-0000-000000000000	6be8a440-43c3-4859-8476-bdfbce6cd82a	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-09 08:55:02.191471+00	
00000000-0000-0000-0000-000000000000	f28f5619-7615-44e1-80d9-d1ccfeaeeff3	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-09 14:39:41.668971+00	
00000000-0000-0000-0000-000000000000	ab415711-3d5a-4bad-9ede-e4e5e135fa36	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-09 15:38:20.538207+00	
00000000-0000-0000-0000-000000000000	ded21009-00a8-4a9e-b0fa-53cbf8350c8d	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-09 15:38:20.549006+00	
00000000-0000-0000-0000-000000000000	212cdb08-e9f9-4eff-979c-214f8704ff20	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-09 16:36:21.884763+00	
00000000-0000-0000-0000-000000000000	223fe677-11db-48d3-998e-951f5149fa74	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-09 16:36:21.889076+00	
00000000-0000-0000-0000-000000000000	c78f94be-2be9-445d-ab84-25da22ce8de1	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-09 17:35:18.069028+00	
00000000-0000-0000-0000-000000000000	42dde816-1287-408c-bbf6-47898d8905af	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-09 17:35:18.076689+00	
00000000-0000-0000-0000-000000000000	31af5cc8-4432-4b77-a0bd-2a82b6ff274a	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-09 17:59:47.775909+00	
00000000-0000-0000-0000-000000000000	005860eb-af2c-43eb-9da1-355caa0c46c2	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-09 17:59:50.955562+00	
00000000-0000-0000-0000-000000000000	6625d9cd-7770-477a-a9fa-6f89ebe951fe	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-09 18:57:56.844039+00	
00000000-0000-0000-0000-000000000000	886f3493-f8d6-4c0a-a25b-fea16560f199	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-09 18:57:56.856273+00	
00000000-0000-0000-0000-000000000000	dc0dd513-b27e-4fee-891f-bc98d0b3cc5a	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-09 19:15:07.64219+00	
00000000-0000-0000-0000-000000000000	e807e7d7-a3c5-4066-bc0d-aee6197b1caa	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-09 19:15:07.643877+00	
00000000-0000-0000-0000-000000000000	5be2418f-dbf5-4cb8-a938-db41dbe48169	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-09 19:18:48.126849+00	
00000000-0000-0000-0000-000000000000	c1c98a75-15eb-440b-95ed-952ce3bf7f1b	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-09 19:18:52.660605+00	
00000000-0000-0000-0000-000000000000	1ddf1b1d-7144-4520-8dce-2fd73b21223d	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-09 19:21:49.502111+00	
00000000-0000-0000-0000-000000000000	43ffe0bc-570e-4aa7-92a7-255ca6578e03	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-09 19:21:49.502997+00	
00000000-0000-0000-0000-000000000000	9a6556a5-04ef-4f30-9cd7-642e63d98139	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-09 19:23:59.248955+00	
00000000-0000-0000-0000-000000000000	c45b3706-37e4-4c69-b4c2-3814fd4c6c0d	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-09 19:23:59.25091+00	
00000000-0000-0000-0000-000000000000	3a677597-eba2-4d1c-a764-e6fc8e9d9f0f	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-09 19:24:34.324886+00	
00000000-0000-0000-0000-000000000000	00b57541-82b5-4862-ada7-3d07efca0885	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-09 19:24:34.325552+00	
00000000-0000-0000-0000-000000000000	a1b9f264-8d95-44f6-a37b-724bf2316c9b	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-09 19:28:59.05395+00	
00000000-0000-0000-0000-000000000000	dc5de100-e971-477c-89f4-228d85f4a29f	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-09 19:28:59.056165+00	
00000000-0000-0000-0000-000000000000	183be9de-f939-4d4b-a843-f674ca272ebc	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-09 19:29:51.007335+00	
00000000-0000-0000-0000-000000000000	9ee2c54e-db59-4316-be5c-34dfec7e40a1	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-09 19:29:51.008001+00	
00000000-0000-0000-0000-000000000000	4e884b13-ab09-432f-bddd-91417e611a02	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-09 19:30:24.720527+00	
00000000-0000-0000-0000-000000000000	c6e52c5a-f546-4330-b649-4d8fa70fc8ba	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-09 19:30:24.721223+00	
00000000-0000-0000-0000-000000000000	83e62860-e81a-4806-8333-cefb8f6cd0e7	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-09 19:31:21.536676+00	
00000000-0000-0000-0000-000000000000	5b072bf6-d53b-4e2d-90f2-16992a1b79dd	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-09 19:31:21.537269+00	
00000000-0000-0000-0000-000000000000	620d354c-d060-4e46-ada0-5be79c8ebd0d	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-09 19:32:13.651574+00	
00000000-0000-0000-0000-000000000000	c103c05c-b35e-4002-a0d3-9d60ee666f3c	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-09 19:32:13.652232+00	
00000000-0000-0000-0000-000000000000	a0419bb1-9ee4-44de-ab15-89dda3180a99	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-09 19:32:22.589677+00	
00000000-0000-0000-0000-000000000000	9d5bc545-4dc3-4691-ba6e-d21171d7ada4	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-09 19:32:22.590268+00	
00000000-0000-0000-0000-000000000000	c844c9da-041e-45ec-b741-482de10f205f	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-09 19:34:51.734781+00	
00000000-0000-0000-0000-000000000000	3b02586c-827f-440f-9caf-bc8d07b325ff	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-09 19:34:51.736305+00	
00000000-0000-0000-0000-000000000000	ac26e990-33f7-43d5-b3f3-b490a5c94785	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-10 02:27:55.437226+00	
00000000-0000-0000-0000-000000000000	7a44f7bf-d17b-4144-8166-1cee322d67fb	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-10 02:27:55.442078+00	
00000000-0000-0000-0000-000000000000	555902f0-c9be-4b9d-be2d-707a20f42384	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-10 02:44:52.894149+00	
00000000-0000-0000-0000-000000000000	7fc82596-02c8-44ca-ba90-b98859f294e5	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-10 02:45:04.203517+00	
00000000-0000-0000-0000-000000000000	c31f5504-ae6e-4252-95ba-fd739293931d	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-10 02:50:46.070774+00	
00000000-0000-0000-0000-000000000000	086b2b2e-061c-4ae1-aee9-4bb732624d0a	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-10 03:43:34.344029+00	
00000000-0000-0000-0000-000000000000	a98c173c-6d41-432b-8407-9353124cc529	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-10 03:43:34.348821+00	
00000000-0000-0000-0000-000000000000	9ad29bfb-cba1-47c9-a35c-ea5e35754d7c	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-10 03:47:02.46104+00	
00000000-0000-0000-0000-000000000000	39a3ed25-86d1-4062-9ef9-fbd4a6fe6d6c	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-10 05:17:11.846976+00	
00000000-0000-0000-0000-000000000000	e658936c-817e-4b13-85a5-c1652cbb91fe	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-10 05:29:02.990466+00	
00000000-0000-0000-0000-000000000000	5fa09403-9053-49ab-a2d6-26289257708d	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-10 05:29:07.009088+00	
00000000-0000-0000-0000-000000000000	80df3a44-dc84-46b8-aca1-1b39d5dae440	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-10 05:29:13.294839+00	
00000000-0000-0000-0000-000000000000	c5260fa5-72bd-41cd-a8d6-fa3e997ed96e	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-10 05:29:23.991032+00	
00000000-0000-0000-0000-000000000000	05ec8eae-8e9f-496f-81e7-e7066bc956fc	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-10 05:47:38.881719+00	
00000000-0000-0000-0000-000000000000	0b325751-2d3a-433f-b699-e32ebffb00e6	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-10 05:47:38.884829+00	
00000000-0000-0000-0000-000000000000	0ac51097-bde8-4d4d-a0d8-42a64c237922	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-10 05:47:38.906896+00	
00000000-0000-0000-0000-000000000000	f3dac4ca-e361-47fe-b94c-a7300df61b22	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-10 05:47:38.919541+00	
00000000-0000-0000-0000-000000000000	d78db589-f7fb-49d4-9c8f-40464311f503	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-10 05:47:50.506397+00	
00000000-0000-0000-0000-000000000000	20861e10-8513-407e-ae0a-1e3ef6c78b9e	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-10 05:47:50.508467+00	
00000000-0000-0000-0000-000000000000	698985a5-d293-4863-9da1-6b2b955f4f74	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-10 05:47:50.75403+00	
00000000-0000-0000-0000-000000000000	dfc8fcb6-dba1-4aab-9ddf-b8d8b2c3a7c9	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-10 05:47:51.261109+00	
00000000-0000-0000-0000-000000000000	aef5fa3c-774b-412f-8325-fce7d055d7f4	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-10 05:47:51.261686+00	
00000000-0000-0000-0000-000000000000	c4e34942-0a3a-4e40-8214-24a62e0d8833	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-10 05:47:51.297044+00	
00000000-0000-0000-0000-000000000000	d9fef711-f9fb-4d80-919a-e2da33fd152f	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-10 05:47:59.575527+00	
00000000-0000-0000-0000-000000000000	2a9ba480-076e-489b-ae1e-ede81bbfd38c	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-10 05:47:59.576152+00	
00000000-0000-0000-0000-000000000000	e14533b1-1d77-4acb-acb7-c473cc053438	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-10 05:48:11.717092+00	
00000000-0000-0000-0000-000000000000	d7c41a20-56de-47af-b8db-db565d08361b	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-10 05:48:11.717729+00	
00000000-0000-0000-0000-000000000000	1f1cc900-1f7f-4196-bb44-4c89395e0c1b	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-10 05:48:40.916091+00	
00000000-0000-0000-0000-000000000000	fe883883-fe82-4dd6-a909-3c6e611aacc2	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-10 05:48:40.916807+00	
00000000-0000-0000-0000-000000000000	477c9823-a076-4eb8-a8cf-7e6aa2a5340d	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-10 05:51:15.68288+00	
00000000-0000-0000-0000-000000000000	8041a091-5201-490c-85b0-40dc39b188dd	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-10 05:51:26.252908+00	
00000000-0000-0000-0000-000000000000	1e34bcac-0af9-49b8-9f53-a12f5e6f985f	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-10 05:51:26.254309+00	
00000000-0000-0000-0000-000000000000	ab3ecf9d-eaab-4985-b3eb-267ff44e9519	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-10 05:53:33.201746+00	
00000000-0000-0000-0000-000000000000	6ee8e1e4-f759-4acd-ad3b-147d26042cc0	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-10 05:53:33.202771+00	
00000000-0000-0000-0000-000000000000	85875b04-2346-4b7a-97aa-33ff63fdfd10	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-10 06:01:49.94109+00	
00000000-0000-0000-0000-000000000000	6e07666e-7329-44af-bd7b-e35e3e19431f	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-10 06:01:49.943978+00	
00000000-0000-0000-0000-000000000000	9366a94f-71b8-45c4-9b8a-24242753877a	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-10 06:01:49.967718+00	
00000000-0000-0000-0000-000000000000	63f34035-9f10-4122-b161-63a69c6e60f5	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-10 06:02:48.01236+00	
00000000-0000-0000-0000-000000000000	9dd42f75-fbcd-49c0-8d4e-80ecdf3bd809	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-10 06:02:48.01294+00	
00000000-0000-0000-0000-000000000000	20e4cef8-bae2-403e-9caa-fc5c389c8e1a	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-10 06:03:02.782734+00	
00000000-0000-0000-0000-000000000000	84e4f576-4792-4ce6-9990-ad9e722bcf4c	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-10 06:03:02.783359+00	
00000000-0000-0000-0000-000000000000	6b590041-3894-47a7-868c-0bd5c472f5ff	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-10 06:03:14.059599+00	
00000000-0000-0000-0000-000000000000	e46064a5-4987-4a97-ad46-cb2354d5c39d	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-10 06:03:14.060171+00	
00000000-0000-0000-0000-000000000000	07064c00-f424-4c95-b8d3-3fc2909c22e4	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-10 06:07:38.016504+00	
00000000-0000-0000-0000-000000000000	77930e1d-4668-44c3-8830-dcfb63adca3e	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-10 06:07:38.018281+00	
00000000-0000-0000-0000-000000000000	a5aa5c22-7cd2-472a-8f51-78d8ab9b194c	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-10 06:10:01.133917+00	
00000000-0000-0000-0000-000000000000	6f3aeebc-8d56-4d31-8068-5d86560751ad	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-10 06:10:28.132102+00	
00000000-0000-0000-0000-000000000000	8d9c34a4-f77c-4b16-8ba2-557a981a4d60	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-10 06:10:28.132767+00	
00000000-0000-0000-0000-000000000000	aab5cf2b-fb55-4f3d-8ecf-cb4549cdb02e	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-10 06:11:17.863999+00	
00000000-0000-0000-0000-000000000000	feaf7995-e473-42b9-b1e0-fcfb781c22fa	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-10 06:11:17.864626+00	
00000000-0000-0000-0000-000000000000	c8d2ef1d-ad24-4759-83ad-cf712f3c1423	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-10 06:12:15.817316+00	
00000000-0000-0000-0000-000000000000	6ed94c28-71a2-4afe-8b6b-d8384515e861	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-10 06:15:11.558598+00	
00000000-0000-0000-0000-000000000000	7fd931e2-935a-4cb3-9349-715e2d7c1e66	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-10 06:15:30.481066+00	
00000000-0000-0000-0000-000000000000	ea67efcf-ffd6-49b4-962b-a445fb4a1986	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-10 07:03:01.718469+00	
00000000-0000-0000-0000-000000000000	c1cfddfd-d072-497b-b698-7bcb906c75ec	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-10 07:03:13.698835+00	
00000000-0000-0000-0000-000000000000	d5ab669b-bbc2-44ac-8375-c91ac35dae47	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-10 08:57:40.491546+00	
00000000-0000-0000-0000-000000000000	bfbae518-d6c1-4038-b01d-55c24e923364	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-10 08:57:40.494519+00	
00000000-0000-0000-0000-000000000000	7e34d78e-cff1-4e50-964e-9c63524a287f	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-10 08:57:40.508745+00	
00000000-0000-0000-0000-000000000000	00b69e57-b7e2-4edf-855f-9236194561ed	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-10 09:21:43.166436+00	
00000000-0000-0000-0000-000000000000	291641ab-8523-4366-bc97-e76720fd23bf	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-10 09:43:38.827555+00	
00000000-0000-0000-0000-000000000000	0107c1d4-a146-4492-9c50-41dbfebbb4ca	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-10 09:43:44.342626+00	
00000000-0000-0000-0000-000000000000	84a74a7d-c284-4c70-8911-7507d7532b7b	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-10 14:00:20.092565+00	
00000000-0000-0000-0000-000000000000	2c8e95cb-2699-4b71-8470-c27592e9e95e	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-10 14:00:20.099308+00	
00000000-0000-0000-0000-000000000000	9b3fdd8c-14dc-4e80-be9c-2ed725baaacb	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-10 14:00:34.998877+00	
00000000-0000-0000-0000-000000000000	e4cb5853-90a7-4842-8ebf-3440f5b96efd	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-10 18:31:34.882507+00	
00000000-0000-0000-0000-000000000000	35b3cd8e-2f5d-442a-a089-0bc25b72848d	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-10 18:31:34.885804+00	
00000000-0000-0000-0000-000000000000	7e7d85f5-a7ac-4830-bf41-1a510bc493b5	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-10 18:32:02.7632+00	
00000000-0000-0000-0000-000000000000	6e15fcc4-1206-491f-9c81-a6e292ffa515	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-10 19:14:49.270928+00	
00000000-0000-0000-0000-000000000000	0b9bc7c7-a572-454f-8228-1801413ed699	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-10 19:14:55.926927+00	
00000000-0000-0000-0000-000000000000	b3206a64-711d-41e1-b774-a57052205e1f	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-10 19:17:45.862595+00	
00000000-0000-0000-0000-000000000000	203d9585-65c0-4d4f-9de4-fd2732ddaa75	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-10 19:17:49.606699+00	
00000000-0000-0000-0000-000000000000	aa1a2540-7a81-4d9b-8dfe-98f9017f8286	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-10 19:18:21.127597+00	
00000000-0000-0000-0000-000000000000	9986b5be-fc3a-4ed2-9675-314aceceeedb	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-10 19:23:15.128818+00	
00000000-0000-0000-0000-000000000000	77ac8668-a0e1-4dcc-ba4b-b5074e0427f6	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-10 19:24:34.018065+00	
00000000-0000-0000-0000-000000000000	9421e0c3-ebfc-4525-9fac-b78bc8899412	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-10 19:24:37.057895+00	
00000000-0000-0000-0000-000000000000	928c9509-6f5a-46d5-b05a-87cb235a6826	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-10 19:32:45.333286+00	
00000000-0000-0000-0000-000000000000	8925270e-5f51-49bd-8254-9f8a9d8a3122	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-10 19:32:45.338568+00	
00000000-0000-0000-0000-000000000000	cf1cec4f-ef1e-4e0e-be95-e192f60c2992	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-10 19:32:45.366814+00	
00000000-0000-0000-0000-000000000000	b7e27e4e-9742-443d-8c0d-11647d3b3779	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-10 19:32:48.365715+00	
00000000-0000-0000-0000-000000000000	c6bfd152-2cde-4611-baa4-09f7ee937f47	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-10 19:32:48.366357+00	
00000000-0000-0000-0000-000000000000	dc689512-8035-40b0-a2fa-a187fe375492	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-10 19:32:54.193916+00	
00000000-0000-0000-0000-000000000000	d55814fc-b92c-46ab-983d-d13df0464cdc	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-10 19:32:54.194586+00	
00000000-0000-0000-0000-000000000000	61284046-8361-4ce6-9689-0e79fc7b2df6	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-10 19:33:14.851753+00	
00000000-0000-0000-0000-000000000000	cf48b8a7-0f50-426a-856a-d0e07edfcd97	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-10 19:33:14.853421+00	
00000000-0000-0000-0000-000000000000	01ff9d62-0362-4ddd-818a-70af1fcf9016	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-10 19:33:40.971806+00	
00000000-0000-0000-0000-000000000000	9e6f3917-090d-46c5-9fda-ba622cea602f	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-10 19:33:40.972428+00	
00000000-0000-0000-0000-000000000000	94fe5ef3-2f92-46db-92de-952ae1ba8720	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-10 19:38:20.598455+00	
00000000-0000-0000-0000-000000000000	d4e2b1cd-44a8-44db-a2f6-e190c336a029	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-10 19:38:20.600114+00	
00000000-0000-0000-0000-000000000000	42d118b4-1566-4074-9a63-aa8aa6467e26	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-10 19:38:32.000462+00	
00000000-0000-0000-0000-000000000000	89987298-08ed-449a-91fa-6dcd4570b507	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-10 19:38:32.001151+00	
00000000-0000-0000-0000-000000000000	b6bc27b4-e01c-4989-b133-bca224395ae2	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-10 19:39:45.173541+00	
00000000-0000-0000-0000-000000000000	edb6b998-7e41-4e3b-b1b8-c43dedada450	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-10 19:39:45.175125+00	
00000000-0000-0000-0000-000000000000	acaec125-d59a-4ddc-a646-9fdbb73aba92	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-10 19:41:35.109639+00	
00000000-0000-0000-0000-000000000000	00371f85-f350-43f8-8f7e-78ca9a12b2dc	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-10 19:41:35.110278+00	
00000000-0000-0000-0000-000000000000	727ff439-5053-48d7-9949-f9939af8b665	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 03:48:45.043188+00	
00000000-0000-0000-0000-000000000000	0a1f101a-3132-4458-a03c-d696b7c857a7	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 03:48:45.048598+00	
00000000-0000-0000-0000-000000000000	b71094cc-dc27-40d8-9a8c-8971641bae7a	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 03:52:42.9912+00	
00000000-0000-0000-0000-000000000000	a8ad3109-51e2-43c3-a4ed-b2f9228e5fc9	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 03:52:42.996236+00	
00000000-0000-0000-0000-000000000000	24a17435-c43a-4e5b-8186-748381269c7f	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 03:52:53.153967+00	
00000000-0000-0000-0000-000000000000	effbf03d-70fe-4529-9338-6f40902a54b6	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 03:52:53.15532+00	
00000000-0000-0000-0000-000000000000	f72c2486-c563-4918-affc-4efe73be1a86	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 04:16:03.829329+00	
00000000-0000-0000-0000-000000000000	5ffeac0e-2914-4d39-908e-66693bb29a30	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 04:16:03.831627+00	
00000000-0000-0000-0000-000000000000	d8fba254-9d7c-4d68-babc-80417149d2bb	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 04:16:17.006727+00	
00000000-0000-0000-0000-000000000000	789201b1-9026-4865-b7e2-537548cf7d2f	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 04:16:17.008091+00	
00000000-0000-0000-0000-000000000000	7c726bef-b75c-41fb-ad5a-ac85ee2a358c	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 04:16:42.707777+00	
00000000-0000-0000-0000-000000000000	694b18cc-0aa1-4706-915a-dab3cc1fc0d2	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 04:16:42.708474+00	
00000000-0000-0000-0000-000000000000	56ab910e-1c4e-4e93-954a-9c301b5f9691	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 04:17:03.064974+00	
00000000-0000-0000-0000-000000000000	9bc5c71b-c417-40f1-a09b-de2076e27568	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 04:17:03.065647+00	
00000000-0000-0000-0000-000000000000	ba39c03c-bfd7-4a43-845b-c1a80706a69d	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 04:17:37.579861+00	
00000000-0000-0000-0000-000000000000	b5a25e47-fd74-49de-b5c5-168f43a66a6c	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 04:17:37.581174+00	
00000000-0000-0000-0000-000000000000	ec3b9607-f852-467d-92f9-515f26a2cde3	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 04:20:10.507842+00	
00000000-0000-0000-0000-000000000000	30184f38-8f10-4d4e-8ba7-6ce9b3efcb90	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 04:20:10.510295+00	
00000000-0000-0000-0000-000000000000	f24c11a8-ad37-4f77-ab7e-e83c7103e6d8	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 04:20:21.487306+00	
00000000-0000-0000-0000-000000000000	d93e4f1f-305f-472c-94fa-57e654975a54	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 04:20:21.487881+00	
00000000-0000-0000-0000-000000000000	8fe31009-a772-48d9-b298-3bad734f132d	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 05:06:46.183207+00	
00000000-0000-0000-0000-000000000000	3538aca3-7163-409b-ae53-df6c5d0cb744	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 05:06:46.184941+00	
00000000-0000-0000-0000-000000000000	3dde6281-4d75-4963-8818-a853046f8ca1	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 05:07:07.457296+00	
00000000-0000-0000-0000-000000000000	a7c7b602-dd67-4da9-93de-ed4a5fc07dd8	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 05:07:07.457937+00	
00000000-0000-0000-0000-000000000000	60ec2c6b-41a2-4379-9295-61b0952dd5dc	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 05:11:43.650297+00	
00000000-0000-0000-0000-000000000000	870c7764-ecb6-462f-b0cd-01ce7e824db8	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 05:11:43.653428+00	
00000000-0000-0000-0000-000000000000	33a3de57-7a0d-441c-adeb-070138031563	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 05:12:08.429331+00	
00000000-0000-0000-0000-000000000000	9f2ffdc2-4402-413a-8a77-7af6c6697f49	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 05:12:08.429943+00	
00000000-0000-0000-0000-000000000000	91387bbd-a694-4cce-95b5-a9ad9728930b	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 05:13:23.696373+00	
00000000-0000-0000-0000-000000000000	383bbac5-2fba-4f59-9fca-93df4549d65d	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 05:13:23.697229+00	
00000000-0000-0000-0000-000000000000	05edffae-f5a3-4bbf-8d86-41ae69434bbd	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 05:13:42.612415+00	
00000000-0000-0000-0000-000000000000	62ba6f14-9733-44fd-96c7-13c990020262	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 05:17:17.187825+00	
00000000-0000-0000-0000-000000000000	bb3e54f9-f6b4-46b4-b90d-34085ccc4193	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 05:17:17.189962+00	
00000000-0000-0000-0000-000000000000	32177181-3551-4bb8-b041-81385f321052	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 05:17:48.2979+00	
00000000-0000-0000-0000-000000000000	597bebcf-d334-460a-9381-bf5e9e605b8e	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 05:17:48.298535+00	
00000000-0000-0000-0000-000000000000	7fad89bc-50a5-4265-b34f-8414d1d8e0d8	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 05:18:56.75415+00	
00000000-0000-0000-0000-000000000000	444669ab-fe4e-4d18-8b3d-82ed1e16e39a	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 05:18:56.755487+00	
00000000-0000-0000-0000-000000000000	2192b935-6080-4558-8437-35b17a7d94dd	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 05:19:16.35418+00	
00000000-0000-0000-0000-000000000000	b5c424e7-a094-49b9-939a-d54b5b44e389	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 05:19:16.35623+00	
00000000-0000-0000-0000-000000000000	8cdbdcbd-4efc-4b8e-8c44-7431257e4b69	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 05:24:04.682779+00	
00000000-0000-0000-0000-000000000000	1825e5e9-9e7c-4307-b1ec-60061e723614	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 05:24:04.683767+00	
00000000-0000-0000-0000-000000000000	e5e56b17-c971-4e50-b4d2-b2093435fb24	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 05:24:52.244137+00	
00000000-0000-0000-0000-000000000000	25ca9511-56cd-4bf0-818b-36f11996b693	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 05:24:52.247277+00	
00000000-0000-0000-0000-000000000000	1afbc015-65db-4deb-b16e-68e37b74a4eb	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 05:25:12.051471+00	
00000000-0000-0000-0000-000000000000	0ca91bda-097c-4f58-ae20-e4c93c304fc3	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 05:25:12.052064+00	
00000000-0000-0000-0000-000000000000	d9cf99a9-75ae-404d-a5c7-a89c3b6f24e2	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-11 05:30:00.113791+00	
00000000-0000-0000-0000-000000000000	04398cde-cdf5-4964-97b1-89671b8d2671	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 05:30:51.579739+00	
00000000-0000-0000-0000-000000000000	a1a9d667-ca58-4061-892e-d5516780122f	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 05:30:51.580976+00	
00000000-0000-0000-0000-000000000000	fa081595-ffc5-4c86-872a-0cd732fa0906	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 05:31:53.181927+00	
00000000-0000-0000-0000-000000000000	55ea7005-f872-4b9c-b9dd-122589ebe7a9	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 05:31:53.182598+00	
00000000-0000-0000-0000-000000000000	767f6c71-fec5-460d-8de3-e08293d10f6e	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 05:34:22.217203+00	
00000000-0000-0000-0000-000000000000	e71c234a-46af-472e-aa80-d427c1f352ba	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 05:34:22.220518+00	
00000000-0000-0000-0000-000000000000	456cd0ef-4d17-4ad0-bbff-c1a00733970b	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 06:15:59.776923+00	
00000000-0000-0000-0000-000000000000	7f48737a-954d-4877-b819-57b82bf60cbe	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 06:15:59.780052+00	
00000000-0000-0000-0000-000000000000	722ed785-cbbe-468b-9edd-50f4e3c88279	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 06:17:33.888051+00	
00000000-0000-0000-0000-000000000000	1257588a-d710-41d0-beed-58a778f7b221	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 06:17:33.888965+00	
00000000-0000-0000-0000-000000000000	3061a88f-648c-46ae-a2c9-305128b6b1f1	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-11 06:19:06.861052+00	
00000000-0000-0000-0000-000000000000	23dfff9a-bc0e-47e1-aac4-e3efabd8b457	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 06:19:26.572969+00	
00000000-0000-0000-0000-000000000000	72885591-3d30-4b24-b6ab-c9af68493015	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 06:19:26.576752+00	
00000000-0000-0000-0000-000000000000	8135a742-a282-4a00-a991-b28b7d54d7c6	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 06:24:44.654356+00	
00000000-0000-0000-0000-000000000000	0bbce0b4-3ca2-41da-94e4-48ec68a57b52	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 06:24:44.657668+00	
00000000-0000-0000-0000-000000000000	20ba2e98-e071-4619-9686-31112029c884	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 06:25:23.646794+00	
00000000-0000-0000-0000-000000000000	77645b85-88a2-4092-8434-c3fd14b1053e	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 06:25:23.648099+00	
00000000-0000-0000-0000-000000000000	4f9d4fb2-89d3-4787-a955-50c53a5cb469	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 06:26:15.269391+00	
00000000-0000-0000-0000-000000000000	917d5076-f2e9-4da4-8959-d8a2a1456284	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 06:26:15.270105+00	
00000000-0000-0000-0000-000000000000	d28e63aa-24d9-47fd-b942-0d17efdb959d	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 06:37:13.893871+00	
00000000-0000-0000-0000-000000000000	3ef67cec-db6b-4a31-9f44-cc8cc6195ef6	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 06:37:13.897733+00	
00000000-0000-0000-0000-000000000000	36771294-f2c7-4800-825c-f689b4c4c396	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 06:37:35.752151+00	
00000000-0000-0000-0000-000000000000	e2b379bb-c405-4404-8909-bf37a2b16f87	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 06:37:35.752806+00	
00000000-0000-0000-0000-000000000000	d84a9449-ce34-4170-9554-177a4f60825e	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 07:36:23.330248+00	
00000000-0000-0000-0000-000000000000	d573111a-007d-4634-ae23-94dc58fac890	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 07:36:23.338479+00	
00000000-0000-0000-0000-000000000000	744b7a4b-29e5-4a71-860b-e9aa980668b6	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 08:07:43.493103+00	
00000000-0000-0000-0000-000000000000	d395503c-0fce-4613-a65f-896256d3822b	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 08:07:43.496881+00	
00000000-0000-0000-0000-000000000000	113f43ef-d960-49d0-8aba-99f5d1c8f8ff	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-11 08:15:35.066854+00	
00000000-0000-0000-0000-000000000000	25ee6218-2f14-4aa1-a53b-d0bc865e771f	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 08:15:49.829222+00	
00000000-0000-0000-0000-000000000000	a12e1548-f258-408b-befc-83585113536a	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 08:15:49.829791+00	
00000000-0000-0000-0000-000000000000	ee9fdacb-df9c-4966-9729-80cdaa433566	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 08:20:00.398634+00	
00000000-0000-0000-0000-000000000000	9cda10ca-60bb-4de1-a697-8f8bba9a2a49	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 08:20:00.401813+00	
00000000-0000-0000-0000-000000000000	92b1cd72-61a8-453d-a105-1446600277bd	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 08:24:30.827042+00	
00000000-0000-0000-0000-000000000000	38fe7bd0-079a-43d3-a9a3-7c061eadf772	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 08:24:30.82859+00	
00000000-0000-0000-0000-000000000000	a0860ae3-88c1-46c8-bfa7-91a3c87a8760	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 08:24:30.84677+00	
00000000-0000-0000-0000-000000000000	0fcf2859-cb75-4e4c-9b3c-5c52c8530055	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 08:24:30.881125+00	
00000000-0000-0000-0000-000000000000	949afe1d-de99-44bb-a0ba-fb20e5092144	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 08:24:46.453287+00	
00000000-0000-0000-0000-000000000000	894c9ad7-07dc-4adf-b55c-20ff79dc0375	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 08:24:46.454661+00	
00000000-0000-0000-0000-000000000000	232473b4-d3e5-44f2-b299-d59d3dd0a3c7	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 08:27:13.101153+00	
00000000-0000-0000-0000-000000000000	0ba25aeb-6ff9-4347-acb5-bd48b1e70459	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 08:27:13.1027+00	
00000000-0000-0000-0000-000000000000	95980eb9-955e-47a7-afce-693ce72f388c	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 08:27:29.316602+00	
00000000-0000-0000-0000-000000000000	7fb4740c-fae2-44d9-a5d5-245d4a17d449	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 08:27:29.317236+00	
00000000-0000-0000-0000-000000000000	4f4dfc9a-dc69-42a1-b1e5-1cf6af7d621b	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 08:31:15.747839+00	
00000000-0000-0000-0000-000000000000	0ac9e872-8b79-4d39-8e27-94ac94234744	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 08:31:15.749714+00	
00000000-0000-0000-0000-000000000000	8534a7a8-4b2f-4539-a34d-ecb3dfbf4116	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 08:33:39.905483+00	
00000000-0000-0000-0000-000000000000	21dc6f03-555d-40a5-9662-63042c5c8560	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 08:33:39.906458+00	
00000000-0000-0000-0000-000000000000	caaf746c-9b62-4883-99ba-2df808a2f706	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 08:40:05.988342+00	
00000000-0000-0000-0000-000000000000	5fb3836b-7bb9-48be-98b7-8d05abf3dd2d	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 08:40:05.99066+00	
00000000-0000-0000-0000-000000000000	e260e80f-1b8d-4fec-ada6-6e7818ca5db3	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 08:41:07.423422+00	
00000000-0000-0000-0000-000000000000	1db96538-0e69-4fa0-9466-71ad90c8db43	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 08:41:07.424066+00	
00000000-0000-0000-0000-000000000000	271d07e1-6098-4d62-904f-53fbf071e9c1	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 08:43:54.401353+00	
00000000-0000-0000-0000-000000000000	9b3fa64d-e97e-4eda-a16a-373bcf28e4cf	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 08:43:54.402184+00	
00000000-0000-0000-0000-000000000000	e20ad0a3-747b-4855-b95f-039b221bda65	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 08:45:47.319144+00	
00000000-0000-0000-0000-000000000000	0ceb5be6-911c-4a0d-a151-5e842e94bdb9	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 08:45:47.321369+00	
00000000-0000-0000-0000-000000000000	147fd5d9-d684-4fa2-9691-2f301ff637c8	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 08:50:37.832035+00	
00000000-0000-0000-0000-000000000000	2311e951-571e-43b4-bf14-11c9d39ff927	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 08:50:37.833691+00	
00000000-0000-0000-0000-000000000000	0580f191-6e53-4920-ae56-14589dd82cd1	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 08:53:59.211872+00	
00000000-0000-0000-0000-000000000000	214455f3-2e8a-4162-8fff-8e26e3bb75e3	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-11 08:53:59.212719+00	
00000000-0000-0000-0000-000000000000	ba0c00f0-5c25-4674-a4ac-c930032761b5	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-12 01:14:28.790288+00	
00000000-0000-0000-0000-000000000000	62f3fd25-07b9-43fc-8f77-347103ecbda7	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-12 01:15:05.898005+00	
00000000-0000-0000-0000-000000000000	3474619b-411a-400e-b641-1c43e112aed4	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-12 01:15:05.899932+00	
00000000-0000-0000-0000-000000000000	d829f124-430e-49d4-8cec-f459b6b6f705	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-12 01:15:26.062046+00	
00000000-0000-0000-0000-000000000000	930e4544-7a4b-4c73-aca1-51eb13b58192	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-12 01:15:26.063432+00	
00000000-0000-0000-0000-000000000000	aee5dcbd-6a7c-43ac-b508-1173d28fff6c	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-12 01:15:50.951572+00	
00000000-0000-0000-0000-000000000000	5929d36f-7aca-4bd9-8657-5b1caaa0521e	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-12 01:15:50.952192+00	
00000000-0000-0000-0000-000000000000	e22eac2a-0e16-4ba5-a82e-97d796039edd	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-12 01:22:01.798357+00	
00000000-0000-0000-0000-000000000000	14a5d63e-63cf-4bf0-85f9-bb83cb34cdb1	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-12 01:22:01.803465+00	
00000000-0000-0000-0000-000000000000	9ea41605-e7ec-4d21-89e5-70db7ce3d07f	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-12 01:22:54.177894+00	
00000000-0000-0000-0000-000000000000	99d540e7-f34e-4c58-bed9-8918846d7059	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-12 01:22:54.180443+00	
00000000-0000-0000-0000-000000000000	4a3ece2c-72ae-48a6-8fa0-aa9edfcc893b	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-12 01:23:20.404188+00	
00000000-0000-0000-0000-000000000000	6b8a24fa-7f46-4900-8594-ce2a1573335a	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-12 01:23:20.405554+00	
00000000-0000-0000-0000-000000000000	9ff83791-bce3-43d2-a3aa-5757ff9d8a43	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-12 01:31:26.204745+00	
00000000-0000-0000-0000-000000000000	e5baf786-fea1-4352-bc20-9b4c575bbbcc	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-12 01:31:59.37615+00	
00000000-0000-0000-0000-000000000000	0c24a496-4e3e-4490-aa0b-b5bab910af08	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-12 01:33:21.637945+00	
00000000-0000-0000-0000-000000000000	26469d9a-ae7d-4031-9030-548e52283338	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-12 01:33:21.638559+00	
00000000-0000-0000-0000-000000000000	99a6b492-14eb-40df-b530-abb9a907da99	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-12 01:36:16.744512+00	
00000000-0000-0000-0000-000000000000	773c790d-b3f7-441e-8a03-a70e359bc2dc	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-12 01:36:29.182287+00	
00000000-0000-0000-0000-000000000000	3a1e31b0-4c4f-459f-b813-98a723f7c228	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-12 01:36:29.183048+00	
00000000-0000-0000-0000-000000000000	c2ee8ecc-2497-4f26-9400-7828874e991d	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-12 01:36:40.607514+00	
00000000-0000-0000-0000-000000000000	39921618-ce91-4f41-8bc5-ed4861c6df51	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-12 01:36:40.608802+00	
00000000-0000-0000-0000-000000000000	d1fd59e2-42c4-46d6-86bd-714ae1d1b41c	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-12 01:40:07.465255+00	
00000000-0000-0000-0000-000000000000	c459c93b-85aa-4952-993d-6b9a56d7564d	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-12 01:40:07.467825+00	
00000000-0000-0000-0000-000000000000	930dd123-d768-40e1-ac13-a376dfaf4c5a	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-12 01:40:19.588915+00	
00000000-0000-0000-0000-000000000000	01d052ce-4674-42dc-a931-897812a272e6	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-12 01:40:19.59027+00	
00000000-0000-0000-0000-000000000000	32a26025-4297-4cd8-9193-8b551e430975	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-12 01:47:36.564307+00	
00000000-0000-0000-0000-000000000000	2ba9421a-72b6-46d5-92cf-fea66323a346	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-12 01:47:36.567118+00	
00000000-0000-0000-0000-000000000000	61e6b2f2-6720-4a04-a98e-439633b414c9	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-12 01:51:36.023477+00	
00000000-0000-0000-0000-000000000000	b4877adf-c548-4a7c-85dc-27222a755afb	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-12 01:51:36.025895+00	
00000000-0000-0000-0000-000000000000	e9343477-c837-4996-a71e-26ec1e488d0a	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-12 01:51:57.318574+00	
00000000-0000-0000-0000-000000000000	8079cd5b-69d1-4f6f-bb8c-dcb2a594920d	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-12 01:51:57.319227+00	
00000000-0000-0000-0000-000000000000	6a19f0a4-686a-4400-b26b-c0f2c9170b06	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-12 02:02:26.369936+00	
00000000-0000-0000-0000-000000000000	289f2b72-e753-44aa-ba2a-3d361c677270	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-12 02:02:26.373075+00	
00000000-0000-0000-0000-000000000000	01cb68c8-4e52-4958-a8c7-2d2f3658668a	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-12 02:06:54.49389+00	
00000000-0000-0000-0000-000000000000	1cb7257f-97ac-48ab-a205-e5eb5f2832fc	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-12 02:06:58.307712+00	
00000000-0000-0000-0000-000000000000	6978c2bf-f250-4cc7-9aa7-6f032f75b941	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-12 02:07:03.648571+00	
00000000-0000-0000-0000-000000000000	275c20de-42e1-43f9-8efc-375ee6b50937	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-12 02:07:03.649144+00	
00000000-0000-0000-0000-000000000000	135c344e-2467-4584-beae-3268ff55532f	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-12 02:08:59.388472+00	
00000000-0000-0000-0000-000000000000	232fa891-df03-49cc-b1a6-e314a853f295	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-12 02:08:59.389297+00	
00000000-0000-0000-0000-000000000000	26088281-cb3c-4e98-ae70-c734c285ff38	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-12 02:10:48.515983+00	
00000000-0000-0000-0000-000000000000	83a29ada-4a8d-4567-8e29-66574cf8082b	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-12 02:10:48.518102+00	
00000000-0000-0000-0000-000000000000	30bf44ad-ecc1-4961-ba28-359f284b6f82	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-12 02:13:57.4942+00	
00000000-0000-0000-0000-000000000000	6d5699a0-ae59-407b-93ee-9a4e8768dc5b	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-12 02:14:07.78001+00	
00000000-0000-0000-0000-000000000000	6d6ac82a-b2a3-4fb5-ab86-615855134e3a	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-12 02:14:07.780554+00	
00000000-0000-0000-0000-000000000000	9c511723-7743-445f-95d1-a9e9d34b4ddf	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-12 02:14:22.001667+00	
00000000-0000-0000-0000-000000000000	2ca75236-2fb5-46c5-9526-56dcaf72bda9	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-12 02:14:50.788728+00	
00000000-0000-0000-0000-000000000000	b0c12c3b-194d-4c82-ab6f-0b27c307e63f	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-12 02:14:50.7901+00	
00000000-0000-0000-0000-000000000000	9c61c1c6-12c0-4361-b2fa-37677941b7ee	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-12 02:26:41.889167+00	
00000000-0000-0000-0000-000000000000	75a2b900-0686-4839-9d0b-c179b1c99696	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-12 02:26:41.89076+00	
00000000-0000-0000-0000-000000000000	6254a657-c82e-4015-90b2-96738b73b71e	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-12 02:26:58.34515+00	
00000000-0000-0000-0000-000000000000	700ebdd0-dc06-4837-9c47-2a2c57b07af1	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-12 02:26:58.345754+00	
00000000-0000-0000-0000-000000000000	cdd6df1a-affe-4d7e-af1a-2836b37e15e2	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-12 02:31:59.131637+00	
00000000-0000-0000-0000-000000000000	a4aba0f0-479c-4eb9-975c-4dfd95c65b0f	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-12 02:31:59.132574+00	
00000000-0000-0000-0000-000000000000	cdd85442-d9c0-441a-980e-9838b4156aa2	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-12 02:57:10.204254+00	
00000000-0000-0000-0000-000000000000	b7aafb40-86f6-4114-8231-dd3cf20484f0	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-12 03:06:30.772529+00	
00000000-0000-0000-0000-000000000000	83579a4a-6238-4ee7-afbc-4605e9c6c000	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-12 04:28:33.49002+00	
00000000-0000-0000-0000-000000000000	3e817e4f-2810-4177-b633-3de97e9750fb	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-12 04:28:33.493025+00	
00000000-0000-0000-0000-000000000000	c66a7989-86f5-4256-8d3a-398f206477e1	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-12 05:30:10.385804+00	
00000000-0000-0000-0000-000000000000	45c71bcd-50a8-4174-a059-03b15b381acc	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-12 05:30:10.387996+00	
00000000-0000-0000-0000-000000000000	c5c8d09f-415f-4f5b-9d64-e01db7b8ff31	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-12 06:31:38.11277+00	
00000000-0000-0000-0000-000000000000	5e86a7d6-c049-4c2a-a733-51ee151802ec	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-12 06:31:38.123505+00	
00000000-0000-0000-0000-000000000000	605586a2-6211-4c7b-85e4-ab567584a1f7	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-12 06:44:32.459165+00	
00000000-0000-0000-0000-000000000000	076973b0-8646-4905-8801-65f9c08d3102	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-12 06:44:35.922855+00	
00000000-0000-0000-0000-000000000000	570ee52c-345b-4a2e-9efe-971d5b35191c	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-12 06:52:00.719465+00	
00000000-0000-0000-0000-000000000000	b5a900f0-d09e-482f-9508-29b95ff15974	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-12 06:52:04.06252+00	
00000000-0000-0000-0000-000000000000	d1c55feb-6400-4b5e-89c6-ca0eaad26d4b	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-12 07:51:39.502204+00	
00000000-0000-0000-0000-000000000000	12ba6433-95ab-4b89-abcc-87af67850fc3	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-12 07:51:39.506552+00	
00000000-0000-0000-0000-000000000000	59347f01-3b8d-4c95-a0f9-f68e55ba56ba	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-12 08:08:44.700886+00	
00000000-0000-0000-0000-000000000000	08b05b07-4885-4aeb-850e-8bd644cb3dd8	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-12 08:08:47.659894+00	
00000000-0000-0000-0000-000000000000	47d58106-08d6-4746-a9e4-d69184417bce	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-13 01:37:40.97987+00	
00000000-0000-0000-0000-000000000000	6564b9ba-937b-44ad-8e0d-e3b4f90c10f0	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-13 02:08:25.870326+00	
00000000-0000-0000-0000-000000000000	478a2b70-16d6-4449-b5c3-e79ec03c79d2	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-13 02:54:40.487779+00	
00000000-0000-0000-0000-000000000000	6e467855-03b2-46dc-8e4c-43869188adff	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-13 02:54:43.849372+00	
00000000-0000-0000-0000-000000000000	107c123d-6536-4c09-8b1e-f6d57993108d	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-13 03:53:26.817772+00	
00000000-0000-0000-0000-000000000000	8351d7f8-33d8-4b2c-818d-e618e358bab6	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-13 03:53:26.823931+00	
00000000-0000-0000-0000-000000000000	da97e65a-d37e-4b29-b0d3-5336b62cc362	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-13 04:52:10.041896+00	
00000000-0000-0000-0000-000000000000	c80f59ad-e05f-48f6-96f0-9dc98f065833	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-13 04:52:10.047891+00	
00000000-0000-0000-0000-000000000000	4b4ebd72-3197-4a7d-a5a2-1b63f50e283b	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-13 05:15:09.739355+00	
00000000-0000-0000-0000-000000000000	a09de639-3235-40d2-8efb-9ee57d139e17	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-13 06:10:37.475813+00	
00000000-0000-0000-0000-000000000000	8e5eed9b-9fca-4b79-a339-09debb06f7ba	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-13 06:12:20.229511+00	
00000000-0000-0000-0000-000000000000	7864f3bb-10d5-469f-a405-01b6507103f6	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-13 06:12:23.357402+00	
00000000-0000-0000-0000-000000000000	31ce8816-ae51-4c67-811e-a1fa91b2a2e4	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-13 06:16:35.721916+00	
00000000-0000-0000-0000-000000000000	58f1d6b7-ca4d-456f-a251-7083d15a06f8	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-13 06:16:38.449275+00	
00000000-0000-0000-0000-000000000000	b77df506-46d1-42b0-ba34-0bb9b65d0402	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-13 06:20:12.736356+00	
00000000-0000-0000-0000-000000000000	a78c526b-8c3f-44e8-a27b-6027a884048a	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-13 06:22:01.696918+00	
00000000-0000-0000-0000-000000000000	d8a1060d-cda9-4501-8e36-f6a93321a193	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-13 07:20:34.598054+00	
00000000-0000-0000-0000-000000000000	2541b2c2-0e29-4dec-92e4-b7f1568c77ac	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-13 07:20:34.606641+00	
00000000-0000-0000-0000-000000000000	6a70fd25-44d2-42dc-897d-77e07aa4d2f3	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-13 08:19:42.811916+00	
00000000-0000-0000-0000-000000000000	d1524d34-9549-4558-b59b-e605413b22c0	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-13 08:19:42.815796+00	
00000000-0000-0000-0000-000000000000	c8cd1d75-31dd-422c-9c1a-6aea36b62a9d	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-13 08:19:55.545115+00	
00000000-0000-0000-0000-000000000000	58bfaf36-b519-4227-85ef-212f092dacc6	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-13 08:22:38.99042+00	
00000000-0000-0000-0000-000000000000	cc1edb5c-d08b-4d97-a936-199debc19baa	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-13 23:59:49.057829+00	
00000000-0000-0000-0000-000000000000	9bf1236c-8b75-48bf-a6f3-acd8fe909e20	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-13 23:59:49.077941+00	
00000000-0000-0000-0000-000000000000	53213223-4b4b-49c8-899b-c6e4990eb4e7	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 00:22:50.386715+00	
00000000-0000-0000-0000-000000000000	21f3c063-efa8-4b4c-89e2-0a6ada292d30	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 00:22:50.391324+00	
00000000-0000-0000-0000-000000000000	6eeaa744-34bb-4914-884e-48dc84d5596a	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 00:23:36.286964+00	
00000000-0000-0000-0000-000000000000	c43d4b0a-3683-47fd-9558-0142d7b5b8e9	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 00:23:36.288491+00	
00000000-0000-0000-0000-000000000000	42b4a9ca-ae84-4ba8-b966-d78907b4ad16	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 00:25:00.570653+00	
00000000-0000-0000-0000-000000000000	5fd6013f-c6c4-4ddd-9bcd-533c0c6a7b00	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 00:25:00.571632+00	
00000000-0000-0000-0000-000000000000	e8ea3d77-af0c-4f38-afeb-5e27d93978ea	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 00:27:00.329577+00	
00000000-0000-0000-0000-000000000000	eb739b91-675f-4dbb-9bed-540fdf757e6d	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 00:27:00.333013+00	
00000000-0000-0000-0000-000000000000	73b7141b-32ac-423e-9b26-1190bf77e97e	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 00:27:54.878156+00	
00000000-0000-0000-0000-000000000000	0e501684-7e0d-48b5-9c51-bdb8716614df	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 00:27:54.879981+00	
00000000-0000-0000-0000-000000000000	b7286cc8-1fdb-47fe-bbe6-9752d7ac59f1	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 00:28:35.719624+00	
00000000-0000-0000-0000-000000000000	33a90256-815f-478b-a2ee-010a4276e7b9	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 00:28:35.720207+00	
00000000-0000-0000-0000-000000000000	e4c34c56-b19a-4e95-b3ff-f578d00b8f04	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 00:33:26.603806+00	
00000000-0000-0000-0000-000000000000	a680e0a7-ee98-4d03-980a-07ffed287663	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 00:33:26.609729+00	
00000000-0000-0000-0000-000000000000	fbe39628-4304-40e5-977b-d16f951b0963	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 00:39:17.682124+00	
00000000-0000-0000-0000-000000000000	dc71d005-917e-4596-bec7-ebebc47fbe3e	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 00:39:17.684199+00	
00000000-0000-0000-0000-000000000000	937fe3dd-5031-4e1d-866b-19a1e4b58da0	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 00:39:27.22646+00	
00000000-0000-0000-0000-000000000000	4ae01459-bd2f-40af-8284-7e4d64119e36	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 00:39:27.227001+00	
00000000-0000-0000-0000-000000000000	b2019b74-4650-44d8-8a42-2db39ac9105d	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 00:44:36.163415+00	
00000000-0000-0000-0000-000000000000	353c157d-aa9f-47ff-9a7e-36262bd34607	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 00:44:36.166249+00	
00000000-0000-0000-0000-000000000000	ab821198-8421-4443-a376-973de0c25eac	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 00:45:51.786957+00	
00000000-0000-0000-0000-000000000000	41f0aca1-0bbe-4f4e-9a3b-4dfc425decba	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 00:45:51.787985+00	
00000000-0000-0000-0000-000000000000	e6daf863-f537-4407-9645-5c4e99c43923	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 00:46:58.635559+00	
00000000-0000-0000-0000-000000000000	c9855b5e-586f-47bd-a3f3-103c7a3c69c2	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 00:46:58.636175+00	
00000000-0000-0000-0000-000000000000	d401a45f-092a-45c4-b095-8210fe041a7b	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 00:47:13.609057+00	
00000000-0000-0000-0000-000000000000	ba6eed0f-1b9b-41b9-a22d-cd68321b943e	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 00:47:13.609712+00	
00000000-0000-0000-0000-000000000000	edffab63-166c-4a0c-b17c-0bff1c826760	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 00:51:07.050457+00	
00000000-0000-0000-0000-000000000000	b80611bc-23a4-44b8-90fc-edc020247d88	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 00:51:07.052049+00	
00000000-0000-0000-0000-000000000000	da1d3e3e-3ab1-46f7-9ccd-71501430de04	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 00:51:16.830281+00	
00000000-0000-0000-0000-000000000000	8026502f-f6aa-4be5-a5b8-b8d052cdba84	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 00:51:16.830944+00	
00000000-0000-0000-0000-000000000000	bc63d25f-debb-476c-8b61-3c052d78bdac	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 00:52:37.721201+00	
00000000-0000-0000-0000-000000000000	649c3875-eb5b-4dfa-aa35-0587c26d0710	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 00:52:37.722049+00	
00000000-0000-0000-0000-000000000000	c91e9c2d-7721-4bb8-bdd6-75d02c11914e	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 00:54:50.467252+00	
00000000-0000-0000-0000-000000000000	b621e74d-8279-4b86-bc5a-e59d3406143a	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 00:54:50.468152+00	
00000000-0000-0000-0000-000000000000	23735dd9-ff03-4002-a57c-4b0a6b983343	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 00:55:09.841495+00	
00000000-0000-0000-0000-000000000000	ac325dfc-df01-4f5c-a005-75261d48499a	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 00:55:09.8428+00	
00000000-0000-0000-0000-000000000000	92377045-6625-4e14-a9dd-c0c437d1d245	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 00:58:25.757084+00	
00000000-0000-0000-0000-000000000000	d9f32b7c-3be6-4255-912c-25e9bc4d4638	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 00:58:25.761233+00	
00000000-0000-0000-0000-000000000000	9b48b631-98e7-4909-8074-d75d6cd2ca97	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 01:01:35.51081+00	
00000000-0000-0000-0000-000000000000	d6d94f2d-114d-4f54-adad-7c65b7f35998	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 01:01:35.513962+00	
00000000-0000-0000-0000-000000000000	4455a611-52e9-4f71-a699-0ce483666c99	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 01:01:47.712161+00	
00000000-0000-0000-0000-000000000000	c7f2e75d-2bef-4abb-b6a4-e30330230c2d	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 01:01:47.713611+00	
00000000-0000-0000-0000-000000000000	8e373ef6-ff7f-429b-9a96-97d25d22ca7c	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 01:01:55.612152+00	
00000000-0000-0000-0000-000000000000	aa3b4a67-7404-414f-91fc-d9a554ba8e99	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 01:01:55.612771+00	
00000000-0000-0000-0000-000000000000	d21b4121-83d5-42f2-b190-6fd4c7365874	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 01:05:00.763462+00	
00000000-0000-0000-0000-000000000000	d3e751f2-72f5-4fba-8c14-e560ce986c7e	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 01:05:00.764433+00	
00000000-0000-0000-0000-000000000000	7e317a7e-806d-4949-add5-64fb5f4f952c	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 01:06:49.088678+00	
00000000-0000-0000-0000-000000000000	5398d142-8cc0-459d-b445-478621aa8259	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 01:06:49.091735+00	
00000000-0000-0000-0000-000000000000	7dc43dd5-78c4-4e86-8c77-f3360271696a	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 01:07:12.906898+00	
00000000-0000-0000-0000-000000000000	37a9acd2-64fb-478b-805d-e3f04f46e28f	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 01:07:12.907503+00	
00000000-0000-0000-0000-000000000000	2655feb4-aee7-4da9-b2bd-0213cfc3217a	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 01:07:21.409975+00	
00000000-0000-0000-0000-000000000000	de431121-e156-4564-9b03-0a446ed60ffe	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 01:07:21.411291+00	
00000000-0000-0000-0000-000000000000	65e341f4-163b-4b03-8752-63962b265b56	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 01:07:55.111211+00	
00000000-0000-0000-0000-000000000000	692da9ad-b6a1-4987-8043-37e5ae0e3e95	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 01:07:55.111771+00	
00000000-0000-0000-0000-000000000000	598631b6-8327-4f41-8aaa-48fb808765d6	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 01:08:39.763018+00	
00000000-0000-0000-0000-000000000000	2c5054cc-32e2-429e-91d1-894729c49e74	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 01:08:39.763636+00	
00000000-0000-0000-0000-000000000000	e31f50d0-82be-4f08-a6c0-005408da0722	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 01:08:55.736018+00	
00000000-0000-0000-0000-000000000000	561f8a8f-7642-4c21-a27f-de08720e902e	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 01:08:55.736604+00	
00000000-0000-0000-0000-000000000000	b24dd2eb-4dc0-4516-a184-60e203958b3b	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 01:11:53.08204+00	
00000000-0000-0000-0000-000000000000	b3e56f98-b104-4caf-96dc-c5628ebbcd70	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 01:11:53.084193+00	
00000000-0000-0000-0000-000000000000	e1c7ae47-2537-4269-9e14-cffaab477afd	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 01:13:48.771299+00	
00000000-0000-0000-0000-000000000000	d4389ab1-8f77-4775-afca-dcfb92ef7ad2	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 01:13:48.772166+00	
00000000-0000-0000-0000-000000000000	0bb8ad7b-4209-4344-a708-9662dfcccd82	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-14 01:32:53.939696+00	
00000000-0000-0000-0000-000000000000	e0d3fd13-e9c0-494e-bcd1-637d15f07db6	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-14 01:32:57.020688+00	
00000000-0000-0000-0000-000000000000	c6f378a2-d4a6-4836-a991-b8af7e7a0874	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-14 01:34:01.803861+00	
00000000-0000-0000-0000-000000000000	2fb5fe4b-27a6-4519-b529-e887ec7934cb	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-14 01:35:32.814711+00	
00000000-0000-0000-0000-000000000000	973de67c-a327-47ad-8fd8-02e3f5ea1883	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-14 01:35:50.485117+00	
00000000-0000-0000-0000-000000000000	26147c62-ee9c-4c43-8183-d421be96dce9	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-14 02:07:49.876478+00	
00000000-0000-0000-0000-000000000000	3f8616d9-6034-483a-82f3-a87f3f4c7d15	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-14 02:08:01.783062+00	
00000000-0000-0000-0000-000000000000	54b1f643-fb00-42bf-9e3f-16460f56f79e	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-14 02:19:43.489567+00	
00000000-0000-0000-0000-000000000000	595b5aa5-839d-4a27-ac92-1a110a5cbcd3	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-14 02:19:49.36825+00	
00000000-0000-0000-0000-000000000000	0e337081-6eac-4931-bcbc-64d3babf694f	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-14 02:20:07.38052+00	
00000000-0000-0000-0000-000000000000	e7a03fe0-b8f4-47a6-a5d1-cc60d967c51c	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-14 02:21:08.400279+00	
00000000-0000-0000-0000-000000000000	21b007b8-5549-4a7d-941c-13781e701224	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-14 02:24:54.626643+00	
00000000-0000-0000-0000-000000000000	3f4fef55-5273-4e89-88ae-688bda73b3d7	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-14 02:24:59.241817+00	
00000000-0000-0000-0000-000000000000	94f3ff24-98e9-4996-868f-1265cace9915	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-14 02:25:05.234384+00	
00000000-0000-0000-0000-000000000000	5a2fc3e1-0b23-45f0-ab0f-56d5864ad47b	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-14 02:25:14.998654+00	
00000000-0000-0000-0000-000000000000	f9dceafb-3b87-4c3a-a292-1119c8924c47	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-14 02:26:38.862428+00	
00000000-0000-0000-0000-000000000000	f49c53c1-5a9e-40fc-bf63-9578a8856bb4	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-14 02:26:42.157767+00	
00000000-0000-0000-0000-000000000000	180498e2-3be2-47b1-8b53-5eccd872f6cb	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-14 02:27:14.965899+00	
00000000-0000-0000-0000-000000000000	c99a85a3-763f-4dab-a6a5-d49c8fa014f0	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-14 02:28:59.872295+00	
00000000-0000-0000-0000-000000000000	71aacc26-b18a-4031-9595-b5a8fcd25eea	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-14 02:29:24.590986+00	
00000000-0000-0000-0000-000000000000	df900f43-beb9-4f11-9471-49ee55f0e6ee	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-14 02:29:31.810552+00	
00000000-0000-0000-0000-000000000000	633fa81d-9fd2-46ec-b490-9fbadb106fb4	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-14 02:29:36.546409+00	
00000000-0000-0000-0000-000000000000	af76a32e-f24c-435c-bc38-79e45820e188	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-14 02:29:41.589651+00	
00000000-0000-0000-0000-000000000000	ed99a443-3237-467b-be57-4540197dbfb5	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-14 02:29:47.04367+00	
00000000-0000-0000-0000-000000000000	0fcb9e83-9bba-4a49-acae-c374134e69f7	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-14 02:30:19.250979+00	
00000000-0000-0000-0000-000000000000	6fe20e2e-5c0f-4564-82e7-9227d5f34ffd	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-14 02:30:48.734107+00	
00000000-0000-0000-0000-000000000000	3881de69-45be-49dd-a734-ebfb0cb5dab9	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-14 02:31:57.671483+00	
00000000-0000-0000-0000-000000000000	247c961e-12a3-48cc-b372-659b72c6d21e	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 03:30:02.555632+00	
00000000-0000-0000-0000-000000000000	24660511-2003-47cd-80f6-c8b18057f9e5	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 03:30:02.561034+00	
00000000-0000-0000-0000-000000000000	f256642e-4b7e-46da-9e3a-3269fe3753bf	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-14 04:15:58.164937+00	
00000000-0000-0000-0000-000000000000	aeae7f83-a509-4c02-b823-98c957906346	{"action":"login","actor_id":"6e6376f2-9648-4c72-80f2-809adfe63988","actor_username":"rupesh.sakthivel@iba-group.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-14 04:18:35.683771+00	
00000000-0000-0000-0000-000000000000	38838510-4199-404c-b3cc-902d4d35ee46	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-14 04:26:10.860241+00	
00000000-0000-0000-0000-000000000000	aa021247-61c9-46ab-a211-bb94de97a135	{"action":"user_signedup","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"jithin.palottukandy@iba-group.com","user_id":"18c42826-0ae1-4833-8fd3-5ed1614ab339","user_phone":""}}	2025-05-14 04:42:59.628681+00	
00000000-0000-0000-0000-000000000000	f8ba4184-1a9d-4f91-b663-51da79deae91	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-14 04:46:43.281035+00	
00000000-0000-0000-0000-000000000000	5f9db637-6651-4f25-a81f-a4254e378c26	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-14 05:13:40.041006+00	
00000000-0000-0000-0000-000000000000	f466e762-71c5-4960-89ef-e683f5811495	{"action":"token_refreshed","actor_id":"6e6376f2-9648-4c72-80f2-809adfe63988","actor_username":"rupesh.sakthivel@iba-group.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 05:17:32.736434+00	
00000000-0000-0000-0000-000000000000	502ccbc6-0197-46be-8938-f55b1ce0ffb5	{"action":"token_revoked","actor_id":"6e6376f2-9648-4c72-80f2-809adfe63988","actor_username":"rupesh.sakthivel@iba-group.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 05:17:32.739741+00	
00000000-0000-0000-0000-000000000000	d1de4332-4685-4588-9afd-58ba5423b2c4	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-14 05:21:04.329759+00	
00000000-0000-0000-0000-000000000000	719e080f-0fc7-4b4c-b381-d636780d14c7	{"action":"token_refreshed","actor_id":"6e6376f2-9648-4c72-80f2-809adfe63988","actor_username":"rupesh.sakthivel@iba-group.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 06:16:21.424758+00	
00000000-0000-0000-0000-000000000000	875a080b-5ff9-4170-b064-ddbcbe321c80	{"action":"token_revoked","actor_id":"6e6376f2-9648-4c72-80f2-809adfe63988","actor_username":"rupesh.sakthivel@iba-group.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 06:16:21.434347+00	
00000000-0000-0000-0000-000000000000	ea6c5639-b9b8-4418-bd6b-787c38c45069	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 06:19:42.039145+00	
00000000-0000-0000-0000-000000000000	3abb77da-6ca2-408e-a434-c4decc70930f	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 06:19:42.041295+00	
00000000-0000-0000-0000-000000000000	fa86285a-0224-463a-8b79-d5a2727f6df0	{"action":"login","actor_id":"18c42826-0ae1-4833-8fd3-5ed1614ab339","actor_username":"jithin.palottukandy@iba-group.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-14 06:47:22.801058+00	
00000000-0000-0000-0000-000000000000	ace8c1f3-9d05-4a5b-96d5-5d15db673c2b	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 07:00:41.381251+00	
00000000-0000-0000-0000-000000000000	c60c9a2c-e0ff-40c5-bcca-13d21f72320a	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 07:00:41.384358+00	
00000000-0000-0000-0000-000000000000	485971a6-5745-44ec-aca4-cc31d59f43ae	{"action":"token_refreshed","actor_id":"6e6376f2-9648-4c72-80f2-809adfe63988","actor_username":"rupesh.sakthivel@iba-group.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 07:15:12.301917+00	
00000000-0000-0000-0000-000000000000	9e7ac348-23a7-443d-97e9-bcbcc11621a4	{"action":"token_revoked","actor_id":"6e6376f2-9648-4c72-80f2-809adfe63988","actor_username":"rupesh.sakthivel@iba-group.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 07:15:12.306861+00	
00000000-0000-0000-0000-000000000000	6dcba727-72c9-49a8-be47-98da7935eb7c	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 07:18:15.01381+00	
00000000-0000-0000-0000-000000000000	2019bdb6-dfe7-4eb7-8de1-b5bcc4cec9e1	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 07:18:15.01716+00	
00000000-0000-0000-0000-000000000000	4544cc59-a36f-4250-8907-ffc12c525f22	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-14 07:32:10.809968+00	
00000000-0000-0000-0000-000000000000	cc26abda-b4ab-4918-959e-a95df68fa28f	{"action":"token_refreshed","actor_id":"18c42826-0ae1-4833-8fd3-5ed1614ab339","actor_username":"jithin.palottukandy@iba-group.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 07:45:31.568578+00	
00000000-0000-0000-0000-000000000000	79d488c8-1549-4990-b501-9f54ddade5fc	{"action":"token_revoked","actor_id":"18c42826-0ae1-4833-8fd3-5ed1614ab339","actor_username":"jithin.palottukandy@iba-group.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 07:45:31.571585+00	
00000000-0000-0000-0000-000000000000	3126ceb8-c2fb-4606-88d0-0e059cd0dc8c	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 07:59:06.022892+00	
00000000-0000-0000-0000-000000000000	b9d58421-320a-4381-aa95-9f09e7228091	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 07:59:06.026358+00	
00000000-0000-0000-0000-000000000000	a8d934ce-8e8f-4805-83cf-892a67427efa	{"action":"token_refreshed","actor_id":"6e6376f2-9648-4c72-80f2-809adfe63988","actor_username":"rupesh.sakthivel@iba-group.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 08:14:02.800344+00	
00000000-0000-0000-0000-000000000000	c7f0b440-477b-4515-8680-8e82bcd1ebda	{"action":"token_revoked","actor_id":"6e6376f2-9648-4c72-80f2-809adfe63988","actor_username":"rupesh.sakthivel@iba-group.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 08:14:02.803687+00	
00000000-0000-0000-0000-000000000000	cb9ea09c-183e-4d63-99e3-4ff0ebc95085	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 08:17:07.137174+00	
00000000-0000-0000-0000-000000000000	1ab9e8af-b047-4ae2-8232-3396229aae46	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 08:17:07.13872+00	
00000000-0000-0000-0000-000000000000	b864cfed-b15d-42fc-99e3-a7c9c2152e76	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 08:30:50.077971+00	
00000000-0000-0000-0000-000000000000	525257a5-ceaf-48a8-8be4-dd932fa18534	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 08:30:50.081488+00	
00000000-0000-0000-0000-000000000000	0078aa44-ef1f-4ea0-974a-f6e578801ec7	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-14 08:42:07.490298+00	
00000000-0000-0000-0000-000000000000	d97fa3c1-e787-4201-89c9-ac4ed4b4338b	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-14 08:43:14.304508+00	
00000000-0000-0000-0000-000000000000	f0ccf749-1cdd-48f3-805e-721e6edd234e	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-14 08:43:29.369472+00	
00000000-0000-0000-0000-000000000000	9bb2d66b-97b1-46c2-9e5c-934503626ce8	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-14 08:43:35.529348+00	
00000000-0000-0000-0000-000000000000	487ef610-a951-4d55-9185-890ea90997c8	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-14 08:43:39.583394+00	
00000000-0000-0000-0000-000000000000	b0ee5b82-a4bb-419e-a35d-9377802840db	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-14 08:43:46.305128+00	
00000000-0000-0000-0000-000000000000	9add4327-4859-4114-ac34-02260a42adbc	{"action":"token_refreshed","actor_id":"18c42826-0ae1-4833-8fd3-5ed1614ab339","actor_username":"jithin.palottukandy@iba-group.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 08:44:08.825273+00	
00000000-0000-0000-0000-000000000000	40d4e6be-e106-4877-9379-884f855db0b4	{"action":"token_revoked","actor_id":"18c42826-0ae1-4833-8fd3-5ed1614ab339","actor_username":"jithin.palottukandy@iba-group.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 08:44:08.825885+00	
00000000-0000-0000-0000-000000000000	09f4b524-13e9-4265-bd45-515f3c8120bd	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-14 09:10:42.498172+00	
00000000-0000-0000-0000-000000000000	3aa64cbb-3c80-4dc1-9951-d6a6486d6b8f	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-14 09:28:03.190479+00	
00000000-0000-0000-0000-000000000000	e956de2d-9618-4d5b-8282-0c87f6126072	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 09:42:06.511131+00	
00000000-0000-0000-0000-000000000000	4159966d-f3d2-486d-9a77-c6ea055a111e	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 09:42:06.513537+00	
00000000-0000-0000-0000-000000000000	ba724e2a-e5c8-4999-b2d5-1cb4e0950dfb	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-14 09:42:50.586033+00	
00000000-0000-0000-0000-000000000000	e021482f-84f6-4c72-b946-0dcec12dbc51	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-14 09:42:56.221605+00	
00000000-0000-0000-0000-000000000000	4e05961e-0b62-4923-8d36-13dd98ca3828	{"action":"token_refreshed","actor_id":"18c42826-0ae1-4833-8fd3-5ed1614ab339","actor_username":"jithin.palottukandy@iba-group.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 09:43:15.159005+00	
00000000-0000-0000-0000-000000000000	9f59eb6a-2474-46ea-9215-0ecadb543989	{"action":"token_revoked","actor_id":"18c42826-0ae1-4833-8fd3-5ed1614ab339","actor_username":"jithin.palottukandy@iba-group.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 09:43:15.159692+00	
00000000-0000-0000-0000-000000000000	1dc9f0b6-433a-4705-b39b-6edeb75ada86	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-14 09:43:39.551164+00	
00000000-0000-0000-0000-000000000000	b15c1fa7-ce28-4558-adba-deabc930206c	{"action":"token_refreshed","actor_id":"6e6376f2-9648-4c72-80f2-809adfe63988","actor_username":"rupesh.sakthivel@iba-group.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 09:43:55.694513+00	
00000000-0000-0000-0000-000000000000	669b0ff5-85fd-4f61-af0c-c7237a6f592e	{"action":"token_revoked","actor_id":"6e6376f2-9648-4c72-80f2-809adfe63988","actor_username":"rupesh.sakthivel@iba-group.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 09:43:55.695253+00	
00000000-0000-0000-0000-000000000000	a6f4e4a7-1be5-4431-bbaf-de1da8d3cd96	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-14 09:52:17.96834+00	
00000000-0000-0000-0000-000000000000	f2a4c43c-c999-48d4-956d-9e386e34fbd7	{"action":"user_signedup","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"vishnuv.shenoy@iba-group.com","user_id":"e604e248-d849-4c04-a7b8-b2b46bb13e4a","user_phone":""}}	2025-05-14 10:04:10.366352+00	
00000000-0000-0000-0000-000000000000	59ee92ac-7b82-4a90-8d5e-3c3b6144cf87	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-14 10:04:52.602503+00	
00000000-0000-0000-0000-000000000000	7b9889df-15b7-475d-a7d8-02e740373d7b	{"action":"user_signedup","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"rajagopal.krishnamoorthy@iba-group.com","user_id":"d630c4d9-2929-4a44-9a53-92aeb8586182","user_phone":""}}	2025-05-14 10:05:35.445359+00	
00000000-0000-0000-0000-000000000000	1eae403b-175d-4b02-885c-13c6da205c14	{"action":"login","actor_id":"6e6376f2-9648-4c72-80f2-809adfe63988","actor_username":"rupesh.sakthivel@iba-group.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-14 10:05:47.155153+00	
00000000-0000-0000-0000-000000000000	22bd185d-69ce-4a57-bafb-ec18f4371bf4	{"action":"logout","actor_id":"6e6376f2-9648-4c72-80f2-809adfe63988","actor_username":"rupesh.sakthivel@iba-group.com","actor_via_sso":false,"log_type":"account"}	2025-05-14 10:09:37.88524+00	
00000000-0000-0000-0000-000000000000	ae79fc34-98f9-42b8-99fc-85e4f2fa0ec4	{"action":"logout","actor_id":"18c42826-0ae1-4833-8fd3-5ed1614ab339","actor_username":"jithin.palottukandy@iba-group.com","actor_via_sso":false,"log_type":"account"}	2025-05-14 10:11:05.690045+00	
00000000-0000-0000-0000-000000000000	2e7ffd9e-5f0f-479e-917f-a0dbf3190214	{"action":"login","actor_id":"18c42826-0ae1-4833-8fd3-5ed1614ab339","actor_username":"jithin.palottukandy@iba-group.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-14 10:11:09.533101+00	
00000000-0000-0000-0000-000000000000	a157ca9f-fead-4681-bd61-8acbaad9be20	{"action":"logout","actor_id":"18c42826-0ae1-4833-8fd3-5ed1614ab339","actor_username":"jithin.palottukandy@iba-group.com","actor_via_sso":false,"log_type":"account"}	2025-05-14 10:11:38.184942+00	
00000000-0000-0000-0000-000000000000	a393af38-9e6c-48bd-bc11-61f4fc9314c6	{"action":"user_signedup","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"tcs@goiba.net","user_id":"17e3383f-6805-413e-8254-0bbbeb7f225e","user_phone":""}}	2025-05-14 11:32:47.826209+00	
00000000-0000-0000-0000-000000000000	6a580fd3-91b8-4ff6-865f-908d06028900	{"action":"login","actor_id":"17e3383f-6805-413e-8254-0bbbeb7f225e","actor_username":"tcs@goiba.net","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-14 11:33:01.433451+00	
00000000-0000-0000-0000-000000000000	be1670cb-649f-4cd3-8bf0-e4061266db86	{"action":"logout","actor_id":"17e3383f-6805-413e-8254-0bbbeb7f225e","actor_username":"tcs@goiba.net","actor_via_sso":false,"log_type":"account"}	2025-05-14 11:34:38.964922+00	
00000000-0000-0000-0000-000000000000	160a4906-b41b-4b60-bffb-1ee8224aa6a2	{"action":"login","actor_id":"17e3383f-6805-413e-8254-0bbbeb7f225e","actor_username":"tcs@goiba.net","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-14 11:34:41.487357+00	
00000000-0000-0000-0000-000000000000	aa14bc5d-27be-459c-86c8-c2eb000e3efb	{"action":"logout","actor_id":"17e3383f-6805-413e-8254-0bbbeb7f225e","actor_username":"tcs@goiba.net","actor_via_sso":false,"log_type":"account"}	2025-05-14 11:49:28.444864+00	
00000000-0000-0000-0000-000000000000	1da27e4d-bb08-40e7-9dcc-d75db7549bf6	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-14 11:49:42.290388+00	
00000000-0000-0000-0000-000000000000	4c025a88-54d0-4119-9d56-42d3e37e204d	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-14 12:04:55.324098+00	
00000000-0000-0000-0000-000000000000	ae7fd762-579b-4d5f-80e2-cdb4af239441	{"action":"login","actor_id":"17e3383f-6805-413e-8254-0bbbeb7f225e","actor_username":"tcs@goiba.net","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-14 12:04:58.955545+00	
00000000-0000-0000-0000-000000000000	bcb80cb2-7d7c-4dc9-b24d-fcc6dbed4fd1	{"action":"logout","actor_id":"17e3383f-6805-413e-8254-0bbbeb7f225e","actor_username":"tcs@goiba.net","actor_via_sso":false,"log_type":"account"}	2025-05-14 12:06:33.316067+00	
00000000-0000-0000-0000-000000000000	f970f490-f95c-41f2-bbc0-f0363e9972e3	{"action":"login","actor_id":"17e3383f-6805-413e-8254-0bbbeb7f225e","actor_username":"tcs@goiba.net","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-14 12:06:36.522138+00	
00000000-0000-0000-0000-000000000000	bfb4a4d1-6c7d-4bed-bd59-ce7b1ecac9b3	{"action":"logout","actor_id":"17e3383f-6805-413e-8254-0bbbeb7f225e","actor_username":"tcs@goiba.net","actor_via_sso":false,"log_type":"account"}	2025-05-14 12:07:02.880129+00	
00000000-0000-0000-0000-000000000000	e0cf33b4-2dd1-462b-a8e4-4fc1ece32fe2	{"action":"login","actor_id":"17e3383f-6805-413e-8254-0bbbeb7f225e","actor_username":"tcs@goiba.net","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-14 12:07:07.0415+00	
00000000-0000-0000-0000-000000000000	c4dccf05-dcab-41af-bba7-ae73d922ecc5	{"action":"logout","actor_id":"17e3383f-6805-413e-8254-0bbbeb7f225e","actor_username":"tcs@goiba.net","actor_via_sso":false,"log_type":"account"}	2025-05-14 12:26:41.948278+00	
00000000-0000-0000-0000-000000000000	118512bf-6a82-48e7-b6f8-b3514a7a8394	{"action":"login","actor_id":"17e3383f-6805-413e-8254-0bbbeb7f225e","actor_username":"tcs@goiba.net","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-14 12:26:45.548361+00	
00000000-0000-0000-0000-000000000000	37b8bafa-c48b-495b-a6f8-597b250b9659	{"action":"token_refreshed","actor_id":"17e3383f-6805-413e-8254-0bbbeb7f225e","actor_username":"tcs@goiba.net","actor_via_sso":false,"log_type":"token"}	2025-05-14 13:25:39.807454+00	
00000000-0000-0000-0000-000000000000	c7e53bd8-62ba-4ae3-abd1-40fcbcf92351	{"action":"token_revoked","actor_id":"17e3383f-6805-413e-8254-0bbbeb7f225e","actor_username":"tcs@goiba.net","actor_via_sso":false,"log_type":"token"}	2025-05-14 13:25:39.810798+00	
00000000-0000-0000-0000-000000000000	6faddf6d-ad27-45a8-9df6-70d372f8ae51	{"action":"login","actor_id":"17e3383f-6805-413e-8254-0bbbeb7f225e","actor_username":"tcs@goiba.net","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-14 14:07:46.250821+00	
00000000-0000-0000-0000-000000000000	96dadd85-b229-4d45-b646-b91b89b59b27	{"action":"logout","actor_id":"17e3383f-6805-413e-8254-0bbbeb7f225e","actor_username":"tcs@goiba.net","actor_via_sso":false,"log_type":"account"}	2025-05-14 14:35:12.98607+00	
00000000-0000-0000-0000-000000000000	62ec2b6e-6b34-49bd-be24-860423cd50bc	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-14 14:35:22.738089+00	
00000000-0000-0000-0000-000000000000	45059da8-a81b-4e0d-940f-86e5f6a9572e	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-14 14:36:36.969014+00	
00000000-0000-0000-0000-000000000000	f7b42bdb-e08e-4acd-8662-d12fbaff593a	{"action":"login","actor_id":"17e3383f-6805-413e-8254-0bbbeb7f225e","actor_username":"tcs@goiba.net","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-14 14:44:33.762595+00	
00000000-0000-0000-0000-000000000000	84f88cd3-1169-44a3-9f6c-7836ee1064b6	{"action":"login","actor_id":"17e3383f-6805-413e-8254-0bbbeb7f225e","actor_username":"tcs@goiba.net","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-14 15:14:35.343606+00	
00000000-0000-0000-0000-000000000000	7fe73f29-3d33-41c8-983d-86cc12dfddbd	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-14 15:39:14.229751+00	
00000000-0000-0000-0000-000000000000	a69524a0-5c76-429d-95bc-da13d204fae6	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-14 15:47:50.460854+00	
00000000-0000-0000-0000-000000000000	36fe5d57-965b-4bcd-8d36-cb1f848b6180	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-14 15:47:53.470251+00	
00000000-0000-0000-0000-000000000000	608066f6-cbed-4d17-b39e-4fa80facdc4a	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-14 15:48:02.36542+00	
00000000-0000-0000-0000-000000000000	a5c52139-47b7-4e05-95c5-ebd143e7c647	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-14 15:48:33.469474+00	
00000000-0000-0000-0000-000000000000	b0d15dd1-c981-405c-af6e-c0928745e363	{"action":"login","actor_id":"17e3383f-6805-413e-8254-0bbbeb7f225e","actor_username":"tcs@goiba.net","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-14 15:48:38.7899+00	
00000000-0000-0000-0000-000000000000	1f9820c8-c3c7-476a-91e1-61a451b87b47	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-14 15:52:34.350956+00	
00000000-0000-0000-0000-000000000000	ba9c638e-7b4a-48c2-9710-a9f54892845f	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-14 15:53:34.767831+00	
00000000-0000-0000-0000-000000000000	c75a15a7-d203-42a8-922b-44c2d8db0771	{"action":"logout","actor_id":"17e3383f-6805-413e-8254-0bbbeb7f225e","actor_username":"tcs@goiba.net","actor_via_sso":false,"log_type":"account"}	2025-05-14 15:58:46.191578+00	
00000000-0000-0000-0000-000000000000	b2f807af-2a64-4863-b611-6682d786efc0	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-14 15:58:55.285966+00	
00000000-0000-0000-0000-000000000000	b2e16c62-148b-485b-ac97-3139fa1bf2e9	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-14 15:59:20.565644+00	
00000000-0000-0000-0000-000000000000	4a2685ca-2d04-4d19-8e30-a01b9bae2ef1	{"action":"login","actor_id":"17e3383f-6805-413e-8254-0bbbeb7f225e","actor_username":"tcs@goiba.net","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-14 15:59:27.109655+00	
00000000-0000-0000-0000-000000000000	9760f9d3-5952-47f4-a250-0b34f11665a2	{"action":"logout","actor_id":"17e3383f-6805-413e-8254-0bbbeb7f225e","actor_username":"tcs@goiba.net","actor_via_sso":false,"log_type":"account"}	2025-05-14 16:49:55.64596+00	
00000000-0000-0000-0000-000000000000	34f2a68e-a45e-47aa-bb67-287aa463ce13	{"action":"login","actor_id":"17e3383f-6805-413e-8254-0bbbeb7f225e","actor_username":"tcs@goiba.net","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-14 16:50:01.473096+00	
00000000-0000-0000-0000-000000000000	23ea840d-30b1-471f-a9f7-0c8372e95175	{"action":"logout","actor_id":"17e3383f-6805-413e-8254-0bbbeb7f225e","actor_username":"tcs@goiba.net","actor_via_sso":false,"log_type":"account"}	2025-05-14 17:11:59.923407+00	
00000000-0000-0000-0000-000000000000	fd413a8c-0583-4ae8-a190-9e4d6d00da56	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-14 17:12:06.620343+00	
00000000-0000-0000-0000-000000000000	e5090374-0874-479c-804a-e0d1b2626a44	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-14 17:45:31.638773+00	
00000000-0000-0000-0000-000000000000	83a29485-90f0-42fb-897a-9edea4f3db19	{"action":"login","actor_id":"17e3383f-6805-413e-8254-0bbbeb7f225e","actor_username":"tcs@goiba.net","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-14 17:45:37.767824+00	
00000000-0000-0000-0000-000000000000	b0405229-82ba-4285-b31e-29c974eb7e04	{"action":"logout","actor_id":"17e3383f-6805-413e-8254-0bbbeb7f225e","actor_username":"tcs@goiba.net","actor_via_sso":false,"log_type":"account"}	2025-05-14 17:59:24.77954+00	
00000000-0000-0000-0000-000000000000	23bf3fb1-7945-453c-88c6-1e57123443d5	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-14 17:59:31.39495+00	
00000000-0000-0000-0000-000000000000	090d2dc7-ab3d-4e15-ac7d-95eeb78fe718	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-14 18:00:32.388567+00	
00000000-0000-0000-0000-000000000000	049bf76c-3e30-4f71-9029-395633b79e01	{"action":"login","actor_id":"17e3383f-6805-413e-8254-0bbbeb7f225e","actor_username":"tcs@goiba.net","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-14 18:00:37.413031+00	
00000000-0000-0000-0000-000000000000	15ee6bc3-06e4-4fed-bbbb-d41ff8ef1e51	{"action":"logout","actor_id":"17e3383f-6805-413e-8254-0bbbeb7f225e","actor_username":"tcs@goiba.net","actor_via_sso":false,"log_type":"account"}	2025-05-14 18:54:34.469724+00	
00000000-0000-0000-0000-000000000000	5d1d79c8-1002-44cc-8fe2-f627eb44814a	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-14 22:49:27.05549+00	
00000000-0000-0000-0000-000000000000	2be09d40-4649-4b39-aa51-5117ea02cbe4	{"action":"token_refreshed","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 23:58:28.101794+00	
00000000-0000-0000-0000-000000000000	d7878aa8-fcab-4a9c-a2e9-8e57d2be1e7c	{"action":"token_revoked","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-14 23:58:28.104037+00	
00000000-0000-0000-0000-000000000000	c3622742-fb17-4b77-a4d6-64aa9ef6af2e	{"action":"login","actor_id":"17e3383f-6805-413e-8254-0bbbeb7f225e","actor_username":"tcs@goiba.net","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-15 03:40:51.939195+00	
00000000-0000-0000-0000-000000000000	de79f171-3188-4ae5-88f0-5186751f13e4	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-15 03:44:15.007036+00	
00000000-0000-0000-0000-000000000000	df1fd906-175b-42ab-a5cf-8469f096892b	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-15 03:46:06.529379+00	
00000000-0000-0000-0000-000000000000	219971fe-0066-4319-ba92-0e36b3125970	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-15 03:46:26.69637+00	
00000000-0000-0000-0000-000000000000	e25d6231-e904-4dba-a767-4966a4ca6301	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-15 03:48:48.343921+00	
00000000-0000-0000-0000-000000000000	441fed52-ffa8-4c74-890b-16dea08ae8f3	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-15 04:09:55.672406+00	
00000000-0000-0000-0000-000000000000	4beafb91-f085-4a18-adab-047f967526bd	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-15 04:11:42.864922+00	
00000000-0000-0000-0000-000000000000	5674c360-bce7-4d82-b918-a45e30854a86	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-15 04:44:23.683063+00	
00000000-0000-0000-0000-000000000000	08453535-d03c-4588-9071-384ef0ddefc8	{"action":"login","actor_id":"17e3383f-6805-413e-8254-0bbbeb7f225e","actor_username":"tcs@goiba.net","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-15 04:45:11.553298+00	
00000000-0000-0000-0000-000000000000	0f34a70b-f679-449f-b5bb-204768cea1e2	{"action":"token_refreshed","actor_id":"17e3383f-6805-413e-8254-0bbbeb7f225e","actor_username":"tcs@goiba.net","actor_via_sso":false,"log_type":"token"}	2025-05-15 05:43:43.176547+00	
00000000-0000-0000-0000-000000000000	5c53ab69-4606-4229-9108-413dda2f5a87	{"action":"token_revoked","actor_id":"17e3383f-6805-413e-8254-0bbbeb7f225e","actor_username":"tcs@goiba.net","actor_via_sso":false,"log_type":"token"}	2025-05-15 05:43:43.188984+00	
00000000-0000-0000-0000-000000000000	084496ba-1c44-49df-bbcf-949b48b11685	{"action":"logout","actor_id":"17e3383f-6805-413e-8254-0bbbeb7f225e","actor_username":"tcs@goiba.net","actor_via_sso":false,"log_type":"account"}	2025-05-15 06:32:58.109959+00	
00000000-0000-0000-0000-000000000000	e0c488b0-6688-447d-a0d9-d8b626ccff2d	{"action":"login","actor_id":"17e3383f-6805-413e-8254-0bbbeb7f225e","actor_username":"tcs@goiba.net","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-15 06:33:04.743213+00	
00000000-0000-0000-0000-000000000000	fac0db3b-c040-448b-8891-a409dc5234de	{"action":"logout","actor_id":"17e3383f-6805-413e-8254-0bbbeb7f225e","actor_username":"tcs@goiba.net","actor_via_sso":false,"log_type":"account"}	2025-05-15 06:33:14.748056+00	
00000000-0000-0000-0000-000000000000	6261cecb-d62c-4afb-ad87-0e796c0a3949	{"action":"login","actor_id":"17e3383f-6805-413e-8254-0bbbeb7f225e","actor_username":"tcs@goiba.net","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-15 06:33:17.64227+00	
00000000-0000-0000-0000-000000000000	c139e20b-4b99-40d7-9ac8-a178bd426272	{"action":"user_signedup","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"gopi.mohan@iba-group.com","user_id":"22c67970-fad9-4c11-b652-3d1a08d256f8","user_phone":""}}	2025-05-15 07:22:57.917576+00	
00000000-0000-0000-0000-000000000000	854ec628-acee-42e9-8731-30481376682e	{"action":"user_signedup","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"dhivakar.sakthinesan@iba-group.com","user_id":"3318ff37-2875-4764-a176-3b8dac2ad352","user_phone":""}}	2025-05-15 07:24:04.158585+00	
00000000-0000-0000-0000-000000000000	89438175-54d3-433a-b881-71372fdb7cac	{"action":"user_signedup","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"aravindraj.ramachandran@iba-group.com","user_id":"803d1878-6177-4a85-9284-126e25be580b","user_phone":""}}	2025-05-15 07:25:02.835408+00	
00000000-0000-0000-0000-000000000000	a5d01ce2-3850-430b-a526-d9e94a71b0c0	{"action":"user_signedup","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"suresh.kumar@iba-group.com","user_id":"86a93f00-ff2c-4151-932d-c03dd761510a","user_phone":""}}	2025-05-15 07:26:03.993966+00	
00000000-0000-0000-0000-000000000000	3579a5e5-aae0-4ace-a2f1-2c34f8b3c06f	{"action":"user_signedup","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"giftusdavid.sathyawinfred@iba-group.com","user_id":"4d4e3623-9b68-48a9-93a1-f00d6ebf7f47","user_phone":""}}	2025-05-15 07:26:57.47084+00	
00000000-0000-0000-0000-000000000000	d44dc306-3de1-4461-8405-ba9c1b4576b5	{"action":"token_refreshed","actor_id":"17e3383f-6805-413e-8254-0bbbeb7f225e","actor_username":"tcs@goiba.net","actor_via_sso":false,"log_type":"token"}	2025-05-15 07:31:32.116509+00	
00000000-0000-0000-0000-000000000000	92a5e4af-f75f-4ec7-a0c3-761b5523ac45	{"action":"token_revoked","actor_id":"17e3383f-6805-413e-8254-0bbbeb7f225e","actor_username":"tcs@goiba.net","actor_via_sso":false,"log_type":"token"}	2025-05-15 07:31:32.119951+00	
00000000-0000-0000-0000-000000000000	9c0ef4a7-8fb0-4dab-9b56-db556d1bb35c	{"action":"logout","actor_id":"17e3383f-6805-413e-8254-0bbbeb7f225e","actor_username":"tcs@goiba.net","actor_via_sso":false,"log_type":"account"}	2025-05-15 07:38:12.723589+00	
00000000-0000-0000-0000-000000000000	d93fa469-b0f6-49f7-8fad-113ef38fa709	{"action":"login","actor_id":"22c67970-fad9-4c11-b652-3d1a08d256f8","actor_username":"gopi.mohan@iba-group.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-15 07:38:47.748946+00	
00000000-0000-0000-0000-000000000000	2f068311-5ec7-4934-8346-9d1875935191	{"action":"logout","actor_id":"22c67970-fad9-4c11-b652-3d1a08d256f8","actor_username":"gopi.mohan@iba-group.com","actor_via_sso":false,"log_type":"account"}	2025-05-15 07:47:53.133335+00	
00000000-0000-0000-0000-000000000000	d4ead93d-f847-4631-ada0-39ac7c3d5014	{"action":"login","actor_id":"22c67970-fad9-4c11-b652-3d1a08d256f8","actor_username":"gopi.mohan@iba-group.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-15 07:47:59.71671+00	
00000000-0000-0000-0000-000000000000	27398f5a-13d7-44fe-8e28-5f98521a2242	{"action":"login","actor_id":"22c67970-fad9-4c11-b652-3d1a08d256f8","actor_username":"gopi.mohan@iba-group.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-15 08:09:03.170573+00	
00000000-0000-0000-0000-000000000000	ca565b6d-7569-4d9c-aed3-d8a21a4b20f1	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-15 08:29:42.216481+00	
00000000-0000-0000-0000-000000000000	a50c2d23-11b0-4fa6-bc8b-9bf715ab6278	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-15 08:30:26.781827+00	
00000000-0000-0000-0000-000000000000	4bd42336-81c1-481f-81db-cf1e2cd64ce6	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-15 08:30:32.278298+00	
00000000-0000-0000-0000-000000000000	3454f628-91ac-493d-b324-d6e324654f97	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-15 08:42:45.145993+00	
00000000-0000-0000-0000-000000000000	14d81c00-f9b7-4e6c-9738-50eaaf6a88ef	{"action":"login","actor_id":"d630c4d9-2929-4a44-9a53-92aeb8586182","actor_username":"rajagopal.krishnamoorthy@iba-group.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-15 08:55:48.536286+00	
00000000-0000-0000-0000-000000000000	ef5bfabd-b7fd-4f02-b331-5b86ffd8c963	{"action":"user_signedup","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"roland.loeschner@iba-group.com","user_id":"da24e324-3029-4f4b-a3fd-a3310e7fb80a","user_phone":""}}	2025-05-15 09:01:33.314687+00	
00000000-0000-0000-0000-000000000000	a4f8c3a0-a334-4e15-94f5-470f96ac5b59	{"action":"logout","actor_id":"d630c4d9-2929-4a44-9a53-92aeb8586182","actor_username":"rajagopal.krishnamoorthy@iba-group.com","actor_via_sso":false,"log_type":"account"}	2025-05-15 09:01:42.990378+00	
00000000-0000-0000-0000-000000000000	e8109a9e-9430-49bd-bc2a-d91a14e59230	{"action":"login","actor_id":"da24e324-3029-4f4b-a3fd-a3310e7fb80a","actor_username":"roland.loeschner@iba-group.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-15 09:02:24.706196+00	
00000000-0000-0000-0000-000000000000	f035d519-0f4b-4d2f-9bb1-80f82a409465	{"action":"logout","actor_id":"da24e324-3029-4f4b-a3fd-a3310e7fb80a","actor_username":"roland.loeschner@iba-group.com","actor_via_sso":false,"log_type":"account"}	2025-05-15 09:02:32.805517+00	
00000000-0000-0000-0000-000000000000	95672320-1de2-44b8-8647-50ed5a4cab83	{"action":"login","actor_id":"86a93f00-ff2c-4151-932d-c03dd761510a","actor_username":"suresh.kumar@iba-group.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-15 09:03:35.456262+00	
00000000-0000-0000-0000-000000000000	8cc9e5fc-6ffb-4fb6-9a3a-9337a7a760f1	{"action":"login","actor_id":"d630c4d9-2929-4a44-9a53-92aeb8586182","actor_username":"rajagopal.krishnamoorthy@iba-group.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-15 09:03:39.355581+00	
00000000-0000-0000-0000-000000000000	4cedc00b-0911-42f5-9c42-f801b1339d6b	{"action":"logout","actor_id":"86a93f00-ff2c-4151-932d-c03dd761510a","actor_username":"suresh.kumar@iba-group.com","actor_via_sso":false,"log_type":"account"}	2025-05-15 09:03:53.043028+00	
00000000-0000-0000-0000-000000000000	8bf919f1-48fc-47a8-b08f-1e9e16ba9aee	{"action":"logout","actor_id":"d630c4d9-2929-4a44-9a53-92aeb8586182","actor_username":"rajagopal.krishnamoorthy@iba-group.com","actor_via_sso":false,"log_type":"account"}	2025-05-15 09:04:57.950509+00	
00000000-0000-0000-0000-000000000000	88331939-cc52-4e60-85ca-ee17e5ece115	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-15 09:05:00.421849+00	
00000000-0000-0000-0000-000000000000	0bba0ba7-1d71-4aab-9d76-b305159cb5a0	{"action":"login","actor_id":"d630c4d9-2929-4a44-9a53-92aeb8586182","actor_username":"rajagopal.krishnamoorthy@iba-group.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-15 09:05:04.480807+00	
00000000-0000-0000-0000-000000000000	efceb5c1-88dd-44b7-9235-d731a5d46caa	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-15 09:05:17.739119+00	
00000000-0000-0000-0000-000000000000	e09d5da6-3b01-447a-aa06-e78738e81dbd	{"action":"login","actor_id":"86a93f00-ff2c-4151-932d-c03dd761510a","actor_username":"suresh.kumar@iba-group.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-15 09:05:28.182521+00	
00000000-0000-0000-0000-000000000000	cb122923-6e1f-44d9-bf15-7452ddf4c14c	{"action":"logout","actor_id":"86a93f00-ff2c-4151-932d-c03dd761510a","actor_username":"suresh.kumar@iba-group.com","actor_via_sso":false,"log_type":"account"}	2025-05-15 09:06:57.16016+00	
00000000-0000-0000-0000-000000000000	fe5a701b-262c-4d57-8abb-400763f6eea1	{"action":"login","actor_id":"86a93f00-ff2c-4151-932d-c03dd761510a","actor_username":"suresh.kumar@iba-group.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-15 09:08:23.950958+00	
00000000-0000-0000-0000-000000000000	e5de2593-0c29-43b1-886a-25d7f2aaf40e	{"action":"logout","actor_id":"86a93f00-ff2c-4151-932d-c03dd761510a","actor_username":"suresh.kumar@iba-group.com","actor_via_sso":false,"log_type":"account"}	2025-05-15 09:08:46.575374+00	
00000000-0000-0000-0000-000000000000	19b3d20c-8073-4c14-98b9-8cfcb932ca88	{"action":"login","actor_id":"17e3383f-6805-413e-8254-0bbbeb7f225e","actor_username":"tcs@goiba.net","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-15 09:49:22.638704+00	
00000000-0000-0000-0000-000000000000	0e945296-8671-4058-80e4-178990314dd1	{"action":"logout","actor_id":"17e3383f-6805-413e-8254-0bbbeb7f225e","actor_username":"tcs@goiba.net","actor_via_sso":false,"log_type":"account"}	2025-05-15 09:50:20.563868+00	
00000000-0000-0000-0000-000000000000	104529fb-f2dc-400d-8567-5989d4f8097e	{"action":"token_refreshed","actor_id":"d630c4d9-2929-4a44-9a53-92aeb8586182","actor_username":"rajagopal.krishnamoorthy@iba-group.com","actor_via_sso":false,"log_type":"token"}	2025-05-15 10:03:55.871079+00	
00000000-0000-0000-0000-000000000000	a7ac1cea-49fe-44ff-81ef-c478927744f6	{"action":"token_revoked","actor_id":"d630c4d9-2929-4a44-9a53-92aeb8586182","actor_username":"rajagopal.krishnamoorthy@iba-group.com","actor_via_sso":false,"log_type":"token"}	2025-05-15 10:03:55.87479+00	
00000000-0000-0000-0000-000000000000	9a389ba7-6ebd-4873-a7ce-a2b4ba987172	{"action":"login","actor_id":"d630c4d9-2929-4a44-9a53-92aeb8586182","actor_username":"rajagopal.krishnamoorthy@iba-group.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-15 10:12:47.978036+00	
00000000-0000-0000-0000-000000000000	4413c964-a3b6-4001-91e9-69f97525e262	{"action":"login","actor_id":"da24e324-3029-4f4b-a3fd-a3310e7fb80a","actor_username":"roland.loeschner@iba-group.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-15 11:02:25.773087+00	
00000000-0000-0000-0000-000000000000	e75909a4-781b-46ee-8fbe-b5537adae7aa	{"action":"token_refreshed","actor_id":"d630c4d9-2929-4a44-9a53-92aeb8586182","actor_username":"rajagopal.krishnamoorthy@iba-group.com","actor_via_sso":false,"log_type":"token"}	2025-05-15 11:05:06.65937+00	
00000000-0000-0000-0000-000000000000	cd687046-3a7e-4a71-a228-d015fb10514c	{"action":"token_revoked","actor_id":"d630c4d9-2929-4a44-9a53-92aeb8586182","actor_username":"rajagopal.krishnamoorthy@iba-group.com","actor_via_sso":false,"log_type":"token"}	2025-05-15 11:05:06.660978+00	
00000000-0000-0000-0000-000000000000	2ae91a96-b434-4bae-9878-7aae9674e2ed	{"action":"token_refreshed","actor_id":"da24e324-3029-4f4b-a3fd-a3310e7fb80a","actor_username":"roland.loeschner@iba-group.com","actor_via_sso":false,"log_type":"token"}	2025-05-15 12:01:10.161614+00	
00000000-0000-0000-0000-000000000000	1ad34ed4-eb57-4557-9c46-ddb73b8da4f7	{"action":"token_revoked","actor_id":"da24e324-3029-4f4b-a3fd-a3310e7fb80a","actor_username":"roland.loeschner@iba-group.com","actor_via_sso":false,"log_type":"token"}	2025-05-15 12:01:10.165835+00	
00000000-0000-0000-0000-000000000000	7f7a43de-8d20-4d64-92a1-cb8e77fc1b5b	{"action":"token_refreshed","actor_id":"da24e324-3029-4f4b-a3fd-a3310e7fb80a","actor_username":"roland.loeschner@iba-group.com","actor_via_sso":false,"log_type":"token"}	2025-05-15 13:00:10.083602+00	
00000000-0000-0000-0000-000000000000	f18be191-0f26-48b9-9c8f-e120498fda7d	{"action":"token_revoked","actor_id":"da24e324-3029-4f4b-a3fd-a3310e7fb80a","actor_username":"roland.loeschner@iba-group.com","actor_via_sso":false,"log_type":"token"}	2025-05-15 13:00:10.088044+00	
00000000-0000-0000-0000-000000000000	31bcf6c3-08cd-411d-badc-004b01e8f70c	{"action":"token_refreshed","actor_id":"da24e324-3029-4f4b-a3fd-a3310e7fb80a","actor_username":"roland.loeschner@iba-group.com","actor_via_sso":false,"log_type":"token"}	2025-05-15 13:59:25.041643+00	
00000000-0000-0000-0000-000000000000	56ba799a-da4b-4729-afc0-61b2100ebc23	{"action":"token_revoked","actor_id":"da24e324-3029-4f4b-a3fd-a3310e7fb80a","actor_username":"roland.loeschner@iba-group.com","actor_via_sso":false,"log_type":"token"}	2025-05-15 13:59:25.050746+00	
00000000-0000-0000-0000-000000000000	4d85ce1b-a454-4d37-a2f2-ade2c1e9e137	{"action":"token_refreshed","actor_id":"da24e324-3029-4f4b-a3fd-a3310e7fb80a","actor_username":"roland.loeschner@iba-group.com","actor_via_sso":false,"log_type":"token"}	2025-05-15 14:58:20.687667+00	
00000000-0000-0000-0000-000000000000	9243b0ae-3dd1-4a7e-9188-782d1b038654	{"action":"token_revoked","actor_id":"da24e324-3029-4f4b-a3fd-a3310e7fb80a","actor_username":"roland.loeschner@iba-group.com","actor_via_sso":false,"log_type":"token"}	2025-05-15 14:58:20.689893+00	
00000000-0000-0000-0000-000000000000	269997f2-40c7-45b5-a7d7-e73b294b7709	{"action":"login","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-16 01:39:16.461576+00	
00000000-0000-0000-0000-000000000000	0e33a60a-7134-4b05-92b8-4cf3b6b84cbe	{"action":"logout","actor_id":"36d49150-8a97-45d2-a96d-116319c07fea","actor_username":"jithinkv2013@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-16 01:57:34.488629+00	
\.


--
-- Data for Name: flow_state; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.flow_state (id, user_id, auth_code, code_challenge_method, code_challenge, provider_type, provider_access_token, provider_refresh_token, created_at, updated_at, authentication_method, auth_code_issued_at) FROM stdin;
\.


--
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.identities (provider_id, user_id, identity_data, provider, last_sign_in_at, created_at, updated_at, id) FROM stdin;
\.


--
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.instances (id, uuid, raw_base_config, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_amr_claims (session_id, created_at, updated_at, authentication_method, id) FROM stdin;
1329f164-87b8-4584-b244-fe1e68cca476	2025-05-16 06:42:24.234832+00	2025-05-16 06:42:24.234832+00	password	8e962dad-1bda-44c9-bffe-d6228126c105
\.


--
-- Data for Name: mfa_challenges; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_challenges (id, factor_id, created_at, verified_at, ip_address, otp_code, web_authn_session_data) FROM stdin;
\.


--
-- Data for Name: mfa_factors; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_factors (id, user_id, friendly_name, factor_type, status, created_at, updated_at, secret, phone, last_challenged_at, web_authn_credential, web_authn_aaguid) FROM stdin;
\.


--
-- Data for Name: one_time_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.one_time_tokens (id, user_id, token_type, token_hash, relates_to, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.refresh_tokens (instance_id, id, token, user_id, revoked, created_at, updated_at, parent, session_id) FROM stdin;
00000000-0000-0000-0000-000000000000	602	k2pvqmz3xhhb	36d49150-8a97-45d2-a96d-116319c07fea	f	2025-05-16 06:42:24.22107+00	2025-05-16 06:42:24.22107+00	\N	1329f164-87b8-4584-b244-fe1e68cca476
\.


--
-- Data for Name: saml_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.saml_providers (id, sso_provider_id, entity_id, metadata_xml, metadata_url, attribute_mapping, created_at, updated_at, name_id_format) FROM stdin;
\.


--
-- Data for Name: saml_relay_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.saml_relay_states (id, sso_provider_id, request_id, for_email, redirect_to, created_at, updated_at, flow_state_id) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.schema_migrations (version) FROM stdin;
20171026211738
20171026211808
20171026211834
20180103212743
20180108183307
20180119214651
20180125194653
00
20210710035447
20210722035447
20210730183235
20210909172000
20210927181326
20211122151130
20211124214934
20211202183645
20220114185221
20220114185340
20220224000811
20220323170000
20220429102000
20220531120530
20220614074223
20220811173540
20221003041349
20221003041400
20221011041400
20221020193600
20221021073300
20221021082433
20221027105023
20221114143122
20221114143410
20221125140132
20221208132122
20221215195500
20221215195800
20221215195900
20230116124310
20230116124412
20230131181311
20230322519590
20230402418590
20230411005111
20230508135423
20230523124323
20230818113222
20230914180801
20231027141322
20231114161723
20231117164230
20240115144230
20240214120130
20240306115329
20240314092811
20240427152123
20240612123726
20240729123726
20240802193726
20240806073726
20241009103726
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sessions (id, user_id, created_at, updated_at, factor_id, aal, not_after, refreshed_at, user_agent, ip, tag) FROM stdin;
1329f164-87b8-4584-b244-fe1e68cca476	36d49150-8a97-45d2-a96d-116319c07fea	2025-05-16 06:42:24.212682+00	2025-05-16 06:42:24.212682+00	\N	aal1	\N	\N	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36	192.168.65.1	\N
\.


--
-- Data for Name: sso_domains; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sso_domains (id, sso_provider_id, domain, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: sso_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sso_providers (id, resource_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, invited_at, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) FROM stdin;
00000000-0000-0000-0000-000000000000	6e6376f2-9648-4c72-80f2-809adfe63988	authenticated	authenticated	rupesh.sakthivel@iba-group.com	$2a$10$gnBj91uzTh.g2sqNvycSuu76oxsBf0OI3mDtpFb.Q860mhX6t/pxC	2025-05-05 09:57:32.498849+00	\N		\N		\N			\N	2025-05-14 10:05:47.156715+00	{"provider": "email", "providers": ["email"]}	{"email_verified": true}	\N	2025-05-05 09:57:32.481934+00	2025-05-14 10:05:47.164273+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	18c42826-0ae1-4833-8fd3-5ed1614ab339	authenticated	authenticated	jithin.palottukandy@iba-group.com	$2a$10$xuCxzL.uXOGKNqnIC7BamOtVSRfxBXsj.7V52uUxeancBl0rBI9OW	2025-05-14 04:42:59.633301+00	\N		\N		\N			\N	2025-05-14 10:11:09.53392+00	{"provider": "email", "providers": ["email"]}	{"email_verified": true}	\N	2025-05-14 04:42:59.611607+00	2025-05-14 10:11:09.537548+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	86a93f00-ff2c-4151-932d-c03dd761510a	authenticated	authenticated	suresh.kumar@iba-group.com	$2a$10$EZ81hPlvYCMwGl64COY1WOHg9Q6mpy9QKi4j5/zXwuJ6mo7km3Bhi	2025-05-15 07:26:03.999546+00	\N		\N		\N			\N	2025-05-15 09:08:23.951998+00	{"provider": "email", "providers": ["email"]}	{"email_verified": true}	\N	2025-05-15 07:26:03.987669+00	2025-05-15 09:08:23.957049+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	4d4e3623-9b68-48a9-93a1-f00d6ebf7f47	authenticated	authenticated	giftusdavid.sathyawinfred@iba-group.com	$2a$10$XpSrIIdQ8i/QSZh24qI4zesDwFXtYefjkW03fD5T8YgZnlTJVC.Fy	2025-05-15 07:26:57.472498+00	\N		\N		\N			\N	\N	{"provider": "email", "providers": ["email"]}	{"email_verified": true}	\N	2025-05-15 07:26:57.469045+00	2025-05-15 07:26:57.473155+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	3318ff37-2875-4764-a176-3b8dac2ad352	authenticated	authenticated	dhivakar.sakthinesan@iba-group.com	$2a$10$A/wrbXqaP5dyC4N7IDPuKOLImok1b2JPN//Q5s8MdkraifbMB31rO	2025-05-15 07:24:04.162314+00	\N		\N		\N			\N	\N	{"provider": "email", "providers": ["email"]}	{"email_verified": true}	\N	2025-05-15 07:24:04.153564+00	2025-05-15 07:24:04.163959+00	\N	\N			\N		0	\N		\N	f	\N	f
\N	d2e159cd-6a81-49d9-a47a-8239c43ae0e7	\N	\N	giftus@iba-group.com	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	17e3383f-6805-413e-8254-0bbbeb7f225e	authenticated	authenticated	tcs@goiba.net	$2a$10$r0SLjy/NtBEZP7rLF35FIuishCq1q5NNUgSAhRoPPptpHIXldNZk.	2025-05-14 11:32:47.83442+00	\N		\N		\N			\N	2025-05-15 09:49:22.642163+00	{"provider": "email", "providers": ["email"]}	{"email_verified": true}	\N	2025-05-14 11:32:47.818967+00	2025-05-15 09:49:22.647294+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	da24e324-3029-4f4b-a3fd-a3310e7fb80a	authenticated	authenticated	roland.loeschner@iba-group.com	$2a$10$gW5PnqOnMCXGtOcJdVOkgO9oFAriNihvlXz.bZVr/yvObEp9ItFMW	2025-05-15 09:01:33.319042+00	\N		\N		\N			\N	2025-05-15 11:02:25.776972+00	{"provider": "email", "providers": ["email"]}	{"email_verified": true}	\N	2025-05-15 09:01:33.308466+00	2025-05-15 14:58:20.696118+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	e604e248-d849-4c04-a7b8-b2b46bb13e4a	authenticated	authenticated	vishnuv.shenoy@iba-group.com	$2a$10$ha2rO5/xse1.4I4kSfBCQOwhCDC047YLIE8BX1CRw52Vsn/PFWuP.	2025-05-14 10:04:10.372374+00	\N		\N		\N			\N	\N	{"provider": "email", "providers": ["email"]}	{"email_verified": true}	\N	2025-05-14 10:04:10.350607+00	2025-05-14 10:04:10.374819+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	803d1878-6177-4a85-9284-126e25be580b	authenticated	authenticated	aravindraj.ramachandran@iba-group.com	$2a$10$bp70aBmsRZ8BSfizQxTEq.gTSocIzz0ptqKSLvQOAe7MuRPtlNaTu	2025-05-15 07:25:02.836403+00	\N		\N		\N			\N	\N	{"provider": "email", "providers": ["email"]}	{"email_verified": true}	\N	2025-05-15 07:25:02.832121+00	2025-05-15 07:25:02.837078+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	22c67970-fad9-4c11-b652-3d1a08d256f8	authenticated	authenticated	gopi.mohan@iba-group.com	$2a$10$VvumolUMmTIrAFIX1PiLx.Q5VScTP8p0.6o.hEQR/6Ks60HPwovQq	2025-05-15 07:22:57.921815+00	\N		\N		\N			\N	2025-05-15 08:09:03.174051+00	{"provider": "email", "providers": ["email"]}	{"email_verified": true}	\N	2025-05-15 07:22:57.887622+00	2025-05-15 08:09:03.180716+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	d630c4d9-2929-4a44-9a53-92aeb8586182	authenticated	authenticated	rajagopal.krishnamoorthy@iba-group.com	$2a$10$d5M9JEyca.LNZjTT.LKIyOrDLwhsYNU3GDAjR9Ki/5GvkMGVFD6Ym	2025-05-14 10:05:35.448513+00	\N		\N		\N			\N	2025-05-15 10:12:47.981423+00	{"provider": "email", "providers": ["email"]}	{"email_verified": true}	\N	2025-05-14 10:05:35.44138+00	2025-05-15 11:05:06.664476+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	36d49150-8a97-45d2-a96d-116319c07fea	authenticated	authenticated	jithinkv2013@gmail.com	$2a$10$5eIr2OWR3b7YEH.L1tkZU.VBvYiBPaEjkZ0GhGgmzNu7RWuiSEqRW	2025-03-29 22:04:12.920263+00	\N		\N		\N			\N	2025-05-16 06:42:24.209312+00	{"provider": "email", "providers": ["email"]}	{"sub": "36d49150-8a97-45d2-a96d-116319c07fea", "email": "jithinkv2013@gmail.com", "email_verified": true, "phone_verified": false}	\N	2025-03-29 22:04:12.896501+00	2025-05-16 06:42:24.232562+00	\N	\N			\N		0	\N		\N	f	\N	f
\.


--
-- Data for Name: key; Type: TABLE DATA; Schema: pgsodium; Owner: supabase_admin
--

COPY pgsodium.key (id, status, created, expires, key_type, key_id, key_context, name, associated_data, raw_key, raw_key_nonce, parent_key, comment, user_data) FROM stdin;
\.


--
-- Data for Name: access_requests; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.access_requests (id, name, email, role, message, status, created_at) FROM stdin;
26146927-3546-4f70-a4e3-9a2179f8bf02	Rajagopal Krishnamoorthy	rajagopal.krishnamoorthy@iba-group.com	Manager	Access Required	pending	2025-05-15 08:54:46.160481+00
\.


--
-- Data for Name: active_shifts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.active_shifts (id, shift_type, started_at, started_by, salesforce_number, created_at) FROM stdin;
f5c7c454-2cae-44ac-934a-f7c283e56e58	morning	2025-05-16 06:48:37.132+00	36d49150-8a97-45d2-a96d-116319c07fea	test	2025-05-16 06:48:37.139978+00
\.


--
-- Data for Name: attachments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.attachments (id, created_at, user_id, log_entry_id, file_name, file_type, file_size, file_path, public_url) FROM stdin;
037e0824-d351-4bfd-a53b-8dd6ecbfe272	2025-05-16 06:54:20.043476+00	36d49150-8a97-45d2-a96d-116319c07fea	225bec15-ee5b-463c-bad4-2cb0d22a3b53	Indoor-Photoshoot-Studio-Space-for-Rent-in-Chennai.jpg	image/jpeg	172183	36d49150-8a97-45d2-a96d-116319c07fea/kmci0okarv_1747378457591.jpg	\N
\.


--
-- Data for Name: engineers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.engineers (id, name, user_id, created_at) FROM stdin;
93d69223-94db-4b0d-809e-d70d3b05cb2e	Jithin	36d49150-8a97-45d2-a96d-116319c07fea	2025-03-29 22:30:04.689987+00
e4c31835-adbf-40fc-a8e1-9f65493e7a9b	Gopi	36d49150-8a97-45d2-a96d-116319c07fea	2025-03-29 22:30:04.689987+00
297a1ed5-eaab-4328-8a15-85d19a7086bb	Sarin	36d49150-8a97-45d2-a96d-116319c07fea	2025-03-29 22:30:04.689987+00
3f442eab-49c1-462b-9ea7-3a249e1e27ce	Vishnu	36d49150-8a97-45d2-a96d-116319c07fea	2025-03-29 22:30:04.689987+00
e70c8231-8cb2-4682-9bfc-7315bef32612	Dhivakar	36d49150-8a97-45d2-a96d-116319c07fea	2025-03-29 22:30:04.689987+00
30719c63-a4c1-4497-8729-d34b4191a69c	Suresh	36d49150-8a97-45d2-a96d-116319c07fea	2025-03-29 22:30:04.689987+00
21cf20da-9147-446e-a257-360cb478e645	Aravind	36d49150-8a97-45d2-a96d-116319c07fea	2025-03-29 22:30:04.689987+00
e6b111e1-c4b9-453e-91f5-2a34684f5d75	Sri	36d49150-8a97-45d2-a96d-116319c07fea	2025-03-29 22:30:04.689987+00
adb54ea2-25c5-4220-8ff7-a3d16713664e	Raja	36d49150-8a97-45d2-a96d-116319c07fea	2025-03-29 22:30:04.689987+00
f91dc27c-75c4-477c-8947-b46d781dd561	Rupesh	36d49150-8a97-45d2-a96d-116319c07fea	2025-03-29 22:30:04.689987+00
7db1ca8f-207c-4d30-ac2a-9effd3db3c88	Giftus	d2e159cd-6a81-49d9-a47a-8239c43ae0e7	2025-04-29 02:15:03.75648+00
\.


--
-- Data for Name: log_entries; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.log_entries (id, created_at, shift_type, category, description, user_id, case_number, case_status, workorder_number, workorder_status, mc_setpoint, yoke_temperature, arc_current, filament_current, p1e_x_width, p1e_y_width, p2e_x_width, p2e_y_width, removed_source_number, removed_filament_current, removed_arc_current, removed_filament_counter, inserted_source_number, inserted_filament_current, inserted_arc_current, inserted_filament_counter, filament_hours, engineers, dt_start_time, dt_end_time, dt_duration, workorder_title, preferred_start_time, shift_id, downtime_id) FROM stdin;
bd5bfd75-b5a5-42c3-ad60-09b725dd7390	2025-05-15 07:34:41.417281+00	morning	shift	morning shift ended. Note: Source baseline data added - test shift ended - please this for shift reporting	17e3383f-6805-413e-8254-0bbbeb7f225e	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
3539e377-1d1d-450e-8305-a1ce7b2766fd	2025-05-15 07:35:43.350426+00	morning	shift	morning shift started by Dhivakar, Gopi, Jithin, Rupesh (SF#: SR-103185)	17e3383f-6805-413e-8254-0bbbeb7f225e	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	a44TX00001ZCcL2YAL	\N
6ec49386-af8a-4cc3-8767-c765d3c6a502	2025-05-15 07:40:53.798735+00	morning	data-mc	Routine MC tuning - morning 	22c67970-fad9-4c11-b652-3d1a08d256f8	\N	\N	\N	\N	748.43	35.82	73.1	182.87	1.55	1.35	15.62	18.03	\N	\N	\N	\N	\N	\N	\N	\N	\N	{}	\N	\N	\N		\N	\N	\N
9b9feec3-eefb-49f6-b497-3276863870a3	2025-05-15 07:42:13.952566+00	morning	general	Found HVAC turned off in the vault - turn on the HVAC at 6:00am - yoke temp got affected	22c67970-fad9-4c11-b652-3d1a08d256f8	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
e8567665-339f-4fb8-bc64-0b629b284638	2025-05-15 07:42:49.895304+00	morning	error	In GTR-2 Positioning Process crashed - PCU Restarted and recovered	22c67970-fad9-4c11-b652-3d1a08d256f8	\N	\N	\N	\N	748.4	35.75	75	175	1.5	1.3	14.5	17.5	\N	\N	\N	\N	\N	\N	\N	\N	\N	{}	\N	\N	\N		\N	\N	\N
b393274e-fa3a-48dd-94b7-75b8b11a68a0	2025-05-15 07:28:34.040376+00	morning	shift	morning shift started by Jithin (SF#: test)	17e3383f-6805-413e-8254-0bbbeb7f225e	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	test	\N
f3319678-c42d-4aa9-ad52-1f43dbd4490a	2025-05-15 07:33:57.979385+00	morning	data-sc	IC Cyclo pause - adding data from 13-May-2025 - Source 3 removed 	17e3383f-6805-413e-8254-0bbbeb7f225e		\N	WO-291318	\N	748.4	35.75	75	175	1.5	1.3	14.5	17.5	3	185	64.7	28529	1	192	68	\N	\N	{e4c31835-adbf-40fc-a8e1-9f65493e7a9b,e70c8231-8cb2-4682-9bfc-7315bef32612}	\N	\N	\N		\N	\N	\N
24e9dd8e-559e-4e97-b650-48a5dc41423f	2025-05-15 07:43:09.395861+00	morning	error	In GTR-3 Collision detected upon QA . Restarted Positioning process and recovered	22c67970-fad9-4c11-b652-3d1a08d256f8	\N	\N	\N	\N	748.4	35.75	75	175	1.5	1.3	14.5	17.5	\N	\N	\N	\N	\N	\N	\N	\N	\N	{}	\N	\N	\N		\N	\N	\N
bea0688d-5476-44c8-aea5-0320a69a02bb	2025-05-15 07:43:24.948696+00	morning	general	GTR3_ RAD b locking jack not working properly , looks like air pressure is weak, all the pneumatic devices are slow in action . need to be checked	22c67970-fad9-4c11-b652-3d1a08d256f8	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
9a18e2cd-275c-4ddf-b827-6d940260ff92	2025-05-15 07:43:49.862418+00	morning	error	FBTR: Leoni , DNSHCU were in error state , needed restart and use of MHP to recover	22c67970-fad9-4c11-b652-3d1a08d256f8	\N	\N	\N	\N	748.4	35.75	75	175	1.5	1.3	14.5	17.5	\N	\N	\N	\N	\N	\N	\N	\N	\N	{}	\N	\N	\N		\N	\N	\N
03c0b863-88a7-41d7-a65c-c20ef90d66a7	2025-05-15 07:45:26.714546+00	morning	error	GTR3 - Customer reported RAD-B insertion issue at gantry angles near 30 and 90 - needs to check this 	22c67970-fad9-4c11-b652-3d1a08d256f8	\N	\N	\N	\N	748.4	35.75	75	175	1.5	1.3	14.5	17.5	\N	\N	\N	\N	\N	\N	\N	\N	\N	{}	\N	\N	\N		\N	\N	\N
da77e6cb-9c53-461a-bc4a-61e130c0eb8a	2025-05-15 07:46:24.516027+00	morning	general	GTR2 - Customer reported strange nose while rotating gantry to 90 deg - please check this after patient treatment	22c67970-fad9-4c11-b652-3d1a08d256f8	\N	\N	\N	\N	748.4	35.75	75	175	1.5	1.3	14.5	17.5	\N	\N	\N	\N	\N	\N	\N	\N	\N	{}	\N	\N	\N		\N	\N	\N
390d2cef-e466-4261-80b9-d941a38b9c42	2025-05-15 07:47:34.542183+00	morning	data-mc	Routine MC tuning	22c67970-fad9-4c11-b652-3d1a08d256f8	\N	\N	\N	\N	748.44	35.83	75.1	183.26	1.53	1.34	14.5	18.82	\N	\N	\N	\N	\N	\N	\N	\N	\N	{}	\N	\N	\N		\N	\N	\N
f56aa64b-fc57-4824-bf64-c987cca795a5	2025-05-15 08:10:42.688365+00	morning	general	GTR3 - RAD B - LS4-6 limit plate was loose , fixed it back all ok now , no issues	22c67970-fad9-4c11-b652-3d1a08d256f8	\N	\N	\N	\N	748.4	35.75	75	175	1.5	1.3	14.5	17.5	\N	\N	\N	\N	\N	\N	\N	\N	\N	{}	\N	\N	\N		\N	\N	\N
028fd433-387b-48f3-8765-0457361a84da	2025-05-15 08:17:09.527686+00	morning	general	GTR3 - PIT temp monitor were not working - inform to APCC	22c67970-fad9-4c11-b652-3d1a08d256f8	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
609d1be7-5307-4034-bdb4-1d862b73d6a3	2025-05-15 07:56:29.726473+00	morning	downtime	GTR-3, RAD-B, flat panel got struck partially	22c67970-fad9-4c11-b652-3d1a08d256f8	00223590	closed	\N	\N	748.4	35.75	75	175	1.5	1.3	14.5	17.5	\N	\N	\N	\N	\N	\N	\N	\N	\N	{}	2025-05-15 07:36:00+00	2025-05-15 07:46:00+00	10		\N	\N	500TX00000Iue5JYAR
7e3fb0a0-d6dd-45c7-b497-59b05364f320	2025-05-15 08:19:34.086385+00	morning	downtime	GTR-3, RAD-B, flat panel got struck partially	22c67970-fad9-4c11-b652-3d1a08d256f8	00223588	closed	\N	\N	748.4	35.75	75	175	1.5	1.3	14.5	17.5	\N	\N	\N	\N	\N	\N	\N	\N	\N	{}	2025-05-15 06:55:00+00	2025-05-15 07:05:00+00	10		\N	\N	500TX00000IugTgYAJ
3a9bf162-dee2-463b-a2ae-ce6aff5633ac	2025-05-15 08:27:55.362539+00	morning	shift	morning shift ended. Note: Few customer queries are mentioned in shift report please go through it - :-)	22c67970-fad9-4c11-b652-3d1a08d256f8	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
57d0195d-d5a5-4632-a10f-1ae5c296a751	2025-05-15 09:06:44.222394+00	afternoon	shift	afternoon shift started by Aravind, Giftus, Sarin, Suresh (SF#: SR-103206)	86a93f00-ff2c-4151-932d-c03dd761510a	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	a44TX00001ZF2CgYAL	\N
1e08f6dc-9aee-4b11-9b0e-8ae7a4a0ea27	2025-05-16 01:48:25.985536+00	morning	data-sc	Source regulation issue 	36d49150-8a97-45d2-a96d-116319c07fea	122243	\N	WO-12345	\N	748.4	35.75	75	175	1.5	1.3	14.5	17.5	1	175	75	28599	2	180.33	79.87	\N	70	{21cf20da-9147-446e-a257-360cb478e645,e70c8231-8cb2-4682-9bfc-7315bef32612}	\N	\N	\N		\N	\N	\N
ddfb234e-2de1-4043-addc-5f099d467862	2025-05-16 01:49:16.353446+00	afternoon	general	test	36d49150-8a97-45d2-a96d-116319c07fea	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
19903ad6-fcfb-4f8e-8483-b26932c2373d	2025-05-16 01:52:34.992467+00	morning	workorder	test	36d49150-8a97-45d2-a96d-116319c07fea	\N	\N	WO-00286445	open	748.4	35.75	75	175	1.5	1.3	14.5	17.5	\N	\N	\N	\N	\N	\N	\N	\N	\N	{}	\N	\N	\N	Source Regulation issue	\N	\N	\N
6b10a39e-30a1-4844-887e-d0b3349a31ee	2025-05-16 01:45:30.436333+00	morning	workorder	Completed - and updated in svmx	36d49150-8a97-45d2-a96d-116319c07fea	\N	\N	WO-00273164	open	748.4	35.75	75	175	1.5	1.3	14.5	17.5	\N	\N	\N	\N	\N	\N	\N	\N	\N	{}	\N	\N	\N	C230 Data Monitoring in PRIDEx	\N	\N	\N
ff91f1b7-624a-493c-aa7e-8c64ddc13ae1	2025-05-16 01:43:55.026899+00	morning	workorder	Completed and updated in SVMX	36d49150-8a97-45d2-a96d-116319c07fea	\N	\N	WO-00274502	open	748.4	35.75	75	175	1.5	1.3	14.5	17.5	\N	\N	\N	\N	\N	\N	\N	\N	\N	{}	\N	\N	\N	RTCB Fan and Filter Replacement	\N	\N	\N
d0d72ad5-59c7-4f64-909d-50b6826877cc	2025-05-16 06:42:55.681203+00	afternoon	general	adding from new loacl supabase setup	36d49150-8a97-45d2-a96d-116319c07fea	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
1021d4ab-3be7-4e53-80eb-fb61b1243637	2025-05-16 06:44:15.644989+00	afternoon	shift	afternoon shift ended. Note: testing end shift with local supabase setup	36d49150-8a97-45d2-a96d-116319c07fea	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
686b6607-d934-4c96-a0ff-29163769cacf	2025-05-16 06:45:46.69213+00	afternoon	shift	afternoon shift ended. Note: end test supabase localaaa	36d49150-8a97-45d2-a96d-116319c07fea	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
f7166f9f-67b9-472a-9fda-8030ee555996	2025-05-16 06:47:11.582706+00	morning	shift	morning shift started by Jithin (SF#: test)	36d49150-8a97-45d2-a96d-116319c07fea	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	test	\N
37cc18dc-3a49-459c-85ab-de26d31d3324	2025-05-16 06:47:18.352197+00	morning	shift	morning shift ended. Note: test	36d49150-8a97-45d2-a96d-116319c07fea	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
6b0cc819-4827-461d-9125-a9b5ed3066ce	2025-05-16 06:48:37.327486+00	morning	shift	morning shift started by Aravind, Gopi (SF#: test)	36d49150-8a97-45d2-a96d-116319c07fea	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	123	\N
446c022c-7a2c-4065-9235-bb84023cde80	2025-05-16 06:53:40.500265+00	morning	general	test quick entry	36d49150-8a97-45d2-a96d-116319c07fea	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
225bec15-ee5b-463c-bad4-2cb0d22a3b53	2025-05-16 06:54:17.556188+00	morning	general	test gen entry	36d49150-8a97-45d2-a96d-116319c07fea	\N	\N	\N	\N	748.4	35.75	75	175	1.5	1.3	14.5	17.5	\N	\N	\N	\N	\N	\N	\N	\N	\N	{}	\N	\N	\N		\N	\N	\N
\.


--
-- Data for Name: log_suggestions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.log_suggestions (id, category, description, usage_count, created_at, last_used) FROM stdin;
\.


--
-- Data for Name: profiles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.profiles (id, is_admin, created_at) FROM stdin;
17e3383f-6805-413e-8254-0bbbeb7f225e	t	2025-05-15 04:38:55+00
d630c4d9-2929-4a44-9a53-92aeb8586182	f	2025-05-15 04:39:13+00
e604e248-d849-4c04-a7b8-b2b46bb13e4a	f	2025-05-15 04:39:30+00
18c42826-0ae1-4833-8fd3-5ed1614ab339	t	2025-05-15 04:39:47+00
6e6376f2-9648-4c72-80f2-809adfe63988	f	2025-05-15 04:39:59+00
36d49150-8a97-45d2-a96d-116319c07fea	t	2025-05-15 04:40:15+00
22c67970-fad9-4c11-b652-3d1a08d256f8	f	2025-05-15 07:23:26+00
3318ff37-2875-4764-a176-3b8dac2ad352	f	2025-05-15 07:24:16+00
803d1878-6177-4a85-9284-126e25be580b	f	2025-05-15 07:25:13+00
86a93f00-ff2c-4151-932d-c03dd761510a	f	2025-05-15 07:26:16+00
4d4e3623-9b68-48a9-93a1-f00d6ebf7f47	f	2025-05-15 07:27:07+00
da24e324-3029-4f4b-a3fd-a3310e7fb80a	f	2025-05-15 09:01:52+00
\.


--
-- Data for Name: shift_engineers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.shift_engineers (shift_id, engineer_id) FROM stdin;
f5c7c454-2cae-44ac-934a-f7c283e56e58	21cf20da-9147-446e-a257-360cb478e645
f5c7c454-2cae-44ac-934a-f7c283e56e58	e4c31835-adbf-40fc-a8e1-9f65493e7a9b
\.


--
-- Data for Name: shift_notes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.shift_notes (id, created_at, shift_type, note, user_id) FROM stdin;
b6b6e877-a8f8-4e00-80e3-57db7b460e79	2025-05-15 07:34:41.122106+00	morning	Source baseline data added - test shift ended - please this for shift reporting	17e3383f-6805-413e-8254-0bbbeb7f225e
bf1522fb-07a1-4161-9e54-c0bf0629670c	2025-05-15 08:27:55.128336+00	morning	Few customer queries are mentioned in shift report please go through it - :-)	22c67970-fad9-4c11-b652-3d1a08d256f8
795d9782-a43b-4507-9b02-0a6de03f9853	2025-05-16 06:44:15.529154+00	afternoon	testing end shift with local supabase setup	36d49150-8a97-45d2-a96d-116319c07fea
342b08e6-ba2e-4323-bffa-1717f6704159	2025-05-16 06:45:46.609727+00	afternoon	end test supabase localaaa	36d49150-8a97-45d2-a96d-116319c07fea
e737d3d3-d086-42ba-aad4-3a12bb88b893	2025-05-16 06:47:18.31803+00	morning	test	36d49150-8a97-45d2-a96d-116319c07fea
\.


--
-- Data for Name: workorders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.workorders (id, workorder_number, location, workorder_title, prefered_start_time, days_between_today_and_pst, status, source, created_at, workorder_id, updated_at, workorder_category) FROM stdin;
290	WO-00280357	SAT.125 - Chennai	(TR) Beam Line and Ion Source Chamber Primary Pumps Servicing	2025-07-22 12:30:00+00	67	open	imported	2025-05-15 05:00:07.026793+00	a1TTX000000vAx7	\N	\N
277	WO-00279352	SAT.125 - Chennai	(ESBTS) Beam Monitoring Inspection and Servicing	2025-07-09 12:30:00+00	54	open	imported	2025-05-15 05:00:07.026793+00	a1TTX000000sRxh	\N	\N
299	WO-00282853	SAT.125 - Chennai	PPVS/TECH/6months_FP4030	2025-08-15 12:30:00+00	91	open	imported	2025-05-15 05:00:07.026793+00	a1TTX000000yKTh	\N	\N
257	WO-00274055	SAT.125 - Chennai	PSR/HAZEMEYER PS/TECH/36months	2025-05-10 12:30:00+00	-6	open	imported	2025-05-15 05:00:07.026793+00	a1TTX000000l0iv	\N	\N
294	WO-00281442	SAT.125 - Chennai	WTR/TECH/1month	2025-08-01 12:30:00+00	77	open	imported	2025-05-15 05:00:07.026793+00	a1TTX000000wJlR	\N	\N
295	WO-00281441	SAT.125 - Chennai	PSR/TECH/1month	2025-08-01 12:30:00+00	77	open	imported	2025-05-15 05:00:07.026793+00	a1TTX000000wI9S	\N	\N
302	WO-00282850	SAT.125 - Chennai	PPVS/TECH/6months	2025-08-15 12:30:00+00	91	open	imported	2025-05-15 05:00:07.026793+00	a1TTX000000yKOr	\N	\N
259	WO-00274505	SAT.125 - Chennai	SOFTWARE/SW/1month	2025-05-15 12:30:00+00	-1	open	imported	2025-05-15 05:00:07.026793+00	a1TTX000000ljXx	\N	\N
301	WO-00282851	SAT.125 - Chennai	PPVS/PMS HW/6months_1	2025-08-15 12:30:00+00	91	open	imported	2025-05-15 05:00:07.026793+00	a1TTX000000yKQT	\N	\N
263	WO-00275099	SAT.125 - Chennai	PPVS/CBCT/PMS_HW/3months	2025-05-22 12:30:00+00	6	open	imported	2025-05-15 05:00:07.026793+00	a1TTX000000mTqv	\N	\N
265	WO-00276365	SAT.125 - Chennai	C230 Data Monitoring in PRIDEx	2025-06-01 12:30:00+00	16	open	imported	2025-05-15 05:00:07.026793+00	a1TTX000000ngMH	\N	\N
285	WO-00279778	SAT.125 - Chennai	Group3 Hall Probe Calibration	2025-07-15 12:30:00+00	60	open	imported	2025-05-15 05:00:07.026793+00	a1TTX000000uRIT	\N	\N
289	WO-00280358	SAT.125 - Chennai	(TR) Beam Monitoring Inspection and Servicing	2025-07-22 12:30:00+00	67	open	imported	2025-05-15 05:00:07.026793+00	a1TTX000000vAyj	\N	\N
291	WO-00280360	SAT.125 - Chennai	GRF 6 months maintenance operations	2025-07-22 12:30:00+00	67	open	imported	2025-05-15 05:00:07.026793+00	a1TTX000000vAqg	\N	\N
258	WO-00274054	SAT.125 - Chennai	PSR/HAZEMEYER PS/TECH/36months	2025-05-10 12:30:00+00	-6	open	imported	2025-05-15 05:00:07.026793+00	a1TTX000000l0hJ	\N	\N
264	WO-00275098	SAT.125 - Chennai	GRF monthly maintenance operations	2025-05-22 12:30:00+00	6	open	imported	2025-05-15 05:00:07.026793+00	a1TTX000000mTpJ	\N	\N
296	WO-00282856	SAT.125 - Chennai	PPVS/CBCT-LFOV/TECH/6months	2025-08-15 12:30:00+00	91	open	imported	2025-05-15 05:00:07.026793+00	a1TTX000000yKYX	\N	\N
273	WO-00278450	SAT.125 - Chennai	PSR/TECH/1month	2025-07-01 12:30:00+00	46	open	imported	2025-05-15 05:00:07.026793+00	a1TTX000000qhSH	\N	\N
304	WO-00282848	SAT.125 - Chennai	PPVS/CBCT/PMS_HW/3months	2025-08-15 12:30:00+00	91	open	imported	2025-05-15 05:00:07.026793+00	a1TTX000000yKLd	\N	\N
270	WO-00277415	SAT.125 - Chennai	SOFTWARE/SW/1month	2025-06-15 12:30:00+00	30	open	imported	2025-05-15 05:00:07.026793+00	a1TTX000000pZ3m	\N	\N
281	WO-00279782	SAT.125 - Chennai	SOFTWARE/SW/1month	2025-07-15 12:30:00+00	60	open	imported	2025-05-15 05:00:07.026793+00	a1TTX000000uROv	\N	\N
283	WO-00279780	SAT.125 - Chennai	BTS/VAULT/TECH/6months_3	2025-07-15 12:30:00+00	60	open	imported	2025-05-15 05:00:07.026793+00	a1TTX000000uRLh	\N	\N
267	WO-00275911	SAT.125 - Chennai	PSR/TECH/1month	2025-06-01 12:30:00+00	16	open	imported	2025-05-15 05:00:07.026793+00	a1TTX000000naQX	\N	\N
293	WO-00281841	SAT.125 - Chennai	C230 Data Monitoring in PRIDEx	2025-08-01 12:30:00+00	77	open	imported	2025-05-15 05:00:07.026793+00	a1TTX000000wNyl	\N	\N
268	WO-00275912	SAT.125 - Chennai	GLOBAL/TECH/12months	2025-06-01 12:30:00+00	16	open	imported	2025-05-15 05:00:07.026793+00	a1TTX000000nZ34	\N	\N
272	WO-00278861	SAT.125 - Chennai	C230 Data Monitoring in PRIDEx	2025-07-01 12:30:00+00	46	open	imported	2025-05-15 05:00:07.026793+00	a1TTX000000qiY2	\N	\N
260	WO-00274504	SAT.125 - Chennai	PPVS/CBCT/PMS_HW/3months	2025-05-15 12:30:00+00	-1	open	imported	2025-05-15 05:00:07.026793+00	a1TTX000000ljWL	\N	\N
292	WO-00280359	SAT.125 - Chennai	GRF monthly maintenance operations	2025-07-22 12:30:00+00	67	open	imported	2025-05-15 05:00:07.026793+00	a1TTX000000vAVi	\N	\N
266	WO-00275913	SAT.125 - Chennai	WTR/TECH/1month	2025-06-01 12:30:00+00	16	open	imported	2025-05-15 05:00:07.026793+00	a1TTX000000naS9	\N	\N
261	WO-00274503	SAT.125 - Chennai	GRF monthly maintenance operations	2025-05-15 12:30:00+00	-1	open	imported	2025-05-15 05:00:07.026793+00	a1TTX000000ljUj	\N	\N
278	WO-00279351	SAT.125 - Chennai	(ESBTS) Beam Line and Ion Source Chamber Primary Pumps Servicing	2025-07-09 12:30:00+00	54	open	imported	2025-05-15 05:00:07.026793+00	a1TTX000000sPKt	\N	\N
274	WO-00278451	SAT.125 - Chennai	WTR/TECH/1month	2025-07-01 12:30:00+00	46	open	imported	2025-05-15 05:00:07.026793+00	a1TTX000000qgT0	\N	\N
262	WO-00274502	SAT.125 - Chennai	RTCB Fan and Filter Replacement	2025-05-15 12:30:00+00	-1	open	imported	2025-05-15 05:00:07.026793+00	a1TTX000000ljT7	2025-05-16 01:43:55.337+00	\N
279	WO-00279784	SAT.125 - Chennai	SOFTWARE/SW/3months	2025-07-15 12:30:00+00	60	open	imported	2025-05-15 05:00:07.026793+00	a1TTX000000uRS9	\N	\N
298	WO-00282854	SAT.125 - Chennai	PPVS/TECH/6months_FP4343	2025-08-15 12:30:00+00	91	open	imported	2025-05-15 05:00:07.026793+00	a1TTX000000yKVJ	\N	\N
297	WO-00282855	SAT.125 - Chennai	SOFTWARE/SW/1month	2025-08-15 12:30:00+00	91	open	imported	2025-05-15 05:00:07.026793+00	a1TTX000000yKWv	\N	\N
271	WO-00277849	SAT.125 - Chennai	GRF monthly maintenance operations	2025-06-22 12:30:00+00	37	open	imported	2025-05-15 05:00:07.026793+00	a1TTX000000qC57	\N	\N
300	WO-00282852	SAT.125 - Chennai	PPVS/PMS HW/6months_2	2025-08-15 12:30:00+00	91	open	imported	2025-05-15 05:00:07.026793+00	a1TTX000000yKS5	\N	\N
303	WO-00282849	SAT.125 - Chennai	PPVS/GTR/TECH/6months	2025-08-15 12:30:00+00	91	open	imported	2025-05-15 05:00:07.026793+00	a1TTX000000yKNF	\N	\N
376	WO-00289603	SAT.125 - Chennai	GRF monthly maintenance operations	2025-10-22 12:30:00+00	159	open	imported	2025-05-15 05:00:07.026793+00	a1TTX0000017TKr	\N	\N
330	WO-00284229	SAT.125 - Chennai	WTR/TECH/1month	2025-09-01 12:30:00+00	108	open	imported	2025-05-15 05:00:07.026793+00	a1TTX0000010qMD	\N	\N
338	WO-00285592	SAT.125 - Chennai	GTR/TECH/6months_1	2025-09-15 12:30:00+00	122	open	imported	2025-05-15 05:00:07.026793+00	a1TTX0000012sAD	\N	\N
332	WO-00285599	SAT.125 - Chennai	SOFTWARE/SW/1month	2025-09-15 12:30:00+00	122	open	imported	2025-05-15 05:00:07.026793+00	a1TTX0000012sLV	\N	\N
325	WO-00283328	SAT.125 - Chennai	PPVS/CBCT/PMS_HW/3months	2025-08-22 12:30:00+00	98	open	imported	2025-05-15 05:00:07.026793+00	a1TTX000000z3yf	\N	\N
307	WO-00282845	SAT.125 - Chennai	Gantry Beam Line Magnets Inspection	2025-08-15 12:30:00+00	91	open	imported	2025-05-15 05:00:07.026793+00	a1TTX000000yKGn	\N	\N
336	WO-00285594	SAT.125 - Chennai	NOZZLE/DEDICATED/DNSH/TECH/6months	2025-09-15 12:30:00+00	122	open	imported	2025-05-15 05:00:07.026793+00	a1TTX0000012sDR	\N	\N
350	WO-00288192	SAT.125 - Chennai	C230 Small roughing pump servicing	2025-10-01 12:30:00+00	138	open	imported	2025-05-15 05:00:07.026793+00	a1TTX00000155L3	\N	\N
320	WO-00283334	SAT.125 - Chennai	PPVS/TECH/6months_FP4030	2025-08-22 12:30:00+00	98	open	imported	2025-05-15 05:00:07.026793+00	a1TTX000000z458	\N	\N
352	WO-00288190	SAT.125 - Chennai	Vacuum Gauges Servicing	2025-10-01 12:30:00+00	138	open	imported	2025-05-15 05:00:07.026793+00	a1TTX00000155Hp	\N	\N
341	WO-00286322	SAT.125 - Chennai	NOZZLE/DEDICATED/DNSH/TECH/6months	2025-09-22 12:30:00+00	129	open	imported	2025-05-15 05:00:07.026793+00	a1TTX0000013bFN	\N	\N
346	WO-00287354	SAT.125 - Chennai	PPS/Orion/TECH/12months	2025-09-30 12:30:00+00	137	open	imported	2025-05-15 05:00:07.026793+00	a1TTX0000014d8f	\N	\N
339	WO-00285591	SAT.125 - Chennai	GRF monthly maintenance operations	2025-09-15 12:30:00+00	122	open	imported	2025-05-15 05:00:07.026793+00	a1TTX0000012s8b	\N	\N
316	WO-00283337	SAT.125 - Chennai	PPVS/TECH/6months	2025-08-22 12:30:00+00	98	open	imported	2025-05-15 05:00:07.026793+00	a1TTX000000z4BZ	\N	\N
340	WO-00286323	SAT.125 - Chennai	NOZZLE/DEDICATED/TECH/6months	2025-09-22 12:30:00+00	129	open	imported	2025-05-15 05:00:07.026793+00	a1TTX0000013bGz	\N	\N
349	WO-00288193	SAT.125 - Chennai	C230 Large Primary Pump Servicing	2025-10-01 12:30:00+00	138	open	imported	2025-05-15 05:00:07.026793+00	a1TTX00000155Mf	\N	\N
321	WO-00283332	SAT.125 - Chennai	PPVS/PMS HW/6months_1	2025-08-22 12:30:00+00	98	open	imported	2025-05-15 05:00:07.026793+00	a1TTX000000z457	\N	\N
331	WO-00284228	SAT.125 - Chennai	PSR/TECH/1month	2025-09-01 12:30:00+00	108	open	imported	2025-05-15 05:00:07.026793+00	a1TTX0000010qKb	\N	\N
334	WO-00285597	SAT.125 - Chennai	NOZZLE/DEDICATED/TECH/6months	2025-09-15 12:30:00+00	122	open	imported	2025-05-15 05:00:07.026793+00	a1TTX0000012sIH	\N	\N
347	WO-00287353	SAT.125 - Chennai	PPS/Orion/TECH/12months	2025-09-30 12:30:00+00	137	open	imported	2025-05-15 05:00:07.026793+00	a1TTX0000014d73	\N	\N
308	WO-00282844	SAT.125 - Chennai	Rotary Feedthrough Quadrings Lubrication	2025-08-15 12:30:00+00	91	open	imported	2025-05-15 05:00:07.026793+00	a1TTX000000yKFB	\N	\N
354	WO-00288188	SAT.125 - Chennai	LLRF-SSA Cleaning	2025-10-01 12:30:00+00	138	open	imported	2025-05-15 05:00:07.026793+00	a1TTX00000155Eb	\N	\N
311	WO-00283342	SAT.125 - Chennai	PPVS/CBCT-LFOV/TECH/6months	2025-08-22 12:30:00+00	98	open	imported	2025-05-15 05:00:07.026793+00	a1TTX000000z4I1	\N	\N
319	WO-00283333	SAT.125 - Chennai	PPVS/PMS HW/6months_2	2025-08-22 12:30:00+00	98	open	imported	2025-05-15 05:00:07.026793+00	a1TTX000000z46j	\N	\N
383	WO-00286445	SAT.125 - Chennai	Source Regulation issue	2025-05-14 07:22:00+00	-2	open	imported	2025-05-16 01:52:35.465+00	a1TTX0000013t2b2AA	2025-05-16 01:52:35.465+00	manual
323	WO-00283330	SAT.125 - Chennai	PPVS/GTR/TECH/6months	2025-08-22 12:30:00+00	98	open	imported	2025-05-15 05:00:07.026793+00	a1TTX000000z41t	\N	\N
312	WO-00283341	SAT.125 - Chennai	PPVS/TECH/6months_FP4343	2025-08-22 12:30:00+00	98	open	imported	2025-05-15 05:00:07.026793+00	a1TTX000000z4GP	\N	\N
348	WO-00288194	SAT.125 - Chennai	C230 Data Monitoring in PRIDEx	2025-10-01 12:30:00+00	138	open	imported	2025-05-15 05:00:07.026793+00	a1TTX00000155OH	\N	\N
309	WO-00283285	SAT.125 - Chennai	(TR) Beam Monitoring Inspection and Servicing	2025-08-20 12:30:00+00	96	open	imported	2025-05-15 05:00:07.026793+00	a1TTX000000yvxt	\N	\N
328	WO-00283325	SAT.125 - Chennai	Rotary Feedthrough Quadrings Lubrication	2025-08-22 12:30:00+00	98	open	imported	2025-05-15 05:00:07.026793+00	a1TTX000000z3tp	\N	\N
324	WO-00283329	SAT.125 - Chennai	PPVS/FBTR/TECH/6months	2025-08-22 12:30:00+00	98	open	imported	2025-05-15 05:00:07.026793+00	a1TTX000000z40H	\N	\N
306	WO-00282846	SAT.125 - Chennai	GRF monthly maintenance operations	2025-08-15 12:30:00+00	91	open	imported	2025-05-15 05:00:07.026793+00	a1TTX000000yKIP	\N	\N
315	WO-00283338	SAT.125 - Chennai	PPVS/PMS HW/6months_1	2025-08-22 12:30:00+00	98	open	imported	2025-05-15 05:00:07.026793+00	a1TTX000000z4DB	\N	\N
327	WO-00283326	SAT.125 - Chennai	Gantry Beam Line Magnets Inspection	2025-08-22 12:30:00+00	98	open	imported	2025-05-15 05:00:07.026793+00	a1TTX000000z3vR	\N	\N
353	WO-00288189	SAT.125 - Chennai	Deflector V4 Rebuilding	2025-10-01 12:30:00+00	138	open	imported	2025-05-15 05:00:07.026793+00	a1TTX00000155GD	\N	\N
345	WO-00287355	SAT.125 - Chennai	PPS/Orion/TECH/12months	2025-09-30 12:30:00+00	137	open	imported	2025-05-15 05:00:07.026793+00	a1TTX0000014dAH	\N	\N
361	WO-00287610	SAT.125 - Chennai	WTR/TECH/6months_3	2025-10-01 12:30:00+00	138	open	imported	2025-05-15 05:00:07.026793+00	a1TTX0000014pkv	\N	\N
269	WO-00277414	SAT.125 - Chennai	GRF monthly maintenance operations	2025-06-15 12:30:00+00	30	open	imported	2025-05-15 05:00:07.026793+00	a1TTX000000pZLV	\N	\N
305	WO-00282847	SAT.125 - Chennai	GRF 6 months maintenance operations	2025-08-15 12:30:00+00	91	open	imported	2025-05-15 05:00:07.026793+00	a1TTX000000yKK1	\N	\N
359	WO-00287612	SAT.125 - Chennai	WTR/TECH/1month	2025-10-01 12:30:00+00	138	open	imported	2025-05-15 05:00:07.026793+00	a1TTX0000014po9	\N	\N
382	WO-00291124	SAT.125 - Chennai	HPV3/lifetime check/12months	2025-11-05 13:30:00+00	173	open	imported	2025-05-15 05:00:07.026793+00	a1TTX0000018p9d	\N	\N
375	WO-00289125	SAT.125 - Chennai	GRF monthly maintenance operations	2025-10-15 12:30:00+00	152	open	imported	2025-05-15 05:00:07.026793+00	a1TTX0000016rNd	\N	\N
284	WO-00279779	SAT.125 - Chennai	BTS/VAULT/TECH/6months_1	2025-07-15 12:30:00+00	60	open	imported	2025-05-15 05:00:07.026793+00	a1TTX000000uRK5	\N	\N
365	WO-00287605	SAT.125 - Chennai	MCR/TECH/12months	2025-10-01 12:30:00+00	138	open	imported	2025-05-15 05:00:07.026793+00	a1TTX0000014peT	\N	\N
344	WO-00286319	SAT.125 - Chennai	GRF monthly maintenance operations	2025-09-22 12:30:00+00	129	open	imported	2025-05-15 05:00:07.026793+00	a1TTX0000013bAX	\N	\N
379	WO-00290496	SAT.125 - Chennai	WTR/TECH/1month	2025-11-01 12:30:00+00	169	open	imported	2025-05-15 05:00:07.026793+00	a1TTX0000018H4k	\N	\N
358	WO-00288184	SAT.125 - Chennai	C230 Ion Source Movement Inspection and Servicing	2025-10-01 12:30:00+00	138	open	imported	2025-05-15 05:00:07.026793+00	a1TTX0000015589	\N	\N
377	WO-00290896	SAT.125 - Chennai	C230 Data Monitoring in PRIDEx	2025-11-01 12:30:00+00	169	open	imported	2025-05-15 05:00:07.026793+00	a1TTX0000018JTA	\N	\N
356	WO-00288186	SAT.125 - Chennai	Compensation coil injected current check	2025-10-01 12:30:00+00	138	open	imported	2025-05-15 05:00:07.026793+00	a1TTX00000155BN	\N	\N
367	WO-00287603	SAT.125 - Chennai	C230/FPA Anode PS/CYCLO/24 months	2025-10-01 12:30:00+00	138	open	imported	2025-05-15 05:00:07.026793+00	a1TTX0000014ok2	\N	\N
288	WO-00279775	SAT.125 - Chennai	(TR) Beam Line and Ion Source Chamber Primary Pumps Servicing	2025-07-15 12:30:00+00	60	open	imported	2025-05-15 05:00:07.026793+00	a1TTX000000uRDd	\N	\N
351	WO-00288191	SAT.125 - Chennai	C230 water and vacuum leak detection	2025-10-01 12:30:00+00	138	open	imported	2025-05-15 05:00:07.026793+00	a1TTX00000155JR	\N	\N
380	WO-00291126	SAT.125 - Chennai	HPV3/lifetime check/12months	2025-11-05 13:30:00+00	173	open	imported	2025-05-15 05:00:07.026793+00	a1TTX0000018pCr	\N	\N
313	WO-00283339	SAT.125 - Chennai	PPVS/PMS HW/6months_2	2025-08-22 12:30:00+00	98	open	imported	2025-05-15 05:00:07.026793+00	a1TTX000000z4En	\N	\N
374	WO-00289126	SAT.125 - Chennai	SOFTWARE/SW/1month	2025-10-15 12:30:00+00	152	open	imported	2025-05-15 05:00:07.026793+00	a1TTX0000016rPF	\N	\N
370	WO-00288600	SAT.125 - Chennai	BTS/VAULT/TECH/6months_4	2025-10-08 12:30:00+00	145	open	imported	2025-05-15 05:00:07.026793+00	a1TTX0000015m1p	\N	\N
333	WO-00285598	SAT.125 - Chennai	NOZZLE/DEDICATED/TECH/6months	2025-09-15 12:30:00+00	122	open	imported	2025-05-15 05:00:07.026793+00	a1TTX0000012sJt	\N	\N
363	WO-00287608	SAT.125 - Chennai	WTR/TECH/6months_1	2025-10-01 12:30:00+00	138	open	imported	2025-05-15 05:00:07.026793+00	a1TTX0000014phh	\N	\N
381	WO-00291125	SAT.125 - Chennai	HPV3/lifetime check/12months	2025-11-05 13:30:00+00	173	open	imported	2025-05-15 05:00:07.026793+00	a1TTX0000018pBF	\N	\N
314	WO-00283340	SAT.125 - Chennai	PPVS/TECH/6months_FP4030	2025-08-22 12:30:00+00	98	open	imported	2025-05-15 05:00:07.026793+00	a1TTX000000z4DC	\N	\N
310	WO-00283284	SAT.125 - Chennai	(TR) Beam Line and Ion Source Chamber Primary Pumps Servicing	2025-08-20 12:30:00+00	96	open	imported	2025-05-15 05:00:07.026793+00	a1TTX000000yvwH	\N	\N
287	WO-00279776	SAT.125 - Chennai	(TR) Beam Monitoring Inspection and Servicing	2025-07-15 12:30:00+00	60	open	imported	2025-05-15 05:00:07.026793+00	a1TTX000000uRFF	\N	\N
342	WO-00286321	SAT.125 - Chennai	GTR/TECH/6months_2	2025-09-22 12:30:00+00	129	open	imported	2025-05-15 05:00:07.026793+00	a1TTX0000013bDl	\N	\N
317	WO-00283336	SAT.125 - Chennai	PPVS/TECH/12months	2025-08-22 12:30:00+00	98	open	imported	2025-05-15 05:00:07.026793+00	a1TTX000000z49x	\N	\N
378	WO-00290495	SAT.125 - Chennai	PSR/TECH/1month	2025-11-01 12:30:00+00	169	open	imported	2025-05-15 05:00:07.026793+00	a1TTX0000018HZN	\N	\N
369	WO-00288601	SAT.125 - Chennai	BTS/VAULT/TECH/12months	2025-10-08 12:30:00+00	145	open	imported	2025-05-15 05:00:07.026793+00	a1TTX0000015m3R	\N	\N
360	WO-00287611	SAT.125 - Chennai	WTR/TECH/6months_4	2025-10-01 12:30:00+00	138	open	imported	2025-05-15 05:00:07.026793+00	a1TTX0000014pmX	\N	\N
357	WO-00288185	SAT.125 - Chennai	C230 Yoke Lifting System Servicing	2025-10-01 12:30:00+00	138	open	imported	2025-05-15 05:00:07.026793+00	a1TTX000001559l	\N	\N
282	WO-00279781	SAT.125 - Chennai	GRF monthly maintenance operations	2025-07-15 12:30:00+00	60	open	imported	2025-05-15 05:00:07.026793+00	a1TTX000000uRNJ	\N	\N
276	WO-00279353	SAT.125 - Chennai	(ESBTS) ProteusPLUS Small Roughing Pump Replacement	2025-07-09 12:30:00+00	54	open	imported	2025-05-15 05:00:07.026793+00	a1TTX000000sRzJ	\N	\N
280	WO-00279783	SAT.125 - Chennai	SOFTWARE/SW/6months	2025-07-15 12:30:00+00	60	open	imported	2025-05-15 05:00:07.026793+00	a1TTX000000uRQX	\N	\N
364	WO-00287607	SAT.125 - Chennai	PSR/D/TECH/6months	2025-10-01 12:30:00+00	138	open	imported	2025-05-15 05:00:07.026793+00	a1TTX0000014pg5	\N	\N
368	WO-00287606	SAT.125 - Chennai	PSR/TECH/1month	2025-10-01 12:30:00+00	138	open	imported	2025-05-15 05:00:07.026793+00	a1TTX0000014lr0	\N	\N
371	WO-00288644	SAT.125 - Chennai	PPVS/TECH/12months	2025-10-09 12:30:00+00	146	open	imported	2025-05-15 05:00:07.026793+00	a1TTX0000015rKr	\N	\N
373	WO-00289127	SAT.125 - Chennai	SOFTWARE/SW/3months	2025-10-15 12:30:00+00	152	open	imported	2025-05-15 05:00:07.026793+00	a1TTX0000016rQr	\N	\N
362	WO-00287609	SAT.125 - Chennai	WTR/TECH/6months_2	2025-10-01 12:30:00+00	138	open	imported	2025-05-15 05:00:07.026793+00	a1TTX0000014pjJ	\N	\N
326	WO-00283327	SAT.125 - Chennai	GRF monthly maintenance operations	2025-08-22 12:30:00+00	98	open	imported	2025-05-15 05:00:07.026793+00	a1TTX000000z3x3	\N	\N
343	WO-00286320	SAT.125 - Chennai	GTR/TECH/6months_1	2025-09-22 12:30:00+00	129	open	imported	2025-05-15 05:00:07.026793+00	a1TTX0000013bC9	\N	\N
335	WO-00285595	SAT.125 - Chennai	NOZZLE/DEDICATED/DNSH/TECH/6months	2025-09-15 12:30:00+00	122	open	imported	2025-05-15 05:00:07.026793+00	a1TTX0000012sF3	\N	\N
318	WO-00283335	SAT.125 - Chennai	PPVS/TECH/6months_FP4343	2025-08-22 12:30:00+00	98	open	imported	2025-05-15 05:00:07.026793+00	a1TTX000000z48L	\N	\N
337	WO-00285593	SAT.125 - Chennai	GTR/TECH/6months_2	2025-09-15 12:30:00+00	122	open	imported	2025-05-15 05:00:07.026793+00	a1TTX0000012sBp	\N	\N
329	WO-00284634	SAT.125 - Chennai	C230 Data Monitoring in PRIDEx	2025-09-01 12:30:00+00	108	open	imported	2025-05-15 05:00:07.026793+00	a1TTX0000010wGL	\N	\N
256	WO-00273164	SAT.125 - Chennai	C230 Data Monitoring in PRIDEx	2025-05-01 12:30:00+00	-15	open	imported	2025-05-15 05:00:07.026793+00	a1TTX000000jxTl	2025-05-16 01:45:31.107+00	\N
372	WO-00288643	SAT.125 - Chennai	PPVS/TECH/12months	2025-10-09 12:30:00+00	146	open	imported	2025-05-15 05:00:07.026793+00	a1TTX0000015rJF	\N	\N
355	WO-00288187	SAT.125 - Chennai	Radial Probe Inspection and Servicing	2025-10-01 12:30:00+00	138	open	imported	2025-05-15 05:00:07.026793+00	a1TTX00000155Cz	\N	\N
286	WO-00279777	SAT.125 - Chennai	(ESBTS) Beam Stop Assembly Servicing	2025-07-15 12:30:00+00	60	open	imported	2025-05-15 05:00:07.026793+00	a1TTX000000uRGr	\N	\N
275	WO-00279354	SAT.125 - Chennai	Degrader Position Reproducibility Verification and Hardware Inspection	2025-07-09 12:30:00+00	54	open	imported	2025-05-15 05:00:07.026793+00	a1TTX000000sS0v	\N	\N
322	WO-00283331	SAT.125 - Chennai	PPVS/TECH/6months	2025-08-22 12:30:00+00	98	open	imported	2025-05-15 05:00:07.026793+00	a1TTX000000z43V	\N	\N
366	WO-00287604	SAT.125 - Chennai	MCR/TECH/6months	2025-10-01 12:30:00+00	138	open	imported	2025-05-15 05:00:07.026793+00	a1TTX0000014pcr	\N	\N
\.


--
-- Data for Name: messages_2025_05_15; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.messages_2025_05_15 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: messages_2025_05_16; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.messages_2025_05_16 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: messages_2025_05_17; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.messages_2025_05_17 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: messages_2025_05_18; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.messages_2025_05_18 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: messages_2025_05_19; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.messages_2025_05_19 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.schema_migrations (version, inserted_at) FROM stdin;
20211116024918	2025-05-16 05:35:02
20211116045059	2025-05-16 05:35:02
20211116050929	2025-05-16 05:35:02
20211116051442	2025-05-16 05:35:02
20211116212300	2025-05-16 05:35:02
20211116213355	2025-05-16 05:35:02
20211116213934	2025-05-16 05:35:02
20211116214523	2025-05-16 05:35:02
20211122062447	2025-05-16 05:35:02
20211124070109	2025-05-16 05:35:02
20211202204204	2025-05-16 05:35:02
20211202204605	2025-05-16 05:35:02
20211210212804	2025-05-16 05:35:02
20211228014915	2025-05-16 05:35:02
20220107221237	2025-05-16 05:35:02
20220228202821	2025-05-16 05:35:02
20220312004840	2025-05-16 05:35:02
20220603231003	2025-05-16 05:35:02
20220603232444	2025-05-16 05:35:02
20220615214548	2025-05-16 05:35:02
20220712093339	2025-05-16 05:35:02
20220908172859	2025-05-16 05:35:02
20220916233421	2025-05-16 05:35:02
20230119133233	2025-05-16 05:35:02
20230128025114	2025-05-16 05:35:02
20230128025212	2025-05-16 05:35:02
20230227211149	2025-05-16 05:35:02
20230228184745	2025-05-16 05:35:02
20230308225145	2025-05-16 05:35:02
20230328144023	2025-05-16 05:35:02
20231018144023	2025-05-16 05:35:02
20231204144023	2025-05-16 05:35:02
20231204144024	2025-05-16 05:35:02
20231204144025	2025-05-16 05:35:02
20240108234812	2025-05-16 05:35:02
20240109165339	2025-05-16 05:35:02
20240227174441	2025-05-16 05:35:02
20240311171622	2025-05-16 05:35:02
20240321100241	2025-05-16 05:35:03
20240401105812	2025-05-16 05:35:03
20240418121054	2025-05-16 05:35:03
20240523004032	2025-05-16 05:35:03
20240618124746	2025-05-16 05:35:03
20240801235015	2025-05-16 05:35:03
20240805133720	2025-05-16 05:35:03
20240827160934	2025-05-16 05:35:03
20240919163303	2025-05-16 05:35:03
20240919163305	2025-05-16 05:35:03
20241019105805	2025-05-16 05:35:03
20241030150047	2025-05-16 05:35:03
20241108114728	2025-05-16 05:35:03
20241121104152	2025-05-16 05:35:03
20241130184212	2025-05-16 05:35:03
20241220035512	2025-05-16 05:35:03
20241220123912	2025-05-16 05:35:03
20241224161212	2025-05-16 05:35:03
20250107150512	2025-05-16 05:35:03
20250110162412	2025-05-16 05:35:03
20250123174212	2025-05-16 05:35:03
20250128220012	2025-05-16 05:35:03
\.


--
-- Data for Name: subscription; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.subscription (id, subscription_id, entity, filters, claims, created_at) FROM stdin;
\.


--
-- Data for Name: buckets; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.buckets (id, name, owner, created_at, updated_at, public, avif_autodetection, file_size_limit, allowed_mime_types, owner_id) FROM stdin;
attachments	attachments	\N	2025-05-16 06:30:55.07871+00	2025-05-16 06:30:55.07871+00	t	f	\N	\N	\N
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.migrations (id, name, hash, executed_at) FROM stdin;
0	create-migrations-table	e18db593bcde2aca2a408c4d1100f6abba2195df	2025-05-16 05:35:08.391219
1	initialmigration	6ab16121fbaa08bbd11b712d05f358f9b555d777	2025-05-16 05:35:08.407711
2	storage-schema	5c7968fd083fcea04050c1b7f6253c9771b99011	2025-05-16 05:35:08.415542
3	pathtoken-column	2cb1b0004b817b29d5b0a971af16bafeede4b70d	2025-05-16 05:35:08.452843
4	add-migrations-rls	427c5b63fe1c5937495d9c635c263ee7a5905058	2025-05-16 05:35:08.506282
5	add-size-functions	79e081a1455b63666c1294a440f8ad4b1e6a7f84	2025-05-16 05:35:08.514042
6	change-column-name-in-get-size	f93f62afdf6613ee5e7e815b30d02dc990201044	2025-05-16 05:35:08.523601
7	add-rls-to-buckets	e7e7f86adbc51049f341dfe8d30256c1abca17aa	2025-05-16 05:35:08.532402
8	add-public-to-buckets	fd670db39ed65f9d08b01db09d6202503ca2bab3	2025-05-16 05:35:08.540305
9	fix-search-function	3a0af29f42e35a4d101c259ed955b67e1bee6825	2025-05-16 05:35:08.549468
10	search-files-search-function	68dc14822daad0ffac3746a502234f486182ef6e	2025-05-16 05:35:08.57707
11	add-trigger-to-auto-update-updated_at-column	7425bdb14366d1739fa8a18c83100636d74dcaa2	2025-05-16 05:35:08.590066
12	add-automatic-avif-detection-flag	8e92e1266eb29518b6a4c5313ab8f29dd0d08df9	2025-05-16 05:35:08.601606
13	add-bucket-custom-limits	cce962054138135cd9a8c4bcd531598684b25e7d	2025-05-16 05:35:08.608172
14	use-bytes-for-max-size	941c41b346f9802b411f06f30e972ad4744dad27	2025-05-16 05:35:08.723358
15	add-can-insert-object-function	934146bc38ead475f4ef4b555c524ee5d66799e5	2025-05-16 05:35:08.800258
16	add-version	76debf38d3fd07dcfc747ca49096457d95b1221b	2025-05-16 05:35:08.804889
17	drop-owner-foreign-key	f1cbb288f1b7a4c1eb8c38504b80ae2a0153d101	2025-05-16 05:35:08.81123
18	add_owner_id_column_deprecate_owner	e7a511b379110b08e2f214be852c35414749fe66	2025-05-16 05:35:08.816848
19	alter-default-value-objects-id	02e5e22a78626187e00d173dc45f58fa66a4f043	2025-05-16 05:35:08.824662
20	list-objects-with-delimiter	cd694ae708e51ba82bf012bba00caf4f3b6393b7	2025-05-16 05:35:08.831338
21	s3-multipart-uploads	8c804d4a566c40cd1e4cc5b3725a664a9303657f	2025-05-16 05:35:08.843693
22	s3-multipart-uploads-big-ints	9737dc258d2397953c9953d9b86920b8be0cdb73	2025-05-16 05:35:08.878239
23	optimize-search-function	9d7e604cddc4b56a5422dc68c9313f4a1b6f132c	2025-05-16 05:35:08.910292
24	operation-function	8312e37c2bf9e76bbe841aa5fda889206d2bf8aa	2025-05-16 05:35:08.920872
25	custom-metadata	d974c6057c3db1c1f847afa0e291e6165693b990	2025-05-16 05:35:08.927744
\.


--
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata, version, owner_id, user_metadata) FROM stdin;
5ff917ff-c538-41fd-98c4-1676ec44b5d2	attachments	36d49150-8a97-45d2-a96d-116319c07fea/kmci0okarv_1747378457591.jpg	36d49150-8a97-45d2-a96d-116319c07fea	2025-05-16 06:54:19.314845+00	2025-05-16 06:54:19.314845+00	2025-05-16 06:54:19.314845+00	{"eTag": "\\"418f440cc1fe566b4b1a1306132bc0de\\"", "size": 172183, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2025-05-16T06:54:19.018Z", "contentLength": 172183, "httpStatusCode": 200}	1e15cd9d-ca36-4774-9a04-5d0ad6451daf	36d49150-8a97-45d2-a96d-116319c07fea	{}
\.


--
-- Data for Name: s3_multipart_uploads; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.s3_multipart_uploads (id, in_progress_size, upload_signature, bucket_id, key, version, owner_id, created_at, user_metadata) FROM stdin;
\.


--
-- Data for Name: s3_multipart_uploads_parts; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.s3_multipart_uploads_parts (id, upload_id, size, part_number, bucket_id, key, etag, owner_id, version, created_at) FROM stdin;
\.


--
-- Data for Name: hooks; Type: TABLE DATA; Schema: supabase_functions; Owner: supabase_functions_admin
--

COPY supabase_functions.hooks (id, hook_table_id, hook_name, created_at, request_id) FROM stdin;
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: supabase_functions; Owner: supabase_functions_admin
--

COPY supabase_functions.migrations (version, inserted_at) FROM stdin;
initial	2025-05-16 05:34:46.958511+00
20210809183423_update_grants	2025-05-16 05:34:46.958511+00
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: supabase_migrations; Owner: postgres
--

COPY supabase_migrations.schema_migrations (version, statements, name) FROM stdin;
20250516050252	{"SET statement_timeout = 0","SET lock_timeout = 0","SET idle_in_transaction_session_timeout = 0","SET client_encoding = 'UTF8'","SET standard_conforming_strings = on","SELECT pg_catalog.set_config('search_path', '', false)","SET check_function_bodies = false","SET xmloption = content","SET client_min_messages = warning","SET row_security = off","CREATE EXTENSION IF NOT EXISTS \\"pgsodium\\"","COMMENT ON SCHEMA \\"public\\" IS 'standard public schema'","CREATE EXTENSION IF NOT EXISTS \\"pg_graphql\\" WITH SCHEMA \\"graphql\\"","CREATE EXTENSION IF NOT EXISTS \\"pg_stat_statements\\" WITH SCHEMA \\"extensions\\"","CREATE EXTENSION IF NOT EXISTS \\"pgcrypto\\" WITH SCHEMA \\"extensions\\"","CREATE EXTENSION IF NOT EXISTS \\"pgjwt\\" WITH SCHEMA \\"extensions\\"","CREATE EXTENSION IF NOT EXISTS \\"supabase_vault\\" WITH SCHEMA \\"vault\\"","CREATE EXTENSION IF NOT EXISTS \\"uuid-ossp\\" WITH SCHEMA \\"extensions\\"","CREATE TYPE \\"public\\".\\"log_category\\" AS ENUM (\n    'error',\n    'general',\n    'downtime',\n    'workorder',\n    'data-collection',\n    'shift',\n    'data-mc',\n    'data-sc'\n)","ALTER TYPE \\"public\\".\\"log_category\\" OWNER TO \\"postgres\\"","CREATE TYPE \\"public\\".\\"shift_type\\" AS ENUM (\n    'morning',\n    'afternoon',\n    'night'\n)","ALTER TYPE \\"public\\".\\"shift_type\\" OWNER TO \\"postgres\\"","CREATE TYPE \\"public\\".\\"status_type\\" AS ENUM (\n    'open',\n    'in_progress',\n    'closed',\n    'pending'\n)","ALTER TYPE \\"public\\".\\"status_type\\" OWNER TO \\"postgres\\"","CREATE OR REPLACE FUNCTION \\"public\\".\\"check_active_shift\\"() RETURNS \\"trigger\\"\n    LANGUAGE \\"plpgsql\\"\n    AS $$\nBEGIN\n  -- Check if there's already an active shift\n  IF EXISTS (\n    SELECT 1 FROM active_shifts \n    WHERE id != COALESCE(NEW.id, '00000000-0000-0000-0000-000000000000')\n  ) THEN\n    RAISE EXCEPTION 'Another shift is already active';\n  END IF;\n  RETURN NEW;\nEND;\n$$","ALTER FUNCTION \\"public\\".\\"check_active_shift\\"() OWNER TO \\"postgres\\"","CREATE OR REPLACE FUNCTION \\"public\\".\\"check_active_shifts\\"() RETURNS \\"trigger\\"\n    LANGUAGE \\"plpgsql\\"\n    AS $$\r\nBEGIN\r\n    IF EXISTS (\r\n        SELECT 1 FROM public.active_shifts \r\n        WHERE shift_type = NEW.shift_type \r\n        AND id != NEW.id\r\n    ) THEN\r\n        RAISE EXCEPTION 'Another shift is already active for this shift type';\r\n    END IF;\r\n    RETURN NEW;\r\nEND;\r\n$$","ALTER FUNCTION \\"public\\".\\"check_active_shifts\\"() OWNER TO \\"postgres\\"","CREATE OR REPLACE FUNCTION \\"public\\".\\"cleanup_shifts\\"(\\"shift_ids\\" \\"uuid\\"[]) RETURNS \\"void\\"\n    LANGUAGE \\"plpgsql\\"\n    AS $$\r\nBEGIN\r\n    -- Delete the shift engineers first\r\n    DELETE FROM public.shift_engineers\r\n    WHERE shift_id = ANY(shift_ids);\r\n    \r\n    -- Then delete the active shift\r\n    DELETE FROM public.active_shifts\r\n    WHERE id = ANY(shift_ids);\r\nEND;\r\n$$","ALTER FUNCTION \\"public\\".\\"cleanup_shifts\\"(\\"shift_ids\\" \\"uuid\\"[]) OWNER TO \\"postgres\\"","CREATE OR REPLACE FUNCTION \\"public\\".\\"restore_active_shift_on_end_log_delete\\"() RETURNS \\"trigger\\"\n    LANGUAGE \\"plpgsql\\"\n    AS $$\r\nDECLARE\r\n  start_log RECORD;\r\n  end_log RECORD;\r\n  existing_active_shift RECORD;\r\n  salesforce_number TEXT;\r\nBEGIN\r\n  -- Only act if the deleted log is a 'shift ended' log\r\n  IF OLD.category = 'shift' AND OLD.description ILIKE '%shift ended%' THEN\r\n    -- Find the most recent 'shift started' log for the same shift_type before the deleted end log\r\n    SELECT * INTO start_log\r\n    FROM log_entries\r\n    WHERE category = 'shift'\r\n      AND shift_type = OLD.shift_type\r\n      AND created_at < OLD.created_at\r\n      AND description ILIKE '%shift started%'\r\n    ORDER BY created_at DESC\r\n    LIMIT 1;\r\n\r\n    IF start_log IS NOT NULL THEN\r\n      -- Check if there is any other 'shift ended' log after this start log\r\n      SELECT * INTO end_log\r\n      FROM log_entries\r\n      WHERE category = 'shift'\r\n        AND shift_type = OLD.shift_type\r\n        AND created_at > start_log.created_at\r\n        AND description ILIKE '%shift ended%'\r\n      ORDER BY created_at ASC\r\n      LIMIT 1;\r\n\r\n      -- Only restore if there is no other end log after the start log\r\n      IF end_log IS NULL THEN\r\n        -- Check if an active shift already exists\r\n        SELECT * INTO existing_active_shift\r\n        FROM active_shifts\r\n        WHERE shift_type = start_log.shift_type\r\n        ORDER BY started_at DESC\r\n        LIMIT 1;\r\n\r\n        IF existing_active_shift IS NULL THEN\r\n          -- Extract Salesforce number from the description if possible\r\n          salesforce_number := regexp_replace(start_log.description, '.*SF#: ([^\\\\\\\\)]*).*', '\\\\\\\\1');\r\n\r\n          -- Insert the active shift\r\n          INSERT INTO active_shifts (shift_type, started_by, salesforce_number, started_at)\r\n          VALUES (start_log.shift_type, start_log.user_id, salesforce_number, start_log.created_at);\r\n        END IF;\r\n      END IF;\r\n    END IF;\r\n  END IF;\r\n  RETURN OLD;\r\nEND;\r\n$$","ALTER FUNCTION \\"public\\".\\"restore_active_shift_on_end_log_delete\\"() OWNER TO \\"postgres\\"","CREATE OR REPLACE FUNCTION \\"public\\".\\"start_new_shift\\"(\\"p_shift_type\\" \\"public\\".\\"shift_type\\", \\"p_started_by\\" \\"uuid\\", \\"p_salesforce_number\\" \\"text\\", \\"p_engineer_ids\\" \\"uuid\\"[], \\"p_description\\" \\"text\\") RETURNS \\"json\\"\n    LANGUAGE \\"plpgsql\\" SECURITY DEFINER\n    AS $$\nDECLARE\n  v_shift_id uuid;\n  v_result json;\n  v_existing_shifts uuid[];\nBEGIN\n  -- Start transaction\n  BEGIN\n    -- Get IDs of any existing active shifts\n    SELECT array_agg(id)\n    INTO v_existing_shifts\n    FROM active_shifts;\n\n    -- Only perform cleanup if there are existing shifts\n    IF v_existing_shifts IS NOT NULL AND array_length(v_existing_shifts, 1) > 0 THEN\n      -- Delete shift engineers first due to foreign key constraint\n      DELETE FROM shift_engineers\n      WHERE shift_id = ANY(v_existing_shifts);\n\n      -- Then delete the active shifts\n      DELETE FROM active_shifts\n      WHERE id = ANY(v_existing_shifts);\n    END IF;\n\n    -- Create new active shift\n    INSERT INTO active_shifts (\n      shift_type,\n      started_at,\n      started_by,\n      salesforce_number\n    ) VALUES (\n      p_shift_type,\n      now(),\n      p_started_by,\n      p_salesforce_number\n    ) RETURNING id INTO v_shift_id;\n\n    -- Add engineers to shift\n    INSERT INTO shift_engineers (shift_id, engineer_id)\n    SELECT v_shift_id, unnest(p_engineer_ids);\n\n    -- Create log entry\n    INSERT INTO log_entries (\n      shift_type,\n      category,\n      description,\n      user_id\n    ) VALUES (\n      p_shift_type,\n      'shift',\n      p_description,\n      p_started_by\n    );\n\n    -- Get the complete shift data\n    SELECT row_to_json(t)\n    INTO v_result\n    FROM (\n      SELECT a.*, \n        (\n          SELECT json_agg(row_to_json(e))\n          FROM (\n            SELECT eng.*\n            FROM engineers eng\n            JOIN shift_engineers se ON se.engineer_id = eng.id\n            WHERE se.shift_id = a.id\n          ) e\n        ) as engineers\n      FROM active_shifts a\n      WHERE a.id = v_shift_id\n    ) t;\n\n    RETURN v_result;\n  EXCEPTION\n    WHEN OTHERS THEN\n      -- Rollback is automatic\n      RAISE;\n  END;\nEND;\n$$","ALTER FUNCTION \\"public\\".\\"start_new_shift\\"(\\"p_shift_type\\" \\"public\\".\\"shift_type\\", \\"p_started_by\\" \\"uuid\\", \\"p_salesforce_number\\" \\"text\\", \\"p_engineer_ids\\" \\"uuid\\"[], \\"p_description\\" \\"text\\") OWNER TO \\"postgres\\"","CREATE OR REPLACE FUNCTION \\"public\\".\\"upsert_log_suggestion\\"(\\"p_category\\" \\"public\\".\\"log_category\\", \\"p_description\\" \\"text\\") RETURNS \\"void\\"\n    LANGUAGE \\"plpgsql\\" SECURITY DEFINER\n    AS $$\nBEGIN\n  -- Validate inputs\n  IF p_description IS NULL OR trim(p_description) = '' THEN\n    RAISE EXCEPTION 'Description cannot be empty';\n  END IF;\n\n  -- Insert or update the suggestion\n  INSERT INTO log_suggestions (\n    category,\n    description,\n    usage_count,\n    last_used\n  )\n  VALUES (\n    p_category,\n    trim(p_description),\n    1,\n    now()\n  )\n  ON CONFLICT (category, description) \n  DO UPDATE SET \n    usage_count = log_suggestions.usage_count + 1,\n    last_used = now();\n\nEXCEPTION\n  WHEN OTHERS THEN\n    -- Add context to the error\n    RAISE EXCEPTION 'Error in upsert_log_suggestion: %', SQLERRM;\nEND;\n$$","ALTER FUNCTION \\"public\\".\\"upsert_log_suggestion\\"(\\"p_category\\" \\"public\\".\\"log_category\\", \\"p_description\\" \\"text\\") OWNER TO \\"postgres\\"","SET default_tablespace = ''","SET default_table_access_method = \\"heap\\"","CREATE TABLE IF NOT EXISTS \\"public\\".\\"access_requests\\" (\n    \\"id\\" \\"uuid\\" DEFAULT \\"extensions\\".\\"uuid_generate_v4\\"() NOT NULL,\n    \\"name\\" \\"text\\" NOT NULL,\n    \\"email\\" \\"text\\" NOT NULL,\n    \\"role\\" \\"text\\" NOT NULL,\n    \\"message\\" \\"text\\",\n    \\"status\\" \\"text\\" DEFAULT 'pending'::\\"text\\",\n    \\"created_at\\" timestamp with time zone DEFAULT \\"timezone\\"('utc'::\\"text\\", \\"now\\"()) NOT NULL,\n    CONSTRAINT \\"access_requests_status_check\\" CHECK ((\\"status\\" = ANY (ARRAY['pending'::\\"text\\", 'approved'::\\"text\\", 'rejected'::\\"text\\"])))\n)","ALTER TABLE \\"public\\".\\"access_requests\\" OWNER TO \\"postgres\\"","CREATE TABLE IF NOT EXISTS \\"public\\".\\"active_shifts\\" (\n    \\"id\\" \\"uuid\\" DEFAULT \\"extensions\\".\\"uuid_generate_v4\\"() NOT NULL,\n    \\"shift_type\\" \\"public\\".\\"shift_type\\" NOT NULL,\n    \\"started_at\\" timestamp with time zone DEFAULT \\"now\\"() NOT NULL,\n    \\"started_by\\" \\"uuid\\" NOT NULL,\n    \\"salesforce_number\\" \\"text\\" NOT NULL,\n    \\"created_at\\" timestamp with time zone DEFAULT \\"timezone\\"('utc'::\\"text\\", \\"now\\"()) NOT NULL\n)","ALTER TABLE \\"public\\".\\"active_shifts\\" OWNER TO \\"postgres\\"","CREATE TABLE IF NOT EXISTS \\"public\\".\\"attachments\\" (\n    \\"id\\" \\"uuid\\" DEFAULT \\"gen_random_uuid\\"() NOT NULL,\n    \\"created_at\\" timestamp with time zone DEFAULT \\"timezone\\"('utc'::\\"text\\", \\"now\\"()) NOT NULL,\n    \\"user_id\\" \\"uuid\\" NOT NULL,\n    \\"log_entry_id\\" \\"uuid\\" NOT NULL,\n    \\"file_name\\" \\"text\\" NOT NULL,\n    \\"file_type\\" \\"text\\",\n    \\"file_size\\" bigint,\n    \\"file_path\\" \\"text\\" NOT NULL,\n    \\"public_url\\" \\"text\\",\n    CONSTRAINT \\"valid_file_size\\" CHECK ((\\"file_size\\" > 0))\n)","ALTER TABLE \\"public\\".\\"attachments\\" OWNER TO \\"postgres\\"","CREATE TABLE IF NOT EXISTS \\"public\\".\\"engineers\\" (\n    \\"id\\" \\"uuid\\" DEFAULT \\"gen_random_uuid\\"() NOT NULL,\n    \\"name\\" \\"text\\" NOT NULL,\n    \\"user_id\\" \\"uuid\\" NOT NULL,\n    \\"created_at\\" timestamp with time zone DEFAULT \\"now\\"()\n)","ALTER TABLE \\"public\\".\\"engineers\\" OWNER TO \\"postgres\\"","CREATE TABLE IF NOT EXISTS \\"public\\".\\"log_entries\\" (\n    \\"id\\" \\"uuid\\" DEFAULT \\"gen_random_uuid\\"() NOT NULL,\n    \\"created_at\\" timestamp with time zone DEFAULT \\"now\\"(),\n    \\"shift_type\\" \\"public\\".\\"shift_type\\" NOT NULL,\n    \\"category\\" \\"public\\".\\"log_category\\" NOT NULL,\n    \\"description\\" \\"text\\" NOT NULL,\n    \\"user_id\\" \\"uuid\\" NOT NULL,\n    \\"case_number\\" \\"text\\",\n    \\"case_status\\" \\"public\\".\\"status_type\\",\n    \\"workorder_number\\" \\"text\\",\n    \\"workorder_status\\" \\"public\\".\\"status_type\\",\n    \\"mc_setpoint\\" numeric,\n    \\"yoke_temperature\\" numeric,\n    \\"arc_current\\" numeric,\n    \\"filament_current\\" numeric,\n    \\"p1e_x_width\\" numeric,\n    \\"p1e_y_width\\" numeric,\n    \\"p2e_x_width\\" double precision,\n    \\"p2e_y_width\\" double precision,\n    \\"removed_source_number\\" integer,\n    \\"removed_filament_current\\" double precision,\n    \\"removed_arc_current\\" double precision,\n    \\"removed_filament_counter\\" double precision,\n    \\"inserted_source_number\\" integer,\n    \\"inserted_filament_current\\" double precision,\n    \\"inserted_arc_current\\" double precision,\n    \\"inserted_filament_counter\\" double precision,\n    \\"filament_hours\\" double precision,\n    \\"engineers\\" \\"uuid\\"[],\n    \\"dt_start_time\\" timestamp with time zone,\n    \\"dt_end_time\\" timestamp with time zone,\n    \\"dt_duration\\" integer,\n    \\"workorder_title\\" \\"text\\",\n    \\"preferred_start_time\\" timestamp without time zone,\n    \\"shift_id\\" character varying(32),\n    \\"downtime_id\\" character varying\n)","ALTER TABLE \\"public\\".\\"log_entries\\" OWNER TO \\"postgres\\"","COMMENT ON COLUMN \\"public\\".\\"log_entries\\".\\"downtime_id\\" IS 'dt id from svmx'","CREATE TABLE IF NOT EXISTS \\"public\\".\\"log_suggestions\\" (\n    \\"id\\" \\"uuid\\" DEFAULT \\"gen_random_uuid\\"() NOT NULL,\n    \\"category\\" \\"public\\".\\"log_category\\" NOT NULL,\n    \\"description\\" \\"text\\" NOT NULL,\n    \\"usage_count\\" integer DEFAULT 1,\n    \\"created_at\\" timestamp with time zone DEFAULT \\"now\\"(),\n    \\"last_used\\" timestamp with time zone DEFAULT \\"now\\"()\n)","ALTER TABLE \\"public\\".\\"log_suggestions\\" OWNER TO \\"postgres\\"","CREATE TABLE IF NOT EXISTS \\"public\\".\\"profiles\\" (\n    \\"id\\" \\"uuid\\" NOT NULL,\n    \\"is_admin\\" boolean DEFAULT true,\n    \\"created_at\\" timestamp with time zone DEFAULT \\"timezone\\"('utc'::\\"text\\", \\"now\\"()) NOT NULL\n)","ALTER TABLE \\"public\\".\\"profiles\\" OWNER TO \\"postgres\\"","CREATE TABLE IF NOT EXISTS \\"public\\".\\"shift_engineers\\" (\n    \\"shift_id\\" \\"uuid\\" NOT NULL,\n    \\"engineer_id\\" \\"uuid\\" NOT NULL\n)","ALTER TABLE \\"public\\".\\"shift_engineers\\" OWNER TO \\"postgres\\"","CREATE TABLE IF NOT EXISTS \\"public\\".\\"shift_notes\\" (\n    \\"id\\" \\"uuid\\" DEFAULT \\"gen_random_uuid\\"() NOT NULL,\n    \\"created_at\\" timestamp with time zone DEFAULT \\"now\\"(),\n    \\"shift_type\\" \\"public\\".\\"shift_type\\" NOT NULL,\n    \\"note\\" \\"text\\" NOT NULL,\n    \\"user_id\\" \\"uuid\\" NOT NULL\n)","ALTER TABLE \\"public\\".\\"shift_notes\\" OWNER TO \\"postgres\\"","CREATE TABLE IF NOT EXISTS \\"public\\".\\"workorders\\" (\n    \\"id\\" bigint NOT NULL,\n    \\"workorder_number\\" \\"text\\" NOT NULL,\n    \\"location\\" \\"text\\",\n    \\"workorder_title\\" \\"text\\",\n    \\"prefered_start_time\\" timestamp with time zone,\n    \\"days_between_today_and_pst\\" integer,\n    \\"status\\" \\"text\\" DEFAULT 'open'::\\"text\\",\n    \\"source\\" \\"text\\" DEFAULT 'imported'::\\"text\\",\n    \\"created_at\\" timestamp with time zone DEFAULT \\"now\\"(),\n    \\"workorder_id\\" character varying(18),\n    \\"updated_at\\" timestamp with time zone,\n    \\"workorder_category\\" \\"text\\"\n)","ALTER TABLE \\"public\\".\\"workorders\\" OWNER TO \\"postgres\\"","CREATE SEQUENCE IF NOT EXISTS \\"public\\".\\"workorders_id_seq\\"\n    START WITH 1\n    INCREMENT BY 1\n    NO MINVALUE\n    NO MAXVALUE\n    CACHE 1","ALTER TABLE \\"public\\".\\"workorders_id_seq\\" OWNER TO \\"postgres\\"","ALTER SEQUENCE \\"public\\".\\"workorders_id_seq\\" OWNED BY \\"public\\".\\"workorders\\".\\"id\\"","ALTER TABLE ONLY \\"public\\".\\"workorders\\" ALTER COLUMN \\"id\\" SET DEFAULT \\"nextval\\"('\\"public\\".\\"workorders_id_seq\\"'::\\"regclass\\")","ALTER TABLE ONLY \\"public\\".\\"access_requests\\"\n    ADD CONSTRAINT \\"access_requests_pkey\\" PRIMARY KEY (\\"id\\")","ALTER TABLE ONLY \\"public\\".\\"active_shifts\\"\n    ADD CONSTRAINT \\"active_shifts_pkey\\" PRIMARY KEY (\\"id\\")","ALTER TABLE ONLY \\"public\\".\\"attachments\\"\n    ADD CONSTRAINT \\"attachments_pkey\\" PRIMARY KEY (\\"id\\")","ALTER TABLE ONLY \\"public\\".\\"engineers\\"\n    ADD CONSTRAINT \\"engineers_name_key\\" UNIQUE (\\"name\\")","ALTER TABLE ONLY \\"public\\".\\"engineers\\"\n    ADD CONSTRAINT \\"engineers_pkey\\" PRIMARY KEY (\\"id\\")","ALTER TABLE ONLY \\"public\\".\\"log_entries\\"\n    ADD CONSTRAINT \\"log_entries_pkey\\" PRIMARY KEY (\\"id\\")","ALTER TABLE ONLY \\"public\\".\\"log_suggestions\\"\n    ADD CONSTRAINT \\"log_suggestions_pkey\\" PRIMARY KEY (\\"id\\")","ALTER TABLE ONLY \\"public\\".\\"profiles\\"\n    ADD CONSTRAINT \\"profiles_pkey\\" PRIMARY KEY (\\"id\\")","ALTER TABLE ONLY \\"public\\".\\"shift_engineers\\"\n    ADD CONSTRAINT \\"shift_engineers_pkey\\" PRIMARY KEY (\\"shift_id\\", \\"engineer_id\\")","ALTER TABLE ONLY \\"public\\".\\"shift_notes\\"\n    ADD CONSTRAINT \\"shift_notes_pkey\\" PRIMARY KEY (\\"id\\")","ALTER TABLE ONLY \\"public\\".\\"workorders\\"\n    ADD CONSTRAINT \\"workorders_pkey\\" PRIMARY KEY (\\"id\\")","ALTER TABLE ONLY \\"public\\".\\"workorders\\"\n    ADD CONSTRAINT \\"workorders_workorder_id_unique\\" UNIQUE (\\"workorder_id\\")","ALTER TABLE ONLY \\"public\\".\\"workorders\\"\n    ADD CONSTRAINT \\"workorders_workorder_number_key\\" UNIQUE (\\"workorder_number\\")","CREATE INDEX \\"engineers_name_idx\\" ON \\"public\\".\\"engineers\\" USING \\"btree\\" (\\"name\\")","CREATE INDEX \\"idx_active_shifts_started_by\\" ON \\"public\\".\\"active_shifts\\" USING \\"btree\\" (\\"started_by\\")","CREATE INDEX \\"idx_attachments_log_entry_id\\" ON \\"public\\".\\"attachments\\" USING \\"btree\\" (\\"log_entry_id\\")","CREATE INDEX \\"idx_engineers_user_id\\" ON \\"public\\".\\"engineers\\" USING \\"btree\\" (\\"user_id\\")","CREATE INDEX \\"idx_log_entries_shift_id\\" ON \\"public\\".\\"log_entries\\" USING \\"btree\\" (\\"shift_id\\")","CREATE INDEX \\"idx_shift_engineers_engineer_id\\" ON \\"public\\".\\"shift_engineers\\" USING \\"btree\\" (\\"engineer_id\\")","CREATE INDEX \\"idx_shift_engineers_shift_id\\" ON \\"public\\".\\"shift_engineers\\" USING \\"btree\\" (\\"shift_id\\")","CREATE INDEX \\"log_entries_category_idx\\" ON \\"public\\".\\"log_entries\\" USING \\"btree\\" (\\"category\\")","CREATE INDEX \\"log_entries_created_at_idx\\" ON \\"public\\".\\"log_entries\\" USING \\"btree\\" (\\"created_at\\")","CREATE INDEX \\"log_entries_shift_type_idx\\" ON \\"public\\".\\"log_entries\\" USING \\"btree\\" (\\"shift_type\\")","CREATE UNIQUE INDEX \\"log_suggestions_category_description_idx\\" ON \\"public\\".\\"log_suggestions\\" USING \\"btree\\" (\\"category\\", \\"description\\")","CREATE INDEX \\"shift_notes_created_at_idx\\" ON \\"public\\".\\"shift_notes\\" USING \\"btree\\" (\\"created_at\\")","CREATE INDEX \\"shift_notes_shift_type_idx\\" ON \\"public\\".\\"shift_notes\\" USING \\"btree\\" (\\"shift_type\\")","CREATE UNIQUE INDEX \\"unique_active_shift\\" ON \\"public\\".\\"active_shifts\\" USING \\"btree\\" ((1))","CREATE OR REPLACE TRIGGER \\"enforce_single_active_shift\\" BEFORE INSERT OR UPDATE ON \\"public\\".\\"active_shifts\\" FOR EACH ROW EXECUTE FUNCTION \\"public\\".\\"check_active_shifts\\"()","CREATE OR REPLACE TRIGGER \\"trg_restore_active_shift_on_end_log_delete\\" AFTER DELETE ON \\"public\\".\\"log_entries\\" FOR EACH ROW EXECUTE FUNCTION \\"public\\".\\"restore_active_shift_on_end_log_delete\\"()","ALTER TABLE ONLY \\"public\\".\\"active_shifts\\"\n    ADD CONSTRAINT \\"active_shifts_started_by_fkey\\" FOREIGN KEY (\\"started_by\\") REFERENCES \\"auth\\".\\"users\\"(\\"id\\")","ALTER TABLE ONLY \\"public\\".\\"attachments\\"\n    ADD CONSTRAINT \\"attachments_log_entry_id_fkey\\" FOREIGN KEY (\\"log_entry_id\\") REFERENCES \\"public\\".\\"log_entries\\"(\\"id\\")","ALTER TABLE ONLY \\"public\\".\\"attachments\\"\n    ADD CONSTRAINT \\"attachments_user_id_fkey\\" FOREIGN KEY (\\"user_id\\") REFERENCES \\"auth\\".\\"users\\"(\\"id\\")","ALTER TABLE ONLY \\"public\\".\\"engineers\\"\n    ADD CONSTRAINT \\"engineers_user_id_fkey\\" FOREIGN KEY (\\"user_id\\") REFERENCES \\"auth\\".\\"users\\"(\\"id\\")","ALTER TABLE ONLY \\"public\\".\\"shift_engineers\\"\n    ADD CONSTRAINT \\"fk_engineer\\" FOREIGN KEY (\\"engineer_id\\") REFERENCES \\"public\\".\\"engineers\\"(\\"id\\")","ALTER TABLE ONLY \\"public\\".\\"shift_engineers\\"\n    ADD CONSTRAINT \\"fk_shift\\" FOREIGN KEY (\\"shift_id\\") REFERENCES \\"public\\".\\"active_shifts\\"(\\"id\\")","ALTER TABLE ONLY \\"public\\".\\"log_entries\\"\n    ADD CONSTRAINT \\"log_entries_user_id_fkey\\" FOREIGN KEY (\\"user_id\\") REFERENCES \\"auth\\".\\"users\\"(\\"id\\")","ALTER TABLE ONLY \\"public\\".\\"profiles\\"\n    ADD CONSTRAINT \\"profiles_id_fkey\\" FOREIGN KEY (\\"id\\") REFERENCES \\"auth\\".\\"users\\"(\\"id\\")","ALTER TABLE ONLY \\"public\\".\\"shift_engineers\\"\n    ADD CONSTRAINT \\"shift_engineers_engineer_id_fkey\\" FOREIGN KEY (\\"engineer_id\\") REFERENCES \\"public\\".\\"engineers\\"(\\"id\\")","ALTER TABLE ONLY \\"public\\".\\"shift_notes\\"\n    ADD CONSTRAINT \\"shift_notes_user_id_fkey\\" FOREIGN KEY (\\"user_id\\") REFERENCES \\"auth\\".\\"users\\"(\\"id\\")","CREATE POLICY \\"Allow authenticated users to create engineers\\" ON \\"public\\".\\"engineers\\" FOR INSERT TO \\"authenticated\\" WITH CHECK ((\\"auth\\".\\"uid\\"() = \\"user_id\\"))","CREATE POLICY \\"Allow authenticated users to create log entries\\" ON \\"public\\".\\"log_entries\\" FOR INSERT TO \\"authenticated\\" WITH CHECK ((\\"auth\\".\\"uid\\"() = \\"user_id\\"))","CREATE POLICY \\"Allow authenticated users to create shift notes\\" ON \\"public\\".\\"shift_notes\\" FOR INSERT TO \\"authenticated\\" WITH CHECK ((\\"auth\\".\\"uid\\"() = \\"user_id\\"))","CREATE POLICY \\"Allow authenticated users to read all log entries\\" ON \\"public\\".\\"log_entries\\" FOR SELECT TO \\"authenticated\\" USING (true)","CREATE POLICY \\"Allow authenticated users to read all shift notes\\" ON \\"public\\".\\"shift_notes\\" FOR SELECT TO \\"authenticated\\" USING (true)","CREATE POLICY \\"Allow authenticated users to read engineers\\" ON \\"public\\".\\"engineers\\" FOR SELECT TO \\"authenticated\\" USING (true)","CREATE POLICY \\"Allow authenticated users to read log suggestions\\" ON \\"public\\".\\"log_suggestions\\" FOR SELECT TO \\"authenticated\\" USING (true)","CREATE POLICY \\"Allow authenticated users to read shift engineers\\" ON \\"public\\".\\"shift_engineers\\" FOR SELECT TO \\"authenticated\\" USING (true)","CREATE POLICY \\"Allow read access\\" ON \\"public\\".\\"attachments\\" FOR SELECT USING (true)","CREATE POLICY \\"Allow read access\\" ON \\"public\\".\\"log_entries\\" FOR SELECT USING (true)","CREATE POLICY \\"Allow read access to attachments\\" ON \\"public\\".\\"attachments\\" FOR SELECT USING (true)","CREATE POLICY \\"Allow read access to log_entries\\" ON \\"public\\".\\"log_entries\\" FOR SELECT USING (true)","CREATE POLICY \\"Allow read for all\\" ON \\"public\\".\\"workorders\\" FOR SELECT USING (true)","CREATE POLICY \\"Allow users to delete their own log entries\\" ON \\"public\\".\\"log_entries\\" FOR DELETE TO \\"authenticated\\" USING ((\\"auth\\".\\"uid\\"() = \\"user_id\\"))","CREATE POLICY \\"Allow users to delete their own shift notes\\" ON \\"public\\".\\"shift_notes\\" FOR DELETE TO \\"authenticated\\" USING ((\\"auth\\".\\"uid\\"() = \\"user_id\\"))","CREATE POLICY \\"Allow users to update their own log entries\\" ON \\"public\\".\\"log_entries\\" FOR UPDATE TO \\"authenticated\\" USING ((\\"auth\\".\\"uid\\"() = \\"user_id\\")) WITH CHECK ((\\"auth\\".\\"uid\\"() = \\"user_id\\"))","CREATE POLICY \\"Allow users to update their own shift notes\\" ON \\"public\\".\\"shift_notes\\" FOR UPDATE TO \\"authenticated\\" USING ((\\"auth\\".\\"uid\\"() = \\"user_id\\")) WITH CHECK ((\\"auth\\".\\"uid\\"() = \\"user_id\\"))","CREATE POLICY \\"Authenticated users can create engineers\\" ON \\"public\\".\\"engineers\\" FOR INSERT TO \\"authenticated\\" WITH CHECK (true)","CREATE POLICY \\"Users can delete shift engineers\\" ON \\"public\\".\\"shift_engineers\\" FOR DELETE TO \\"authenticated\\" USING ((EXISTS ( SELECT 1\n   FROM \\"public\\".\\"active_shifts\\"\n  WHERE ((\\"active_shifts\\".\\"id\\" = \\"shift_engineers\\".\\"shift_id\\") AND (\\"active_shifts\\".\\"started_by\\" = \\"auth\\".\\"uid\\"())))))","CREATE POLICY \\"Users can delete their own attachments\\" ON \\"public\\".\\"attachments\\" FOR DELETE TO \\"authenticated\\" USING ((\\"auth\\".\\"uid\\"() = \\"user_id\\"))","CREATE POLICY \\"Users can delete their own shifts\\" ON \\"public\\".\\"active_shifts\\" FOR DELETE TO \\"authenticated\\" USING ((\\"auth\\".\\"uid\\"() = \\"started_by\\"))","CREATE POLICY \\"Users can insert shift engineers\\" ON \\"public\\".\\"shift_engineers\\" FOR INSERT TO \\"authenticated\\" WITH CHECK ((EXISTS ( SELECT 1\n   FROM \\"public\\".\\"active_shifts\\"\n  WHERE ((\\"active_shifts\\".\\"id\\" = \\"shift_engineers\\".\\"shift_id\\") AND (\\"active_shifts\\".\\"started_by\\" = \\"auth\\".\\"uid\\"())))))","CREATE POLICY \\"Users can insert shifts\\" ON \\"public\\".\\"active_shifts\\" FOR INSERT TO \\"authenticated\\" WITH CHECK ((\\"auth\\".\\"uid\\"() = \\"started_by\\"))","CREATE POLICY \\"Users can insert their own attachments\\" ON \\"public\\".\\"attachments\\" FOR INSERT TO \\"authenticated\\" WITH CHECK ((\\"auth\\".\\"uid\\"() = \\"user_id\\"))","CREATE POLICY \\"Users can insert their own profile\\" ON \\"public\\".\\"profiles\\" FOR INSERT WITH CHECK ((\\"auth\\".\\"uid\\"() = \\"id\\"))","CREATE POLICY \\"Users can update their own shifts\\" ON \\"public\\".\\"active_shifts\\" FOR UPDATE TO \\"authenticated\\" USING ((\\"auth\\".\\"uid\\"() = \\"started_by\\")) WITH CHECK ((\\"auth\\".\\"uid\\"() = \\"started_by\\"))","CREATE POLICY \\"Users can view active shifts\\" ON \\"public\\".\\"active_shifts\\" FOR SELECT TO \\"authenticated\\" USING (true)","CREATE POLICY \\"Users can view all engineers\\" ON \\"public\\".\\"engineers\\" FOR SELECT TO \\"authenticated\\" USING (true)","CREATE POLICY \\"Users can view all shift engineers\\" ON \\"public\\".\\"shift_engineers\\" FOR SELECT TO \\"authenticated\\" USING (true)","CREATE POLICY \\"Users can view their own attachments\\" ON \\"public\\".\\"attachments\\" FOR SELECT TO \\"authenticated\\" USING ((\\"auth\\".\\"uid\\"() = \\"user_id\\"))","CREATE POLICY \\"Users can view their own profile\\" ON \\"public\\".\\"profiles\\" FOR SELECT USING ((\\"auth\\".\\"uid\\"() = \\"id\\"))","ALTER TABLE \\"public\\".\\"active_shifts\\" ENABLE ROW LEVEL SECURITY","ALTER TABLE \\"public\\".\\"attachments\\" ENABLE ROW LEVEL SECURITY","ALTER TABLE \\"public\\".\\"engineers\\" ENABLE ROW LEVEL SECURITY","ALTER TABLE \\"public\\".\\"log_entries\\" ENABLE ROW LEVEL SECURITY","ALTER TABLE \\"public\\".\\"log_suggestions\\" ENABLE ROW LEVEL SECURITY","ALTER TABLE \\"public\\".\\"profiles\\" ENABLE ROW LEVEL SECURITY","ALTER TABLE \\"public\\".\\"shift_engineers\\" ENABLE ROW LEVEL SECURITY","ALTER TABLE \\"public\\".\\"shift_notes\\" ENABLE ROW LEVEL SECURITY","ALTER PUBLICATION \\"supabase_realtime\\" OWNER TO \\"postgres\\"","GRANT USAGE ON SCHEMA \\"public\\" TO \\"postgres\\"","GRANT USAGE ON SCHEMA \\"public\\" TO \\"anon\\"","GRANT USAGE ON SCHEMA \\"public\\" TO \\"authenticated\\"","GRANT USAGE ON SCHEMA \\"public\\" TO \\"service_role\\"","GRANT ALL ON FUNCTION \\"public\\".\\"check_active_shift\\"() TO \\"anon\\"","GRANT ALL ON FUNCTION \\"public\\".\\"check_active_shift\\"() TO \\"authenticated\\"","GRANT ALL ON FUNCTION \\"public\\".\\"check_active_shift\\"() TO \\"service_role\\"","GRANT ALL ON FUNCTION \\"public\\".\\"check_active_shifts\\"() TO \\"anon\\"","GRANT ALL ON FUNCTION \\"public\\".\\"check_active_shifts\\"() TO \\"authenticated\\"","GRANT ALL ON FUNCTION \\"public\\".\\"check_active_shifts\\"() TO \\"service_role\\"","GRANT ALL ON FUNCTION \\"public\\".\\"cleanup_shifts\\"(\\"shift_ids\\" \\"uuid\\"[]) TO \\"anon\\"","GRANT ALL ON FUNCTION \\"public\\".\\"cleanup_shifts\\"(\\"shift_ids\\" \\"uuid\\"[]) TO \\"authenticated\\"","GRANT ALL ON FUNCTION \\"public\\".\\"cleanup_shifts\\"(\\"shift_ids\\" \\"uuid\\"[]) TO \\"service_role\\"","GRANT ALL ON FUNCTION \\"public\\".\\"restore_active_shift_on_end_log_delete\\"() TO \\"anon\\"","GRANT ALL ON FUNCTION \\"public\\".\\"restore_active_shift_on_end_log_delete\\"() TO \\"authenticated\\"","GRANT ALL ON FUNCTION \\"public\\".\\"restore_active_shift_on_end_log_delete\\"() TO \\"service_role\\"","GRANT ALL ON FUNCTION \\"public\\".\\"start_new_shift\\"(\\"p_shift_type\\" \\"public\\".\\"shift_type\\", \\"p_started_by\\" \\"uuid\\", \\"p_salesforce_number\\" \\"text\\", \\"p_engineer_ids\\" \\"uuid\\"[], \\"p_description\\" \\"text\\") TO \\"anon\\"","GRANT ALL ON FUNCTION \\"public\\".\\"start_new_shift\\"(\\"p_shift_type\\" \\"public\\".\\"shift_type\\", \\"p_started_by\\" \\"uuid\\", \\"p_salesforce_number\\" \\"text\\", \\"p_engineer_ids\\" \\"uuid\\"[], \\"p_description\\" \\"text\\") TO \\"authenticated\\"","GRANT ALL ON FUNCTION \\"public\\".\\"start_new_shift\\"(\\"p_shift_type\\" \\"public\\".\\"shift_type\\", \\"p_started_by\\" \\"uuid\\", \\"p_salesforce_number\\" \\"text\\", \\"p_engineer_ids\\" \\"uuid\\"[], \\"p_description\\" \\"text\\") TO \\"service_role\\"","GRANT ALL ON FUNCTION \\"public\\".\\"upsert_log_suggestion\\"(\\"p_category\\" \\"public\\".\\"log_category\\", \\"p_description\\" \\"text\\") TO \\"anon\\"","GRANT ALL ON FUNCTION \\"public\\".\\"upsert_log_suggestion\\"(\\"p_category\\" \\"public\\".\\"log_category\\", \\"p_description\\" \\"text\\") TO \\"authenticated\\"","GRANT ALL ON FUNCTION \\"public\\".\\"upsert_log_suggestion\\"(\\"p_category\\" \\"public\\".\\"log_category\\", \\"p_description\\" \\"text\\") TO \\"service_role\\"","GRANT ALL ON TABLE \\"public\\".\\"access_requests\\" TO \\"anon\\"","GRANT ALL ON TABLE \\"public\\".\\"access_requests\\" TO \\"authenticated\\"","GRANT ALL ON TABLE \\"public\\".\\"access_requests\\" TO \\"service_role\\"","GRANT ALL ON TABLE \\"public\\".\\"active_shifts\\" TO \\"anon\\"","GRANT ALL ON TABLE \\"public\\".\\"active_shifts\\" TO \\"authenticated\\"","GRANT ALL ON TABLE \\"public\\".\\"active_shifts\\" TO \\"service_role\\"","GRANT ALL ON TABLE \\"public\\".\\"attachments\\" TO \\"anon\\"","GRANT ALL ON TABLE \\"public\\".\\"attachments\\" TO \\"authenticated\\"","GRANT ALL ON TABLE \\"public\\".\\"attachments\\" TO \\"service_role\\"","GRANT ALL ON TABLE \\"public\\".\\"engineers\\" TO \\"anon\\"","GRANT ALL ON TABLE \\"public\\".\\"engineers\\" TO \\"authenticated\\"","GRANT ALL ON TABLE \\"public\\".\\"engineers\\" TO \\"service_role\\"","GRANT ALL ON TABLE \\"public\\".\\"log_entries\\" TO \\"anon\\"","GRANT ALL ON TABLE \\"public\\".\\"log_entries\\" TO \\"authenticated\\"","GRANT ALL ON TABLE \\"public\\".\\"log_entries\\" TO \\"service_role\\"","GRANT ALL ON TABLE \\"public\\".\\"log_suggestions\\" TO \\"anon\\"","GRANT ALL ON TABLE \\"public\\".\\"log_suggestions\\" TO \\"authenticated\\"","GRANT ALL ON TABLE \\"public\\".\\"log_suggestions\\" TO \\"service_role\\"","GRANT ALL ON TABLE \\"public\\".\\"profiles\\" TO \\"anon\\"","GRANT ALL ON TABLE \\"public\\".\\"profiles\\" TO \\"authenticated\\"","GRANT ALL ON TABLE \\"public\\".\\"profiles\\" TO \\"service_role\\"","GRANT ALL ON TABLE \\"public\\".\\"shift_engineers\\" TO \\"anon\\"","GRANT ALL ON TABLE \\"public\\".\\"shift_engineers\\" TO \\"authenticated\\"","GRANT ALL ON TABLE \\"public\\".\\"shift_engineers\\" TO \\"service_role\\"","GRANT ALL ON TABLE \\"public\\".\\"shift_notes\\" TO \\"anon\\"","GRANT ALL ON TABLE \\"public\\".\\"shift_notes\\" TO \\"authenticated\\"","GRANT ALL ON TABLE \\"public\\".\\"shift_notes\\" TO \\"service_role\\"","GRANT ALL ON TABLE \\"public\\".\\"workorders\\" TO \\"anon\\"","GRANT ALL ON TABLE \\"public\\".\\"workorders\\" TO \\"authenticated\\"","GRANT ALL ON TABLE \\"public\\".\\"workorders\\" TO \\"service_role\\"","GRANT ALL ON SEQUENCE \\"public\\".\\"workorders_id_seq\\" TO \\"anon\\"","GRANT ALL ON SEQUENCE \\"public\\".\\"workorders_id_seq\\" TO \\"authenticated\\"","GRANT ALL ON SEQUENCE \\"public\\".\\"workorders_id_seq\\" TO \\"service_role\\"","ALTER DEFAULT PRIVILEGES FOR ROLE \\"postgres\\" IN SCHEMA \\"public\\" GRANT ALL ON SEQUENCES  TO \\"postgres\\"","ALTER DEFAULT PRIVILEGES FOR ROLE \\"postgres\\" IN SCHEMA \\"public\\" GRANT ALL ON SEQUENCES  TO \\"anon\\"","ALTER DEFAULT PRIVILEGES FOR ROLE \\"postgres\\" IN SCHEMA \\"public\\" GRANT ALL ON SEQUENCES  TO \\"authenticated\\"","ALTER DEFAULT PRIVILEGES FOR ROLE \\"postgres\\" IN SCHEMA \\"public\\" GRANT ALL ON SEQUENCES  TO \\"service_role\\"","ALTER DEFAULT PRIVILEGES FOR ROLE \\"postgres\\" IN SCHEMA \\"public\\" GRANT ALL ON FUNCTIONS  TO \\"postgres\\"","ALTER DEFAULT PRIVILEGES FOR ROLE \\"postgres\\" IN SCHEMA \\"public\\" GRANT ALL ON FUNCTIONS  TO \\"anon\\"","ALTER DEFAULT PRIVILEGES FOR ROLE \\"postgres\\" IN SCHEMA \\"public\\" GRANT ALL ON FUNCTIONS  TO \\"authenticated\\"","ALTER DEFAULT PRIVILEGES FOR ROLE \\"postgres\\" IN SCHEMA \\"public\\" GRANT ALL ON FUNCTIONS  TO \\"service_role\\"","ALTER DEFAULT PRIVILEGES FOR ROLE \\"postgres\\" IN SCHEMA \\"public\\" GRANT ALL ON TABLES  TO \\"postgres\\"","ALTER DEFAULT PRIVILEGES FOR ROLE \\"postgres\\" IN SCHEMA \\"public\\" GRANT ALL ON TABLES  TO \\"anon\\"","ALTER DEFAULT PRIVILEGES FOR ROLE \\"postgres\\" IN SCHEMA \\"public\\" GRANT ALL ON TABLES  TO \\"authenticated\\"","ALTER DEFAULT PRIVILEGES FOR ROLE \\"postgres\\" IN SCHEMA \\"public\\" GRANT ALL ON TABLES  TO \\"service_role\\"","RESET ALL"}	remote_schema
20250516051154	{"grant delete on table \\"storage\\".\\"s3_multipart_uploads\\" to \\"postgres\\"","grant insert on table \\"storage\\".\\"s3_multipart_uploads\\" to \\"postgres\\"","grant references on table \\"storage\\".\\"s3_multipart_uploads\\" to \\"postgres\\"","grant select on table \\"storage\\".\\"s3_multipart_uploads\\" to \\"postgres\\"","grant trigger on table \\"storage\\".\\"s3_multipart_uploads\\" to \\"postgres\\"","grant truncate on table \\"storage\\".\\"s3_multipart_uploads\\" to \\"postgres\\"","grant update on table \\"storage\\".\\"s3_multipart_uploads\\" to \\"postgres\\"","grant delete on table \\"storage\\".\\"s3_multipart_uploads_parts\\" to \\"postgres\\"","grant insert on table \\"storage\\".\\"s3_multipart_uploads_parts\\" to \\"postgres\\"","grant references on table \\"storage\\".\\"s3_multipart_uploads_parts\\" to \\"postgres\\"","grant select on table \\"storage\\".\\"s3_multipart_uploads_parts\\" to \\"postgres\\"","grant trigger on table \\"storage\\".\\"s3_multipart_uploads_parts\\" to \\"postgres\\"","grant truncate on table \\"storage\\".\\"s3_multipart_uploads_parts\\" to \\"postgres\\"","grant update on table \\"storage\\".\\"s3_multipart_uploads_parts\\" to \\"postgres\\"","create policy \\"Allow authenticated deletes\\"\non \\"storage\\".\\"objects\\"\nas permissive\nfor delete\nto authenticated\nusing (((bucket_id = 'attachments'::text) AND (auth.role() = 'authenticated'::text)))","create policy \\"Allow authenticated downloads\\"\non \\"storage\\".\\"objects\\"\nas permissive\nfor select\nto authenticated\nusing (((bucket_id = 'attachments'::text) AND (auth.role() = 'authenticated'::text)))","create policy \\"Allow authenticated uploads\\"\non \\"storage\\".\\"objects\\"\nas permissive\nfor insert\nto authenticated\nwith check (((bucket_id = 'attachments'::text) AND (auth.role() = 'authenticated'::text)))"}	remote_schema
\.


--
-- Data for Name: secrets; Type: TABLE DATA; Schema: vault; Owner: supabase_admin
--

COPY vault.secrets (id, name, description, secret, key_id, nonce, created_at, updated_at) FROM stdin;
\.


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: supabase_auth_admin
--

SELECT pg_catalog.setval('auth.refresh_tokens_id_seq', 602, true);


--
-- Name: key_key_id_seq; Type: SEQUENCE SET; Schema: pgsodium; Owner: supabase_admin
--

SELECT pg_catalog.setval('pgsodium.key_key_id_seq', 1, false);


--
-- Name: workorders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.workorders_id_seq', 383, true);


--
-- Name: subscription_id_seq; Type: SEQUENCE SET; Schema: realtime; Owner: supabase_admin
--

SELECT pg_catalog.setval('realtime.subscription_id_seq', 1, false);


--
-- Name: hooks_id_seq; Type: SEQUENCE SET; Schema: supabase_functions; Owner: supabase_functions_admin
--

SELECT pg_catalog.setval('supabase_functions.hooks_id_seq', 1, false);


--
-- Name: extensions extensions_pkey; Type: CONSTRAINT; Schema: _realtime; Owner: supabase_admin
--

ALTER TABLE ONLY _realtime.extensions
    ADD CONSTRAINT extensions_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: _realtime; Owner: supabase_admin
--

ALTER TABLE ONLY _realtime.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: tenants tenants_pkey; Type: CONSTRAINT; Schema: _realtime; Owner: supabase_admin
--

ALTER TABLE ONLY _realtime.tenants
    ADD CONSTRAINT tenants_pkey PRIMARY KEY (id);


--
-- Name: mfa_amr_claims amr_id_pk; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT amr_id_pk PRIMARY KEY (id);


--
-- Name: audit_log_entries audit_log_entries_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.audit_log_entries
    ADD CONSTRAINT audit_log_entries_pkey PRIMARY KEY (id);


--
-- Name: flow_state flow_state_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.flow_state
    ADD CONSTRAINT flow_state_pkey PRIMARY KEY (id);


--
-- Name: identities identities_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (id);


--
-- Name: identities identities_provider_id_provider_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_provider_id_provider_unique UNIQUE (provider_id, provider);


--
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_authentication_method_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_authentication_method_pkey UNIQUE (session_id, authentication_method);


--
-- Name: mfa_challenges mfa_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_pkey PRIMARY KEY (id);


--
-- Name: mfa_factors mfa_factors_last_challenged_at_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_last_challenged_at_key UNIQUE (last_challenged_at);


--
-- Name: mfa_factors mfa_factors_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_pkey PRIMARY KEY (id);


--
-- Name: one_time_tokens one_time_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_token_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_token_unique UNIQUE (token);


--
-- Name: saml_providers saml_providers_entity_id_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_entity_id_key UNIQUE (entity_id);


--
-- Name: saml_providers saml_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_pkey PRIMARY KEY (id);


--
-- Name: saml_relay_states saml_relay_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: sso_domains sso_domains_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_pkey PRIMARY KEY (id);


--
-- Name: sso_providers sso_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_providers
    ADD CONSTRAINT sso_providers_pkey PRIMARY KEY (id);


--
-- Name: users users_phone_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_phone_key UNIQUE (phone);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: access_requests access_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.access_requests
    ADD CONSTRAINT access_requests_pkey PRIMARY KEY (id);


--
-- Name: active_shifts active_shifts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.active_shifts
    ADD CONSTRAINT active_shifts_pkey PRIMARY KEY (id);


--
-- Name: attachments attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attachments
    ADD CONSTRAINT attachments_pkey PRIMARY KEY (id);


--
-- Name: engineers engineers_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.engineers
    ADD CONSTRAINT engineers_name_key UNIQUE (name);


--
-- Name: engineers engineers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.engineers
    ADD CONSTRAINT engineers_pkey PRIMARY KEY (id);


--
-- Name: log_entries log_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.log_entries
    ADD CONSTRAINT log_entries_pkey PRIMARY KEY (id);


--
-- Name: log_suggestions log_suggestions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.log_suggestions
    ADD CONSTRAINT log_suggestions_pkey PRIMARY KEY (id);


--
-- Name: profiles profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_pkey PRIMARY KEY (id);


--
-- Name: shift_engineers shift_engineers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shift_engineers
    ADD CONSTRAINT shift_engineers_pkey PRIMARY KEY (shift_id, engineer_id);


--
-- Name: shift_notes shift_notes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shift_notes
    ADD CONSTRAINT shift_notes_pkey PRIMARY KEY (id);


--
-- Name: workorders workorders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workorders
    ADD CONSTRAINT workorders_pkey PRIMARY KEY (id);


--
-- Name: workorders workorders_workorder_id_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workorders
    ADD CONSTRAINT workorders_workorder_id_unique UNIQUE (workorder_id);


--
-- Name: workorders workorders_workorder_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workorders
    ADD CONSTRAINT workorders_workorder_number_key UNIQUE (workorder_number);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE ONLY realtime.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2025_05_15 messages_2025_05_15_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2025_05_15
    ADD CONSTRAINT messages_2025_05_15_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2025_05_16 messages_2025_05_16_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2025_05_16
    ADD CONSTRAINT messages_2025_05_16_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2025_05_17 messages_2025_05_17_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2025_05_17
    ADD CONSTRAINT messages_2025_05_17_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2025_05_18 messages_2025_05_18_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2025_05_18
    ADD CONSTRAINT messages_2025_05_18_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2025_05_19 messages_2025_05_19_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2025_05_19
    ADD CONSTRAINT messages_2025_05_19_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: subscription pk_subscription; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.subscription
    ADD CONSTRAINT pk_subscription PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: buckets buckets_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets
    ADD CONSTRAINT buckets_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_name_key; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_name_key UNIQUE (name);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: objects objects_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT objects_pkey PRIMARY KEY (id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_pkey PRIMARY KEY (id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_pkey PRIMARY KEY (id);


--
-- Name: hooks hooks_pkey; Type: CONSTRAINT; Schema: supabase_functions; Owner: supabase_functions_admin
--

ALTER TABLE ONLY supabase_functions.hooks
    ADD CONSTRAINT hooks_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: supabase_functions; Owner: supabase_functions_admin
--

ALTER TABLE ONLY supabase_functions.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (version);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: supabase_migrations; Owner: postgres
--

ALTER TABLE ONLY supabase_migrations.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: extensions_tenant_external_id_index; Type: INDEX; Schema: _realtime; Owner: supabase_admin
--

CREATE INDEX extensions_tenant_external_id_index ON _realtime.extensions USING btree (tenant_external_id);


--
-- Name: extensions_tenant_external_id_type_index; Type: INDEX; Schema: _realtime; Owner: supabase_admin
--

CREATE UNIQUE INDEX extensions_tenant_external_id_type_index ON _realtime.extensions USING btree (tenant_external_id, type);


--
-- Name: tenants_external_id_index; Type: INDEX; Schema: _realtime; Owner: supabase_admin
--

CREATE UNIQUE INDEX tenants_external_id_index ON _realtime.tenants USING btree (external_id);


--
-- Name: audit_logs_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX audit_logs_instance_id_idx ON auth.audit_log_entries USING btree (instance_id);


--
-- Name: confirmation_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX confirmation_token_idx ON auth.users USING btree (confirmation_token) WHERE ((confirmation_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_current_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_current_idx ON auth.users USING btree (email_change_token_current) WHERE ((email_change_token_current)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_new_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_new_idx ON auth.users USING btree (email_change_token_new) WHERE ((email_change_token_new)::text !~ '^[0-9 ]*$'::text);


--
-- Name: factor_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX factor_id_created_at_idx ON auth.mfa_factors USING btree (user_id, created_at);


--
-- Name: flow_state_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX flow_state_created_at_idx ON auth.flow_state USING btree (created_at DESC);


--
-- Name: identities_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_email_idx ON auth.identities USING btree (email text_pattern_ops);


--
-- Name: INDEX identities_email_idx; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON INDEX auth.identities_email_idx IS 'Auth: Ensures indexed queries on the email column';


--
-- Name: identities_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_user_id_idx ON auth.identities USING btree (user_id);


--
-- Name: idx_auth_code; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_auth_code ON auth.flow_state USING btree (auth_code);


--
-- Name: idx_user_id_auth_method; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_user_id_auth_method ON auth.flow_state USING btree (user_id, authentication_method);


--
-- Name: mfa_challenge_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX mfa_challenge_created_at_idx ON auth.mfa_challenges USING btree (created_at DESC);


--
-- Name: mfa_factors_user_friendly_name_unique; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX mfa_factors_user_friendly_name_unique ON auth.mfa_factors USING btree (friendly_name, user_id) WHERE (TRIM(BOTH FROM friendly_name) <> ''::text);


--
-- Name: mfa_factors_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX mfa_factors_user_id_idx ON auth.mfa_factors USING btree (user_id);


--
-- Name: one_time_tokens_relates_to_hash_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX one_time_tokens_relates_to_hash_idx ON auth.one_time_tokens USING hash (relates_to);


--
-- Name: one_time_tokens_token_hash_hash_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX one_time_tokens_token_hash_hash_idx ON auth.one_time_tokens USING hash (token_hash);


--
-- Name: one_time_tokens_user_id_token_type_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX one_time_tokens_user_id_token_type_key ON auth.one_time_tokens USING btree (user_id, token_type);


--
-- Name: reauthentication_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX reauthentication_token_idx ON auth.users USING btree (reauthentication_token) WHERE ((reauthentication_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: recovery_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX recovery_token_idx ON auth.users USING btree (recovery_token) WHERE ((recovery_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: refresh_tokens_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_idx ON auth.refresh_tokens USING btree (instance_id);


--
-- Name: refresh_tokens_instance_id_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_user_id_idx ON auth.refresh_tokens USING btree (instance_id, user_id);


--
-- Name: refresh_tokens_parent_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_parent_idx ON auth.refresh_tokens USING btree (parent);


--
-- Name: refresh_tokens_session_id_revoked_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_session_id_revoked_idx ON auth.refresh_tokens USING btree (session_id, revoked);


--
-- Name: refresh_tokens_updated_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_updated_at_idx ON auth.refresh_tokens USING btree (updated_at DESC);


--
-- Name: saml_providers_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_providers_sso_provider_id_idx ON auth.saml_providers USING btree (sso_provider_id);


--
-- Name: saml_relay_states_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_created_at_idx ON auth.saml_relay_states USING btree (created_at DESC);


--
-- Name: saml_relay_states_for_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_for_email_idx ON auth.saml_relay_states USING btree (for_email);


--
-- Name: saml_relay_states_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_sso_provider_id_idx ON auth.saml_relay_states USING btree (sso_provider_id);


--
-- Name: sessions_not_after_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_not_after_idx ON auth.sessions USING btree (not_after DESC);


--
-- Name: sessions_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_user_id_idx ON auth.sessions USING btree (user_id);


--
-- Name: sso_domains_domain_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX sso_domains_domain_idx ON auth.sso_domains USING btree (lower(domain));


--
-- Name: sso_domains_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sso_domains_sso_provider_id_idx ON auth.sso_domains USING btree (sso_provider_id);


--
-- Name: sso_providers_resource_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX sso_providers_resource_id_idx ON auth.sso_providers USING btree (lower(resource_id));


--
-- Name: unique_phone_factor_per_user; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX unique_phone_factor_per_user ON auth.mfa_factors USING btree (user_id, phone);


--
-- Name: user_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX user_id_created_at_idx ON auth.sessions USING btree (user_id, created_at);


--
-- Name: users_email_partial_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX users_email_partial_key ON auth.users USING btree (email) WHERE (is_sso_user = false);


--
-- Name: INDEX users_email_partial_key; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON INDEX auth.users_email_partial_key IS 'Auth: A partial unique index that applies only when is_sso_user is false';


--
-- Name: users_instance_id_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_email_idx ON auth.users USING btree (instance_id, lower((email)::text));


--
-- Name: users_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_idx ON auth.users USING btree (instance_id);


--
-- Name: users_is_anonymous_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_is_anonymous_idx ON auth.users USING btree (is_anonymous);


--
-- Name: engineers_name_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX engineers_name_idx ON public.engineers USING btree (name);


--
-- Name: idx_active_shifts_started_by; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_active_shifts_started_by ON public.active_shifts USING btree (started_by);


--
-- Name: idx_attachments_log_entry_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_attachments_log_entry_id ON public.attachments USING btree (log_entry_id);


--
-- Name: idx_engineers_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_engineers_user_id ON public.engineers USING btree (user_id);


--
-- Name: idx_log_entries_shift_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_log_entries_shift_id ON public.log_entries USING btree (shift_id);


--
-- Name: idx_shift_engineers_engineer_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_shift_engineers_engineer_id ON public.shift_engineers USING btree (engineer_id);


--
-- Name: idx_shift_engineers_shift_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_shift_engineers_shift_id ON public.shift_engineers USING btree (shift_id);


--
-- Name: log_entries_category_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX log_entries_category_idx ON public.log_entries USING btree (category);


--
-- Name: log_entries_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX log_entries_created_at_idx ON public.log_entries USING btree (created_at);


--
-- Name: log_entries_shift_type_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX log_entries_shift_type_idx ON public.log_entries USING btree (shift_type);


--
-- Name: log_suggestions_category_description_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX log_suggestions_category_description_idx ON public.log_suggestions USING btree (category, description);


--
-- Name: shift_notes_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX shift_notes_created_at_idx ON public.shift_notes USING btree (created_at);


--
-- Name: shift_notes_shift_type_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX shift_notes_shift_type_idx ON public.shift_notes USING btree (shift_type);


--
-- Name: unique_active_shift; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX unique_active_shift ON public.active_shifts USING btree ((1));


--
-- Name: ix_realtime_subscription_entity; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX ix_realtime_subscription_entity ON realtime.subscription USING btree (entity);


--
-- Name: subscription_subscription_id_entity_filters_key; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE UNIQUE INDEX subscription_subscription_id_entity_filters_key ON realtime.subscription USING btree (subscription_id, entity, filters);


--
-- Name: bname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bname ON storage.buckets USING btree (name);


--
-- Name: bucketid_objname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bucketid_objname ON storage.objects USING btree (bucket_id, name);


--
-- Name: idx_multipart_uploads_list; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_multipart_uploads_list ON storage.s3_multipart_uploads USING btree (bucket_id, key, created_at);


--
-- Name: idx_objects_bucket_id_name; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_objects_bucket_id_name ON storage.objects USING btree (bucket_id, name COLLATE "C");


--
-- Name: name_prefix_search; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX name_prefix_search ON storage.objects USING btree (name text_pattern_ops);


--
-- Name: supabase_functions_hooks_h_table_id_h_name_idx; Type: INDEX; Schema: supabase_functions; Owner: supabase_functions_admin
--

CREATE INDEX supabase_functions_hooks_h_table_id_h_name_idx ON supabase_functions.hooks USING btree (hook_table_id, hook_name);


--
-- Name: supabase_functions_hooks_request_id_idx; Type: INDEX; Schema: supabase_functions; Owner: supabase_functions_admin
--

CREATE INDEX supabase_functions_hooks_request_id_idx ON supabase_functions.hooks USING btree (request_id);


--
-- Name: messages_2025_05_15_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2025_05_15_pkey;


--
-- Name: messages_2025_05_16_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2025_05_16_pkey;


--
-- Name: messages_2025_05_17_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2025_05_17_pkey;


--
-- Name: messages_2025_05_18_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2025_05_18_pkey;


--
-- Name: messages_2025_05_19_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2025_05_19_pkey;


--
-- Name: active_shifts enforce_single_active_shift; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER enforce_single_active_shift BEFORE INSERT OR UPDATE ON public.active_shifts FOR EACH ROW EXECUTE FUNCTION public.check_active_shifts();


--
-- Name: log_entries trg_restore_active_shift_on_end_log_delete; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_restore_active_shift_on_end_log_delete AFTER DELETE ON public.log_entries FOR EACH ROW EXECUTE FUNCTION public.restore_active_shift_on_end_log_delete();


--
-- Name: subscription tr_check_filters; Type: TRIGGER; Schema: realtime; Owner: supabase_admin
--

CREATE TRIGGER tr_check_filters BEFORE INSERT OR UPDATE ON realtime.subscription FOR EACH ROW EXECUTE FUNCTION realtime.subscription_check_filters();


--
-- Name: objects update_objects_updated_at; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER update_objects_updated_at BEFORE UPDATE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.update_updated_at_column();


--
-- Name: extensions extensions_tenant_external_id_fkey; Type: FK CONSTRAINT; Schema: _realtime; Owner: supabase_admin
--

ALTER TABLE ONLY _realtime.extensions
    ADD CONSTRAINT extensions_tenant_external_id_fkey FOREIGN KEY (tenant_external_id) REFERENCES _realtime.tenants(external_id) ON DELETE CASCADE;


--
-- Name: identities identities_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: mfa_challenges mfa_challenges_auth_factor_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_auth_factor_id_fkey FOREIGN KEY (factor_id) REFERENCES auth.mfa_factors(id) ON DELETE CASCADE;


--
-- Name: mfa_factors mfa_factors_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: one_time_tokens one_time_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: refresh_tokens refresh_tokens_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: saml_providers saml_providers_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_flow_state_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_flow_state_id_fkey FOREIGN KEY (flow_state_id) REFERENCES auth.flow_state(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: sso_domains sso_domains_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: active_shifts active_shifts_started_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.active_shifts
    ADD CONSTRAINT active_shifts_started_by_fkey FOREIGN KEY (started_by) REFERENCES auth.users(id);


--
-- Name: attachments attachments_log_entry_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attachments
    ADD CONSTRAINT attachments_log_entry_id_fkey FOREIGN KEY (log_entry_id) REFERENCES public.log_entries(id);


--
-- Name: attachments attachments_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attachments
    ADD CONSTRAINT attachments_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id);


--
-- Name: engineers engineers_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.engineers
    ADD CONSTRAINT engineers_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id);


--
-- Name: shift_engineers fk_engineer; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shift_engineers
    ADD CONSTRAINT fk_engineer FOREIGN KEY (engineer_id) REFERENCES public.engineers(id);


--
-- Name: shift_engineers fk_shift; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shift_engineers
    ADD CONSTRAINT fk_shift FOREIGN KEY (shift_id) REFERENCES public.active_shifts(id);


--
-- Name: log_entries log_entries_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.log_entries
    ADD CONSTRAINT log_entries_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id);


--
-- Name: profiles profiles_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_id_fkey FOREIGN KEY (id) REFERENCES auth.users(id);


--
-- Name: shift_engineers shift_engineers_engineer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shift_engineers
    ADD CONSTRAINT shift_engineers_engineer_id_fkey FOREIGN KEY (engineer_id) REFERENCES public.engineers(id);


--
-- Name: shift_notes shift_notes_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shift_notes
    ADD CONSTRAINT shift_notes_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id);


--
-- Name: objects objects_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT "objects_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_upload_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_upload_id_fkey FOREIGN KEY (upload_id) REFERENCES storage.s3_multipart_uploads(id) ON DELETE CASCADE;


--
-- Name: audit_log_entries; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.audit_log_entries ENABLE ROW LEVEL SECURITY;

--
-- Name: flow_state; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.flow_state ENABLE ROW LEVEL SECURITY;

--
-- Name: identities; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.identities ENABLE ROW LEVEL SECURITY;

--
-- Name: instances; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.instances ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_amr_claims; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_amr_claims ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_challenges; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_challenges ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_factors; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_factors ENABLE ROW LEVEL SECURITY;

--
-- Name: one_time_tokens; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.one_time_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: refresh_tokens; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.refresh_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_providers; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.saml_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_relay_states; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.saml_relay_states ENABLE ROW LEVEL SECURITY;

--
-- Name: schema_migrations; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.schema_migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: sessions; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sessions ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_domains; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sso_domains ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_providers; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sso_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: users; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.users ENABLE ROW LEVEL SECURITY;

--
-- Name: engineers Allow authenticated users to create engineers; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow authenticated users to create engineers" ON public.engineers FOR INSERT TO authenticated WITH CHECK ((auth.uid() = user_id));


--
-- Name: log_entries Allow authenticated users to create log entries; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow authenticated users to create log entries" ON public.log_entries FOR INSERT TO authenticated WITH CHECK ((auth.uid() = user_id));


--
-- Name: shift_notes Allow authenticated users to create shift notes; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow authenticated users to create shift notes" ON public.shift_notes FOR INSERT TO authenticated WITH CHECK ((auth.uid() = user_id));


--
-- Name: log_entries Allow authenticated users to read all log entries; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow authenticated users to read all log entries" ON public.log_entries FOR SELECT TO authenticated USING (true);


--
-- Name: shift_notes Allow authenticated users to read all shift notes; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow authenticated users to read all shift notes" ON public.shift_notes FOR SELECT TO authenticated USING (true);


--
-- Name: engineers Allow authenticated users to read engineers; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow authenticated users to read engineers" ON public.engineers FOR SELECT TO authenticated USING (true);


--
-- Name: log_suggestions Allow authenticated users to read log suggestions; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow authenticated users to read log suggestions" ON public.log_suggestions FOR SELECT TO authenticated USING (true);


--
-- Name: shift_engineers Allow authenticated users to read shift engineers; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow authenticated users to read shift engineers" ON public.shift_engineers FOR SELECT TO authenticated USING (true);


--
-- Name: attachments Allow read access; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow read access" ON public.attachments FOR SELECT USING (true);


--
-- Name: log_entries Allow read access; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow read access" ON public.log_entries FOR SELECT USING (true);


--
-- Name: attachments Allow read access to attachments; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow read access to attachments" ON public.attachments FOR SELECT USING (true);


--
-- Name: log_entries Allow read access to log_entries; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow read access to log_entries" ON public.log_entries FOR SELECT USING (true);


--
-- Name: workorders Allow read for all; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow read for all" ON public.workorders FOR SELECT USING (true);


--
-- Name: log_entries Allow users to delete their own log entries; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow users to delete their own log entries" ON public.log_entries FOR DELETE TO authenticated USING ((auth.uid() = user_id));


--
-- Name: shift_notes Allow users to delete their own shift notes; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow users to delete their own shift notes" ON public.shift_notes FOR DELETE TO authenticated USING ((auth.uid() = user_id));


--
-- Name: log_entries Allow users to update their own log entries; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow users to update their own log entries" ON public.log_entries FOR UPDATE TO authenticated USING ((auth.uid() = user_id)) WITH CHECK ((auth.uid() = user_id));


--
-- Name: shift_notes Allow users to update their own shift notes; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow users to update their own shift notes" ON public.shift_notes FOR UPDATE TO authenticated USING ((auth.uid() = user_id)) WITH CHECK ((auth.uid() = user_id));


--
-- Name: engineers Authenticated users can create engineers; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated users can create engineers" ON public.engineers FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: shift_engineers Users can delete shift engineers; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can delete shift engineers" ON public.shift_engineers FOR DELETE TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.active_shifts
  WHERE ((active_shifts.id = shift_engineers.shift_id) AND (active_shifts.started_by = auth.uid())))));


--
-- Name: attachments Users can delete their own attachments; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can delete their own attachments" ON public.attachments FOR DELETE TO authenticated USING ((auth.uid() = user_id));


--
-- Name: active_shifts Users can delete their own shifts; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can delete their own shifts" ON public.active_shifts FOR DELETE TO authenticated USING ((auth.uid() = started_by));


--
-- Name: shift_engineers Users can insert shift engineers; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can insert shift engineers" ON public.shift_engineers FOR INSERT TO authenticated WITH CHECK ((EXISTS ( SELECT 1
   FROM public.active_shifts
  WHERE ((active_shifts.id = shift_engineers.shift_id) AND (active_shifts.started_by = auth.uid())))));


--
-- Name: active_shifts Users can insert shifts; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can insert shifts" ON public.active_shifts FOR INSERT TO authenticated WITH CHECK ((auth.uid() = started_by));


--
-- Name: attachments Users can insert their own attachments; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can insert their own attachments" ON public.attachments FOR INSERT TO authenticated WITH CHECK ((auth.uid() = user_id));


--
-- Name: profiles Users can insert their own profile; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can insert their own profile" ON public.profiles FOR INSERT WITH CHECK ((auth.uid() = id));


--
-- Name: active_shifts Users can update their own shifts; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can update their own shifts" ON public.active_shifts FOR UPDATE TO authenticated USING ((auth.uid() = started_by)) WITH CHECK ((auth.uid() = started_by));


--
-- Name: active_shifts Users can view active shifts; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can view active shifts" ON public.active_shifts FOR SELECT TO authenticated USING (true);


--
-- Name: engineers Users can view all engineers; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can view all engineers" ON public.engineers FOR SELECT TO authenticated USING (true);


--
-- Name: shift_engineers Users can view all shift engineers; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can view all shift engineers" ON public.shift_engineers FOR SELECT TO authenticated USING (true);


--
-- Name: attachments Users can view their own attachments; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can view their own attachments" ON public.attachments FOR SELECT TO authenticated USING ((auth.uid() = user_id));


--
-- Name: profiles Users can view their own profile; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can view their own profile" ON public.profiles FOR SELECT USING ((auth.uid() = id));


--
-- Name: active_shifts; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.active_shifts ENABLE ROW LEVEL SECURITY;

--
-- Name: attachments; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.attachments ENABLE ROW LEVEL SECURITY;

--
-- Name: engineers; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.engineers ENABLE ROW LEVEL SECURITY;

--
-- Name: log_entries; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.log_entries ENABLE ROW LEVEL SECURITY;

--
-- Name: log_suggestions; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.log_suggestions ENABLE ROW LEVEL SECURITY;

--
-- Name: profiles; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

--
-- Name: shift_engineers; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.shift_engineers ENABLE ROW LEVEL SECURITY;

--
-- Name: shift_notes; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.shift_notes ENABLE ROW LEVEL SECURITY;

--
-- Name: messages; Type: ROW SECURITY; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE realtime.messages ENABLE ROW LEVEL SECURITY;

--
-- Name: objects Allow authenticated deletes; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Allow authenticated deletes" ON storage.objects FOR DELETE TO authenticated USING (((bucket_id = 'attachments'::text) AND (auth.role() = 'authenticated'::text)));


--
-- Name: objects Allow authenticated downloads; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Allow authenticated downloads" ON storage.objects FOR SELECT TO authenticated USING (((bucket_id = 'attachments'::text) AND (auth.role() = 'authenticated'::text)));


--
-- Name: objects Allow authenticated uploads; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Allow authenticated uploads" ON storage.objects FOR INSERT TO authenticated WITH CHECK (((bucket_id = 'attachments'::text) AND (auth.role() = 'authenticated'::text)));


--
-- Name: buckets; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets ENABLE ROW LEVEL SECURITY;

--
-- Name: migrations; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: objects; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.s3_multipart_uploads ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads_parts; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.s3_multipart_uploads_parts ENABLE ROW LEVEL SECURITY;

--
-- Name: supabase_realtime; Type: PUBLICATION; Schema: -; Owner: postgres
--

CREATE PUBLICATION supabase_realtime WITH (publish = 'insert, update, delete, truncate');


ALTER PUBLICATION supabase_realtime OWNER TO postgres;

--
-- Name: supabase_realtime_messages_publication; Type: PUBLICATION; Schema: -; Owner: supabase_admin
--

CREATE PUBLICATION supabase_realtime_messages_publication WITH (publish = 'insert, update, delete, truncate');


ALTER PUBLICATION supabase_realtime_messages_publication OWNER TO supabase_admin;

--
-- Name: supabase_realtime_messages_publication messages; Type: PUBLICATION TABLE; Schema: realtime; Owner: supabase_admin
--

ALTER PUBLICATION supabase_realtime_messages_publication ADD TABLE ONLY realtime.messages;


--
-- Name: SCHEMA auth; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA auth TO anon;
GRANT USAGE ON SCHEMA auth TO authenticated;
GRANT USAGE ON SCHEMA auth TO service_role;
GRANT ALL ON SCHEMA auth TO supabase_auth_admin;
GRANT ALL ON SCHEMA auth TO dashboard_user;
GRANT ALL ON SCHEMA auth TO postgres;


--
-- Name: SCHEMA extensions; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA extensions TO anon;
GRANT USAGE ON SCHEMA extensions TO authenticated;
GRANT USAGE ON SCHEMA extensions TO service_role;
GRANT ALL ON SCHEMA extensions TO dashboard_user;


--
-- Name: SCHEMA net; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA net TO supabase_functions_admin;
GRANT USAGE ON SCHEMA net TO postgres;
GRANT USAGE ON SCHEMA net TO anon;
GRANT USAGE ON SCHEMA net TO authenticated;
GRANT USAGE ON SCHEMA net TO service_role;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT USAGE ON SCHEMA public TO postgres;
GRANT USAGE ON SCHEMA public TO anon;
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT USAGE ON SCHEMA public TO service_role;


--
-- Name: SCHEMA realtime; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA realtime TO postgres;
GRANT USAGE ON SCHEMA realtime TO anon;
GRANT USAGE ON SCHEMA realtime TO authenticated;
GRANT USAGE ON SCHEMA realtime TO service_role;
GRANT ALL ON SCHEMA realtime TO supabase_realtime_admin;


--
-- Name: SCHEMA storage; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT ALL ON SCHEMA storage TO postgres;
GRANT USAGE ON SCHEMA storage TO anon;
GRANT USAGE ON SCHEMA storage TO authenticated;
GRANT USAGE ON SCHEMA storage TO service_role;
GRANT ALL ON SCHEMA storage TO supabase_storage_admin;
GRANT ALL ON SCHEMA storage TO dashboard_user;


--
-- Name: SCHEMA supabase_functions; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA supabase_functions TO postgres;
GRANT USAGE ON SCHEMA supabase_functions TO anon;
GRANT USAGE ON SCHEMA supabase_functions TO authenticated;
GRANT USAGE ON SCHEMA supabase_functions TO service_role;
GRANT ALL ON SCHEMA supabase_functions TO supabase_functions_admin;


--
-- Name: SCHEMA vault; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA vault TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION email(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.email() TO dashboard_user;


--
-- Name: FUNCTION jwt(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.jwt() TO postgres;
GRANT ALL ON FUNCTION auth.jwt() TO dashboard_user;


--
-- Name: FUNCTION role(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.role() TO dashboard_user;


--
-- Name: FUNCTION uid(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.uid() TO dashboard_user;


--
-- Name: FUNCTION algorithm_sign(signables text, secret text, algorithm text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.algorithm_sign(signables text, secret text, algorithm text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.algorithm_sign(signables text, secret text, algorithm text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION armor(bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.armor(bytea) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.armor(bytea) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION armor(bytea, text[], text[]); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.armor(bytea, text[], text[]) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.armor(bytea, text[], text[]) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION crypt(text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.crypt(text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.crypt(text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION dearmor(text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.dearmor(text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.dearmor(text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION decrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION digest(bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.digest(bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.digest(bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION digest(text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.digest(text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.digest(text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION encrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION encrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION gen_random_bytes(integer); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.gen_random_bytes(integer) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.gen_random_bytes(integer) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION gen_random_uuid(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.gen_random_uuid() TO dashboard_user;
GRANT ALL ON FUNCTION extensions.gen_random_uuid() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION gen_salt(text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.gen_salt(text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.gen_salt(text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION gen_salt(text, integer); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.gen_salt(text, integer) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.gen_salt(text, integer) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION grant_pg_cron_access(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.grant_pg_cron_access() FROM postgres;
GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO dashboard_user;


--
-- Name: FUNCTION grant_pg_graphql_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.grant_pg_graphql_access() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION grant_pg_net_access(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.grant_pg_net_access() FROM postgres;
GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO dashboard_user;


--
-- Name: FUNCTION hmac(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.hmac(bytea, bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.hmac(bytea, bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION hmac(text, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.hmac(text, text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.hmac(text, text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT blk_read_time double precision, OUT blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT blk_read_time double precision, OUT blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pg_stat_statements_reset(userid oid, dbid oid, queryid bigint); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_armor_headers(text, OUT key text, OUT value text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_key_id(bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_key_id(bytea) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_key_id(bytea) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_sym_encrypt(text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_sym_encrypt(text, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgrst_ddl_watch(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgrst_ddl_watch() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgrst_drop_watch(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgrst_drop_watch() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION set_graphql_placeholder(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.set_graphql_placeholder() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION sign(payload json, secret text, algorithm text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.sign(payload json, secret text, algorithm text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.sign(payload json, secret text, algorithm text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION try_cast_double(inp text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.try_cast_double(inp text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.try_cast_double(inp text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION url_decode(data text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.url_decode(data text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.url_decode(data text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION url_encode(data bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.url_encode(data bytea) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.url_encode(data bytea) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_generate_v1(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v1() TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_generate_v1mc(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v1mc() TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1mc() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_generate_v3(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_generate_v4(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v4() TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_generate_v4() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_generate_v5(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_nil(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_nil() TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_nil() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_ns_dns(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_ns_dns() TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_ns_dns() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_ns_oid(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_ns_oid() TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_ns_oid() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_ns_url(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_ns_url() TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_ns_url() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_ns_x500(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_ns_x500() TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_ns_x500() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION verify(token text, secret text, algorithm text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.verify(token text, secret text, algorithm text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.verify(token text, secret text, algorithm text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION graphql("operationName" text, query text, variables jsonb, extensions jsonb); Type: ACL; Schema: graphql_public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO postgres;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO anon;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO authenticated;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO service_role;


--
-- Name: FUNCTION http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer); Type: ACL; Schema: net; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
GRANT ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin;
GRANT ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO postgres;
GRANT ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO anon;
GRANT ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO authenticated;
GRANT ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO service_role;


--
-- Name: FUNCTION http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer); Type: ACL; Schema: net; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
GRANT ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin;
GRANT ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO postgres;
GRANT ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO anon;
GRANT ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO authenticated;
GRANT ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO service_role;


--
-- Name: FUNCTION get_auth(p_usename text); Type: ACL; Schema: pgbouncer; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION pgbouncer.get_auth(p_usename text) FROM PUBLIC;
GRANT ALL ON FUNCTION pgbouncer.get_auth(p_usename text) TO pgbouncer;
GRANT ALL ON FUNCTION pgbouncer.get_auth(p_usename text) TO postgres;


--
-- Name: FUNCTION crypto_aead_det_decrypt(message bytea, additional bytea, key_uuid uuid, nonce bytea); Type: ACL; Schema: pgsodium; Owner: pgsodium_keymaker
--

GRANT ALL ON FUNCTION pgsodium.crypto_aead_det_decrypt(message bytea, additional bytea, key_uuid uuid, nonce bytea) TO service_role;


--
-- Name: FUNCTION crypto_aead_det_encrypt(message bytea, additional bytea, key_uuid uuid, nonce bytea); Type: ACL; Schema: pgsodium; Owner: pgsodium_keymaker
--

GRANT ALL ON FUNCTION pgsodium.crypto_aead_det_encrypt(message bytea, additional bytea, key_uuid uuid, nonce bytea) TO service_role;


--
-- Name: FUNCTION crypto_aead_det_keygen(); Type: ACL; Schema: pgsodium; Owner: supabase_admin
--

GRANT ALL ON FUNCTION pgsodium.crypto_aead_det_keygen() TO service_role;


--
-- Name: FUNCTION check_active_shift(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.check_active_shift() TO anon;
GRANT ALL ON FUNCTION public.check_active_shift() TO authenticated;
GRANT ALL ON FUNCTION public.check_active_shift() TO service_role;


--
-- Name: FUNCTION check_active_shifts(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.check_active_shifts() TO anon;
GRANT ALL ON FUNCTION public.check_active_shifts() TO authenticated;
GRANT ALL ON FUNCTION public.check_active_shifts() TO service_role;


--
-- Name: FUNCTION cleanup_shifts(shift_ids uuid[]); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.cleanup_shifts(shift_ids uuid[]) TO anon;
GRANT ALL ON FUNCTION public.cleanup_shifts(shift_ids uuid[]) TO authenticated;
GRANT ALL ON FUNCTION public.cleanup_shifts(shift_ids uuid[]) TO service_role;


--
-- Name: FUNCTION restore_active_shift_on_end_log_delete(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.restore_active_shift_on_end_log_delete() TO anon;
GRANT ALL ON FUNCTION public.restore_active_shift_on_end_log_delete() TO authenticated;
GRANT ALL ON FUNCTION public.restore_active_shift_on_end_log_delete() TO service_role;


--
-- Name: FUNCTION start_new_shift(p_shift_type public.shift_type, p_started_by uuid, p_salesforce_number text, p_engineer_ids uuid[], p_description text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.start_new_shift(p_shift_type public.shift_type, p_started_by uuid, p_salesforce_number text, p_engineer_ids uuid[], p_description text) TO anon;
GRANT ALL ON FUNCTION public.start_new_shift(p_shift_type public.shift_type, p_started_by uuid, p_salesforce_number text, p_engineer_ids uuid[], p_description text) TO authenticated;
GRANT ALL ON FUNCTION public.start_new_shift(p_shift_type public.shift_type, p_started_by uuid, p_salesforce_number text, p_engineer_ids uuid[], p_description text) TO service_role;


--
-- Name: FUNCTION upsert_log_suggestion(p_category public.log_category, p_description text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.upsert_log_suggestion(p_category public.log_category, p_description text) TO anon;
GRANT ALL ON FUNCTION public.upsert_log_suggestion(p_category public.log_category, p_description text) TO authenticated;
GRANT ALL ON FUNCTION public.upsert_log_suggestion(p_category public.log_category, p_description text) TO service_role;


--
-- Name: FUNCTION apply_rls(wal jsonb, max_record_bytes integer); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO postgres;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO anon;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO authenticated;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO service_role;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO supabase_realtime_admin;


--
-- Name: FUNCTION broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) TO postgres;
GRANT ALL ON FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) TO dashboard_user;


--
-- Name: FUNCTION build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO postgres;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO anon;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO authenticated;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO service_role;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO supabase_realtime_admin;


--
-- Name: FUNCTION "cast"(val text, type_ regtype); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO postgres;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO dashboard_user;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO anon;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO authenticated;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO service_role;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO supabase_realtime_admin;


--
-- Name: FUNCTION check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO postgres;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO anon;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO authenticated;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO service_role;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO supabase_realtime_admin;


--
-- Name: FUNCTION is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO postgres;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO anon;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO authenticated;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO service_role;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO supabase_realtime_admin;


--
-- Name: FUNCTION list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO postgres;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO anon;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO authenticated;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO service_role;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO supabase_realtime_admin;


--
-- Name: FUNCTION quote_wal2json(entity regclass); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO postgres;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO anon;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO authenticated;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO service_role;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO supabase_realtime_admin;


--
-- Name: FUNCTION send(payload jsonb, event text, topic text, private boolean); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) TO postgres;
GRANT ALL ON FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) TO dashboard_user;


--
-- Name: FUNCTION subscription_check_filters(); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO postgres;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO dashboard_user;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO anon;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO authenticated;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO service_role;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO supabase_realtime_admin;


--
-- Name: FUNCTION to_regrole(role_name text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO postgres;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO anon;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO authenticated;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO service_role;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO supabase_realtime_admin;


--
-- Name: FUNCTION topic(); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.topic() TO postgres;
GRANT ALL ON FUNCTION realtime.topic() TO dashboard_user;


--
-- Name: FUNCTION http_request(); Type: ACL; Schema: supabase_functions; Owner: supabase_functions_admin
--

REVOKE ALL ON FUNCTION supabase_functions.http_request() FROM PUBLIC;
GRANT ALL ON FUNCTION supabase_functions.http_request() TO postgres;
GRANT ALL ON FUNCTION supabase_functions.http_request() TO anon;
GRANT ALL ON FUNCTION supabase_functions.http_request() TO authenticated;
GRANT ALL ON FUNCTION supabase_functions.http_request() TO service_role;


--
-- Name: FUNCTION _crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault._crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION create_secret(new_secret text, new_name text, new_description text, new_key_id uuid); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault.create_secret(new_secret text, new_name text, new_description text, new_key_id uuid) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault.update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid) TO postgres WITH GRANT OPTION;


--
-- Name: TABLE audit_log_entries; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.audit_log_entries TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.audit_log_entries TO postgres;
GRANT SELECT ON TABLE auth.audit_log_entries TO postgres WITH GRANT OPTION;


--
-- Name: TABLE flow_state; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.flow_state TO postgres;
GRANT SELECT ON TABLE auth.flow_state TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.flow_state TO dashboard_user;


--
-- Name: TABLE identities; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.identities TO postgres;
GRANT SELECT ON TABLE auth.identities TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.identities TO dashboard_user;


--
-- Name: TABLE instances; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.instances TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.instances TO postgres;
GRANT SELECT ON TABLE auth.instances TO postgres WITH GRANT OPTION;


--
-- Name: TABLE mfa_amr_claims; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.mfa_amr_claims TO postgres;
GRANT SELECT ON TABLE auth.mfa_amr_claims TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_amr_claims TO dashboard_user;


--
-- Name: TABLE mfa_challenges; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.mfa_challenges TO postgres;
GRANT SELECT ON TABLE auth.mfa_challenges TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_challenges TO dashboard_user;


--
-- Name: TABLE mfa_factors; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.mfa_factors TO postgres;
GRANT SELECT ON TABLE auth.mfa_factors TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_factors TO dashboard_user;


--
-- Name: TABLE one_time_tokens; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.one_time_tokens TO postgres;
GRANT SELECT ON TABLE auth.one_time_tokens TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.one_time_tokens TO dashboard_user;


--
-- Name: TABLE refresh_tokens; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.refresh_tokens TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.refresh_tokens TO postgres;
GRANT SELECT ON TABLE auth.refresh_tokens TO postgres WITH GRANT OPTION;


--
-- Name: SEQUENCE refresh_tokens_id_seq; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO dashboard_user;
GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO postgres;


--
-- Name: TABLE saml_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.saml_providers TO postgres;
GRANT SELECT ON TABLE auth.saml_providers TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.saml_providers TO dashboard_user;


--
-- Name: TABLE saml_relay_states; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.saml_relay_states TO postgres;
GRANT SELECT ON TABLE auth.saml_relay_states TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.saml_relay_states TO dashboard_user;


--
-- Name: TABLE schema_migrations; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.schema_migrations TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.schema_migrations TO postgres;
GRANT SELECT ON TABLE auth.schema_migrations TO postgres WITH GRANT OPTION;


--
-- Name: TABLE sessions; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.sessions TO postgres;
GRANT SELECT ON TABLE auth.sessions TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sessions TO dashboard_user;


--
-- Name: TABLE sso_domains; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.sso_domains TO postgres;
GRANT SELECT ON TABLE auth.sso_domains TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sso_domains TO dashboard_user;


--
-- Name: TABLE sso_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.sso_providers TO postgres;
GRANT SELECT ON TABLE auth.sso_providers TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sso_providers TO dashboard_user;


--
-- Name: TABLE users; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.users TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.users TO postgres;
GRANT SELECT ON TABLE auth.users TO postgres WITH GRANT OPTION;


--
-- Name: TABLE pg_stat_statements; Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON TABLE extensions.pg_stat_statements TO postgres WITH GRANT OPTION;


--
-- Name: TABLE pg_stat_statements_info; Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON TABLE extensions.pg_stat_statements_info TO postgres WITH GRANT OPTION;


--
-- Name: TABLE decrypted_key; Type: ACL; Schema: pgsodium; Owner: postgres
--

GRANT ALL ON TABLE pgsodium.decrypted_key TO pgsodium_keyholder;


--
-- Name: TABLE masking_rule; Type: ACL; Schema: pgsodium; Owner: supabase_admin
--

GRANT ALL ON TABLE pgsodium.masking_rule TO pgsodium_keyholder;


--
-- Name: TABLE mask_columns; Type: ACL; Schema: pgsodium; Owner: supabase_admin
--

GRANT ALL ON TABLE pgsodium.mask_columns TO pgsodium_keyholder;


--
-- Name: TABLE access_requests; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.access_requests TO anon;
GRANT ALL ON TABLE public.access_requests TO authenticated;
GRANT ALL ON TABLE public.access_requests TO service_role;


--
-- Name: TABLE active_shifts; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.active_shifts TO anon;
GRANT ALL ON TABLE public.active_shifts TO authenticated;
GRANT ALL ON TABLE public.active_shifts TO service_role;


--
-- Name: TABLE attachments; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.attachments TO anon;
GRANT ALL ON TABLE public.attachments TO authenticated;
GRANT ALL ON TABLE public.attachments TO service_role;


--
-- Name: TABLE engineers; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.engineers TO anon;
GRANT ALL ON TABLE public.engineers TO authenticated;
GRANT ALL ON TABLE public.engineers TO service_role;


--
-- Name: TABLE log_entries; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.log_entries TO anon;
GRANT ALL ON TABLE public.log_entries TO authenticated;
GRANT ALL ON TABLE public.log_entries TO service_role;


--
-- Name: TABLE log_suggestions; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.log_suggestions TO anon;
GRANT ALL ON TABLE public.log_suggestions TO authenticated;
GRANT ALL ON TABLE public.log_suggestions TO service_role;


--
-- Name: TABLE profiles; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.profiles TO anon;
GRANT ALL ON TABLE public.profiles TO authenticated;
GRANT ALL ON TABLE public.profiles TO service_role;


--
-- Name: TABLE shift_engineers; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.shift_engineers TO anon;
GRANT ALL ON TABLE public.shift_engineers TO authenticated;
GRANT ALL ON TABLE public.shift_engineers TO service_role;


--
-- Name: TABLE shift_notes; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.shift_notes TO anon;
GRANT ALL ON TABLE public.shift_notes TO authenticated;
GRANT ALL ON TABLE public.shift_notes TO service_role;


--
-- Name: TABLE workorders; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.workorders TO anon;
GRANT ALL ON TABLE public.workorders TO authenticated;
GRANT ALL ON TABLE public.workorders TO service_role;


--
-- Name: SEQUENCE workorders_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.workorders_id_seq TO anon;
GRANT ALL ON SEQUENCE public.workorders_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.workorders_id_seq TO service_role;


--
-- Name: TABLE messages; Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON TABLE realtime.messages TO postgres;
GRANT ALL ON TABLE realtime.messages TO dashboard_user;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO anon;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO authenticated;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO service_role;


--
-- Name: TABLE messages_2025_05_15; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2025_05_15 TO postgres;
GRANT ALL ON TABLE realtime.messages_2025_05_15 TO dashboard_user;


--
-- Name: TABLE messages_2025_05_16; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2025_05_16 TO postgres;
GRANT ALL ON TABLE realtime.messages_2025_05_16 TO dashboard_user;


--
-- Name: TABLE messages_2025_05_17; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2025_05_17 TO postgres;
GRANT ALL ON TABLE realtime.messages_2025_05_17 TO dashboard_user;


--
-- Name: TABLE messages_2025_05_18; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2025_05_18 TO postgres;
GRANT ALL ON TABLE realtime.messages_2025_05_18 TO dashboard_user;


--
-- Name: TABLE messages_2025_05_19; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2025_05_19 TO postgres;
GRANT ALL ON TABLE realtime.messages_2025_05_19 TO dashboard_user;


--
-- Name: TABLE schema_migrations; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.schema_migrations TO postgres;
GRANT ALL ON TABLE realtime.schema_migrations TO dashboard_user;
GRANT SELECT ON TABLE realtime.schema_migrations TO anon;
GRANT SELECT ON TABLE realtime.schema_migrations TO authenticated;
GRANT SELECT ON TABLE realtime.schema_migrations TO service_role;
GRANT ALL ON TABLE realtime.schema_migrations TO supabase_realtime_admin;


--
-- Name: TABLE subscription; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.subscription TO postgres;
GRANT ALL ON TABLE realtime.subscription TO dashboard_user;
GRANT SELECT ON TABLE realtime.subscription TO anon;
GRANT SELECT ON TABLE realtime.subscription TO authenticated;
GRANT SELECT ON TABLE realtime.subscription TO service_role;
GRANT ALL ON TABLE realtime.subscription TO supabase_realtime_admin;


--
-- Name: SEQUENCE subscription_id_seq; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO postgres;
GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO dashboard_user;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO anon;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO authenticated;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO service_role;
GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO supabase_realtime_admin;


--
-- Name: TABLE buckets; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.buckets TO anon;
GRANT ALL ON TABLE storage.buckets TO authenticated;
GRANT ALL ON TABLE storage.buckets TO service_role;
GRANT ALL ON TABLE storage.buckets TO postgres;


--
-- Name: TABLE migrations; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.migrations TO anon;
GRANT ALL ON TABLE storage.migrations TO authenticated;
GRANT ALL ON TABLE storage.migrations TO service_role;
GRANT ALL ON TABLE storage.migrations TO postgres;


--
-- Name: TABLE objects; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.objects TO anon;
GRANT ALL ON TABLE storage.objects TO authenticated;
GRANT ALL ON TABLE storage.objects TO service_role;
GRANT ALL ON TABLE storage.objects TO postgres;


--
-- Name: TABLE s3_multipart_uploads; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.s3_multipart_uploads TO service_role;
GRANT SELECT ON TABLE storage.s3_multipart_uploads TO authenticated;
GRANT SELECT ON TABLE storage.s3_multipart_uploads TO anon;
GRANT ALL ON TABLE storage.s3_multipart_uploads TO postgres;


--
-- Name: TABLE s3_multipart_uploads_parts; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.s3_multipart_uploads_parts TO service_role;
GRANT SELECT ON TABLE storage.s3_multipart_uploads_parts TO authenticated;
GRANT SELECT ON TABLE storage.s3_multipart_uploads_parts TO anon;
GRANT ALL ON TABLE storage.s3_multipart_uploads_parts TO postgres;


--
-- Name: TABLE hooks; Type: ACL; Schema: supabase_functions; Owner: supabase_functions_admin
--

GRANT ALL ON TABLE supabase_functions.hooks TO postgres;
GRANT ALL ON TABLE supabase_functions.hooks TO anon;
GRANT ALL ON TABLE supabase_functions.hooks TO authenticated;
GRANT ALL ON TABLE supabase_functions.hooks TO service_role;


--
-- Name: SEQUENCE hooks_id_seq; Type: ACL; Schema: supabase_functions; Owner: supabase_functions_admin
--

GRANT ALL ON SEQUENCE supabase_functions.hooks_id_seq TO postgres;
GRANT ALL ON SEQUENCE supabase_functions.hooks_id_seq TO anon;
GRANT ALL ON SEQUENCE supabase_functions.hooks_id_seq TO authenticated;
GRANT ALL ON SEQUENCE supabase_functions.hooks_id_seq TO service_role;


--
-- Name: TABLE migrations; Type: ACL; Schema: supabase_functions; Owner: supabase_functions_admin
--

GRANT ALL ON TABLE supabase_functions.migrations TO postgres;
GRANT ALL ON TABLE supabase_functions.migrations TO anon;
GRANT ALL ON TABLE supabase_functions.migrations TO authenticated;
GRANT ALL ON TABLE supabase_functions.migrations TO service_role;


--
-- Name: TABLE secrets; Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT SELECT,DELETE ON TABLE vault.secrets TO postgres WITH GRANT OPTION;


--
-- Name: TABLE decrypted_secrets; Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT SELECT,DELETE ON TABLE vault.decrypted_secrets TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES  TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS  TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES  TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON SEQUENCES  TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON FUNCTIONS  TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON TABLES  TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: pgsodium; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA pgsodium GRANT ALL ON SEQUENCES  TO pgsodium_keyholder;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: pgsodium; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA pgsodium GRANT ALL ON TABLES  TO pgsodium_keyholder;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: pgsodium_masks; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA pgsodium_masks GRANT ALL ON SEQUENCES  TO pgsodium_keyiduser;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: pgsodium_masks; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA pgsodium_masks GRANT ALL ON FUNCTIONS  TO pgsodium_keyiduser;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: pgsodium_masks; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA pgsodium_masks GRANT ALL ON TABLES  TO pgsodium_keyiduser;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES  TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS  TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES  TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: supabase_functions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON SEQUENCES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON SEQUENCES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON SEQUENCES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: supabase_functions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON FUNCTIONS  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON FUNCTIONS  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON FUNCTIONS  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: supabase_functions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON TABLES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON TABLES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON TABLES  TO service_role;


--
-- Name: issue_graphql_placeholder; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_graphql_placeholder ON sql_drop
         WHEN TAG IN ('DROP EXTENSION')
   EXECUTE FUNCTION extensions.set_graphql_placeholder();


ALTER EVENT TRIGGER issue_graphql_placeholder OWNER TO supabase_admin;

--
-- Name: issue_pg_cron_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_cron_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_cron_access();


ALTER EVENT TRIGGER issue_pg_cron_access OWNER TO supabase_admin;

--
-- Name: issue_pg_graphql_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_graphql_access ON ddl_command_end
         WHEN TAG IN ('CREATE FUNCTION')
   EXECUTE FUNCTION extensions.grant_pg_graphql_access();


ALTER EVENT TRIGGER issue_pg_graphql_access OWNER TO supabase_admin;

--
-- Name: issue_pg_net_access; Type: EVENT TRIGGER; Schema: -; Owner: postgres
--

CREATE EVENT TRIGGER issue_pg_net_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_net_access();


ALTER EVENT TRIGGER issue_pg_net_access OWNER TO postgres;

--
-- Name: pgrst_ddl_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_ddl_watch ON ddl_command_end
   EXECUTE FUNCTION extensions.pgrst_ddl_watch();


ALTER EVENT TRIGGER pgrst_ddl_watch OWNER TO supabase_admin;

--
-- Name: pgrst_drop_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_drop_watch ON sql_drop
   EXECUTE FUNCTION extensions.pgrst_drop_watch();


ALTER EVENT TRIGGER pgrst_drop_watch OWNER TO supabase_admin;

--
-- PostgreSQL database dump complete
--

