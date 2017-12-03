SET SEARCH_PATH TO quizschema;


CREATE VIEW questions AS
SELECT includes.questionId, questionType FROM includes 
JOIN question ON includes.questionId=question.questionId
WHERE quizid='Pr1-220310';

CREATE VIEW students AS
SELECT s_Id FROM took JOIN class ON took.c_id=class.c_id
WHERE class.grade='grade 8' AND class.room='room 120' AND class.teacher='Mr Higgins';

-- CREATE VIEW questionAnswers AS
-- (SELECT questions.questionId, answerOption AS realAnswer FROM questions
-- JOIN MultipleChoice ON questions.questionId=MultipleChoice.questionId
-- WHERE isAnswer=True) 
-- UNION
-- (SELECT questions.questionId, startRange AS realAnswer FROM questions
-- JOIN NumericQuestions ON questions.questionId=NumericQuestions.questionId
-- WHERE isAnswer=True)
-- UNION
-- (SELECT questions.questionId, answer AS realAnswer FROM questions
-- JOIN true_false ON questions.questionId=true_false.questionId);

CREATE VIEW studentResponses AS
SELECT questionId, students.s_id, answer, questionType FROM students
JOIN studentResponse ON students.s_id=studentResponse.s_id
WHERE quizid='Pr1-220310';

CREATE VIEW numberCorrect_MCQ AS
SELECT studentResponses.questionId, count(*) AS correctCount
FROM studentResponses JOIN MultipleChoice
ON studentResponses.questionId=MultipleChoice.questionId
AND questionType='MCQ' AND isAnswer=True 
AND answer=answerOption
GROUP BY studentResponses.questionId;

CREATE VIEW numberIncorrect_MCQ AS
SELECT studentResponses.questionId, count(*) AS incorrectCount
FROM studentResponses JOIN MultipleChoice
ON studentResponses.questionId=MultipleChoice.questionId AND
questionType='MCQ' AND isAnswer=False
AND answer=answerOption
GROUP BY studentResponses.questionId;

CREATE VIEW numberNone_MCQ AS
SELECT questionId, count(*) AS noneCount
FROM studentResponses
WHERE questionType='MCQ' AND (Answer IS NULL OR answer='no response given')
GROUP BY questionId;

CREATE VIEW numberCorrect_Numeric AS
SELECT studentResponses.questionId, count(*) AS correctCount
FROM studentResponses JOIN NumericQuestions
ON studentResponses.questionId=NumericQuestions.questionId
AND questionType='Numeric' AND isAnswer=True 
AND cast(answer AS INT)=startRange
GROUP BY studentResponses.questionId;

CREATE VIEW numberIncorrect_Numeric AS
SELECT studentResponses.questionId, count(*) AS incorrectCount
FROM studentResponses JOIN NumericQuestions
ON studentResponses.questionId=NumericQuestions.questionId AND
questionType='Numeric' AND isAnswer=True AND answer!='no response given'
AND cast(answer AS INT)!=startRange
GROUP BY studentResponses.questionId;

CREATE VIEW numberNone_Numeric AS
SELECT questionId, count(*) AS noneCount
FROM studentResponses
WHERE questionType='Numeric' AND (Answer IS NULL OR answer='no response given')
GROUP BY questionId;


CREATE VIEW numberCorrect_tf AS
SELECT studentResponses.questionId, count(*) AS correctCount
FROM studentResponses JOIN true_false
ON studentResponses.questionId=true_false.questionId
AND questionType='TF' 
AND cast(studentResponses.answer AS BOOLEAN)=true_false.answer
GROUP BY studentResponses.questionId;

CREATE VIEW numberIncorrect_tf AS
SELECT studentResponses.questionId, count(*) AS incorrectCount
FROM studentResponses JOIN true_false
ON studentResponses.questionId=true_false.questionId AND
questionType='TF' AND studentResponses.answer!='no response given'
AND cast(studentResponses.answer AS BOOLEAN)!=true_false.answer
GROUP BY studentResponses.questionId;

CREATE VIEW numberNone_tf AS
SELECT questionId, count(*) AS noneCount
FROM studentResponses
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