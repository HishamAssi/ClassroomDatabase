CREATE VIEW questions AS
SELECT includes.questionId, questionType FROM includes 
JOIN question ON includes.questionId=question.questionId
WHERE quizid='Pr1-220310';

CREATE VIEW students AS
SELECT s_Id FROM took JOIN class ON took.c_id=class.c_id
WHERE class.grade='grade 8' AND class.room='room 120' AND class.teacher='Mr Higgins';

CREATE VIEW studentResponses AS
SELECT questionId, students.s_id, answer, questionType FROM students
JOIN studentResponse ON students.s_id=studentResponse.s_id
WHERE quizid='Pr1-220310' AND answer IS NULL OR answer='no response given';

CREATE VIEW allInfo AS
SELECT s_id, studentResponses.questionId, LEFT(question.questionText, 50)
FROM studentResponses JOIN question 
ON studentResponses.questionId=question.questionId;

SELECT * FROM allInfo;
