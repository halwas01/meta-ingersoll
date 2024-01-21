--
-- PostgreSQL database dump
--

-- Dumped from database version 11.7 (Debian 11.7-0+deb10u1)
-- Dumped by pg_dump version 11.7 (Debian 11.7-0+deb10u1)

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
-- Name: notify_job_mapping(); Type: FUNCTION; Schema: public; Owner: insight
--

CREATE OR REPLACE FUNCTION public.notify_job_mapping() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	IF (TG_OP = 'DELETE') THEN
       PERFORM pg_notify('job_mapping_data_channel',json_build_object('operation',0,'record',OLD)::text);
       PERFORM pg_notify('job_mapping_data_channel_' || array_to_string (old.fld_toolmacaddress,''),json_build_object('operation',0)::text);
	   RETURN OLD;
	ELSIF (TG_OP = 'INSERT') THEN
       PERFORM pg_notify('job_mapping_data_channel',json_build_object('operation',1,'record',NEW)::text);
       PERFORM pg_notify('job_mapping_data_channel_' || array_to_string (new.fld_toolmacaddress,''),json_build_object('MacAddress',array_to_string(new.fld_toolmacaddress,'.'),'operation',1,'record',NEW)::text);
	   RETURN NEW;
	ELSE
       PERFORM pg_notify('job_mapping_data_channel',json_build_object('operation',2,'record',NEW)::text);
       RETURN NEW;
	END IF;
END;
$$;


ALTER FUNCTION public.notify_job_mapping() OWNER TO insight;

--
-- Name: notify_master_tool_mapping(); Type: FUNCTION; Schema: public; Owner: insight
--

CREATE OR REPLACE FUNCTION public.notify_master_tool_mapping() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	IF (TG_OP = 'DELETE') THEN
       PERFORM pg_notify('master_tool_data_channel',json_build_object('operation',0,'record',OLD)::text);
	   PERFORM pg_notify('master_tool_data_channel_' || array_to_string (old.fld_toolmacaddress,''),json_build_object('operation',0)::text);
	   RETURN OLD;
	ELSIF (TG_OP = 'INSERT') THEN
       PERFORM pg_notify('master_tool_data_channel',json_build_object('operation',1,'record',NEW)::text);
	   RETURN NEW;
	ELSE
	   PERFORM pg_notify('master_tool_data_channel',json_build_object('operation',2,'record',NEW)::text);
       RETURN NEW;
	END IF;
END;
$$;


ALTER FUNCTION public.notify_master_tool_mapping() OWNER TO insight;

--
-- Name: notify_pset_mapping(); Type: FUNCTION; Schema: public; Owner: insight
--

CREATE OR REPLACE FUNCTION public.notify_pset_mapping() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	IF (TG_OP = 'DELETE') THEN
       PERFORM pg_notify('pset_mapping_data_channel',json_build_object('operation',0,'record',OLD)::text);
	   RETURN OLD;
	ELSIF (TG_OP = 'INSERT') THEN
       PERFORM pg_notify('pset_mapping_data_channel',json_build_object('operation',1,'record',NEW)::text);
	   RETURN NEW;
	ELSE
       PERFORM pg_notify('pset_mapping_data_channel',json_build_object('operation',2,'record',NEW)::text);
       RETURN NEW;
	END IF;
END;
$$;


ALTER FUNCTION public.notify_pset_mapping() OWNER TO insight;

--
-- Name: notify_qx_general_settings_mapping(); Type: FUNCTION; Schema: public; Owner: insight
--

CREATE OR REPLACE FUNCTION public.notify_qx_general_settings_mapping() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    PERFORM pg_notify('qx_tool_general_setting_channel',json_build_object('operation',2,'record',NEW)::text);
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.notify_qx_general_settings_mapping() OWNER TO insight;

--
-- Name: notify_toolsnet_settings(); Type: FUNCTION; Schema: public; Owner: insight
--
CREATE OR REPLACE FUNCTION public.notify_toolsnet_settings() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE
  BEGIN
    IF (TG_OP = 'DELETE') THEN
      PERFORM pg_notify('toolsnet_settings_channel_' || array_to_string (old.fld_toolmacaddress,''),json_build_object('operation',0)::text);
      PERFORM pg_notify('toolsnet_settings_channel',json_build_object('MacAddress',array_to_string(old.fld_toolmacaddress,'.'),'operation',0,'record',OLD)::text);
      RETURN OLD;
    ELSIF (TG_OP = 'INSERT') THEN
      --raise notice 'insert trigger';   
      PERFORM pg_notify('toolsnet_settings_channel',json_build_object('MacAddress',array_to_string(new.fld_toolmacaddress,'.'),'operation',1,'record',NEW)::text);
      RETURN NEW;
    ELSIF (TG_OP = 'UPDATE') THEN
      --raise notice 'update trigger';
      PERFORM pg_notify('toolsnet_settings_channel_' || array_to_string (new.fld_toolmacaddress,''),json_build_object('MacAddress',array_to_string(new.fld_toolmacaddress,'.'),'operation',2,'record',NEW)::text);
      PERFORM pg_notify('toolsnet_settings_channel',json_build_object('MacAddress',array_to_string(new.fld_toolmacaddress,'.'),'operation',2,'record',NEW)::text);
	  RETURN NEW;
    ELSE 
      PERFORM pg_notify('toolsnet_settings_channel',json_build_object('operation',3));
      RETURN NEW;
    END IF;
  END;
$$;


ALTER FUNCTION public.notify_toolsnet_settings() OWNER TO insight;

--
-- Name: notify_pfop_settings(); Type: FUNCTION; Schema: public; Owner: insight
--
CREATE OR REPLACE FUNCTION public.notify_pfop_settings() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE
  BEGIN
    IF (TG_OP = 'DELETE') THEN
      PERFORM pg_notify('pfop_settings_channel',json_build_object('MacAddress',array_to_string(new.fld_toolmacaddress,'.'),'operation',0,'record',OLD)::text);
      RETURN OLD;
    ELSIF (TG_OP = 'INSERT') THEN
      --raise notice 'insert trigger';   
      PERFORM pg_notify('pfop_settings_channel',json_build_object('MacAddress',array_to_string(new.fld_toolmacaddress,'.'),'operation',1,'record',NEW)::text);
      RETURN NEW;
    ELSIF (TG_OP = 'UPDATE') THEN
      --raise notice 'update trigger';
      PERFORM pg_notify('pfop_settings_channel',json_build_object('MacAddress',array_to_string(new.fld_toolmacaddress,'.'),'operation',2,'record',NEW)::text);
      RETURN NEW;
    ELSE 
      PERFORM pg_notify('pfop_settings_channel',json_build_object('operation',3));
      RETURN NEW;
    END IF;
  END;
$$;

ALTER FUNCTION public.notify_pfop_settings() OWNER TO insight;

--
-- Name: notify_pfcs_settings(); Type: FUNCTION; Schema: public; Owner: insight
--
CREATE OR REPLACE FUNCTION public.notify_pfcs_settings() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE
  BEGIN
    IF (TG_OP = 'DELETE') THEN
      PERFORM pg_notify('pfcs_settings_channel',json_build_object('operation',0,'record',OLD)::text);
      RETURN OLD;
    ELSIF (TG_OP = 'INSERT') THEN
      --raise notice 'insert trigger';   
      PERFORM pg_notify('pfcs_settings_channel',json_build_object('operation',1,'record',NEW)::text);
      RETURN NEW;
    ELSIF (TG_OP = 'UPDATE') THEN
      --raise notice 'update trigger';
      PERFORM pg_notify('pfcs_settings_channel',json_build_object('operation',2,'record',NEW)::text);
      RETURN NEW;
    ELSE 
      PERFORM pg_notify('pfcs_settings_channel',json_build_object('operation',3));
      RETURN NEW;
    END IF;
  END;
$$;

ALTER FUNCTION public.notify_pfcs_settings() OWNER TO insight;

--
-- Name: notify_system_info_setting(); Type: FUNCTION; Schema: public; Owner: insight
--
CREATE OR REPLACE FUNCTION public.notify_system_info_setting() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    PERFORM pg_notify('system_info_data_channel',json_build_object('operation',2,'record',NEW)::text);
    RETURN NEW;
END;
$$;

ALTER FUNCTION public.notify_system_info_setting() OWNER TO insight;

--
-- Name: notify_date_time_setting(); Type: FUNCTION; Schema: public; Owner: insight
--
CREATE OR REPLACE FUNCTION public.notify_date_time_setting() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    PERFORM pg_notify('date_time_data_channel',json_build_object('operation',2,'record',NEW)::text);
    RETURN NEW;
END;
$$;

ALTER FUNCTION public.notify_date_time_setting() OWNER TO insight;

--
-- Name: notify_permanent_tool_data(); Type: FUNCTION; Schema: public; Owner: insight
--

CREATE OR REPLACE FUNCTION public.notify_permanent_tool_data() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF (TG_OP = 'INSERT') THEN
       PERFORM pg_notify('permanent_tool_data_channel',json_build_object('operation',1,'record',NEW)::text);
       RETURN NEW;
    ELSE
       PERFORM pg_notify('permanent_tool_data_channel',json_build_object('operation',2,'record',NEW)::text);
       RETURN NEW;
    END IF;
END;
$$;

ALTER FUNCTION public.notify_permanent_tool_data() OWNER TO insight;

--
-- Name: notify_job_list(); Type: FUNCTION; Schema: public; Owner: insight
--
CREATE OR REPLACE FUNCTION public.notify_job_list() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    PERFORM pg_notify('job_list_channel',json_build_object('operation',2,'record',NEW)::text);
    RETURN NEW;
END;
$$;

ALTER FUNCTION public.notify_job_list() OWNER TO insight;

--
-- Name: notify_eor_logs(); Type: FUNCTION; Schema: public; Owner: insight
--

CREATE OR REPLACE FUNCTION public.notify_eor_logs() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE
  BEGIN
    IF (TG_OP = 'INSERT') THEN
      --raise notice 'insert trigger';   
      PERFORM pg_notify('eor_event_channel_' || array_to_string (new.fld_toolmacaddress,''),json_build_object('lifetime_cyclecount',NEW.fld_tool_lifetime_cycle_count)::text);
      RETURN NEW;
    END IF;
  END;
$$;

ALTER FUNCTION public.notify_eor_logs() OWNER TO insight;

--
-- Name: notify_trace_logs(); Type: FUNCTION; Schema: public; Owner: insight
--

CREATE OR REPLACE FUNCTION public.notify_trace_logs() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE
  BEGIN
    IF (TG_OP = 'INSERT') THEN
      --raise notice 'insert trigger';   
      PERFORM pg_notify('trace_event_channel_' || array_to_string (new.fld_toolmacaddress,''),json_build_object('controller_cycle_number',NEW.fld_controller_cycle_number)::text);
      RETURN NEW;
    END IF;
  END;
$$;

ALTER FUNCTION public.notify_trace_logs() OWNER TO insight;

--
-- Name: notify_barcode_settings(); Type: FUNCTION; Schema: public; Owner: insight
--

