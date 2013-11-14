if exists(select * from sys.objects where name= 'vw_log')
	drop view vw_log

go

create view vw_log
as

/*
21-1-11,lau@ciysys.com
-show the minimum fields for troubleshooting.

*/

select 
	top 100 log_id,log_type_id,created_on,msg, remarks

from tb_log

order by 
	log_id desc

go
