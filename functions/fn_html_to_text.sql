

if object_id('fn_html_to_text') is not null
	drop function dbo.fn_html_to_text 

go

create function dbo.fn_html_to_text (
	@string nvarchar(max)
) 
returns nvarchar(max)
as
begin
/*
12-jul-16,lhw
- This function extract the text by removing the html tags.
- This function consumes more CPU but lesser the reads as compared to fn_html_to_text_table().

reference:
http://sqlmag.com/t-sql/pull-out-text-html-code
http://lazycoders.blogspot.my/2007/06/stripping-html-from-text-in-sql-server.html

*/
	declare
		@result nvarchar(max)
		, @is_text nchar(1)
		, @char nchar(1)
		, @len int
		, @count int

	set @count = 0
	set @result = ''
	set @string = '>' + @string + '<'		
	set @string = replace(replace(replace(replace(replace(@string, '<br>', char(13) + char(10)), '<br/>', char(13) + char(10)), '<br />', char(13) + char(10)), '&nbsp;',' '), '&amp;', '&')

	set @len = len(@string)

	while (@count <= @len)
	begin

		set @char = substring(@string,@count,1)

		if (@char = '>')
		begin 
			set @is_text = 1
		end
		else if (@char = '<')
		begin
			set @is_text = 0
		end
		else if (@is_text = 1)	
		begin
			set @result = @result + @char
		end
	
		set @count = @count + 1
	
	end

	set @result = replace(replace(@result, '&gt;', '>'), '&lt;', '<')

	return @result
end
go
