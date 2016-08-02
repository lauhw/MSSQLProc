if exists(
	select *
	from sys.objects
	where name = 'mgt_index_usage'
)
begin
	drop proc mgt_index_usage
end
go

create proc mgt_index_usage (
	@tb_name sysname = null
)
as
begin

/*
4-apr-16,lhw-
- this proc returns the index usage.

sample code:
	
	exec mgt_index_usage null
	exec mgt_index_usage 'dbo.tb_fa_asset'

reference:
http://aboutsqlserver.com/2014/12/02/size-does-matter-10-ways-to-reduce-the-database-size-and-improve-performance-in-sql-server/

*/

	select 
		s.Name + N'.' + t.name as [Table]
		,i.name as [Index] 
		,i.is_unique as [IsUnique]
		,ius.user_seeks as [Seeks], ius.user_scans as [Scans]
		,ius.user_lookups as [Lookups]
		,ius.user_seeks + ius.user_scans + ius.user_lookups as [Reads]
		,ius.user_updates as [Updates], ius.last_user_seek as [Last Seek]
		,ius.last_user_scan as [Last Scan], ius.last_user_lookup as [Last Lookup]
		,ius.last_user_update as [Last Update]
	from 
		sys.tables t with (nolock) 
		join sys.indexes i with (nolock) on t.object_id = i.object_id
		join sys.schemas s with (nolock) on t.schema_id = s.schema_id
		left outer join sys.dm_db_index_usage_stats ius on
			ius.database_id = db_id() and
			ius.object_id = i.object_id and 
			ius.index_id = i.index_id

	where 
		len(isnull(@tb_name, '')) = 0
		or s.Name + N'.' + t.name = @tb_name

	order by
		s.name, t.name, i.index_id
	


end
go
