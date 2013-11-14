if exists(select * from sys.objects where name = 'fn_date_sql')
	drop function fn_date_sql
go

create function fn_date_sql (
	@dt datetime
)
returns nvarchar(20)
as
begin

/*
4-sep-13,lau@ciysys.com
- convert the date value into sql compatible value (for generating SQL statement).
  This is useful if you are executing dynamic SQL statement in stored proc.

sample code:

	select 
		dbo.fn_date_sql('2013-01-01')
		, cast(dbo.fn_date_sql(getdate()) as datetime)
		


*/

	-- ==========================================================
	-- init
	-- ==========================================================
	declare 
		@result nvarchar(50)
		
		
	-- ==========================================================
	-- process
	-- ==========================================================		
	select @result = convert(nvarchar,@dt,102)
						+ ' '
						+ left(convert(nvarchar, @dt, 114), 8)

	-- ==========================================================
	-- cleanup
	-- ==========================================================
	return @result

end
go
