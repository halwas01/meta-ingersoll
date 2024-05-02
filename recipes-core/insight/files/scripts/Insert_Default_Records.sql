--
-- Name: notify_fop_settings(); Type: FUNCTION; Schema: public; Owner: insight
--
CREATE OR REPLACE FUNCTION public.notify_fop_settings() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE
  BEGIN
    IF (TG_OP = 'DELETE') THEN
      PERFORM pg_notify('fop_settings_channel',json_build_object('MacAddress',array_to_string(new.fld_toolmacaddress,'.'),'operation',0,'record',OLD)::text);
      RETURN OLD;
    ELSIF (TG_OP = 'INSERT') THEN
      --raise notice 'insert trigger';   
      PERFORM pg_notify('fop_settings_channel',json_build_object('MacAddress',array_to_string(new.fld_toolmacaddress,'.'),'operation',1,'record',NEW)::text);
      RETURN NEW;
    ELSIF (TG_OP = 'UPDATE') THEN
      --raise notice 'update trigger';
      PERFORM pg_notify('fop_settings_channel',json_build_object('MacAddress',array_to_string(new.fld_toolmacaddress,'.'),'operation',2,'record',NEW)::text);
      RETURN NEW;
    ELSE 
      PERFORM pg_notify('fop_settings_channel',json_build_object('operation',3));
      RETURN NEW;
    END IF;
  END;
$$;

ALTER FUNCTION public.notify_fop_settings() OWNER TO insight;

--
-- Name: tbl_fop_settings trig_fop_settings; Type: TRIGGER; Schema: public; Owner: insight
--

CREATE TRIGGER trig_fop_settings AFTER INSERT OR DELETE OR UPDATE ON public.tbl_fop_settings FOR EACH ROW EXECUTE PROCEDURE public.notify_fop_settings();

--
-- Name: notify_dio_settings(); Type: FUNCTION; Schema: public; Owner: insight
--
CREATE OR REPLACE FUNCTION public.notify_dio_settings() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE
  BEGIN
    IF (TG_OP = 'DELETE') THEN
      PERFORM pg_notify('dio_settings_channel',json_build_object('operation',0,'fld_toolmacaddress',OLD.fld_toolmacaddress,'fld_dio_source',OLD.fld_dio_source,'fld_modbus_ip_address',OLD.fld_modbus_ip_address,'fld_old_dio_source',OLD.fld_dio_source,'fld_old_modbus_ip_address',OLD.fld_modbus_ip_address)::text);
      RETURN OLD;
    ELSIF (TG_OP = 'INSERT') THEN
      --raise notice 'insert trigger';   
      PERFORM pg_notify('dio_settings_channel',json_build_object('operation',1,'fld_toolmacaddress',NEW.fld_toolmacaddress,'fld_dio_source',NEW.fld_dio_source,'fld_modbus_ip_address',NEW.fld_modbus_ip_address,'fld_old_dio_source',NEW.fld_dio_source,'fld_old_modbus_ip_address',NEW.fld_modbus_ip_address)::text);
      RETURN NEW;
    ELSIF (TG_OP = 'UPDATE') THEN
      --raise notice 'update trigger';
      PERFORM pg_notify('dio_settings_channel',json_build_object('operation',2,'fld_toolmacaddress',NEW.fld_toolmacaddress,'fld_dio_source',NEW.fld_dio_source,'fld_modbus_ip_address',NEW.fld_modbus_ip_address,'fld_old_dio_source',OLD.fld_dio_source,'fld_old_modbus_ip_address',OLD.fld_modbus_ip_address)::text);
      RETURN NEW;
    ELSE 
      PERFORM pg_notify('dio_settings_channel',json_build_object('operation',3));
      RETURN NEW;
    END IF;
  END;
$$;

ALTER FUNCTION public.notify_dio_settings() OWNER TO insight;

--
-- Name: tbl_dio_settings trig_dio_settings; Type: TRIGGER; Schema: public; Owner: insight
--

CREATE TRIGGER trig_dio_settings AFTER INSERT OR DELETE OR UPDATE ON public.tbl_dio_settings FOR EACH ROW EXECUTE PROCEDURE public.notify_dio_settings();

--
-- Name: notify_vwxml_settings(); Type: FUNCTION; Schema: public; Owner: insight
--
CREATE OR REPLACE FUNCTION public.notify_vwxml_settings() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE
  BEGIN
    IF (TG_OP = 'DELETE') THEN
      PERFORM pg_notify('vwxml_setting_channel_' || array_to_string (old.fld_toolmacaddress,''),json_build_object('operation',0)::text);
      RETURN OLD;
    ELSIF (TG_OP = 'INSERT') THEN
      --raise notice 'insert trigger';   
      PERFORM pg_notify('vwxml_setting_channel',json_build_object('MacAddress',array_to_string(new.fld_toolmacaddress,'.'),'operation',1,'record',NEW)::text);
      RETURN NEW;
    ELSIF (TG_OP = 'UPDATE') THEN
      --raise notice 'update trigger';
      PERFORM pg_notify('vwxml_setting_channel_' || array_to_string (new.fld_toolmacaddress,''),json_build_object('MacAddress',array_to_string(new.fld_toolmacaddress,'.'),'operation',2,'record',NEW)::text);
      RETURN NEW;
    ELSE 
      PERFORM pg_notify('vwxml_setting_channel',json_build_object('operation',3));
      RETURN NEW;
    END IF;
  END;
