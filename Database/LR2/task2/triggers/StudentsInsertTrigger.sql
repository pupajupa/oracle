CREATE OR REPLACE TRIGGER students_before_insert
BEFORE INSERT ON STUDENTS
FOR EACH ROW
DECLARE
    v_group_count NUMBER;
    v_trigger_disabled NUMBER;

BEGIN

    SELECT trigger_disabled INTO v_trigger_disabled FROM trigger_control WHERE trigger_name = 'students_before_insert';
    IF v_trigger_disabled = 1 THEN
        RETURN;
    END IF;

    IF :NEW.GROUP_ID IS NOT NULL THEN
        SELECT COUNT(*) INTO v_group_count FROM GROUPS WHERE GROUPS.ID = :NEW.GROUP_ID;
        IF v_group_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Group with id GROUP_ID not found');
        END IF;

    ELSE
        RAISE_APPLICATION_ERROR(-20001, 'Group Id is required');
    END IF;

    IF :NEW.ID IS NULL THEN
        SELECT students_seq.NEXTVAL INTO :NEW.ID FROM DUAL;
    ELSE
        DECLARE
            v_count NUMBER;
        BEGIN
            SELECT COUNT(*) INTO v_count FROM STUDENTS WHERE ID=:NEW.ID;
            IF v_count > 0 THEN
                SELECT students_seq.NEXTVAL INTO :NEW.ID FROM DUAL;
            ELSE
                NULL;
            END IF;
        END;
    END IF;
END;