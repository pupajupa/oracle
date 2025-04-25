CREATE TABLE departments (
    department_id NUMBER PRIMARY KEY,
    department_name VARCHAR2(100),
    location_id NUMBER
);

CREATE TABLE locations (
    location_id NUMBER PRIMARY KEY,
    city VARCHAR2(100)
);

CREATE TABLE employees (
    employee_id NUMBER PRIMARY KEY,
    first_name VARCHAR2(100),
    last_name VARCHAR2(100),
    department_id NUMBER,
    salary NUMBER,
    CONSTRAINT fk_department FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

INSERT INTO locations (location_id, city) VALUES (1, 'New York');
INSERT INTO locations (location_id, city) VALUES (2, 'Los Angeles');

INSERT INTO departments (department_id, department_name, location_id) VALUES (10, 'Finance', 1);
INSERT INTO departments (department_id, department_name, location_id) VALUES (20, 'HR', 2);

INSERT INTO employees (employee_id, first_name, last_name, department_id, salary) VALUES (1, 'John', 'Doe', 10, 6000);
INSERT INTO employees (employee_id, first_name, last_name, department_id, salary) VALUES (2, 'Jane', 'Smith', 10, 7000);
INSERT INTO employees (employee_id, first_name, last_name, department_id, salary) VALUES (3, 'Alice', 'Johnson', 20, 4000);

--тестирование select запросов
--1
DECLARE
    result CLOB;
    v_json    CLOB;
    v_cursor  SYS_REFCURSOR;
    v_employee_id employees.employee_id%TYPE;
    v_first_name  employees.first_name%TYPE;
BEGIN
    v_json := '{
        "queryType": "SELECT",
        "columns": ["employees.employee_id", "employees.first_name"],
        "tables": ["employees"],
        "joins": [
            {
                "type": "INNER",
                "table": "departments",
                "on": "employees.department_id = departments.department_id"
            }
        ],
        "filters": [
            {
                "column": "employees.department_id",
                "operator": "IN",
                "subquery": {
                    "queryType": "SELECT",
                    "columns": ["department_id"],
                    "tables": ["departments"],
                    "filters": [
                        {
                            "column": "location_id",
                            "operator": "=",
                            "value": "1"
                        }
                    ],
                    "orderBy": []
                }
            },
            {
                "column": "employees.salary",
                "operator": ">",
                "value": "5000"
            }
        ],
        "orderBy": [
            {
                "column": "employees.last_name",
                "direction": "ASC"
            }
        ]
    }';

     v_cursor := get_dynamic_cursor_select(v_json);

    LOOP
        FETCH v_cursor INTO v_employee_id, v_first_name;
        EXIT WHEN v_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Employee ID: ' || v_employee_id || ', First Name: ' || v_first_name);
    END LOOP;

    CLOSE v_cursor;
END;
----------------------------------
--2
DECLARE
    result CLOB;
    v_json    CLOB;
    v_cursor  SYS_REFCURSOR;
    v_department_id departments.department_id%TYPE;
    v_employee_count NUMBER;
BEGIN
    v_json := '{
        "queryType": "SELECT",
        "columns": ["employees.department_id", "COUNT(employees.employee_id) AS employee_count"],
        "tables": ["employees"],
        "joins": [
            {
                "type": "INNER",
                "table": "departments",
                "on": "employees.department_id = departments.department_id"
            }
        ],
        "filters": [
            {
                "column": "employees.salary",
                "operator": ">",
                "value": "5000"
            }
        ],
        "groupBy": ["employees.department_id"],
        "orderBy": [
            {
                "column": "employee_count",
                "direction": "DESC"
            }
        ]
    }';

    v_cursor := get_dynamic_cursor_select(v_json);

    LOOP
        FETCH v_cursor INTO v_department_id, v_employee_count;
        EXIT WHEN v_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Department ID: ' || v_department_id || ', Employee Count: ' || v_employee_count);
    END LOOP;

    CLOSE v_cursor;
END;
----------------------------------------------------------------------------------

--тестирование DML-запросов

--INSERT
DECLARE
    v_json CLOB;
    v_query CLOB;
BEGIN
    v_json := '{
        "queryType": "INSERT",
        "table": "employees",
        "columns": ["employee_id", "first_name", "last_name", "department_id", "salary"],
        "values": ["10", "''John''", "''Doe''", "10","1000"]
    }';

    v_query := EXECUTE_DYNAMIC_DML_QUERY(v_json);
    DBMS_OUTPUT.PUT_LINE(v_query);
END;
-------------------------------------

--UPDATE
DECLARE
    v_json CLOB;
    v_query CLOB;
BEGIN
    v_json := '{
        "queryType": "UPDATE",
        "table": "employees",
        "set": [
            {"column": "first_name", "value": "''Jane''"},
            {"column": "last_name", "value": "''Smith''"}
        ],
        "filters": [
            {"column": "employee_id", "operator": "=", "value": "10"}
        ]
    }';

    v_query := EXECUTE_DYNAMIC_DML_QUERY(v_json);

    DBMS_OUTPUT.PUT_LINE(v_query);
END;
--------------------------------

--DELETE
DECLARE
    v_json CLOB;
    v_query CLOB;
BEGIN
    v_json := '{
        "queryType": "DELETE",
        "table": "employees",
        "filters": [
            {"column": "employee_id", "operator": "=", "value": "10"}
        ]
    }';

    v_query := EXECUTE_DYNAMIC_DML_QUERY(v_json);

    DBMS_OUTPUT.PUT_LINE(v_query);
END;
-----------------------------------------------------------------------------------------------

--тестирование DDL запросов

--CREATE TABLE employees1
DECLARE
    v_json       CLOB;
    v_result     VARCHAR2(4000);
BEGIN
    v_json := '{
        "ddlType": "CREATE",
        "tableName": "employees1",
        "columns": [
            {"name": "employee_id", "type": "NUMBER", "primaryKey": "true"},
            {"name": "first_name", "type": "VARCHAR2(100)"},
            {"name": "last_name", "type": "VARCHAR2(100)"},
            {"name": "department_id", "type": "NUMBER"}
        ]
    }';

    v_result := execute_dynamic_ddl_query(v_json);
    DBMS_OUTPUT.PUT_LINE(v_result);
END;
-----------------------------------------

--CREATE TABLE employees2
DECLARE
    v_json       CLOB;
    v_result     VARCHAR2(4000);
BEGIN
    v_json := '{
        "ddlType": "CREATE",
        "tableName": "employees2",
        "columns": [
            {"name": "employee2_id", "type": "NUMBER", "primaryKey": "true"},
            {"name": "first_name", "type": "VARCHAR2(100)"},
            {"name": "last_name", "type": "VARCHAR2(100)"},
            {"name": "employee_id", "type": "NUMBER", "foreignKey": {"table": "employees1", "column": "employee_id"}}
        ]
    }';

    v_result := execute_dynamic_ddl_query(v_json);
    DBMS_OUTPUT.PUT_LINE(v_result);
END;
----------------------------------------

--DROP TABLE employees1
DECLARE
    v_json       CLOB;
    v_result     VARCHAR2(4000);
BEGIN
    v_json := '{
        "ddlType": "DROP",
        "tableName": "employees1"
    }';

    v_result := execute_dynamic_ddl_query(v_json);
    DBMS_OUTPUT.PUT_LINE(v_result);
END;
----------------------------------------------------------------------------------