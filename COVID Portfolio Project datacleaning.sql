/*

Cleaning Data in SQL Queries

*/

Select *
From [Portfolio Project ].dbo.[Nashville Housing]

-- Standardize Date Format

Select SaleDateconverted, CONVERT(date,SaleDate)
From [Portfolio Project ].dbo.[Nashville Housing]

update [Nashville Housing]
SET SaleDate=CONVERT(date, SaleDate)


ALTER TABLE [Nashville Housing]
Add SaleDateConverted Date;

update [Nashville Housing]
SET SaleDate=CONVERT(date, SaleDate)


-- Populate Property Address Data

Select *
From [Portfolio Project ].dbo.[Nashville Housing]
--Where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From [Portfolio Project ].dbo.[Nashville Housing] a
JOIN [Portfolio Project ].dbo.[Nashville Housing] b
	 on a.ParcelID = b.ParcelID
	 AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


Update a
SET PropertyAddress= ISNULL(a.PropertyAddress, b.PropertyAddress)
From [Portfolio Project ].dbo.[Nashville Housing] a
JOIN [Portfolio Project ].dbo.[Nashville Housing] b
	 on a.ParcelID = b.ParcelID
	 AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null



-- Breaking out Address into Individual Columns (Address, City, State)



Select PropertyAddress
From [Portfolio Project ].dbo.[Nashville Housing]
--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) + 1, LEN(PropertyAddress)) as Address

From [Portfolio Project ].dbo.[Nashville Housing]

ALTER TABLE [Nashville Housing]
Add PropertySplitAddress Nvarchar(255);

update [Nashville Housing]
SET PropertySplitAddress=SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1)

ALTER TABLE [Nashville Housing]
Add PropertySplitCity  Nvarchar(255);

update [Nashville Housing]
SET PropertySplitCity=SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) + 1, LEN(PropertyAddress))



Select *
From [Portfolio Project ].dbo.[Nashville Housing]






Select OwnerAddress
From [Portfolio Project ].dbo.[Nashville Housing]


Select
PARSENAME(REPLACE(OwnerAddress,',','.'), 3)
, PARSENAME(REPLACE(OwnerAddress,',','.'), 2)
, PARSENAME(REPLACE(OwnerAddress,',','.'), 1)
From [Portfolio Project ].dbo.[Nashville Housing]




ALTER TABLE [Nashville Housing]
Add OwnerSplitAddress Nvarchar(255);

update [Nashville Housing]
SET OwnerSplitAddress=PARSENAME(REPLACE(OwnerAddress,',','.'), 3)

ALTER TABLE [Nashville Housing]
Add OwnerSplitCity  Nvarchar(255);

update [Nashville Housing]
SET OwnerSplitCity=PARSENAME(REPLACE(OwnerAddress,',','.'), 2)




ALTER TABLE [Nashville Housing]
Add OwnerSplitState  Nvarchar(255);

update [Nashville Housing]
SET OwnerSplitState=PARSENAME(REPLACE(OwnerAddress,',','.'), 1)


Select *
From [Portfolio Project ].dbo.[Nashville Housing]

-----------------------------------------------------------------

-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), Count(SoldasVacant)
From [Portfolio Project ].dbo.[Nashville Housing]
Group by SoldAsVacant
order by 2

Select SoldAsVacant
, CASE when SoldAsVacant ='Y' THEN 'Yes'
       When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From [Portfolio Project ].dbo.[Nashville Housing]


Update [Nashville Housing]
SET SoldAsVacant = CASE when SoldAsVacant ='Y' THEN 'Yes'
       When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From [Portfolio Project ].dbo.[Nashville Housing]



-- Remove Duplicates
WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER(
	PARTITION BY parcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY
				    UniqueID
					) row_num

From [Portfolio Project ].dbo.[Nashville Housing]
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num >1
Order by PropertyAddress



Select *
From [Portfolio Project ].dbo.[Nashville Housing]




-- Delete Unused Columns

Select *
From [Portfolio Project ].dbo.[Nashville Housing]

ALTER TABLE [Portfolio Project ].dbo.[Nashville Housing]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE [Portfolio Project ].dbo.[Nashville Housing]
DROP COLUMN SaleDate