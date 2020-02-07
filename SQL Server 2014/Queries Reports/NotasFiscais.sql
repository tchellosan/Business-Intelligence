select top 10
a.nr_nf,
a.data,
sum(b.vlr_unitario * b.qtd_vendida) as vlratual
from f_venda as a
inner join f_vendadetalhe as b
on a.data = b.data 
and a.nr_nf = b.nr_nf
and a.id_cliente = b.id_cliente
and a.id_funcionario = b.id_funcionario
and a.id_regiaovendas = b.id_regiaovendas
where a.id_cliente = @id_cliente
group by a.nr_nf, a.data
order by a.data desc