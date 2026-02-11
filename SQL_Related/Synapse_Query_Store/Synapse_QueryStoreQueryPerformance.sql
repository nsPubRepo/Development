


SELECT '#tmpDistinctLabels', *
FROM [DWCommon].[uvw_QueryStoreQueryPerformance]
WHERE [query_sql_text] LIKE '%INSERT INTO DWReporting_DocHub.tbl_PowerBI_rpt_Scrubbed_Label_Fact_Testing%'	--#tmpDistinctLabels / 6.24 avg
	AND [last_execution_time_utc] > '2025-04-24 15:11:23.4930000 -04:00'
ORDER BY [last_execution_time] DESC



SELECT '#tmpEDF', *
FROM [DWCommon].[uvw_QueryStoreQueryPerformance]
WHERE [query_sql_text] LIKE '%INSERT INTO DWReporting_DocHub.tbl_PowerBI_rpt_ExtractionDocument_Fact%'	--#tmpEDF / 25.71 avg
	AND [last_execution_time_utc] > '2025-04-24 15:17:22.9770000 -04:00'
ORDER BY [last_execution_time] DESC



SELECT '#tmpEVF', *
FROM [DWCommon].[uvw_QueryStoreQueryPerformance]
WHERE [query_sql_text] LIKE '%INSERT INTO DWReporting_DocHub.tbl_PowerBI_rpt_ExtractionValue_Fact%'	--#tmpEVF / 254.43 (4.240 mins) avg
	AND [last_execution_time_utc] > '2025-04-24 15:24:45.2130000 -04:00'
ORDER BY [last_execution_time] DESC



SELECT '#tmpPreFinal', *
FROM [DWCommon].[uvw_QueryStoreQueryPerformance]
WHERE [query_sql_text] LIKE '%INSERT INTO DWReporting_DocHub.tbl_PowerBI_rpt_PreFinal_Fact%'	--#tmpPreFinal / 342.97 (5.716 mins) avg
	AND [last_execution_time_utc] > '2025-04-24 15:36:43.2270000 -04:00'
ORDER BY [last_execution_time] DESC



SELECT 'rest', *
FROM [DWCommon].[uvw_QueryStoreQueryPerformance]
WHERE [query_sql_text] LIKE '%INSERT INTO DWReporting_DocHub.tbl_PowerBI_rpt_Extraction_Fact_Testing%'	--extraction / "rest" table / 119.177 (1.982) avg
	AND [last_execution_time_utc] > '2025-04-24 15:41:54.1900000 -04:00'
ORDER BY [last_execution_time] DESC