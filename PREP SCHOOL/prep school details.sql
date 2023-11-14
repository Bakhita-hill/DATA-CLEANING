--1.a)  Form the pupil's name correctly for the records in the format Last Name, First Name 

select concat([pupil last name],'  ',[pupil first name]) as full_name
from details

-- b. create the full name column and add the details
alter table details
add  [pupil's full name] nvarchar (255)

UPDATE details
    SET [pupil's full name] = concat([pupil last name],'  ',[pupil first name]) 
        

--2. Form the parental contact's name in the same format as the pupil's 
--(The Parental Contact Name 1 and 2 are the first names of each parent.)
--Use parental contact column to select which parent first name to use along with the pupil's last name

select concat([pupil last name],' ', 
case when [parental contact] ='1' then [parental contact name_1]
	 when [parental contact] ='2' then [parental contact name_2]
	 else null end) as full_name
from details

--b. create the parents  full name column and add its details
alter table details
add  [parent's full name] nvarchar (255)

UPDATE details
    SET [parent's full name] = concat([pupil last name],' ', 
case when [parental contact] ='1' then [parental contact name_1]
	 when [parental contact] ='2' then [parental contact name_2]
	 else null end) 

--3. Create the email address to contact the parent using the format Parent First Name.Parent Last Name@Employer.com
select concat(case when [parental contact] ='1' then [parental contact name_1]
	   when [parental contact] ='2' then [parental contact name_2]
	   else null end,
	   [pupil last name],'@',[preferred contact employer],'.com')as parent_email_address
from details

--b. Create the parent's email address and add the details
alter table details
add  [parent's email address] nvarchar (255)

UPDATE details
    SET [parent's email address] = concat(case when [parental contact] ='1' then [parental contact name_1]
											   when [parental contact] ='2' then [parental contact name_2]
											   else null end,
									[pupil last name],'@',[preferred contact employer],'.com')

--4. a)Create the academic year the pupils are in ,Each academic year starts on 1st September.(Year 1 is anyone born after 1st Sept 2014 ,Year 2 is anyone born between 1st Sept 2013 and 31st Aug 2014 etc)
select  case when [Date of Birth]  >'2014-09-01' then 'year_1'
			when [Date of Birth] between '2013-09-01 'and '2014-08-31' then 'year_2'
			when [Date of Birth] between '2012-09-01 'and '2013-08-31' then 'year_3'
			when [Date of Birth] between '2011-09-01 'and '2012-08-31' then 'year_4'
			else null end
from details

--b. Create the pupils academic year column  and add the details
alter table details
add  [academic year] nvarchar (255)

UPDATE details
    SET [academic year] = case when [Date of Birth]  >'2014-09-01' then '1'
			when [Date of Birth] between '2013-09-01 'and '2014-08-31' then '2'
			when [Date of Birth] between '2012-09-01 'and '2013-08-31' then '3'
			when [Date of Birth] between '2011-09-01 'and '2012-08-31' then '4'
			else null end

-- 5. Work out what day of the week the pupil's birthday falls on ,Remember if the birthday falls on a Saturday or Sunday, we need to change the weekday to Friday
SELECT case when DATENAME(WEEKDAY, [date of birth]) = 'saturday' or DATENAME(WEEKDAY, [date of birth] ) = 'sunday' then 'friday' else DATENAME(WEEKDAY, [date of birth]) end 
from details

--b. create the column and add the details
alter table details
add  [cake needed on] nvarchar (255)

UPDATE details
    SET [cake needed on] = case when DATENAME(WEEKDAY, [date of birth]) = 'saturday' or DATENAME(WEEKDAY, [date of birth] ) = 'sunday' then 'friday'
								else DATENAME(WEEKDAY, [date of birth]) end

--6. Work out what month the pupil's birthday falls within
select datename(month,[date of birth]) as birth_day_month
from details 

--b. create the birth day month column and add the details
alter table details
add  [birth day month] nvarchar (255)

UPDATE details
    SET [birth day month] = datename(month,[date of birth]) 

--7. Remove any unnecessary columns of data 
alter table details
drop column  [parental contact],[preferred contact employer],[parental contact name_1],[parental contact name_2],[pupil first name], [pupil last name],[gender],[date of birth]


--8. Output the data 
