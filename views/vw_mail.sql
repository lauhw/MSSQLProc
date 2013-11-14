if exists( select * from sys.objects where name = 'vw_mail')
	drop view vw_mail
go


create view vw_mail
as

/*

21-1-11,lau@ciysys.com
- show the minimum fields for troubleshooting.

*/


	select top 100  
		row_id, created_on,sent_status_id, sent_on,
		send_to_email, subject, body_text,attach_file
		, reply_to

	from dbo.tb_mail

	order by row_id desc

go
