create procedure dbo.sp_carregar_d_data as

	declare @origemdados	as nvarchar(20)
	declare @tabela 		as nvarchar(20)

	set @origemdados 		= 'arquivo de vendas'
	set @tabela 			= upper('d_data')

	begin try
		-- apagar registros
		truncate table ds..d_data

		-- inserir registros no ds
		insert into dbo.d_data 
			select distinct	cast(datavenda as date) as data,
			right('00' + cast(day(datavenda) as varchar(2)), 2) as dia,
			right('00' + cast(month(datavenda) as varchar(2)), 2) as mes,
			year(datavenda) as ano 
			from ds..tbimp_vendas

		-- inserir registros no dw
		insert into  dw..d_data
			select ds.data, ds.dia, ds.mes, ds.ano
			from ds..d_data as ds 
			left join dw..d_data as dw
			on ds.data = dw.data
			where dw.data is null

		-- gravar log
		insert into dbo.adm_log 
			values(newid(), getdate(), 'importa data', upper('s'), 'carga ' + @tabela + ' com sucesso')									
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