if exists(select * from sys.objects where name = 'fn_duration')
	drop function fn_duration

go

create function dbo.fn_duration (
	@dt datetime
)
returns nvarchar(255)
as
begin
/*
9-jan-13,lau@ciysys.com
-the duration since '@dt'.

sample:

	select 
		top 100 dbo.fn_duration( created_on), created_on
	from tb_profile
	order by created_on desc
	
	select 
		dbo.fn_duration('2001-12-13 23:44:55' ),
		dbo.fn_duration('2010-12-13 23:44:55' ),
		dbo.fn_duration('2012-12-13 23:44:55' ),
		dbo.fn_duration( dateadd(hour,-4, getdate()) ),
		dbo.fn_duration( dateadd(minute,-2, getdate()) ),
		dbo.fn_duration( getdate() )	


*/
	declare 
		@i int
		, @result nvarchar(50)

	
	select 
		@i = datediff(day, @dt, getdate())
		, @result = ''
	
	if @i <= 1
	begin
		select @i = datediff(hour, @dt, getdate())
		if @i <= 1 
		begin
			select @i = datediff(minute, @dt, getdate())
			
			if @i <= 1
				select @result = 'Less than a minute ago'
			else
				select @result = cast(@i as nvarchar) + ' minutes ago'
		end
		else
			select @result = cast(@i as nvarchar) + ' hours ago'
	end
	else if @i <= 30
	begin
		select @result = cast(@i as nvarchar) + ' days ago'
	end
	else
	begin
		select @i = datediff(month, @dt, getdate())
		if @i < 12
		begin
			if @i = 1
				select @result = cast(@i as nvarchar) + ' month ago'
			else
				select @result = cast(@i as nvarchar) + ' months ago'
		end
		else 
		begin
			select @i = datediff(year, @dt, getdate())
			if @i = 1
				select @result = cast(@i as nvarchar) + ' year ago'
			else if @i > 2 
				select @result = convert(nvarchar, @dt, 106)
								 + ' @ '
								 + convert(nvarchar, getdate(), 108)
			else
				select @result = cast(@i as nvarchar) + ' years ago'
		end
	end
	
	return @result

end
go
