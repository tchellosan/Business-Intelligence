create table dbo.f_venda(
	data 			date not null,
	nr_nf 			varchar(10) not null,
	id_cliente 		int not null,
	id_funcionario 	int not null,
	id_regiaovendas int not null,
	vlr_imposto 	decimal(18, 2) not null,
	vlr_frete 		decimal(18, 2) not null,
	lindata 		date not null,
	linorig 		varchar(50) not null,
	constraint pk_f_venda primary key clustered(
		data asc,
		nr_nf asc,
		id_cliente asc,
		id_funcionario asc,
		id_regiaovendas asc
		)
)