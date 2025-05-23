--тест селекта с джоином
DECLARE
  v_json CLOB := '{
    "operation": "SELECT",
    "columns": ["students.first_name", "courses.course_name"],
    "tables": ["students"],
    "joins": [
      {
        "type": "INNER JOIN",
        "table": "courses",
        "on": "students.course_id = courses.course_id"
      }
    ],
    "where": {
      "conditions": [
        {
          "column": "students.grade",
          "operator": ">=",
          "value": "80"
        }
      ],
      "logical_operator": "AND"
    }
  }';
  v_cur SYS_REFCURSOR;
  v_name students.first_name%TYPE;
  v_course courses.course_name%TYPE;
BEGIN
  v_cur := json_select_handler(v_json);
  LOOP
    FETCH v_cur INTO v_name, v_course;
    EXIT WHEN v_cur%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(v_name || ' | ' || v_course);
  END LOOP;
  CLOSE v_cur;
END;
/

-- тест where с подхапросом
DECLARE
  v_json CLOB := '{
    "operation": "SELECT",
    "columns": ["first_name"],
    "tables": ["students"],
    "where": {
      "conditions": [
        {
          "column": "course_id",
          "operator": "IN",
          "subquery": {
            "columns": "course_id",
            "tables": "courses",
            "conditions": "instructor = ''Teacher №1''"
          }
        }
      ],
      "logical_operator": "AND"
    }
  }';

  v_cur SYS_REFCURSOR;
  v_name students.first_name%TYPE;
BEGIN
  v_cur := json_select_handler(v_json);
  LOOP
    FETCH v_cur INTO v_name;
    EXIT WHEN v_cur%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(v_name);
  END LOOP;
  CLOSE v_cur;
END;
/

--тест селекта с джоином и подзапросом
DECLARE
  v_json CLOB := '{
    "operation": "SELECT",
    "columns": ["students.first_name", "courses.course_name"],
    "tables": ["students"],
    "joins": [
      {
        "type": "INNER JOIN",
        "table": "courses",
        "on": "students.course_id = courses.course_id"
      }
    ],
    "where": {
      "conditions": [
        {
          "column": "students.grade",
          "operator": ">=",
          "value": "80"
        },
        {
          "column": "students.course_id",
          "operator": "IN",
          "subquery": {
            "columns": "course_id",
            "tables": "courses",
            "conditions": "instructor = ''Teacher №1''"
          }
        }
      ],
      "logical_operator": "AND"
    }
  }';
  v_cur SYS_REFCURSOR;
  v_name students.first_name%TYPE;
  v_course courses.course_name%TYPE;
BEGIN
  v_cur := json_select_handler(v_json);
  LOOP
    FETCH v_cur INTO v_name, v_course;
    EXIT WHEN v_cur%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(v_name || ' | ' || v_course);
  END LOOP;
  CLOSE v_cur;
END;
/

--тест селекта с нот ин
DECLARE
  v_json CLOB := '{
    "operation": "SELECT",
    "columns": ["first_name"],
    "tables": ["students"],
    "where": {
      "conditions": [
        {
          "column": "course_id",
          "operator": "NOT IN",
          "subquery": {
            "columns": "course_id",
            "tables": "courses",
            "conditions": "instructor = ''Teacher №1''"
          }
        }
      ],
      "logical_operator": "AND"
    }
  }';
  v_cur SYS_REFCURSOR;
  v_name students.first_name%TYPE;
BEGIN
  v_cur := json_select_handler(v_json);
  LOOP
    FETCH v_cur INTO v_name;
    EXIT WHEN v_cur%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(v_name);
  END LOOP;
  CLOSE v_cur;
END;
/

--тест селекта с exists
DECLARE
  v_json CLOB := '{
    "operation": "SELECT",
    "columns": ["first_name"],
    "tables": ["students"],
    "where": {
      "conditions": [
        {
          "column": "",
          "operator": "EXISTS",
          "subquery": {
            "columns": "course_id",
            "tables": "courses",
            "conditions": "instructor = ''Teacher №2'' AND course_id = students.course_id"
          }
        }
      ],
      "logical_operator": "AND"
    }
  }';
  v_cur SYS_REFCURSOR;
  v_name students.first_name%TYPE;
