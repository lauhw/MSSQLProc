if exists(select * from sys.objects where name = 'fn_to_date')
	drop function fn_to_date
go

create function fn_to_date
(
	@dt as datetime
)
returns datetime
begin

/*
5-june-12,lau@ciysys.com
-extract the date value without the time value.

	select dbo.fn_to_date(getdate())

*/

	declare @result nvarchar(50)
	select @result = cast(convert(nvarchar,@dt,102) as datetime)
	return @result
	
end

go
