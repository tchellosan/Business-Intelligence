declare @dataatual as date = (select max(data) from d_data)

select
month(a.data) as mes,
b.nome,
sum(a.vlr_unitario * a.qtd_vendida) as vlrvenda
from f_vendadetalhe as a
inner join d_cliente as b
on a.id_cliente = b.id_cliente
where a.data between dateadd(month, -5, @dataatual) and @dataatual
and a.id_cliente in (
	select top 5
	id_cliente
	from f_vendadetalhe
	where data between dateadd(month, -5, @dataatual) and @dataatual
	group by id_cliente
	order by sum(vlr_unitario * qtd_vendida) desc
)
group by month(a.data), b.nome
order by month(a.data), b.nome, vlrvenda