BEGIN
  v_cur := json_select_handler(v_json);
  LOOP
    FETCH v_cur INTO v_name;
    EXIT WHEN v_cur%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(v_name);
  END LOOP;
  CLOSE v_cur;
END;
/

--тест селекта с not exists
DECLARE
  v_json CLOB := '{
    "operation": "SELECT",
    "columns": ["first_name"],
    "tables": ["students"],
    "where": {
      "conditions": [
        {
          "column": "",
          "operator": "NOT EXISTS",
          "subquery": {
            "columns": "course_id",
            "tables": "courses",
            "conditions": "course_name = ''English'' AND course_id = students.course_id"
          }
        }
      ],
      "logical_operator": "AND"
    }
  }';
  v_cur SYS_REFCURSOR;
  v_name students.first_name%TYPE;
BEGIN
  v_cur := json_select_handler(v_json);
  LOOP
    FETCH v_cur INTO v_name;
    EXIT WHEN v_cur%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(v_name);
  END LOOP;
  CLOSE v_cur;
END;
/

--тест на джоин с условием
DECLARE
  v_json CLOB := '{
    "operation": "SELECT",
    "columns": ["students.first_name", "courses.course_name", "students.grade"],
    "tables": ["students"],
    "joins": [
      {
        "type": "INNER JOIN",
        "table": "courses",
        "on": "students.course_id = courses.course_id"
      }
    ],
    "where": {
      "conditions": [
        {
          "column": "students.grade",
          "operator": ">=",
          "value": "80"
        }
      ]
    }
  }';
  v_cur SYS_REFCURSOR;
  v_name students.first_name%TYPE;
  v_course courses.course_name%TYPE;
  v_grade students.grade%TYPE;
BEGIN
  v_cur := json_select_handler(v_json);
  DBMS_OUTPUT.PUT_LINE('Students with grade >= 80:');
  LOOP
    FETCH v_cur INTO v_name, v_course, v_grade;
    EXIT WHEN v_cur%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(v_name || ' | ' || v_course || ' | ' || v_grade);
  END LOOP;
  CLOSE v_cur;
END;
/

--INSERT INTO students (student_id, first_name, course_id, grade) VALUES (8, 'Семен', 2, 79);
--тест с груп бай
DECLARE
  v_json CLOB := '{
    "operation": "SELECT",
    "columns": ["courses.course_name", "COUNT(students.student_id)"],
    "tables": ["courses"],
    "joins": [
      {
        "type": "LEFT JOIN",
        "table": "students",
        "on": "courses.course_id = students.course_id"
      }
    ],
    "group_by": ["courses.course_name"]
  }';
  v_cur SYS_REFCURSOR;
  v_course courses.course_name%TYPE;
  v_count NUMBER;
BEGIN
  v_cur := json_select_handler(v_json);
  DBMS_OUTPUT.PUT_LINE('Number of students by course:');
  LOOP
    FETCH v_cur INTO v_course, v_count;
    EXIT WHEN v_cur%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(v_course || ' | ' || v_count);
  END LOOP;
  CLOSE v_cur;
END;
/

--тест с агрешатной функцией
DECLARE
  v_json CLOB := '{
    "operation": "SELECT",
    "columns": ["courses.course_name", "AVG(students.grade)"],
    "tables": ["courses"],
    "joins": [
      {
        "type": "INNER JOIN",
        "table": "students",
        "on": "courses.course_id = students.course_id"
      }
    ],
    "group_by": ["courses.course_name"]
  }';
  v_cur SYS_REFCURSOR;
  v_course courses.course_name%TYPE;
  v_avg NUMBER;
BEGIN
  v_cur := json_select_handler(v_json);
  DBMS_OUTPUT.PUT_LINE('Average course rating:');
  LOOP
    FETCH v_cur INTO v_course, v_avg;
    EXIT WHEN v_cur%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(v_course || ' | ' || ROUND(v_avg, 1));
  END LOOP;
  CLOSE v_cur;
