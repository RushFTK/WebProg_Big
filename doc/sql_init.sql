create table books
(
	ISBN 	char(24) 	primary key,
	title 	char(64)	not null,
	author	char(32)	not null,
	press	char(32)	not null,
	price	double		not null
)

create table accounts
(
	username  char(24)	primary key	,
	password  char(24)	not null	,
	sessionid char(24)
)

insert into books values	('9787121193941', 'How_to_sleep', 'dreammaster', 'dreammaster_co', 62.70),
				('9787302176428', 'LearningAjax(3th_Editon)', 'LiXiang', 'noname_process', 59.30),
				('1234567891234', 'Dosta_Analyze', 'Fon_Group', '409Studio', 25.00),
				('1234567891235', 'Runningtest', 'Fon_Group', '409Studio', 28.30),
				('9876543219876', 'Teachingbyhands_EnterpriseJavaBeans', 'Suhang', 'BJUT', 125.80),
				('2222333344445', 'WebProgramdesign(3th_Editon)', 'Suhang', 'BJUT', 45.60);


insert into accounts values	('admin','123456')