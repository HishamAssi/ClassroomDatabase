-- Inserting stuff into tables.

INSERT INTO student VALUES 
('0998801234','Lena','Headey'), 
('0010784522','Peter','Dinklage'),
('0997733991','Emilia','Clarke'),
('5555555555','Kit','Harrington'),
('1111111111','Sophie','Turner'),
('2222222222','Maisie','Williams');

INSERT INTO class VALUES
(1,'room 120','grade 8'),
(2,'room 366','grade 5');

INSERT INTO RoomTeacher VALUES
('room 120', 'Mr Higgins'),
('room 366', 'Miss Nyers');

INSERT INTO took VALUES
('0998801234',1),
('0010784522',1),
('0997733991',1),
('5555555555',1),
('1111111111',1),
('2222222222',2);

INSERT INTO quiz VALUES
('Pr1-220310',1,'Citizenship Test Practise Questions',
'1:30 pm, Oct 1, 2017',True);

INSERT INTO question VALUES
(782,'What do you promise when you take the oath of citizenship?','MCQ'),
(566,'The Prime Minister, Justin Trudeau, is Canada''s Head of State.',TF),
(601,'During the Quiet Revolution, Quebec experienced rapid change. In what decade did this occur? (Enter the year that began the decade, e.g., 1840.)','Numeric'),
(625,'What is the Underground Railroad?','MCQ'),
(790,'During the War of 1812 the Americans burned down the Parliament Buildings in York (now Toronto). What did the British and Canadians do in return?','MCQ');

INSERT INTO includes VALUES
('Pr1-220310',601,2),
('Pr1-220310',566,1),
('Pr1-220310',790,3),
('Pr1-220310',625,2);

INSERT INTO MultipleChoice VALUES
(782,'To pledge your loyalty to the Sovereign, Queen Elizabeth II',True),
(782,'To pledge your allegiance to the flag and fulfill the duties of a Canadian',FALSE),
(782,'To pledge your loyalty to Canada from sea to sea',FALSE),
(625,'The first railway to cross Canada',FALSE),
(625,'The CPR''s secret railway line',FALSE),
(625,'The TTC subway system',FALSE),
(625,'A network used by slaves who escaped the United States into Canada',TRUE),
(790,'They attacked American merchant ships',FALSE),
(790,'They expanded their defence system, including Fort York',FALSE),
(790,'They burned down the White House in Washington D.C.',True),
(790,'They captured Niagara Falls',False);

INSERT INTO MultipleChoiceHints VALUES
(782,'To pledge your allegiance to the flag and fulfill the duties of a Canadian','Think regally.'),
(625,'The first railway to cross Canada','The Underground Railroad was generally south to north, not east-west'),
(625,'The CPR''s secret railway line','The Underground Railroad was secret, but it had nothing to do with trains'),
(625,'The TTC subway system','The TTC is relatively recent; the Underground Railroad was  in operation over 100 years ago.');

INSERT INTO NumericQuestions VALUES
(601,1960);

INSERT INTO NumericQuestionsHints VALUES
(601,1800,1900,'The Quiet Revolution happened during the 20th'),
(601,2000,2010,'The Quiet Revolution happened some time ago.'),
(601,2020,3000,'The Quiet Revolution has already happened!');

INSERT INTO true_false VALUES
(566, False);

INSERT INTO studentResponse
(601,'Pr1-220310','0998801234',1950,'Numeric'),
(566,'Pr1-220310','0998801234',FALSE,'TF')
(790,'Pr1-220310','0998801234','They expanded their defence system, including Fort York','MCQ'),
(625,'Pr1-220310','0998801234','A network used by slaves who escaped the United States into Canada','MCQ'),
(601,'Pr1-220310','0010784522',1960,'Numeric'),
(566,'Pr1-220310','0010784522',FALSE,'TF'),
(790,'Pr1-220310','0010784522','They burned down the White House in Washington D.C.','MCQ'),
(625,'Pr1-220310','0010784522','A network used by slaves who escaped the United States into Canada','MCQ'),
(601,'Pr1-220310','0997733991',1960,'Numeric'),
(566,'Pr1-220310','0997733991',TRUE,'TF'),
(790,'Pr1-220310','0997733991','They burned down the White House in Washington D.C.','MCQ'),
(625,'Pr1-220310','0997733991','The CPR''s secret railway line','MCQ'),
(566,'Pr1-220310','5555555555',FALSE,'TF'),
(790,'Pr1-220310','5555555555','They captured Niagara Falls','MCQ');