END;
/

DECLARE
  v_result VARCHAR2(4000);
BEGIN
  v_result := json_ddl_handler('{
    "operation": "CREATE",
    "table": "DEP",
    "columns": [
      {"name": "DEPT_ID", "type": "NUMBER", "constraints": "PRIMARY KEY"},
      {"name": "DEPT_NAME", "type": "VARCHAR2(100)"}
    ]
  }');
  DBMS_OUTPUT.PUT_LINE(v_result);

  EXECUTE IMMEDIATE 'INSERT INTO DEP (DEPT_ID, DEPT_NAME) VALUES (1, ''IT Department'')';
  COMMIT;
END;
/

DECLARE
  v_result VARCHAR2(4000);
BEGIN
  v_result := json_ddl_handler('{
    "operation": "CREATE",
    "table": "EMP",
    "columns": [
      {"name": "EMP_ID", "type": "NUMBER", "constraints": "PRIMARY KEY"},
      {"name": "NAME", "type": "VARCHAR2(100)"},
      {"name": "DEPT_ID", "type": "NUMBER"}
    ],
    "foreign_keys": [
      {
        "column": "DEPT_ID",
        "references": {"table": "DEP", "column": "DEPT_ID"}
      }
    ]
  }');
  DBMS_OUTPUT.PUT_LINE(v_result);
END;
/


/--тест простого инсерта
DECLARE
  v_json CLOB := '{
    "operation": "INSERT",
    "table": "EMP",
    "columns": ["NAME","DEPT_ID"],
    "values":["Nick","1"]
                 }';
  v_result VARCHAR2(100);
BEGIN
  v_result := json_dml_handler(v_json);
  DBMS_OUTPUT.PUT_LINE(v_result);

  FOR rec IN (SELECT * FROM EMP) LOOP
    DBMS_OUTPUT.PUT_LINE('Name: ' || rec.NAME || ', Id: ' || rec.EMP_ID);
  END LOOP;
END;
/




DECLARE
  v_id NUMBER;
BEGIN
  INSERT INTO EMP (NAME, DEPT_ID) VALUES ('First', 1);
  SELECT EMP_ID INTO v_id FROM EMP WHERE NAME = 'First';
  DBMS_OUTPUT.PUT_LINE('Generated EMP_ID: ' || v_id);
  COMMIT;
  INSERT INTO EMP (NAME, DEPT_ID) VALUES ('Second', 1);
  SELECT EMP_ID INTO v_id FROM EMP WHERE NAME = 'Second';
  DBMS_OUTPUT.PUT_LINE('Generated EMP_ID: ' || v_id);
  COMMIT;
  INSERT INTO EMP (NAME, DEPT_ID) VALUES ('3', 1);
  SELECT EMP_ID INTO v_id FROM EMP WHERE NAME = '3';
  DBMS_OUTPUT.PUT_LINE('Generated EMP_ID: ' || v_id);
  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    RAISE;
END;
/

BEGIN
  DBMS_OUTPUT.PUT_LINE(json_ddl_handler('{"operation":"DROP","table":"EMP"}'));
  DBMS_OUTPUT.PUT_LINE(json_ddl_handler('{"operation":"DROP","table":"DEP"}'));
END;
/

DECLARE
  v_json CLOB := '{
    "operation": "CREATE",
    "table": "test_table",
    "columns": [
      { "name": "id", "type": "NUMBER","constraints": "PRIMARY KEY" },
      { "name": "name", "type": "VARCHAR2(100)" },
      { "name": "created_at", "type": "DATE" }
    ]
  }';
  v_result VARCHAR2(200);
BEGIN
  v_result := json_ddl_handler(v_json);
  DBMS_OUTPUT.PUT_LINE(v_result);

  FOR rec IN (
    SELECT table_name, column_name, data_type
    FROM user_tab_columns
    WHERE table_name = 'TEST_TABLE'
    ORDER BY column_id
  ) LOOP
    DBMS_OUTPUT.PUT_LINE('Table: ' || rec.table_name || ', Column: ' || rec.column_name || ', Type: ' || rec.data_type);
  END LOOP;
