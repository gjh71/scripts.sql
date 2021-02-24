use master
go
set nocount on
declare divDbCrsr cursor read_only
for select name from sys.databases where database_id>4

declare @dbname varchar(255)
open divDbCrsr

fetch next from divDbCrsr into @dbname
while (@@fetch_status<>-1)
begin
	if (@@fetch_status<>-2)
	begin
		print 'Detaching ' + @dbname
		declare dbProcessCrsr cursor read_only
		for select spid, rtrim(program_name) + '@' + rtrim(hostname) + ' user: ' + rtrim(loginame) from master..sysprocesses where dbid=db_id(@dbname)
		declare @processid int
		declare @processdescr varchar(255)
		declare @cmd varchar(255)
		open dbProcessCrsr

		fetch next from dbProcessCrsr into @processid, @processdescr
		while (@@fetch_status<>-1)
		begin
			if (@@fetch_status<>-2)
			begin
				set @cmd = 'kill ' + cast(@processid as varchar(4))
				print @cmd
				exec (@cmd)
				print ' killed: ' + @processdescr + '(' + convert(varchar(12), @processid) + ')'
			end
			fetch next from dbProcessCrsr into @processid, @processdescr
		end
		close dbProcessCrsr
		deallocate dbProcessCrsr

		exec sp_detach_db @dbname, 'true'
		print 'detached.'
	end
	fetch next from divDbCrsr into @dbname
end
close divDbCrsr
deallocate divDbCrsr