declare @dataatual as date = (select max(data) from d_data)
declare @dataanterior as date = (select dateadd(year, -1, @dataatual))

select
month(data) as mes,
sum(vlr_unitario * qtd_vendida) as vlratual,
0 as vlranterior
from f_vendadetalhe as a 
inner join d_cliente as b
on a.id_cliente = b.id_cliente
where a.data between dateadd(month, -5, @dataatual) and @dataatual
and a.id_cliente = @id_cliente
group by month(data)
union all
select
month(data) as mes,
0 as vlratual,
sum(vlr_unitario * qtd_vendida) as vlranterior
from f_vendadetalhe as a 
inner join d_cliente as b
on a.id_cliente = b.id_cliente
where a.data between dateadd(month, -5, @dataanterior ) and @dataanterior 
and a.id_cliente = @id_cliente
group by month(data)