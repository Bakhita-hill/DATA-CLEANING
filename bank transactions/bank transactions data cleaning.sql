select *
from dbo.transactions

-- 1. Split the Transaction Code to extract the letters at the start of the transaction code. These identify the bank who processes the transaction 

select [Transaction Code],left ([Transaction Code],CHARINDEX('-',[Transaction Code])-1) as bank
from dbo.transactions

alter table dbo.transactions
add Bank nvarchar(255);

update transactions
set bank=left([Transaction Code],CHARINDEX('-',[Transaction Code])-1)


-- 2. Rename the values in the Online or In-person field, Online of the 1 values and In-Person for the 2 values. 
select [Online or In-Person],
case when [Online or In-Person]='1' then  'online' 
     when [Online or In-Person]='2' then 'in-person' 
	 else [Online or In-Person]
	 end
from dbo.transactions

update dbo.transactions
set  [Online or In-Person] =
case when [Online or In-Person]='1' then 'online'
     when [Online or In-Person]='2' then 'in-person'
	 else [Online or In-Person]
	 end


-- 3a.  Total Values of Transactions by each bank
select[bank],sum (value) as total_value
from dbo.transactions
group by bank
order by total_value desc


--3b.  Total Values by Bank and Type of Transaction (Online or In-Person)

select[bank],[Online or In-Person],sum (value) as total_value
from dbo.transactions
group by bank,[Online or In-Person]
order by total_value desc


-- 3c. Total Values by Bank and Customer Code

select[bank],[Customer Code] ,sum (value) as total_value
from dbo.transactions
group by bank,[Customer Code]
order by total_value desc


-- 4. delete unused column 
select *
from dbo.transactions

ALTER TABLE dbo.transactions
DROP COLUMN [transaction date]

--5. output the data 

