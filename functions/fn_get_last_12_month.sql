
if exists(
	select *
	from sys.objects
	where name = 'fn_get_last_12_month'
)
begin
	drop function fn_get_last_12_month	
end
go

create function fn_get_last_12_month (
	@today datetime
)
returns @tb_mth table (
	seq int
	, mth int
	, mth_name varchar(3)
	, start_dt datetime
	, end_dt datetime
)
as
begin
/*
18-sep-15,lhw
- returns the last 12 months.

	select *
	from dbo.fn_get_last_12_month(getdate())

*/

	declare 
		@curr_mth int
		, @start_dt datetime

	set @curr_mth = month(@today)
	set @start_dt = dbo.fn_month_start(@today)

	;
	with tb_mth (seq, mth, start_dt)
	as
	(
		select 12 as seq, @curr_mth as mth, @start_dt as start_dt
		union all
		select 
			seq - 1
			, case when mth - 1 > 0 then mth - 1 else mth + 11 end
			, dateadd(month, -1, start_dt)

		from tb_mth 
		where seq > 1
	)
	insert into @tb_mth (
		seq, mth, mth_name, start_dt, end_dt
	)
	select 
		seq
		, mth		
		, left(datename(month, start_dt), 3)
		, start_dt
		, dbo.fn_end_of_day(dbo.fn_month_end(start_dt))
	from tb_mth

	return

end

go
