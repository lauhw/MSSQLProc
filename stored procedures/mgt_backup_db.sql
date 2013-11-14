if exists(select * from sys.objects where name ='mgt_backup_db')
	drop proc mgt_backup_db

go

create proc mgt_backup_db (
	@db_name sysname
)
as
begin
 /*

1-dec-2010,lau@ciysys.com
-backup the specific database.
-this proc can be added to any database.

sample:

	exec mgt_backup_db2 'mydb1'

*/

	declare 
		@sql nvarchar(max),
		@d int,	
		@dow nvarchar(3),
		@bak_device_name sysname
	
	select @d = datepart( weekday, getdate())

	select @dow = (case @d
						when 1 then 'sun'
						when 2 then 'mon'
						when 3 then 'tue'
						when 4 then 'wed'
						when 5 then 'thu'
						when 6 then 'fri'
						when 7 then 'sat'
						end)

	select @bak_device_name = @db_name 
								+ '_'+ @dow
								+ '_bak'

	if exists(
				select *
				from master..sysdevices
				where name = @bak_device_name
			)
	begin
		
		select @sql = '	backup database ' + @db_name
						+ ' to '  
						+ @bak_device_name
						+ ' with init'

		--select @sql
		exec sp_executesql @sql

		select result = 'The database ' + @db_name + ' has been backed up to ' + @bak_device_name
	end
	else
	begin

		select result = 'The device does not exists: ' + @bak_device_name

	end

end
 
go
