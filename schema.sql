drop schema if exists quizschema cascade;
create schema quizschema;
set search_path to quizschema;

-- Contraints that could not be enforced: 
	
-- Constraints that could be (but were not) enforced:
       -- (1) MCQ having atleast 2 options:
           -- Enforcing this constraint would have resulted in
	   -- a redundant table. We could have had a relation
	   -- between each answer and an arbitrary option. However
	   -- this does not give us any new facts about the domain
	   -- and takes up more space, without much added value. 
       -- (2) At least one question per quiz:
	   -- We could have implemented a circular reference, but we 
	   -- read on the FAQ that we have the option to OPT OUT of 
	   -- using this. 
       -- (3) At least one student per class:
	   -- Similarly to the question the above, we opted out of 
	   -- using the circular refernces
      -- (4) Student can only take a quiz that was assigned to their class
	   -- We could include the class_id in the Studentresponse table
	   -- and have a reference to the Quiz(quizId, classId) and then 
	   -- ensured that neither our quizId or classId were NULL.
	   -- We did not do this because it would have introduced a lot
	   -- of redundancy. Our Took Table already includes the class to
	   -- student relation, and the quiz table already includes the 
	   -- quiz to class relation. We would not be introducing facts
	   -- any new facts if we included the class id. We would actually
	   -- be repeating information that is already known (redundantly).		

-- Student table with their respective ids and names
CREATE TABLE student(
    -- We decided to make the s_id as a varchar so we can enforce
    -- the 10 character constraint on the attribute.
    s_id VARCHAR(10) PRIMARY KEY CHECK(CHAR_LENGTH(s_id) = 10),
    -- The professor mentioned the rare scenario where smoeone may not
    -- have a firstname so we allowed firstname to be null.
    firstname VARCHAR(255),
    lastname VARCHAR(255) NOT NULL
);


-- The class as it is defined by the grade and room
	-- A class_id has been added for practical joining with
	-- other tables
CREATE TABLE class(
    c_id INT PRIMARY KEY,
    room VARCHAR(255),
    grade VARCHAR(255),
    -- Assuming that a grade has a room 
    UNIQUE(room, grade)
);


-- The rooms, as associated with teachers
-- Enforcing the constraint of only having 
-- one teacher per room
CREATE TABLE RoomTeacher(
    room VARCHAR(255) PRIMARY KEY,
    teacher VARCHAR(255)
);

-- The Took relation to associate students and classes
CREATE TABLE took(
    s_id VARCHAR(10) REFERENCES student(s_id),
    c_id INT REFERENCES class(c_id),
    PRIMARY KEY(s_id, c_id)
);

-- The Quiz Table and the class it is associated with.
-- We could have made a relation between class and quiz,
-- but since a quiz can only belong to one class we decided 
-- to merge them into one.
CREATE TABLE quiz(
    quizid VARCHAR(255) PRIMARY KEY,
    -- The class to which this quiz is assigned to
    c_Id INT REFERENCES class(c_id),
    title VARCHAR(255),
    q_timestamp TIMESTAMP NOT NULL,
    -- The flag to determine whether or not
    -- we are including hints for this quiz
    isHint BOOLEAN NOT NULL
);

-- Question Types
-- We created a type for the question types so we
-- dont have varying versions of them.
-- i.e. MCQ vs MultipleChoice.
CREATE TYPE question_type AS ENUM(
	'MCQ', 'Numeric', 'TF');

-- The questions as they relate to their prompts and types
CREATE TABLE question(
    questionId INT PRIMARY KEY,
    questionText VARCHAR(255) NOT NULL,
    -- The type of the question is an ENUM of either 
    -- MCQ, Numeric, TF
    questionType question_type NOT NULL
);

-- The relation to associate the questions that each quiz includes
-- and their respective weights
CREATE TABLE includes(
    -- We cannot enforce at least one question per quiz because
    -- quizId is a subset of the quiz(quizId) so it might
    -- be that quiz does not include any questions
    quizid VARCHAR(255) REFERENCES quiz(quizid),
    questionid INT REFERENCES question(questionid),
    q_weight INT NOT NULL,
    PRIMARY KEY(quizid, questionid)
);

-- The answer options for the Multiple Choice questions
	-- It might have been better to keep the hints in the same table as MultipleChoice
	-- But since this assignment does not allow us to have nulls, we have included a relation
	-- to associate the hints with the options
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

-- Numeric Questions and their answers 
CREATE TABLE NumericQuestions(
    questionId INT PRIMARY KEY,
    -- The domain specifies an "Integer" answer,
    -- Therefore, a range is not an answer. 
    answer INT NOT NULL,
    FOREIGN KEY (questionId) REFERENCES question(questionId) 
);

-- The relation between the question and its hints. 
-- ASSUMPTION: there is a hint IFF there is a range associated
	       -- with it
CREATE TABLE NumericQuestionsHints(
    questionId INT REFERENCES question(questionId),
    -- The start range upon which a hint must be displayed
    startRange INT,
    -- End range for this hint
    endRange INT,
    hint VARCHAR(255) NOT NULL,
    PRIMARY KEY(questionId, startRange, endRange)
);

-- The answers to all the true_false questions 
CREATE TABLE true_false(
    questionId INT REFERENCES question(questionId) PRIMARY KEY,
    -- True or False cannot have hints.
    -- Each question must have an answer
    answer BOOLEAN NOT NULL
);

-- The ternary relation to associate the student's responses to questions
-- on the quizes they take.
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





