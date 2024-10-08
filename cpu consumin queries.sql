
--cpu consuming queries
SELECT TOP 5 sql_text.text, stats.total_worker_time
FROM sys.dm_exec_query_stats AS stats
CROSS APPLY sys.dm_exec_sql_text(stats.sql_handle) AS sql_text
ORDER BY stats.total_physical_reads DESC;



