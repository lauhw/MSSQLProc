if exists(select * from sys.objects where name = 'fn_count_day_occurrence')
	drop function fn_count_day_occurrence
go

create function fn_count_day_occurrence (
	@start_dt datetime
	, @end_dt datetime
	, @day int
	
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
		dbo.fn_count_day_occurrence('2013-01-01', '2013-12-31', 30)
		


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
			select @start_dt as dt, day(@start_dt) as dy
			union all
			select dt + 1, day(dt + 1)
			from all_dates
			where dt < @end_dt
		)
		select 
			
			@i = count(*)
			
		from all_dates
		
		where
			dy = @day
			
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
