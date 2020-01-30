create table dbo.d_pais(
	id_grupogeo int not null,
	sigla 		char(2) not null,
	lindata 	date not null,
	linorig 	varchar(50) not null
)
go
--
create index ix_d_paisidgrupo on ds..d_pais (id_grupogeo)
	go
--
create index ix_d_paissigla on ds..d_pais (sigla)
	go
--
create index ix_d_paissigla on dw..d_pais (sigla)
	go