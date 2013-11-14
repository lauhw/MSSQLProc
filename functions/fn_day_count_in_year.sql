if exists(select * from sys.objects where name = 'fn_day_count_in_year')
	drop function fn_day_count_in_year
go

create function fn_day_count_in_year (
	@yr int
)
returns int
as
begin

/*
4-sep-13,lau@ciysys.com
- returns the number of days in the given year.

	select 
		dbo.fn_day_count_in_year(2011)
		, dbo.fn_day_count_in_year(2012)


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
	
	set @dt = cast(@yr as nvarchar)
				+ '-01-01'
	
	select @i = datediff(day
							, @dt
							, dateadd(year, 1, @dt) - 1
						)	
				+ 1			--include the first day in the date range.

	-- ==========================================================
	-- cleanup
	-- ==========================================================
	return @i

end
go
