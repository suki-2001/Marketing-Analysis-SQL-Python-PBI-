USE PortfolioProject_MarketingAnalytics
GO

-- Facts Tables

select * from dbo.customer_reviews;

-- Query to remove double spaces from ReviewTest column

select ReviewID, CustomerID, ProductID, REviewDate, Rating, 
		REPLACE(ReviewText, '  ',' ') As ReviewTex
FROM dbo.customer_reviews;

-- ********************************************************************************************************************************
--**************************************************************************************************************************

-- Fact Engagement

select * from dbo.engagement_data;

-- Query to clean and normalize the data engagement table

SELECT EngagementID, ContentID, CampaignID, ProductID,
		Upper(REPLACE(ContentType, 'social media', 'Social Media')) AS ContentType,
		Likes,
		LEFT(ViewsClicksCombined, CHARINDEX('-', ViewsClicksCombined)- 1) as Views,
		RIGHT(ViewsClicksCombined, LEN(ViewsClicksCombined) - CHARINDEX('-', ViewsClicksCombined)) AS Clicks,
		FORMAT(CONVERT(DATE,EngagementDate) , 'dd-mm-yyyy') as EngagementDate
FROM dbo.engagement_data
where ContentType ! = 'Newsletter';

-- ********************************************************************************************************************************
--**************************************************************************************************************************

-- Facts customer Journey

select * from dbo.customer_journey;

-- Common Table Expression (CTE) to identify duplicated and tage duplicate records

WITH DuplicateRecords as (
	SELECT
		JourneyID, CustomerID, ProductID, VisitDate,Action,Stage, Duration,
		ROW_NUMBER () OVER (
		PARTITION BY CustomerID, ProductID, VisitDate, Stage, Action
		ORDER BY JourneyID
		) as Row_Num
FROM DBO.customer_journey)

-- Select all records from CTE where row_num > 1, which indicates duplicate records
SELECT * from DuplicateRecords 
WHERE Row_Num > 1
oRDER BY JourneyID

-- Query to select the final cleaned and standardized data

SELECT JourneyID, CustomerID, ProductID, VisitDate, Stage, Action, 
	COALESCE(Duration, avg_duration) as Duration
FROM (
		-- Subquery to prcess and clean the data
		SELECT JourneyID, CustomerID, ProductID, VisitDate, Action,
			UPPER(Stage) as Stage,
			Duration,
			AVG(Duration) OVER (PARTITION BY VisitDate) AS avg_duration,
			ROW_NUMBER () OVER (PARTITION BY CustomerID, ProductID, VisitDate, UPPER(Stage), Action 
			Order BY JourneyID 
		) AS Row_Num
		FROM dbo.customer_journey
			) AS subquery
		WHERE
			Row_Num =1;