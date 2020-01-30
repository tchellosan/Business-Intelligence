create procedure dbo.sp_carregar_d_funcionario as

	declare @origemdados 	as nvarchar(20)
	declare @tabela 		as nvarchar(20)

	set @origemdados 		= 'arquivo de vendas'
	set @tabela 			= 'd_funcionario'

	begin try
		-- apagar registros
		truncate table ds..d_funcionario

		-- inserir registros no ds
		insert into dbo.d_funcionario
			select distinct
			vendedornome,
			vendedorlogin,
			null,
			getdate()			as lindata,
			@origemdados		as linorig
			from ds..tbimp_vendas

		-- inserir registros no dw
		insert into dw..d_funcionario
			select distinct
			ds.nome,
			ds.login,
			ds.id_chefe,
			ds.lindata,
			ds.linorig
			from ds..d_funcionario as ds
			left join dw..d_funcionario as dw
			on ds.login = dw.login
			where dw.id_funcionario is null

		-- atualizar registros no dw
		declare @id_funcionario		as int
		declare @nome_funcionario	as varchar(50)
		declare @login_funcionario	as varchar(50)
		declare @id_chefe			as int
		declare @nome_chefe			as varchar(50)

		declare cs_atualizar_id_chefe cursor for 
		select
		dw.id_funcionario,
		dw.nome,
		dw.login
		from dw..d_funcionario as dw

		open cs_atualizar_id_chefe

		fetch next from cs_atualizar_id_chefe 
		into @id_funcionario, @nome_funcionario, @login_funcionario

		while @@fetch_status = 0
			--
			begin
				--
				set @nome_chefe	= (
					select distinct vendedorchefenome
					from ds..tbimp_vendas
					where vendedorlogin = @login_funcionario
					)

				set @id_chefe	= (
					select distinct id_funcionario
					from dw..d_funcionario
					where nome = @nome_chefe
					)				

				if @nome_funcionario != @nome_chefe
					--
					begin
						--
						update dw..d_funcionario
							set id_chefe 			= @id_chefe
							where id_funcionario 	= @id_funcionario
					--
					end
				--
				fetch next from cs_atualizar_id_chefe 
				into @id_funcionario, @nome_funcionario, @login_funcionario
			--
			end
		--
		close cs_atualizar_id_chefe
		deallocate cs_atualizar_id_chefe

		-- gravar log
		insert into dbo.adm_log 
			values(newid(), getdate(), 'importa funcionario', 's', 'carga ' + @tabela + ' com sucesso')						
	--
	end try
	--
	begin catch
		--
		print error_number();
		print error_message();

		-- gravar log
		insert into dbo.adm_log 
			values(newid(), getdate(), 'importa funcionario', 'f', 'erro ao carregar ' + @tabela)
	--
	end catch