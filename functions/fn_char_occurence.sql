if exists (
	select *
	from sys.objects
	where name = 'fn_char_occurence'
)
begin
	drop function fn_char_occurence
end
go

create function fn_char_occurence
(
	@s nvarchar(max)
	, @char nvarchar(50)
)
returns int
as
begin
/*
20-jan-14,lhw
-this function returns the number of character occurence.

sample:

	select dbo.fn_char_occurence('1,2,3,4,5', ',')	
	--returns '4' (ie, 4 commas)
	
*/

	declare
		@i int
		
	select 
		@i = len(@s) - len(replace(@s, @char, ''))

	return @i
	
end

go
