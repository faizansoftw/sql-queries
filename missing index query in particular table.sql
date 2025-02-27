SELECT 
    migs.avg_total_user_cost * (migs.avg_user_impact / 100.0) * (migs.user_seeks + migs.user_scans) AS [ImprovementMeasure],
    'CREATE INDEX [IX_' + OBJECT_NAME(mid.object_id, mid.database_id) + '_' + 
        REPLACE(REPLACE(REPLACE(ISNULL(mid.equality_columns,''), '[', ''), ']', ''), ', ', '_') + 
        CASE WHEN mid.inequality_columns IS NOT NULL THEN '_' + REPLACE(REPLACE(REPLACE(mid.inequality_columns, '[', ''), ']', ''), ', ', '_') ELSE '' END + 
        '] ON [' + OBJECT_NAME(mid.object_id, mid.database_id) + '] (' + 
        ISNULL(mid.equality_columns,'') +
        CASE WHEN mid.inequality_columns IS NOT NULL AND mid.equality_columns IS NOT NULL THEN ',' ELSE '' END +
        ISNULL(mid.inequality_columns, '') + 
        ')' +
        ISNULL(' INCLUDE (' + mid.included_columns + ')', '') AS [CreateIndexStatement],
    migs.*, mid.database_id, mid.[object_id], OBJECT_NAME(mid.[object_id], mid.database_id) AS [TableName]
FROM 
    sys.dm_db_missing_index_group_stats AS migs
    INNER JOIN sys.dm_db_missing_index_groups AS mig 
        ON migs.group_handle = mig.index_group_handle
    INNER JOIN sys.dm_db_missing_index_details AS mid 
        ON mig.index_handle = mid.index_handle
WHERE 
    mid.database_id = DB_ID('contactaholic-production-db') -- Replace with your database name
    AND OBJECT_NAME(mid.object_id, mid.database_id) = 'CallLogs'
ORDER BY 
    [ImprovementMeasure] DESC;

