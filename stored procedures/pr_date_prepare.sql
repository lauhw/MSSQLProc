if exists(
	select *
	from sys.objects
	where name = 'pr_date_prepare'
)
begin
	drop proc pr_date_prepare
end
go

create proc pr_date_prepare (
	@start_dt datetime
	, @end_dt datetime
	, @is_debug int = 0
)
as
begin

/*
28-aug-16,lau@ciysys.com
- generate the date for the given period.
Note: this proc does not returns any data. You have to query the records in tb_date.


	exec pr_date_prepare
			@start_dt = '2016-01-01'
			, @end_dt =  '2016-12-31'
			--, @is_debug = 1

	select * from tb_date




*/

	set nocount on

	declare 	
		@rec_cnt int
		, @day_cnt int

	declare @day_tb table (d datetime)

	set @day_cnt = datediff(day, @start_dt, @end_dt) + 1

	select @rec_cnt = count(*)
	from tb_date
	where dt between @start_dt and @end_dt

	if @day_cnt <> @rec_cnt
	begin

		-- generate the date record when it is necessary.
		;with day_tb (dt)
		as (
			select dt = @start_dt
			union all
			select dateadd(day, 1, dt)
			from day_tb
			where dateadd(day, 1, dt) <= @end_dt
		)
		insert into tb_date (dt, yr, mth, qtr, wk, dow, day_mth, day_yr)
		select dt, year(dt), month(dt), datepart(quarter, dt), datepart(week, dt), datepart(weekday, dt), day(dt), datepart(dayofyear, dt)
		from day_tb	
		where dt not in (select dt from tb_date)				--exclude the date that does not exist in tb_date.
		option (maxrecursion 1000)								--<<<===== this proc can handle upto 1000 days.

	end

	if @is_debug = 1 
	begin
		select *
		from tb_date
		where dt between @start_dt and @end_dt
		order by dt
	end

	
	set nocount off


end
go