CREATE OR REPLACE FUNCTION public.notify_barcode_settings() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE
  BEGIN
    IF (TG_OP = 'DELETE') THEN
      PERFORM pg_notify('barcode_settings_channel',json_build_object('operation',0,'fld_toolmacaddress',OLD.fld_toolmacaddress)::text);
	  PERFORM pg_notify('barcode_settings_channel_' || array_to_string (old.fld_toolmacaddress,''),json_build_object('operation',0)::text);
      RETURN OLD;
    ELSIF (TG_OP = 'INSERT') THEN
      --raise notice 'insert trigger';   
      PERFORM pg_notify('barcode_settings_channel',json_build_object('operation',1,'fld_toolmacaddress',NEW.fld_toolmacaddress,'fld_port_number',NEW.fld_port_number,'fld_barcode_source',NEW.fld_barcode_source)::text);
      RETURN NEW;
    ELSIF (TG_OP = 'UPDATE') THEN
      --raise notice 'update trigger';
      PERFORM pg_notify('barcode_settings_channel',json_build_object('operation',2,'fld_toolmacaddress',NEW.fld_toolmacaddress)::text);
	  PERFORM pg_notify('barcode_settings_channel_' || array_to_string (new.fld_toolmacaddress,''),json_build_object('MacAddress',array_to_string(new.fld_toolmacaddress,'.'),'operation',2,'record',NEW)::text);
      RETURN NEW;
    ELSE 
      PERFORM pg_notify('barcode_settings_channel',json_build_object('operation',3));
      RETURN NEW;
    END IF;
  END;
$$;

ALTER FUNCTION public.notify_barcode_settings() OWNER TO insight;

--
-- Name: notify_accessories_setting(); Type: FUNCTION; Schema: public; Owner: insight
--

CREATE OR REPLACE FUNCTION public.notify_accessories_setting() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE
  BEGIN
    IF (TG_OP = 'DELETE') THEN
      PERFORM pg_notify('accessories_setting_channel',json_build_object('operation',0,'record',OLD)::text);
      RETURN OLD;
    ELSIF (TG_OP = 'INSERT') THEN
      --raise notice 'insert trigger';  
      PERFORM pg_notify('accessories_setting_channel',json_build_object('operation',1,'record',NEW)::text);
      RETURN NEW;
    ELSIF (TG_OP = 'UPDATE') THEN
      --raise notice 'update trigger';
      PERFORM pg_notify('accessories_setting_channel',json_build_object('operation',2,'record',NEW)::text);
      RETURN NEW;
    ELSE
      PERFORM pg_notify('accessories_setting_channel',json_build_object('operation',3));
      RETURN NEW;
    END IF;
  END;
$$;

ALTER FUNCTION public.notify_accessories_setting() OWNER TO insight;


--
-- Name: notify_user_session(); Type: FUNCTION; Schema: public; Owner: insight
--

CREATE OR REPLACE FUNCTION public.notify_user_session() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE
  BEGIN
    IF (TG_OP = 'DELETE') THEN
      PERFORM pg_notify('user_session',json_build_object('operation',0,'record',OLD)::text);
      RETURN OLD;
    ELSIF (TG_OP = 'UPDATE') THEN
      -- raise notice 'update trigger';
      PERFORM pg_notify('user_session',json_build_object('userID',NEW.fld_user_id,'new_diagMode',NEW.fld_diagnostic_mode,'module_name',NEW.fld_locked_module_name,'old_module_name',OLD.fld_locked_module_name,'operation',1,'old_diagMode', OLD.fld_diagnostic_mode)::text);
      RETURN NEW;
    ELSE 
      PERFORM pg_notify('user_session',json_build_object('operation',2));
      RETURN NEW;
    END IF;
  END;
$$;

ALTER FUNCTION public.notify_user_session() OWNER TO insight;

--
-- Name: notify_pokayoke_settings(); Type: FUNCTION; Schema: public; Owner: insight
--
CREATE OR REPLACE FUNCTION public.notify_pokayoke_settings() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE
  BEGIN
    IF (TG_OP = 'DELETE') THEN
      PERFORM pg_notify('pokayoke_setting_channel',json_build_object('operation',0,'record',OLD)::text);
      RETURN OLD;
    ELSIF (TG_OP = 'INSERT') THEN
      --raise notice 'insert trigger';   
      PERFORM pg_notify('pokayoke_setting_channel',json_build_object('operation',1,'record',NEW)::text);
      RETURN NEW;
    ELSIF ((TG_OP = 'UPDATE') AND ((OLD.fld_enable_status != NEW.fld_enable_status) OR (OLD.fld_communication_log != NEW.fld_communication_log) OR (OLD.fld_step_flow != NEW.fld_step_flow) OR (OLD.fld_pokayoke_source != NEW.fld_pokayoke_source))) THEN
      --raise notice 'update trigger';
      PERFORM pg_notify('pokayoke_setting_channel',json_build_object('operation',2,'record',NEW)::text);
      RETURN NEW;
    ELSE 
      PERFORM pg_notify('pokayoke_setting_channel',json_build_object('operation',3,'record',NEW)::text);
      RETURN NEW;
    END IF;
  END;
$$;

ALTER FUNCTION public.notify_pokayoke_settings() OWNER TO insight;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: tbl_controller_settings; Type: TABLE; Schema: public; Owner: insight
--

CREATE TABLE public.tbl_controller_settings (
    fld_pan_id integer,
    fld_rf_channel smallint,
    fld_tx_power_level smallint,
    fld_radio_fw_version text,
    fld_radio_mac_address integer[],
    fld_is_modified smallint,
    fld_pkey smallint NOT NULL,
    fld_ext_radio smallint DEFAULT 0 NOT NULL,
    fld_tcp_enable_status smallint DEFAULT 0 NOT NULL,
    fld_ethportselected smallint DEFAULT 0 NOT NULL,
    fld_lan_port_no integer DEFAULT 6565 NOT NULL
);


ALTER TABLE public.tbl_controller_settings OWNER TO insight;

--
-- Name: tbl_date_and_time_settings; Type: TABLE; Schema: public; Owner: insight
--

CREATE TABLE public.tbl_date_and_time_settings (
    fld_dst smallint,
    fld_time_format smallint,
    fld_date_format smallint,
    fld_setting_mode smallint,
    fld_epoch_time bigint,
    fld_ntps_server_name text,
    fld_dst_zone text,
    fld_time_zone text,
    fld_pkey smallint NOT NULL
);


ALTER TABLE public.tbl_date_and_time_settings OWNER TO insight;

--
-- Name: tbl_energy_scan_data; Type: TABLE; Schema: public; Owner: insight
--

CREATE TABLE public.tbl_energy_scan_data (
    fld_epoch_time bigint,
    fld_duration smallint,
    fld_scan_results smallint[]
);


ALTER TABLE public.tbl_energy_scan_data OWNER TO insight;

--
-- Name:  tbl_eor_logs; Type: TABLE; Schema: public; Owner: insight
--

CREATE TABLE public.tbl_eor_logs (
    fld_controller_cycle_number integer NOT NULL,
    fld_job_cycle_number integer,
    fld_job_id smallint,
    fld_pset_id smallint,
    fld_pset_name text,
    fld_tool_location_id integer,
    fld_tool_lifetime_cycle_count integer,
    fld_tool_cycle_count integer,
    fld_cycle_status smallint,
    fld_current_batch_count smallint,
    fld_total_batch_count smallint,
    fld_torque_display_units smallint,
    fld_step_number smallint,
    fld_fault_word integer,
    fld_peak_torque real,
    fld_final_angle integer,
    fld_current_at_peak_torque real,
    fld_target real,
    fld_torque_high_limit real,
    fld_torque_low_limit real,
    fld_angle_high_limit integer,
    fld_angle_low_limit integer,
    fld_torque_result smallint,
    fld_angle_result smallint,
    fld_strategy smallint,
    fld_time_stamp bigint,
    fld_free_speed real,
    fld_down_shift_speed real,
    fld_max_tool_speed real,
    fld_torque_tr real,
    fld_tool_serial_number text,
    fld_identifier1 text,
    fld_operator_alias text,
    fld_job_name text,
    fld_trace_available smallint,
    fld_trace_request_for_pset smallint,
    fld_job_fault_type smallint,
    fld_job_status smallint,
    fld_toho_status smallint,
    fld_free_run_angle_status smallint,
    fld_tightening_time_status smallint,
    fld_free_run_angle real,
    fld_tightening_time integer,
    fld_cycle_retry smallint,
    fld_ets_mode smallint,
    fld_job_modified_time bigint,
    fld_identifier2 text,
    fld_identifier3 text,
    fld_identifier4 text,
    fld_tool_name text,
    fld_toolmacaddress integer[],
    fld_station_name text,
    fld_assembly_name text,
    fld_prevailing_torque real,
    fld_application_id integer
);


ALTER TABLE public.tbl_eor_logs OWNER TO insight;

--
-- Name: tbl_eor_tn; Type: TABLE; Schema: public; Owner: insight
--

CREATE TABLE public.tbl_eor_tn (
    fld_controller_cycle_number integer NOT NULL,
    fld_job_cycle_number integer,
    fld_job_id smallint,
    fld_pset_id smallint,
    fld_pset_name text,
    fld_tool_location_id integer,
    fld_tool_lifetime_cycle_count integer,
    fld_tool_cycle_count integer,
    fld_cycle_status smallint,
    fld_current_batch_count smallint,
    fld_total_batch_count smallint,
    fld_torque_display_units smallint,
    fld_step_number smallint,
    fld_fault_word integer,
    fld_peak_torque real,
    fld_final_angle integer,
    fld_current_at_peak_torque real,
    fld_target real,
    fld_torque_high_limit real,
    fld_torque_low_limit real,
    fld_angle_high_limit integer,
    fld_angle_low_limit integer,
    fld_torque_result smallint,
    fld_angle_result smallint,
    fld_strategy smallint,
    fld_time_stamp bigint,
    fld_free_speed real,
    fld_down_shift_speed real,
    fld_max_tool_speed real,
    fld_torque_tr real,
    fld_tool_serial_number text,
    fld_identifier1 text,
    fld_operator_alias text,
    fld_job_name text,
    fld_trace_available smallint,
    fld_trace_request_for_pset smallint,
    fld_job_fault_type smallint,
    fld_job_status smallint,
    fld_toho_status smallint,
    fld_free_run_angle_status smallint,
    fld_tightening_time_status smallint,
    fld_free_run_angle real,
    fld_tightening_time integer,
    fld_cycle_retry smallint,
    fld_ets_mode smallint,
    fld_job_modified_time bigint,
    fld_identifier2 text,
    fld_identifier3 text,
    fld_identifier4 text,
    fld_tool_name text,
    fld_toolmacaddress integer[],
    fld_station_name text,
    fld_assembly_name text,
    fld_prevailing_torque real,
    fld_application_id integer
);


ALTER TABLE public.tbl_eor_tn OWNER TO insight;
--
-- Name: tbl_ethernet_settings; Type: TABLE; Schema: public; Owner: insight
--

