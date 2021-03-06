

if object_id('fn_date_from_ymd') is not null
	drop function dbo.fn_date_from_ymd 

go

create function dbo.fn_date_from_ymd (
	@yr int
	, @mth int
	, @day int
) 
returns datetime
as
begin
/*
28-jul-16,lhw
- This function returns the datetime base on the yr, mth & day if it is valid. Otherwise, null will be return


	select 
		dbo.fn_date_from_ymd(2016, 1,1)
		, dbo.fn_date_from_ymd(2016, 2,28)
		, dbo.fn_date_from_ymd(2016, 2,29)
		, dbo.fn_date_from_ymd(2016, 2,30)	--null

		, dbo.fn_date_from_ymd(2015, 2,28)
		, dbo.fn_date_from_ymd(2015, 2,29)	--null

*/
	declare
		@result datetime

	set @result = case 
					when @mth in (1,3,5,7,8,10,12) 
					then cast(cast(@yr as varchar) + right('0' +cast(@mth as varchar), 2) + right('0' + cast(@day as varchar), 2) as datetime)

					when @mth in (4,6,9,11) and @day <= 30
					then cast(cast(@yr as varchar) + right('0' +cast(@mth as varchar), 2) + right('0' + cast(@day as varchar), 2) as datetime)

					when @mth = 2
					then (
							case 
								when (@yr % 4 = 0) and (@yr % 100 != 0) or (@yr % 400 = 0)							
								then 
									-- leap year (can be either 28 or 29 days in feb)
									case
										when @day <= 29
										then cast(cast(@yr as varchar) + right('0' +cast(@mth as varchar), 2) + right('0' + cast(@day as varchar), 2) as datetime)
										else null 
									end
								else (
									--not leap year (max is 28 days in feb)
									case 
										when @day <= 28
										then cast(cast(@yr as varchar) + right('0' +cast(@mth as varchar), 2) + right('0' + cast(@day as varchar), 2) as datetime)
										else null 
									end
								)
							end
						)
					else null
				end

	return @result
end
go
