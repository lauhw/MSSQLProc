if exists(select * from sys.objects where name = 'fn_from_sys_date')
	drop function fn_from_sys_date
go

create function fn_from_sys_date
(
	@dt_str as nvarchar(14)
)
returns datetime
begin

/*
9-may-12,lhw
-parse the date+time string and returns datetime type.

select 
	dbo.fn_from_sys_date('20120509174210'),
	dbo.fn_from_sys_date('20120509'),
	dbo.fn_from_sys_date('')
	--, dbo.fn_from_sys_date('12340234')
	

*/
	declare @result datetime,
		@dd nchar(2),
		@mm nchar(2),
		@yyyy nchar(4),
		@hh nchar(2),
		@minute nchar(2),
		@ss nchar(2)

	-- the value format is yyyymmddhhMMss
	if len(@dt_str) >= 8
	begin
		select 
			@yyyy = left(@dt_str, 4),
			@mm = substring(@dt_str, 5, 2),
			@dd = substring(@dt_str, 7, 2)
	end
	else
	begin
		-- min date.
		select 
			@yyyy = '1753',
			@mm = '01',
			@dd = '01'
	end

	if len(@dt_str) = 14
	begin	
		select
			@hh = substring(@dt_str, 9, 2),
			@minute = substring(@dt_str, 11, 2),
			@ss = substring(@dt_str, 13, 2)
	end
	else
	begin
		select 
			@hh = '00',
			@minute = '00',
			@ss = '00'
	end

	select @result = cast(@yyyy 
								+ '-' + @mm 
								+ '-' + @dd 
								+ ' ' + @hh
								+ ':' + @minute
								+ ':' + @ss
							as datetime)

	return @result
end

go
