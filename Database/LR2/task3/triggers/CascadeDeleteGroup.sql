CREATE OR REPLACE TRIGGER groups_before_delete
AFTER DELETE ON GROUPS
FOR EACH ROW
BEGIN
    UPDATE trigger_control SET trigger_disabled = 1 WHERE trigger_name = 'update_c_val';
    DELETE FROM STUDENTS WHERE GROUP_ID = :OLD.ID;
    UPDATE trigger_control SET trigger_disabled = 0 WHERE trigger_name = 'update_c_val';
END;