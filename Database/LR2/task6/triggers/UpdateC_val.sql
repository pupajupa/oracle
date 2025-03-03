CREATE OR REPLACE TRIGGER update_c_val
AFTER INSERT OR DELETE OR UPDATE ON STUDENTS
DECLARE
    v_count NUMBER;
    v_trigger_disabled NUMBER;
BEGIN
    SELECT trigger_disabled INTO v_trigger_disabled FROM trigger_control WHERE trigger_name = 'update_c_val';
    IF v_trigger_disabled = 1 THEN
        RETURN;
    END IF;

    FOR rec IN (SELECT GROUP_ID FROM STUDENTS GROUP BY GROUP_ID) LOOP
        SELECT COUNT(*) INTO v_count
        FROM STUDENTS
        WHERE GROUP_ID = rec.GROUP_ID;

        UPDATE GROUPS
        SET C_VAL = v_count
        WHERE ID = rec.GROUP_ID;
    END LOOP;
END;