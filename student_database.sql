CREATE DATABASE student;
USE student;
SHOW TABLES;
SELECT * FROM student_list;
SELECT * FROM student_response;
SELECT * FROM correct_answer;
SELECT * FROM question_paper_code;

ALTER TABLE student_list
RENAME COLUMN ï»¿roll_number TO roll_number;

ALTER TABLE question_paper_code
RENAME COLUMN ï»¿paper_code TO question_paper_code;

WITH cte AS (
	SELECT sl.roll_number, sl.student_name, sl.class, sl.section, sl.school_name,
		SUM(CASE WHEN qpc.subject = 'Math' AND sr.option_marked = ca.correct_option AND sr.option_marked <> 'e'
		THEN 1
		ELSE 0 
		END) AS math_correct,
		SUM(CASE WHEN qpc.subject = 'Math' AND sr.option_marked <> ca.correct_option AND sr.option_marked <> 'e'
		THEN 1
		ELSE 0 
		END) AS math_wrong,
		SUM(CASE WHEN qpc.subject = 'Math' AND sr.option_marked = 'e'
		THEN 1
		ELSE 0
		END) AS Math_yet_to_learn,
        SUM( CASE WHEN qpc.subject = 'Math' THEN 1
        ELSE 0
        END) AS total_math,
		SUM(CASE WHEN qpc.subject = 'Science' AND sr.option_marked = ca.correct_option AND sr.option_marked <> 'e'
		THEN 1
		ELSE 0 
		END) AS Science_correct,
		SUM(CASE WHEN qpc.subject = 'Science' AND sr.option_marked <> ca.correct_option AND sr.option_marked <> 'e'
		THEN 1
		ELSE 0 
		END) AS Science_wrong,
	    SUM(CASE WHEN qpc.subject = 'Science' AND sr.option_marked = 'e'
		THEN 1
		ELSE 0
		END) AS Science_yet_to_learn,
        SUM(CASE WHEN qpc.subject ='Science' THEN 1
        ELSE 0
        END) AS Total_science
	FROM student_list AS sl
	JOIN student_response AS sr ON sl.roll_number = sr.roll_number
	JOIN correct_answer AS ca ON sr.question_paper_code = ca.question_paper_code
	AND sr.question_number = ca.question_number
	JOIN question_paper_code AS qpc ON ca.question_paper_code = qpc.question_paper_code
	GROUP BY sl.roll_number, sl.student_name, sl.class, sl.section, sl.school_name)
SELECT roll_number, student_name, class, section, school_name, math_correct, math_wrong, math_yet_to_learn, math_correct AS math_score, round((math_correct/total_math)*100,2) AS math_percentage,
Science_correct, science_wrong, science_yet_to_learn, science_correct AS science_score, round((science_correct/total_science)*100,2) AS science_percentage
FROM cte;
