drop table courses cascade constraints;
drop table students cascade constraints;


CREATE TABLE courses (
    course_id   NUMBER PRIMARY KEY,
    course_name VARCHAR2(100),
    instructor  VARCHAR2(50)
);

CREATE TABLE students (
    student_id  NUMBER PRIMARY KEY,
    first_name  VARCHAR2(50),
    course_id   NUMBER,
    grade       NUMBER,
    CONSTRAINT fk_course
        FOREIGN KEY (course_id)
        REFERENCES courses(course_id)
);

INSERT INTO courses (course_id, course_name, instructor) VALUES (1, 'English', 'Teacher №1');
INSERT INTO courses (course_id, course_name, instructor) VALUES (2, 'Russian', 'Teacher №2');
INSERT INTO courses (course_id, course_name, instructor) VALUES (3, 'Germany', 'Teacher №3');

INSERT INTO students (student_id, first_name, course_id, grade) VALUES (1, 'Anton', 1, 90);
INSERT INTO students (student_id, first_name, course_id, grade) VALUES (2, 'Max', 2, 82);
INSERT INTO students (student_id, first_name, course_id, grade) VALUES (3, 'Dima', 1, 78);
INSERT INTO students (student_id, first_name, course_id, grade) VALUES (5, 'Genry', 1, 65);
INSERT INTO students (student_id, first_name, course_id, grade) VALUES (6, 'Jonh', 2, 67);
INSERT INTO students (student_id, first_name, course_id, grade) VALUES (7, 'Jack', 1, 87);
COMMIT;