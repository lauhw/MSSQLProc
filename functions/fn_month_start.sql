if exists(select * from sys.objects where name = 'fn_month_start')
	drop function fn_month_start
go

create function fn_month_start (
	@dt datetime
)
returns datetime
as
begin

/*
17-apr-14,lhw
- returns the first day of the month.

sample code:

	select 		
		dbo.fn_month_start('2014-07-25')

*/

	-- ==========================================================
	-- init
	-- ==========================================================
	declare
		@result datetime
		
	-- ==========================================================
	-- process
	-- ==========================================================

	set @result = cast(cast(year(@dt) as nvarchar) 
						+ '-' 
						+ right('0' + cast(month(@dt) as nvarchar), 2)
						+ '-01'
						as datetime)
						
	
	-- ==========================================================
	-- cleanup
	-- ==========================================================
	return @result

end
go
