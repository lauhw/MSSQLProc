/*
1-jan-10,lau@ciysys.com
- This table stores the last number of the serial number. 
  You can store invoice number, delivery order number and any other document number here.

*/

if not exists(
	select *
	from sys.objects
	where name = 'tb_last_id'
)
begin

	CREATE TABLE tb_last_id (
		tb_name NVARCHAR(255) NOT NULL,
		last_id BIGINT NOT NULL,
		modified_on DATETIME NOT NULL
	);

end
go

if not exists(
	select *
	from sys.objects
	where name = 'PK_tb_last_id'
)
begin

	ALTER TABLE tb_last_id 
	ADD CONSTRAINT PK_tb_last_id PRIMARY KEY (
		tb_name
	);

end
go