CREATE TABLE public.tbl_ethernet_settings (
    fld_eth0configuration smallint,
    fld_eth0linkstatus smallint,
    fld_eth0portlinkspeed smallint,
    fld_eth0portpridnsstatus smallint,
    fld_eth0portsecdnsstatus smallint,
    fld_eth0portipaddress text,
    fld_eth0portsubnetmask text,
    fld_eth0portgetway text,
    fld_eth0portpridnsserver text,
    fld_eth0portsecdnsserver text,
    fld_eth0macaddress text,
    fld_eth1configuration smallint,
    fld_eth1linkstatus smallint,
    fld_eth1portlinkspeed smallint,
    fld_eth1portpridnsstatus smallint,
    fld_eth1portsecdnsstatus smallint,
    fld_eth1portipaddress text,
    fld_eth1portsubnetmask text,
    fld_eth1portgetway text,
    fld_eth1portpridnsserver text,
    fld_eth1portsecdnsserver text,
    fld_eth1macaddress text,
    fld_pkey smallint NOT NULL
);


ALTER TABLE public.tbl_ethernet_settings OWNER TO insight;

--
-- Name: tbl_event_logs; Type: TABLE; Schema: public; Owner: insight
--

CREATE TABLE public.tbl_event_logs (
    fld_event_log_id integer NOT NULL,
    fld_event_log_number integer,
    fld_event_log_timestamp bigint,
	fld_tool_serial_number text
);


ALTER TABLE public.tbl_event_logs OWNER TO insight;

--
-- Name: tbl_event_logs_fld_event_id_seq; Type: SEQUENCE; Schema: public; Owner: insight
--

CREATE SEQUENCE public.tbl_event_logs_fld_event_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_event_logs_fld_event_id_seq OWNER TO insight;

--
-- Name: tbl_event_logs_fld_event_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: insight
--

ALTER SEQUENCE public.tbl_event_logs_fld_event_id_seq OWNED BY public.tbl_event_logs.fld_event_log_id;

--
-- Name: tbl_audit_logs; Type: TABLE; Schema: public; Owner: insight
--

CREATE TABLE public.tbl_audit_logs (
    fld_audit_log_id integer NOT NULL,
    fld_audit_username text, 
    fld_audit_field_code text[], 
    fld_audit_desc_code text, 
    fld_audit_old_value text[], 
    fld_audit_new_value text[],
    fld_audit_log_timestamp bigint
);


ALTER TABLE public.tbl_audit_logs OWNER TO insight;

--
-- Name: tbl_audit_logs_fld_audit_id_seq; Type: SEQUENCE; Schema: public; Owner: insight
--

CREATE SEQUENCE public.tbl_audit_logs_fld_audit_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_audit_logs_fld_audit_id_seq OWNER TO insight;


--
-- Name: tbl_audit_logs_fld_audit_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: insight
--

ALTER SEQUENCE public.tbl_audit_logs_fld_audit_id_seq OWNED BY public.tbl_audit_logs.fld_audit_log_id;


--
-- Name: tbl_factory_settings; Type: TABLE; Schema: public; Owner: insight
--

CREATE TABLE public.tbl_factory_settings (
    fld_sys_model_no text,
    fld_sys_serial_no text,
    fld_radio_fw_version text,
    fld_radio_mac_address text
);


ALTER TABLE public.tbl_factory_settings OWNER TO insight;

--
-- Name: tbl_feature_license_data; Type: TABLE; Schema: public; Owner: insight
--

CREATE TABLE public.tbl_feature_license_data (
    fld_license_activation_date text,
    fld_license_expiry_date integer,
    fld_license_id text,
    fld_license_type text,
    fld_license_feature_enabled smallint,
    fld_license_parse_status smallint,
    fld_license_sata_id text,
    fld_license_feature text[]
);


ALTER TABLE public.tbl_feature_license_data OWNER TO insight;

--
-- Name: tbl_job_list; Type: TABLE; Schema: public; Owner: insight
--

CREATE TABLE public.tbl_job_list (
    fld_job_id integer NOT NULL,
    fld_total_pset_count smallint,
    fld_tool_enabled_interlock smallint,
    fld_valid_job_interlock smallint,
    fld_barcode_interlock smallint,
    fld_socket_selection_interlock smallint,
    fld_tool_disable_reverse_interlock smallint,
    fld_jobdt bigint,
    fld_profile_type smallint,
    fld_job_name text NOT NULL,
    fld_min_toolmax_torque double precision,
    fld_lock_on_rescan smallint DEFAULT 0 NOT NULL
);


ALTER TABLE public.tbl_job_list OWNER TO insight;

--
-- Name: tbl_job_list_fld_job_id_seq; Type: SEQUENCE; Schema: public; Owner: insight
--

CREATE SEQUENCE public.tbl_job_list_fld_job_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_job_list_fld_job_id_seq OWNER TO insight;

--
-- Name: tbl_job_list_fld_job_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: insight
--

ALTER SEQUENCE public.tbl_job_list_fld_job_id_seq OWNED BY public.tbl_job_list.fld_job_id;


--
-- Name: tbl_job_mapping; Type: TABLE; Schema: public; Owner: insight
--

CREATE TABLE public.tbl_job_mapping (
    fld_toolmacaddress integer[],
    fld_controller_job_id integer,
    fld_tool_job_id integer,
    fld_application_id integer
);


ALTER TABLE public.tbl_job_mapping OWNER TO insight;

--
-- Name: tbl_job_pset_details; Type: TABLE; Schema: public; Owner: insight
--

CREATE TABLE public.tbl_job_pset_details (
    fld_job_id integer NOT NULL,
    fld_pset_id integer NOT NULL,
    fld_pset_batch_count smallint,
    fld_max_nok_status smallint,
    fld_pass_next_pset_id integer,
    fld_reset_to_pset integer,
    fld_socket_id smallint,
    fld_fail_rules_count smallint
);


ALTER TABLE public.tbl_job_pset_details OWNER TO insight;

--
-- Name: tbl_job_pset_fail_rules; Type: TABLE; Schema: public; Owner: insight
--

CREATE TABLE public.tbl_job_pset_fail_rules (
    fld_job_id integer NOT NULL,
    fld_pset_id integer NOT NULL,
    fld_failure_type smallint,
    fld_failure_action smallint,
    fld_jump_to_pset integer,
    fld_retry_count smallint,
    fld_retry_action smallint,
    fld_fail_rule_id smallint NOT NULL,
    fld_pset_index smallint
);


ALTER TABLE public.tbl_job_pset_fail_rules OWNER TO insight;

--
-- Name: tbl_master_tool_data; Type: TABLE; Schema: public; Owner: insight
--

CREATE TABLE public.tbl_master_tool_data (
    fld_toolmacaddress integer[] NOT NULL,
    fld_tool_serial_number text,
    fld_tool_name text,
    fld_ip_address text,
    fld_operator_name text,
    fld_operator_source smallint,
    fld_boot_job smallint NOT NULL,
    fld_job_selection_type smallint NOT NULL,
    fld_persist_io_on_disconnect smallint NOT NULL,
    fld_ethernet_port smallint NOT NULL,
    fld_tool_position smallint NOT NULL,
    fld_binary_job_selection_type smallint DEFAULT 0 NOT NULL,
    fld_tool_ip_address text DEFAULT '0.0.0.0' NOT NULL,
    fld_ip_alias_status smallint DEFAULT 0 NOT NULL,
    fld_interfacetype smallint DEFAULT 1 NOT NULL,
    fld_application_id integer
);


ALTER TABLE public.tbl_master_tool_data OWNER TO insight;

--
-- Name: tbl_permanent_tool_data; Type: TABLE; Schema: public; Owner: insight
--

CREATE TABLE public.tbl_permanent_tool_data (
    fld_toolmacaddress integer[],
    fld_message_type smallint,
    fld_location_id integer,
    fld_tool_max_torque double precision,
    fld_tool_max_output_speed integer,
    fld_factory_tr double precision,
    fld_tool_model_number text,
    fld_tool_serial_number text,
    fld_ets_tool smallint,
    fld_tool_type smallint,
    fld_number_motor_poles smallint,
    fld_checksum smallint
);


ALTER TABLE public.tbl_permanent_tool_data OWNER TO insight;

--
-- Name: tbl_pset_details; Type: TABLE; Schema: public; Owner: insight
--

CREATE TABLE public.tbl_pset_details (
    fld_pset_id integer NOT NULL,
    fld_acceleration double precision,
    fld_angle_high_limit integer,
    fld_angle_low_limit integer,
    fld_control_flags integer,
    fld_free_speed double precision,
    fld_motor_speed double precision,
    fld_down_shift_speed double precision,
    fld_shift_down_torque double precision,
    fld_shift_down_type smallint,
    fld_step_number smallint NOT NULL,
    fld_step_timeout integer,
    fld_step_type smallint,
    fld_target double precision,
    fld_threshold_for_counting_angle double precision,
    fld_torque_high_limit double precision,
    fld_torque_low_limit double precision
);


ALTER TABLE public.tbl_pset_details OWNER TO insight;

--
-- Name: tbl_pset_list; Type: TABLE; Schema: public; Owner: insight
--

CREATE TABLE public.tbl_pset_list (
    fld_pset_id integer NOT NULL,
    fld_pset_name text NOT NULL,
    fld_step_count smallint,
    fld_torque_unit smallint,
    fld_cycle_delay integer,
    fld_current_plausibility_enabled smallint,
    fld_current_plausibility_high_limit double precision,
    fld_current_plausibility_low_limit double precision,
    fld_total_gang_count smallint,
    fld_tubenut_rev_speed double precision,
    fld_tubenut_torque_threshold double precision,
    fld_current_gang_count smallint,
    fld_auto_increment smallint,
    fld_tightening_mode smallint,
    fld_reset_pset_id smallint,
    fld_assembly_complete_enable smallint,
    fld_ets_mode smallint,
    fld_curve_transfer_settings integer,
    fld_socket_selection smallint,
    fld_current_step smallint,
    fld_fastening_time_high_limit integer,
    fld_fastening_time_low_limit integer,
    fld_free_run_angle_high integer,
    fld_free_run_angle_low integer,
    fld_tr_correction_factor double precision,
    fld_pset_modified_date bigint,
    fld_profile_type smallint,
    fld_trace_torque_threshold double precision,
    fld_min_toolmax_torque double precision,
    fld_min_valid_etstool integer,
    fld_rehit_settings smallint DEFAULT 0 NOT NULL
);


ALTER TABLE public.tbl_pset_list OWNER TO insight;

--
-- Name: tbl_pset_list_fld_pset_id_seq; Type: SEQUENCE; Schema: public; Owner: insight
--

CREATE SEQUENCE public.tbl_pset_list_fld_pset_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_pset_list_fld_pset_id_seq OWNER TO insight;

--
-- Name: tbl_modifed_job; Type: TABLE; Schema: public; Owner: insight
--

CREATE TABLE public.tbl_modifed_job (
    fld_modified_job_id integer,
    fld_toolmacaddress integer[],
    fld_application_id integer
);

ALTER TABLE public.tbl_modifed_job OWNER TO insight;

--
-- Name: tbl_pset_list_fld_pset_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: insight
--

ALTER SEQUENCE public.tbl_pset_list_fld_pset_id_seq OWNED BY public.tbl_pset_list.fld_pset_id;

--
-- Name: tbl_pset_mapping; Type: TABLE; Schema: public; Owner: insight
--

CREATE TABLE public.tbl_pset_mapping (
    fld_toolmacaddress integer[],
    fld_controller_pset_id integer,
    fld_tool_pset_id smallint,
    fld_num_jobs_shared smallint,
    fld_dirty_flag smallint
);


