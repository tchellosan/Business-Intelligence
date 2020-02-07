declare @anoatual as char(4) = (select year(max(data)) from d_data)

select 
b.nome,
month(a.data) as mes,
sum(a.vlr_unitario * a.qtd_vendida) as vlratual
from f_vendadetalhe as a
inner join d_produto as b
on a.id_produto = b.id_produto
where year(a.data) = @anoatual
and a.id_cliente = @id_cliente
group by b.nome, month(a.data)