$$;


ALTER FUNCTION public.notify_vwxml_settings() OWNER TO insight;

--
-- Name: tbl_vwxml_settings trig_vwxml_settings; Type: TRIGGER; Schema: public; Owner: insight
--

CREATE TRIGGER trig_vwxml_settings AFTER INSERT OR DELETE OR UPDATE ON public.tbl_vwxml_settings FOR EACH ROW EXECUTE PROCEDURE public.notify_vwxml_settings();

--
-- Name: notify_tool_status(); Type: FUNCTION; Schema: public; Owner: insight
--
CREATE OR REPLACE FUNCTION public.notify_tool_status() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE
  BEGIN
    IF (TG_OP = 'INSERT') THEN
      --raise notice 'insert trigger';   
     PERFORM pg_notify('tool_connection_status_channel_' || array_to_string (new.fld_toolmacaddress,''),json_build_object('MacAddress',array_to_string(new.fld_toolmacaddress,'.'),'operation',1,'record',NEW)::text);
      RETURN NEW;
    ELSIF (TG_OP = 'UPDATE') THEN
      --raise notice 'update trigger';
      PERFORM pg_notify('tool_connection_status_channel_' || array_to_string (new.fld_toolmacaddress,''),json_build_object('MacAddress',array_to_string(new.fld_toolmacaddress,'.'),'operation',2,'record',NEW)::text);
      RETURN NEW;
    ELSE 
      PERFORM pg_notify('tool_connection_status_channel',json_build_object('operation',3));
      RETURN NEW;
    END IF;
  END;
$$;

ALTER FUNCTION public.notify_tool_status() OWNER TO insight;

--
-- Name: trig_tool_connection_status trig_tool_connection_status; Type: TRIGGER; Schema: public; Owner: insight
--
CREATE TRIGGER trig_tool_connection_status AFTER INSERT OR UPDATE ON public.tbl_tool_status FOR EACH ROW EXECUTE PROCEDURE public.notify_tool_status();


--
-- Name: notify_modified_job(); Type: FUNCTION; Schema: public; Owner: insight
--
CREATE OR REPLACE FUNCTION public.notify_modified_job() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE
  BEGIN
    IF (TG_OP = 'INSERT') THEN
      --raise notice 'insert trigger';   
      PERFORM pg_notify('job_modified_channel_' || array_to_string (new.fld_toolmacaddress,''),json_build_object('MacAddress',array_to_string(new.fld_toolmacaddress,'.'),'operation',1,'record',NEW)::text);
      RETURN NEW;
    ELSIF (TG_OP = 'UPDATE') THEN
      --raise notice 'update trigger';
      PERFORM pg_notify('job_modified_channel_' || array_to_string (new.fld_toolmacaddress,''),json_build_object('MacAddress',array_to_string(new.fld_toolmacaddress,'.'),'operation',2,'record',NEW)::text);
      RETURN NEW;
    ELSE 
      PERFORM pg_notify('job_modified_channel',json_build_object('operation',3));
      RETURN NEW;
    END IF;
  END;
$$;

ALTER FUNCTION public.notify_modified_job() OWNER TO insight;

--
-- Name: tbl_modifed_job trig_modified_job; Type: TRIGGER; Schema: public; Owner: insight
--
CREATE TRIGGER trig_modified_job AFTER INSERT OR UPDATE ON public.tbl_modifed_job FOR EACH ROW EXECUTE PROCEDURE public.notify_modified_job();

--
-- Name: notify_ethernet_settings(); Type: FUNCTION; Schema: public; Owner: insight
--

CREATE OR REPLACE FUNCTION public.notify_ethernet_settings() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE
  BEGIN
    IF (TG_OP = 'INSERT') THEN
      --raise notice 'insert trigger';   
      PERFORM pg_notify('ethernet_settings_channel',json_build_object('operation',1,'record',NEW)::text);
      RETURN NEW;
    ELSIF (TG_OP = 'UPDATE') THEN
      --raise notice 'update trigger';
      PERFORM pg_notify('ethernet_settings_channel',json_build_object('operation',2,'record',NEW)::text);
      RETURN NEW;
    ELSE 
      PERFORM pg_notify('ethernet_settings_channel',json_build_object('operation',0,'record',OLD)::text);
      RETURN OLD;
    END IF;
  END;
$$;

ALTER FUNCTION public.notify_ethernet_settings() OWNER TO insight;

--
-- Name: tbl_ethernet_settings trig_ethernet_settings; Type: TRIGGER; Schema: public; Owner: insight
--

CREATE TRIGGER trig_ethernet_settings AFTER INSERT OR UPDATE OR DELETE ON public.tbl_ethernet_settings FOR EACH ROW EXECUTE PROCEDURE public.notify_ethernet_settings();

