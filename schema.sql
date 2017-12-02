drop schema if exists quizschema cascade;
create schema quizschema;
set search_path to quizschema;

CREATE TABLE student(
    s_id INT PRIMARY KEY,
    firstname varchar(255),
    lastname varchar(255) NOT NULL
);


CREATE TABLE class(
    c_id INT PRIMARY KEY AUTO_INCREMENT,
    room varchar(255) NOT NULL,
    grade varchar(255) NOT NULL,
    teacher varchar(255) NOT NULL,
    UNIQUE(room, grade, teacher)
);

CREATE TABLE took(
    s_id int REFERENCES student(s_id),
    c_id int REFERENCES class(c_id),
    PRIMARY KEY(s_id, c_id)
);


CREATE TABLE quiz(
    quizid TEXT PRIMARY KEY,
    title VARCHAR(255),
    q_timestamp TIMESTAMP NOT NULL,
    isHint BOOLEAN NOT NULL
);

CREATE TABLE question(
    questionId INT PRIMARY KEY,
    questionText TEXT NOT NULL,
    questionType TEXT NOT NULL
);

CREATE TABLE includes(
    quizid TEXT REFERENCES quiz(quizid),
    questionid INT REFERENCES question(questionid),
    q_weight INT NOT NULL,
    PRIMARY KEY(quizid, questionid) 
);


CREATE TABLE MultipleChoice(
    questionId INT REFERENCES question(questionId),
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
    hint TEXT,
    PRIMARY KEY(questionId, startRange, endRange)
);

CREATE TABLE true_false(
    questionId INT REFERENCES question(questionId) PRIMARY KEY,
    answer BOOLEAN NOT NULL
);

CREATE TABLE StudentResponse(
    -- TODO: constrain student to only take quiz in a class they are in. 
    questionId INT REFERENCES question(questionId),
    quizid INT REFERENCES quiz(quizid),
    s_id INT REFERENCES student(s_id),
    -- TODO: answer for mcq lies within options.
    answer TEXT,
    questionType TEXT NOT NULL,
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





