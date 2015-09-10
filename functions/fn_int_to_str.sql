

if exists(
	select *
	from sys.objects
	where name = 'fn_int_to_str'
)
begin
	drop function fn_int_to_str
end
go

create function fn_int_to_str (
	@value int
)
returns nvarchar(50)
begin

/*
1-aug-15,lhw
- convert @value from int type to nvarchar type

	select 
		dbo.fn_int_to_str(12341231)
		, dbo.fn_int_to_str(-0123)

result:

	123456.79

*/

	declare
		@s nvarchar(50)

	set @s = cast(@value as nvarchar)

	return @s

end
go
