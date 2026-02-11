

CREATE TABLE #BabyData
(
	[Name] VARCHAR(50) NOT NULL
  , [Gender] VARCHAR(1) NOT NULL 
  , [Count] INT NOT NULL
)


INSERT INTO #BabyData ([Name], Gender, Count) VALUES ('Girl 1', 'F', CAST(RAND() * 100 AS int))
INSERT INTO #BabyData ([Name], Gender, Count) VALUES ('Boy 1', 'M', CAST(RAND() * 100 AS int))
INSERT INTO #BabyData ([Name], Gender, Count) VALUES ('Girl 2', 'F', CAST(RAND() * 100 AS int))
INSERT INTO #BabyData ([Name], Gender, Count) VALUES ('Boy 2', 'M', CAST(RAND() * 100 AS int))
INSERT INTO #BabyData ([Name], Gender, Count) VALUES ('Girl 3', 'F', CAST(RAND() * 100 AS int))
INSERT INTO #BabyData ([Name], Gender, Count) VALUES ('Boy 3', 'M', CAST(RAND() * 100 AS int))
INSERT INTO #BabyData ([Name], Gender, Count) VALUES ('Girl 4', 'F', CAST(RAND() * 100 AS int))
INSERT INTO #BabyData ([Name], Gender, Count) VALUES ('Boy 4', 'M', CAST(RAND() * 100 AS int))
INSERT INTO #BabyData ([Name], Gender, Count) VALUES ('Girl 5', 'F', CAST(RAND() * 100 AS int))
INSERT INTO #BabyData ([Name], Gender, Count) VALUES ('Boy 5', 'M', CAST(RAND() * 100 AS int))
INSERT INTO #BabyData ([Name], Gender, Count) VALUES ('Girl 6', 'F', CAST(RAND() * 100 AS int))
INSERT INTO #BabyData ([Name], Gender, Count) VALUES ('Boy 6', 'M', CAST(RAND() * 100 AS int))
INSERT INTO #BabyData ([Name], Gender, Count) VALUES ('Girl 7', 'F', CAST(RAND() * 100 AS int))
INSERT INTO #BabyData ([Name], Gender, Count) VALUES ('Boy 7', 'M', CAST(RAND() * 100 AS int))
INSERT INTO #BabyData ([Name], Gender, Count) VALUES ('Girl 8', 'F', CAST(RAND() * 100 AS int))
INSERT INTO #BabyData ([Name], Gender, Count) VALUES ('Boy 8', 'M', CAST(RAND() * 100 AS int))
INSERT INTO #BabyData ([Name], Gender, Count) VALUES ('Boy 9', 'M', 17)




SELECT [Name]
	 , Gender
	 , [Count]
	 , WindowGrouping.Popularity
FROM 
	(
		SELECT [Name]
			 , Gender
			 , [Count]
			 , RANK() OVER (PARTITION BY gender ORDER BY [Count] DESC) AS 'Popularity'
			 --, DENSE_RANK() OVER (PARTITION BY gender ORDER BY [Count] DESC) AS 'Popularity'
			 --, ROW_NUMBER() OVER (PARTITION BY gender ORDER BY [Count] DESC) AS 'Popularity'
		FROM #BabyData
	) WindowGrouping
WHERE WindowGrouping.Popularity < 6



DROP TABLE #BabyData


/*************************************************************************************************/
/*************************************************************************************************/
/*************************************************************************************************/


IF OBJECT_ID('tempdb..#tmpPartition') IS NOT NULL
	DROP TABLE #tmpPartition


CREATE TABLE #tmpPartition
	(
		[RequestCompletedDateUTC] DATE        NULL
	  , [DocumentTypeName]        VARCHAR(50) NULL
	  , [LabelName]               VARCHAR(50) NULL
	  , [AccuracyMetricIND]       VARCHAR(50) NULL
	  , [TotalCount]              INT         NULL
	)


