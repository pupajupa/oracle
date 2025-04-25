--запуск сравнения схем
ALTER SESSION SET CURRENT_SCHEMA = C##admin_schema;
BEGIN
    compare_schemes('C##SCHEMA_1', 'C##SCHEMA_2');
END;
----------------------

-- создание двух схем и выдача им прав
CREATE USER C##schema_1 IDENTIFIED BY schema1_password;
CREATE USER C##schema_2 IDENTIFIED BY schema2_password;
GRANT CONNECT, RESOURCE TO C##schema_1, C##schema_2;
----------------------------

---создание таблицы в схеме new_schema1
ALTER SESSION SET CURRENT_SCHEMA = C##schema_1;
CREATE TABLE schema1_table1 (
    id NUMBER,
    name VARCHAR2(100)
);
---------------------------------------

---создание той же таблицы но с новым полем description в схеме new_schema2
ALTER SESSION SET CURRENT_SCHEMA = C##schema_2;
CREATE TABLE schema1_table1 (
    id NUMBER,
    name VARCHAR2(100),
    description VARCHAR(100)
);
------------------------------------------------

--- создание функции в new_schema1
ALTER SESSION SET CURRENT_SCHEMA = C#schema_1;
CREATE OR REPLACE PROCEDURE hello_world IS
BEGIN
    DBMS_OUTPUT.PUT_LINE('Привет мир');
END hello_world;
----------------------------------

--- создание функции в new_schema2
ALTER SESSION SET CURRENT_SCHEMA = C##schema_2;
CREATE OR REPLACE PROCEDURE hello_world IS
BEGIN
    DBMS_OUTPUT.PUT_LINE('Привет');
END hello_world;
;

-- t2->t3->t1
ALTER SESSION SET CURRENT_SCHEMA = C##schema_1;
CREATE TABLE t1 (
    t1_id NUMBER PRIMARY KEY,
    val int  NOT NULL
);

CREATE TABLE t2 (
    t2_id NUMBER PRIMARY KEY,
    val  int NOT NULL
);

CREATE TABLE t3 (
    t3_id NUMBER PRIMARY KEY,
    val int NOT NULL
);

ALTER TABLE t1
ADD CONSTRAINT fk_t FOREIGN KEY (t1_id) REFERENCES t3(t3_id);

ALTER TABLE t3
ADD CONSTRAINT fk_table FOREIGN KEY (t3_id) REFERENCES t2(t2_id);
---------------------------------------


--циклическая зависимость
ALTER SESSION SET CURRENT_SCHEMA = C##schema_1;
ALTER TABLE t3
ADD CONSTRAINT fk_t1 FOREIGN KEY (t3_id) REFERENCES t1(t1_id);
-----------------------------------------------------------

