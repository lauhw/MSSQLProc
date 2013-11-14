if exists(select * from sys.objects where name = 'mgt_db_size')
begin
	drop proc mgt_db_size
end	
go

create proc mgt_db_size
as
begin

/*
15-jun-11,lau@ciysys.com
-show the current database size & info.

Example:

	exec mgt_db_size

*/

	declare @db_name sysname
	select @db_name = db_name()
	exec sp_helpdb @db_name

end
go


