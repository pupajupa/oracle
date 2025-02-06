create PROCEDURE InsertIntoMyTable(
    p_id IN NUMBER,
    p_val IN NUMBER
) IS
BEGIN
    -- Вставляем новую строку в таблицу
    INSERT INTO MyTable (id, val)
    VALUES (p_id, p_val);
    -- Фиксируем изменения
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Строка успешно добавлена: ID = ' || p_id || ', VAL = ' || p_val);
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK
        DBMS_OUTPUT.PUT_LINE('Ошибка при вставке: ' || SQLERRM);
END;

