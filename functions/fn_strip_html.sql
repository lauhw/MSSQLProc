if exists(
	select *
	from sys.objects
	where name = 'fn_stripHtml'
)
begin
	drop function fn_stripHtml
end
go

create function fn_stripHtml (
	@HTMLText nvarchar(max)
)
returns nvarchar(max)
as
begin

/*

reference:
- http://forums.asp.net/t/1466145.aspx/1

*/

	declare
		@Start int
		, @end int
		, @Length int
	
	--remove style section
	set @Start = charindex('<style>',@HTMLText)
	set @end = (len('</style>')-1)+charindex('</style>',@HTMLText,charindex('<style>',@HTMLText))
	set @Length = (@end - @Start) + 1
	
	while @Start > 0 AND @end > 0 AND @Length > 0
	begin
		set @HTMLText = stuff(@HTMLText,@Start,@Length,'')
		set @Start = charindex('<style>',@HTMLText)
		set @end = (len('</style>')-1) + charindex('</style>',@HTMLText,charindex('<style>',@HTMLText))
		set @Length = (@end - @Start) + 1
	end

	--remove script section
	set @Start = charindex('<script',@HTMLText)
	set @end = (len('</script>')-1)+charindex('</script>',@HTMLText,charindex('<script',@HTMLText))
	set @Length = (@end - @Start) + 1
	
	while @Start > 0 AND @end > 0 AND @Length > 0
	begin
		set @HTMLText = stuff(@HTMLText,@Start,@Length,'')
		set @Start = charindex('<script',@HTMLText)
		set @end = (len('</script>')-1) + charindex('</script>',@HTMLText,charindex('<script',@HTMLText))
		set @Length = (@end - @Start) + 1
	end

	-- strip the html tags.
	set @Start = charindex('<',@HTMLText)
	set @end = charindex('>',@HTMLText,charindex('<',@HTMLText))
	set @Length = (@end - @Start) + 1
	while @Start > 0 AND @end > 0 AND @Length > 0
	
	begin
		set @HTMLText = stuff(@HTMLText,@Start,@Length,'')
		set @Start = charindex('<',@HTMLText)
		set @end = charindex('>',@HTMLText,charindex('<',@HTMLText))
		set @Length = (@end - @Start) + 1
	end

	set @HTMLText = replace(@HTMLText,' ',' ')

	--decode the symbols.
	set @HTMLText = replace(@HTMLText, '&quot;', '"')
	set @HTMLText = replace(@HTMLText, '&amp;', '&')
	set @HTMLText = replace(@HTMLText, '&lt;', '<')
	set @HTMLText = replace(@HTMLText, '&gt;', '>')
	
	return ltrim(rtrim(@HTMLText))
	
end
go
