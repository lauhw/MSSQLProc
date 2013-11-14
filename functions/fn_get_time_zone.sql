/*

16-11-10,lau@ciysys.com
-returns the time zone for the given date/time.

sample:

	select dbo.fn_get_time_zone (getdate())

*/

if exists(select * from sys.objects where name= 'fn_get_time_zone')
	drop function fn_get_time_zone
go


create function dbo.fn_get_time_zone ( 
	@dt datetime 
)
returns varchar(9)
as
begin

	declare @result varchar(9)

	select  @result = cast(datepart(hour, @dt) as varchar) + '00-'
					+ cast(datepart(hour, @dt) as varchar) + '59'

	return @result

end
go
