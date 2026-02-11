


SELECT DISTINCT Processor
INTO #tempProcessor
FROM DMDocHub.ProcessorVersionType_Dim



--SELECT * FROM #tempProcessor
--SELECT * FROM #tempCrossApplied



/**************************************/
	SELECT t.Processor
		 , TRIM(TRANSLATE(c.[value], N'{}', N'  ')) AS [value]
	INTO #tempCrossApplied
	FROM #tempProcessor t

		CROSS APPLY STRING_SPLIT(t.Processor, ',') C
--SELECT * FROM #tempCrossApplied
/**************************************/



/**************************************/
	SELECT Processor			--the 'Processor' column is, in fact, coming from the 't' asliased subquery (see the FROM statement) however, because of the PIVOT command, any attempts to bind the Processor field to the 't' aliased table will fail - the 'Processor' column **MUST** remain un-bound... free... unencumbered of the material realm... 
		 , Pivoted.BaseFoundationModel
		 , Pivoted.OcrVersion
		 , Pivoted.ProcessorId
		 , Pivoted.ProcessorName
		 , Pivoted.ProcessorVersionId
	FROM
		(
			SELECT TCA.Processor
				 , LEFT(TCA.[value], CHARINDEX(N'=', TCA.[value]) - 1)				AS [Column]		--gets string, starting, from the left, at character 1 and going, in left-to-right fashion, *THROUGH* the character at position as defined by "CHARINDEX(N'=', [value]) - 1)"
				 , RIGHT(TCA.[value], LEN([value]) - CHARINDEX(N'=', TCA.[value]))	AS [Value]		--gets string, starting, from the right, at the *LAST* character and going, in a right-to-leftr fashion, *THROUGH* the amount of characters as defined by "LEN([value]) - CHARINDEX(N'=', tca.[value])" (e.g., if the string is 30 char's long and the "=" is at postion 20, 10 characters (30 - 20 = 10), starting at the last character and going to the right, will be returned
			FROM #tempCrossApplied TCA
		) t

			PIVOT 
				(
					MAX(t.[Value])				--"Value" is the name of the column where the (below) values are currently "lumped" into amongst other values (e.g., "=", "GPT-Vision", "1.0", etc.)
					FOR t.[Column] IN (			--these are the EXTRACTED vales which we want to become the COLUMN HEADERS (names)
										  [BaseFoundationModel]		--NOTE: column names **MUST** be encapsulated in opening & closing BRACKETS ("[" and "]")
										, [OcrVersion]
										, [ProcessorId]
										, [ProcessorName]
										, [ProcessorVersionId]
									  )
				) Pivoted
/**************************************/



--DROP TABLE #tempProcessor
--DROP TABLE #tempTest
--DROP TABLE #tempCrossApplied