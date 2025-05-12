DECLARE
  v_json CLOB := '{
    "operation": "SELECT",
    "columns": ["students.first_name", "courses.course_name", "students.grade"],
    "tables": ["students"],
    "joins": [
      {
        "type": "INNER JOIN",
        "table": "courses",
        "on": "students.course_id = courses.course_id AND courses.instructor = ''Teacher №1''"
      }
    ],
    "where": {
      "conditions": [
        {
          "column": "students.grade",
          "operator": "BETWEEN",
          "value": "70 AND 90"
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
  DBMS_OUTPUT.PUT_LINE('Students with grade between 70 and 90 in courses taught by Teacher №1:');
  LOOP
    FETCH v_cur INTO v_name, v_course, v_grade;
    EXIT WHEN v_cur%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(v_name || ' | ' || v_course || ' | ' || v_grade);
  END LOOP;
  CLOSE v_cur;
END;
/