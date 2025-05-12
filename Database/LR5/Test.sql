INSERT INTO customers (customer_id, customer_name) VALUES (4, 'Иван Иванов');
INSERT INTO products (product_id, product_name, price) VALUES (4, 'Книга', 500);
INSERT INTO orders (order_id, customer_id, product_id, quantity) VALUES (4, 4, 4, 4);
COMMIT;

UPDATE customers SET customer_name = 'Вася' WHERE customer_id = 1;
UPDATE products SET price = 110000 WHERE product_id = 1;
UPDATE orders SET quantity = 3 WHERE order_id = 1;
COMMIT;

DELETE FROM orders WHERE order_id = 2;
DELETE FROM products WHERE product_id = 2;
DELETE FROM customers WHERE customer_id = 2;
begin
    generate_changes_report(p_file_path => 'report_1.html', p_include_details => TRUE);
end;

begin
    generate_changes_report(p_since_timestamp => TO_TIMESTAMP('2025-05-12 00:12:00.000', 'YYYY-MM-DD HH24:MI:SS.FF3'), p_file_path => 'changes_report1.html', p_include_details => TRUE);
end;

SELECT * FROM customers_history;
SELECT * FROM products_history;
SELECT * FROM orders_history;
SELECT * FROM customers;
SELECT * FROM products;
SELECT * FROM orders;

INSERT INTO customers (customer_id, customer_name) VALUES (1, 'Анна');
INSERT INTO customers (customer_id, customer_name) VALUES (2, 'Иван');
INSERT INTO customers (customer_id, customer_name) VALUES (3, 'Мария');

INSERT INTO products (product_id, product_name, price) VALUES (1, 'Ноутбук', 100000);
INSERT INTO products (product_id, product_name, price) VALUES (2, 'Телефон', 50000);
INSERT INTO products (product_id, product_name, price) VALUES (3, 'Наушники', 15000);

INSERT INTO orders (order_id, customer_id, product_id, quantity) VALUES (1, 1, 1, 1);
INSERT INTO orders (order_id, customer_id, product_id, quantity) VALUES (2, 2, 2, 2);
INSERT INTO orders (order_id, customer_id, product_id, quantity) VALUES (3, 3, 3, 3);
COMMIT;
begin
    generate_changes_report(p_file_path => 'test1_inserts.html', p_include_details => TRUE);
end;


BEGIN
  history_mgmt.rollback_to(300000); -- 300000 мс = 5 минут
END;