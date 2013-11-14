if exists(
	select *
	from sys.objects
	where
		name = 'fn_proper_concate'
)
begin
	drop function fn_proper_concate
end
go

create function dbo.fn_proper_concate (
	@s nvarchar(max)
)
returns nvarchar(max)
as
begin

/*

19-feb-13,lau@ciysys.com
-this function replace the last comma with '&' symbol so that it is friendly-text.

select 
	dbo.fn_proper_concate('a11, b22, c33')
	, dbo.fn_proper_concate('a11, b22')
	, dbo.fn_proper_concate('a11')
	, dbo.fn_proper_concate('')

*/	
	if @s is null
	begin
		set @s = ''
	end
	else
	begin
		set @s = 
			case when charindex(  ' ,', reverse( @s)) > 0
			then	
				reverse(right(reverse(@s), len(@s) - charindex(  ' ,', reverse( @s)) -1 ))	
				+ 
				' & '
				+ reverse(left(reverse(@s), charindex(  ' ,', reverse( @s)) - 1))
			else
				@s
			end
	end
	
	return @s
end
go

