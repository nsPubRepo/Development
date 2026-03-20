



--https://stackoverflow.com/a/7825036
	SELECT DATEADD(DAY, nbr - 1, DATEADD(WEEK, -1, CAST(GETDATE() AS DATE)))			AS termination_d
	FROM (
			SELECT ROW_NUMBER() OVER (ORDER BY c.object_id)		AS nbr
			FROM sys.columns AS c
         ) AS nbrs
	WHERE (nbr - 1) <= DATEDIFF(DAY, DATEADD(WEEK, -1, CAST(GETDATE() AS DATE)), CAST(GETDATE() AS DATE))







	SELECT DATEADD(DAY, nbr - 1, DATEADD(WEEK, -1, CAST(GETDATE() AS DATE)))			AS termination_d
	FROM (
			SELECT TOP 3650 ROW_NUMBER() OVER (ORDER BY c.object_id)		AS nbr		--3650 = ~10 years worth of numbers (which will be turned into dates)
			FROM sys.columns AS c
         ) AS nbrs
	WHERE (nbr - 1) <= DATEDIFF(DAY, DATEADD(WEEK, -1, CAST(GETDATE() AS DATE)), CAST(GETDATE() AS DATE))