CREATE USER C##admin_schema IDENTIFIED BY admin_password;
GRANT CONNECT, RESOURCE TO C##admin_schema;
GRANT SELECT ANY DICTIONARY TO C##admin_schema;
GRANT ALL PRIVILEGES TO C##ADMIN_SCHEMA;
SET SERVEROUTPUT ON;


ALTER SESSION SET CURRENT_SCHEMA = C##admin_schema;



CREATE USER C##dev_schema IDENTIFIED BY dev_password;
CREATE USER C##prod_schema IDENTIFIED BY prod_password;
GRANT CONNECT, RESOURCE TO C##dev_schema, C##prod_schema;


ALTER SESSION SET CURRENT_SCHEMA = C##dev_schema;

CREATE TABLE dev_table1 (
    id NUMBER,
    name VARCHAR2(100)
);
CREATE TABLE dev_table2 (
    id NUMBER,
    description VARCHAR2(200)
);
CREATE TABLE common_table (
    id NUMBER,
    name VARCHAR2(100),
    age NUMBER
);

CREATE OR REPLACE PROCEDURE hello_world IS
BEGIN
    DBMS_OUTPUT.PUT_LINE('Привет, мир!');
END hello_world;

ALTER SESSION SET CURRENT_SCHEMA = C##dev_schema;

-- Индекс для таблицы DEV_TABLE1
CREATE INDEX idx_dev_table1_name ON dev_table1(name);

-- Уникальный индекс для таблицы DEPARTMENTS
CREATE UNIQUE INDEX idx_departments_name ON departments(department_name);

ALTER SESSION SET CURRENT_SCHEMA = C##prod_schema;

CREATE TABLE prod_table1 (
    id NUMBER,
    name VARCHAR2(100)
);
CREATE TABLE prod_table3 (
    id NUMBER,
    details VARCHAR2(200)
);
CREATE TABLE common_table (
    id NUMBER,
    name VARCHAR2(100),
    email VARCHAR2(100)
);

ALTER SESSION SET CURRENT_SCHEMA = C##prod_schema;

-- Индекс для таблицы PROD_TABLE1
CREATE INDEX idx_prod_table1_name ON prod_table1(name);

-- Составной индекс для таблицы COMMON_TABLE
CREATE INDEX idx_common_table_name_email ON common_table(name, email);

ALTER SESSION SET CURRENT_SCHEMA = C##dev_schema;

CREATE TABLE departments (
    department_id NUMBER PRIMARY KEY,
    department_name VARCHAR2(100) NOT NULL
);

CREATE TABLE employees (
    employee_id NUMBER PRIMARY KEY,
    employee_name VARCHAR2(100) NOT NULL,
    department_id NUMBER,
    CONSTRAINT fk_department FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

CREATE TABLE projects (
    project_id NUMBER PRIMARY KEY,
    project_name VARCHAR2(100) NOT NULL,
    employee_id NUMBER,
    CONSTRAINT fk_employee FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

CREATE TABLE team_leads (
    lead_id NUMBER PRIMARY KEY,
    lead_name VARCHAR2(100) NOT NULL,
    team_id NUMBER
);

CREATE TABLE teams (
    team_id NUMBER PRIMARY KEY,
    team_name VARCHAR2(100) NOT NULL,
    lead_id NUMBER
);

ALTER TABLE team_leads
ADD CONSTRAINT fk_team FOREIGN KEY (team_id) REFERENCES teams(team_id);

ALTER TABLE teams
ADD CONSTRAINT fk_lead FOREIGN KEY (lead_id) REFERENCES team_leads(lead_id);

ALTER SESSION SET CURRENT_SCHEMA = C##dev_schema;

CREATE OR REPLACE PACKAGE pkg_example IS
    PROCEDURE calculate_bonus(emp_id NUMBER);
    FUNCTION get_employee_count RETURN NUMBER;
END pkg_example;

CREATE OR REPLACE PACKAGE BODY pkg_example IS
    PROCEDURE calculate_bonus(emp_id NUMBER) IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Бонус для сотрудника ' || emp_id);
    END;

    FUNCTION get_employee_count RETURN NUMBER IS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count FROM employees;
        RETURN v_count;
    END;
END pkg_example;


ALTER SESSION SET CURRENT_SCHEMA = C##prod_schema;

CREATE OR REPLACE PACKAGE pkg_example IS
    PROCEDURE calculate_bonus(emp_id NUMBER);
    -- В PROD-схеме функция get_employee_count отсутствует
END pkg_example;

CREATE OR REPLACE PACKAGE BODY pkg_example IS
    PROCEDURE calculate_bonus(emp_id NUMBER) IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Бонус для сотрудника ' || emp_id || ' (PROD)');
    END;
END pkg_example;

SET SERVEROUTPUT ON SIZE UNLIMITED;

ALTER SESSION SET CURRENT_SCHEMA = C##admin_schema;
BEGIN
    compare_schemes('C##DEV_SCHEMA', 'C##PROD_SCHEMA');
END;

