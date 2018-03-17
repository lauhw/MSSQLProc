/*
1-jan-10,lau@ciysys.com
- This table stores the date information. You may replying on this table to produce daily, weekly, monthly report.
  
*/

if not exists(
	select *
	from sys.objects
	where name = 'tb_date'
)
begin

	CREATE TABLE tb_date (
		dt DATETIME NOT NULL
		, yr INT NOT NULL
		, mth INT NOT NULL
		, qtr INT NOT NULL
		, wk INT NOT NULL
		, dow INT NOT NULL
		, day_mth INT NOT NULL
		, day_yr INT NOT NULL
	);
	
end
go

if not exists(
	select *
	from sys.objects
	where name = 'PK_tb_date'
)
begin

	ALTER TABLE tb_date ADD CONSTRAINT PK_tb_date PRIMARY KEY (dt);

end
go


if not exists(
	select *
	from sys.indexes
	where name = 'IX_tb_date_2'
)
begin

	CREATE INDEX IX_tb_date_2 ON tb_date (dt) INCLUDE (yr,mth,qtr,wk,dow,day_mth,day_yr);

end
go