ALTER TABLE public.tbl_pset_mapping OWNER TO insight;

--
-- Name: tbl_system_info; Type: TABLE; Schema: public; Owner: insight
--

CREATE TABLE public.tbl_system_info (
    fld_plant_name text,
    fld_assembly_name text,
    fld_station_name text,
    fld_job text,
    fld_language text,
    fld_max_page_size smallint,
    fld_brightness smallint,
    fld_orientation smallint,
    fld_pkey smallint NOT NULL
);


ALTER TABLE public.tbl_system_info OWNER TO insight;

--
-- Name: tbl_temporary_tool_data; Type: TABLE; Schema: public; Owner: insight
--

CREATE TABLE public.tbl_temporary_tool_data (
    fld_toolmacaddress integer[],
    fld_location_id integer,
    fld_messaget_ype smallint,
    fld_life_time_cycle_count integer,
    fld_pulse_count integer,
    fld_tool_display_firmware_version bigint,
    fld_tool_motor_firmware_version bigint,
    fld_tool_radio_firmware_version bigint,
    fld_current_faults bigint,
    fld_selected_config smallint,
    fld_user_tr double precision,
    fld_asc double precision,
    fld_tool_direction smallint,
    fld_in_cycle smallint,
    fld_offline_eor integer,
    fld_checksum smallint
);


ALTER TABLE public.tbl_temporary_tool_data OWNER TO insight;

--
-- Name: tbl_time_zones; Type: TABLE; Schema: public; Owner: insight
--

CREATE TABLE public.tbl_time_zones (
    fld_label text,
    fld_time_zone text,
    fld_offset integer,
    fld_dst_enable smallint,
    fld_dst_zone text,
    fld_pkey smallint NOT NULL
);


ALTER TABLE public.tbl_time_zones OWNER TO insight;

--
-- Name: tbl_tool_general_settings; Type: TABLE; Schema: public; Owner: insight
--

CREATE TABLE public.tbl_tool_general_settings (
    fld_toolmacaddress integer[],
    fld_password integer,
    fld_interlock_enabled smallint,
    fld_config_select_mode smallint,
    fld_enable_headlight smallint,
    fld_headlight_timeout integer,
    fld_sleep_timeout integer,
    fld_keypad_lockout smallint,
    fld_theft_lock smallint,
    fld_location_id integer,
    fld_wireless_retry_enabled smallint,
    fld_theft_lock_counter integer,
    fld_archaving_enabled smallint,
    fld_smart_socket_enabled smallint,
    fld_tubenut_mode integer,
    fld_spare integer,
    fld_mask integer,
    fld_application_id integer
);


ALTER TABLE public.tbl_tool_general_settings OWNER TO insight;

--
-- Name: tbl_tool_license_data; Type: TABLE; Schema: public; Owner: insight
--

CREATE TABLE public.tbl_tool_license_data (
    fld_license_activation_date text,
    fld_license_parse_status smallint,
    fld_license_sata_id text,
    fld_license_max_no_tools smallint,
    fld_license_expiry_date integer,
    fld_license_id text
);


ALTER TABLE public.tbl_tool_license_data OWNER TO insight;

--
-- Name: tbl_tool_position; Type: TABLE; Schema: public; Owner: insight
--

CREATE TABLE public.tbl_tool_position (
    fld_toolmacaddress integer[],
    fld_tool_pair_status smallint,
    fld_application_id integer
);


ALTER TABLE public.tbl_tool_position OWNER TO insight;

--
-- Name: tbl_toolsnet_settings; Type: TABLE; Schema: public; Owner: insight
--

CREATE TABLE public.tbl_toolsnet_settings (
    fld_pim_port_num integer,
    fld_station_num smallint,
    fld_system_num smallint,
    fld_toolsnet_enable smallint,
    fld_communication_log smallint,
    fld_keepalive_interval smallint,
    fld_max_retry smallint,
    fld_retry_interval smallint,
    fld_system_type smallint,
    fld_conn_retry_interval smallint,
    fld_pim_ipaddress text,
    fld_spindle_name text,
    fld_station_name text,
    fld_system_name text,
    fld_toolmacaddress integer[],
    fld_application_id integer
);


ALTER TABLE public.tbl_toolsnet_settings OWNER TO insight;

--
-- Name: tbl_trace_logs; Type: TABLE; Schema: public; Owner: insight
--

CREATE TABLE public.tbl_trace_logs (
    fld_controller_cycle_number bigint,
    fld_trace_length integer,
    fld_trace_settings bigint,
    fld_torque_tr real,
    fld_sample_rate integer,
    fld_torque_offset integer,
    fld_asc real,
    fld_torque_high_limit real,
    fld_torque_low_limit real,
    fld_angle_high_limit integer,
    fld_angle_low_limit integer,
    fld_final_angle integer DEFAULT 0 NOT NULL,
    fld_trace_data_pt integer[],
    fld_toolmacaddress integer[],
    fld_application_id integer
);


ALTER TABLE public.tbl_trace_logs OWNER TO insight;

--
-- Name: tbl_eor_headers; Type: TABLE; Schema: public; Owner: insight
--

CREATE TABLE public.tbl_eor_headers (
    fld_id integer NOT NULL,
    fld_status smallint,
    fld_display_name text,
    fld_field text
);

ALTER TABLE public.tbl_eor_headers OWNER TO insight;

--
-- Name: tbl_security; Type: TABLE; Schema: public; Owner: insight
--

CREATE TABLE public.tbl_security (
    fld_user_id integer NOT NULL,
    fld_first_name text,
    fld_last_name text, 
    fld_user_name text, 
    fld_alias_name text, 
    fld_password text, 
    fld_session_timeout smallint, 
    fld_role text, 
    fld_login_status smallint, 
    fld_login_mode smallint, 
    fld_locked_job_id integer,
    fld_change_password boolean default false,
    fld_locked_pset_list text,
    fld_pairing_initiated smallint,
    fld_simplified_login smallint default 0 NOT NULL
);

ALTER TABLE public.tbl_security OWNER TO insight;

--
-- Name: tbl_security_fld_user_id_seq; Type: SEQUENCE; Schema: public; Owner: insight
--

CREATE SEQUENCE public.tbl_security_fld_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_security_fld_user_id_seq OWNER TO insight;

--
-- Name: tbl_security_fld_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: insight
--

ALTER SEQUENCE public.tbl_security_fld_user_id_seq OWNED BY public.tbl_security.fld_user_id;

--
-- Name: tbl_session; Type: TABLE; Schema: public; Owner: insight
--

CREATE TABLE public.tbl_session (
sid varchar NOT NULL COLLATE "default",
sess json NOT NULL,
expire timestamp(6) NOT NULL,
fld_user_id integer,
fld_locked_job_id integer[], 
fld_locked_pset_id integer[],
fld_login_mode integer,
fld_locked_module_name text,
fld_alias_name text,
fld_locked_user_id integer,
fld_diagnostic_mode text
)
WITH (OIDS=FALSE);

ALTER TABLE public.tbl_session OWNER TO insight;

--
-- Name: tbl_pfop_settings; Type: TABLE; Schema: public; Owner: insight
--
CREATE TABLE public.tbl_pfop_settings (
    fld_number_of_repeat smallint,
    fld_repeat_delay smallint,
    fld_ethernet_port_no integer,
    fld_cell_id integer,
    fld_channel_id smallint,
    fld_communication_log smallint,
    fld_enable_status smallint, 
    fld_controller_name text,
    fld_protocol_version text,
    fld_toolmacaddress integer[],
    fld_tool_enable_on_power_up smallint,
    fld_ip_aliasing smallint DEFAULT 1 NOT NULL,
    fld_job_off_status smallint DEFAULT 1 NOT NULL,
    fld_user_selected_torque_unit smallint DEFAULT 0 NOT NULL,
    fld_job_id_in_eor smallint DEFAULT 0 NOT NULL,
    fld_application_id integer
);

ALTER TABLE public.tbl_pfop_settings OWNER TO insight;

--
-- Name: tbl_fop_settings; Type: TABLE; Schema: public; Owner: insight
--
CREATE TABLE public.tbl_fop_settings (
    fld_number_of_repeat smallint,
    fld_repeat_delay smallint,
    fld_ethernet_port_no integer,
    fld_cell_id integer,
    fld_channel_id smallint,
    fld_communication_log smallint,
    fld_enable_status smallint, 
    fld_controller_name text,
    fld_protocol_version text,
    fld_toolmacaddress integer[],
    fld_ip_aliasing smallint DEFAULT 1 NOT NULL,
    fld_fop_defaults smallint DEFAULT 0 NOT NULL,
    fld_application_id integer
);

ALTER TABLE public.tbl_fop_settings OWNER TO insight;

--
-- Name: tbl_vwxml_settings; Type: TABLE; Schema: public; Owner: insight
--
CREATE TABLE public.tbl_vwxml_settings (
    fld_enable_status smallint,
    fld_communication_log smallint,
    fld_keep_alive_interval smallint,
    fld_retry_interval smallint,
    fld_port_a_number integer,
    fld_port_b_number integer,
    fld_protocol_version smallint,
    fld_time_value_status smallint DEFAULT 0 NOT NULL,
    fld_toolmacaddress integer[],
    fld_application_id integer
);

ALTER TABLE public.tbl_vwxml_settings OWNER TO insight;

CREATE TABLE public.tbl_tool_status (
    fld_tool_connection_status integer,
    fld_toolmacaddress integer[]
);

ALTER TABLE public.tbl_tool_status OWNER TO insight;

--
-- Name: tbl_pfcs_settings; Type: TABLE; Schema: public; Owner: insight
--
CREATE TABLE public.tbl_pfcs_settings (
    fld_enable_status smallint,
    fld_communication_log smallint,
    fld_connection_retry_timeout smallint,
    fld_message_timeout smallint,
    fld_keep_alive_timeout smallint,
    fld_retry_count smallint,
    fld_unsolicited_mode_status smallint, 
    fld_solicited_mode_status smallint,
    fld_format_mode smallint,
    fld_sever_ip_address text,
    fld_solicited_port_number integer,
    fld_solicited_machine_id text,
    fld_unsolicited_port_number integer,
    fld_unsolicited_machine_id text,
    fld_batch_result_status smallint,
    fld_store_on_disconnect_status smallint,
    fld_job_mapping text[]
);

ALTER TABLE public.tbl_pfcs_settings OWNER TO insight;

--
-- Name: tbl_pfcs_tool_settings; Type: TABLE; Schema: public; Owner: insight
--
CREATE TABLE public.tbl_pfcs_tool_settings (
    fld_enable_status smallint,
    fld_tool_machine_id text,
    fld_toolmacaddress integer[],
    fld_application_id integer
);

ALTER TABLE public.tbl_pfcs_tool_settings OWNER TO insight;

--
-- Name: tbl_dio_settings; Type: TABLE; Schema: public; Owner: insight
--
CREATE TABLE public.tbl_dio_settings (
    fld_remote_tool_enable smallint,
    fld_dio_source text DEFAULT 'None' NOT NULL,
    fld_modbus_ip_address text DEFAULT '0.0.0.0' NOT NULL,
    fld_no_of_inputs smallint,
    fld_input_bit_behaviour text[],
    fld_no_of_outputs smallint,
    fld_output_bit_behaviour text[],
    fld_toolmacaddress integer[],
    fld_label text DEFAULT 'None' NOT NULL,
    fld_application_id integer
);

