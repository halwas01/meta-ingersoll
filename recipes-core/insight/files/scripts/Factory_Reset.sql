--
-- Data for Name: tbl_energy_scan_data; Type: TABLE DATA; Schema: public; Owner: insight
--
DELETE FROM public.tbl_energy_scan_data;

--
-- Data for Name: tbl_eor_logs; Type: TABLE DATA; Schema: public; Owner: insight
--
DELETE FROM public.tbl_eor_logs;

--
-- Data for Name: tbl_eor_tn; Type: TABLE DATA; Schema: public; Owner: insight
--
DELETE FROM public.tbl_eor_tn;

--
-- Data for Name: tbl_event_logs; Type: TABLE DATA; Schema: public; Owner: insight
--
DELETE FROM public.tbl_event_logs;

--
-- Data for Name: tbl_audit_logs; Type: TABLE DATA; Schema: public; Owner: insight
--
DELETE FROM public.tbl_audit_logs;

--
-- Data for Name: tbl_job_list; Type: TABLE DATA; Schema: public; Owner: insight
--
DELETE FROM public.tbl_job_list;

--
-- Data for Name: tbl_master_tool_data; Type: TABLE DATA; Schema: public; Owner: insight
--
DELETE FROM public.tbl_master_tool_data;

--
-- Data for Name: tbl_pset_list; Type: TABLE DATA; Schema: public; Owner: insight
--
DELETE FROM public.tbl_pset_list;

--
-- Data for Name: tbl_tool_position; Type: TABLE DATA; Schema: public; Owner: insight
--
DELETE FROM public.tbl_tool_position;

--
-- Data for Name: tbl_eor_headers; Type: TABLE DATA; Schema: public; Owner: insight
--
DELETE FROM public.tbl_eor_headers;

--
-- Data for Name: tbl_security; Type: TABLE DATA; Schema: public; Owner: insight
--
DELETE FROM public.tbl_security;

--
-- Data for Name: tbl_accessories_name; Type: TABLE DATA; Schema: public; Owner: insight
--
DELETE FROM public.tbl_accessories_name;

--
-- Data for Name: tbl_accessories_setting; Type: TABLE DATA; Schema: public; Owner: insight
--
DELETE FROM public.tbl_accessories_setting;

--
-- Data for Name: tbl_saved_settings; Type: TABLE DATA; Schema: public; Owner: insight
--
DELETE FROM public.tbl_saved_settings;

--
-- Data for Name: tbl_backup_fieldbus_settings; Type: TABLE DATA; Schema: public; Owner: insight
--
DELETE FROM public.tbl_backup_fieldbus_settings;

--
-- Data for Name: tbl_modifed_job; Type: TABLE DATA; Schema: public; Owner: insight
--
DELETE FROM public.tbl_modifed_job;

--
-- Data for Name: tbl_pfcs_settings; Type: TABLE DATA; Schema: public; Owner: insight
--
DELETE FROM public.tbl_pfcs_settings;

--
-- Name: tbl_event_logs_fld_event_id_seq; Type: SEQUENCE; Schema: public; Owner: insight
--
ALTER SEQUENCE public.tbl_event_logs_fld_event_id_seq RESTART;

--
-- Name: tbl_audit_logs_fld_audit_id_seq; Type: SEQUENCE; Schema: public; Owner: insight
--
ALTER SEQUENCE public.tbl_audit_logs_fld_audit_id_seq RESTART;

--
-- Name: tbl_job_list_fld_job_id_seq; Type: SEQUENCE; Schema: public; Owner: insight
--
ALTER SEQUENCE public.tbl_job_list_fld_job_id_seq RESTART;

--
-- Name: tbl_pset_list_fld_pset_id_seq; Type: SEQUENCE; Schema: public; Owner: insight
--
ALTER SEQUENCE public.tbl_pset_list_fld_pset_id_seq RESTART;

--
-- Name: tbl_security_fld_user_id_seq; Type: SEQUENCE; Schema: public; Owner: insight
--
ALTER SEQUENCE public.tbl_security_fld_user_id_seq RESTART;

--
-- Name: tbl_saved_settings_fld_id_seq; Type: SEQUENCE; Schema: public; Owner: insight
--
ALTER SEQUENCE public.tbl_saved_settings_fld_id_seq RESTART;

--
-- Data for Name: tbl_system_info; Type: TABLE DATA; Schema: public; Owner: insight
--
UPDATE public.tbl_system_info
SET fld_plant_name = 'PlantName', 
fld_assembly_name = 'AssemblyName',
fld_station_name = 'StationName',
fld_job = 'Job',
fld_language = 'en',
fld_max_page_size = 100,
fld_brightness = 4,
fld_orientation = 0;

--
-- Data for Name: tbl_controller_settings; Type: TABLE DATA; Schema: public; Owner: insight
--
UPDATE public.tbl_controller_settings
SET fld_pan_id = 100, 
fld_rf_channel = 3,
fld_tx_power_level = 4,
fld_is_modified = 0,
fld_ext_radio = 0,
fld_tcp_enable_status = 0,
fld_ethportselected = 0,
fld_lan_port_no = 6565;

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
(50,0,'TRACE_REQUEST_FOR_PSET', 'fld_trace_request_for_pset')on conflict(fld_id) do nothing;

--
-- Data for Name: tbl_security; Type: TABLE DATA; Schema: public; Owner: insight
--
INSERT INTO public.tbl_security (
fld_first_name, fld_last_name, fld_user_name, fld_alias_name, fld_password, fld_session_timeout, fld_role
) VALUES 
('Admin','Admin','admin','admin','aW5nZXJzb2xs',30,'admin')on conflict(fld_user_id) do nothing;