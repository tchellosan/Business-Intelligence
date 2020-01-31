create procedure dbo.sp_carregar_d_cliente as

	declare @origemdados 	as nvarchar(20)
	declare @tabela 		as nvarchar(20)

	set @origemdados 		= 'arquivo de vendas'
	set @tabela 			= upper('d_cliente')

	begin try
		-- apagar registros
		truncate table ds..d_cliente

		-- inserir registros no ds
		insert into dbo.d_cliente
			select distinct
			codcliente 			as cod_cliente,
			nomecliente 		as nome,
			emailcliente		as email,
			getdate()			as lindata,
			@origemdados		as linorig
			from ds..tbimp_vendas

		-- inserir registros no dw
		insert into dw..d_cliente
			select ds.cod_cliente, ds.nome, ds.email, ds.lindata, ds.linorig
			from ds..d_cliente as ds
			left join dw..d_cliente as dw
			on ds.cod_cliente = dw.cod_cliente
			where dw.id_cliente is null

		-- gravar log
		insert into dbo.adm_log 
			values(newid(), getdate(), 'importa cliente', upper('s'), 'carga ' + @tabela + ' com sucesso')			
	--
	end try
	--
	begin catch
		--
		print error_number();
		print error_message();
		
		-- gravar log
		insert into dbo.adm_log 
			values(newid(), getdate(), 'importa data', upper('f'), 'erro ao carregar ' + @tabela)
	--
	end catch