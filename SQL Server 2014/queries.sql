select *
from [dw].[dbo].[f_vendadetalhe] a
inner join [dw].[dbo].[d_data] g
on a.Data = g.Data
inner join [dw].[dbo].[d_cliente] b
on a.Id_Cliente = b.Id_Cliente
inner join [dw].[dbo].[d_funcionario] c
on a.Id_Funcionario = c.Id_Funcionario
inner join [dw].[dbo].[d_regiaovendas] d
on a.Id_RegiaoVendas = d.id_regiaovendas
inner join [dw].[dbo].[d_produto] e
on a.Id_Produto= e.Id_Produto
right join [ds].[dbo].[tbimp_vendas] f
on  a.data = f.DataVenda
and b.Cod_Cliente = f.CodCliente
and c.Login = f.VendedorLogin
and d.nome = f.RegiaoVendas
and e.Cod_Produto = f.Cod_Produto
where a.data is null

---------------------------------------------------

select *
from [dw].[dbo].[f_vendadetalhe] a
left join [ds].[dbo].[f_vendadetalhe] b
on a.data = b.data
and a.nr_nf= b.nr_nf
and a.id_cliente = b.id_cliente
and a.id_funcionario = b.id_funcionario
and a.id_regiaovendas = b.id_regiaovendas
and a.id_produto = b.id_produto
where b.data is null

---------------------------------------------------

declare @anoatual as char(4) = (select year(max(data)) from d_data)

select 
c.Nr_NF,
b.nome,
month(a.data) as mes,
sum(a.vlr_unitario * a.qtd_vendida) as vlratual
from f_vendadetalhe as a
inner join d_produto as b
on a.id_produto = b.id_produto
inner join f_venda as c
on a.data = c.data 
and a.nr_nf = c.nr_nf
and a.id_cliente = c.id_cliente
and a.id_funcionario = c.id_funcionario
and a.id_regiaovendas = c.id_regiaovendas
where year(a.data) = @anoatual
and a.id_cliente = 223944
group by 
c.Nr_NF,
b.nome, month(a.data)

---------------------------------------------------

declare @dataatual as date = (select max(data) from d_data)
declare @dataanterior as date = (select dateadd(year, -1, @dataatual))

select * from (

	select 
	b.id_cliente,
	c.Nome,
	month(a.data) as mes,
	sum(b.Vlr_Unitario * b.Qtd_Vendida) as vlratual,
	0 as vlranterior
	from f_venda as a
	inner join f_vendadetalhe as b
	on a.data = b.data 
	and a.nr_nf = b.nr_nf
	and a.id_cliente = b.id_cliente
	and a.id_funcionario = b.id_funcionario
	and a.id_regiaovendas = b.id_regiaovendas
	inner join d_cliente as c
	on a.Id_Cliente = c.Id_Cliente
	where a.data between dateadd(month, -5, @dataatual) and @dataatual
	group by b.id_cliente, c.Nome,month(a.data)
	union all
	select 
	b.id_cliente,
	c.Nome,
	month(a.data) as mes,
	0 as vlratual,
	sum(b.Vlr_Unitario * b.Qtd_Vendida) as vlranterior
	from f_venda as a
	inner join f_vendadetalhe as b
	on a.data = b.data 
	and a.nr_nf = b.nr_nf
	and a.id_cliente = b.id_cliente
	and a.id_funcionario = b.id_funcionario
	and a.id_regiaovendas = b.id_regiaovendas
	inner join d_cliente as c
	on a.Id_Cliente = c.Id_Cliente
	where a.data between dateadd(month, -5, @dataanterior ) and @dataanterior 
	group by b.id_cliente, c.Nome,month(a.data)
) as dadosclientes
order by Nome

---------------------------------------------------

declare @produto_ativo as char(1) = '1'

select
a.Data,
c.Dia,
c.Mes,
c.Ano,
d.Cod_Cliente,
d.Nome as ClienteNome,
d.Email,
e.Nome as FuncNome,
e.Login,
f.Nome as RegiaoVendas,
g.Sigla as Pais,
h.Nome as GrupoGeo,
i.Nome as Produto,
i.Cod_Produto,
b.Vlr_Unitario,
b.Qtd_Vendida
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
on f.Id_Pais = g.Id_Pais
inner join d_grupogeografico as h
on g.Id_GrupoGeo = h.Id_GrupoGeo
inner join d_produto as i
on b.Id_Produto = i.Id_Produto
where i.Ativo = @produto_ativo