create procedure dbo.sp_carregar_f_venda as

	declare @origemdados 	as nvarchar(20)	= 'arquivo de vendas'
	declare @tabela 		as nvarchar(20) = upper('f_venda')

	begin try
		-- apagar registros
		truncate table ds..f_venda

		declare @id_cliente_gen as int = 
		(select id_cliente from dw..d_cliente where lower(cod_cliente) = lower('999999'))
		
		declare @id_func_gen as int = 
		(select id_funcionario from dw..d_funcionario where lower(login) = lower('não aplica'))
		
		declare @id_regiao_vendas_gen as int = 
		(select id_regiaovendas from dw..d_regiaovendas where lower(nome) = lower('não aplica'))

		-- inserir registros no ds
		insert into ds..f_venda
			select 
			data,
			nr_nf,
			id_cliente,
			id_funcionario,
			id_regiaovendas,
			sum(vlr_imposto),
			sum(vlr_frete),
			getdate(),
			@origemdados
			from (select distinct
				isnull(a.datavenda, '1900/01/01') as data,
				isnull(a.nrnf, '000000') as nr_nf,
				isnull(c.id_cliente, @id_cliente_gen) as id_cliente,
				isnull(d.id_funcionario, @id_func_gen) as id_funcionario,
				isnull(e.id_regiaovendas, @id_regiao_vendas_gen) as id_regiaovendas,
				cast(a.imptotal as decimal(18,2)) as vlr_imposto,
				cast(a.frete as decimal(18,2)) as vlr_frete 
				from ds..tbimp_vendas as a
				left join dw..d_data as b
				on a.datavenda = b.data			
				left join dw..d_cliente as c
				on a.codcliente = c.cod_cliente
				left join dw..d_funcionario as d
				on a.vendedorlogin = d.login
				left join dw..d_regiaovendas as e
				on a.regiaovendas = e.nome) as dados_venda
			group by 			
			data,
			nr_nf,
			id_cliente,
			id_funcionario,
			id_regiaovendas

		-- inserir registros no dw
		insert into dw..f_venda
			select
			ds.data,
			ds.nr_nf,	
			ds.id_cliente,
			ds.id_funcionario,
			ds.id_regiaovendas,
			ds.vlr_imposto,
			ds.vlr_frete,	
			ds.lindata,		
			ds.linorig
			from ds..f_venda as ds
			left join dw..f_venda as dw
			on ds.data = dw.data
			and ds.nr_nf = dw.nr_nf
			and ds.id_cliente = dw.id_cliente
			and ds.id_funcionario = dw.id_funcionario
			and ds.id_regiaovendas = dw.id_regiaovendas
			where dw.data is null

		-- gravar log
		insert into dbo.adm_log 
			values(newid(), getdate(), 'importa fato vendas', upper('s'), 'carga ' + @tabela + ' com sucesso')						
	--			
	end try	
	--			
	begin catch
		--
		print error_number();
		print error_message();
		-- gravar log
		insert into dbo.adm_log 
			values(newid(), getdate(), 'importa fato vendas', upper('f'), 'erro ao carregar ' + @tabela)
	--		
	end catch