CREATE OR REPLACE PROCEDURE restore_students(
    p_log_id IN NUMBER
) IS
    v_group_id NUMBER;
BEGIN
    UPDATE trigger_control SET trigger_disabled = 1 WHERE TRIGGER_NAME = 'students_audit_trigger';
    UPDATE trigger_control SET trigger_disabled = 1 WHERE TRIGGER_NAME = 'students_before_insert';
    DELETE FROM STUDENTS;

    FOR rec IN (
        SELECT *
        FROM STUDENTS_LOG
        WHERE LOG_ID <= p_log_id
        ORDER BY LOG_ID ASC
    ) LOOP
        BEGIN
            SELECT ID INTO v_group_id
            FROM GROUPS
            WHERE NAME = rec.GROUP_NAME;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_group_id := group_seq.NEXTVAL;
                INSERT INTO GROUPS (ID, NAME)
                VALUES (v_group_id, rec.GROUP_NAME);
        END;

        IF rec.ACTION_TYPE = 'INSERT' THEN
            INSERT INTO STUDENTS (ID, NAME, GROUP_ID)
            VALUES (rec.STUDENT_ID, rec.NAME, v_group_id);
        ELSIF rec.ACTION_TYPE = 'DELETE' THEN
            DELETE FROM STUDENTS WHERE ID = rec.STUDENT_ID;
        ELSIF rec.ACTION_TYPE = 'UPDATE' THEN
            UPDATE STUDENTS
            SET NAME = rec.NAME, GROUP_ID = v_group_id
            WHERE ID = rec.STUDENT_ID;
        END IF;
    END LOOP;

    COMMIT;

    UPDATE trigger_control SET trigger_disabled = 0 WHERE TRIGGER_NAME = 'students_audit_trigger';
    UPDATE trigger_control SET trigger_disabled = 0 WHERE TRIGGER_NAME = 'students_before_insert';
END;