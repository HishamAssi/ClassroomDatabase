SET SEARCH_PATH TO quizschema;


-- Get all questions id for the specific quiz.
CREATE VIEW questionsForQuiz AS
SELECT includes.questionId, questionType 
FROM includes 
JOIN question ON includes.questionId=question.questionId
WHERE quizid='Pr1-220310';

-- Get all the students in grade 8 that are in Mr Higgins Room.
CREATE VIEW studentsInGrade AS
SELECT s_Id FROM took 
JOIN class ON took.c_id=class.c_id
JOIN RoomTeacher ON class.room = RoomTeacher.room
WHERE class.grade='grade 8' AND class.room='room 120'
AND RoomTeacher.teacher='Mr Higgins';

-- Get the student responses for the specific quiz.
CREATE VIEW studentResponsesForQuiz AS
SELECT questionId, studentsInGrade.s_id, answer, questionType FROM studentsInGrade
JOIN studentResponse ON studentsInGrade.s_id=studentResponse.s_id
WHERE quizid='Pr1-220310';

-- the number of students that got an mcq question correct.
CREATE VIEW numberCorrect_MCQ AS
SELECT studentResponsesForQuiz.questionId, count(*) AS correctCount
FROM studentResponsesForQuiz JOIN MultipleChoice
ON studentResponsesForQuiz.questionId=MultipleChoice.questionId
AND questionType='MCQ' AND isAnswer=True 
AND answer=answerOption
GROUP BY studentResponsesForQuiz.questionId;

-- the number of students that got an mcq question incorrect.
CREATE VIEW numberIncorrect_MCQ AS
SELECT studentResponsesForQuiz.questionId, count(*) AS incorrectCount
FROM studentResponsesForQuiz JOIN MultipleChoice
ON studentResponsesForQuiz.questionId=MultipleChoice.questionId AND
questionType='MCQ' AND isAnswer=False
AND answer=answerOption
GROUP BY studentResponsesForQuiz.questionId;

-- the number of students that got a numeric question correct.
CREATE VIEW numberCorrect_Numeric AS
SELECT studentResponsesForQuiz.questionId, count(*) AS correctCount
FROM studentResponsesForQuiz JOIN NumericQuestions
ON studentResponsesForQuiz.questionId=NumericQuestions.questionId
AND questionType='Numeric' AND isAnswer=True 
AND cast(answer AS INT)=startRange
GROUP BY studentResponsesForQuiz.questionId;

-- the number of students that got a numeric question incorrect.
CREATE VIEW numberIncorrect_Numeric AS
SELECT studentResponsesForQuiz.questionId, count(*) AS incorrectCount
FROM studentResponsesForQuiz JOIN NumericQuestions
ON studentResponsesForQuiz.questionId=NumericQuestions.questionId AND
questionType='Numeric' AND isAnswer=True AND answer!='no response given'
AND cast(answer AS INT)!=startRange
GROUP BY studentResponsesForQuiz.questionId;

-- the number of students that got a true or false question correct.
CREATE VIEW numberCorrect_tf AS
SELECT studentResponsesForQuiz.questionId, count(*) AS correctCount
FROM studentResponsesForQuiz JOIN true_false
ON studentResponsesForQuiz.questionId=true_false.questionId
AND questionType='TF' 
AND cast(studentResponsesForQuiz.answer AS BOOLEAN)=true_false.answer
GROUP BY studentResponsesForQuiz.questionId;

-- the number of students that got a true or false question incorrect.
CREATE VIEW numberIncorrect_tf AS
SELECT studentResponsesForQuiz.questionId, count(*) AS incorrectCount
FROM studentResponsesForQuiz JOIN true_false
ON studentResponsesForQuiz.questionId=true_false.questionId AND
questionType='TF' AND studentResponsesForQuiz.answer!='no response given'
AND cast(studentResponsesForQuiz.answer AS BOOLEAN)!=true_false.answer
GROUP BY studentResponsesForQuiz.questionId;

-- All s_ids with all q_ids for the specific class and quiz.
CREATE VIEW allSidnQid AS
SELECT s_id, questionId, questionType
FROM questionsForQuiz, studentsInGrade;

-- The count of students that did not answer a question.
CREATE VIEW countNone AS
SELECT allSidnQid.questionId, count(*) as NoneCount
FROM allSidnQid LEFT JOIN studentResponsesForQuiz
ON allSidnQid.s_id=studentResponsesForQuiz.s_id
AND allSidnQid.questionId=studentResponsesForQuiz.questionId
WHERE answer IS NULL
GROUP BY allSidnQid.questionId, allSidnQid.questionType;

-- Unioning the correct answers of the different types
-- of questions.
CREATE VIEW countCorrect AS
(SELECT questionId, correctCount
FROM numberCorrect_MCQ)
UNION
(SELECT questionId, correctCount
FROM numberCorrect_Numeric)
UNION
(SELECT questionId, correctCount
FROM numberCorrect_tf);

-- Unioning the incorrect answers of the different types
-- of questions.
CREATE VIEW countIncorrect AS
(SELECT questionId, incorrectCount
FROM numberIncorrect_MCQ)
UNION
(SELECT questionId, incorrectCount
FROM numberIncorrect_Numeric)
UNION
(SELECT questionId, incorrectCount
FROM numberIncorrect_tf);

SELECT * FROM countCorrect;
SELECT * FROM countIncorrect;
SELECT * FROM countNone;