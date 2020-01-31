create procedure dbo.sp_carregar_d_produto as

	declare @origemdados 	as nvarchar(20)	= 'arquivo de vendas'
	declare @tabela 		as nvarchar(20) = upper('d_produto')
	declare @status_ativo	as char(1) 		= 1
	declare @status_inativo	as char(1) 		= 0

	begin try
		-- apagar registros
		truncate table ds..d_produto		

		-- inserir registros no ds
		insert into dbo.d_produto
			select distinct
			cod_produto,
			produto,
			tamanho,
			cor,
			@status_ativo,
			getdate(),
			@origemdados
			from ds..tbimp_vendas

		-- inserir registros no dw
		insert into dw..d_produto
			select			
			ds.cod_produto,
			ds.nome,
			ds.tamanho,
			ds.cor,
			ds.ativo,
			ds.lindata,
			ds.linorig
			from ds..d_produto as ds
			left join dw..d_produto as dw
			on ds.cod_produto = dw.cod_produto
			where dw.id_produto is null

		-- atualizar registros no dw
		declare @cod_produto	as varchar(20)
		declare @nome 			as varchar(50)
		declare @tamanho		as varchar(5)
		declare @cor 			as varchar(20)
		declare @status 		as char(1)
		declare @lindata 		as date
		declare @linorig 		as varchar(50)

		declare cs_atualizar_produto cursor for
		select			
		ds.cod_produto,
		ds.nome,
		ds.tamanho,
		ds.cor,
		ds.lindata,
		ds.linorig
		from ds..d_produto as ds
		join dw..d_produto as dw
		on ds.cod_produto 	= dw.cod_produto
		where not ds.nome	= dw.nome
		and dw.ativo 		= @status_ativo
		for update

		open cs_atualizar_produto

		fetch next from cs_atualizar_produto 
		into @cod_produto, @nome, @tamanho, @cor, @lindata, @linorig

		while @@fetch_status = 0
			--
			begin
				--
				update dw..d_produto
					set ativo = @status_inativo
					where current of cs_atualizar_produto
				--
				insert into dw..d_produto
					values(@cod_produto, @nome, @tamanho, @cor, @status_ativo, @lindata, @linorig)
				--
				fetch next from cs_atualizar_produto
				into @cod_produto, @nome, @tamanho, @cor, @lindata, @linorig
			--				
			end
		--
		close cs_atualizar_produto
		deallocate cs_atualizar_produto

		-- gravar log
		insert into dbo.adm_log 
			values(newid(), getdate(), 'importa produto', upper('s'), 'carga ' + @tabela + ' com sucesso')						
	--				
	end try	
	--
	begin catch
		--
		print error_number();
		print error_message();

		-- gravar log
		insert into dbo.adm_log 
			values(newid(), getdate(), 'importa produto', upper('f'), 'erro ao carregar ' + @tabela)
	--			
	end catch