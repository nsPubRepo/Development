

--If the SPROC in question does **NOT** already exist, create an empty shell / stubbed-out version of the SPROC in question.
--Doing this will cause the execution plan, for the SPROC in question, to PERSIST (ALTERs don't drop EP's but DROPs do...)
	IF (
			SELECT COUNT(*)
			FROM sys.objects o
				INNER JOIN sys.schemas s
					ON o.schema_id = s.schema_id
						AND s.[name] = '<some_schema>'
			WHERE o.[Name] = '<some_SPROC>'
				AND o.[type_desc] = 'SQL_STORED_PROCEDURE'
				AND o.[type] = 'P'
		) = 0	--if 0, then that means the SPROC in question does **NOT** previously exist and, if it does **NOT** previously exist, you know what THAT means... 
		EXECUTE ('CREATE PROCEDURE <some_schema>.<some_SPROC> AS')	--... create 'ol stubby... hopefully we won't have to put stubby down like we did 'ol Yeller... :-(
	--ELSE
	--	PRINT 'Already there, my dude...'
	GO



SET ANSI_NULLS ON
GO



SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE <some_schema>.<some_SPROC> AS	--update (i.e., ALTER) the guts... how do you feel about field dressing a fresh kill?
-- 	--/*************************************************************************************************************************************************************
--	---------------------------------------------------------------------------------------------
--	--  Name				:	<some_schema>.<some_SPROC_name>
--	--
--	--  Developer			:	<some_developer>
--	--
--	--  Date Created		:   <some_date>
--	--
--	--  Purpose				:   <some_description>
--	--
--	--	Business Unit		:	<some_business_unit> (DocsAI, perhaps?)
--	---------------------------------------------------------------------------------------------
--	--                      M O D I F I C A T I O N     L O G
--	---------------------------------------------------------------------------------------------
--	-- NAME					DATE			      COMMENTS
--	---------------------------------------------------------------------------------------------
--	-- <some_developer>     <some_date>           <some_comment>
--	-- 
--	--*************************************************************************************************************************************************************/


	/*
		Write yer crap here...
	*/