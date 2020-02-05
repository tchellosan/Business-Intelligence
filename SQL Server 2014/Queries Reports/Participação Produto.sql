declare @anoatual as char(4) = (select year(max(data)) from d_data)
declare @anoanterior as char(4) = (select year(dateadd(year, -1, @anoatual)))
declare @totalvenda as decimal(18,2) = (select sum(vlr_unitario*qtd_vendida) from f_vendadetalhe where year(data) = @anoanterior)

select top 10
a.id_produto, 
b.nome,
vlratual = (select sum(vlr_unitario * qtd_vendida) 
	from f_vendadetalhe c 
	where a.id_produto = c.id_produto 
	and year(c.data) = @anoatual),
sum(a.vlr_unitario * a.qtd_vendida) as vlranterior,
sum(a.vlr_unitario * a.qtd_vendida)/@totalvenda  as percentual
from f_vendadetalhe a 
inner join d_produto b
on a.id_produto = b.id_produto
where year(a.data) = @anoanterior 
group by a.id_produto, b.nome
order by 3 desc