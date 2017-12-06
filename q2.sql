set search_path to quizschema;


DROP VIEW IF EXISTS NumericHintCount CASCADE;
DROP VIEW IF EXISTS trueFalseHintCount CASCADE;
DROP VIEW IF EXISTS MCQHintCount CASCADE;
DROP VIEW IF EXISTS allCounts CASCADE;
DROP VIEW IF EXISTS countsWithText CASCADE;



CREATE VIEW NumericHintCount AS
	SELECT questionId, count(hint) as hints
	FROM NumericQuestionsHints
	GROUP BY questionId;

CREATE VIEW trueFalseHintCount AS
	SELECT questionId, 0 as hints
	FROM true_false;

CREATE VIEW MCQHintCount AS
	SELECT questionId, count(hint) as hints
	FROM MultipleChoiceHints
	GROUP BY questionId;
CREATE VIEW ZeroHints AS
	SELECT questionId, 0 as hints
	FROM (SELECT * FROM 
		(SELECT * 
		 FROM (SELECT questionId FROM MultipleChoice) 
		       except 
		      (SELECT questionId FROM MultipleChoiceHints))
		 UNION
		(SELECT * 
		 FROM (SELECT questionId FROM NumericQuestions) 
		       except 
		      (SELECT questionId FROM NumericQuestionsHints))) AS ZEROHINT 

CREATE VIEW allCounts as 
	SELECT * 
	FROM ((SELECT * FROM  NumericHintCount) UNION 
	(SELECT * FROM  trueFalseHintCount) UNION 
	(SELECT * FROM MCQHintCount) UNION
	(SELECT * FROM ZeroHints))
	 AS allQuestions;

CREATE VIEW countsWithText AS
	SELECT  allCounts.questionId as questionId, LEFT(questionText, 50) AS questionText, hints 
	FROM allCounts JOIN question on allCounts.questionId = question.questionId;

SELECT * FROM countsWithText;

	
