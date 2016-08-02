if exists(select * from sys.objects where name = 'fn_get_age')
	drop function fn_get_age
go

create function fn_get_age (
	@dob datetime
	-- this param is optional. 
	, @now datetime = null
)
returns numeric(10,2)
as
begin

/*
20-dec-13,lhw
- returs the age.

9-jun-16,lhw
- only increase the age after the day+month of birth.

sample code:

	select 		
		dbo.fn_get_age('1997-06-05', '2015-06-04') expected_17
		, dbo.fn_get_age('1997-06-05', '2015-06-05') expected_18_on_birth_day
		, dbo.fn_get_age('1997-06-05', '2015-06-06')  expected_18_after_birth_day

		, dbo.fn_get_age('1998-06-05', '2015-06-03') b4_birth_day_mth_16
		, dbo.fn_get_age('1998-06-05', '2015-06-04') b4_birth_day_mth_16
		, dbo.fn_get_age('1998-06-05', '2015-06-05') on_birth_day_mth_17
		, dbo.fn_get_age('1998-06-05', '2015-06-06') after_birth_day_mth_17
		
		
		


*/
	-- ==========================================================
	-- init
	-- ==========================================================
	declare
		@result numeric(10,2)
		, @one_yr_old_dt datetime
		, @days_to_dt2 numeric(10,2)
		
	if @now is null
		set @now = getdate()
		
	-- ==========================================================
	-- process
	-- ==========================================================

	-- last year's yesterday
	set @one_yr_old_dt = dateadd(day, -1, dateadd(year, 1, @dob))
	
	-- extract the date value only
	set @one_yr_old_dt = cast( 
								cast(year(@one_yr_old_dt) as nvarchar)
								+ '-' + right('0' + cast(month(@one_yr_old_dt) as nvarchar), 2)
								+ '-' + right('0' + cast(day(@one_yr_old_dt) as nvarchar), 2)
							as datetime)
							
	set @dob = cast( 
						cast(year(@dob) as nvarchar)
						+ '-' + right('0' + cast(month(@dob) as nvarchar), 2)
						+ '-' + right('0' + cast(day(@dob) as nvarchar), 2)
					as datetime)
	
	set @result = 0
	
	while @one_yr_old_dt <= @now
	begin		
			
		-- ------------------------------
		-- advance to next year
		-- ------------------------------
		
		set @result = @result + 1
		
		-- last year's yesterday
		set @one_yr_old_dt = dateadd(year, 1, @one_yr_old_dt)
		
		if @one_yr_old_dt > @now
		begin
			break
		end
	end
	
	-- remove the fraction of days
	if @one_yr_old_dt > @now 
	begin
		
		set @days_to_dt2 = dbo.fn_day_count(dateadd(year, -1, @one_yr_old_dt) , @now) -1

		if @days_to_dt2 = 0
		begin
			set @result = @result - 1
		end
			
	end		
	
	return @result
end
go

