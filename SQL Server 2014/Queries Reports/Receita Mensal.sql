declare @dataatual as date = (select max(data) from d_data)
declare @dataanterior as date = (select dateadd(year, -1, @dataatual))

select 
month(data) as mes,
sum(vlr_unitario * qtd_vendida) as vlratual,
0 as vlranterior
from f_vendadetalhe as a
where a.data between dateadd(month, -5,@dataatual) and @dataatual
group by month(data)
union all
select 
month(data) as mes,
0 as vlratual,
sum(vlr_unitario * qtd_vendida) as vlranterior
from f_vendadetalhe as a
where a.data between dateadd(month, -5,@dataanterior ) and @dataanterior 
group by month(data)