create view vw_analise_dw as
	select
	a.data,
	c.dia,
	c.mes,
	c.ano,
	d.cod_cliente,
	d.nome as clientenome,
	d.email,
	e.nome as funcnome,
	e.login,
	f.nome as regiaovendas,
	g.sigla as pais,
	h.nome as grupogeo,
	i.nome as produto,
	i.cod_produto,
	b.vlr_unitario,
	b.qtd_vendida
	from f_venda as a
	inner join f_vendadetalhe as b
	on a.data = b.data 
	and a.nr_nf = b.nr_nf
	and a.id_cliente = b.id_cliente
	and a.id_funcionario = b.id_funcionario
	and a.id_regiaovendas = b.id_regiaovendas
	inner join d_data as c
	on a.data = c.data 
	inner join d_cliente as d
	on a.id_cliente = d.id_cliente
	inner join d_funcionario as e
	on a.id_funcionario = e.id_funcionario
	inner join d_regiaovendas as f
	on a.id_regiaovendas = f.id_regiaovendas
	inner join d_pais as g
	on f.id_pais = g.id_pais
	inner join d_grupogeografico as h
	on g.id_grupogeo = h.id_grupogeo
	inner join d_produto as i
	on b.id_produto = i.id_produto
where i.ativo = '1' -- produtos ativos