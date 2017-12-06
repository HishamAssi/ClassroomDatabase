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
FROM questionsForQuiz_, studentsInGrade_;

CREATE VIEW countNone_ AS
SELECT allSidnQid_.s_id, allSidnQid_.questionId
FROM allSidnQid_ LEFT JOIN studentResponse
ON allSidnQid_.s_id=studentResponse.s_id
AND allSidnQid_.questionId=studentResponse.questionId
WHERE answer IS NULL;

CREATE VIEW allAnsweredInfo AS
SELECT s_id, countNone_.questionId, 
    LEFT(question.questionText, 50) AS questionText
FROM countNone_ JOIN question
ON countNone_.questionId=question.questionId;

SELECT * FROM allAnsweredInfo;
