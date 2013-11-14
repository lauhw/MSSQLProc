if exists( select * from sys.objects where name ='mgt_reindex')
	drop proc mgt_reindex
go

create proc mgt_reindex
as
begin

/*
6-6-11,lau@ciysys.com
- reindex the database.
	
*/

	declare
		@tb_name sysname
		, @idx_name sysname
		, @sql nvarchar(500)

	declare cr cursor 
	for

		select 
			o.name as tb_name, i.name as idx_name
		from sys.indexes i
		inner join sys.objects o on o.object_id = i.object_id
		where o.type='u'
			and i.name is not null
		order by o.name, i.name

	open cr

	fetch next from cr 
	into @tb_name, @idx_name

	while (@@fetch_status = 0)
	begin
		select @sql = 'dbcc dbreindex(' + @tb_name +','+ @idx_name + ')'
		exec sp_executesql @sql	

		fetch next from cr 
		into @tb_name, @idx_name

	end

	close cr
	deallocate cr


end 
go


