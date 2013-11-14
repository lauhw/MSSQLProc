if exists(select * from sys.objects where name = 'fn_day_count_in_month')
	drop function fn_day_count_in_month
go

create function fn_day_count_in_month (
	@yr int
	, @mth int
)
returns int
as
begin

/*
4-sep-13,lau@ciysys.com
- returns the number of days in the given month.

	select 
		dbo.fn_day_count_in_month(2012, 2)
		, dbo.fn_day_count_in_month(2012, 1)


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
				+'-'
				+ right('0'+cast(@mth as nvarchar), 2) 
				+ '-01'
	
	select @i = datediff(day
							, @dt
							, dateadd(month, 1, @dt) - 1
						)	
				+ 1			--include the first day in the month.

	-- ==========================================================
	-- cleanup
	-- ==========================================================
	return @i

end
go
