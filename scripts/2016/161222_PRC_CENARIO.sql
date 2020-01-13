USE [DB_SISCOB]
GO
/****** Object:  StoredProcedure [APP_WEB].[PRC_CENARIO]    Script Date: 12/22/2016 6:28:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [APP_WEB].[PRC_CENARIO] 
	@QUERY_WHERE NVARCHAR(MAX),  
	@ANALISTA NVARCHAR(100),  
	@RAIZ_GRUPO NVARCHAR(100)
	--@ID_FILE bigint output
AS
BEGIN


SET LANGUAGE PORTUGUESE;

SET NOCOUNT ON

DECLARE @Cmd VARCHAR(500);
DECLARE @SQL NVARCHAR(MAX);	
DECLARE @QUERY NVARCHAR(MAX);
DECLARE @QUERY_WHERE_TMP NVARCHAR(MAX);


-- ###################################################################################################################################################################################
-- ###################################################################################################################################################################################
-- [1] -> COPIAR ARQUIVO MODELO 
-- ###################################################################################################################################################################################
-- ###################################################################################################################################################################################

-- #########################
-- SELEÇÃO DO ARQUIVO
-- #########################
	DECLARE @FILE_MODEL_PATH		VARCHAR(1000); SET @FILE_MODEL_PATH		= (SELECT TOP 1 [DESCRICAO] AS 'FILE_MODEL_PATH' FROM [DB_SISCOB].[ADM].[TB_APP_CONTROLE] WHERE [TIPO] = 'CENARIO_FILE_MODEL_PATH');
	DECLARE @FILE_MODEL				VARCHAR(1000); SET @FILE_MODEL			= (SELECT TOP 1 [DESCRICAO] AS 'FILE_MODEL' FROM [DB_SISCOB].[ADM].[TB_APP_CONTROLE] WHERE [TIPO] = 'CENARIO_FILE_MODEL');
	DECLARE @FILE_EXIT				VARCHAR(1000); SET @FILE_EXIT			= (SELECT TOP 1 [DESCRICAO_02] AS 'FILE_EXIT' FROM [DB_SISCOB].[ADM].[TB_APP_CONTROLE] WHERE [TIPO] = 'CENARIO_FILE_MODEL');
	DECLARE @FILE_DOWNLOAD			VARCHAR(1000); SET @FILE_DOWNLOAD		= (SELECT TOP 1 [DESCRICAO] AS 'FILE_DOWNLOAD' FROM [DB_SISCOB].[ADM].[TB_APP_CONTROLE] WHERE [TIPO] = 'CENARIO_DOWNLOAD');
	DECLARE @FILE_DOWNLOAD_TMP		VARCHAR(100);  SET @FILE_DOWNLOAD_TMP	= LEFT(@FILE_DOWNLOAD,LEN(@FILE_DOWNLOAD)-1) +'\'
	
	DECLARE @FILE_EXIT_TMP			VARCHAR(1000); SET @FILE_EXIT_TMP		= @RAIZ_GRUPO + '_' + @FILE_EXIT;
	DECLARE @RETURN_ID_FILE			VARCHAR(1000); --SET @RETURN_ID_FILE		= (SELECT TOP 1 [ID] AS 'ID' FROM [DB_SISCOB].[APP_WEB].[TBL_ARQUIVOS_TRANSITO_CENARIOS] WHERE [nm_arquivo] = @FILE_EXIT_TMP ORDER BY [ID] DESC);

-- ##################################
-- COPIA DE ARQUIVO MODELO
-- ##################################
	SET @Cmd = 'COPY ' + @FILE_MODEL_PATH + @FILE_MODEL + ' ' + @FILE_DOWNLOAD_TMP + @FILE_EXIT_TMP ;
	--PRINT @Cmd  
	EXEC xp_cmdshell @Cmd,no_output	



-- ###################################################################################################################################################################################
-- ###################################################################################################################################################################################
-- [2] -> CADASTRA ARQUIVO COM DADOS CARRAGADOS
-- ###################################################################################################################################################################################
-- ###################################################################################################################################################################################

  --INSERT INTO [APP_WEB].[TBL_ARQUIVOS_TRANSITO_CENARIOS]
  --         ([nm_arquivo]
  --         ,[diretorio]
		--   ,ID_ANALISTA
		--   ,DATA_SOLICITACAO
  --         )
  --   VALUES
  --         (@FILE_EXIT_TMP
  --         ,@FILE_DOWNLOAD
		--   ,convert(int,@ANALISTA)
		--   ,GETDATE()
  --         )

-- ###################################################################################################################################################################################
-- ###################################################################################################################################################################################
-- [3] -> CARREGAR DADOS EM ARQUIVO COPIADO
-- ###################################################################################################################################################################################
-- ###################################################################################################################################################################################

-- #########################
-- EXPORTAR DADOS
-- #########################
	
	--SET @QUERY = @QUERY + '		,'''' AS HISTORICO_DETALHADO '

	SET @SQL = 'INSERT INTO OPENROWSET(''Microsoft.ACE.OLEDB.12.0'',''Excel 12.0 Xml;HDR=YES;IMEX=0;Database=' + @FILE_DOWNLOAD_TMP + @FILE_EXIT_TMP  + ''',''SELECT * FROM [Dados$]'') '

SET @QUERY = 'SELECT PROCV 
	,ID
	,CONVERT(VARCHAR(255), NOME_ANALISTA) as NOME_ANALISTA 
	,CONVERT(VARCHAR(255), NOME_ANALISTA_TMP) as NOME_ANALISTA_TMP 
	,FEEDBACK
	,AREA_OFENSORA
	,TIPO_PAGTO
	,DT_PAGTO
	,REPLACE(CONVERT(VARCHAR(20), VALOR_PAGTO), ''.'', '','') as VALOR_PAGTO
	,DT_AJUSTE
	,REPLACE(CONVERT(VARCHAR(20), VALOR_AJUSTADO), ''.'', '','') as VALOR_AJUSTADO
	,CONVERT(VARCHAR(255), RESUMO_EXECUTIVO_ACAO) as RESUMO_EXECUTIVO_ACAO
	,CONVERT(VARCHAR(255), RESUMO_EXECUTIVO_PROBLEMA) as RESUMO_EXECUTIVO_PROBLEMA
	,CONVERT(VARCHAR(255), HISTORICO_DETALHADO) as HISTORICO_DETALHADO
	,DT_FOLLOW_UP
	,DT_ENCERRAMENTO
	,DT_CONTATO
	,CONVERT(VARCHAR(255), RESPONSAVEL) as RESPONSAVEL
	,FAIXA_FORNECEDOR
	,FAIXA_FECHO
	,FAIXA_ARRECADA_INICIAL
	,FAIXA_ARRECADA_ATUAL
	,RAIZ_GRUPO
	,GRUPO
	,RAIZ
	,CNPJ
	,NOME
	,NOME_CLIENTE
	,TIPO
	,EMPRESA
	,CONTA
	,TEL
	,LOCAL
	,TERMINAL
	,DV
	,NRC
	,CLASSERV
	,TITULO
	,FILIAL
	,LJ_CLI
	,COD_CLI
	,DOCUMENTO_SAP
	,DOC_FAT
	,N_DOC_DE_PARA_ATLYS
	,NOTA_FISCAL
	,VENC_ATUAL
	,VENC_ORIGINAL
	,DT_PROCESS
	,ANOMES
	,DIA_VENCIMENTO_LOTE
	,NUMERO_LOTE
	,REPLACE(CONVERT(VARCHAR(20), VALOR_LOTE), ''.'', '','') as VALOR_LOTE
	,REPLACE(CONVERT(VARCHAR(20), SALDO_CAR_26), ''.'', '','') as SALDO_CAR_26
	,REPLACE(CONVERT(VARCHAR(20), SALDO_CAR_05), ''.'', '','') as SALDO_CAR_05
	,REPLACE(CONVERT(VARCHAR(20), SALDO_CAR_14), ''.'', '','') as SALDO_CAR_14
	,REPLACE(CONVERT(VARCHAR(20), SALDO_CAR_21), ''.'', '','') as SALDO_CAR_21
	,REPLACE(CONVERT(VARCHAR(20), SALDO_CAR_25), ''.'', '','') as SALDO_CAR_25
	,REPLACE(CONVERT(VARCHAR(20), SALDO_TOTAL), ''.'', '','') as SALDO_TOTAL
	,REPLACE(CONVERT(VARCHAR(20), SOMA_FXE_PDD_26), ''.'', '','') as SOMA_FXE_PDD_26
	,REPLACE(CONVERT(VARCHAR(20), SOMA_FXE_PDD_05), ''.'', '','') as SOMA_FXE_PDD_05
	,REPLACE(CONVERT(VARCHAR(20), SOMA_FXE_PDD_14), ''.'', '','') as SOMA_FXE_PDD_14
	,REPLACE(CONVERT(VARCHAR(20), SOMA_FXE_PDD_21), ''.'', '','') as SOMA_FXE_PDD_21
	,REPLACE(CONVERT(VARCHAR(20), SOMA_FXE_PDD_25), ''.'', '','') as SOMA_FXE_PDD_25
	,REPLACE(CONVERT(VARCHAR(20), VALOR_PAGAMENTO), ''.'', '','') as VALOR_PAGAMENTO
	,REPLACE(CONVERT(VARCHAR(20), VALOR_AJUSTE), ''.'', '','') as VALOR_AJUSTE
	,REPLACE(CONVERT(VARCHAR(20), SALDO_ATUAL), ''.'', '','') as SALDO_ATUAL
	,CICLO
	,UF
	,STATUS
	,CLASSE
	,SEGMENTO_GERENCIA
	,GN
	,GV
	,DIRETOR
	,ANALISTA_TLF_VIVO
	,INTRAGOV
	,INTERCOMPANY
	,FEEDBACK_00
	,FEEDBACK_01
	,FEEDBACK_02
	,FEEDBACK_03
	,FEEDBACK_04
	,FEEDBACK_05
	,PENDENTE_ID_ANALISE_CONTA
	,PENDENTE_DATA_ANALISE_CONTA
	,CONCLUIDO_ID_ANALISE_CONTA
	,CONCLUIDO_DATA_ANALISE_CONTA
	,REABERTO_ID_ANALISE_CONTA
	,REABERTO_DATA_ANALISE_CONTA
	,QTD_REG_AGRUPADO
	,DT_ULT_ALTERACAO
	,CONVERT(VARCHAR(255), USUARIO_ATUALIZACAO) as USUARIO_ATUALIZACAO
	,ID_ANALISTA
	,ID_ANALISTA_TMP
	,AREA_ATUACAO
	,TASK_FORCE
	,SEG_DESCR
	,PARCELAMENTO
	,ESCALATION
	,CONTA_BONUS
	,OBS
	,ID_GESTAO_CONTA
	,PENDENTE_ID_ANALISE_CONTA
FROM [APP_EXCEL].[VW_CONSUMO_CONSOLIDADO_ANALISTA] 
WHERE '  

	SET @QUERY_WHERE_TMP = @QUERY_WHERE

	SET @SQL = @SQL + @QUERY + @QUERY_WHERE
	----ARQUIVO DE SCRIPT
	--INSERT INTO [APP_WEB].[TBL_ARQUIVOS_TRANSITO_CENARIOS] ([QUERY_RESUMO]) VALUES (@SQL);


	EXEC(@SQL) 

-- ###################################################################################################################################################################################
-- ###################################################################################################################################################################################
-- [4] -> OK
-- ###################################################################################################################################################################################
-- ###################################################################################################################################################################################

  INSERT INTO [APP_WEB].[TBL_ARQUIVOS_TRANSITO_CENARIOS]
           ([nm_arquivo]
           ,[diretorio]
		   ,ID_ANALISTA
		   ,DATA_SOLICITACAO
		   ,[QUERY_RESUMO]
           )
     VALUES
           (@FILE_EXIT_TMP
           ,@FILE_DOWNLOAD
		   ,convert(int,@ANALISTA)
		   ,GETDATE()
		   ,@SQL
           )


	
	--SET @RETURN_ID_FILE		= (SELECT TOP 1 [ID] AS 'ID' FROM [APP_WEB].[TBL_ARQUIVOS_TRANSITO_CENARIOS] WHERE [nm_arquivo] = @FILE_EXIT_TMP ORDER BY [ID] DESC);
	--SET @ID_FILE = @RETURN_ID_FILE

END


