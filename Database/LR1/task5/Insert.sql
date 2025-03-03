CREATE OR REPLACE PROCEDURE InsertIntoMyTable(
    p_val IN NUMBER
) IS
    v_new_id NUMBER;
BEGIN
    -- Находим максимальное значение id в таблице и увеличиваем его на
    SELECT NVL(MAX(id), 0) + 1 INTO v_new_id
    FROM MyTable;

    -- Вставляем новую строку в таблицу
    INSERT INTO MyTable (id, val)
    VALUES (v_new_id, p_val);

    -- Фиксируем изменения
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Строка успешно добавлена: ID = ' || v_new_id || ', VAL = ' || p_val);
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ошибка при вставке: ' || SQLERRM);
END;