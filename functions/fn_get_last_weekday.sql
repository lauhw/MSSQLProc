if exists(select * from sys.objects where name = 'fn_get_last_weekday')
	drop function fn_get_last_weekday
go

create function fn_get_last_weekday (
	@start_dt datetime
	, @end_dt datetime
	
	--1-sunday, 7-saturday
	, @search_for_dow int
	, @before_date datetime	
)
returns datetime
as
begin

/*
3-dec-13,lhw
- returs the date of the last 'weekday' in the period.


sample code:

	select 
		-- the date for last friday
		dbo.fn_get_last_weekday('2013-01-01', '2013-01-31', 6, null)
		
		--the date for last second friday.
		, dbo.fn_get_last_weekday('2013-01-01', 
									'2013-01-31', 
									6, 		
									dbo.fn_get_last_weekday('2013-01-01', '2013-01-31', 6,null))
		
		


*/

	-- ==========================================================
	-- init
	-- ==========================================================
	declare
		@i datetime
		, @dt datetime
		
	-- ==========================================================
	-- process
	-- ==========================================================
	
	-- ensure that the date is valid.
	if @start_dt > '1970-01-01'
		and @end_dt > '1970-01-01'
	begin

		;with all_dates as
		(
			select @start_dt as dt, datepart(weekday, @start_dt) as wk
			union all
			select dt + 1, datepart(weekday, dt + 1) 
			from all_dates
			where dt < @end_dt
		)
		select top 1
			
			@i = dt
		from all_dates
		
		where
			wk = @search_for_dow
			and (@before_date is null 
					or dt < @before_date
				)
			
		order by
			dt desc
		
	end
	else
	begin
	
		set @i = 0
		
	end

	-- ==========================================================
	-- cleanup
	-- ==========================================================
	return @i

end
go
