SET STATISTICS XML ON;
exec sp_executesql N'SELECT COUNT(*)  FROM [CallLogs] AS [c]  WHERE [c].[CustomerId] = @__s_cc_Id_0',@__s_cc_Id_0=271409;
SET STATISTICS XML OFF;

SELECT COUNT(*)  FROM [CallLogs] AS [c]  WHERE [c].[CustomerId] = @__s_cc_Id_0