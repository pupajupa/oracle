create PROCEDURE DeleteFromMyTable(
    p_id IN NUMBER
) IS
BEGIN
    DELETE FROM MyTable
    WHERE id = p_id;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Строка успешно удалена: ID = ' || p_id);
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ошибка при удалении: ' || SQLERRM);
END;