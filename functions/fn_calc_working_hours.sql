
if exists(select * from sys.objects where name  = 'fn_calc_working_hours')
	drop function fn_calc_working_hours
go


create function fn_calc_working_hours (
	@start_time nvarchar(5)
	, @end_time nvarchar(5)
)
returns int
begin
/*

11-jan-16,lhw
- return the working hours between the start & end time.


TESTING:
--------

	select 
		dbo.fn_calc_working_hours('09:00', '18:00') '9 hours'
		, dbo.fn_calc_working_hours('21:00', '03:00') '6 hours'
		, dbo.fn_calc_working_hours('15:00', '00:00') '9 hours'
		, dbo.fn_calc_working_hours('22:00', '02:00') '4 hours'
		, dbo.fn_calc_working_hours('02:00', '22:00') '20 hours'

*/

	-- ================================================================
	-- init 
	-- ================================================================
	declare 
		@result int

	-- ================================================================
	-- process
	-- ================================================================

	if @start_time is null 
	or @end_time is null
	begin
			
		set @result = 0

	end
	else
	begin

		set @result = case 						
					when cast(@start_time as datetime) <= cast(@end_time as datetime)

					then 
						--calc the hours between 2 date
						datediff(hour,  cast(@start_time as datetime), cast(@end_time as datetime))
					else
						-- calc the start time until mid night
						datediff(hour,  cast(@start_time as datetime), cast('23:59:59.999' as datetime))
						-- calc the mid night until end time
						+ datediff(hour, cast('00:00' as datetime), cast(@end_time as datetime))
					end
		
	end

	-- ================================================================
	-- cleanup & return result
	-- ================================================================

	return @result

end
go
