if exists(select * from sys.objects where name = 'fn_fmt_date')
	drop function fn_fmt_date
go

create function fn_fmt_date (
	@dt datetime
)
returns nvarchar(255)
as
begin

/*
27-oct-12,lau@ciysys.com

select 
	dbo.fn_fmt_date(getdate()),
	dbo.fn_fmt_date('2010-12-31 23:44:55')


*/

	-- ==========================================================
	-- init
	-- ==========================================================
	declare
		@s nvarchar(255)

	-- ==========================================================
	-- process
	-- ==========================================================
	select @s = convert(nvarchar, @dt, 106)

	-- ==========================================================
	-- cleanup
	-- ==========================================================
	return @s

end
go
