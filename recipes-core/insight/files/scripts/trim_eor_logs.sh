# Query to trim EOR logs to 500k
# Query to trim Event and Audit logs to 50k

psql db_insight << EOF
DELETE FROM tbl_eor_logs WHERE fld_controller_cycle_number <= (SELECT MAX(fld_controller_cycle_number) FROM tbl_eor_logs) - 500000;
DELETE FROM tbl_event_logs WHERE ctid IN ( SELECT ctid FROM tbl_event_logs ORDER BY fld_event_log_timestamp LIMIT (SELECT COUNT(*) FROM tbl_event_logs) - 50000);
DELETE FROM tbl_audit_logs WHERE ctid IN ( SELECT ctid FROM tbl_audit_logs ORDER BY fld_audit_log_timestamp LIMIT (SELECT COUNT(*) FROM tbl_audit_logs) - 50000);
EOF
