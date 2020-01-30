create table dbo.d_funcionario(
	nome 		varchar(50) not null,
	login 		varchar(50) not null,
	id_chefe 	int null,
	lindata 	date not null,
	linorig 	varchar(50) not null
)
go
--
create index ix_funcionariologin on ds..d_funcionario(login)
	go
--
create index ix_funcionariologin on dw..d_funcionario(login)
	go