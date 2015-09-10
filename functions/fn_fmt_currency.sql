

if exists(
	select *
	from sys.objects
	where name = 'fn_fmt_currency'
)
begin
	drop function fn_fmt_currency
end
go

create function fn_fmt_currency (
	@value numeric(20, 8)
	, @no_of_digit int
)
returns nvarchar(50)
begin

/*
1-aug-15,lhw
- returns the formatted currency in string.

	select 
		dbo.fn_fmt_currency(123456.7890, 2)
		, dbo.fn_fmt_currency(123456.7890, 8)
		, dbo.fn_fmt_currency(123456, 0)
		, dbo.fn_fmt_currency(5, 0)
		, dbo.fn_fmt_currency(5, 3)
		, dbo.fn_fmt_currency(123456, -3)
		, dbo.fn_fmt_currency(2143422345.6897234, 6)
		, dbo.fn_fmt_currency(2143422345.6897234, 8)
		, dbo.fn_fmt_currency(2143422345.6897234, 10)

result:

	123456.79

*/

	declare
		@s nvarchar(50)
		, @int nvarchar(50)
		, @dec nvarchar(50)
		, @pos int
			
	set @s = cast(@value as nvarchar)
	
	-- extract the integer 
	set @int = left(@s, charindex('.', @s) - 1)

	-- see if there is any need to adding ',' symbol
	if len(@int) > 3
	begin
		set @int = convert(nvarchar(50), cast(@int as money), 1)
		set @int = left(@int, charindex('.', @int) -1)
	end
	
	if @no_of_digit > 0
	begin
		-- extract the decimal points that is asking for.
		set @dec = substring(@s, charindex('.', @s) + 1, len(@s) - charindex('.', @s) )		
		set @dec = left(@dec, @no_of_digit)

		set @s = @int 
				+ '.' 
				+ @dec
	end
	else 
	begin
		-- if @no_of_digit <= 0
		set @s = @int
	end

	return @s

end
go
