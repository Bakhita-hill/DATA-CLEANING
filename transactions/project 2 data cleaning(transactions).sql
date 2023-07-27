
--1. In the Transactions table, there is a Sort Code field which contains dashes. We need to remove these so just have a 6 digit string 

-- create a user defined function to remove all the dashes(-)
Create FUNCTION [dbo].[udfGetCharacters](@inputString VARCHAR(MAX), @validChars VARCHAR(100))  

 RETURNS VARCHAR(500) AS 

 BEGIN 

     WHILE @inputString like '%[^' + @validChars + ']%' 

         SELECT @inputString = REPLACE(@inputString,SUBSTRING(@inputString,PATINDEX('%[^' + @validChars + ']%',@inputString),1),' ')  
         
 SELECT @inputString = (SELECT LTRIM(RTRIM(
            REPLACE(REPLACE(REPLACE(@inputString,'  ',' ||*9*9||'),'||*9*9|| ',''),'||*9*9||','')
        )))
        
     RETURN @inputString  

 END

select [Sort Code], MASTER.dbo.udfGetCharacters([Sort Code] ,'0-9 /') 
FROM Transactions

update Transactions
set [Sort Code] =  MASTER.dbo.udfGetCharacters([Sort Code],'0-9 /')
where [Sort Code]!=  MASTER.dbo.udfGetCharacters([Sort Code],'0-9 /')



-- create another user defined function to remove all the spaces left between the numbers 
CREATE FUNCTION RemoveAllSpaces
(
    @InputStr varchar(8000)
)
RETURNS varchar(8000)
AS
BEGIN
declare @ResultStr varchar(8000)
set @ResultStr = @InputStr
while charindex(' ', @ResultStr) > 0
    set @ResultStr = replace(@InputStr, ' ', '')

return @ResultStr
END


select [Sort Code], dbo.RemoveAllSpaces([Sort Code]) 
FROM Transactions


update Transactions
set [Sort Code] =  dbo.RemoveAllSpaces([Sort Code])
where [Sort Code]!=  dbo.RemoveAllSpaces([Sort Code])


begin tran
commit
-- 2. Use the SWIFT Bank Code lookup table to bring in additional information about the SWIFT code and Check Digits of the receiving bank account 
select a.Bank,a.[SWIFT code],a.[Check Digits],b.[Transaction ID],b.[Account Number],b.[Sort Code],b.Bank
from [swift codes]a
join transactions b
on a.bank = b.bank


-- 3. Add a field for the Country Code (hint) all these transactions take place in the UK so the Country Code should be GB
alter table transactions
add country_code nvarchar(255)

update transactions
set   country_code= 'GB'
where country_code IS null



-- 4. Create the IBAN 
-- the IBAN  contains (country code, check digits,swift code, sort code, account number ) some of this information is contained in the swift codes table ,copy that information from swift codes table to the transactions table 

alter table transactions
add check_digits  nvarchar(255)

UPDATE transactions
    SET check_digits = (
        SELECT [Check Digits]
        FROM [swift codes]
        WHERE transactions.Bank= [swift codes].Bank
    );


alter table transactions
add swift_code  nvarchar(255)

UPDATE transactions
    SET swift_code = (
        SELECT [SWIFT code]
        FROM [swift codes]
        WHERE transactions.Bank= [swift codes].Bank
    );

-- convert the account number column data type from float to bigint inorder to concat

alter table transactions
alter column [account number] bigint

select concat(country_code,check_digits,swift_code,[Sort Code],[Account Number])
FROM transactions 

-- after concating create the iban column 
alter table transactions
add IBAN nvarchar(255)

update transactions
set   IBAN = concat(country_code,check_digits,swift_code,[Sort Code],[Account Number]) 


-- 5. Remove unnecessary fields and remain with the iban and transaction id 
alter table transactions
drop  column [account number],[sort code],bank,country_code,check_digits,swift_code

-- 6. output the data 