
if exists(
	select * 
	from sys.objects
	where name = 'fn_calc_rounding_adj'
)
begin
	drop function fn_calc_rounding_adj
end
go

create function fn_calc_rounding_adj (
	@value money
)
returns money
as
begin
/*
10-sep-15,lhw
- returns rounding adjustment for the total amount (base on Malaysia law).

sample:

	select 
		dbo.fn_calc_rounding_adj(1234.50)'1234.50'
		,dbo.fn_calc_rounding_adj(1234.51)'1234.51'
		,dbo.fn_calc_rounding_adj(1234.52)'1234.52'
		,dbo.fn_calc_rounding_adj(1234.53)'1234.53'
		,dbo.fn_calc_rounding_adj(1234.54)'1234.54'
		,dbo.fn_calc_rounding_adj(1234.55)'1234.55'
		,dbo.fn_calc_rounding_adj(1234.56)'1234.56'
		,dbo.fn_calc_rounding_adj(1234.57)'1234.57'
		,dbo.fn_calc_rounding_adj(1234.58)'1234.58'
		,dbo.fn_calc_rounding_adj(1234.59)'1234.59'

*/	

	declare 
		@ch char(1)
		, @i int
	
		, @result money

	set @ch = right(cast(@value as varchar), 1)
	set @i = cast(@ch as int)

	-- no adjustment.
	if ((@i = 0)
		or (@i = 5))
	begin
		set @result = 0
	end
	else
	begin

		if ((@i = 1)
			or (@i = 6))
		begin
			set @result  = -0.01
		end
		else if ((@i = 2)
			or (@i = 7))
		begin
			set @result  = -0.02
		end
		else if ((@i = 3)
			or (@i = 8))
		begin
			set @result  = 0.02
		end
		else if ((@i = 4)
			or (@i = 9))
		begin
			set @result = 0.01
		end

	end
		
	return @result

end
go