ALTER TABLE public.tbl_dio_settings OWNER TO insight;

--
-- Name: tbl_fieldbus_settings; Type: TABLE; Schema: public; Owner: insight
--
CREATE TABLE public.tbl_fieldbus_settings (
    fld_tool_index smallint,
    fld_bus_control_status smallint,
    fld_communication_log smallint,
    fld_devicenet_slave_address smallint,
    fld_fielbus_baudrate smallint,
    fld_fieldbus_profile_type smallint,
    fld_fieldbus_selection_type smallint,
    fld_profibus_slave_address smallint,
    fld_remote_tool_enable smallint,
    fld_input_start_byte_position smallint,
    fld_input_end_byte_position smallint,
    fld_output_start_byte_position smallint,
    fld_output_end_byte_position smallint,
    fld_input_behaviour text[],
    fld_output_behaviour text[],
    fld_toolmacaddress integer[],
    fld_barcode_pass_through smallint DEFAULT 0 NOT NULL,
    fld_application_id integer
);

ALTER TABLE public.tbl_fieldbus_settings OWNER TO insight;

--
-- Name: tbl_backup_fieldbus_settings; Type: TABLE; Schema: public; Owner: insight
--
CREATE TABLE public.tbl_backup_fieldbus_settings (
    fld_bus_control_status smallint,
    fld_communication_log smallint,
    fld_devicenet_slave_address smallint,
    fld_fielbus_baudrate smallint,
    fld_fieldbus_profile_type smallint,
    fld_fieldbus_selection_type smallint,
    fld_profibus_slave_address smallint,
    fld_remote_tool_enable smallint,
    fld_input_start_byte_position smallint,
    fld_input_end_byte_position smallint,
    fld_output_start_byte_position smallint,
    fld_output_end_byte_position smallint,
    fld_input_behaviour text[],
    fld_output_behaviour text[],
    fld_toolmacaddress integer[],
    fld_toolserialnumber text,
    fld_barcode_pass_through smallint DEFAULT 0 NOT NULL,
    fld_application_id integer
);

ALTER TABLE public.tbl_backup_fieldbus_settings OWNER TO insight;

--
-- Name: tbl_used_license_ids; Type: TABLE; Schema: public; Owner: insight
--
CREATE TABLE public.tbl_used_license_ids (
	fld_license_ids text,
	fld_expiry integer
);

ALTER TABLE public.tbl_used_license_ids OWNER TO insight;

--
-- Name: tbl_boot_job_info; Type: TABLE; Schema: public; Owner: insight
--
CREATE TABLE public.tbl_boot_job_info (
    fld_active_job_id smallint,
    fld_active_pset_id smallint,
    fld_active_socket_id smallint,
    fld_tool_enable_status smallint,
    fld_barcode_interlock_status smallint,
    fld_socket_interlock_status smallint,
    fld_disable_on_fail_status smallint, 
    fld_max_nok_retry_count smallint,
    fld_max_nok_pass_cycle_count smallint,
    fld_job_status smallint,
    fld_modified_active_job_id smallint,
    fld_deleted_active_job_id smallint,
    fld_index smallint,
    fld_enable_state smallint,
    fld_socket_io smallint,
    fld_identifier_1 text,
    fld_identifier_2 text,
    fld_identifier_3 text,
    fld_identifier_4 text,
    fld_toolmacaddress integer[],
	fld_lock_on_rescan_status smallint DEFAULT 0 NOT NULL,
    fld_application_id integer
);

ALTER TABLE public.tbl_boot_job_info OWNER TO insight;


--
-- Name: tbl_barcode_settings; Type: TABLE; Schema: public; Owner: insight
--

CREATE TABLE public.tbl_barcode_settings (
    fld_enable_status smallint,
    fld_manual_barcode smallint,
    fld_queue_barcode smallint,
    fld_ignore_barcode smallint,
    fld_start smallint,
    fld_end smallint,
    fld_wildcard text,
    fld_job_selection smallint,	
    fld_free_order smallint,
    fld_scan_order integer[],
    fld_barcode_source text DEFAULT 'None' NOT NULL,
    fld_port_number integer,
    fld_toolmacaddress integer[],
    fld_application_id integer
);

ALTER TABLE public.tbl_barcode_settings OWNER TO insight;

--
-- Name: tbl_identifiers; Type: TABLE; Schema: public; Owner: insight
--

CREATE TABLE public.tbl_identifiers (
    fld_identifier_id smallint,
    fld_name text,
    fld_length_check smallint,
    fld_length smallint,
    fld_ignore_duplicate_scan smallint,
    fld_toolmacaddress integer[],
    fld_application_id integer
);

ALTER TABLE public.tbl_identifiers OWNER TO insight;

--
-- Name: tbl_barcode_job_mapping; Type: TABLE; Schema: public; Owner: insight
--

CREATE TABLE public.tbl_barcode_job_mapping (
    fld_job_id integer,
    fld_barcode_strings text[],
    fld_toolmacaddress integer[],
    fld_application_id integer
);

ALTER TABLE public.tbl_barcode_job_mapping OWNER TO insight;

--
-- Name: tbl_accessories_name; Type: TABLE; Schema: public; Owner: insight
--

CREATE TABLE public.tbl_accessories_name (
    fld_device_name text NOT NULL,
    fld_device_id text,
    fld_module smallint,
    fld_family_type smallint DEFAULT 0 NOT NULL,
    fld_serial_id text DEFAULT '' NOT NULL
);

ALTER TABLE public.tbl_accessories_name OWNER TO insight;

--
-- Name: tbl_accessories_setting; Type: TABLE; Schema: public; Owner: insight
--

CREATE TABLE public.tbl_accessories_setting (
    fld_device_id text NOT NULL,
    fld_device_name text,
    fld_device_description text,
    fld_device_type smallint, 
    fld_connection_status smallint, 
    fld_port_number smallint, 
    fld_device_bus integer, 
    fld_device_address integer, 
    fld_device_tty_num smallint, 
    fld_baud_rate smallint, 
    fld_data_bits smallint, 
    fld_stop_bits smallint, 
    fld_parity smallint, 
    fld_module smallint,
    fld_family_type smallint DEFAULT 0 NOT NULL,
    fld_serial_id text DEFAULT '' NOT NULL
);

ALTER TABLE public.tbl_accessories_setting OWNER TO insight;

--
-- Name: tbl_pokayoke_settings; Type: TABLE; Schema: public; Owner: insight
--
CREATE TABLE public.tbl_pokayoke_settings (
    fld_enable_status smallint, 
    fld_communication_log smallint,
    fld_step_flow smallint,
    fld_pokayoke_source text DEFAULT 'None' NOT NULL,
    fld_last_controller_sequence_number smallint DEFAULT 0 NOT NULL,
    fld_last_lifetime_cycle_count integer DEFAULT 0 NOT NULL,
    fld_number_of_shaft_left smallint DEFAULT 0 NOT NULL,
    fld_pending_work_order smallint[] DEFAULT '{}' NOT NULL,
    fld_toolmacaddress integer[],
    fld_application_id integer
);

ALTER TABLE public.tbl_pokayoke_settings OWNER TO insight;

--
-- Name: tbl_saved_settings; Type: TABLE; Schema: public; Owner: insight
--

CREATE TABLE public.tbl_saved_settings (
    fld_id integer NOT NULL,
    fld_saved_settings_name text NOT NULL,
    fld_tool_info json,
    fld_tool_general_settings json, 
    fld_pset_mapping json, 
    fld_job_mapping json, 
    fld_toolsnet_settings json, 
    fld_pfop_settings json, 
    fld_fop_settings json,
    fld_pfcs_settings json,
    fld_pfcs_tool_settings json,		
    fld_vwxml_settings json, 
    fld_dio_settings json, 
    fld_barcode_settings json,
    fld_identifiers json,
    fld_barcode_job_mapping json,
    fld_pokayoke_settings json,
    fld_global_settings json,
	fld_backup_fieldbus_settings json,
    fld_eor_dataout_settings json,
    fld_timestamp timestamp default now(),
    fld_application_settinga json
);

ALTER TABLE public.tbl_saved_settings OWNER TO insight;

--
-- Name: tbl_saved_settings_fld_id_seq; Type: SEQUENCE; Schema: public; Owner: insight
--

CREATE SEQUENCE public.tbl_saved_settings_fld_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_saved_settings_fld_id_seq OWNER TO insight;

--
-- Name: tbl_saved_settings_fld_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: insight
--

ALTER SEQUENCE public.tbl_saved_settings_fld_id_seq OWNED BY public.tbl_saved_settings.fld_id;

--
-- Name: tbl_eor_dataout_settings; Type: TABLE; Schema: public; Owner: insight
--

CREATE TABLE public.tbl_eor_dataout_settings (
    fld_enable_status smallint,
    fld_communication_log smallint,
    fld_source text DEFAULT 'None' NOT NULL,
    fld_port_number integer,
    fld_job_id integer,
    fld_end_of_record smallint,
    fld_delimeter smallint,
    fld_param_sequence_order integer[],
    fld_preferences_data json,
    fld_toolmacaddress integer[],
    fld_application_id integer
);

ALTER TABLE public.tbl_eor_dataout_settings OWNER TO insight;

--
-- Name: tbl_expired_tool_license; Type: TABLE; Schema: public; Owner: insight
--

CREATE TABLE public.tbl_expired_tool_license (
    fld_tool_license_id text,
    fld_expiry integer
);

ALTER TABLE public.tbl_expired_tool_license OWNER TO insight;

--
-- Name: tbl_event_logs fld_event_log_id; Type: DEFAULT; Schema: public; Owner: insight
--

ALTER TABLE ONLY public.tbl_event_logs ALTER COLUMN fld_event_log_id SET DEFAULT nextval('public.tbl_event_logs_fld_event_id_seq'::regclass);

--
-- Name: tbl_audit_logs fld_audit_log_id; Type: DEFAULT; Schema: public; Owner: insight
--

ALTER TABLE ONLY public.tbl_audit_logs ALTER COLUMN fld_audit_log_id SET DEFAULT nextval('public.tbl_audit_logs_fld_audit_id_seq'::regclass);

--
-- Name: tbl_job_list fld_job_id; Type: DEFAULT; Schema: public; Owner: insight
--

ALTER TABLE ONLY public.tbl_job_list ALTER COLUMN fld_job_id SET DEFAULT nextval('public.tbl_job_list_fld_job_id_seq'::regclass);

--
-- Name: tbl_pset_list fld_pset_id; Type: DEFAULT; Schema: public; Owner: insight
--

ALTER TABLE ONLY public.tbl_pset_list ALTER COLUMN fld_pset_id SET DEFAULT nextval('public.tbl_pset_list_fld_pset_id_seq'::regclass);

--
-- Name: tbl_security fld_user_id; Type: DEFAULT; Schema: public; Owner: insight
--

ALTER TABLE ONLY public.tbl_security ALTER COLUMN fld_user_id SET DEFAULT nextval('public.tbl_security_fld_user_id_seq'::regclass);

