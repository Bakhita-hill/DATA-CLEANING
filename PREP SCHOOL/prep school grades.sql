
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
--Aggregate the data per student to count how many subjects each student passed

Remove any unnecessary fields and output the data

Requirements
Input the data
Divide the students grades into 6 evenly distributed groups (have a look at 'Tiles' functionality in Prep)
By evenly distributed, it means the same number of students gain each grade within a subject
Convert the groups to two different metrics:
The top scoring group should get an A, second group B etc through to the sixth group who receive an F
An A is worth 10 points for their high school application, B gets 8, C gets 6, D gets 4, E gets 2 and F gets 1.
Determine how many high school application points each Student has received across all their subjects 
Work out the average total points per student by grade 
ie for all the students who got an A, how many points did they get across all their subjects
Take the average total score you get for students who have received at least one A and remove anyone who scored less than this. 
Remove results where students received an A grade (requirement updated 2/2/22)
--How many students scored more than the average if you ignore their As?
Output the data