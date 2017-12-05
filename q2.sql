set search_path to quizschema;
drop table if exists q2 cascade;

DROP VIEW IF EXISTS NumericHintCount CASCADE;
DROP VIEW IF EXISTS trueFalseHintCount CASCADE;
DROP VIEW IF EXISTS MCQHintCount CASCADE;
DROP VIEW IF EXISTS allCounts CASCADE;
DROP VIEW IF EXISTS countsWithText CASCADE;

CREATE TABLE q2 (
	questionId INT PRIMARY KEY,
	questionText TEXT NOT NULL,
	hints INT 
);

CREATE VIEW NumericHintCount AS
	SELECT questionId, count(hint) as hints
	FROM NumericQuestionsHints
	GROUP BY questionId;

CREATE VIEW trueFalseHintCount AS
	SELECT questionId, NULL as hints
	FROM true_false;

CREATE VIEW MCQHintCount AS
	SELECT questionId, count(hint) as hints
	FROM MultipleChoiceHints
	GROUP BY questionId;


CREATE VIEW allCounts as 
	SELECT * 
	FROM ((SELECT * FROM  NumericHintCount) UNION 
	(SELECT * FROM  trueFalseHintCount) UNION (
	SELECT * FROM MCQHintCount)) AS allQuestions;

CREATE VIEW countsWithText AS
	SELECT  allCounts.questionId as questionId, LEFT(questionText, 50), hints 
	FROM allCounts JOIN question on allCounts.questionId = question.questionId;

SELECT * FROM countsWithText;

	
