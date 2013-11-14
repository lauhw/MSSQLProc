if exists(
	select * 
	from sys.objects 
	where name = 'mgt_create_backup_device'
)
begin
	drop proc mgt_create_backup_device
end
go

create proc mgt_create_backup_device (
	@db nvarchar(255),
	@folder nvarchar(100)	
)
as
begin

/*
22-10-10,lau@ciysys.com
-create 7 backup devices for the database

sample code:

	exec mgt_create_backup_device  'vois_dev', 'c:\mssql\backup\'

to verify the device that has been created:

	exec sp_helpdevice

*/

	declare 
		@device_name sysname
		, @file_name sysname

	-- ------------------------------------------------------------
	select @device_name = @db + '_mon_bak', 
			@file_name = @folder + @db + '_mon_bak.bak'

	if not exists(
				select *
				from master..sysdevices
				where name = @device_name
			)
	begin
		exec sp_addumpdevice 
					'disk', 
					@device_name, 
					@file_name

		print 'created ' + @device_name
	end

	-- ------------------------------------------------------------
	select @device_name = @db + '_tue_bak', 
			@file_name = @folder + @db + '_tue_bak.bak'

	if not exists(
				select *
				from master..sysdevices
				where name = @device_name
			)
	begin
		exec sp_addumpdevice 
					'disk', 
					@device_name, 
					@file_name
	end

	-- ------------------------------------------------------------
	select @device_name = @db + '_wed_bak', 
			@file_name = @folder + @db + '_wed_bak.bak'

	if not exists(
				select *
				from master..sysdevices
				where name = @device_name
			)
	begin
		exec sp_addumpdevice 
					'disk', 
					@device_name, 
					@file_name
	end

	-- ------------------------------------------------------------
	select @device_name = @db + '_thu_bak', 
			@file_name = @folder + @db + '_thu_bak.bak'

	if not exists(
				select *
				from master..sysdevices
				where name = @device_name
			)
	begin
		exec sp_addumpdevice 
					'disk', 
					@device_name, 
					@file_name
	end

	-- ------------------------------------------------------------
	select @device_name = @db + '_fri_bak', 
			@file_name = @folder + @db + '_fri_bak.bak'

	if not exists(
				select *
				from master..sysdevices
				where name = @device_name
			)
	begin
		exec sp_addumpdevice 
					'disk', 
					@device_name, 
					@file_name
	end

	-- ------------------------------------------------------------
	select @device_name = @db + '_sat_bak', 
			@file_name = @folder + @db + '_sat_bak.bak'

	if not exists(
				select *
				from master..sysdevices
				where name = @device_name
			)
	begin
		exec sp_addumpdevice 
					'disk', 
					@device_name, 
					@file_name
	end

	-- ------------------------------------------------------------
	select @device_name = @db + '_sun_bak', 
			@file_name = @folder + @db + '_sun_bak.bak'

	if not exists(
				select *
				from master..sysdevices
				where name = @device_name
			)
	begin
		exec sp_addumpdevice 
					'disk', 
					@device_name, 
					@file_name
	end

end
go
