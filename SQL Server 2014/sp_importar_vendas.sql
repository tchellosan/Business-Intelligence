create procedure dbo.sp_importar_vendas as

	declare @str as nvarchar(1000)

	-- apagar registros
	truncate table tbimp_vendas

	-- renomear arquivos existentes
	set @str = 'move c:\arquivos\*.rpt c:\arquivos\massadados.rpt'
	exec xp_cmdshell @str

	-- importar dados do arquivo para sql
	bulk insert dbo.tbimp_vendas
	from 'c:\arquivos\massadados.rpt'
	with (
		firstrow = 3,
		fieldterminator = '|',
		rowterminator = '\n'
		)

	-- gravar log
	insert into dbo.adm_log 
		values(newid(), getdate(), 'importa massadados.rpt', upper('s'), 'arquivo importado com sucesso')

	-- copiar arquivo para histórico
	declare @nomearquivo varchar(50)
	set @nomearquivo = (select 
		cast(year(getdate()) as char(4)) +
		right('00' + cast(month(getdate()) as varchar(2)), 2) + 
		right('00' + cast(day(getdate()) as varchar(2)), 2) + 
		'_vendas.rpt'
		)

	set @str = 'move c:\arquivos\massadados.rpt c:\arquivos\historico\' + @nomearquivo
	exec xp_cmdshell @str