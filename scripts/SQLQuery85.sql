DECLARE @ANALISTA AS VARCHAR(50); SET @ANALISTA = 'angela';SELECT * FROM [DB_SISCOB].[APP_WEB].[TBL_USUARIOS] WHERE FNAME LIKE '%'+ @ANALISTA +'%';
DECLARE @RAIZ_GRUPO AS VARCHAR(50); SET @RAIZ_GRUPO = '4046643466';
DECLARE @ID_ANALISTA AS VARCHAR(50); SET @ID_ANALISTA = '15';

select  * FROM 
	[DB_SISCOB].[APP_WEB].[TBL_ARQUIVOS_TRANSITO_ACORDOS] 
WHERE [ID_ANALISTA] = @ID_ANALISTA 
ORDER BY ID DESC


/****** CENARIO - CONSUMO DO ANALISTA ******/
--SELECT count(*), sum([SALDO_ATUAL]) as SALDO_ATUAL ,sum(SALDO_CAR_05) as SALDO_CAR_05 FROM [DB_SISCOB].[APP_EXCEL].[VW_CONSUMO_CONSOLIDADO_ANALISTA] WHERE RAIZ_GRUPO =@RAIZ_GRUPO and (NOME_ANALISTA  IS NOT NULL OR NOME_ANALISTA_TMP IS NOT NULL)
SELECT sum([SALDO_ATUAL]) as SALDO_ATUAL ,sum(SALDO_CAR_05) as SALDO_CAR_05 FROM [APP_EXCEL].[VW_CONSUMO_CONSOLIDADO_ANALISTA] WHERE RAIZ_GRUPO =@RAIZ_GRUPO  and (NOME_ANALISTA  IS NOT NULL OR NOME_ANALISTA_TMP IS NOT NULL)

