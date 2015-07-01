if exists(select * from sys.objects where name = 'fn_month_end')
	drop function fn_month_end
go

create function fn_month_end (
	@dt datetime
)
returns datetime
as
begin

/*
17-apr-14,lhw
- returns the last day date of the month.

sample code:

	select 		
		dbo.fn_month_end('2014-07-25')

*/

	-- ==========================================================
	-- init
	-- ==========================================================
	declare
		@result datetime
		
	-- ==========================================================
	-- process
	-- ==========================================================

	set @result = dbo.fn_month_start(@dt)
	set @result = dateadd(day, -1, dateadd(month, 1, @result))
						
	
	-- ==========================================================
	-- cleanup
	-- ==========================================================
	return @result

end
go
