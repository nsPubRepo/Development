


--If the SPROC in question does **NOT** already exist, create an empty shell / stubbed-out version of the SPROC in question.
--Doing this will cause the execution plan, for the SPROC in question, to PERSIST (ALTERs don't drop EP's but DROPs do...)
	--IF (
	--		SELECT COUNT(*)
	--		FROM sys.objects o
	--			INNER JOIN sys.schemas s
	--				ON o.schema_id = s.schema_id
	--					AND s.[name] = 'DWReporting_DocHub'
	--		WHERE o.[Name] = 'ufns_CompareTwoDateTimes'
	--			AND o.[type_desc] = 'SQL_SCALAR_FUNCTION'
	--			AND o.[type] = 'FN'	--redundant but it gives me the warm fuzzies... sssoooo... *shrug*
	--	) = 0	--if 0, then that means the object in question does **NOT** previously exist and, if it does **NOT** previously exist, you know what THAT means... 
	--	EXECUTE ('CREATE FUNCTION DWReporting_DocHub.ufns_CompareTwoDateTimes AS')	--... create 'ol Stubby... hopefully we won't have to put 'ol Stubby down like we did 'ol Yeller... :-(
	--ELSE
	--	PRINT 'Already there, my dude... but I''ll do ya a solid and execute the ALTER...'
	--GO



IF (SELECT COUNT(*) FROM sys.objects WHERE [Name] = 'ufns_CompareTwoDateTimes' AND [type_desc] = 'SQL_SCALAR_FUNCTION' AND [type] = 'FN') > 0
   DROP FUNCTION [DWReporting_DocHub].[ufns_CompareTwoDateTimes];
GO



SET ANSI_NULLS ON
GO



SET QUOTED_IDENTIFIER ON
GO



CREATE FUNCTION [DWReporting_DocHub].[ufns_CompareTwoDateTimes] (@DateTime1 DATETIME2 = NULL, @DateTime2 DATETIME2 = NULL, @ReturnWhichDate BIT = NULL) RETURNS DATETIME2 AS 
BEGIN
	--/*************************************************************************************************************************************************************
	---------------------------------------------------------------------------------------------
	--  Name				:	[DWReporting_DocHub].[ufns_CompareTwoDateTimes]
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
	-- NStuart	 	   06/11/2025		      Function creation
	-- 
	--*************************************************************************************************************************************************************/



	DECLARE @NewerDateTime DATETIME2 = CAST('01-01-1900' AS DATETIME2)
          , @OlderDateTime DATETIME2 = CAST('01-01-1900' AS DATETIME2)
          , @ReturnValue DATETIME2 = CAST('01-01-1900' AS DATETIME2)



		IF @DateTime1 IS NOT NULL
			AND @DateTime2 IS NOT NULL
				IF DATEDIFF(SECOND, @DateTime1, @DateTime2) >= 0
					BEGIN
						SET @NewerDateTime = @DateTime2
						SET @OlderDateTime = @DateTime1
					END
				ELSE
					BEGIN
						SET @NewerDateTime = @DateTime1
						SET @OlderDateTime = @DateTime2
					END

		ELSE IF @DateTime1 IS NOT NULL
			BEGIN
				SET @NewerDateTime = @DateTime1
				SET @OlderDateTime = @DateTime1
			END

		ELSE IF @DateTime2 IS NOT NULL
			BEGIN
				SET @NewerDateTime = @DateTime2
				SET @OlderDateTime = @DateTime2
			END



		IF @ReturnWhichDate = 1
			SET @ReturnValue = @NewerDateTime
		ELSE
			SET @ReturnValue = @OlderDateTime



		RETURN @ReturnValue
END	--ALTER FUNCTION [DWReporting_DocHub].[ufns_NathansExtractProcessorName] (@InputValue [VARCHAR](500) = '') RETURNS VARCHAR(500)


/*
	SELECT DWReporting_DocHub.ufns_DateTimeCompare(DATEADD(DAY, 1, GETDATE()), NULL, 1)
*/