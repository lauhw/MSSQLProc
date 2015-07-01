if exists(select * from sys.objects where name = 'fn_fmt_date_mth_yr')
	drop function fn_fmt_date_mth_yr
go

create function fn_fmt_date_mth_yr (
	@dt datetime
)
returns nvarchar(255)
as
begin

/*
27-oct-12,lhw

	
	select 
		dbo.fn_fmt_date_mth_yr(getdate()),
		dbo.fn_fmt_date_mth_yr('2010-12-31 23:44:55')

	--- sample output ---
	
		May.2014
		Dec.2010

*/

	-- ==========================================================
	-- init
	-- ==========================================================
	declare
		@s nvarchar(255)

	-- ==========================================================
	-- process
	-- ==========================================================
		
	set @s = replace(replace(convert(nvarchar, @dt, 106), ' ', '.'), right('0' + cast(day(@dt) as nvarchar), 2) + '.', '')

	-- ==========================================================
	-- cleanup
	-- ==========================================================
	return @s

end
go
