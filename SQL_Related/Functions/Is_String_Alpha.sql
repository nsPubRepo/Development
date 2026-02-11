
SET ANSI_NULLS ON
GO



SET QUOTED_IDENTIFIER ON
GO



CREATE FUNCTION [DWReporting_DocHub].[ufns_IsStringAlpha] (@InputValue [VARCHAR](500) = NULL) RETURNS BIT AS
BEGIN
	--/*************************************************************************************************************************************************************
	---------------------------------------------------------------------------------------------
	--  Name				:	[DWReporting_DocHub].[ufns_IsStringAlpha]
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
	--DECLARE @OriginalString NVARCHAR(500) = REPLACE(TRIM(COALESCE(@InputValue, '')), ' ', '')	--set @OriginalValue to be the lower-case version of the @InputValue argument but with spaces REMOVED (because of the first WHILE loop below)
	DECLARE @OriginalString NVARCHAR(500) = TRIM(COALESCE(@InputValue, ''))
	DECLARE @ReturnValue BIT = 1	--default to '1' which means we're presuming the string passed into this function IS all alpha characters
          , @LoopIndex INT = 1
          , @LoopCeiling INT = LEN(@OriginalString)
          , @ASCIIValue INT = 0


	--Loop through the the entire @OriginalString 
		WHILE (@LoopIndex <= @LoopCeiling)
			BEGIN
				SET @ASCIIValue = ASCII(SUBSTRING(@OriginalString, @LoopIndex, 1))	--get the first character (if there is one) in the @OriginalString variable and convert that to an ASCII value

				IF (@ASCIIValue NOT BETWEEN 65 AND 90)			--upper case letters
					AND (@ASCIIValue NOT BETWEEN 97 AND 122)	--lower case letters
					AND (@ASCIIValue <> 32)							--space
						BEGIN
							SET @ReturnValue = 0	--charater in question was NOT found to be an alpha character therefore set return value to be '0'
							BREAK	--bail out of the outter WHILE loop 'cause there's no need to go any further with regard to investigating if any other characters are non-alphas
						END	--IF (@ASCIIValue NOT BETWEEN '' AND '')...

				SET @LoopIndex = @LoopIndex + 1	--increment @LoopIndex 
			END	--WHILE (@LoopIndex <= @LoopCeiling)


		--*beep, beep, beep* the UPS / FedEx / Amazon truck is backing up to ship out the return value
			RETURN @ReturnValue

END
GO


