create table dbo.d_grupogeografico
(
	nome 	varchar(50) not null,
	lindata date not null,
	linorig varchar(50) not null
)
go
--
create index ix_d_grupogeografico_nome on ds..d_grupogeografico (nome)
	go
--
create index ix_d_grupogeografico_nome on dw..d_grupogeografico (nome)
	go