--
-- Name: notify_fieldbus_settings(); Type: FUNCTION; Schema: public; Owner: insight
--

CREATE OR REPLACE FUNCTION public.notify_fieldbus_settings() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE
  BEGIN
    IF (TG_OP = 'INSERT') THEN
      --raise notice 'insert trigger';   
      PERFORM pg_notify('fieldbus_settings_channel',json_build_object('operation',1,'fld_toolmacaddress',NEW.fld_toolmacaddress)::text);
      RETURN NEW;
    ELSIF (TG_OP = 'UPDATE') THEN
      --raise notice 'update trigger';
      PERFORM pg_notify('fieldbus_settings_channel',json_build_object('operation',2,'fld_toolmacaddress',NEW.fld_toolmacaddress)::text);
      RETURN NEW;
    ELSE 
      PERFORM pg_notify('fieldbus_settings_channel',json_build_object('operation',0,'fld_toolmacaddress',OLD.fld_toolmacaddress)::text);
      RETURN OLD;
    END IF;
  END;
$$;

ALTER FUNCTION public.notify_fieldbus_settings() OWNER TO insight;

--
-- Name: tbl_fieldbus_settings trig_fieldbus_settings; Type: TRIGGER; Schema: public; Owner: insight
--

CREATE TRIGGER trig_fieldbus_settings AFTER INSERT OR UPDATE OR DELETE ON public.tbl_fieldbus_settings FOR EACH ROW EXECUTE PROCEDURE public.notify_fieldbus_settings();

--
-- Name: notify_eor_dataout_settings(); Type: FUNCTION; Schema: public; Owner: insight
--
CREATE OR REPLACE FUNCTION public.notify_eor_dataout_settings() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE
  BEGIN
    IF (TG_OP = 'DELETE') THEN
      PERFORM pg_notify('eor_dataout_settings_channel',json_build_object('operation',0,'record',OLD)::text);
      RETURN OLD;
    ELSIF (TG_OP = 'INSERT') THEN
      --raise notice 'insert trigger';   
      PERFORM pg_notify('eor_dataout_settings_channel',json_build_object('operation',1,'record',NEW)::text);
      RETURN NEW;
    ELSIF (TG_OP = 'UPDATE') THEN
      --raise notice 'update trigger';
      PERFORM pg_notify('eor_dataout_settings_channel',json_build_object('operation',2,'record',NEW)::text);
      RETURN NEW;
    ELSE 
      PERFORM pg_notify('eor_dataout_settings_channel',json_build_object('operation',3));
      RETURN NEW;
    END IF;
  END;
$$;

ALTER FUNCTION public.notify_eor_dataout_settings() OWNER TO insight;

--
-- Name: tbl_eor_dataout_settings trig_eor_dataout_settings; Type: TRIGGER; Schema: public; Owner: insight
--

CREATE TRIGGER trig_eor_dataout_settings AFTER INSERT OR DELETE OR UPDATE ON public.tbl_eor_dataout_settings FOR EACH ROW EXECUTE PROCEDURE public.notify_eor_dataout_settings();

--
-- Name: notify_controller_settings(); Type: FUNCTION; Schema: public; Owner: insight
--
CREATE OR REPLACE FUNCTION public.notify_controller_settings() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE
  BEGIN
    IF (TG_OP = 'UPDATE') THEN
      --raise notice 'update trigger';
      PERFORM pg_notify('controller_settings_channel',json_build_object('operation',2,'record',NEW)::text);
      RETURN NEW;
    ELSE 
      PERFORM pg_notify('controller_settings_channel',json_build_object('operation',3));
      RETURN NEW;
    END IF;
  END;
$$;

ALTER FUNCTION public.notify_controller_settings() OWNER TO insight;

--
-- Name: tbl_controller_settings trig_controller_settings; Type: TRIGGER; Schema: public; Owner: insight
--

CREATE TRIGGER trig_controller_settings AFTER UPDATE ON public.tbl_controller_settings FOR EACH ROW EXECUTE PROCEDURE public.notify_controller_settings();

--
-- Name: notify_factory_settings(); Type: FUNCTION; Schema: public; Owner: insight
--
CREATE OR REPLACE FUNCTION public.notify_factory_settings() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE
  BEGIN
    IF (TG_OP = 'INSERT') THEN
      --raise notice 'insert trigger';   
      PERFORM pg_notify('factory_settings_channel',json_build_object('operation',1,'record',NEW)::text);
      RETURN NEW;
    ELSIF (TG_OP = 'UPDATE') THEN
      --raise notice 'update trigger';
      PERFORM pg_notify('factory_settings_channel',json_build_object('operation',2,'record',NEW)::text);
      RETURN NEW;
    ELSIF (TG_OP = 'DELETE') THEN
      PERFORM pg_notify('factory_settings_channel',json_build_object('operation',0,'record',OLD)::text);
      RETURN OLD;
    ELSE 
      PERFORM pg_notify('factory_settings_channel',json_build_object('operation',3));
      RETURN NEW;
    END IF;
  END;
