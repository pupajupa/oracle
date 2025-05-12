INSERT INTO customers (customer_id, customer_name) VALUES (1, 'Павел Шукайло');
COMMIT;
begin
    generate_changes_report(p_file_path => 'report.html', p_include_details => TRUE);
end;

begin
    generate_changes_report(p_since_timestamp => TO_TIMESTAMP('2025-05-12 00:12:00.000', 'YYYY-MM-DD HH24:MI:SS.FF3'), p_file_path => 'report_timestamp.html', p_include_details => TRUE);
end;


INSERT INTO customers (customer_id, customer_name) VALUES (3, 'Павел');
UPDATE customers SET customer_name = 'Вася' WHERE customer_id = 1;
DELETE FROM customers WHERE customer_id = 1;

BEGIN
  history_mgmt.rollback_to(300000);
END;