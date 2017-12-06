drop schema if exists quizschema cascade;
create schema quizschema;
set search_path to quizschema;

-- TODO: create our own FD? If not, how can we have redundancy?
-- TODO: query vs select for q1-q5.
-- TODO: MCQ having at least 2 options.


CREATE TABLE student(
    -- We decided to make the s_id as a varchar so we can enforce
    -- the 10 character constraint on the attribute.
    s_id VARCHAR(10) PRIMARY KEY CHECK(CHAR_LENGTH(s_id) = 10),
    -- The professor mentioned the rare scenario where smoeone may not
    -- have a firstname so we allowed firstname to be null.
    firstname VARCHAR(255),
    lastname VARCHAR(255) NOT NULL
);



CREATE TABLE class(
    -- We've included class id in order to
    -- easily join with other tables.
    c_id INT PRIMARY KEY,
    room VARCHAR(255),
    grade VARCHAR(255),
    -- Assuming that a grade has a room 
    UNIQUE(room, grade)
);

CREATE TABLE RoomTeacher(
    room VARCHAR(255) PRIMARY KEY,
    teacher VARCHAR(255)
);

CREATE TABLE took(
    s_id VARCHAR(10) REFERENCES student(s_id),
    c_id INT REFERENCES class(c_id),
    PRIMARY KEY(s_id, c_id)
);


CREATE TABLE quiz(
    quizid VARCHAR(255) PRIMARY KEY,
    c_Id INT REFERENCES class(c_id),
    title VARCHAR(255),
    q_timestamp TIMESTAMP NOT NULL,
    isHint BOOLEAN NOT NULL
);

-- Created a type for the question types so we
-- dont have varying versions of them.
-- i.e. MCQ vs MultipleChoice.
CREATE TYPE question_type AS ENUM(
	'MCQ', 'Numeric', 'TF');

CREATE TABLE question(
    questionId INT PRIMARY KEY,
    questionText VARCHAR(255) NOT NULL,
    questionType question_type NOT NULL
);

CREATE TABLE includes(
    -- We cannot enforce at least one question per quiz because
    -- quizId is a subset of the quiz(quizId) so it might
    -- be that quiz does not include any questions if it
    -- does not exist in this table.
    quizid VARCHAR(255) REFERENCES quiz(quizid),
    questionid INT REFERENCES question(questionid),
    q_weight INT NOT NULL,
    PRIMARY KEY(quizid, questionid)
);

-- It might be better to keep the hints in the same table as MultipleChoice
-- but for the since this assignment does not allow us to have nulls,
-- we have to split the hints into a different table.
CREATE TABLE MultipleChoice(
    questionId INT REFERENCES question(questionId),
    -- Checking that there are at least 2 options is
    -- not doable without a subquery. TODO: ASK OH.
    answerOption VARCHAR(255),
    isAnswer BOOLEAN NOT NULL,
    PRIMARY KEY(questionId, answerOption)
);

-- This table is only for answerOptions that do have a hint,
-- If an option does not have a hint then it should not be in
-- this table.
CREATE TABLE MultipleChoiceHints(
    questionId INT REFERENCES question(questionId),
    answerOption VARCHAR(255),
    hint VARCHAR(255) NOT NULL,
    PRIMARY KEY(questionId, answerOption)
);

CREATE TABLE NumericQuestions(
    questionId INT REFERENCES question(questionId),
    -- We should not enforce not null here in case
    -- a range is x<10 or x>10 but we need the ranges
    -- to be a part of the key to be able to identify
    -- different answers.
    startRange INT,
    endRange INT,
    isAnswer BOOLEAN NOT NULL,
    --CHECK (startRange<=endRange),
    -- If isAnswer is true then startRange and endRange must be the same.
    --CHECK (isAnswer=TRUE AND startRange=endRange),
    PRIMARY KEY(questionId, startRange, endRange)
);

-- Same logic as MultipleChoiceHints
CREATE TABLE NumericQuestionsHints(
    questionId INT REFERENCES question(questionId),
    startRange INT,
    endRange INT,
    hint VARCHAR(255),
    PRIMARY KEY(questionId, startRange, endRange)
);

-- True or False cannot have hints.
CREATE TABLE true_false(
    questionId INT REFERENCES question(questionId) PRIMARY KEY,
    answer BOOLEAN NOT NULL
);

CREATE TABLE studentResponse(
    questionId INT REFERENCES question(questionId),
    quizid VARCHAR(255) REFERENCES quiz(quizid),
    s_id VARCHAR(10) REFERENCES student(s_id),
    -- Since we combined the answers of all question types in one table,
    -- we cannot check that the mcq answer exists as an option in the
    -- MultipleChoice table.
    -- We allowed answer to be Null in this tables because it does tell us
    -- that the student answered nothing. We could instead just not include
    -- questions that the student did not answer but then we won't be able
    -- to tell if a student took the quiz if he did not answer any questions
    -- without performing a complicated query.
    answer VARCHAR(255) NOT NULL,
    questionType question_type NOT NULL,
    PRIMARY KEY(questionId, quizId, s_id)
);

\COPY student FROM 'student.csv' DELIMITER ',' CSV header;
\COPY class FROM 'class.csv' DELIMITER ',' CSV header;
\COPY RoomTeacher FROM 'RoomTeacher.csv' DELIMITER ',' CSV header;
\COPY took FROM 'took.csv' DELIMITER ',' CSV header;
\COPY quiz FROM 'quiz.csv' DELIMITER ',' CSV header;
\COPY question FROM 'question.csv' DELIMITER ',' CSV header;
\COPY includes FROM 'includes.csv' DELIMITER ',' CSV header;
\COPY MultipleChoice FROM 'MultipleChoice.csv' DELIMITER ',' CSV header;
\COPY MultipleChoiceHints FROM 'MultipleChoiceHints.csv' DELIMITER ',' CSV header;
\COPY NumericQuestions FROM 'NumericQuestions.csv' DELIMITER ',' CSV header;
\COPY NumericQuestionsHints FROM 'NumericQuestionsHints.csv' DELIMITER ',' CSV header;
\COPY true_false FROM 'true_false.csv' DELIMITER ',' CSV header;
\COPY StudentResponse FROM 'StudentResponse.csv' DELIMITER ',' CSV header;





