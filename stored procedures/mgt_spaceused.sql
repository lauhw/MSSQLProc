if exists(select * from sys.objects where name = 'mgt_spaceused')
begin
	drop proc mgt_spaceused
end	
go


create proc mgt_spaceused
as

/*
15-jun-11,lhw
-show all table space usage.

Example:

	exec mgt_spaceused

*/

declare @tb table (
	table_name sysname,
	rows int,
	reserved varchar(100),
	data varchar(100), 
	index_size varchar(100), 
	unused varchar(100)
)

insert @tb
exec sp_msforeachtable 'sp_spaceused ''?'''

select * from @tb
ORDER BY CAST(REPLACE(data, ' KB', '') AS integer) DESC


go
