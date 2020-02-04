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