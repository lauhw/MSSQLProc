if exists(select * from sys.objects where name = 'mgt_cleanup_log_table')
	drop proc mgt_cleanup_log_table
go

create proc mgt_cleanup_log_table
as 
begin
/*
20-oct-10,lau@ciysys.com
- cleanup the log table.
*/

	declare 
		@min bigint
		, @max bigint

	select
		@min= isnull(min(log_id), 0),
		@max = isnull( max(log_id), 0)
	from tb_log

	-- leave 100k records in the log table
	select @max = @max - 100000

	while @min < @max
	begin
		select @min = @min + 1000
		print 'Deleting log_id < ' + cast(@min as varchar)

		delete from tb_log
		where log_id < @min + 1000

	end

end

go
