select
b.cod_funcionario,
b.nome_funcionario || ' ' || b.sobrenome_funcionario as nome_completo,
c.cod_cargo,
c.des_cargo,
d.cod_departamento,
d.des_departamento,
e.cod_divisao,
e.des_divisao,
f.dtc_data,
a.salario
from fato_fp_folha a
inner join dim_fp_funcionario b
on a.sk_funcionario = b.sk_funcionario
inner join dim_fp_cargo c
on a.sk_cargo = c.sk_cargo
inner join dim_fp_departamento d
on a.sk_departamento = d.sk_departamento
inner join dim_fp_divisao e
on a.sk_divisao = e.sk_divisao
inner join dim_fp_tempo f
on a.sk_tempo = f.sk_tempo
order by a.data,
a.funcionario,
a.cargo,
a.departamento,
a.divisao