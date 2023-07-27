SELECT *
FROM projectportfolio.DBO.[NASHVILLE HOUSING]


-- STANDARDIZE DATE FORMAT
SELECT SaleDate,convert(date,saledate)
FROM projectportfolio.DBO.[NASHVILLE HOUSING]
update [NASHVILLE HOUSING]
set SaleDate=convert(date,saledate)


alter table [NASHVILLE HOUSING]
add saledateconverted date;
update [NASHVILLE HOUSING]
set SaleDateconverted=convert(date,saledate)


--POPOLATE PROPERTY ADRESS DATA
SELECT *
FROM projectportfolio.DBO.[NASHVILLE HOUSING]
--WHERE PropertyAddress IS NULL
ORDER BY ParcelID

SELECT a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,isnull(a.propertyaddress,b.PropertyAddress)
FROM projectportfolio.DBO.[NASHVILLE HOUSING]a
join projectportfolio.DBO.[NASHVILLE HOUSING]b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null


update a
set propertyaddress=isnull(a.propertyaddress,b.PropertyAddress)
FROM projectportfolio.DBO.[NASHVILLE HOUSING]a
join projectportfolio.DBO.[NASHVILLE HOUSING]b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null


-- BREAKING OUT ADRESS INTO INDIVIDUAL COLUMNS (ADRESS,CITY,STATE)
SELECT PropertyAddress
FROM projectportfolio.DBO.[NASHVILLE HOUSING]
--WHERE PropertyAddress IS NULL
--ORDER BY ParcelID

SELECT
SUBSTRING(propertyaddress, 1, CHARINDEX(',', propertyaddress)-1) as address
 ,SUBSTRING(PROPERTYADDRESS, CHARINDEX(',', propertyaddress)+1 ,len(propertyaddress)) as address
from projectportfolio.dbo.[NASHVILLE HOUSING]

alter table [NASHVILLE HOUSING]
add propertysplitadress nvarchar(255);
update [NASHVILLE HOUSING]
set propertysplitadress=SUBSTRING(propertyaddress, 1, CHARINDEX(',', propertyaddress)-1) 

alter table [NASHVILLE HOUSING]
add propertysplitcity nvarchar(255);
update [NASHVILLE HOUSING]
set propertysplitcity =SUBSTRING(PROPERTYADDRESS, CHARINDEX(',', propertyaddress)+1 ,len(propertyaddress)) 



select *
from projectportfolio.dbo.[NASHVILLE HOUSING]


select 
PARSENAME(replace(owneraddress,',','.'),3)
,PARSENAME(replace(owneraddress,',','.'),2)
,PARSENAME(replace(owneraddress,',','.'),1)
from projectportfolio.dbo.[NASHVILLE HOUSING]


alter table [NASHVILLE HOUSING]
add ownersplitadress nvarchar(255);
update [NASHVILLE HOUSING]
set ownersplitadress=PARSENAME(replace(owneraddress,',','.'),3)


alter table [NASHVILLE HOUSING]
add ownersplitcity nvarchar(255);
update [NASHVILLE HOUSING]
set ownersplitcity =PARSENAME(replace(owneraddress,',','.'),2)


alter table [NASHVILLE HOUSING]
add ownersplitstate nvarchar(255);
update [NASHVILLE HOUSING]
set ownersplitstate =PARSENAME(replace(owneraddress,',','.'),1)



-- CHANGE Y AND N TO YES AND NO IN'SOLD AS VACANT 'FIELD 
select DISTINCT (SoldAsVacant),COUNT(soldasvacant)
from projectportfolio.dbo.[NASHVILLE HOUSING]
group by SoldAsVacant
order by 2


select SoldAsVacant,
case when SoldAsVacant='y' then 'yes'
     when SoldAsVacant='n' then 'no'
	 else SoldAsVacant
	 end
from projectportfolio.dbo.[NASHVILLE HOUSING]


update [NASHVILLE HOUSING]
set  soldasvacant =case when SoldAsVacant='y' then 'yes'
     when SoldAsVacant='n' then 'no'
	 else SoldAsVacant
	 end


-- REMOVE DUPLICATES
WITh ROW_NUMCTE AS(
SELECT*,
      ROW_NUMBER() OVER(
	               PARTITION BY PARCELID,
				               propertyaddress,
							   saleprice,saledate,
							   legalreference
							   order by
							   uniqueid)row_num
from projectportfolio.dbo.[NASHVILLE HOUSING])
select *
from ROW_NUMCTE
where row_num>1
--order by PropertyAddress


--DELETE UNUSED COLUMNS
select *
from projectportfolio.dbo.[NASHVILLE HOUSING]

ALTER TABLE [NASHVILLE HOUSING]
DROP COLUMN OWNERADDRESS,TAXDISTRICT,PROPERTYADDRESS


ALTER TABLE [NASHVILLE HOUSING]
DROP COLUMN SALEDATE