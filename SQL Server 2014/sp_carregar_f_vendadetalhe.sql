create procedure dbo.sp_carregar_f_vendadetalhe as

	declare @origemdados 	as nvarchar(20)	= 'arquivo de vendas'
	declare @tabela 		as nvarchar(20) = upper('f_vendadetalhe')
	declare @status_ativo	as char(1) 		= 1	

	begin try
		-- apagar registros
		truncate table ds..f_vendadetalhe

		declare @id_cliente_gen as int = 
		(select id_cliente from dw..d_cliente where cod_cliente = '999999')
		
		declare @id_func_gen as int = 
		(select id_funcionario from dw..d_funcionario where lower(login) = lower('não aplica'))
		
		declare @id_regiao_vendas_gen as int = 
		(select id_regiaovendas from dw..d_regiaovendas where lower(nome) = lower('não aplica'))

		declare @id_produto_gen	as int =
		(select id_produto from dw..d_produto where cod_produto = '999999' and ativo = '1')

		-- inserir registros no ds
		insert into ds..f_vendadetalhe
			select 
			data,
			nr_nf,
			id_cliente,
			id_funcionario,
			id_regiaovendas,
			id_produto,
			sum(vlr_unitario),
			sum(qtd_vendida),
			getdate(),
			@origemdados
			from (select distinct
				isnull(a.datavenda, '1900/01/01') as data,
				isnull(a.nrnf, '000000') as nr_nf,
				isnull(c.id_cliente, @id_cliente_gen) as id_cliente,
				isnull(d.id_funcionario, @id_func_gen) as id_funcionario,
				isnull(e.id_regiaovendas, @id_regiao_vendas_gen) as id_regiaovendas,
				isnull(f.id_produto, @id_produto_gen) as id_produto,
				cast(a.precounitario as decimal(18,2)) as vlr_unitario,
				cast(a.qtd as int) as qtd_vendida
				from ds..tbimp_vendas as a
				left join dw..d_data as b
				on a.datavenda = b.data			
				left join dw..d_cliente as c
				on a.codcliente = c.cod_cliente
				left join dw..d_funcionario as d
				on a.vendedorlogin = d.login
				left join dw..d_regiaovendas as e
				on a.regiaovendas = e.nome
				left join dw..d_produto as f
				on a.cod_produto = f.cod_produto
				where f.ativo = @status_ativo
				) as dados_venda_detalhe		
			group by 			
			data,
			nr_nf,
			id_cliente,
			id_funcionario,
			id_regiaovendas,
			id_produto

		-- inserir registros no dw
		insert into dw..f_vendadetalhe
			select
			ds.data,
			ds.nr_nf,	
			ds.id_cliente,
			ds.id_funcionario,
			ds.id_regiaovendas,
			ds.id_produto,
			ds.vlr_unitario,
			ds.qtd_vendida,	
			ds.lindata,		
			ds.linorig
			from ds..f_vendadetalhe as ds
			left join dw..f_vendadetalhe as dw
			on ds.data = dw.data
			and ds.nr_nf = dw.nr_nf
			and ds.id_cliente = dw.id_cliente
			and ds.id_funcionario = dw.id_funcionario
			and ds.id_regiaovendas = dw.id_regiaovendas
			and ds.id_produto = dw.id_produto
			where dw.data is null

		-- gravar log
		insert into dbo.adm_log 
			values(newid(), getdate(), 'importa fato vendas detalhe', upper('s'), 'carga ' + @tabela + ' com sucesso')						
	--			
	end try

	begin catch
		--
		print error_number();
		print error_message();
		-- gravar log
		insert into dbo.adm_log 
			values(newid(), getdate(), 'importa fato vendas detalhe', upper('f'), 'erro ao carregar ' + @tabela)
	--		
	end catch