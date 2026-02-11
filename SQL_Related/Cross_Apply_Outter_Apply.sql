--DROP TABLE IF EXISTS #LeftTable;
	CREATE TABLE #LeftTable
		(
			Id INT,
			[Name] NVARCHAR(10)
		)
	INSERT INTO #LeftTable (Id, [Name]) VALUES (1, 'Red')
	INSERT INTO #LeftTable (Id, [Name]) VALUES (2, 'Green')
	INSERT INTO #LeftTable (Id, [Name]) VALUES (3, 'Blue')
	INSERT INTO #LeftTable (Id, [Name]) VALUES (4, 'Yellow')
	INSERT INTO #LeftTable (Id, [Name]) VALUES (5, 'Purple')



--DROP TABLE IF EXISTS #RightTable;
	CREATE TABLE #RightTable
		(
			Id INT,
			ReferenceId INT,
			[Name] NVARCHAR(10)
		)
	INSERT INTO #RightTable (Id, ReferenceId, [Name]) VALUES (1, 1, 'Dog')
	INSERT INTO #RightTable (Id, ReferenceId, [Name]) VALUES (2, 1, 'Cat')
	INSERT INTO #RightTable (Id, ReferenceId, [Name]) VALUES (3, 2, 'Bird')
	INSERT INTO #RightTable (Id, ReferenceId, [Name]) VALUES (4, 4, 'Horse')
	INSERT INTO #RightTable (Id, ReferenceId, [Name]) VALUES (5, 3, 'Bear')
	INSERT INTO #RightTable (Id, ReferenceId, [Name]) VALUES (6, 1, 'Deer')




-- CROSS APPLY
	SELECT L.[Name],
		   R.[Name]
	FROM #LeftTable L
		CROSS APPLY (
						SELECT [Name]
						FROM #RightTable R
						WHERE R.ReferenceId = L.Id
					) R
	--ORDER BY R.[Name] ASC





-- INNER JOIN
	SELECT L.[Name],
		   R.[Name]
	FROM #LeftTable L
		INNER JOIN #RightTable R
			ON R.ReferenceId = L.Id




-- SQL OUTER APPLY
	SELECT L.[Name],
		   R.[Name]
	FROM #LeftTable L
		OUTER APPLY (
						SELECT [Name]
						FROM #RightTable R
						WHERE R.ReferenceId = L.Id
					) R




-- LEFT OUTER JOIN
	SELECT L.[Name],
		   R.[Name]
	FROM #LeftTable L
		LEFT OUTER JOIN #RightTable R
			ON R.ReferenceId = L.Id;


-- CROSS APPLY with a Table Expression
	SELECT *
	FROM #LeftTable L
		CROSS APPLY (
						SELECT TOP 2 R.[Name]
						FROM #RightTable R
						WHERE R.ReferenceId = L.Id
						ORDER BY R.Id DESC
					) R;




DROP TABLE #LeftTable
DROP TABLE #RightTable




/*********************************************************************************************************************************************/
/*********************************************************************************************************************************************/
/*********************************************************************************************************************************************/
/*********************************************************************************************************************************************/
/*********************************************************************************************************************************************/




-- https://www.mssqltips.com

--DROP TABLE IF EXISTS #LeftTable;
--CREATE TABLE #LeftTable
--	(
--		Id INT,
--		Name NVARCHAR(10)
--	)

--INSERT INTO #LeftTable
--	(
--		Id,
--		Name
--	)
--VALUES
--	(1, 'Red'), (2, 'Green'), (3, 'Blue'), (4, 'Yellow'), (5, 'Purple');



--DROP TABLE IF EXISTS #RightTable;
--CREATE TABLE #RightTable
--	(
--		Id INT,
--		ReferenceId INT,
--		Name NVARCHAR(10)
--	)

--INSERT INTO #RightTable
--	(
--		Id,
--		ReferenceId,
--		Name
--	)
--VALUES
--	(1, 1, 'Dog'), (2, 1, 'Cat'), (3, 2, 'Bird'), (4, 4, 'Horse'), (5, 3, 'Bear'), (6, 1, 'Deer');
--GO



SELECT *
FROM #LeftTable
ORDER BY [Id] ASC

SELECT *
FROM #RightTable
ORDER BY [Id] ASC



/*
	CROSS/ INNER JOIN
*/
	-- CROSS APPLY
	SELECT L.Name,
		   R.Name
	FROM #LeftTable L
		CROSS APPLY
			(SELECT Name FROM #RightTable R WHERE R.ReferenceId = L.Id) R
	ORDER BY L.NAME
		   , R.Name ASC 



	-- INNER JOIN
	SELECT L.Name,
		   R.Name
	FROM #LeftTable L
		INNER JOIN #RightTable R
			ON R.ReferenceId = L.Id
	ORDER BY L.NAME
		   , R.Name ASC 



/*
	OUTTER APPLY / LEFT JOIN
*/
	-- SQL OUTER APPLY
	SELECT L.Name,
		   R.Name
	FROM #LeftTable L
		OUTER APPLY
	(SELECT Name FROM #RightTable R WHERE R.ReferenceId = L.Id) R;



	-- LEFT OUTER JOIN
	SELECT L.Name,
		   R.Name
	FROM #LeftTable L
		LEFT OUTER JOIN #RightTable R
			ON R.ReferenceId = L.Id;



-- CROSS APPLY with a Table Expression
SELECT *
FROM #LeftTable L
    CROSS APPLY
		(
			SELECT TOP 2 R.Name
			FROM #RightTable R
			WHERE R.ReferenceId = L.Id
			ORDER BY R.Id DESC
		) R;


DROP TABLE #LeftTable
DROP TABLE #RightTable