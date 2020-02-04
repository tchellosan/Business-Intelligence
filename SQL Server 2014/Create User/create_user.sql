--	Lembrar de configurar a instância do database como: Autenticação do SQL Server e do Windows

USE [master]
GO
CREATE LOGIN [BI_User]
WITH PASSWORD= 'P@ssw0rd',
DEFAULT_LANGUAGE=[Português (Brasil)],
CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
master..sp_addsrvrolemember @loginame = N'BI_User', @rolename = N'sysadmin'
GO