--
-- Name: tbl_saved_settings fld_id; Type: DEFAULT; Schema: public; Owner: insight
--

ALTER TABLE ONLY public.tbl_saved_settings ALTER COLUMN fld_id SET DEFAULT nextval('public.tbl_saved_settings_fld_id_seq'::regclass);

--
-- Name: tbl_controller_settings tbl_controller_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: insight
--

ALTER TABLE ONLY public.tbl_controller_settings
    ADD CONSTRAINT tbl_controller_settings_pkey PRIMARY KEY (fld_pkey);


--
-- Name: tbl_date_and_time_settings tbl_date_and_time_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: insight
--

ALTER TABLE ONLY public.tbl_date_and_time_settings
    ADD CONSTRAINT tbl_date_and_time_settings_pkey PRIMARY KEY (fld_pkey);
	
--
-- Name: tbl_security tbl_date_and_time_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: insight
--

ALTER TABLE ONLY public.tbl_security
    ADD CONSTRAINT tbl_security_pkey PRIMARY KEY (fld_user_id);


--
-- Name: tbl_eor_logs tbl_eor_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: insight
--

ALTER TABLE ONLY public.tbl_eor_logs
    ADD CONSTRAINT tbl_eor_logs_pkey PRIMARY KEY (fld_controller_cycle_number);
	

--
-- Name: tbl_eor_tn tbl_eor_en_pkey; Type: CONSTRAINT; Schema: public; Owner: insight
--

ALTER TABLE ONLY public.tbl_eor_tn
    ADD CONSTRAINT tbl_eor_tn_pkey PRIMARY KEY (fld_controller_cycle_number);

--
-- Name: tbl_ethernet_settings tbl_ethernet_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: insight
--

ALTER TABLE ONLY public.tbl_ethernet_settings
    ADD CONSTRAINT tbl_ethernet_settings_pkey PRIMARY KEY (fld_pkey);


--
-- Name: tbl_job_pset_details tbl_job_details_pkey; Type: CONSTRAINT; Schema: public; Owner: insight
--

ALTER TABLE ONLY public.tbl_job_pset_details
    ADD CONSTRAINT tbl_job_details_pkey PRIMARY KEY (fld_job_id, fld_pset_id);

--
-- Name: tbl_job_pset_fail_rules tbl_job_pset_fail_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: insight
--

ALTER TABLE ONLY public.tbl_job_pset_fail_rules
    ADD CONSTRAINT tbl_job_pset_fail_rules_pkey PRIMARY KEY (fld_job_id, fld_pset_id, fld_fail_rule_id);
	
--
-- Name: tbl_saved_settings tbl_saved_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: insight
--

ALTER TABLE ONLY public.tbl_saved_settings
    ADD CONSTRAINT tbl_saved_settings_pkey PRIMARY KEY (fld_id);


--
-- Name: tbl_job_list tbl_job_list_fld_job_name_key; Type: CONSTRAINT; Schema: public; Owner: insight
--

ALTER TABLE ONLY public.tbl_job_list
    ADD CONSTRAINT tbl_job_list_fld_job_name_key UNIQUE (fld_job_name);


--
-- Name: tbl_job_list tbl_job_list_pkey; Type: CONSTRAINT; Schema: public; Owner: insight
--

ALTER TABLE ONLY public.tbl_job_list
    ADD CONSTRAINT tbl_job_list_pkey PRIMARY KEY (fld_job_id);


--
-- Name: tbl_master_tool_data tbl_master_tool_data_pkey; Type: CONSTRAINT; Schema: public; Owner: insight
--

ALTER TABLE ONLY public.tbl_master_tool_data
    ADD CONSTRAINT tbl_master_tool_data_pkey PRIMARY KEY (fld_toolmacaddress);

--
-- Name: tbl_pset_list tbl_pset_list_fld_pset_name_key; Type: CONSTRAINT; Schema: public; Owner: insight
--

ALTER TABLE ONLY public.tbl_pset_list
    ADD CONSTRAINT tbl_pset_list_fld_pset_name_key UNIQUE (fld_pset_name);


--
-- Name: tbl_pset_list tbl_pset_list_pkey; Type: CONSTRAINT; Schema: public; Owner: insight
--

ALTER TABLE ONLY public.tbl_pset_list
    ADD CONSTRAINT tbl_pset_list_pkey PRIMARY KEY (fld_pset_id);
	
--
-- Name: tbl_pset_list tbl_pset_details_pkey; Type: CONSTRAINT; Schema: public; Owner: insight
--

ALTER TABLE ONLY public.tbl_pset_details
    ADD CONSTRAINT tbl_pset_details_pkey PRIMARY KEY (fld_pset_id, fld_step_number);

--
-- Name: tbl_system_info tbl_system_info_pkey; Type: CONSTRAINT; Schema: public; Owner: insight
--

ALTER TABLE ONLY public.tbl_system_info
    ADD CONSTRAINT tbl_system_info_pkey PRIMARY KEY (fld_pkey);


--
-- Name: tbl_time_zones tbl_time_zones_pkey; Type: CONSTRAINT; Schema: public; Owner: insight
--

ALTER TABLE ONLY public.tbl_time_zones
    ADD CONSTRAINT tbl_time_zones_pkey PRIMARY KEY (fld_pkey);
	
--
-- Name: tbl_eor_headers tbl_eor_headers_pkey; Type: CONSTRAINT; Schema: public; Owner: insight
--

ALTER TABLE ONLY public.tbl_eor_headers
    ADD CONSTRAINT tbl_eor_headers_pkey PRIMARY KEY (fld_id);
	
--
-- Name: tbl_accessories_setting tbl_accessories_setting_pkey; Type: CONSTRAINT; Schema: public; Owner: insight
--

--ALTER TABLE ONLY public.tbl_accessories_setting
--    ADD CONSTRAINT tbl_accessories_setting_pkey PRIMARY KEY (fld_device_id);

--
-- Name: tbl_accessories_name tbl_accessories_name_pkey; Type: CONSTRAINT; Schema: public; Owner: insight
--

ALTER TABLE ONLY public.tbl_accessories_name
    ADD CONSTRAINT tbl_accessories_name_pkey PRIMARY KEY (fld_device_name);

--
-- Name: tbl_toolsnet_settings tbl_toolsnet_settings_fld_toolmacaddress_key; Type: CONSTRAINT; Schema: public; Owner: insight
--

ALTER TABLE ONLY public.tbl_toolsnet_settings
    ADD CONSTRAINT tbl_toolsnet_settings_fld_toolmacaddress_key UNIQUE (fld_toolmacaddress);


--
-- Name: tbl_pfop_settings tbl_pfop_settings_fld_toolmacaddress_key; Type: CONSTRAINT; Schema: public; Owner: insight
--

ALTER TABLE ONLY public.tbl_pfop_settings
    ADD CONSTRAINT tbl_pfop_settings_fld_toolmacaddress_key UNIQUE (fld_toolmacaddress);

--
-- Name: tbl_fop_settings tbl_fop_settings_fld_toolmacaddress_key; Type: CONSTRAINT; Schema: public; Owner: insight
--

ALTER TABLE ONLY public.tbl_fop_settings
    ADD CONSTRAINT tbl_fop_settings_fld_toolmacaddress_key UNIQUE (fld_toolmacaddress);	
	
--
-- Name: tbl_vwxml_settings tbl_vwxml_settings_fld_toolmacaddress_key; Type: CONSTRAINT; Schema: public; Owner: insight
--

ALTER TABLE ONLY public.tbl_vwxml_settings
    ADD CONSTRAINT tbl_vwxml_settings_fld_toolmacaddress_key UNIQUE (fld_toolmacaddress);

--
-- Name: tbl_tool_status tbl_tool_status_fld_toolmacaddress_key; Type: CONSTRAINT; Schema: public; Owner: insight
--

ALTER TABLE ONLY public.tbl_tool_status
    ADD CONSTRAINT tbl_tool_status_fld_toolmacaddress_key UNIQUE (fld_toolmacaddress);

--
-- Name: tbl_pfcs_tool_settings tbl_pfcs_tool_settings_fld_toolmacaddress_key; Type: CONSTRAINT; Schema: public; Owner: insight
--

ALTER TABLE ONLY public.tbl_pfcs_tool_settings
    ADD CONSTRAINT tbl_pfcs_tool_settings_fld_toolmacaddress_key UNIQUE (fld_toolmacaddress);

--
-- Name: tbl_boot_job_info tbl_boot_job_info_fld_toolmacaddress_key; Type: CONSTRAINT; Schema: public; Owner: insight
--

ALTER TABLE ONLY public.tbl_boot_job_info
    ADD CONSTRAINT tbl_boot_job_info_fld_toolmacaddress_key UNIQUE (fld_toolmacaddress);

--
-- Name: tbl_fieldbus_settings tbl_fieldbus_settings_fld_toolmacaddress_key; Type: CONSTRAINT; Schema: public; Owner: insight
--

ALTER TABLE ONLY public.tbl_fieldbus_settings
    ADD CONSTRAINT tbl_fieldbus_settings_fld_toolmacaddress_key UNIQUE (fld_toolmacaddress);
	
--
-- Name: tbl_backup_fieldbus_settings tbl_backup_fieldbus_settings_fld_toolmacaddress_key; Type: CONSTRAINT; Schema: public; Owner: insight
--

--ALTER TABLE ONLY public.tbl_backup_fieldbus_settings
--    ADD CONSTRAINT tbl_backup_fieldbus_settings_fld_toolmacaddress_key UNIQUE (fld_toolmacaddress);

--
-- Name: tbl_barcode_settings tbl_barcode_settings_fld_toolmacaddress_key; Type: CONSTRAINT; Schema: public; Owner: insight
--

ALTER TABLE ONLY public.tbl_barcode_settings
    ADD CONSTRAINT tbl_barcode_settings_fld_toolmacaddress_key UNIQUE (fld_toolmacaddress);

--
-- Name: tbl_accessories_name tbl_accessories_name_fld_device_id_key; Type: CONSTRAINT; Schema: public; Owner: insight
--

--ALTER TABLE ONLY public.tbl_accessories_name
--    ADD CONSTRAINT tbl_accessories_name_fld_device_id_key UNIQUE (fld_device_id);

--
-- Name: tbl_accessories_setting tbl_accessories_name_fld_device_id_key; Type: CONSTRAINT; Schema: public; Owner: insight
--

--ALTER TABLE ONLY public.tbl_accessories_setting
--    ADD CONSTRAINT tbl_accessories_setting_fld_device_id_key UNIQUE (fld_device_id);
	
--
-- Name: tbl_security tbl_security_fld_user_name_key; Type: CONSTRAINT; Schema: public; Owner: insight
--

ALTER TABLE ONLY public.tbl_security
    ADD CONSTRAINT tbl_security_fld_user_name_key UNIQUE (fld_user_name);

--
-- Name: tbl_security tbl_security_fld_alias_name_key; Type: CONSTRAINT; Schema: public; Owner: insight
--

ALTER TABLE ONLY public.tbl_security
    ADD CONSTRAINT tbl_security_fld_alias_name_key UNIQUE (fld_alias_name);
	
--
-- Name: tbl_pokayoke_settings tbl_pokayoke_settings_fld_toolmacaddress_key; Type: CONSTRAINT; Schema: public; Owner: insight
--

