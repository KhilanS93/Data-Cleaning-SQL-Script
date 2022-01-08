-- Cleaning Data in SQL Queries

select *
from PortfolioProject1..Nashvillehousing

--Standardize Date Format

select SaleDateConverted, CONVERT(date, SaleDate)
from PortfolioProject1..Nashvillehousing

update Nashvillehousing
set SaleDate = CONVERT(date, SaleDate)

alter table Nashvillehousing
add SaleDateConverted Date;

update Nashvillehousing
set SaleDateConverted = CONVERT(date, SaleDate)

--Populate Property Address Data


select *
from PortfolioProject1..Nashvillehousing
--where PropertyAddress is null
order by ParcelID


select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject1..Nashvillehousing a
join PortfolioProject1..Nashvillehousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = isnull(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject1..Nashvillehousing a
join PortfolioProject1..Nashvillehousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

--Breaking out Address into Individual Columns

select PropertyAddress
from PortfolioProject1..Nashvillehousing
--where PropertyAddress is null
--order by ParcelID

select
SUBSTRING(propertyaddress, 1, CHARINDEX(',',propertyaddress)-1) as Address,
SUBSTRING(propertyaddress, CHARINDEX(',',propertyaddress)+1, LEN(PropertyAddress)) as Address
from PortfolioProject1..Nashvillehousing

alter table nashvillehousing	
Add PropertySplitAddress nvarchar(255);

update Nashvillehousing
SET PropertySplitAddress = SUBSTRING(propertyaddress, 1, CHARINDEX(',',propertyaddress)-1)

alter table nashvillehousing
add PropertySplitCity nvarchar(255);

UPDATE Nashvillehousing
set propertySplitCity = SUBSTRING(propertyaddress, CHARINDEX(',',propertyaddress)+1, LEN(PropertyAddress))

select *
from PortfolioProject1..Nashvillehousing

select
parsename(replace(owneraddress,',','.'),3),
parsename(replace(owneraddress,',','.'),2),
parsename(replace(owneraddress,',','.'),1)
from PortfolioProject1..Nashvillehousing

alter table nashvillehousing
add OwnerSplitaddress nvarchar(255);

UPDATE Nashvillehousing
set OwnerSplitaddress = parsename(replace(owneraddress,',','.'),3)

alter table nashvillehousing
add OwnerSplitCity nvarchar(255);

UPDATE Nashvillehousing
set OwnersplitCity = parsename(replace(owneraddress,',','.'),2)

alter table nashvillehousing
add OwnerSplitState nvarchar(255);

UPDATE Nashvillehousing
set OwnersplitState = parsename(replace(owneraddress,',','.'),1)

select *
from PortfolioProject1..Nashvillehousing

--Change Y and N to Yes and No in "Sold as Vacant" field

Select distinct(SoldAsVacant), count(soldasvacant)
from PortfolioProject1..Nashvillehousing
group by SoldAsVacant
order by 2

select SoldAsVacant
, case when SoldAsVacant = 'Y' then 'Yes'
	   when SoldAsVacant = 'N' then 'No'
	   else SoldAsVacant
	   end
from PortfolioProject1..Nashvillehousing

update Nashvillehousing
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
	   when SoldAsVacant = 'N' then 'No'
	   else SoldAsVacant
	   end

Select distinct(SoldAsVacant), count(soldasvacant)
from PortfolioProject1..Nashvillehousing
group by SoldAsVacant
order by 2


--Removing Duplicates

--using CTE

with rownumCTE as (

select *, 
	ROW_NUMBER() over(
	partition by ParcelID,
				PropertyAddress,
				SaleDate,
				LegalReference
				order by
					UniqueID
					) row_num

from PortfolioProject1..Nashvillehousing
--order by ParcelID
)


select *
from rownumCTE
where row_num > 1 
order by PropertyAddress

--Delete Unused Colums

select *
from PortfolioProject1..Nashvillehousing

alter table portfolioProject1..Nashvillehousing
drop column OwnerAddress, TaxDistrict, PropertyAddress, SaleDate