$$;

ALTER FUNCTION public.notify_factory_settings() OWNER TO insight;

--
-- Name: tbl_controller_settings trig_controller_settings; Type: TRIGGER; Schema: public; Owner: insight
--

CREATE TRIGGER trig_factory_settings AFTER UPDATE ON public.tbl_factory_settings FOR EACH ROW EXECUTE PROCEDURE public.notify_factory_settings();

--
-- Name: notify_temporary_tool_data(); Type: FUNCTION; Schema: public; Owner: insight
--
CREATE OR REPLACE FUNCTION public.notify_temporary_tool_data() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE
  BEGIN
    IF (TG_OP = 'DELETE') THEN
      PERFORM pg_notify('temporary_tool_data_channel',json_build_object('MacAddress',array_to_string(new.fld_toolmacaddress,'.'),'operation',0,'record',OLD)::text);
      RETURN OLD;
    ELSIF (TG_OP = 'INSERT') THEN
      --raise notice 'insert trigger';   
      PERFORM pg_notify('temporary_tool_data_channel',json_build_object('MacAddress',array_to_string(new.fld_toolmacaddress,'.'),'operation',1,'record',NEW)::text);
      RETURN NEW;
    ELSIF (TG_OP = 'UPDATE') THEN
      --raise notice 'update trigger';
      PERFORM pg_notify('temporary_tool_data_channel',json_build_object('MacAddress',array_to_string(new.fld_toolmacaddress,'.'),'operation',2,'record',NEW)::text);
      RETURN NEW;
    ELSE 
      PERFORM pg_notify('temporary_tool_data_channel',json_build_object('operation',3));
      RETURN NEW;
    END IF;
  END;
$$;

ALTER FUNCTION public.notify_temporary_tool_data() OWNER TO insight;

--
-- Name: notify_pfcs_tool_settings(); Type: FUNCTION; Schema: public; Owner: insight
--
CREATE OR REPLACE FUNCTION public.notify_pfcs_tool_settings() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE
  BEGIN
    IF (TG_OP = 'DELETE') THEN
      PERFORM pg_notify('pfcs_tool_settings_channel',json_build_object('MacAddress',array_to_string(new.fld_toolmacaddress,'.'),'operation',0,'record',OLD)::text);
      RETURN OLD;
    ELSIF (TG_OP = 'INSERT') THEN
      --raise notice 'insert trigger';   
      PERFORM pg_notify('pfcs_tool_settings_channel',json_build_object('MacAddress',array_to_string(new.fld_toolmacaddress,'.'),'operation',1,'record',NEW)::text);
      RETURN NEW;
    ELSIF (TG_OP = 'UPDATE') THEN
      --raise notice 'update trigger';
      PERFORM pg_notify('pfcs_tool_settings_channel',json_build_object('MacAddress',array_to_string(new.fld_toolmacaddress,'.'),'operation',2,'record',NEW)::text);
      RETURN NEW;
    ELSE 
      PERFORM pg_notify('pfcs_tool_settings_channel',json_build_object('operation',3));
      RETURN NEW;
    END IF;
  END;
$$;

ALTER FUNCTION public.notify_pfcs_tool_settings() OWNER TO insight;

--
-- Name: tbl_pfcs_tool_settings tbl_pfcs_tool_settings; Type: TRIGGER; Schema: public; Owner: insight
--

CREATE TRIGGER trig_pfcs_tool_settings AFTER INSERT OR DELETE OR UPDATE ON public.tbl_pfcs_tool_settings FOR EACH ROW EXECUTE PROCEDURE public.notify_pfcs_tool_settings();

--
-- Name: tbl_temporary_tool_data trig_temporary_tool_data; Type: TRIGGER; Schema: public; Owner: insight
--

CREATE TRIGGER trig_temporary_tool_data AFTER INSERT OR DELETE OR UPDATE ON public.tbl_temporary_tool_data FOR EACH ROW EXECUTE PROCEDURE public.notify_temporary_tool_data();



--
-- Data for Name: tbl_controller_settings; Type: TABLE DATA; Schema: public; Owner: insight
--
INSERT INTO public.tbl_controller_settings (
fld_pkey,
fld_pan_id           , fld_rf_channel        , fld_tx_power_level, 
fld_radio_fw_version , fld_radio_mac_address , fld_is_modified , fld_ext_radio
)VALUES 
(
 1,
 100, 3, 4, 
 '', '{0,0,0,0,0,0,0,0}', 0, 0
)on conflict(fld_pkey) do nothing; --this is simply to silence the error message

--
-- Data for Name: tbl_date_and_time_settings; Type: TABLE DATA; Schema: public; Owner: insight
--
INSERT INTO public.tbl_date_and_time_settings (
fld_pkey,
fld_dst          , fld_time_format , fld_date_format      ,
fld_setting_mode , fld_epoch_time  , fld_ntps_server_name ,
fld_dst_zone     , fld_time_zone
)VALUES 
(
 1,
 0, 0, 0, 
 0, 0, 'user.ntpserver.com', 
 'UTC', 'UTC'
)on conflict(fld_pkey) do nothing;

