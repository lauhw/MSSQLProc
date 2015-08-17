
if exists(
	select *
	from sys.objects
	where name = 'fn_is_valid_email'
)
begin
	drop function fn_is_valid_email
end
go


create function fn_is_valid_email(
	@email nvarchar(255)
) 
returns int
begin
/*
14-aug-15,lhw
- returns '1' if the email address is valid.

	select
		email
		, dbo.fn_is_valid_email(email) as result
	from (
		select 'd.dd88@d....com' as email
		union all select 'a'
		union all select 'a.bb'
		union all select 'cc'
		union all select 'd@d.com'
		union all select 'd@d.'
		union all select 'd.dd88@d'
		union all select 'd.dd88@d.com'
		union all select 'd.dd88@@d.@com'
		union all select 'd.dd88@d....com'
		union all select 'd.dd88@.com'
		union all select '@d.dd88@d.com'
		union all select 'd.dd88@d.'
		union all select 'd.d.d.d.d@d.com.my.mm'
		union all select 'd.dd88@d.com.'
		union all select 'd.dd88@d.com.my'
		union all select 'd.dd88@d,com'
		union all select 'd,dd88@d.com'
		union all select 'test @d.com'
		union all select 't#@d.com'
		union all select 't#@d...com'
		union all select 'omer.aslam@gmail.com'
		union all select 'academy_melaka@adonis-beauty.com'
	) as a0

*/

	if len(isnull(@email, '')) = 0
		return 0

	declare
		@EMAIL_ADDR_ALLOW_SYMBOL varchar(10)
		, @EMAIL_ADDRESS_NUMERIC varchar(10)
		, @EMAIL_ADDRESS_ALLOW_ALPHA varchar(30)
		, @EMAIL_ADDR_ALLOW_CHAR varchar(50)
		, @pos int
		, @pos2 int
		, @pos3 int
		, @c char(1)
		, @i int

    set @EMAIL_ADDR_ALLOW_SYMBOL = '@_.-'
    set @EMAIL_ADDRESS_NUMERIC = '0123456789'
    set @EMAIL_ADDRESS_ALLOW_ALPHA = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'
    set @EMAIL_ADDR_ALLOW_CHAR = @EMAIL_ADDR_ALLOW_SYMBOL + @EMAIL_ADDRESS_NUMERIC + @EMAIL_ADDRESS_ALLOW_ALPHA
	    
    set @pos = charindex('@', @email)
    if (@pos <= 0) 
	begin
		return 0
	end

    set @pos2 = charindex('@', @email, @pos + 1)
    if (@pos2 > 0)
	begin
		return 0
	end

    set @pos2 = charindex('.', @email, @pos + 1)
    if ((@pos2 < 0) or (@pos2 < @pos) or (@pos + 1 = @pos2))
	begin
		return 0
	end

    if ((@pos2 + 1) = len(@email)) 
	begin
		return 0
	end

    set @pos3 = charindex('.', @email, @pos2 + 1)
    if ((@pos3 > 0) and ((@pos2 + 1) = @pos3)) 
	begin
		return 0
	end

	set @i = 1
	while @i <= len(@email)
	begin

		set @c = substring(@email, @i, 1)
		if (charindex(@c, @EMAIL_ADDR_ALLOW_CHAR) = 0)
		begin
			return 0 
		end

		set @i = @i + 1
	end
    
	set @c = right(@email, 1)
    if (not (charindex(@c, @EMAIL_ADDRESS_NUMERIC) > 0 or charindex(@c, @EMAIL_ADDRESS_ALLOW_ALPHA) > 0)) 
		return 0

    return 1
end
go
