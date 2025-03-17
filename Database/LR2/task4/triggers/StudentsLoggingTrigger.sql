CREATE OR REPLACE TRIGGER students_audit_trigger
AFTER INSERT OR UPDATE OR DELETE ON STUDENTS
FOR EACH ROW
DECLARE
    v_action_type VARCHAR2(10);
    v_trigger_disabled NUMBER;
    v_group_name VARCHAR2(100);
BEGIN
    SELECT trigger_disabled INTO v_trigger_disabled FROM trigger_control WHERE trigger_name = 'students_audit_trigger';

    IF v_trigger_disabled = 1 THEN
        RETURN;
    END IF;

    BEGIN
        IF INSERTING OR UPDATING THEN
            SELECT NAME INTO v_group_name
            FROM GROUPS
            WHERE ID = :NEW.GROUP_ID;
        ELSIF DELETING THEN
            BEGIN
            SELECT GROUP_NAME INTO v_group_name
            FROM (
                SELECT GROUP_NAME
                FROM STUDENTS_LOG
                WHERE STUDENT_ID = :OLD.ID
                ORDER BY LOG_ID DESC
            )
            WHERE ROWNUM = 1;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_group_name := NULL; 
            END;
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_group_name := NULL; 
    END;

    IF INSERTING THEN
        v_action_type := 'INSERT';
        INSERT INTO STUDENTS_LOG (LOG_ID, ACTION_TYPE, STUDENT_ID, NAME, GROUP_ID, GROUP_NAME, TIMESTAMP)
        VALUES (students_log_seq.NEXTVAL, v_action_type, :NEW.ID, :NEW.NAME, :NEW.GROUP_ID, v_group_name, SYSTIMESTAMP);
    ELSIF UPDATING THEN
        v_action_type := 'UPDATE';
        INSERT INTO STUDENTS_LOG (LOG_ID, ACTION_TYPE, STUDENT_ID, NAME, GROUP_ID, GROUP_NAME, OLD_NAME, OLD_GROUP_ID, TIMESTAMP)
        VALUES (students_log_seq.NEXTVAL, v_action_type, :NEW.ID, :NEW.NAME, :NEW.GROUP_ID, v_group_name, :OLD.NAME, :OLD.GROUP_ID, SYSTIMESTAMP);
    ELSIF DELETING THEN
        v_action_type := 'DELETE';
        INSERT INTO STUDENTS_LOG (LOG_ID, ACTION_TYPE, STUDENT_ID, NAME, GROUP_ID, GROUP_NAME, OLD_NAME, OLD_GROUP_ID, TIMESTAMP)
        VALUES (students_log_seq.NEXTVAL, v_action_type, :OLD.ID, :OLD.NAME, :OLD.GROUP_ID, v_group_name, :OLD.NAME, :OLD.GROUP_ID, SYSTIMESTAMP);
    END IF;
END;