--
-- Data for Name: tbl_ethernet_settings; Type: TABLE DATA; Schema: public; Owner: insight
--
INSERT INTO public.tbl_ethernet_settings (
fld_pkey,
fld_eth0configuration    , fld_eth0linkstatus       , fld_eth0portlinkspeed,
fld_eth0portpridnsstatus , fld_eth0portsecdnsstatus , fld_eth0portipaddress,	
fld_eth0portsubnetmask   , fld_eth0portgetway       , fld_eth0portpridnsserver,
fld_eth0portsecdnsserver , fld_eth0macaddress       , 
fld_eth1configuration    , fld_eth1linkstatus       , fld_eth1portlinkspeed,
fld_eth1portpridnsstatus , fld_eth1portsecdnsstatus , fld_eth1portipaddress,
fld_eth1portsubnetmask   , fld_eth1portgetway       , fld_eth1portpridnsserver,
fld_eth1portsecdnsserver , fld_eth1macaddress
)VALUES 
(
 1,
 1, 1, 3, 
 1, 1, '192.168.5.5', 
 '255.255.255.0', '192.168.5.1', '000.000.000.000', 
 '000.000.000.000', '', 
 1, 1, 2, 
 1, 1, '176.168.5.6', 
 '255.255.255.0', '176.168.5.1', '000.000.000.000', 
 '000.000.000.000', ''
)on conflict(fld_pkey) do nothing;

--
-- Data for Name: tbl_system_info; Type: TABLE DATA; Schema: public; Owner: insight
--
INSERT INTO public.tbl_system_info (
fld_pkey,
fld_plant_name , fld_assembly_name , fld_station_name, 
fld_job        , fld_language      , fld_max_page_size, 
fld_brightness , fld_orientation
)VALUES 
(
 1,
 'PlantName', 'AssemblyName', 'StationName', 
 'Job', 'en', 100, 
 4, 0
)on conflict(fld_pkey) do nothing;

--
-- Data for Name: tbl_time_zones; Type: TABLE DATA; Schema: public; Owner: insight
--
TRUNCATE TABLE tbl_time_zones;


