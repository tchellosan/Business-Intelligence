create table dbo.d_regiaovendas
(
	id_pais int not null,
	nome 	varchar(20) not null,
	lindata date not null,
	linorig varchar(50) not null
)
go
--
create index ix_d_regiaoidpais on ds..d_regiaovendas (id_pais)
	go
--
create index ix_d_regiaonome on ds..d_regiaovendas (nome)
	go
--
create index ix_d_regiaonome on dw..d_regiaovendas (nome)
	go