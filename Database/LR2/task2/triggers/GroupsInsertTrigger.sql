CREATE OR REPLACE TRIGGER groups_before_insert_trigger
BEFORE INSERT ON GROUPS
FOR EACH ROW
DECLARE
    v_count_name INTEGER;
BEGIN

    SELECT COUNT(*)
    INTO v_count_name
    FROM GROUPS
    WHERE NAME = :NEW.NAME;

    IF v_count_name > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Group name already exists');
    END IF;

    IF :NEW.ID IS NULL THEN
        SELECT group_seq.NEXTVAL INTO :NEW.ID FROM DUAL;
    ELSE
        DECLARE
            v_count NUMBER;
        BEGIN
            SELECT COUNT(*) INTO v_count FROM GROUPS WHERE ID=:NEW.ID;
            IF v_count > 0 THEN
                SELECT group_seq.NEXTVAL INTO :NEW.ID FROM DUAL;
            ELSE
                NULL;
            END IF;
        END;
    END IF;
END;