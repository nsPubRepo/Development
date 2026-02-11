

SELECT S.[name]					AS [schema name]
     , O.[name]					AS [object name]
     , O.[object_id]
     , O.principal_id
     , O.[schema_id]
     , O.parent_object_id
     , O.[type]
     , O.[type_desc]
     , O.create_date
     , O.modify_date
     , O.is_ms_shipped
     , O.is_published
     , O.is_schema_published
FROM sys.objects O

	INNER JOIN sys.schemas S
		ON O.schema_id = S.schema_id

WHERE O.[type_desc] IN ('USER_TABLE', 'SQL_STORED_PROCEDURE')
	AND (
			S.[name] = 'DMDocHub'					--appears to be mainly for TABLES
				OR S.[name] = 'DWReporting'			--appaers to be maily for SPROCs // IS THIS SCHEMA EVEN APPLICABLE TO PBI REPORTING / DOC-DATAHUB???
				OR S.[name] = 'DWReporting_DocHub'	--appears to NOT be applicable for EITHER sprocs nor tables
				OR S.[name] = 'DWRaw_DocHub'		--a mix of tables and sprocs
				OR S.[name] = 'DWStage_DocHub'		--a mix of tables and sprocs
		)

ORDER BY S.[name]
       , O.[name] ASC




--SELECT * FROM sys.schemas ORDER BY [name] ASC
--SELECT * FROM sys.objects ORDER BY [name] ASC
