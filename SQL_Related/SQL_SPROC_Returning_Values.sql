

IF (SELECT COUNT(*) FROM sys.objects WHERE [Name] = 'usp_Check_Bank_Name_Rules' AND [type_desc] = 'SQL_STORED_PROCEDURE' AND [type] = 'P') > 0
   DROP PROCEDURE [DWReporting_DocHub].[usp_Check_Bank_Name_Rules];
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [DWReporting_DocHub].[usp_Check_Bank_Name_Rules] @InputValue VARCHAR(500), @ReturnValue VARCHAR(500) OUTPUT
AS 
 	--/*************************************************************************************************************************************************************
	---------------------------------------------------------------------------------------------
	--  Name				:	[DWReporting_DocHub].[usp_Check_Bank_Name_Rules]
	--
	--  Developer			:	NStuart
	--
	--  Date Created		:   09/06/2024
	--
	--  Purpose				:   Given a Bank Name, run through the rule list to figure out what the conslidated (mapped) bank name is.
	--							If the name is NOT found in the rule list, check the Special_Bank_Name_Mapping table to see if it's in there.
	--							If the bank name is NOT found in EITHER the rule list nor the lookup table (Special_Bank_Name_Mapping), send
	--							back to the calling object the exact same value which was passed into this SPROC
	--		    
	--	Business Unit		:	DocsAI
	--
	--	RDL					:	
	---------------------------------------------------------------------------------------------
	--                      M O D I F I C A T I O N     L O G
	---------------------------------------------------------------------------------------------
	-- NAME			    DATE			      COMMENTS
	---------------------------------------------------------------------------------------------
	-- NSTUART	 	   09/06/2024		      Function creation
	-- 
	--*************************************************************************************************************************************************************/

		SET @ReturnValue = ''	--gotsta assign an empty string to @ReturnValue right outta the gate because of the line "IF @ReturnValue = ''" (below)


		--Individual bank rules secetion
			--"Chase" rules (NOTE: the order of these rules is by intention - top to bottom, high-to-low matching constraints)
				IF @InputValue LIKE '% Chase%'
					OR @InputValue LIKE 'Chase%'
					--OR REPLACE(@InputValue, ' ', '') LIKE '%chase%' --**DANGEROUS** because there have been some instances where cteISD.OriginalValue contains the literal "purchase" which "chase" is a subset there of however "purchase" is NOT a Chase bank - e.g., "PURCHASE HOUSTON PROPERTIES"
						SET @ReturnValue = 'Chase'

			--"Bank of America" rules (NOTE: the order of these rules is by intention - top to bottom, high-to-low matching constraints)
				IF @InputValue LIKE 'Bank%America%'
					OR REPLACE(@InputValue, ' ', '') LIKE '%BankOfAmerica%'
						SET @ReturnValue = 'Bank of America'

			--"Wells Fargo" rules (NOTE: the order of these rules is by intention - top to bottom, high-to-low matching constraints)
				IF @InputValue LIKE 'Wells Fargo%'
					OR @InputValue LIKE '% Wells Fargo'
					OR @InputValue LIKE 'ells Fargo%'
					OR @InputValue LIKE 'WellsFargo'
					OR @InputValue LIKE 'Fargo %'
					OR REPLACE(@InputValue, ' ', '') LIKE '%WellsFargo%'
						SET @ReturnValue = 'Wells Fargo'

			--"PNC Bank" rules (NOTE: the order of these rules is by intention - top to bottom, high-to-low matching constraints)
				IF @InputValue LIKE 'PNC %'
					OR @InputValue LIKE '%PNC Bank%'
					OR @InputValue LIKE '%PNC%Bank%'
					OR REPLACE(@InputValue, ' ', '') LIKE '%PNC%'
						SET @ReturnValue = 'PNC'
						
			--"Capital One" rules (NOTE: the order of these rules is by intention - top to bottom, high-to-low matching constraints)
				IF @InputValue LIKE '%Capital One%'
					OR REPLACE(@InputValue, ' ', '') LIKE '%CapitalOne%'
						SET @ReturnValue = 'Capital One'

		--Lookup table section - if here, then that means none of the above "rules for the top 5 banks"
		--were matched so, as a last-ditch effort, lets check the lookup table
			--Check the "Special_Bank_Name_Mapping" table for any matches to the "one-off" bank names
				--First, try matching the OriginalValue from the CTE (DMDocHub.DocumentExtractionValue_Fact table)
				--and, if matched, use the MAPPED bank name
					IF @InputValue IN (
										SELECT SBNM.OriginalBankName
										FROM DMDocHub.Special_Bank_Name_Mapping SBNM
									  )
						SET @ReturnValue = (
												SELECT DISTINCT SBNM.MappedBankName
												FROM DMDocHub.Special_Bank_Name_Mapping SBNM
												WHERE @InputValue = SBNM.OriginalBankName
								           )

				--Second, try matching the SCRUBBED value from the CTE (DMDocHub.DocumentExtractionValue_Fact table)
				--and, if matched, use the MAPPED bank name
					IF DWReporting_DocHub.ufn_Scrub_Bank_Name(@InputValue) IN (
																				SELECT SBNM.ScrubbedValue
																				FROM DMDocHub.Special_Bank_Name_Mapping SBNM
																			  )
						SET @ReturnValue =  (
												SELECT DISTINCT SBNM.MappedBankName
												FROM DMDocHub.Special_Bank_Name_Mapping SBNM
												WHERE DWReporting_DocHub.ufn_Scrub_Bank_Name(@InputValue) = SBNM.ScrubbedValue
											)

		--if *NONE* of the above rules weer matched *AND* the seemingly one-off ADE'd bank name is not accounted for in the "Special Bank Name" table, just pass along the contents of the OriginalValue column and display it on the report as-is
			IF @ReturnValue = ''	--if @ReturnValue, at this point in the game, still contains an empty string, that means we haven't made any matches in either the "Rule" section nor the "Lookup table" section
				SET @ReturnValue = @InputValue	--since no matches have been made by this point, just send back the exact same value which was shipped into this function




/*
	DECLARE @InputValue1 VARCHAR(500) = '!@THE HUNTINGTON $%NATIONAL BANK'
          , @InputValue2 VARCHAR(500) = '!@#$#$%Bob''s #%@^@^Bank))(Thing??'
          , @InputValue3 VARCHAR(500) = 'chase!@#$#$%chase #%@^@^Bank))(chase??'
          , @ReturnValue VARCHAR(500) = ''

	EXECUTE DWReporting_DocHub.usp_Check_Bank_Name_Rules @InputValue = @InputValue1, @ReturnValue = @ReturnValue OUTPUT
		SELECT @ReturnValue AS 'Input Value 1'

	EXECUTE DWReporting_DocHub.usp_Check_Bank_Name_Rules @InputValue = @InputValue2, @ReturnValue = @ReturnValue OUTPUT
		SELECT @ReturnValue AS 'Input Value 2'

	EXECUTE DWReporting_DocHub.usp_Check_Bank_Name_Rules @InputValue = @InputValue3, @ReturnValue = @ReturnValue OUTPUT
		SELECT @ReturnValue AS 'Input Value 3'
*/