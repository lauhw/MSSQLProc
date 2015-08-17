
if exists(
	select *
	from sys.objects
	where name = 'fn_fmt_yesno'
)
begin
	drop function fn_fmt_yesno
end
go

create function fn_fmt_yesno (
	@value int
)
returns nvarchar(3)
begin

/*
1-aug-15,lhw
- returns 'yes' if the @value is '1'. Otherwise, return 'no'.

	select 
		dbo.fn_fmt_yesno(1)
		, dbo.fn_fmt_yesno(0)
		, dbo.fn_fmt_yesno(1234560)

result:

	123456.79

*/

	declare
		@s nvarchar(3)

	if @value = 1
		set @s = 'Yes'
	else 
		set @s = 'No'

	return @s

end
go
