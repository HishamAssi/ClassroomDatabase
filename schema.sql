drop schema if exists quizschema cascade;
create schema quizschema;
set search_path to quizschema;

-- TODO: create our own FD? If not, how can we have redundancy?
-- TODO: query vs select for q1-q5.
-- TODO: MCQ having at least 2 options.


CREATE TABLE student(
    s_id varchar(10) PRIMARY KEY CHECK char_length(s_id) = 10,
    firstname varchar(255),
    lastname varchar(255) NOT NULL
);


CREATE TABLE class(
    c_id SERIAL PRIMARY KEY,
    room varchar(255) NOT NULL,
    grade varchar(255) NOT NULL,
    teacher varchar(255) NOT NULL,
    -- There is a tradeoff between adding a constraint
    -- on maximum one teacher per room and the number
    -- of grades allowed in a room.
    -- It is also not possible to constrain the number
    -- of grades in a room.
    UNIQUE(room, grade, teacher)
    
);

CREATE TABLE took(
    s_id BIGINT REFERENCES student(s_id),
    c_id INT REFERENCES class(c_id),
    PRIMARY KEY(s_id, c_id)
);


CREATE TABLE quiz(
    quizid TEXT PRIMARY KEY,
    c_Id INT REFERENCES took(c_id),
    title VARCHAR(255),
    q_timestamp TIMESTAMP NOT NULL,
    isHint BOOLEAN NOT NULL
);

CREATE TYPE question_type AS ENUM(
	'MCQ', 'Numeric', 'TF');

CREATE TABLE question(
    questionId INT PRIMARY KEY,
    questionText TEXT NOT NULL,
    questionType question_type NOT NULL
);

CREATE TABLE includes(
    -- We cannot enforce at least one question per quiz because
    -- quizId is a subset of the quiz(quizId) so it might
    -- be that quiz does not include any questions if it
    -- does not exist in this table.
    quizid TEXT REFERENCES quiz(quizid),
    questionid INT REFERENCES question(questionid),
    q_weight INT NOT NULL,
    PRIMARY KEY(quizid, questionid)
);


CREATE TABLE MultipleChoice(
    questionId INT REFERENCES question(questionId),
    -- Checking that there are at least 2 options is
    -- not doable without a subquery. TODO: ASK OH.
    answerOption TEXT NOT NULL,
    isAnswer BOOLEAN NOT NULL,
    hint TEXT,
    PRIMARY KEY(questionId, answerOption)
);

CREATE TABLE NumericQuestions(
    questionId INT REFERENCES question(questionId),
    startRange INT,
    endRange INT,
    -- If isAnswer is true then startRange and endRange must be the same.
    isAnswer BOOLEAN NOT NULL,
    CHECK startRange<=endRange,
    CHECK isAnswer=TRUE AND startRange=endRange,
    hint VARCHAR(255),
    PRIMARY KEY(questionId, startRange, endRange)
);

CREATE TABLE true_false(
    questionId INT REFERENCES question(questionId) PRIMARY KEY,
    answer BOOLEAN NOT NULL
);

CREATE TABLE studentResponse(
    -- TODO: constrain student to only take quiz in a class they are in. 
    questionId INT REFERENCES question(questionId),
    quizid VARCHAR(255) REFERENCES quiz(quizid),
    s_id BIGINT REFERENCES student(s_id),
    -- Since we combined the answers of all question types in one table,
    -- we cannot check that the mcq answer exists as an option in the
    -- MultipleChoice table.
    answer VARCHAR(255),
    questionType question_type NOT NULL,
    PRIMARY KEY(questionId, quizId, s_id)
);

\COPY student FROM 'student.csv' DELIMITER ',' CSV header;
\COPY class FROM 'class.csv' DELIMITER ',' CSV header;
\COPY took FROM 'took.csv' DELIMITER ',' CSV header;
\COPY quiz FROM 'quiz.csv' DELIMITER ',' CSV header;
\COPY question FROM 'question.csv' DELIMITER ',' CSV header;
\COPY includes FROM 'includes.csv' DELIMITER ',' CSV header;
\COPY MultipleChoice FROM 'MultipleChoice.csv' DELIMITER ',' CSV header;
\COPY NumericQuestions FROM 'NumericQuestions.csv' DELIMITER ',' CSV header;
\COPY true_false FROM 'true_false.csv' DELIMITER ',' CSV header;
\COPY StudentResponse FROM 'StudentResponse.csv' DELIMITER ',' CSV header;





