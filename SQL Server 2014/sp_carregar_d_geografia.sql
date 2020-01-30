create procedure dbo.sp_carregar_d_geografia as

	declare @origemdados	as nvarchar(20)
	declare @tabela 		as nvarchar(20)

	set @origemdados 		= 'arquivo de vendas'
	set @tabela 			= 'd_grupogeografico, d_pais, d_regiaovendas'

	begin try
		-- apagar registros
		truncate table ds..d_grupogeografico
		truncate table ds..d_pais
		truncate table ds..d_regiaovendas

		-- inserir registros no ds
		insert into dbo.d_grupogeografico
			select distinct
			grupogeografico,
			getdate() as lindata,
			@origemdados as linorig
			from ds..tbimp_vendas

		-- inserir registros no dw
		insert into dw..d_grupogeografico
			select 
			ds.nome, 
			ds.lindata, 
			ds.linorig
			from ds..d_grupogeografico as ds
			left join dw..d_grupogeografico as dw
			on ds.nome = dw.nome
			where dw.id_grupogeo is null

		-- inserir registros no ds
		insert into dbo.d_pais 
			select distinct
			dw.id_grupogeo, 
			ds.pais, 
			getdate() as lindata,
			@origemdados as linorig
			from ds..tbimp_vendas as ds
			inner join dw..d_grupogeografico as dw
			on ds.grupogeografico = dw.nome

		-- inserir registros no dw
		insert into dw..d_pais 
			select 
			ds.id_grupogeo, 
			ds.sigla, 
			ds.lindata,
			ds.linorig
			from ds..d_pais as ds
			left join dw..d_pais as dw
			on ds.id_grupogeo = dw.id_grupogeo
			and ds.sigla = dw.sigla
			where dw.id_pais is null			

		-- inserir registros no ds
		insert into dbo.d_regiaovendas
			select distinct
			dw.id_pais, 
			ds.regiaovendas,
			getdate() as lindata,
			@origemdados as linorig
			from ds..tbimp_vendas as ds
			inner join dw..d_pais as dw
			on ds.pais = dw.sigla

		-- inserir registros no dw
		insert into dw..d_regiaovendas
			select 
			ds.id_pais,
			ds.nome,
			ds.lindata,
			ds.linorig
			from ds..d_regiaovendas as ds
			left join dw..d_regiaovendas as dw
			on ds.id_pais = dw.id_pais
			and ds.nome = dw.nome
			where dw.id_regiaovendas is null

		-- gravar log
		insert into dbo.adm_log 
			values(newid(), getdate(), 'importa geografia', 's', 'carga ' + @tabela + ' com sucesso')						
	--
	end try
	--
	begin catch
		--
		print error_number();
		print error_message();
		
		-- gravar log
		insert into dbo.adm_log 
			values(newid(), getdate(), 'importa geografia', 'f', 'erro ao carregar ' + @tabela)
	--
	end catch