ALTER TABLE ONLY public.tbl_pokayoke_settings
    ADD CONSTRAINT tbl_pokayoke_settings_fld_toolmacaddress_key UNIQUE (fld_toolmacaddress);
	
--
-- Name: tbl_eor_dataout_settings tbl_eor_dataout_settings_fld_toolmacaddress_key; Type: CONSTRAINT; Schema: public; Owner: insight
--

ALTER TABLE ONLY public.tbl_eor_dataout_settings
    ADD CONSTRAINT tbl_eor_dataout_settings_fld_toolmacaddress_key UNIQUE (fld_toolmacaddress);
	
--
-- Name: tbl_expired_tool_license tbl_expired_tool_license_fld_tool_license_id_key; Type: CONSTRAINT; Schema: public; Owner: insight
--

ALTER TABLE ONLY public.tbl_expired_tool_license
    ADD CONSTRAINT tbl_expired_tool_license_fld_tool_license_id_key UNIQUE (fld_tool_license_id);
	
--
-- Name: tbl_used_license_ids tbl_used_license_ids_fld_license_ids_key; Type: CONSTRAINT; Schema: public; Owner: insight
--

ALTER TABLE ONLY public.tbl_used_license_ids
    ADD CONSTRAINT tbl_used_license_ids_fld_license_ids_key UNIQUE (fld_license_ids);
	
--
-- Name: tbl_tool_general_settings tbl_tool_general_settings_fld_toolmacaddress_key; Type: CONSTRAINT; Schema: public; Owner: insight
--

ALTER TABLE ONLY public.tbl_tool_general_settings
    ADD CONSTRAINT tbl_tool_general_settings_fld_toolmacaddress_key UNIQUE (fld_toolmacaddress);

--
-- Name: tbl_temporary_tool_data tbl_temporary_tool_data_fld_toolmacaddress_key; Type: CONSTRAINT; Schema: public; Owner: insight
--

ALTER TABLE ONLY public.tbl_temporary_tool_data
    ADD CONSTRAINT tbl_temporary_tool_data_fld_toolmacaddress_key UNIQUE (fld_toolmacaddress);
	
--
-- Name: tbl_permanent_tool_data tbl_permanent_tool_data_fld_toolmacaddress_key; Type: CONSTRAINT; Schema: public; Owner: insight
--

ALTER TABLE ONLY public.tbl_permanent_tool_data
    ADD CONSTRAINT tbl_permanent_tool_data_fld_toolmacaddress_key UNIQUE (fld_toolmacaddress);

--
-- Name: tbl_job_mapping trig_job_mapping_delete; Type: TRIGGER; Schema: public; Owner: insight
--

CREATE TRIGGER trig_job_mapping_delete BEFORE DELETE ON public.tbl_job_mapping FOR EACH ROW EXECUTE PROCEDURE public.notify_job_mapping();


--
-- Name: tbl_job_mapping trig_job_mapping_insert_update; Type: TRIGGER; Schema: public; Owner: insight
--

CREATE TRIGGER trig_job_mapping_insert_update AFTER INSERT OR UPDATE ON public.tbl_job_mapping FOR EACH ROW EXECUTE PROCEDURE public.notify_job_mapping();


--
-- Name: tbl_master_tool_data trig_master_tool_data_delete; Type: TRIGGER; Schema: public; Owner: insight
--

CREATE TRIGGER trig_master_tool_data_delete BEFORE DELETE ON public.tbl_master_tool_data FOR EACH ROW EXECUTE PROCEDURE public.notify_master_tool_mapping();


--
-- Name: tbl_master_tool_data trig_master_tool_data_insert_update; Type: TRIGGER; Schema: public; Owner: insight
--

CREATE TRIGGER trig_master_tool_data_insert_update AFTER INSERT OR UPDATE ON public.tbl_master_tool_data FOR EACH ROW EXECUTE PROCEDURE public.notify_master_tool_mapping();


--
-- Name: tbl_pset_mapping trig_pset_mapping_delete; Type: TRIGGER; Schema: public; Owner: insight
--

CREATE TRIGGER trig_pset_mapping_delete BEFORE DELETE ON public.tbl_pset_mapping FOR EACH ROW EXECUTE PROCEDURE public.notify_pset_mapping();


--
-- Name: tbl_pset_mapping trig_pset_mapping_insert_update; Type: TRIGGER; Schema: public; Owner: insight
--

CREATE TRIGGER trig_pset_mapping_insert_update AFTER INSERT OR UPDATE ON public.tbl_pset_mapping FOR EACH ROW EXECUTE PROCEDURE public.notify_pset_mapping();


--
-- Name: tbl_tool_general_settings trig_qx_tool_general_settings_update; Type: TRIGGER; Schema: public; Owner: insight
--

CREATE TRIGGER trig_qx_tool_general_settings_update AFTER UPDATE ON public.tbl_tool_general_settings FOR EACH ROW EXECUTE PROCEDURE public.notify_qx_general_settings_mapping();


--
-- Name: tbl_toolsnet_settings trig_toolsnet_settings; Type: TRIGGER; Schema: public; Owner: insight
--

CREATE TRIGGER trig_toolsnet_settings AFTER INSERT OR DELETE OR UPDATE ON public.tbl_toolsnet_settings FOR EACH ROW EXECUTE PROCEDURE public.notify_toolsnet_settings();

--
-- Name: tbl_pfop_settings trig_pfop_settings; Type: TRIGGER; Schema: public; Owner: insight
--

CREATE TRIGGER trig_pfop_settings AFTER INSERT OR DELETE OR UPDATE ON public.tbl_pfop_settings FOR EACH ROW EXECUTE PROCEDURE public.notify_pfop_settings();

--
-- Name: tbl_pfcs_settings trig_pfcs_settings; Type: TRIGGER; Schema: public; Owner: insight
--

CREATE TRIGGER trig_pfcs_settings AFTER INSERT OR DELETE OR UPDATE ON public.tbl_pfcs_settings FOR EACH ROW EXECUTE PROCEDURE public.notify_pfcs_settings();

--
-- Name: tbl_system_info trig_system_info_setting; Type: TRIGGER; Schema: public; Owner: insight
--

CREATE TRIGGER trig_system_info_setting AFTER UPDATE ON public.tbl_system_info FOR EACH ROW EXECUTE PROCEDURE public.notify_system_info_setting();

--
-- Name: tbl_date_and_time_settings trig_date_time_setting; Type: TRIGGER; Schema: public; Owner: insight
--

CREATE TRIGGER trig_date_time_setting AFTER INSERT OR UPDATE ON public.tbl_date_and_time_settings FOR EACH ROW EXECUTE PROCEDURE public.notify_date_time_setting();

--
-- Name: tbl_permanent_tool_data trig_permanent_tool_data; Type: TRIGGER; Schema: public; Owner: insight
--

CREATE TRIGGER trig_permanent_tool_data AFTER INSERT OR UPDATE ON public.tbl_permanent_tool_data FOR EACH ROW EXECUTE PROCEDURE public.notify_permanent_tool_data();

--
-- Name: tbl_job_list trig_job_list; Type: TRIGGER; Schema: public; Owner: insight
--

CREATE TRIGGER trig_job_list AFTER UPDATE ON public.tbl_job_list FOR EACH ROW EXECUTE PROCEDURE public.notify_job_list();

--
-- Name: tbl_eor_logs trig_eor_logs; Type: TRIGGER; Schema: public; Owner: insight
--

CREATE TRIGGER trig_eor_logs AFTER INSERT ON public.tbl_eor_logs FOR EACH ROW EXECUTE PROCEDURE public.notify_eor_logs();

--
-- Name: tbl_eor_logs trig_trace_logs; Type: TRIGGER; Schema: public; Owner: insight
--

CREATE TRIGGER trig_trace_logs AFTER INSERT ON public.tbl_trace_logs FOR EACH ROW EXECUTE PROCEDURE public.notify_trace_logs();

--
-- Name: tbl_barcode_settings trig_barcode_settings; Type: TRIGGER; Schema: public; Owner: insight
--

CREATE TRIGGER trig_barcode_settings AFTER INSERT OR DELETE OR UPDATE ON public.tbl_barcode_settings FOR EACH ROW EXECUTE PROCEDURE public.notify_barcode_settings();

--
-- Name: tbl_accessories_setting trig_accessories_setting; Type: TRIGGER; Schema: public; Owner: insight
--

CREATE TRIGGER trig_accessories_setting  AFTER INSERT OR DELETE OR UPDATE ON public.tbl_accessories_setting FOR EACH ROW EXECUTE PROCEDURE public.notify_accessories_setting();

--
-- Name: tbl_session trig_session; Type: TRIGGER; Schema: public; Owner: insight
--

CREATE TRIGGER trig_session AFTER DELETE OR UPDATE ON public.tbl_session FOR EACH ROW EXECUTE PROCEDURE public.notify_user_session();

--
-- Name: tbl_pokayoke_settings trig_pokayoke_settings; Type: TRIGGER; Schema: public; Owner: insight
--

CREATE TRIGGER trig_pokayoke_settings AFTER INSERT OR DELETE OR UPDATE ON public.tbl_pokayoke_settings FOR EACH ROW EXECUTE PROCEDURE public.notify_pokayoke_settings();

--
-- Name: tbl_job_pset_details tbl_job_details_fld_job_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: insight
--

ALTER TABLE ONLY public.tbl_job_pset_details
    ADD CONSTRAINT tbl_job_details_fld_job_id_fkey FOREIGN KEY (fld_job_id) REFERENCES public.tbl_job_list(fld_job_id) ON DELETE CASCADE;


--
-- Name: tbl_job_pset_details tbl_job_details_fld_pset_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: insight
--

ALTER TABLE ONLY public.tbl_job_pset_details
    ADD CONSTRAINT tbl_job_details_fld_pset_id_fkey FOREIGN KEY (fld_pset_id) REFERENCES public.tbl_pset_list(fld_pset_id) ON DELETE CASCADE;


--
-- Name: tbl_job_mapping tbl_job_mapping_fld_controller_job_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: insight
--

ALTER TABLE ONLY public.tbl_job_mapping
    ADD CONSTRAINT tbl_job_mapping_fld_controller_job_id_fkey FOREIGN KEY (fld_controller_job_id) REFERENCES public.tbl_job_list(fld_job_id) ON DELETE CASCADE;


--
-- Name: tbl_job_mapping tbl_job_mapping_fld_tool_mac_address_fkey; Type: FK CONSTRAINT; Schema: public; Owner: insight
--

ALTER TABLE ONLY public.tbl_job_mapping
    ADD CONSTRAINT tbl_job_mapping_fld_tool_mac_address_fkey FOREIGN KEY (fld_toolmacaddress) REFERENCES public.tbl_master_tool_data(fld_toolmacaddress) ON DELETE CASCADE;


--
-- Name: tbl_job_pset_fail_rules tbl_job_pset_fail_rules_fld_job_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: insight
--

ALTER TABLE ONLY public.tbl_job_pset_fail_rules
    ADD CONSTRAINT tbl_job_pset_fail_rules_fld_job_id_fkey FOREIGN KEY (fld_job_id) REFERENCES public.tbl_job_list(fld_job_id) ON DELETE CASCADE;


