
--1. Exclude the Overall Ratings, these were incorrectly calculated by the system

alter table [DSB Customer Survery]
drop column [Mobile App - Overall Rating],[Online Interface - Overall Rating] 


--2. Calculate the Average Ratings for each platform for each customer 
	-- a)average rating for the mobile app

select [Customer ID], 
	(select avg(myavg) from (values ([Mobile App - Ease of Access]), ([Mobile App - Ease of Use]), ([Mobile App - Likelihood to Recommend]), ([Mobile App - Navigation])) as rating(myavg))
from [bank transactions].dbo.[DSB Customer Survery]

	--  b) average rating for the online interface

select [Customer ID], 
	(select avg(myavg) from (values ([Online Interface - Ease of Access]),([Online Interface - Ease of Use]),([Online Interface - Likelihood to Recommend]),([Online Interface - Navigation]) ) as rating(myavg))
from [bank transactions].dbo.[DSB Customer Survery]

--3. Create columns for the overall rating 
	--a) mobile overall rating
alter table [DSB Customer Survery]
add mobile_overall_rating  float

UPDATE [DSB Customer Survery]
    SET mobile_overall_rating = (select avg(myavg) from (values ([Mobile App - Ease of Access]), ([Mobile App - Ease of Use]), ([Mobile App - Likelihood to Recommend]), ([Mobile App - Navigation])) as rating(myavg))
        WHERE mobile_overall_rating is null
   ;
   -- b) online interface overall rating
alter table [DSB Customer Survery]
add online_interface_overall_rating  float

UPDATE [DSB Customer Survery]
    SET online_interface_overall_rating = (select avg(myavg) from (values ([Online Interface - Ease of Access]),([Online Interface - Ease of Use]),([Online Interface - Likelihood to Recommend]),([Online Interface - Navigation]) ) as rating(myavg))
        WHERE online_interface_overall_rating is null

--4. Calculate the difference in Average Rating between Mobile App and Online Interface for each customer
select [Customer ID], (mobile_overall_rating-online_interface_overall_rating) as difference_in_avererage_rating
from [bank transactions].dbo.[DSB Customer Survery]
