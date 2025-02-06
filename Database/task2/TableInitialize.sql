DECLARE
    random_val NUMBER;
BEGIN
    FOR i IN 1..10000 LOOP
        random_val := ROUND(DBMS_RANDOM.VALUE(1, 1000));
        INSERT INTO MyTable (id, val)
        VALUES (i, random_val);
    END LOOP;
    COMMIT;
END;