create procedure dbo.sp_workflow_vendas as

	exec dbo.sp_importar_vendas

	--	carga dimensão
	exec dbo.sp_carregar_d_data
	exec dbo.sp_carregar_d_cliente
	exec dbo.sp_carregar_d_geografia
	exec dbo.sp_carregar_d_funcionario
	exec dbo.sp_carregar_d_produto

	--	carga fato
	exec dbo.sp_carregar_f_venda
	exec dbo.sp_carregar_f_vendadetalhe