

IF (SELECT COUNT(*) FROM sys.objects WHERE [Name] = 'ufns_NathansExtractProcessorName' AND [type_desc] = 'SQL_SCALAR_FUNCTION' AND [type] = 'FN') > 0
   DROP FUNCTION [DWReporting_DocHub].[ufns_NathansExtractProcessorName];
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [DWReporting_DocHub].[ufns_NathansExtractProcessorName] (@InputValue [VARCHAR](500) = '') RETURNS VARCHAR(500)
AS 
 BEGIN
	--/*************************************************************************************************************************************************************
	---------------------------------------------------------------------------------------------
	--  Name				:	[DWReporting_DocHub].[ufns_NathansExtractProcessorName]
	--
	--  Developer			:	NStuart
	--
	--  Date Created		:   11/08/2024
	--
	--  Purpose				:   This function is used to extract the Processor Name (ID / Type) from a provided JSON (input) string
	--		    
	--	Business Unit		:	DocsAI
	--
	--	RDL					:	
	---------------------------------------------------------------------------------------------
	--                      M O D I F I C A T I O N     L O G
	---------------------------------------------------------------------------------------------
	-- NAME			    DATE			      COMMENTS
	---------------------------------------------------------------------------------------------
	-- NSTUART	 	   11/08/2024		      Function creation
	-- 
	--*************************************************************************************************************************************************************/

		DECLARE @ReturnValue VARCHAR(500) = NULL
              , @ProcessorName VARCHAR(500) = NULL


		IF @InputValue IS NOT NULL
			AND CHARINDEX('ProcessorID=', @InputValue) > 0
				BEGIN
					SET @ProcessorName = SUBSTRING(@InputValue, CHARINDEX('ProcessorID=', @InputValue) + LEN('ProcessorID='), (CHARINDEX(',ProcessorName', @InputValue) - (CHARINDEX('ProcessorID=', @InputValue) + LEN('ProcessorID='))))
							IF @ProcessorName = 'e3663bffe68069ee'
								SET @ReturnValue = 'Specialized'

							ELSE IF @ProcessorName = 'cee6ac96e02e8323'
								SET @ReturnValue = 'Gemini Pro'

							ELSE
								SET @ReturnValue = '--Unknown Processor--'
				END	--IF @InputValue IS NOT NULL AND CHARINDEX('ProcessorID=', @InputValue) > 0
		

		RETURN ISNULL(@ReturnValue, '--Unknown Processor--')	--including the ISNULL check as a safety in case (regardless of how low of a chance) this function is being fed-in a NULL value
END	--CREATE FUNCTION [DWReporting_DocHub].[ufns_NathansExtractProcessorName] (@InputValue [VARCHAR](500) = '') RETURNS VARCHAR(500)


/*

	SELECT * FROM sys.objects WHERE [Name] = 'ufns_NathansExtractProcessorName'

	select DWReporting_DocHub.ufns_NathansExtractProcessorName('{BaseFoundationModel=pretrained-bankstatement-v1.0-2021-08-08,OcrVersion=1.0,ProcessorId=blahblah,ProcessorName=Bank_Statement_Uptrain,ProcessorVersionId=46f64fde4b381c14}')
         , DWReporting_DocHub.ufns_NathansExtractProcessorName('{BaseFoundationModel=pretrained-bankstatement-v1.0-2021-08-08,OcrVersion=1.0,ProcessorId=e3663bffe68069ee,ProcessorName=Bank_Statement_Uptrain,ProcessorVersionId=46f64fde4b381c14}')
         , DWReporting_DocHub.ufns_NathansExtractProcessorName('{BaseFoundationModel=pretrained-foundation-model-v1.2-2024-05-10,OcrVersion=2.1,ProcessorId=cee6ac96e02e8323,ProcessorName=fine_tuned_pro_TS_40_LR_point4,ProcessorVersionId=78f3c192613bb6e1}')
         , DWReporting_DocHub.ufns_NathansExtractProcessorName('{BaseFoundationModel=pretrained-bankstatement-v1.0-2021-08-08,OcrVersion=1.0,ProcessorId=e3663bffe68069ee,ProcessorName=Bank_Statement_Uptrain,ProcessorVersionId=46f64fde4b381c14}')
         , DWReporting_DocHub.ufns_NathansExtractProcessorName('')
         , DWReporting_DocHub.ufns_NathansExtractProcessorName('happy')
*/