SELECT @@servername as [Server name]
    , session_id as SPID
    , substring(a.text, charindex('[', a.text )+1, charindex(']', a.text )-charindex('[', a.text )-1) AS [Database name]
    , percent_complete as [Completed %]
    , Command
    , a.text AS Query
    , start_time as [Started]
    , dateadd(second,estimated_completion_time/1000, getdate()) as ETA
FROM sys.dm_exec_requests r CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) a 
WHERE r.command in ('BACKUP DATABASE','RESTORE DATABASE', 'BACKUP LOG', 'RESTORE LOG')