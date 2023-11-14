
--Join the data sets together to give us the grades per student
--Remove the parental data fields, they aren't needed for the challenge this week
select *
from [student details]
select *
from grades
alter table [student details]
drop column  [parental contact],[preferred contact employer],[parental contact name_1],[parental contact name_2],[date of birth]


-- create a column for the  total score in all the subjects 
select  [student id],sum(maths + english + spanish+ science + art + history + geography) as total_score
from grades b
group by [student id]

alter table grades
add [total score] float

update grades
set [total score] = (maths + english + spanish+ science + art + history + geography) 

--Create an average score per student based on all of their grades ,Round the average score per student to one decimal place

select  [student id],round(sum(maths + english + spanish+ science + art + history + geography)/7,1) as total_average
from grades b
group by [student id]


--Create a field that records whether the student passed each subject Pass mark is 75 and above in all subjects
select  case when maths  >'74' then 'pass'
			when english  >'74' then 'pass'
			when spanish  >'74' then 'pass'
			when science  >'74' then 'pass'
			else null end
from grades

select  case when maths  >'74' then 'pass' else 'fail' end
from grades