END;
/

DECLARE
  v_json CLOB := '{
    "operation": "DROP",
    "table": "test_table"
  }';
  v_result VARCHAR2(200);
BEGIN
  v_result := json_ddl_handler(v_json);
  DBMS_OUTPUT.PUT_LINE(v_result);

  -- проверка, что таблица удалена черех выборку из USER_TABLES
  DECLARE
    v_dummy NUMBER;
  BEGIN
    SELECT COUNT(*) INTO v_dummy FROM user_tables WHERE table_name = 'TEST_TABLE';
    DBMS_OUTPUT.PUT_LINE('Remaining tables with name TEST_TABLE: ' || v_dummy);
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error checking table existence: ' || SQLERRM);
  END;
END;


/--тест простого инсерта
DECLARE
  v_json CLOB := '{
    "operation": "INSERT",
    "table": "test_table",
    "columns": ["name"],
    "values":["Nick"]
                 }';
  v_result VARCHAR2(100);
BEGIN
  v_result := json_dml_handler(v_json);
  DBMS_OUTPUT.PUT_LINE(v_result);

  FOR rec IN (SELECT * FROM TEST_TABLE) LOOP
    DBMS_OUTPUT.PUT_LINE('Name: ' || rec.NAME || ', Id: ' || rec.ID || ', Time: ' || rec.CREATED_AT);
  END LOOP;
END;
/


--тест простого инсерта
DECLARE
  v_json CLOB := '{
    "operation": "INSERT",
    "table": "students",
    "columns": ["student_id", "first_name", "course_id", "grade"],
    "values": ["4", "Andrew", "2", "88"]
  }';
  v_result VARCHAR2(100);
BEGIN
  v_result := json_dml_handler(v_json);
  DBMS_OUTPUT.PUT_LINE(v_result);

  FOR rec IN (SELECT student_id, first_name, course_id, grade FROM students ORDER BY student_id) LOOP
    DBMS_OUTPUT.PUT_LINE('ID: ' || rec.student_id || ', Name: ' || rec.first_name || ', course_id: ' || rec.course_id || ', grade: ' || rec.grade);
  END LOOP;
END;
/

--тест апдейта
DECLARE
  v_json CLOB := '{
    "operation": "UPDATE",
    "table": "students",
    "set": [
      { "column": "grade", "value": "90" }
    ],
    "where": {
      "conditions": [
        {
          "column": "student_id",
          "operator": "=",
          "value": "4"
        }
      ],
      "logical_operator": "AND"
    }
  }';
  v_result VARCHAR2(100);
BEGIN
  v_result := json_dml_handler(v_json);
  DBMS_OUTPUT.PUT_LINE(v_result);

  FOR rec IN (SELECT student_id, first_name, course_id, grade FROM students ORDER BY student_id) LOOP
    DBMS_OUTPUT.PUT_LINE('ID: ' || rec.student_id || ', Имя: ' || rec.first_name || ', course_id: ' || rec.course_id || ', grade: ' || rec.grade);
  END LOOP;
END;
/

--тест удаления
DECLARE
  v_json CLOB := '{
    "operation": "DELETE",
    "table": "students",
    "where": {
      "conditions": [
        {
          "column": "student_id",
          "operator": "=",
          "value": "4"
        }
      ],
      "logical_operator": "AND"
    }
  }';
  v_result VARCHAR2(100);
BEGIN
  v_result := json_dml_handler(v_json);
  DBMS_OUTPUT.PUT_LINE(v_result);

  FOR rec IN (SELECT student_id, first_name, course_id, grade FROM students ORDER BY student_id) LOOP
    DBMS_OUTPUT.PUT_LINE('ID: ' || rec.student_id || ', Имя: ' || rec.first_name || ', course_id: ' || rec.course_id || ', grade: ' || rec.grade);
  END LOOP;