--
-- Data for Name: tbl_time_zones; Type: TABLE DATA; Schema: public; Owner: insight
--
INSERT INTO public.tbl_time_zones (
fld_pkey, fld_label, fld_time_zone, fld_offset, fld_dst_enable, fld_dst_zone
)VALUES 
( 1,'TIMEZONE.WEST','Etc,GMT+12',-43200,0,'Etc,GMT+12'),
( 2,'TIMEZONE.UTC11','Etc,GMT+11',-39600,0,'Etc,GMT+11'),
( 3,'TIMEZONE.ANCHORAGE','America,Anchorage',-32400,0,'Etc,GMT+9'),
( 4,'TIMEZONE.JUNEAU','America,Juneau',-32400,1,'Etc,GMT+9'),
( 5,'TIMEZONE.PACIFIC','America,Vancouver',-28800,1,'Etc,GMT+8'),
( 6,'TIMEZONE.MOUNTAIN','America,Chihuahua',-25200,0,'Etc,GMT+7'),
( 7,'TIMEZONE.ARIZONA','US,Arizona',-25200,0,'Etc,GMT+7'),
( 8,'TIMEZONE.SASKAT','Canada,Saskatchewan',-21600,0,'Etc,GMT+6'),
( 9,'TIMEZONE.CENTRAL','US,Central',-21600,1,'Etc,GMT+6'),
(10,'TIMEZONE.MONTERREY','America,Monterrey',-21600,0,'Etc,GMT+6'),
(11,'TIMEZONE.EASTERN','Canada,Eastern',-18000,1,'Etc,GMT+5'),
(12,'TIMEZONE.BOGOTA','America,Bogota',-18000,0,'Etc,GMT+5'),
(13,'TIMEZONE.INDIANA','America,Indiana,Indianapolis',-18000,1,'Etc,GMT+5'),
(14,'TIMEZONE.CARACAS','America,Caracas',-16200,0,'America,Caracas'),
(15,'TIMEZONE.ATLANTIC','Canada,Atlantic',-14400,1,'Etc,GMT+4'),
(16,'TIMEZONE.CUIABA','America,Cuiaba',-14400,0,'Etc,GMT+4'),
(17,'TIMEZONE.SANTIAGO','America,Santiago',-10800,0,'Etc,GMT+3'),
(18,'TIMEZONE.MANAUS','America,Manaus',-14400,0,'Etc,GMT+4'),
(19,'TIMEZONE.ASUNCION','America,Asuncion',-14400,0,'Etc,GMT+4'),
(20,'TIMEZONE.NEWFOUNDLAND','Canada,Newfoundland',-12600,1,'Canada,Newfoundland'),
(21,'TIMEZONE.SAOPAULO','America,Sao_Paulo',-10800,0,'Etc,GMT+3'),
(22,'TIMEZONE.GREENLAND','America,Godthab',-3600,1,'Etc,GMT+1'),
(23,'TIMEZONE.MONTEVIDEO','America,Montevideo',-10800,0,'Etc,GMT+3'),
(24,'TIMEZONE.CAYENNE','America,Cayenne',-10800,0,'Etc,GMT+3'),
(25,'TIMEZONE.AIRES','America,Buenos_Aires',-10800,0,'Etc,GMT+3'),
(26,'TIMEZONE.MIDATLANTIC','Etc,GMT+2',-7200,0,'Etc,GMT+2'),
(27,'TIMEZONE.AZORES','Atlantic,Azores',0,1,'Etc,GMT'),
(28,'TIMEZONE.DUBLIN','Europe,Dublin',0,1,'Etc,GMT'),
(29,'TIMEZONE.MONROVIA','Africa,Monrovia',0,0,'Etc,GMT'),
(30,'TIMEZONE.CASABLANCA','Africa,Casablanca',3600,1,'Etc,GMT'),
(31,'TIMEZONE.BELGRADE','Europe,Belgrade',3600,1,'Etc,GMT-1'),
(32,'TIMEZONE.UTC','UTC',0,0,'UTC'),
(33,'TIMEZONE.SARAJEVO','Europe,Sarajevo',3600,1,'Etc,GMT-1'),
(34,'TIMEZONE.BRUSSELS','Europe,Brussels',3600,1,'Etc,GMT-1'),
(35,'TIMEZONE.WCA','Africa,Algiers',3600,0,'Etc,GMT-1'),
(36,'TIMEZONE.AMSTERDAM','Europe,Amsterdam',3600,1,'Etc,GMT-1'),
(37,'TIMEZONE.WINDHOEK','Africa,Windhoek',7200,1,'Etc,GMT-2'),
(38,'TIMEZONE.MINSK','Europe,Minsk',7200,0,'Etc,GMT-2'),
(39,'TIMEZONE.CAIRO','Africa,Cairo',7200,0,'Etc,GMT-2'),
(40,'TIMEZONE.HELSINKI','Europe,Helsinki',7200,1,'Etc,GMT-2'),
(41,'TIMEZONE.ATHENS','Europe,Athens',7200,1,'Etc,GMT-2'),
(42,'TIMEZONE.JERUSALEM','Asia,Jerusalem',7200,1,'Etc,GMT-2'),
(43,'TIMEZONE.AMMAN','Asia,Amman',7200,0,'Etc,GMT-2'),
(44,'TIMEZONE.BEIRUT','Asia,Beirut',7200,1,'Etc,GMT-2'),
(45,'TIMEZONE.HARARE','Africa,Harare',7200,0,'Etc,GMT-2'),
(46,'TIMEZONE.DAMASCUS','Asia,Damascus',7200,1,'Etc,GMT-2'),
(47,'TIMEZONE.ISTANBUL','Europe,Istanbul',7200,1,'Etc,GMT-2'),
(48,'TIMEZONE.KUWAIT','Asia,Kuwait',10800,0,'Etc,GMT-3'),
(49,'TIMEZONE.BAGHDAD','Asia,Baghdad',10800,0,'Etc,GMT-3'),
(50,'TIMEZONE.NAIROBI','Africa,Nairobi',10800,0,'Etc,GMT-3'),
(51,'TIMEZONE.KALININGRAD','Europe,Kaliningrad',7200,0,'Etc,GMT-2'),
(52,'TIMEZONE.TEHRAN','Asia,Tehran',12600,1,'Asia,Tehran'),
(53,'TIMEZONE.MOSCOW','Europe,Moscow',10800,0,'Etc,GMT-3'),
(54,'TIMEZONE.MUSCAT','Asia,Muscat',14400,0,'Etc,GMT-4'),
(55,'TIMEZONE.BAKU','Asia,Baku',14400,1,'Etc,GMT-4'),
(56,'TIMEZONE.YEREVAN','Asia,Yerevan',14400,0,'Etc,GMT-4'),
(57,'TIMEZONE.TBILISI','Asia,Tbilisi',14400,0,'Asia,Tbilisi'),
(58,'TIMEZONE.MAURITIUS','Indian,Mauritius',14400,0,'Etc,GMT-4'),
(59,'TIMEZONE.KABUL','Asia,Kabul',16200,0,'Asia,Kabul'),
(60,'TIMEZONE.TASHKENT','Asia,Tashkent',18000,0,'Etc,GMT-5'),
(61,'TIMEZONE.KARACHI','Asia,Karachi',18000,0,'Etc,GMT-5'),
(62,'TIMEZONE.COLOMBO','Asia,Colombo',19800,0,'Asia,Colombo'),
(63,'TIMEZONE.CALCUTTA','Asia,Calcutta',19800,0,'Asia,Calcutta'),
(64,'TIMEZONE.KATHMANDU','Asia,Kathmandu',20700,0,'Asia,Kathmandu'),
(65,'TIMEZONE.YEKATERIN','Asia,Yekaterinburg',18000,0,'Etc,GMT-5'),
(66,'TIMEZONE.DHAKA','Asia,Dhaka',21600,0,'Etc,GMT-6'),
(67,'TIMEZONE.RANGOON','Asia,Rangoon',23400,0,'Asia,Rangoon'),
(68,'TIMEZONE.NOVOSIBIRSK','Asia,Novosibirsk',21600,0,'Etc,GMT-6'),
(69,'TIMEZONE.BANGKOK','Asia,Bangkok',25200,0,'Etc,GMT-7'),
(70,'TIMEZONE.KRASNOYARSK','Asia,Krasnoyarsk',25200,0,'Etc,GMT-7'),
(71,'TIMEZONE.HONGKONG','Asia,Hong_Kong',28800,0,'Etc,GMT-8'),
(72,'TIMEZONE.SINGAPORE','Asia,Singapore',28800,0,'Etc,GMT-8'),
(73,'TIMEZONE.TAIPEI','Asia,Taipei',28800,0,'Etc,GMT-8'),
(74,'TIMEZONE.PERTH','Australia,Perth',28800,0,'Etc,GMT-8'),
(75,'TIMEZONE.ULAANBAATAR','Asia,Ulaanbaatar',28800,1,'Etc,GMT-8'),
(76,'TIMEZONE.IRKUTSK','Asia,Irkutsk',28800,0,'Etc,GMT-8'),
(77,'TIMEZONE.SEOUL','Asia,Seoul',32400,0,'Etc,GMT-9'),
(78,'TIMEZONE.TOKYO','Asia,Tokyo',32400,0,'Etc,GMT-9'),
(79,'TIMEZONE.DARWIN','Australia,Darwin',34200,0,'Australia,Darwin'),
(80,'TIMEZONE.ADELAIDE','Australia,Adelaide',32400,1,'Etc,GMT-9'),
(81,'TIMEZONE.YAKUTSK','Asia,Yakutsk',32400,0,'Etc,GMT-9'),
(82,'TIMEZONE.MELBOURNE','Australia,Melbourne',36000,1,'Etc,GMT-10'),
(83,'TIMEZONE.BRISBANE','Australia,Brisbane',36000,0,'Etc,GMT-10'),
(84,'TIMEZONE.HOBART','Australia,Hobart',36000,1,'Etc,GMT-10'),
(85,'TIMEZONE.GUAM','Pacific,Guam',36000,0,'Etc,GMT-10'),
(86,'TIMEZONE.VLADIVOSTOK','Asia,Vladivostok',36000,0,'Etc,GMT-10'),
(87,'TIMEZONE.NOUMEA','Pacific,Noumea',39600,0,'Etc,GMT-11'),
(88,'TIMEZONE.MAGADAN','Asia,Magadan',36000,0,'Etc,GMT-10'),
(89,'TIMEZONE.FIJI','Pacific,Fiji',43200,0,'Etc,GMT-12'),
(90,'TIMEZONE.AUCKLAND','Pacific,Auckland',43200,1,'Etc,GMT-12'),
(91,'TIMEZONE.TARAWA','Etc,GMT-12',43200,0,'Etc,GMT-12'),
(92,'TIMEZONE.TONGATAPU','Pacific,Tongatapu',46800,0,'Etc,GMT-13'),
(93,'TIMEZONE.SAMOA','Pacific,Pago_Pago',-39600,0,'Etc,GMT-11')on conflict(fld_pkey) do nothing;

