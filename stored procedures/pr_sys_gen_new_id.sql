if exists(select * from sys.objects where name = 'pr_sys_gen_new_id')
	drop proc pr_sys_gen_new_id
go

create proc pr_sys_gen_new_id (
	@tb_name nvarchar(255)
	, @last_id bigint output
)
as
begin
/*
9-may-2012,lau@ciysys.com
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
		select @init_local_trans = 1
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
			select 
				@tb_name, getdate(), '1'

			select @last_id = 1
		end
		else
		begin
			-- ---------------------------------------------------------------
			-- if the record already exists, update it.
			-- ---------------------------------------------------------------
			select 
				@last_id = cast(last_id as bigint) + 1
			from tb_last_id
			where
				tb_name = @tb_name

			update tb_last_id
			set 
				last_id = cast(@last_id as nvarchar),
				modified_on = getdate()
			where
				tb_name = @tb_name
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
