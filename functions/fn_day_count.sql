if exists(select * from sys.objects where name = 'fn_day_count')
	drop function fn_day_count
go

create function fn_day_count (
	@dt1 datetime
	, @dt2 datetime
)
returns int
as
begin

/*
30-jul-13,lau@ciysys.com 

select 
	dbo.fn_day_count('2010-12-31', '2010-12-01')


*/

	-- ==========================================================
	-- init
	-- ==========================================================
	declare
		@i int

	-- ==========================================================
	-- process
	-- ==========================================================
	select @i = abs(datediff(day, @dt1, @dt2)) + 1

	-- ==========================================================
	-- cleanup
	-- ==========================================================
	return @i

end
go
