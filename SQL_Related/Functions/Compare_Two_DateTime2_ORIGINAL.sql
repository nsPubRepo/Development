


--If the SPROC in question does **NOT** already exist, create an empty shell / stubbed-out version of the SPROC in question.
--Doing this will cause the execution plan, for the SPROC in question, to PERSIST (ALTERs don't drop EP's but DROPs do...)
	IF (
			SELECT COUNT(*)
			FROM sys.objects o
				INNER JOIN sys.schemas s
					ON o.schema_id = s.schema_id
						AND s.[name] = 'DWReporting_DocHub'
			WHERE o.[Name] = 'ufns_DateTimeCompare_ORIGINAL'
				AND o.[type_desc] = 'SQL_SCALAR_FUNCTION'
				AND o.[type] = 'FN'	--redundant but it gives me the warm fuzzies... sssoooo... *shrug*
		) = 0	--if 0, then that means the object in question does **NOT** previously exist and, if it does **NOT** previously exist, you know what THAT means... 
		EXECUTE ('CREATE FUNCTION DWReporting_DocHub.ufns_DateTimeCompare_ORIGINAL AS')	--... create 'ol Stubby... hopefully we won't have to put 'ol Stubby down like we did 'ol Yeller... :-(
	ELSE
		PRINT 'Already there, my dude... but I''ll do ya a solid and execute the ALTER...'
	GO



--IF (SELECT COUNT(*) FROM sys.objects WHERE [Name] = 'ufns_DateTimeCompare' AND [type_desc] = 'SQL_SCALAR_FUNCTION' AND [type] = 'FN') > 0
--   DROP FUNCTION [DWReporting_DocHub].[ufns_DateTimeCompare];
--GO



SET ANSI_NULLS ON
GO



SET QUOTED_IDENTIFIER ON
GO



ALTER FUNCTION [DWReporting_DocHub].[ufns_DateTimeCompare_ORIGINAL] (
																		@DateTime1 DATETIME2 = NULL
																	  , @DateTime2 DATETIME2 = NULL
																	  , @DateTime3 DATETIME2 = NULL
																	  , @DateTime4 DATETIME2 = NULL
																	  , @DateTime5 DATETIME2 = NULL
																	  , @DateTime6 DATETIME2 = NULL
																	  , @DateTime7 DATETIME2 = NULL
																	  , @DateTime8 DATETIME2 = NULL
																	  , @DateTime9 DATETIME2 = NULL
																	  --, @ReturnWhichDate BIT = NULL
														            ) RETURNS DATETIME2 AS 
BEGIN
	--/*************************************************************************************************************************************************************
	---------------------------------------------------------------------------------------------
	--  Name				:	[DWReporting_DocHub].[ufns_DateTimeCompare_ORIGINAL]
	--
	--  Developer			:	NStuart
	--
	--  Date Created		:   06/11/2025
	--
	--  Purpose				:   This function is used to compare two arguments (DATETIME2 data type) and return the newer or older of the two dates based on the @ReturnWhichDate argument
	--		    
	--	Business Unit		:	DocsAI
	--
	--	RDL					:	
	---------------------------------------------------------------------------------------------
	--                      M O D I F I C A T I O N     L O G
	---------------------------------------------------------------------------------------------
	-- NAME			    DATE			      COMMENTS
	---------------------------------------------------------------------------------------------
	-- NSTUART	 	   06/11/2025		      Function creation
	-- 
	--*************************************************************************************************************************************************************/

		DECLARE @ReturnValue DATETIME2 = CAST('01-01-1900' AS DATETIME2)



			IF @DateTime1 IS NOT NULL
				AND @DateTime1 >= ISNULL(@DateTime2, @DateTime1)
				AND @DateTime1 >= ISNULL(@DateTime3, @DateTime1)
				AND @DateTime1 >= ISNULL(@DateTime4, @DateTime1)
				AND @DateTime1 >= ISNULL(@DateTime5, @DateTime1)
				AND @DateTime1 >= ISNULL(@DateTime6, @DateTime1)
				AND @DateTime1 >= ISNULL(@DateTime7, @DateTime1)
				AND @DateTime1 >= ISNULL(@DateTime8, @DateTime1)
				AND @DateTime1 >= ISNULL(@DateTime9, @DateTime1)
					SET @ReturnValue = @DateTime1

			ELSE IF @DateTime2 IS NOT NULL
				AND @DateTime2 >= ISNULL(@DateTime1, @DateTime2)
				AND @DateTime2 >= ISNULL(@DateTime3, @DateTime2)
				AND @DateTime2 >= ISNULL(@DateTime4, @DateTime2)
				AND @DateTime2 >= ISNULL(@DateTime5, @DateTime2)
				AND @DateTime2 >= ISNULL(@DateTime6, @DateTime2)
				AND @DateTime2 >= ISNULL(@DateTime7, @DateTime2)
				AND @DateTime2 >= ISNULL(@DateTime8, @DateTime2)
				AND @DateTime2 >= ISNULL(@DateTime9, @DateTime2)
					SET @ReturnValue = @DateTime2

			ELSE IF @DateTime3 IS NOT NULL
				AND @DateTime3 >= ISNULL(@DateTime1, @DateTime3)
				AND @DateTime3 >= ISNULL(@DateTime2, @DateTime3)
				AND @DateTime3 >= ISNULL(@DateTime4, @DateTime3)
				AND @DateTime3 >= ISNULL(@DateTime5, @DateTime3)
				AND @DateTime3 >= ISNULL(@DateTime6, @DateTime3)
				AND @DateTime3 >= ISNULL(@DateTime7, @DateTime3)
				AND @DateTime3 >= ISNULL(@DateTime8, @DateTime3)
				AND @DateTime3 >= ISNULL(@DateTime9, @DateTime3)
					SET @ReturnValue = @DateTime3

			ELSE IF @DateTime4 IS NOT NULL
				AND @DateTime4 >= ISNULL(@DateTime1, @DateTime4)
				AND @DateTime4 >= ISNULL(@DateTime2, @DateTime4)
				AND @DateTime4 >= ISNULL(@DateTime3, @DateTime4)
				AND @DateTime4 >= ISNULL(@DateTime5, @DateTime4)
				AND @DateTime4 >= ISNULL(@DateTime6, @DateTime4)
				AND @DateTime4 >= ISNULL(@DateTime7, @DateTime4)
				AND @DateTime4 >= ISNULL(@DateTime8, @DateTime4)
				AND @DateTime4 >= ISNULL(@DateTime9, @DateTime4)
					SET @ReturnValue = @DateTime4

			ELSE IF @DateTime5 IS NOT NULL
				AND @DateTime5 >= ISNULL(@DateTime1, @DateTime5)
				AND @DateTime5 >= ISNULL(@DateTime2, @DateTime5)
				AND @DateTime5 >= ISNULL(@DateTime3, @DateTime5)
				AND @DateTime5 >= ISNULL(@DateTime4, @DateTime5)
				AND @DateTime5 >= ISNULL(@DateTime6, @DateTime5)
				AND @DateTime5 >= ISNULL(@DateTime7, @DateTime5)
				AND @DateTime5 >= ISNULL(@DateTime8, @DateTime5)
				AND @DateTime5 >= ISNULL(@DateTime9, @DateTime5)
					SET @ReturnValue = @DateTime5

			ELSE IF @DateTime6 IS NOT NULL
				AND @DateTime6 >= ISNULL(@DateTime1, @DateTime6)
				AND @DateTime6 >= ISNULL(@DateTime2, @DateTime6)
				AND @DateTime6 >= ISNULL(@DateTime3, @DateTime6)
				AND @DateTime6 >= ISNULL(@DateTime4, @DateTime6)
				AND @DateTime6 >= ISNULL(@DateTime5, @DateTime6)
				AND @DateTime6 >= ISNULL(@DateTime7, @DateTime6)
				AND @DateTime6 >= ISNULL(@DateTime8, @DateTime6)
				AND @DateTime6 >= ISNULL(@DateTime9, @DateTime6)
					SET @ReturnValue = @DateTime6

			ELSE IF @DateTime7 IS NOT NULL
				AND @DateTime7 >= ISNULL(@DateTime1, @DateTime7)
				AND @DateTime7 >= ISNULL(@DateTime2, @DateTime7)
				AND @DateTime7 >= ISNULL(@DateTime3, @DateTime7)
				AND @DateTime7 >= ISNULL(@DateTime4, @DateTime7)
				AND @DateTime7 >= ISNULL(@DateTime5, @DateTime7)
				AND @DateTime7 >= ISNULL(@DateTime6, @DateTime7)
				AND @DateTime7 >= ISNULL(@DateTime8, @DateTime7)
				AND @DateTime7 >= ISNULL(@DateTime9, @DateTime7)
					SET @ReturnValue = @DateTime7

			ELSE IF @DateTime8 IS NOT NULL
				AND @DateTime8 >= ISNULL(@DateTime1, @DateTime8)
				AND @DateTime8 >= ISNULL(@DateTime2, @DateTime8)
				AND @DateTime8 >= ISNULL(@DateTime3, @DateTime8)
				AND @DateTime8 >= ISNULL(@DateTime4, @DateTime8)
				AND @DateTime8 >= ISNULL(@DateTime5, @DateTime8)
				AND @DateTime8 >= ISNULL(@DateTime6, @DateTime8)
				AND @DateTime8 >= ISNULL(@DateTime7, @DateTime8)
				AND @DateTime8 >= ISNULL(@DateTime9, @DateTime8)
					SET @ReturnValue = @DateTime8

			ELSE IF @DateTime9 IS NOT NULL
				AND @DateTime9 >= ISNULL(@DateTime1, @DateTime9)
				AND @DateTime9 >= ISNULL(@DateTime2, @DateTime9)
				AND @DateTime9 >= ISNULL(@DateTime3, @DateTime9)
				AND @DateTime9 >= ISNULL(@DateTime4, @DateTime9)
				AND @DateTime9 >= ISNULL(@DateTime5, @DateTime9)
				AND @DateTime9 >= ISNULL(@DateTime6, @DateTime9)
				AND @DateTime9 >= ISNULL(@DateTime7, @DateTime9)
				AND @DateTime9 >= ISNULL(@DateTime8, @DateTime9)
					SET @ReturnValue = @DateTime9




		RETURN @ReturnValue
END	--CREATE FUNCTION [DWReporting_DocHub].[ufns_NathansExtractProcessorName] (@InputValue [VARCHAR](500) = '') RETURNS VARCHAR(500)


/*
	SELECT DWReporting_DocHub.ufns_DateTimeCompare_ORIGINAL(GETDATE(), DATEADD(DAY, -1, GETDATE()), 1) AS 'Newest'
         , DWReporting_DocHub.ufns_DateTimeCompare_ORIGINAL(GETDATE(), DATEADD(DAY, -1, GETDATE()), 0) AS 'Oldest'
         , DWReporting_DocHub.ufns_DateTimeCompare_ORIGINAL(DATEADD(DAY, -1, GETDATE()), GETDATE(), 0) AS 'Oldest'
         , DWReporting_DocHub.ufns_DateTimeCompare_ORIGINAL(DATEADD(DAY, -1, GETDATE()), GETDATE(), 1) AS 'Newest'

	SELECT DWReporting_DocHub.ufns_DateTimeCompare_ORIGINAL(NULL, DATEADD(DAY, -1, GETDATE()), 1) AS '1'
         , DWReporting_DocHub.ufns_DateTimeCompare_ORIGINAL(NULL, NULL, 0) AS '2'
         , DWReporting_DocHub.ufns_DateTimeCompare_ORIGINAL(NULL, NULL, NULL) AS '3'
         , DWReporting_DocHub.ufns_DateTimeCompare_ORIGINAL(DATEADD(DAY, -1, GETDATE()), NULL, NULL) AS '4'
         , DWReporting_DocHub.ufns_DateTimeCompare_ORIGINAL(DATEADD(DAY, -1, GETDATE()), GETDATE(), NULL) AS '5'



	SELECT DWReporting_DocHub.ufns_DateTimeCompare_ORIGINAL(
																DATEADD(DAY, 1, GETDATE())
															  , NULL
															  , DATEADD(DAY, 3, GETDATE())
															  , DATEADD(DAY, 4, GETDATE())
															  , DATEADD(DAY, 5, GETDATE())
															  , DATEADD(DAY, 6, GETDATE())
															  , DATEADD(DAY, 7, GETDATE())
															  , DATEADD(DAY, 8, GETDATE())
															  , DATEADD(DAY, 9, GETDATE())
														   )

*/