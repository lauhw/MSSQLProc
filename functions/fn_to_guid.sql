
if exists(select * from sys.objects where name = 'fn_to_guid')
	drop function fn_to_guid

go

create function dbo.fn_to_guid (
	@s nvarchar(36)
)
returns uniqueidentifier
as
begin
/*
19-apr-13,lau@ciysys.com
-convert nvarchar to guid.

sample:

	select 
		dbo.fn_to_guid('2001-12-13 23:44:55' )
		, dbo.fn_to_guid(null)
		, dbo.fn_to_guid('DE3FA7E5-FC7D-4381-A51C-3F711CA5AB10')
		


*/

	declare 
		@result uniqueidentifier
		
	-- as long as the input length does not have 36 char, return empty guid.
	if len(isnull(@s, '')) <> 36
		set @result = cast(cast(0 as varbinary) as uniqueidentifier)
	else
		set @result = cast(@s as uniqueidentifier)
		
	return @result

end
go