END;
/

--тест апдейта с подзапросом
DECLARE
  v_json CLOB := '{
    "operation": "UPDATE",
    "table": "students",
    "set": [
      { "column": "grade", "value": "99" }
    ],
    "where": {
      "conditions": [
        {
          "column": "course_id",
          "operator": "IN",
          "subquery": {
            "columns": "course_id",
            "tables": "courses",
            "conditions": "instructor = ''Teacher №1''"
          }
        }
      ],
      "logical_operator": "AND"
    }
  }';
  v_result VARCHAR2(100);
BEGIN
  v_result := json_dml_handler(v_json);
  DBMS_OUTPUT.PUT_LINE(v_result);

  FOR rec IN (SELECT student_id, first_name, course_id, grade FROM students ORDER BY student_id) LOOP
    DBMS_OUTPUT.PUT_LINE('ID: ' || rec.student_id || ', Name: ' || rec.first_name ||
                         ', course_id: ' || rec.course_id || ', grade: ' || rec.grade);
  END LOOP;
END;
/

--тест удаления с подзапросом
DECLARE
  v_json CLOB := '{
    "operation": "DELETE",
    "table": "students",
    "where": {
      "conditions": [
        {
          "column": "course_id",
          "operator": "IN",
          "subquery": {
            "columns": "course_id",
            "tables": "courses",
            "conditions": "course_name = ''Russian''"
          }
        }
      ],
      "logical_operator": "AND"
    }
  }';
  v_result VARCHAR2(100);
BEGIN
  v_result := json_dml_handler(v_json);
  DBMS_OUTPUT.PUT_LINE(v_result);

  FOR rec IN (SELECT student_id, first_name, course_id, grade FROM students ORDER BY student_id) LOOP
    DBMS_OUTPUT.PUT_LINE('ID: ' || rec.student_id || ', Name: ' || rec.first_name ||
                         ', course_id: ' || rec.course_id || ', grade: ' || rec.grade);
  END LOOP;
END;
/

CREATE OR REPLACE FUNCTION process_select_part(p_query CLOB) RETURN VARCHAR2 IS
  v_columns      VARCHAR2(1000);
  v_tables       VARCHAR2(1000);
  v_join_clause  VARCHAR2(1000) := '';
  v_where        VARCHAR2(4000) := '';
  v_group_by     VARCHAR2(1000) := '';
  v_sql          VARCHAR2(4000);
  v_logical_op   VARCHAR2(5) := 'AND';
