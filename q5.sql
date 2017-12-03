SET SEARCH_PATH TO quizschema;


CREATE VIEW questionsForQuiz AS
SELECT includes.questionId, questionType FROM includes 
JOIN question ON includes.questionId=question.questionId
WHERE quizid='Pr1-220310';

CREATE VIEW studentsInGrade AS
SELECT s_Id FROM took JOIN class ON took.c_id=class.c_id
WHERE class.grade='grade 8' AND class.room='room 120' AND class.teacher='Mr Higgins';

-- CREATE VIEW questionAnswers AS
-- (SELECT questionsForQuiz.questionId, answerOption AS realAnswer FROM questionsForQuiz
-- JOIN MultipleChoice ON questionsForQuiz.questionId=MultipleChoice.questionId
-- WHERE isAnswer=True) 
-- UNION
-- (SELECT questionsForQuiz.questionId, startRange AS realAnswer FROM questionsForQuiz
-- JOIN NumericQuestions ON questionsForQuiz.questionId=NumericQuestions.questionId
-- WHERE isAnswer=True)
-- UNION
-- (SELECT questionsForQuiz.questionId, answer AS realAnswer FROM questionsForQuiz
-- JOIN true_false ON questionsForQuiz.questionId=true_false.questionId);

CREATE VIEW studentResponsesForQuiz AS
SELECT questionId, studentsInGrade.s_id, answer, questionType FROM studentsInGrade
JOIN studentResponse ON studentsInGrade.s_id=studentResponse.s_id
WHERE quizid='Pr1-220310';

CREATE VIEW numberCorrect_MCQ AS
SELECT studentResponsesForQuiz.questionId, count(*) AS correctCount
FROM studentResponsesForQuiz JOIN MultipleChoice
ON studentResponsesForQuiz.questionId=MultipleChoice.questionId
AND questionType='MCQ' AND isAnswer=True 
AND answer=answerOption
GROUP BY studentResponsesForQuiz.questionId;

CREATE VIEW numberIncorrect_MCQ AS
SELECT studentResponsesForQuiz.questionId, count(*) AS incorrectCount
FROM studentResponsesForQuiz JOIN MultipleChoice
ON studentResponsesForQuiz.questionId=MultipleChoice.questionId AND
questionType='MCQ' AND isAnswer=False
AND answer=answerOption
GROUP BY studentResponsesForQuiz.questionId;

CREATE VIEW numberNone_MCQ AS
SELECT questionId, count(*) AS noneCount
FROM studentResponsesForQuiz
WHERE questionType='MCQ' AND (Answer IS NULL OR answer='no response given')
GROUP BY questionId;

CREATE VIEW numberCorrect_Numeric AS
SELECT studentResponsesForQuiz.questionId, count(*) AS correctCount
FROM studentResponsesForQuiz JOIN NumericQuestions
ON studentResponsesForQuiz.questionId=NumericQuestions.questionId
AND questionType='Numeric' AND isAnswer=True 
AND cast(answer AS INT)=startRange
GROUP BY studentResponsesForQuiz.questionId;

CREATE VIEW numberIncorrect_Numeric AS
SELECT studentResponsesForQuiz.questionId, count(*) AS incorrectCount
FROM studentResponsesForQuiz JOIN NumericQuestions
ON studentResponsesForQuiz.questionId=NumericQuestions.questionId AND
questionType='Numeric' AND isAnswer=True AND answer!='no response given'
AND cast(answer AS INT)!=startRange
GROUP BY studentResponsesForQuiz.questionId;

CREATE VIEW numberNone_Numeric AS
SELECT questionId, count(*) AS noneCount
FROM studentResponsesForQuiz
WHERE questionType='Numeric' AND (Answer IS NULL OR answer='no response given')
GROUP BY questionId;


CREATE VIEW numberCorrect_tf AS
SELECT studentResponsesForQuiz.questionId, count(*) AS correctCount
FROM studentResponsesForQuiz JOIN true_false
ON studentResponsesForQuiz.questionId=true_false.questionId
AND questionType='TF' 
AND cast(studentResponsesForQuiz.answer AS BOOLEAN)=true_false.answer
GROUP BY studentResponsesForQuiz.questionId;

CREATE VIEW numberIncorrect_tf AS
SELECT studentResponsesForQuiz.questionId, count(*) AS incorrectCount
FROM studentResponsesForQuiz JOIN true_false
ON studentResponsesForQuiz.questionId=true_false.questionId AND
questionType='TF' AND studentResponsesForQuiz.answer!='no response given'
AND cast(studentResponsesForQuiz.answer AS BOOLEAN)!=true_false.answer
GROUP BY studentResponsesForQuiz.questionId;

CREATE VIEW numberNone_tf AS
SELECT questionId, count(*) AS noneCount
FROM studentResponsesForQuiz
WHERE questionType='TF' AND (Answer IS NULL OR answer='no response given')
GROUP BY questionId;


CREATE VIEW countCorrect AS
(SELECT questionId, correctCount
FROM numberCorrect_MCQ)
UNION
(SELECT questionId, correctCount
FROM numberCorrect_Numeric)
UNION
(SELECT questionId, correctCount
FROM numberCorrect_tf);

CREATE VIEW countIncorrect AS
(SELECT questionId, incorrectCount
FROM numberIncorrect_MCQ)
UNION
(SELECT questionId, incorrectCount
FROM numberIncorrect_Numeric)
UNION
(SELECT questionId, incorrectCount
FROM numberIncorrect_tf);

CREATE VIEW countNone AS
(SELECT questionId, noneCount
FROM numberNone_MCQ)
UNION
(SELECT questionId, noneCount
FROM numberNone_Numeric)
UNION
(SELECT questionId, noneCount
FROM numberNone_tf);

SELECT * FROM countCorrect;
SELECT * FROM countIncorrect;
SELECT * FROM countNone;