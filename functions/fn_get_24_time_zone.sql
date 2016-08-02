
if exists(
	select *
	from sys.objects
	where name = 'fn_get_24_time_zone'
)
begin
	drop function fn_get_24_time_zone	
end
go

create function fn_get_24_time_zone ()
returns @tb_time_zone table (
	time_zone_id int
	, start_time nvarchar(8)
	, end_time nvarchar(8)
)
as
begin
/*#0000_0533

18-sep-15,lhw
- returns the 24 hours time zone.

	select *
	from dbo.fn_get_24_time_zone()

*/

;
	with tb_time_zone (time_zone_id, start_time, end_time)
	as
	(
		select 0, cast('00:00:00'  as nvarchar), cast('00:59:59'  as nvarchar)
		union all
		select 
			time_zone_id + 1
			, cast(right('00' + cast( (time_zone_id + 1)  as nvarchar) + ':00:00', 8)as nvarchar)
			, cast(right('00' + cast( (time_zone_id + 1)  as nvarchar) + ':59:59', 8)as nvarchar)
		from tb_time_zone 
		where time_zone_id < 23
	)
	insert into @tb_time_zone (
		time_zone_id
		, start_time
		, end_time
	)
	select 
		time_zone_id
		, start_time
		, end_time
	from tb_time_zone

	return

end

go
