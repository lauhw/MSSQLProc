
if exists(
	select *
	from sys.objects
	where name = 'fn_has_changes'
)
begin
	drop function fn_has_changes
end
go

create function fn_has_changes (
	@msg nvarchar(255)
	, @old_value nvarchar(255)
	, @new_value nvarchar(255)
)
returns nvarchar(max)
begin

/*
1-aug-15,lhw
- returns the audit log message if there is any changes.

	select 
		dbo.fn_has_changes('ABC S/B', 'ABC SDN BHD', 'customer name')
		, dbo.fn_has_changes('ABC S/B', null, 'customer name')

result:

	,'customer name' has changed from 'ABC S/B' to 'ABC SDN BHD'

*/

	declare
		@s nvarchar(max)

	if isnull(@old_value, '') <> isnull(@new_value, '')
	begin

		set @s = ','''
					+ @msg
					+ ''' has changed from ''' 
					+ isnull(@old_value , '')
					+ ''' to ''' 
					+ isnull(@new_value , '')
					+ ''''

	end
	else
	begin
		set @s = ''
	end

	return @s

end
go
