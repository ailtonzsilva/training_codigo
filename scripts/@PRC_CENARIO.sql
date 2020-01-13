USE [DB_SISCOB]
GO

DECLARE	@return_value int,
		@ID_FILE int

EXEC	@return_value = [APP_WEB].[PRC_CENARIO]
		@QUERY_WHERE = N'raiz_grupo=02382035'
		,@ANALISTA = N'50'
		,@RAIZ_GRUPO = N'02382035'
		--,@ID_FILE = @ID_FILE OUTPUT

SELECT	@ID_FILE as N'@ID_FILE'

SELECT	'Return Value' = @return_value

GO


SELECT TOP 10 * FROM [APP_WEB].[TBL_ARQUIVOS_TRANSITO_CENARIOS] ORDER BY [ID] DESC

--sp_helptext '[APP_WEB].[PRC_CENARIO]'
--sp_help '[APP_WEB].[PRC_CENARIO]'

declare @tmp varchar(max); set @tmp = (select query_resumo FROM [APP_WEB].[TBL_ARQUIVOS_TRANSITO_CENARIOS] where id = '888')
print @tmp