BEGIN
  SELECT LISTAGG(column_name, ', ')
    INTO v_columns
  FROM JSON_TABLE(TO_CHAR(p_query), '$.columns[*]'
       COLUMNS (column_name VARCHAR2(100) PATH '$'));
  SELECT LISTAGG(table_name, ', ') WITHIN GROUP (ORDER BY table_name)
    INTO v_tables
  FROM JSON_TABLE(TO_CHAR(p_query), '$.tables[*]'
       COLUMNS (table_name VARCHAR2(50) PATH '$'));

  BEGIN
    SELECT LISTAGG(jt.join_type || ' ' || jt.join_table || ' ON ' || jt.join_condition, ' ')
      INTO v_join_clause
    FROM JSON_TABLE(TO_CHAR(p_query), '$.joins[*]'
           COLUMNS (
             join_type      VARCHAR2(20) PATH '$.type',
             join_table     VARCHAR2(50) PATH '$.table',
             join_condition VARCHAR2(200) PATH '$.on'
           )) jt;
  EXCEPTION
    WHEN OTHERS THEN
      v_join_clause := '';
  END;

  BEGIN
    FOR cond IN (
      SELECT *
      FROM JSON_TABLE(TO_CHAR(p_query), '$.where.conditions[*]'
        COLUMNS (
          condition_column     VARCHAR2(100) PATH '$.column',
          condition_operator   VARCHAR2(20)  PATH '$.operator',
          condition_value      VARCHAR2(100) PATH '$.value',
          subquery_columns     VARCHAR2(4000) PATH '$.subquery.columns',
          subquery_tables      VARCHAR2(4000) PATH '$.subquery.tables',
          subquery_conditions  VARCHAR2(4000) PATH '$.subquery.conditions'
        )
      )
    ) LOOP
      IF cond.subquery_columns IS NOT NULL AND cond.subquery_tables IS NOT NULL THEN
        DECLARE
          v_subquery VARCHAR2(1000);
        BEGIN
          v_subquery := '(SELECT ' ||
                        RTRIM(REPLACE(REPLACE(cond.subquery_columns, '["', ''), '"]', ''), '"') ||
                        ' FROM ' || RTRIM(REPLACE(REPLACE(cond.subquery_tables, '["', ''), '"]', ''), '"');
          IF cond.subquery_conditions IS NOT NULL THEN
            v_subquery := v_subquery || ' WHERE ' ||
                          RTRIM(REPLACE(REPLACE(cond.subquery_conditions, '["', ''), '"]', ''), '"');
          END IF;
          v_subquery := v_subquery || ')';
          v_where := v_where || cond.condition_column || ' ' || cond.condition_operator || ' ' || v_subquery || ' ' || v_logical_op || ' ';
        END;
      ELSE
        v_where := v_where || cond.condition_column || ' ' || cond.condition_operator || ' ' ||
          CASE
            WHEN REGEXP_LIKE(cond.condition_value, '^\d+(\.\d+)?$') THEN cond.condition_value
            ELSE '''' || REPLACE(cond.condition_value, '''', '''''') || ''''
          END || ' ' || v_logical_op || ' ';
      END IF;
    END LOOP;
    IF v_where IS NOT NULL THEN
      v_where := ' WHERE ' || RTRIM(v_where, ' ' || v_logical_op || ' ');
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      v_where := '';
  END;
  BEGIN
    SELECT LISTAGG(column_name, ', ')
      INTO v_group_by
    FROM JSON_TABLE(TO_CHAR(p_query), '$.group_by[*]'
         COLUMNS (column_name VARCHAR2(100) PATH '$'));
  EXCEPTION
    WHEN OTHERS THEN
      v_group_by := '';
  END;

  v_sql := 'SELECT ' || v_columns ||
           ' FROM ' || v_tables ||
           ' ' || v_join_clause ||
           v_where ||
           CASE WHEN v_group_by IS NOT NULL AND v_group_by <> '' THEN ' GROUP BY ' || v_group_by ELSE '' END;

  RETURN v_sql;
END;
/


CREATE OR REPLACE FUNCTION json_select_handler_union(p_json CLOB) RETURN SYS_REFCURSOR IS
  v_sql             VARCHAR2(4000);
  v_cur             SYS_REFCURSOR;
  v_union_type      VARCHAR2(10) := 'UNION';
  v_union_all_flag  NUMBER := 0;
BEGIN
  v_sql := process_select_part(p_json);
  DBMS_OUTPUT.PUT_LINE(v_sql);

  BEGIN
    SELECT NVL(union_type, 'UNION'),
           NVL(union_all, 0)
      INTO v_union_type,
           v_union_all_flag
      FROM JSON_TABLE(TO_CHAR(p_json), '$.union'
           COLUMNS (
             union_type VARCHAR2(10) PATH '$.type',
             union_all  NUMBER PATH '$.all'
           ));
    IF v_union_all_flag = 1 THEN
      v_union_type := 'UNION ALL';
    END IF;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
  END;

  FOR u IN (
    SELECT JSON_SERIALIZE(jt.query RETURNING VARCHAR2(4000)) AS query_str,
           jt.all_flag
      FROM JSON_TABLE(TO_CHAR(p_json), '$.union.queries[*]'
           COLUMNS (
             query    FORMAT JSON PATH '$',
             all_flag NUMBER PATH '$.all'
           )) jt
  ) LOOP
    v_sql := v_sql || ' ' || v_union_type ||
             CASE WHEN u.all_flag = 1 THEN ' ALL' ELSE '' END || ' ' ||
             process_select_part(u.query_str);
  END LOOP;
  DBMS_OUTPUT.PUT_LINE(v_sql);
  OPEN v_cur FOR v_sql;
  RETURN v_cur;
