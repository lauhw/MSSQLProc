if exists(select * from sys.objects where name = 'fn_count_weekday')
	drop function fn_count_weekday
go

create function fn_count_weekday (
	@start_dt datetime
	, @end_dt datetime
	, @count_for_dow int
	
)
returns int
as
begin

/*
4-sep-13,lau@ciysys.com
- returs the weekday occurence within the given date range.

Reference:

   http://stackoverflow.com/questions/6684577/get-number-of-weekdays-sundays-mondays-tuesdays-between-two-dates-sql

sample code:

	select 
		dbo.fn_count_weekday('2013-01-01', '2013-01-31', 1)
		, dbo.fn_count_weekday('2013-03-01', '2013-03-31', 6)
		


*/

	-- ==========================================================
	-- init
	-- ==========================================================
	declare
		@i int
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
		select 
			
			@i = count(*)
		from all_dates
		
		where
			wk = @count_for_dow
			
		option (maxrecursion 0)
		
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