--
-- Data for Name: tbl_eor_headers; Type: TABLE DATA; Schema: public; Owner: insight
--
INSERT INTO public.tbl_eor_headers (
fld_id, fld_status, fld_display_name, fld_field
)VALUES 
(1,1,'EOR.CONTROLLER_CYCLENO','fld_controller_cycle_number'),
(2,1,'EOR.PROCESS_CYCLENO','fld_job_cycle_number'),
(3,1,'EOR.TOOL_SERIAL_NO', 'fld_tool_serial_number'),
(4,1,'EOR.LIFETIME_CYCLENO','fld_tool_lifetime_cycle_count'),
(5,1,'EOR.TOOL_CYCLENO', 'fld_tool_cycle_count'),
(6,1,'EOR.CYCLE_PASS_FAIL', 'fld_cycle_status'),
(7,1,'EOR.TORQUE_RESULT', 'fld_torque_result'),
(8,1,'EOR.ANGLE_RESULT','fld_angle_result'),
(9,1,'EOR.PROCESSID', 'fld_job_id'),
(10,1,'EOR.PSET_NUMBER', 'fld_pset_id'),
(11,1,'EOR.PSET_NAME','fld_pset_name'),
(12,1,'EOR.CURRENT_GANGCOUNT', 'fld_current_batch_count'),
(13,1,'EOR.TOTAL_GANGCOUNT', 'fld_total_batch_count'),
(14,1,'EOR.STEP_NUMBER', 'fld_step_number'),
(15,1,'EOR.TIMESTAMP','fld_time_stamp'),
(16,1,'EOR.STRATEGY', 'fld_strategy'),
(17,1,'EOR.TORQUE_UNIT', 'fld_torque_display_units'),
(18,1,'EOR.PROCESS_NAME', 'fld_job_name'),
(19,1,'EOR.FAULT_WORD', 'fld_fault_word'),
(20,1,'EOR.PEAK_TORQUE', 'fld_peak_torque'),
(21,1,'EOR.FINAL_ANGLE', 'fld_final_angle'),
(22,1,'EOR.OPERATOR_ALIAS', 'fld_operator_alias'),
(23,0,'EOR.LOCATION_ID', 'fld_tool_location_id'),
(24,0,'EOR.TARGET', 'fld_target'),
(25,0,'EOR.TORQUE_HIGH_LIMIT', 'fld_torque_high_limit'),
(26,0,'EOR.TORQUE_LOW_LIMIT','fld_torque_low_limit'),
(27,0,'EOR.ANGLE_HIGH_LIMIT','fld_angle_high_limit'),
(28,0,'EOR.ANGLE_LOW_LIMIT', 'fld_angle_low_limit'),
(29,0,'EOR.CURRENT_AT_PEAK_TORQUE','fld_current_at_peak_torque'),
(30,0,'EOR.SHIFTDOWN_SPEED', 'fld_down_shift_speed'),
(31,0,'EOR.FREE_SPEED','fld_free_speed'),
(32,0,'EOR.MAX_TOOL_SPEED','fld_max_tool_speed'),
(33,0,'EOR.TR', 'fld_torque_tr'),
(34,1,'EOR.TARCE_AVAILABLE', 'fld_trace_available'),
(35,0,'EOR.ETS_MODE','fld_ets_mode'),
(36,0,'EOR.FASTENING_TIME_STATUS', 'fld_tightening_time_status'),
(37,0,'EOR.FREERUN_ANGLE_TIME_STATUS', 'fld_free_run_angle_status'),
(38,0,'EOR.FASTENING_TIME_VALUE', 'fld_tightening_time'),
(39,0,'EOR.FREERUN_ANGLE_VALUE', 'fld_free_run_angle'),
(40,1,'EOR.IDENTIFIER_ONE','fld_identifier1'),
(41,1,'EOR.IDENTIFIER_TWO', 'fld_identifier2'),
(42,1,'EOR.IDENTIFIER_THREE', 'fld_identifier3'),
(43,1,'EOR.IDENTIFIER_FOUR', 'fld_identifier4'),
(44,1,'EOR.TOOL_NAME', 'fld_tool_name'),
(45,1,'SETTINGS.SYSTEM_INIT.STATION_NAME','fld_station_name'),
(46,1,'SETTINGS.SYSTEM_INIT.ASSEMBLY_NAME','fld_assembly_name'),
(47,0,'EOR.FAILURE_MODE', 'fld_failure_mode'),
(48,0,'TOOL_MACADDRESS','fld_tool_mac_address'),
(49,0,'JOB_MODIFIED_TIME','fld_job_modified_time'),
(50,0,'TRACE_REQUEST_FOR_PSET', 'fld_trace_request_for_pset'),
(51,0,'PROCESS.CREATEPROCESS.PREVAILINGTORQUE', 'fld_prevailing_torque')on conflict(fld_id) do nothing;

