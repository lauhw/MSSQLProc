/*
1-jan-10,lau@ciysys.com
- You may use this table to store the system settings, last process date/time, etc.
  instead of storing the data in a config file. With this table, the system admin
  will be able to turn on or off any feature at anytime without have to access
  the config file stores in the server (ie, the system admin might change the settings
  through web app).
  
*/

if not exists(
	select *
	from sys.objects
	where name = 'tb_sys_prop'
)
begin

	CREATE TABLE tb_sys_prop (
		sys_prop_id BIGINT NOT NULL,
		
		prop_group NVARCHAR(255) NOT NULL,
		prop_name NVARCHAR(255) NOT NULL,
		prop_value NVARCHAR(max) NULL,
		
		modified_on DATETIME NULL,
		modified_by NVARCHAR(255) NULL,
		created_on DATETIME NULL,
		created_by NVARCHAR(50) NULL,
		
		row_guid UNIQUEIDENTIFIER NOT NULL,
		org_id BIGINT NULL, 
		co_id BIGINT NOT NULL
	);
	
end
go

if not exists(
	select *
	from sys.objects
	where name = 'PK_tb_sys_prop'
)
begin

	ALTER TABLE tb_sys_prop 
	ADD CONSTRAINT PK_tb_sys_prop 
	PRIMARY KEY (
		sys_prop_id
	);

end
go


if not exists(
	select *
	from sys.indexes
	where name = 'IX_tb_sys_prop_2'
)
begin

	CREATE INDEX IX_tb_sys_prop_2 ON tb_sys_prop (co_id,prop_name);

end
go
