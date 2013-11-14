if exists(select * from sys.objects where name = 'pr_update_prop_value')
	drop proc pr_update_prop_value
go

create proc pr_update_prop_value (
	@prop_name nvarchar(255),
	@prop_value nvarchar(max),
	@modified_by nvarchar(255)
)
as
begin
/*
9-may-2012,lau@ciysys.com
- update the prop value.

sample:

	declare @s nvarchar(255)
	select @s = cast(getdate() as nvarchar)

	exec pr_update_prop_value 
		'test_prop',
		@s,
		'aaa'

	select *
	from tb_sys_prop
	where 
	prop_name = 'test_prop'


*/

	declare 
		@init_local_trans int,
		@sys_prop_id bigint

	set nocount on 

	if @@trancount = 0
	begin
		select @init_local_trans = 1
		begin tran
	end

	-- ---------------------------------------------------------------
	begin try
		if not exists(select * 
					from tb_sys_prop
					where
						prop_name =	@prop_name
				)
		begin	
			-- generate a new id.
			exec pr_sys_gen_new_id 
						'tb_sys_prop',
						@sys_prop_id output

			-- append the row
			insert into tb_sys_prop (
				row_guid,org_id, co_id,prop_group,
				modified_on,modified_by,created_on,created_by,
				sys_prop_id,
				prop_name,prop_value
			)
			select
				newid(), 0, 0, 'SYSTEM',
				getdate(), @modified_by, getdate(), @modified_by, 
				@sys_prop_id,
				@prop_name,
				@prop_value

		end
		else
		begin
			update tb_sys_prop
			set
				prop_value = @prop_value,
				modified_on = getdate(),
				modified_by = @modified_by
			where
				prop_name = @prop_name
		end

		if @init_local_trans = 1
		begin
			commit
		end
	end try
	begin catch

		if @init_local_trans = 1
		begin
			rollback
		end
		print 'ERROR=>' + error_message()

	end catch

	-- ---------------------------------------------------------------
	set nocount off
 
end

go