--
-- Name: tbl_job_pset_fail_rules tbl_job_pset_fail_rules_fld_pset_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: insight
--

ALTER TABLE ONLY public.tbl_job_pset_fail_rules
    ADD CONSTRAINT tbl_job_pset_fail_rules_fld_pset_id_fkey FOREIGN KEY (fld_pset_id) REFERENCES public.tbl_pset_list(fld_pset_id) ON DELETE CASCADE;


--
-- Name: tbl_permanent_tool_data tbl_permanent_tool_data_fld_tool_mac_address_fkey; Type: FK CONSTRAINT; Schema: public; Owner: insight
--

ALTER TABLE ONLY public.tbl_permanent_tool_data
    ADD CONSTRAINT tbl_permanent_tool_data_fld_tool_mac_address_fkey FOREIGN KEY (fld_toolmacaddress) REFERENCES public.tbl_master_tool_data(fld_toolmacaddress) ON DELETE CASCADE;


--
-- Name: tbl_pset_details tbl_pset_details_fld_pset_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: insight
--

ALTER TABLE ONLY public.tbl_pset_details
    ADD CONSTRAINT tbl_pset_details_fld_pset_id_fkey FOREIGN KEY (fld_pset_id) REFERENCES public.tbl_pset_list(fld_pset_id) ON DELETE CASCADE;


--
-- Name: tbl_pset_mapping tbl_pset_mapping_fld_controller_pset_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: insight
--

ALTER TABLE ONLY public.tbl_pset_mapping
    ADD CONSTRAINT tbl_pset_mapping_fld_controller_pset_id_fkey FOREIGN KEY (fld_controller_pset_id) REFERENCES public.tbl_pset_list(fld_pset_id) ON DELETE CASCADE;


--
-- Name: tbl_pset_mapping tbl_pset_mapping_fld_tool_mac_address_fkey; Type: FK CONSTRAINT; Schema: public; Owner: insight
--

ALTER TABLE ONLY public.tbl_pset_mapping
    ADD CONSTRAINT tbl_pset_mapping_fld_tool_mac_address_fkey FOREIGN KEY (fld_toolmacaddress) REFERENCES public.tbl_master_tool_data(fld_toolmacaddress) ON DELETE CASCADE;


--
-- Name: tbl_temporary_tool_data tbl_temporary_tool_data_fld_tool_mac_address_fkey; Type: FK CONSTRAINT; Schema: public; Owner: insight
--

ALTER TABLE ONLY public.tbl_temporary_tool_data
    ADD CONSTRAINT tbl_temporary_tool_data_fld_tool_mac_address_fkey FOREIGN KEY (fld_toolmacaddress) REFERENCES public.tbl_master_tool_data(fld_toolmacaddress) ON DELETE CASCADE;


--
-- Name: tbl_tool_general_settings tbl_tool_general_settings_fld_tool_mac_address_fkey; Type: FK CONSTRAINT; Schema: public; Owner: insight
--

ALTER TABLE ONLY public.tbl_tool_general_settings
    ADD CONSTRAINT tbl_tool_general_settings_fld_tool_mac_address_fkey FOREIGN KEY (fld_toolmacaddress) REFERENCES public.tbl_master_tool_data(fld_toolmacaddress) ON DELETE CASCADE;


--
-- Name: tbl_toolsnet_settings tbl_toolsnet_settings_fld_toolmacaddress_fkey; Type: FK CONSTRAINT; Schema: public; Owner: insight
--

ALTER TABLE ONLY public.tbl_toolsnet_settings
    ADD CONSTRAINT tbl_toolsnet_settings_fld_toolmacaddress_fkey FOREIGN KEY (fld_toolmacaddress) REFERENCES public.tbl_master_tool_data(fld_toolmacaddress) ON DELETE CASCADE;

--
-- Name: tbl_pfop_settings tbl_pfop_settings_fld_toolmacaddress_fkey; Type: FK CONSTRAINT; Schema: public; Owner: insight
--

ALTER TABLE ONLY public.tbl_pfop_settings
    ADD CONSTRAINT tbl_pfop_settings_fld_toolmacaddress_fkey FOREIGN KEY (fld_toolmacaddress) REFERENCES public.tbl_master_tool_data(fld_toolmacaddress) ON DELETE CASCADE;

--
-- Name: tbl_fop_settings tbl_fop_settings_fld_toolmacaddress_fkey; Type: FK CONSTRAINT; Schema: public; Owner: insight
--

ALTER TABLE ONLY public.tbl_fop_settings
    ADD CONSTRAINT tbl_fop_settings_fld_toolmacaddress_fkey FOREIGN KEY (fld_toolmacaddress) REFERENCES public.tbl_master_tool_data(fld_toolmacaddress) ON DELETE CASCADE;

--
-- Name: tbl_vwxml_settings tbl_vwxml_settings_fld_toolmacaddress_fkey; Type: FK CONSTRAINT; Schema: public; Owner: insight
--

ALTER TABLE ONLY public.tbl_vwxml_settings
    ADD CONSTRAINT tbl_vwxml_settings_fld_toolmacaddress_fkey FOREIGN KEY (fld_toolmacaddress) REFERENCES public.tbl_master_tool_data(fld_toolmacaddress) ON DELETE CASCADE;

--
-- Name: tbl_tool_status tbl_tool_status_fld_toolmacaddress_fkey; Type: FK CONSTRAINT; Schema: public; Owner: insight
--

ALTER TABLE ONLY public.tbl_tool_status
    ADD CONSTRAINT tbl_tool_status_fld_toolmacaddress_fkey FOREIGN KEY (fld_toolmacaddress) REFERENCES public.tbl_master_tool_data(fld_toolmacaddress) ON DELETE CASCADE;


--
-- Name: tbl_pfcs_tool_settings tbl_pfcs_tool_settings_fld_toolmacaddress_fkey; Type: FK CONSTRAINT; Schema: public; Owner: insight
--

ALTER TABLE ONLY public.tbl_pfcs_tool_settings
    ADD CONSTRAINT tbl_pfcs_tool_settings_fld_toolmacaddress_fkey FOREIGN KEY (fld_toolmacaddress) REFERENCES public.tbl_master_tool_data(fld_toolmacaddress) ON DELETE CASCADE;

--
-- Name: tbl_dio_settings tbl_dio_settings_fld_toolmacaddress_fkey; Type: FK CONSTRAINT; Schema: public; Owner: insight
--

ALTER TABLE ONLY public.tbl_dio_settings
    ADD CONSTRAINT tbl_dio_settings_fld_toolmacaddress_fkey FOREIGN KEY (fld_toolmacaddress) REFERENCES public.tbl_master_tool_data(fld_toolmacaddress) ON DELETE CASCADE;

--
-- Name: tbl_fieldbus_settings tbl_fieldbus_settings_fld_toolmacaddress_fkey; Type: FK CONSTRAINT; Schema: public; Owner: insight
--

ALTER TABLE ONLY public.tbl_fieldbus_settings
    ADD CONSTRAINT tbl_fieldbus_settings_fld_toolmacaddress_fkey FOREIGN KEY (fld_toolmacaddress) REFERENCES public.tbl_master_tool_data(fld_toolmacaddress) ON DELETE CASCADE;

--
-- Name: tbl_boot_job_info tbl_boot_job_info_fld_toolmacaddress_fkey; Type: FK CONSTRAINT; Schema: public; Owner: insight
--

ALTER TABLE ONLY public.tbl_boot_job_info
    ADD CONSTRAINT tbl_boot_job_info_fld_toolmacaddress_fkey FOREIGN KEY (fld_toolmacaddress) REFERENCES public.tbl_master_tool_data(fld_toolmacaddress) ON DELETE CASCADE;
	
--
-- Name: tbl_barcode_settings tbl_barcode_settings_fld_toolmacaddress_fkey; Type: FK CONSTRAINT; Schema: public; Owner: insight
--

ALTER TABLE ONLY public.tbl_barcode_settings
    ADD CONSTRAINT tbl_barcode_settings_fld_toolmacaddress_fkey FOREIGN KEY (fld_toolmacaddress) REFERENCES public.tbl_master_tool_data(fld_toolmacaddress) ON DELETE CASCADE;

--
-- Name: tbl_identifiers tbl_identifiers_fld_toolmacaddress_fkey; Type: FK CONSTRAINT; Schema: public; Owner: insight
--

ALTER TABLE ONLY public.tbl_identifiers
    ADD CONSTRAINT tbl_identifiers_fld_toolmacaddress_fkey FOREIGN KEY (fld_toolmacaddress) REFERENCES public.tbl_master_tool_data(fld_toolmacaddress) ON DELETE CASCADE;
--
-- Name: tbl_barcode_job_mapping tbl_barcode_job_mapping_fld_toolmacaddress_fkey; Type: FK CONSTRAINT; Schema: public; Owner: insight
--

ALTER TABLE ONLY public.tbl_barcode_job_mapping
    ADD CONSTRAINT tbl_barcode_job_mapping_fld_toolmacaddress_fkey FOREIGN KEY (fld_toolmacaddress) REFERENCES public.tbl_master_tool_data(fld_toolmacaddress) ON DELETE CASCADE;

--
-- Name: tbl_trace_logs tbl_trace_logs_fld_controller_cycle_number_fkey; Type: FK CONSTRAINT; Schema: public; Owner: insight
--

ALTER TABLE ONLY public.tbl_trace_logs
    ADD CONSTRAINT tbl_trace_logs_fld_controller_cycle_number_fkey FOREIGN KEY (fld_controller_cycle_number) REFERENCES public.tbl_eor_logs(fld_controller_cycle_number) ON DELETE CASCADE;

--
-- Name: tbl_pokayoke_settings tbl_pokayoke_settings_fld_toolmacaddress_fkey; Type: FK CONSTRAINT; Schema: public; Owner: insight
--

ALTER TABLE ONLY public.tbl_pokayoke_settings
    ADD CONSTRAINT tbl_pokayoke_settings_fld_toolmacaddress_fkey FOREIGN KEY (fld_toolmacaddress) REFERENCES public.tbl_master_tool_data(fld_toolmacaddress) ON DELETE CASCADE;

--
-- Name: tbl_eor_dataout_settings tbl_eor_dataout_settings_fld_toolmacaddress_fkey; Type: FK CONSTRAINT; Schema: public; Owner: insight
--

ALTER TABLE ONLY public.tbl_eor_dataout_settings
    ADD CONSTRAINT tbl_eor_dataout_settings_fld_toolmacaddress_fkey FOREIGN KEY (fld_toolmacaddress) REFERENCES public.tbl_master_tool_data(fld_toolmacaddress) ON DELETE CASCADE;
	
--
-- Name: tbl_session session_pkey; Type: CONSTRAINT; Schema: public; Owner: insight
--

ALTER TABLE ONLY public.tbl_session 
    ADD CONSTRAINT "session_pkey" PRIMARY KEY ("sid") NOT DEFERRABLE INITIALLY IMMEDIATE;

CREATE INDEX "IDX_session_expire" ON public.tbl_session ("expire");

CREATE INDEX idx_tool_mac_address ON public.tbl_eor_logs(fld_toolmacaddress);
	
--
-- PostgreSQL database dump complete
--
