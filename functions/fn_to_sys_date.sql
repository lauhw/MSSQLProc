if exists(select * from sys.objects where name = 'fn_to_sys_date')
	drop function fn_to_sys_date
go

create function fn_to_sys_date
(
	@dt as datetime
)
returns nvarchar(50)
begin

/*
9-may-12,lau@ciysys.com
-format the date value to human readable format.	

select dbo.fn_to_sys_date(getdate())

*/
	declare @result nvarchar(50)
	select @result = replace(convert(nvarchar,@dt,102), '.', '')
						+ replace(left(convert(nvarchar, @dt, 114), 8), ':', '')

	return @result
end

go
