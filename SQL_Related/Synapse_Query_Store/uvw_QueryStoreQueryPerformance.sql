


--SET ANSI_NULLS ON
--GO



--SET QUOTED_IDENTIFIER ON
--GO



--CREATE VIEW [DWCommon].[uvw_QueryStoreQueryPerformance] AS
	SELECT t.query_sql_text
         , CONVERT(DATETIMEOFFSET
         , r.last_execution_time) AT TIME ZONE 'Eastern Standard Time'											AS last_execution_time
         , r.last_execution_time																				AS last_execution_time_utc
         , t.query_text_id
         , p.plan_id
         , r.count_executions
    
		/* seconds, milliseconds: */
         , CONVERT(DECIMAL(12,2), r.last_duration / 1000.0 / 1000.0)											AS last_duration_s
         , CONVERT(DECIMAL(12,2), r.avg_duration / 1000.0 / 1000.0)												AS avg_duration_s
         , CONVERT(DECIMAL(12,2), r.last_duration / 1000.0)														AS last_duration_ms
         , CONVERT(DECIMAL(12,2), r.avg_duration / 1000.0)														AS avg_duration_ms
     
		/* microseconds: */
         , r.avg_duration
         , r.last_duration
         , r.min_duration
         , r.[max_duration]

		/* Query options not included as Azure Synapse Analytics will always return zero (0): 
		   cpu_time, logical_io_reads, rowcount, et al.    
		*/

		/* microseconds: */
         , q.avg_compile_duration
         , q.last_compile_duration
    
         , LEFT(t.query_sql_text, 100)																			AS query_sql_text_abridged      -- Optional: Used for aggregated counts, if needed.
         , q.query_hash
         , CONVERT(DATETIME2(3), CONVERT(DATETIMEOFFSET, GETDATE())  AT TIME ZONE 'Eastern Standard Time')		AS query_run_datetime
	FROM sys.query_store_plan p																													-- Invalid column name 'has_compile_replay_script' in Azure, do not include in SELECT.

		JOIN sys.query_store_query q
			ON q.query_id = p.query_id

		JOIN sys.query_store_query_text t
			ON t.query_text_id = q.query_text_id

		JOIN sys.query_store_runtime_stats r
			ON r.plan_id = p.plan_id

	WHERE t.query_sql_text NOT LIKE N'%attrep_%';



--GO
