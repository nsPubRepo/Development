/****** Object:  StoredProcedure [DWStage_DocHub].[usp_insert_ProcessorVersionType_Dim]    Script Date: 07/30/2025 11:10:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [DWStage_DocHub].[usp_insert_ProcessorVersionType_Dim] @JobName [VARCHAR](128),@JobRunID [VARCHAR](50) AS 
 
/**********************************************************************************************************
-----------------------------------------------------------------------------------------------------------
  Name         :	usp_insert_ProcessorVersionType_Dim

  Developer    :	John Allard

  Date Created :	12/16/2024

  Purpose	   :	Ingests and parses DataHub Processor strings into a dedicated dimension table.
  
  Business Unit:	Doc Knights : S.H.U.S.H.
  
  JIRA/TFS	   :	POWERBI-280 : PowerBI | DataMart | ETL Process Update
  
  Example	   :	See run script at bottom.
  
-----------------------------------------------------------------------------------------------------------
					M O D I F I C A T I O N     L O G
-----------------------------------------------------------------------------------------------------------
  REV	NAME		DATE			COMMENTS
-----------------------------------------------------------------------------------------------------------
   1	jallard		12/16/2024		Initial version created.
   2	jallard		03/13/2025		POWERBI-348: Added ProcessorNameFriendly column.

**********************************************************************************************************/


SET NOCOUNT ON;

-----------------------------------------------------------------------------------------------------------
-- Declare, assign all variables and default values:
-----------------------------------------------------------------------------------------------------------

DECLARE @CurrentDatestamp DATETIME2(3) = CONVERT(DATETIMEOFFSET, GETDATE()) AT TIME ZONE 'Eastern Standard Time'
      , @ErrorMessage     NVARCHAR(2000)
      , @TargetTableName  VARCHAR(128);

	
-----------------------------------------------------------------------------------------------------------
-- Drop temp tables if they current exist (required within Azure Synapse for multiple runs in the same 
-- session window):
-----------------------------------------------------------------------------------------------------------
	
IF OBJECT_ID('tempdb..#tempProcessor') IS NOT NULL
	BEGIN
		DROP TABLE #tempProcessor;
	END;

IF OBJECT_ID('tempdb..#tempProcessorVersionType_Dim') IS NOT NULL
	BEGIN
		DROP TABLE #tempProcessorVersionType_Dim;
	END;


-----------------------------------------------------------------------------------------------------------
-- Load DM tables:
-----------------------------------------------------------------------------------------------------------

BEGIN TRY

	-------------------------------------------------------------------------------------------------------
	-- Create, load temp table with Processor values that do not currently exist in DM table:
	-------------------------------------------------------------------------------------------------------

		SET @TargetTableName = '#tempProcessor';
	
		CREATE TABLE #tempProcessor
		WITH (
			  DISTRIBUTION = HASH (Processor)
			, CLUSTERED INDEX (Processor)   
		)
		AS
		SELECT DISTINCT Processor 
		FROM DWStage_DocHub.ExtractionDocument_Fact e
		WHERE NOT EXISTS (
			SELECT 1 FROM DMDocHub.ProcessorVersionType_Dim p
			WHERE p.Processor = e.Processor
		);

	
	-------------------------------------------------------------------------------------------------------
	-- Create, load temp table with ProcessorVersion table values to be loaded:
	-------------------------------------------------------------------------------------------------------
	
		SET @TargetTableName = '#tempProcessorVersionType_Dim';

		CREATE TABLE #tempProcessorVersionType_Dim
			(
				  Processor				  NVARCHAR(255) NOT NULL
				, BaseFoundationModel	  VARCHAR(100)	NULL
				, OcrVersion			  VARCHAR(10)	NULL
				, ProcessorId			  VARCHAR(50)	NULL	
				, ProcessorName			  VARCHAR(100)  NULL
				, ProcessorVersionId	  VARCHAR(50)   NULL
				, ProcessorNameFriendly	  VARCHAR(100)  NULL
			)

			WITH
				(
					  DISTRIBUTION = HASH (Processor)
					, CLUSTERED INDEX (Processor)
				);



			WITH cteProcessorRaw AS
				(
					SELECT t.Processor
						 , TRIM(TRANSLATE(c.[value], N'{}', N'  ')) AS [value]
					FROM #tempProcessor t

						CROSS APPLY STRING_SPLIT(Processor, ',') C
				)



			, cteProcessorValues AS
				(
					SELECT Processor
						 , BaseFoundationModel
						 , OcrVersion
						 , ProcessorId
						 , ProcessorName
						 , ProcessorVersionId
					FROM (
							SELECT Processor
								 , LEFT([value], CHARINDEX(N'=', [value]) - 1) AS [Column]
								 , RIGHT([value], LEN([value]) - CHARINDEX(N'=', [value])) AS [Value]
							FROM cteProcessorRaw
						 ) t

					PIVOT 
						(
						  MAX([Value]) 
						  FOR [Column] IN (
											  [BaseFoundationModel]
											, [OcrVersion]
											, [ProcessorId]
											, [ProcessorName]
											, [ProcessorVersionId]
										  )
						) p
				)



		INSERT #tempProcessorVersionType_Dim
			(
				  Processor
				, BaseFoundationModel
				, OcrVersion
				, ProcessorId
				, ProcessorName
				, ProcessorVersionId
				, ProcessorNameFriendly
			)
				SELECT Processor
					 , BaseFoundationModel
					 , OcrVersion
					 , ProcessorId
					 , ProcessorName
					 , ProcessorVersionId
					 , 'Undefined' AS ProcessorNameFriendly
				FROM cteProcessorValues c;


	
	-------------------------------------------------------------------------------------------------------
	-- Load Data Mart table:
	-------------------------------------------------------------------------------------------------------
	
		SET @TargetTableName = 'ProcessorVersionType_Dim';

		INSERT DMDocHub.ProcessorVersionType_Dim
			(
				  Processor
				, BaseFoundationModel
				, OcrVersion
				, ProcessorId
				, ProcessorName
				, ProcessorVersionId
				, ActiveIND
				, CreatedDatetime
				, CreatedUserName
				, ModifiedDatetime
				, ModifiedUserName
				, ProcessorNameFriendly
			)
				SELECT 
					  Processor
					, BaseFoundationModel
					, OcrVersion
					, ProcessorId
					, ProcessorName
					, ProcessorVersionId
					, 1
					, GETUTCDATE()
					, CURRENT_USER
					, GETUTCDATE()
					, CURRENT_USER
					, ProcessorNameFriendly
				FROM #tempProcessorVersionType_Dim;
END TRY



BEGIN CATCH
    SET @ErrorMessage = CONCAT(ERROR_NUMBER(), ': ',  ERROR_MESSAGE());

    EXEC DWCommon.usp_Insert_LoadError 
          @p_JobName          = @JobName
        , @p_JobRunID         = @JobRunID
        , @p_SourceTableName  = NULL
        , @p_SourceColumnName = NULL
        , @p_TargetTableName  = @TargetTableName
        , @p_TargetColumnName = NULL
        , @p_ErrorMessage     = @ErrorMessage;

    THROW 50005, @ErrorMessage, 1;
END CATCH;




/*  Run script:

	EXEC DWStage_DocHub.usp_insert_ProcessorVersionType_Dim
		  @JobName	= 'ManualRun_20250313_01'
        , @JobRunID	= '02';

	
	SELECT * FROM DMDocHub.ProcessorVersionType_Dim;

*/
GO


