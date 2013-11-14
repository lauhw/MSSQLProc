if exists(select * from sys.objects where name = 'pr_sys_send_mail')
	drop proc pr_sys_send_mail
go

create proc pr_sys_send_mail (
	@send_to_email nvarchar(max)
	, @cc_to_email nvarchar(max)	

	, @subject nvarchar(255)
	, @msg nvarchar(max)
	, @attach_file nvarchar(max)	
		
	, @mail_id uniqueidentifier output
	
	, @mail_type_id int = 0
	, @is_debug int = 0
)
as
begin

/*
14-apr-13,lau@ciysys.com
- append a new email to tb_mail.

sample code: 

	declare @id uniqueidentifier 

	exec pr_sys_send_mail 
		@send_to_email = 'a@test.com'
		, @cc_to_email = 'bb@test.com'

		, @subject ='test mail'
		, @msg = 'test message'
		, @attach_file = 'a.doc;b.doc;'
			
		, @mail_id = @id output
		
		, @mail_type_id =0
		, @is_debug =1
		
	select @id as mail_id

*/
	-- ==========================================================
	-- init
	-- ==========================================================
	set nocount on

	declare 
		@row_id bigint

	exec pr_sys_gen_new_id 
			'tb_mail',
			@row_id output

	set @mail_id = newid()
	
	-- ==========================================================
	-- process
	-- ==========================================================
	insert into tb_mail (
		row_id,row_guid,
		created_on,sent_status_id,sent_on,mail_type_id,
		
		send_to_email,cc_to_email,
		subject,body_text,
		attach_file
	)

	select 
		@row_id
		, @mail_id
		, getdate()
		, 0					-- sent_status_id
		, null				-- sent_on
		, @mail_type_id	
		
		, @send_to_email
		, @cc_to_email
		, @subject
		, @msg
		, @attach_file			

	if @is_debug = 1
		print 'row_id = ' + cast(@row_id as nvarchar) + ',row_guid=' + cast(@mail_id as nvarchar(36))

	-- ==========================================================
	-- cleanup
	-- ==========================================================

	set nocount off

end
go
