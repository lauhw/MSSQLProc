
if exists(select * from sys.objects where name = 'fn_is_valid_time')
	drop function fn_is_valid_time
go

create function fn_is_valid_time (	
	-- accept bigger size (> 5) so that the value will not be truncated automatically
	-- which cause the result to be Ok. For example, '23:55:66' should returns '0'.
	@time nvarchar(255)	
)
returns int
as
begin

/*
27-aug-15,lhw
- returns '1' if the value is in HH:MM format.

sample:

	select 
		dbo.fn_is_valid_time('23:44:55')	'23:44:55-FAILED'
		, dbo.fn_is_valid_time('ab:cd')		'ab:cd-FAILED'
		, dbo.fn_is_valid_time('23:55')		'23:55-OK'
		, dbo.fn_is_valid_time('23:65')		'23:65-FAILED'
		, dbo.fn_is_valid_time('1:65')		'1:65-FAILED'
		, dbo.fn_is_valid_time('1:5')		'1:5-FAILED'
		, dbo.fn_is_valid_time('2355')		'2355-OK'
		, dbo.fn_is_valid_time('2365')		'2365-FAILED'
		, dbo.fn_is_valid_time('255')		'255-FAILED'
		


*/

	-- ==========================================================
	-- init
	-- ==========================================================
	declare
		@result int
		, @continue int
		, @s1 nvarchar(2)
		, @s2 nvarchar(2)

	set @result = 0

	-- ==========================================================
	-- process
	-- ==========================================================

	
	if len(@time) in (4,5)
	begin
		
		set @continue = 0
		if len(@time) = 5
		begin
			set @s1 = charindex(':', @time)		-- the separator
			if @s1 = 3
			begin
				set @continue = 1
			end
		end
		else
		begin
			set @continue = 1
		end

		-- ---------------------------------------------
		if @continue = 1
		begin
			set @s1 = left(@time, 2)
			set @s2 = right(@time, 2)

			if isnumeric(@s1) = 1
			and isnumeric(@s2) = 1
			and cast(@s1 as int) < 24		--within 0 to 23 hours
			and cast(@s2 as int) < 60		--within 0 to 59 hours
			begin			
				set @result = 1
			end
		end
				
	end
	
	-- ==========================================================
	-- cleanup
	-- ==========================================================

	return @result

end
go
