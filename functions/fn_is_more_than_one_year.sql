if exists(select * from sys.objects where name = 'fn_is_more_than_one_year')
	drop function fn_is_more_than_one_year
go

create function fn_is_more_than_one_year (
	@dt1 datetime
	, @dt2 datetime
)
returns int
as
begin

/*
17-apr-14,lhw
- returns 1 if it is more than 365 days old (by comparing 'day' value instead of 'year').

sample code:

	select 		
		-- result: '0'
		dbo.fn_is_more_than_one_year('2013-07-25', '2014-07-16')
		-- result: '0'
		, dbo.fn_is_more_than_one_year('2013-07-16', '2014-07-16')
		-- result: '0'
		, dbo.fn_is_more_than_one_year('2015-07-16', '2014-07-16')
		-- result: '0'
		, dbo.fn_is_more_than_one_year('2014-07-15', '2014-07-16')
		
		-- result: '1'
		, dbo.fn_is_more_than_one_year('2013-07-15', '2014-07-16')
		-- result: '1'
		, dbo.fn_is_more_than_one_year('2013-07-14', '2014-07-16')

*/

	-- ==========================================================
	-- init
	-- ==========================================================
	declare
		@result int
		, @one_yr_old_dt datetime	
		
	-- ==========================================================
	-- process
	-- ==========================================================

	-- last year's yesterday
	set @one_yr_old_dt = dateadd(day, -1, dateadd(year, -1, @dt2))
	
	-- extract the date value only
	set @one_yr_old_dt = cast( 
								cast(year(@one_yr_old_dt) as nvarchar)
								+ '-' + right('0' + cast(month(@one_yr_old_dt) as nvarchar), 2)
								+ '-' + right('0' + cast(day(@one_yr_old_dt) as nvarchar), 2)
							as datetime)
							
	set @dt1 = cast( 
						cast(year(@dt1) as nvarchar)
						+ '-' + right('0' + cast(month(@dt1) as nvarchar), 2)
						+ '-' + right('0' + cast(day(@dt1) as nvarchar), 2)
					as datetime)
	
	if @dt1 <= @one_yr_old_dt
		set @result = 1
	else
		set @result = 0
	
	-- ==========================================================
	-- cleanup
	-- ==========================================================
	return @result

end
go