--
-- Data for Name: tbl_security; Type: TABLE DATA; Schema: public; Owner: insight
--
INSERT INTO public.tbl_security (
fld_first_name, fld_last_name, fld_user_name, fld_alias_name, fld_password, fld_session_timeout, fld_role
) VALUES 
('Admin','Admin','admin','admin','aW5nZXJzb2xs',30,'admin')on conflict(fld_user_id) do nothing;-- TTP 5819 commented out because code reverted. Tested in pgAdmin 

--TTP5819 commented out until verified.
--UPDATE public.tbl_fieldbus_settings
-- SET fld_input_behaviour = '{}', 
-- fld_input_start_byte_position = 0,
-- fld_input_end_byte_position = 0
-- WHERE fld_bus_control_status = 0;

--UPDATE public.tbl_dio_settings
--SET fld_no_of_inputs = '0',
--fld_input_bit_behaviour = '{}'
--WHERE fld_toolmacaddress IN (SELECT fld_toolmacaddress FROM public.tbl_fieldbus_settings WHERE fld_bus_control_status = 1);

ALTER TABLE IF EXISTS public.tbl_accessories_setting
	DROP CONSTRAINT IF EXISTS tbl_accessories_setting_fld_device_id_key;
	
ALTER TABLE IF EXISTS public.tbl_accessories_setting
	DROP CONSTRAINT IF EXISTS tbl_accessories_setting_pkey; 	

ALTER TABLE IF EXISTS public.tbl_accessories_name
	DROP CONSTRAINT IF EXISTS tbl_accessories_name_fld_device_id_key;
	
ALTER TABLE IF EXISTS public.tbl_backup_fieldbus_settings
	DROP CONSTRAINT IF EXISTS tbl_backup_fieldbus_settings_fld_toolmacaddress_key;
	
ALTER TABLE IF EXISTS public.tbl_pfcs_settings
	DROP CONSTRAINT IF EXISTS tbl_pfcs_settings_fld_toolmacaddress_key;
