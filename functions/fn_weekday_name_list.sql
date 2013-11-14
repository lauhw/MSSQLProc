if exists(
	select *
	from sys.objects
	where name = 'fn_weekday_name_list'
)
begin

	drop function fn_weekday_name_list
	
end
go

create function dbo.fn_weekday_name_list ()
returns @tb table (
		wk int
		, wk_name nvarchar(10)
	)
as
begin

/*

9-sep-13,lau@ciysys.com
- returns the weekday name & weekday index.

Sample:

	select *
	from dbo.fn_weekday_name_list()


Reference:
  http://forums.devshed.com/ms-sql-development-95/convert-day-of-week-integer-to-weekday-name-473441.html
  
*/


    DECLARE @i int
    SET @i=1
    
    WHILE @i BETWEEN 1 AND 7
    BEGIN
        --print str(@i) + ': ' + datename(dw,@i-2)
        insert into @tb (wk, wk_name)
        select @i, datename(dw,@i-2)
     
        SET @i=@i+1
    END 

	return

end
go