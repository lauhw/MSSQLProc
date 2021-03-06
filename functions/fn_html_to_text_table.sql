

if object_id('fn_html_to_text_table') is not null
	drop function dbo.fn_html_to_text_table

go

create function dbo.fn_html_to_text_table(
	@string nvarchar(max)
) 
returns @tb table (
	seq int identity(1,1)
	, string nvarchar(max)
)
as
begin
/*
12-jul-16,lhw
- This function extract the text by removing the html tags and stores each text section as a row.
- This function consumes lesser CPU but increased the reads as compare to fn_html_to_text().

reference:
http://sqlmag.com/t-sql/pull-out-text-html-code
http://lazycoders.blogspot.my/2007/06/stripping-html-from-text-in-sql-server.html

*/
	declare
		@result nvarchar(255)
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

			if len(rtrim(@result)) > 0
			and rtrim(@result) <> char(13) + char(10)
			begin
				set @result = replace(replace(@result, '&gt;', '>'), '&lt;', '<')

				insert into @tb (string)
				values (ltrim(rtrim(@result)))

				set @result = ''
			end

		end
		else if (@is_text = 1)	
		begin
			set @result = @result + @char
		end
	
		set @count = @count + 1
	
	end

	return
end
go
