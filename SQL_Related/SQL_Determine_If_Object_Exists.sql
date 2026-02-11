


/*
	Type	Type_Desc
	=================
	D	|	DEFAULT_CONSTRAINT
	FN	|	SQL_SCALAR_FUNCTION
	IF	|	SQL_INLINE_TABLE_VALUED_FUNCTION
	P	|	SQL_STORED_PROCEDURE
	PK	|	PRIMARY_KEY_CONSTRAINT
	U	|	USER_TABLE
	UQ	|	UNIQUE_CONSTRAINT
	V	|	VIEW
*/



/*****************
*****option 1*****
*****************/


	--SELECT o.*
	--	 , s.[name] AS 'Schema_Name'
	--FROM sys.objects o
	--	INNER JOIN sys.schemas s
	--		ON o.schema_id = s.schema_id
	--WHERE o.[name] = 'Special_Bank_Name_Mapping'


/*****************
*****option 2*****
*****************/


	IF (
			SELECT COUNT(*)
			FROM sys.objects o
				INNER JOIN sys.schemas s									--INNER JOINing 'cause I want to not only match on the artifact name **BUT** also the schema said artifact resides in (to promote 100,000,000% confirmation that I'm flushing the correct artifact)
					ON o.schema_id = s.schema_id
						AND s.[name] = 'DMDocHub'
			WHERE o.[Name] = 'rpt_Extraction_Fact'
				AND o.[type_desc] = 'USER_TABLE'
				AND o.[type] = 'U'	--redundant but it gives me the warm fuzzies... sssoooo... *shrug*
		) > 0
		DROP TABLE [DMDocHub].[rpt_Extraction_Fact];
	GO


/*****************
*****option 3*****
*****************/


	--IF OBJECT_ID (N'DWReporting_DocHub.uvw_DocHubADEAccuracyMetricBOLT_AddVibe_BankNameFiltering', N'V') IS NOT NULL
	--	DROP VIEW [DWReporting_DocHub].[uvw_DocHubADEAccuracyMetricBOLT_AddVibe_BankNameFiltering]
	--GO


/*****************
*****option 4*****
*****************/


	--IF EXISTS (N'DWReporting_DocHub.uvw_DocHubADEAccuracyMetricBOLT_AddVibe_BankNameFiltering', N'V')
	--	DROP VIEW [DWReporting_DocHub].[uvw_DocHubADEAccuracyMetricBOLT_AddVibe_BankNameFiltering]
	--GO


/*****************
*****option 5*****
*****************/


	--IF (SELECT COUNT(*) FROM sys.objects WHERE [Name] = 'uvw_DocHubADEAccuracyMetricBOLT_AddVibe_BankNameFiltering' AND [type_desc] = 'VIEW' AND [type] = 'V') > 0
	--   DROP VIEW [DWReporting_DocHub].[uvw_DocHubADEAccuracyMetricBOLT_AddVibe_BankNameFiltering];
	--GO


/*****************
*****option 6*****
*****************/


	--IF OBJECT_ID('tempdb..##tmpBadChar') IS NOT NULL
	--	DROP TABLE #tmpBadChar;


/*****************
*****option 7*****
*****************/


--If the SPROC in question does **NOT** already exist, create an empty shell / stubbed-out version of the SPROC in question.
--Doing this will cause the execution plan, for the SPROC in question, to PERSIST (ALTERs don't drop EP's but DROPs do...)
	IF (
			SELECT COUNT(*)
			FROM sys.objects o
				INNER JOIN sys.schemas s									--INNER JOINing 'cause I want to not only match on the artifact name **BUT** also the schema said artifact resides in (to promote 100,000,000% confirmation that I'm flushing the correct artifact)
					ON o.schema_id = s.schema_id
						AND s.[name] = 'DWReporting_DocHub'
			WHERE o.[Name] = 'usp_PowerBI_Populate_Label_And_Extraction_Tables'
				AND o.[type_desc] = 'SQL_STORED_PROCEDURE'
				AND o.[type] = 'P'	--redundant but it gives me the warm fuzzies... sssoooo... *shrug*
		) = 0	--if 0, then that means the object in question does **NOT** previously exist and, if it does **NOT** previously exist, you know what THAT means... 
		EXECUTE ('CREATE PROCEDURE DWReporting_DocHub.usp_PowerBI_Populate_Label_And_Extraction_Tables AS')	--... create 'ol Stubby... hopefully we won't have to put 'ol Stubby down like we did 'ol Yeller... :-(
	ELSE
		PRINT 'Already there, my dude... but I''ll do ya a solid and execute the ALTER...'
	GO



/*****************
*****option 8*****
*****************/



--If the view in question does **NOT** already exist, create an empty shell / stubbed-out version of the SPROC in question.
--Doing this will cause the execution plan, for the SPROC in question, to PERSIST (ALTERs don't drop EP's but DROPs do...)
	IF (
			SELECT COUNT(*)
			FROM sys.objects o
				INNER JOIN sys.schemas s									--INNER JOINing 'cause I want to not only match on the artifact name **BUT** also the schema said artifact resides in (to promote 100,000,000% confirmation that I'm flushing the correct artifact)
					ON o.schema_id = s.schema_id
						AND s.[name] = 'DWReporting_DocHub'
			WHERE o.[Name] = 'uvw_PowerBI_BOLT_Good_Vibes_That_Changed'
				AND o.[type_desc] = 'VIEW'
				AND o.[type] = 'V'	--redundant but it gives me the warm fuzzies... sssoooo... *shrug*
		) <> 0	--if 0, then that means the object in question does **NOT** previously exist and, if it does **NOT** previously exist, you know what THAT means... 
		BEGIN
			PRINT 'Attempting to flush, er, I mean drop the object in question...'
			DROP VIEW [DWReporting_DocHub].[uvw_PowerBI_BOLT_Good_Vibes_That_Changed]		--... it means it's time to get serious... Schwarzenegger style... #IllBeBack
			PRINT ''
			PRINT '... object successfully dropped....'
			PRINT ''
			PRINT ''
			PRINT 'Attempting to (re)create the object in question...'
			PRINT ''
		END
	ELSE
		BEGIN
			PRINT ''
			PRINT 'SQL object in question does not currently exist... soooo... there''s nothin'' for me to drop... *shrug*'
			PRINT ''
			PRINT 'Attempting to (re)create the object in question...'
			PRINT ''
		END
	GO



--....



	IF (
			SELECT COUNT(*)
			FROM sys.objects o
				INNER JOIN sys.schemas s
					ON o.schema_id = s.schema_id									--INNER JOINing 'cause I want to not only match on the artifact name **BUT** also the schema said artifact resides in (to promote 100,000,000% confirmation that I'm flushing the correct artifact)
						AND s.[name] = 'DWReporting_DocHub'
			WHERE o.[Name] = 'uvw_PowerBI_BOLT_Good_Vibes_That_Changed'
				AND o.[type_desc] = 'VIEW'
				AND o.[type] = 'V'	--redundant but it gives me the warm fuzzies... sssoooo... *shrug*
		) <> 0	--if 0, then that means the object in question does **NOT** previously exist and, if it does **NOT** previously exist, you know what THAT means... 
			BEGIN
				PRINT '... object in question was successfully (re)created... good job, superstar!'
				PRINT ''
				PRINT ''
			END
	ELSE
		BEGIN
			PRINT 'Uhhh... sooo... I tried to (re)create the object... somethin'' happened such that it was **NOT** successfully (re)created... you should probably call someone...'
			PRINT ''
			PRINT ''
		END