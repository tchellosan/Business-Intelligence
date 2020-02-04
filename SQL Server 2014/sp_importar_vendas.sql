create procedure dbo.sp_importar_vendas as

	declare @str as nvarchar(1000)

	-- apagar registros
	truncate table dbo.tbimp_vendas

	-- renomear arquivos existentes
	set @str = 'move c:\arquivos\*.csv c:\arquivos\massadados.csv'
	exec xp_cmdshell @str

	-- importar dados do arquivo para sql
	bulk insert dbo.tbimp_vendas
	from 'c:\arquivos\massadados.csv'
	with (
		firstrow = 1,
		fieldterminator = ';',
		rowterminator = '\n'
		)

	-- gravar log
	insert into dbo.adm_log 
		values(newid(), getdate(), 'importa massadados.csv', upper('s'), 'arquivo importado com sucesso')

	-- copiar arquivo para histórico
	declare @nomearquivo varchar(50)
	set @nomearquivo = (select 
		cast(year(getdate()) as char(4)) +
		right('00' + cast(month(getdate()) as varchar(2)), 2) + 
		right('00' + cast(day(getdate()) as varchar(2)), 2) + 
		'_vendas.csv'
		)

	set @str = 'move c:\arquivos\massadados.csv c:\arquivos\historico\' + @nomearquivo
	exec xp_cmdshell @str