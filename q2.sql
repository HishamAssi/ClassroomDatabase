set search_path to quizschema;


DROP VIEW IF EXISTS NumericHintCount CASCADE;
DROP VIEW IF EXISTS trueFalseHintCount CASCADE;
DROP VIEW IF EXISTS MCQHintCount CASCADE;
DROP VIEW IF EXISTS allCounts CASCADE;
DROP VIEW IF EXISTS countsWithText CASCADE;
DROP VIEW IF EXISTS ZeroMCQ CASCADE;
DROP VIEW IF EXISTS ZeroNum CASCADE;

CREATE VIEW NumericHintCount AS
	SELECT questionId, count(hint) as hints
	FROM NumericQuestionsHints
	GROUP BY questionId;

CREATE VIEW trueFalseHintCount AS
	SELECT questionId, NULL  as hints
	FROM true_false;

CREATE VIEW MCQHintCount AS
	SELECT questionId, count(hint) as hints
	FROM MultipleChoiceHints
	GROUP BY questionId;

CREATE VIEW ZeroMCQ AS
	SELECT questionId, 0 as hints 
 	FROM ((SELECT questionId FROM MultipleChoice) 
		       except 
	(SELECT questionId FROM MultipleChoiceHints)  ) AS MCQ;
	
CREATE VIEW ZeroNum AS
	SELECT questionId, 0 as hints 
 	FROM ((SELECT questionId FROM NumericQuestions) 
		       except 
	(SELECT questionId FROM NumericQuestionsHints ) ) AS NUM;
	


CREATE VIEW allCounts as 
	SELECT * 
	FROM ((SELECT * FROM  NumericHintCount) UNION 
	(SELECT * FROM  trueFalseHintCount) UNION 
	(SELECT * FROM MCQHintCount) UNION
	(SELECT * FROM ZeroMCQ) UNION
	(SELECT * FROM ZeroNum  ))
	 AS allQuestions;

CREATE VIEW countsWithText AS
	SELECT  allCounts.questionId as questionId, LEFT(questionText, 50) AS questionText, hints 
	FROM allCounts JOIN question on allCounts.questionId = question.questionId;

SELECT * FROM countsWithText;

	
