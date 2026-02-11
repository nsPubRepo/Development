


--If the view in question does **NOT** already exist, create an empty shell / stubbed-out version of the SPROC in question.
--Doing this will cause the execution plan, for the SPROC in question, to PERSIST (ALTERs don't drop EP's but DROPs do...)
	IF (
			SELECT COUNT(*)
			FROM sys.objects o
				INNER JOIN sys.schemas s									--INNER JOINing 'cause I want to not only match on the artifact name **BUT** also the schema said artifact resides in (to promote 100,000,000% confirmation that I'm flushing the correct artifact)
					ON o.schema_id = s.schema_id
						AND s.[name] = 'DWReporting_DocHub'
			WHERE o.[Name] = 'ufns_CompareTwoDateTimes'
				AND o.[type_desc] = 'SQL_SCALAR_FUNCTION'
				AND o.[type] = 'FN'	--redundant but it gives me the warm fuzzies... sssoooo... *shrug*
		) <> 0	--if 0, then that means the object in question does **NOT** previously exist and, if it does **NOT** previously exist, you know what THAT means... 
			DROP FUNCTION [DWReporting_DocHub].[ufns_CompareTwoDateTimes]		--... it means it's time to get serious... Schwarzenegger style... #IllBeBack
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
	--	Parameters			: @DateTime1 ==> Datatype DATETIME2 / first date to compare
	--						: @DateTime2 ==> Datatype DATETIME2. Second date to compare
	--						: @ReturnWhichDate ==> Datatype BIT. If '1', then return the newest date (date closest to current, calendar date). If '0', return the oldest date (date furthest from current, calendar date)
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

		ELSE IF @DateTime1 IS NOT NULL	--if here, then **EITHER** DateTime1 **OR** DateTime2 is (are) NULL so we need to check DateTime1 and DateTime2 to determine which one is NULL and act accordingly
			BEGIN
				SET @NewerDateTime = @DateTime1
				SET @OlderDateTime = @DateTime1
			END

		ELSE IF @DateTime2 IS NOT NULL	--if here, then **EITHER** DateTime1 **OR** DateTime2 is (are) NULL so we need to check DateTime1 and DateTime2 to determine which one is NULL and act accordingly
			BEGIN
				SET @NewerDateTime = @DateTime2
				SET @OlderDateTime = @DateTime2
			END



		IF @ReturnWhichDate = 1
			SET @ReturnValue = @NewerDateTime
		ELSE
			SET @ReturnValue = @OlderDateTime



		RETURN @ReturnValue	--"Lets flush this toilet" - Eric O., "South Main Auto"
END	--ALTER FUNCTION [DWReporting_DocHub].[ufns_NathansExtractProcessorName] (@InputValue [VARCHAR](500) = '') RETURNS VARCHAR(500)



/*
	SELECT DWReporting_DocHub.ufns_CompareTwoDateTimes(DATEADD(DAY, 1, GETDATE()), NULL, 1)
*/