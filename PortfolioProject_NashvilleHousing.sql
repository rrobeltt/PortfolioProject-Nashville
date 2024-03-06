--Cleaning Data in SQL Queries
--*/

Select *
From PortfolioProject..NashVilleHousing



-- Standardize Date Format

Select SaleDateConverted, CONVERT(Date, SaleDate) as Date
FROM PortfolioProject..NashVilleHousing

UPDATE NashVilleHousing
SET SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

 UPDATE NashVilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)

--Populate Property Address Data

Select *
FROM PortfolioProject..NashVilleHousing
--Where PropertyAddress is null
Order by ParcelID



Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject..NashVilleHousing a
JOIN PortfolioProject..NashVilleHousing b
   on a.ParcelID = b.ParcelID
   and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject..NashVilleHousing a
JOIN PortfolioProject..NashVilleHousing b
   on a.ParcelID = b.ParcelID
   and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

--Dividing Address into individual columns (Address, city, state)



Select PropertyAddress
FROM PortfolioProject..NashVilleHousing
--Where PropertyAddress is null
--Order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',' , PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',' , PropertyAddress)+1,  LEN(PropertyAddress))as Address

FROM PortfolioProject..NashVilleHousing

ALTER TABLE NashvilleHousing
Add PropertySplitAddress NVarchar(255);

 UPDATE NashVilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',' , PropertyAddress) -1)

ALTER TABLE NashvilleHousing
Add PropertySplitCity NVarchar(255);

 UPDATE NashVilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',' , PropertyAddress)+1,  LEN(PropertyAddress))


Select *
FROM PortfolioProject..NashVilleHousing




Select OwnerAddress
FROM PortfolioProject..NashVilleHousing



Select
PARSENAME (REPLACE(OwnerAddress, ',', '.') , 3),
PARSENAME (REPLACE(OwnerAddress, ',', '.') , 2),
PARSENAME (REPLACE(OwnerAddress, ',', '.') , 1)
FROM PortfolioProject..NashVilleHousing



ALTER TABLE NashvilleHousing
Add OwnerSplitAddress NVarchar(255);

 UPDATE NashVilleHousing
SET OwnerSplitAddress = PARSENAME (REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE NashvilleHousing
Add OwnerSplitCity NVarchar(255);

UPDATE NashVilleHousing
SET OwnerSplitCity = PARSENAME (REPLACE(OwnerAddress, ',', '.') , 2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState  NVarchar(255);

UPDATE NashVilleHousing
SET OwnerSplitState = PARSENAME (REPLACE(OwnerAddress, ',', '.') , 1)

Select *
FROM PortfolioProject..NashVilleHousing


-- Change Y and N to Yes and No in "Sold as Vacant" field


Select DISTINCT(SoldASVacant), COUNT(SoldASVacant)
FROM PortfolioProject..NashVilleHousing
Group by SoldASVacant
Order by 2


Select SoldASVacant, 
Case When SoldASVacant = 'Y' THEN 'Yes'
When SoldAsVacant = 'N' THEN 'No' 
Else SoldAsVacant
End
From PortfolioProject..NashvilleHousing


Update NashvilleHousing
SET SoldAsVacant = Case When SoldASVacant = 'Y' THEN 'Yes'
When SoldAsVacant = 'N' THEN 'No' 
Else SoldAsVacant
End

--Remove Duplicates

WITH RowNumCTE as(

Select *,
    ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
	             PropertyAddress,
				 SalePrice,
				 SaleDate, 
				 LegalReference
				 ORDER BY
				      UniqueID
					  ) row_num


From PortfolioProject..NashvilleHousing
--Order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress



Select *
FROM PortfolioProject..NashVilleHousing


--Delete Unused Columns

Select *
FROM PortfolioProject..NashVilleHousing


Alter Table PortfolioProject..NashVilleHousing
Drop Column SaleDate
