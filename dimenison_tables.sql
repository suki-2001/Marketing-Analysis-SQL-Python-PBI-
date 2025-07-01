-- Dimension Tables and LookUp tables

SELECT TOP 100 * 
FROM PortfolioProject_MarketingAnalytics.dbo.customer_journey;

USE PortfolioProject_MarketingAnalytics;
GO

select * from dbo.products;
select min(Price) as Minimum_price, max(Price) as Maximum_price from dbo.products; 

select ProductID,
	ProductName,
	Category,
	Price,
	CASE -- Categorize the products into price category as Low, medium, high
		WHEN Price < 50 THEN 'Low'
		WHEN Price BETWEEN 50 and 200 THEN 'Medium'
		ELSE 'High'
	END AS PriceCategory -- name the new column as PriceCategory
FROM dbo.products;

-- ************************************************************************************************************

select * from dbo.customers;
select * from dbo.geography;

-- Join customer with geography table (many-one R)

select c.CustomerID, c.CustomerName, c.Email, c.Gender, c.Age, g.Country, g.City
from dbo.geography g
-- LEFT JOIN 
RIGHT JOIN
dbo.customers c
ON g.GeographyID = c.GeographyID;