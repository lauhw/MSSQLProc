
if exists(select * from sys.objects where name = 'fn_fmt_value')
	drop function fn_fmt_value
go

create function fn_fmt_value (
	@value nvarchar(255)		--this field accept date/time & float data type.
	, @fmt varchar(5)
)
returns nvarchar(50)
as
begin

/*
3-aug-15,lhw
- format the date/time value into proper format.

sample:

	select 
		dbo.fn_fmt_value('2010-12-31 23:44:55', 'd') 'd'
		, dbo.fn_fmt_value('2010-12-30 23:44:55', 'dd') 'dd'
		, dbo.fn_fmt_value('2010-12-29 23:44:55', 't') 't'
		, dbo.fn_fmt_value('2010-12-28 23:44:55', 'dt') 'dt'
		, dbo.fn_fmt_value('2010-12-27 23:44:55', 'ddt') 'ddt'

		-- 2 digit year
		, dbo.fn_fmt_value('2010-12-31 23:44:55', 'd2') 'd2'
		, dbo.fn_fmt_value('2010-12-30 23:44:55', 'dd2') 'dd2'
		--, dbo.fn_fmt_value('2010-12-29 23:44:55', 't2') 't2'
		, dbo.fn_fmt_value('2010-12-28 23:44:55', 'dt2') 'dt2'
		, dbo.fn_fmt_value('2010-12-27 23:44:55', 'ddt2') 'ddt2'

		, dbo.fn_fmt_value(12345.6897234, 'm') 'm'
		, dbo.fn_fmt_value(12345.6897234, 'm4') 'm4'
		, dbo.fn_fmt_value(2143422345.6897234, 'm6') 'm6'
		, dbo.fn_fmt_value(2143422345.6897234, 'm8') 'm8'

*/

	-- ==========================================================
	-- init
	-- ==========================================================
	declare
		@s nvarchar(50)
		, @short_yr int
		, @dt datetime
		, @decimal_value numeric(20, 8)
		, @no_of_digit int

	-- ==========================================================
	-- process
	-- ==========================================================

	if len(isnull(@fmt, '')) = 0
	begin
		if isnumeric(@value) = 1
		begin
			set @fmt = 'm'
		end
		else 
		begin		
			set @fmt = 'd'
		end
	end

	if left(@fmt, 1) in ('d', 't')			--date or time
	and charindex('2', @fmt) > 0			--request to show 2 digit year
	begin
		set @short_yr = 100
		set @fmt = left(@fmt, len(@fmt) - 1)
	end
	else 
	begin
		set @short_yr = 0
	end

	-- --------------------------------------------------------------
	if left(@fmt, 1) = 'm'
	begin
		--date only.
		set @decimal_value = cast(@value as numeric(20, 8))

		if len(@fmt) > 1
			set @no_of_digit = cast(substring(@fmt, 2, len(@fmt)-1) as int)
		else
			set @no_of_digit = 2		--default is 2 digit

		set @s = dbo.fn_fmt_currency(@decimal_value, @no_of_digit)
	end
	-- --------------------------------------------------------------
	else if @fmt = 'd'
	begin
		--date only.
		set @dt = cast(@value as datetime)
		set @s = replace(convert(nvarchar, @dt, 106 - @short_yr), ' ', '.')
	end
	else if @fmt = 'dd'
	begin
		--proper date
		set @dt = cast(@value as datetime)
		set @s = replace(convert(nvarchar, @dt, 106 - @short_yr), ' ', '.')
					+ ', '
					+ left(datename(dw, getdate()), 3)
	end	
	else if @fmt = 't'
	begin
		--time only
		set @dt = cast(@value as datetime)
		set @s = convert(nvarchar, @dt, 108)
	end
	else if @fmt = 'dt'
	begin
		--date + time.
		set @dt = cast(@value as datetime)
		set @s = replace(convert(nvarchar, @dt, 106 - @short_yr), ' ', '.')
				+ ' @ '
				+ convert(nvarchar, @dt, 108)

	end
	else if @fmt = 'ddt'
	begin
		--proper date + time.
		set @dt = cast(@value as datetime)
		set @s = replace(convert(nvarchar, @dt, 106 - @short_yr), ' ', '.')
					+ ', '
					+ left(datename(dw, getdate()), 3)
					+ ' @ '
					+ convert(nvarchar, @dt, 108)

	end


	-- ==========================================================
	-- cleanup
	-- ==========================================================
	return @s

end
go
