create table dbo.d_produto(
	cod_produto varchar(20) not null,
	nome varchar(50) not null,
	tamanho varchar(5) not null,
	cor varchar(20) not null,
	ativo char(1) not null,
	lindata date not null,
	linorig varchar(50) not null
)
go
--
create index ix_produtonm on ds..d_produto (nome)
	go	
--
create index ix_produtonm on dw..d_produto (nome)
	go	
--		
create index ix_produtocod on ds..d_produto (cod_produto)
	go	
--			
create index ix_produtocod on dw..d_produto (cod_produto)
	go