EXCEPTION
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20001, 'Ошибка формирования запроса: ' || SQLERRM || '. SQL: ' || v_sql);
END;
/

--тест юнион имен студентов и преподавателей (уникальные значения)
DECLARE
  v_json CLOB := '{
    "operation": "SELECT",
    "columns": ["first_name"],
    "tables": ["students"],
    "union": {
      "queries": [
        {
          "columns": ["instructor"],
          "tables": ["courses"]
        }
      ]
    }
  }';
  v_cur SYS_REFCURSOR;
  v_name VARCHAR2(50);
BEGIN
  v_cur := json_select_handler_union(v_json);
  DBMS_OUTPUT.PUT_LINE('Результат UNION:');
  LOOP
    FETCH v_cur INTO v_name;
    EXIT WHEN v_cur%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(v_name);
  END LOOP;
  CLOSE v_cur;
END;
/

--тест юнион олл с дубликатами (все записи)
DECLARE
  v_json CLOB := '{
    "operation": "SELECT",
    "columns": ["first_name"],
    "tables": ["students"],
    "union": {
      "type": "UNION ALL",
      "queries": [
        {
          "columns": ["instructor"],
          "tables": ["courses"]
        },
        {
          "columns": ["first_name"],
          "tables": ["students"],
          "where": {
            "conditions": [{"column": "grade", "operator": ">", "value": "80"}]
          }
        }
      ]
    }
  }';
  v_cur SYS_REFCURSOR;
  v_name VARCHAR2(50);
BEGIN
  v_cur := json_select_handler_union(v_json);
  DBMS_OUTPUT.PUT_LINE('UNION ALL с дубликатами:');
  LOOP
    FETCH v_cur INTO v_name;
    EXIT WHEN v_cur%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(v_name);
  END LOOP;
  CLOSE v_cur;
END;
/

--тест юнион с разными столбцами
DECLARE
  v_json CLOB := '{
    "operation": "SELECT",
    "columns": ["first_name", "TO_CHAR(grade)"],
    "tables": ["students"],
    "union": {
      "queries": [
        {
          "columns": ["instructor", "course_name"],
          "tables": ["courses"]
        }
      ]
    }
  }';
  v_cur SYS_REFCURSOR;
  v_col1 VARCHAR2(50);
  v_col2 VARCHAR2(100);
BEGIN
  v_cur := json_select_handler_union(v_json);
  DBMS_OUTPUT.PUT_LINE('UNION с разными типами данных:');
  LOOP
    FETCH v_cur INTO v_col1, v_col2;
    EXIT WHEN v_cur%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(v_col1 || ' | ' || v_col2);
  END LOOP;
  CLOSE v_cur;
END;
/

select * from STUDENTS;
select * from COURSES;

--тест юнион с условиями where
DECLARE
  v_json CLOB := '{
    "operation": "SELECT",
    "columns": ["first_name", "grade"],
    "tables": ["students"],
    "where": {
      "conditions": [
        {"column": "grade", "operator": ">=", "value": "80"}
      ]
    },
    "union": {
      "queries": [
        {
          "columns": ["instructor", "course_id"],
          "tables": ["courses"],
          "where": {
            "conditions": [
              {"column": "instructor", "operator": "LIKE", "value": "%Иванов%"}
            ]
          }
        }
      ]
    }
  }';
  v_cur SYS_REFCURSOR;
  v_col1 VARCHAR2(50);
  v_col2 VARCHAR2(100);
BEGIN
  v_cur := json_select_handler_union(v_json);
  DBMS_OUTPUT.PUT_LINE('UNION с условиями WHERE:');
  LOOP
    FETCH v_cur INTO v_col1, v_col2;
    EXIT WHEN v_cur%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(v_col1 || ' | ' || v_col2);
  END LOOP;
  CLOSE v_cur;
END;
/

