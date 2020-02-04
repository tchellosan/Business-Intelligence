truncate table ds..adm_log

truncate table ds..d_cliente
truncate table ds..d_data
truncate table ds..d_funcionario
truncate table ds..d_regiaovendas
truncate table ds..d_pais
truncate table ds..d_grupogeografico
truncate table ds..d_produto
truncate table ds..f_venda
truncate table ds..f_vendadetalhe

delete from dw..f_vendadetalhe
delete from dw..f_venda
delete from dw..d_cliente
delete from dw..d_data
delete from dw..d_funcionario
delete from dw..d_regiaovendas
delete from dw..d_pais
delete from dw..d_grupogeografico
delete from dw..d_produto