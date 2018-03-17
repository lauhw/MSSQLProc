if exists(select * from sys.objects where name = 'pr_sys_gen_new_id')
	drop proc pr_sys_gen_new_id
go

create proc pr_sys_gen_new_id (
	@tb_name nvarchar(255)
	, @last_id bigint output

	, @is_debug int = 0
)
as
begin
/*#
9-may-2012,lhw
- generate a new id.

	declare @id bigint

	exec pr_sys_gen_new_id 
		'tb_sys_prop',
		@id output

	select @id
	
*/

	declare 
		@init_local_trans int

	set nocount on 

	if @@trancount = 0
	begin
		if @is_debug = 1 print 'pr_sys_gen_new_id - begin tran'

		set @init_local_trans = 1
		begin tran
	end

	-- ---------------------------------------------------------------
	begin try

		if not exists(
				select *
				from tb_last_id
				where
					tb_name = @tb_name
			)
		begin
			-- ---------------------------------------------------------------
			-- if the record is not exists, append a new record.
			-- ---------------------------------------------------------------
			insert into tb_last_id (tb_name, modified_on, last_id)
			values (@tb_name, getdate(), '1')

			set @last_id = 1

		end
		else
		begin
			-- ---------------------------------------------------------------
			-- if the record already exists, update it.
			-- ---------------------------------------------------------------
			
			update tb_last_id
			set 
				last_id = cast(cast(last_id as nvarchar) as bigint) + 1,
				modified_on = getdate()
			where
				tb_name = @tb_name

			select 
				@last_id = cast(last_id as bigint) 
			from tb_last_id
			where
				tb_name = @tb_name

		end

		if @init_local_trans = 1
		begin
			commit

			if @is_debug = 1 print 'pr_sys_gen_new_id - commit'
		end

	end try
	begin catch

		if @init_local_trans = 1
		begin
			rollback
			if @is_debug = 1 print 'pr_sys_gen_new_id - rollback'
		end
		print 'ERROR=>' + error_message()

	end catch

	-- ---------------------------------------------------------------
	set nocount off
 
end

go
