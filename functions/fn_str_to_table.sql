if exists (
	select *
	from sys.objects
	where name = 'fn_str_to_table'
)
begin
	drop function fn_str_to_table
end
go

create function fn_str_to_table
(
	@param nvarchar(max)
)
returns @tb table
		(
			col nvarchar(255)
		)
as
begin
/*
14-09-10,lau@ciysys.com
-this function will convert string to table

sample:

	select *
	from dbo.fn_str_to_table('1,2,3,4,5')
	
	select *
	from dbo.fn_str_to_table('aa,bb,cc,dd')


*/

	declare @s nvarchar(max),
			@delimeter nvarchar(1),
			@i int,
			@max_len int

	select @delimeter = ','

	select @param = replace(@param, ', ',',')

	select @max_len = len(isnull(@param, ''))

	if(@max_len>0)
	begin
		--get delimeter index
		select @i = charindex(@delimeter, @param)

		while(@max_len>0)
		begin
			if(@i>0)
			begin
				select @s = left(ltrim(rtrim(@param)), @i-1)
				select @param = right(ltrim(rtrim(@param)), @max_len - len(@s) - 1)
			end
			else
			begin
				--get the data from the param
				select @s = @param
				
				--set balance 
				select @param = ''
			end

			if(len(@s)>0)
			begin
				insert into @tb
				select @s
			end
				
			select @max_len = len(@param)

			--get delimeter index
			select @i = charindex(@delimeter, @param)	
		end
	end
	return
end

go
