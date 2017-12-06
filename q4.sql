CREATE VIEW questionsForQuiz_ AS
SELECT includes.questionId, questionType 
FROM includes 
JOIN question ON includes.questionId=question.questionId
WHERE quizid='Pr1-220310';

CREATE VIEW studentsInGrade_ AS
SELECT s_Id FROM took 
JOIN class ON took.c_id=class.c_id
JOIN RoomTeacher ON class.room = RoomTeacher.room
WHERE class.grade='grade 8' AND class.room='room 120'
AND RoomTeacher.teacher='Mr Higgins';

CREATE VIEW allSidnQid_ AS
SELECT s_id, questionId, questionType
FROM questionsForQuiz, studentsInGrade;

CREATE VIEW countNone_ AS
SELECT allSidnQid.s_id, allSidnQid.questionId
FROM allSidnQid LEFT JOIN studentResponsesForQuiz
ON allSidnQid.s_id=studentResponsesForQuiz.s_id
AND allSidnQid.questionId=studentResponsesForQuiz.questionId
WHERE answer IS NULL;

CREATE VIEW allAnsweredInfo AS
SELECT s_id, studentResponses.questionId, 
    LEFT(question.questionText, 50) AS questionText
FROM answeredNone JOIN question
ON studentResponses.questionId=question.questionId;

SELECT * FROM allAnsweredInfo;
