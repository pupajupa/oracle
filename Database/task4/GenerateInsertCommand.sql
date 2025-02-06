CREATE OR REPLACE FUNCTION GenerateInsertCommand(p_id IN NUMBER) RETURN VARCHAR2 IS
    v_id    NUMBER;
    v_val   NUMBER;
    v_sql   VARCHAR2(200);
BEGIN
    -- Получаем данные по указанному ID
    SELECT id, val
    INTO v_id, v_val
    FROM MyTable
    WHERE id = p_id;
    -- Формируем команду INSERT
    v_sql := 'INSERT INTO MyTable (id, val) VALUES (' || v_id || ', ' || v_val || ');';
    -- Выводим команду в консоль
    DBMS_OUTPUT.PUT_LINE(v_sql);
    -- Возвращаем команду (опционально)
    RETURN v_sql;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: строка с ID = ' || p_id || ' не найдена.');
        RETURN NULL;
END;