create PROCEDURE UpdateMyTable(
    p_id IN NUMBER,
    p_new_val IN NUMBER
) IS
BEGIN
    -- Обновляем значение в таблице
    UPDATE MyTable
    SET val = p_new_val
    WHERE id = p_id;
    -- Фиксируем изменения
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Строка успешно обновлена: ID = ' || p_id || ', новое VAL = ' || p_new_val);
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ошибка при обновлении: ' || SQLERRM);
END;

