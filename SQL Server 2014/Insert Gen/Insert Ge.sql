use dw
go
--
insert into d_cliente 
	values ('999999','não aplica', 'não aplica', getdate(), 'registro padrão inserido manualmente');
--
insert into d_data 
	values ('1900/01/01', '01','01','1900');
--
insert into d_funcionario 
	values ('não aplica','não aplica',null, getdate(), 'registro padrão inserido manualmente');
--
insert into d_grupogeografico 
	values ('não aplica', getdate(), 'registro padrão inserido manualmente');
--
insert into d_pais 
	values ((select id_grupogeo from d_grupogeografico where nome = 'não aplica'), 'xx', getdate(), 'registro padrão inserido manualmente');
--
insert into d_regiaovendas 
	values ((select id_pais from d_pais where sigla = 'xx'), 'não aplica', getdate(), 'registro padrão inserido manualmente');
--
insert into d_produto 
	values ('999999','não aplica','na','na','1', getdate(), 'registro padrão inserido manualmente');