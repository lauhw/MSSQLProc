if exists(select * from sys.objects where name = 'fn_empty_guid')
	drop function fn_empty_guid

go

create function dbo.fn_empty_guid ()
returns uniqueidentifier
as
begin
/*
7-apr-13,lau@ciysys.com


sample:
	
	select 
		dbo.fn_empty_guid()
	

*/
	declare 
		@result uniqueidentifier

	set @result = cast(cast(0 as varbinary) as uniqueidentifier)
	
	return @result
	
end
go