INSERT INTO #tmpPartition ([RequestCompletedDateUTC], [DocumentTypeName], [LabelName], [AccuracyMetricIND], [TotalCount]) VALUES ('2024-01-18', 'Paystub', 'First Name', 'Not Changed', 1)
INSERT INTO #tmpPartition ([RequestCompletedDateUTC], [DocumentTypeName], [LabelName], [AccuracyMetricIND], [TotalCount]) VALUES ('2024-01-18', 'Paystub', 'Last Name', 'Not Changed', 1)
INSERT INTO #tmpPartition ([RequestCompletedDateUTC], [DocumentTypeName], [LabelName], [AccuracyMetricIND], [TotalCount]) VALUES ('2024-02-03', 'Verification of Employment', 'Employer Name', 'None', 1)
INSERT INTO #tmpPartition ([RequestCompletedDateUTC], [DocumentTypeName], [LabelName], [AccuracyMetricIND], [TotalCount]) VALUES ('2025-01-18', 'Driver License', 'DOB', 'None', 1)
INSERT INTO #tmpPartition ([RequestCompletedDateUTC], [DocumentTypeName], [LabelName], [AccuracyMetricIND], [TotalCount]) VALUES ('2025-01-18', '1040', 'Tax Rate', 'None', 1)
INSERT INTO #tmpPartition ([RequestCompletedDateUTC], [DocumentTypeName], [LabelName], [AccuracyMetricIND], [TotalCount]) VALUES ('2025-01-03', '1040', 'Tax Rate', 'None', 1)
INSERT INTO #tmpPartition ([RequestCompletedDateUTC], [DocumentTypeName], [LabelName], [AccuracyMetricIND], [TotalCount]) VALUES ('2025-01-18', 'Paystub', 'DOB', 'Not Changed', 1)
INSERT INTO #tmpPartition ([RequestCompletedDateUTC], [DocumentTypeName], [LabelName], [AccuracyMetricIND], [TotalCount]) VALUES ('2025-01-18', '1080', 'Tax Rate', 'Changed', 1)
INSERT INTO #tmpPartition ([RequestCompletedDateUTC], [DocumentTypeName], [LabelName], [AccuracyMetricIND], [TotalCount]) VALUES ('2025-02-06', 'Driver License', 'Address', 'Changed', 1)
INSERT INTO #tmpPartition ([RequestCompletedDateUTC], [DocumentTypeName], [LabelName], [AccuracyMetricIND], [TotalCount]) VALUES ('2025-01-06', 'Paystub', 'DOB', 'Not Changed', 1)
INSERT INTO #tmpPartition ([RequestCompletedDateUTC], [DocumentTypeName], [LabelName], [AccuracyMetricIND], [TotalCount]) VALUES ('2025-01-18', 'Verification of Employment', 'Employer Address', 'Not Changed', 1)
INSERT INTO #tmpPartition ([RequestCompletedDateUTC], [DocumentTypeName], [LabelName], [AccuracyMetricIND], [TotalCount]) VALUES ('2025-03-15', 'Verification of Employment', 'Employer Name' , 'None', 1)
INSERT INTO #tmpPartition ([RequestCompletedDateUTC], [DocumentTypeName], [LabelName], [AccuracyMetricIND], [TotalCount]) VALUES ('2025-01-18', '1080', 'Tax Rate', 'Changed', 1)
INSERT INTO #tmpPartition ([RequestCompletedDateUTC], [DocumentTypeName], [LabelName], [AccuracyMetricIND], [TotalCount]) VALUES ('2025-01-18', 'Verification of Employment', 'Employer Name', 'None', 1)
INSERT INTO #tmpPartition ([RequestCompletedDateUTC], [DocumentTypeName], [LabelName], [AccuracyMetricIND], [TotalCount]) VALUES ('2024-12-05', 'Driver License', 'Address', 'Changed', 1)
INSERT INTO #tmpPartition ([RequestCompletedDateUTC], [DocumentTypeName], [LabelName], [AccuracyMetricIND], [TotalCount]) VALUES ('2024-12-05', 'Paystub', 'First Name', 'Changed', 1)
INSERT INTO #tmpPartition ([RequestCompletedDateUTC], [DocumentTypeName], [LabelName], [AccuracyMetricIND], [TotalCount]) VALUES ('2025-01-18', '1080', 'Tax Rate', 'Changed', 1)




SELECT [RequestCompletedDateUTC]
	 , [DocumentTypeName]
	 , [LabelName]
	 , [AccuracyMetricIND]
	 , WindowGrouping.[PartitionCount]
FROM 
	(
		SELECT [RequestCompletedDateUTC]
             , [DocumentTypeName]
             , [LabelName]
             , [AccuracyMetricIND]
             , [TotalCount]
             , COUNT([DocumentTypeName]) OVER (PARTITION BY [RequestCompletedDateUTC], [DocumentTypeName], [LabelName]) AS [PartitionCount]
		FROM #tmpPartition
	) WindowGrouping
ORDER BY [RequestCompletedDateUTC] ASC




		SELECT DISTINCT [RequestCompletedDateUTC]
			 , [DocumentTypeName]
			 , [LabelName]
			 , [AccuracyMetricIND]
			 , WindowGrouping.[PartitionCount]
		FROM 
			(
				SELECT [RequestCompletedDateUTC]
					 , [DocumentTypeName]
					 , [LabelName]
					 , [AccuracyMetricIND]
					 , [TotalCount]
					 , COUNT([DocumentTypeName]) OVER (PARTITION BY [RequestCompletedDateUTC], [DocumentTypeName], [LabelName]) AS [PartitionCount]
				FROM #tmpPartition
			) WindowGrouping
		ORDER BY [RequestCompletedDateUTC] ASC




IF OBJECT_ID('tempdb..#tmpPartition') IS NOT NULL
	DROP TABLE #tmpPartition



/****************************************************/
/****************************************************/



--Row numbering
	SELECT ROW_NUMBER() OVER (PARTITION BY (SELECT NULL) ORDER BY (SELECT NULL) ASC)
	SELECT ROW_NUMBER() OVER (ORDER BY (SELECT NULL) ASC)