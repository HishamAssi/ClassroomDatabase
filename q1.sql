
set search_path to quizschema;
drop table if exists q1 cascade;

CREATE TABLE q1(
	fullname varchar(510),
	s_id BIGINT PRIMARY KEY
);

insert into q1 (
	SELECT firstname || ' ' || lastname as fullname, s_id
	FROM student
);	


