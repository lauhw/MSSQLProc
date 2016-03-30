if exists(
	select *
	from sys.objects
	where name = 'fn_cal_working_year'
)
begin

	drop function fn_cal_working_year
	
end
go

create function fn_cal_working_year (
	@dt1 datetime
	, @dt2 datetime
) 
returns numeric(10,2)
begin	

/*
18-jul-14,lhw
-returns the number of years working in a organization. The number of year based on the '@dt1'

9-may-15,lhw- bug fixed
28-jan-16,lhw-bug fixed

select 
	dbo.fn_cal_working_year('2013-07-18', '2016-07-16')
	, dbo.fn_cal_working_year('2011-01-01', '2013-12-31')
	, dbo.fn_cal_working_year('2011-07-01', '2011-12-31')
	, dbo.fn_cal_working_year('2011-07-01', '2013-12-31')
	
	, dbo.fn_cal_working_year('2012-03-01', '2012-01-31') as jan2012
	, dbo.fn_cal_working_year('2012-03-01', '2012-02-28')
	, dbo.fn_cal_working_year('2012-03-01', '2012-03-31')
	, dbo.fn_cal_working_year('2012-03-01', '2012-04-30')
	, dbo.fn_cal_working_year('2012-03-01', '2012-05-31')
	, dbo.fn_cal_working_year('2012-03-01', '2012-06-30')
	, dbo.fn_cal_working_year('2012-03-01', '2012-07-31')
	, dbo.fn_cal_working_year('2012-03-01', '2012-08-31')
	, dbo.fn_cal_working_year('2012-03-01', '2012-09-30')
	, dbo.fn_cal_working_year('2012-03-01', '2012-10-31')
	, dbo.fn_cal_working_year('2012-03-01', '2012-11-30')
	, dbo.fn_cal_working_year('2012-03-01', '2012-12-31')as dec2012	
	
	, dbo.fn_cal_working_year('2012-03-01', '2013-01-31')
	, dbo.fn_cal_working_year('2012-03-01', '2013-02-28')as firstyr
	, dbo.fn_cal_working_year('2012-03-01', '2013-03-31')
	, dbo.fn_cal_working_year('2012-03-01', '2013-04-30')
	
*/


	-- ==========================================================
	-- init
	-- ==========================================================
	declare
		@result numeric(10,2)
		, @one_yr_old_dt datetime
		, @days_to_dt2 numeric(10,2)
		, @total_days_in_yr numeric(10,2)		
		, @yr_start datetime
		, @dt0 datetime
		
	-- ==========================================================
	-- process
	-- ==========================================================

	-- last year's yesterday
	set @one_yr_old_dt = dateadd(day, -1, dateadd(year, 1, @dt1))
	
	-- extract the date value only
	set @one_yr_old_dt = cast( 
								cast(year(@one_yr_old_dt) as nvarchar)
								+ '-' + right('0' + cast(month(@one_yr_old_dt) as nvarchar), 2)
								+ '-' + right('0' + cast(day(@one_yr_old_dt) as nvarchar), 2)
							as datetime)
							
	set @dt1 = cast( 
						cast(year(@dt1) as nvarchar)
						+ '-' + right('0' + cast(month(@dt1) as nvarchar), 2)
						+ '-' + right('0' + cast(day(@dt1) as nvarchar), 2)
					as datetime)
	
	set @result = 0

	while @one_yr_old_dt <= @dt2
	begin		
			
		-- ------------------------------
		-- advance to next year
		-- ------------------------------
		
		set @result = @result + 1
		
		-- last year's yesterday
		set @one_yr_old_dt = dateadd(year, 1, @one_yr_old_dt)
		
		if @one_yr_old_dt > @dt2
		begin
			break
		end
	end
	
	-- calc the fraction of days
	if @one_yr_old_dt > @dt2 
	begin
		
		set @dt0 = dateadd(day, 1, dateadd(year, -1, @one_yr_old_dt))

		--28-jan-16,lhw-ensure that the date value does not goes off the end date.
		if @dt0 < @dt2
		begin
			--14-jan-16,lhw-should count from next day after year end.
			set @days_to_dt2 = dbo.fn_day_count(@dt0, @dt2)
			set @total_days_in_yr = dbo.fn_day_count(@dt0, @one_yr_old_dt)
						
			set @result = @result + (@days_to_dt2 / @total_days_in_yr)

		end
	end
	
	return @result
end
go
