

IF (SELECT COUNT(*) FROM sys.objects WHERE [Name] = 'ufns_RemoveNonAlphasFromString' AND [type_desc] = 'SQL_SCALAR_FUNCTION' AND [type] = 'FN') > 0
   DROP FUNCTION [DWReporting_DocHub].[ufns_RemoveNonAlphasFromString];
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [DWReporting_DocHub].[ufns_RemoveNonAlphasFromString] (@InputValue [VARCHAR](500) = NULL) RETURNS VARCHAR(500)
AS 
 BEGIN
	--/*************************************************************************************************************************************************************
	---------------------------------------------------------------------------------------------
	--  Name				:	[DWReporting_DocHub].[ufns_RemoveNonAlphasFromString]
	--
	--  Developer			:	NStuart
	--
	--  Date Created		:   12/20/2024
	--
	--  Purpose				:   This function determines if there are any non-alpha characters passed in (via @InputValue) and returns '1' or '0' based on non-alpha presence ('1' = all alpha / '0' = non-alpha)
	--		    
	--	Business Unit		:	DocsAI
	--
	--	RDL					:	
	---------------------------------------------------------------------------------------------
	--                      M O D I F I C A T I O N     L O G
	---------------------------------------------------------------------------------------------
	-- NAME			    DATE			      COMMENTS
	---------------------------------------------------------------------------------------------
	-- NStuart          12/20/2024		      Function creation
	--*************************************************************************************************************************************************************/
	DECLARE @OriginalString VARCHAR(500) = TRIM(COALESCE(@InputValue, ''))
	DECLARE @ReturnValue VARCHAR(500) = ''
          , @LoopIndex INT = 1
          , @LoopCeiling INT = LEN(@OriginalString)
          , @CharBeingExamined CHAR(1) = ''


	--Loop through the the entire @OriginalString examining each character to determine if the character in question is or is not an alpha character
		WHILE (@LoopIndex <= @LoopCeiling)
			BEGIN
				SET @CharBeingExamined = SUBSTRING(@OriginalString, @LoopIndex, 1)

				IF (DWReporting_DocHub.ufns_IsStringAlpha(@CharBeingExamined) = 1)
					SET @ReturnValue = @ReturnValue + @CharBeingExamined

				SET @LoopIndex = @LoopIndex + 1	--increment @LoopIndex 
			END	--WHILE (@LoopIndex <= @LoopCeiling)


		--*beep, beep, beep* the UPS / FedEx / Amazon truck is backing up to ship out the return value
			RETURN @ReturnValue

END	--CREATE FUNCTION [DWReporting_DocHub].[ufns_RemoveNonAlphasFromString] (@InputValue [VARCHAR](500) = NULL) RETURNS VARCHAR(500)

/*
	select DWReporting_DocHub.ufns_RemoveNonAlphasFromString('')
         , DWReporting_DocHub.ufns_RemoveNonAlphasFromString('Hejdkasdiw')
         , DWReporting_DocHub.ufns_RemoveNonAlphasFromString('a1b2c3')
         --, DWReporting_DocHub.ufns_RemoveNonAlphasFromString('')
*/
