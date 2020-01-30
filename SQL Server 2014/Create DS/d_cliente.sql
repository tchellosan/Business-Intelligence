create table dbo.d_cliente(
	cod_cliente varchar(10) not null,
	nome 		varchar(50) not null,
	email 		varchar(50) not null,
	lindata 	date not null,
	linorig 	varchar(50) not null
)
go
--
create index ix_cod_cliente on ds..d_cliente (cod_cliente)
	go
--
create index ix_cod_cliente on dw..d_cliente (cod_cliente)
	go	