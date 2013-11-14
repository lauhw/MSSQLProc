if exists(select * from sys.objects where name = 'mgt_shrink_db')
	drop proc mgt_shrink_db
go

create proc mgt_shrink_db
as
begin
/*

6-6-11,lau@ciysys.com
-shrink the database by 10% on every execution. This is the fastest way to shrink
 a huge db.

*/

	declare 
		@fileid int
		, @size int
		, @new_size int
		, @sql nvarchar(500)
		, @stop int

	declare @tb table
	(
		fileid int
		, old_size_mb int
		, new_size_mb int
	)

	-- =====================================================================

	set nocount on

	declare cr cursor
	for
		select 
			fileid, size * 8 /1024
		from sysfiles

	select @stop = 0

	-- =====================================================================
	open cr

	fetch next from cr
	into @fileid, @size

	while @@fetch_status = 0
	begin
	--	print 'file id = ' + cast(@fileid as varchar)
	--		+',size=' + cast( @size	 as varchar)

		insert into @tb values (@fileid, @size, 0)

		-- ----------------------------------------------------
		select @new_size = @size + 5

		-- if the file size is greater than the new size, shrink it.
		while (@size < @new_size)
			and (@size > 0)
			and (@stop = 0)
		begin
			if (@size > 50)
			begin
				-- shrink the file for 10% space.
				select @new_size = @size 
									*  0.9

				select @sql = 'dbcc shrinkfile('
								+ cast(@fileid as varchar)
								+ ','
								+ cast(@new_size as varchar)
								+') with no_infomsgs'
			end 
			else
			begin	
				-- if less than 50mb, we just need to shrink it to 0mb (ie, the smallest possible size).		
				select 
						@stop = 1,
						@new_size = 0,
						@sql = 'dbcc shrinkfile('
											+ cast(@fileid as varchar)
											+') with no_infomsgs'
			end

	--		print 'sql=' + @sql

			exec sp_executesql @sql

			-- get the new shrinked size 
			select @size = size * 8 / 1024
			from sysfiles
			where fileid = @fileid		

			select @new_size = @new_size + 5

	-- -------------------
	-- for debugging used.
	-- -------------------
	--		print
	--			'file id = ' + cast(@fileid as varchar)
	--			+ ', new size=' + cast( @new_size as varchar)
	--			+',size=' + cast( @size	as varchar)

		end

		update @tb
		set new_size_mb = @size
		where 
			fileid = @fileid 

		-- ----------------------------------------------------
		fetch next from cr
		into @fileid, @size
	end

	close cr
	deallocate cr


	set nocount off

	-- =====================================================================
	-- show the shrink result
	select * 
	from @tb

end
go
