USE [DB_SISCOB]
GO
/****** Object:  StoredProcedure [APP_WEB].[PRC_CARTEIRIZACAO_UPLOAD]    Script Date: 11/13/2016 8:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [APP_WEB].[PRC_CARTEIRIZACAO_UPLOAD] --@FILE_PATH NVARCHAR(1000), @FILE_NAME NVARCHAR(1000) 
AS
BEGIN

	SET NOCOUNT ON

	DECLARE @Cmd VARCHAR(500);
	DECLARE @SQL NVARCHAR(MAX);
	DECLARE @DATABASE NVARCHAR(1000);	

-- ###################################################################################################################################################################################
-- ###################################################################################################################################################################################
-- [1] -> MAPEAR PASTA DE DESTINO DE DOWNLOAD
-- ###################################################################################################################################################################################
-- ###################################################################################################################################################################################

-- #########################
-- MAPEAMENTO - ( USUÁRIO )
-- #########################
	DECLARE @USUARIO_NOME VARCHAR(100); SET @USUARIO_NOME = (SELECT TOP 1 [DESCRICAO] AS USUARIO_NOME FROM [DB_SISCOB].[ADM].[TB_APP_CONTROLE] WHERE [TIPO] = 'NET_USER');
	DECLARE @USUARIO_SENHA VARCHAR(100); SET @USUARIO_SENHA = (SELECT TOP 1 [DESCRICAO_02] AS USUARIO_SENHA FROM [DB_SISCOB].[ADM].[TB_APP_CONTROLE] WHERE [TIPO] = 'NET_USER');

-- #########################
-- MAPEAMENTO - ( CAMINHO )
-- #########################
	DECLARE @MAPEAMENTO_CAMINHO VARCHAR(100); SET @MAPEAMENTO_CAMINHO = (SELECT TOP 1 [DESCRICAO] AS MAPEAMENTO_CAMINHO FROM [DB_SISCOB].[ADM].[TB_APP_CONTROLE] WHERE [TIPO] = 'CARTEIRIZACAO_UPLOAD');
	DECLARE @MAPEAMENTO_UNIDADE VARCHAR(100); SET @MAPEAMENTO_UNIDADE = (SELECT TOP 1 [DESCRICAO_02] AS MAPEAMENTO_UNIDADE FROM [DB_SISCOB].[ADM].[TB_APP_CONTROLE] WHERE [TIPO] = 'CARTEIRIZACAO_UPLOAD');


	DECLARE @FILE_NAME VARCHAR(100); SET @FILE_NAME = (SELECT TOP 1 [NOME_ARQUIVO] FROM [DB_SISCOB].[APP_WEB].[TBL_LOG_CARTEIRA] ORDER BY [ID] DESC);

	-- #########################
	-- MAPEAMENTO - ( CRIAÇÃO )
	-- #########################

	--SET @Cmd = 'NET USE ' + @MAPEAMENTO_UNIDADE + '  ' + @MAPEAMENTO_CAMINHO + '  ' + @USUARIO_SENHA + ' /USER:' + @USUARIO_NOME -- ' /PERSISTENT:yes'
	--EXEC xp_cmdshell @Cmd,no_output

	-- #########################
	-- LIMPAR TABELA DE TRANSITO
	-- #########################

	TRUNCATE TABLE [DB_SISCOB].[TRANSITO].[tmpCARTEIRIZACAO_MKT]

	-- ##########################
	-- CARREGAR DADOS EM TRANSITO
	-- ##########################

	SET @DATABASE = 'Excel 12.0;Database=' + @MAPEAMENTO_CAMINHO + @FILE_NAME;
	SET @SQL = 'SELECT * FROM OPENROWSET(''Microsoft.ACE.OLEDB.12.0'',''' + @DATABASE + ''' , [Dados$])';
	print @SQL

	insert into [DB_SISCOB].[TRANSITO].[tmpCARTEIRIZACAO_MKT]
	(
		[RAIZ]
		,[RAZAO_SOCIAL]
		,[RAIZ_GRUPO]
		,[NOME_GRUPO]
		,[GN]
		,[GV]
		,[DIRETOR]
		,[AREA_ATUACAO]
		,[TASK_FORCE]
		,[NOME_ANALISTA]
		,[NOME_ANALISTA_TMP]  
	)
	EXEC (@SQL) 

	-- ######################
	-- ### UPDATE - FIXA
	-- ######################

	UPDATE [AUXILIAR].[TB_ANALISTA_CARTEIRA_FIXA]
	   SET 
			[ID_ANALISTA] = U.id_user
			,[ID_ANALISTA_TMP] = U2.id_user
		  ,[STATUS] = 0
 
	  from
						[DB_SISCOB].[TRANSITO].[tmpCARTEIRIZACAO_MKT] T
			INNER JOIN  [DB_SISCOB].[AUXILIAR].[TB_ANALISTA_CARTEIRA_FIXA]  C ON T.RAIZ = C.RAIZ
			LEFT JOIN   [DB_SISCOB].[APP_WEB].[TBL_USUARIOS]				U ON T.NOME_ANALISTA = CONCAT(U.fname,' ',U.lname) 
			LEFT JOIN   [DB_SISCOB].[APP_WEB].[TBL_USUARIOS]				U2 ON T.NOME_ANALISTA_TMP = CONCAT(U2.fname,' ',U2.lname) 
		
 
	 WHERE T.[AREA_ATUACAO] = 'FIXA'

	 -- ######################
	 -- ### UPDATE - MOVEL
	 -- ######################

	 UPDATE [AUXILIAR].[TB_ANALISTA_CARTEIRA_MOVEL]
		SET 
			[ID_ANALISTA] = U.id_user
			,[ID_ANALISTA_TMP] = U2.id_user
			,[STATUS] = 0
		from
						[DB_SISCOB].[TRANSITO].[tmpCARTEIRIZACAO_MKT] T
			INNER JOIN  [DB_SISCOB].[AUXILIAR].[TB_ANALISTA_CARTEIRA_MOVEL]  C ON T.RAIZ = C.RAIZ
			LEFT JOIN   [DB_SISCOB].[APP_WEB].[TBL_USUARIOS]				U ON T.NOME_ANALISTA = CONCAT(U.fname,' ',U.lname) 
			LEFT JOIN   [DB_SISCOB].[APP_WEB].[TBL_USUARIOS]				U2 ON T.NOME_ANALISTA_TMP = CONCAT(U2.fname,' ',U2.lname) 

		WHERE [AREA_ATUACAO] = 'MOVEL'


	-- #########################
	-- CONSOLIDAÇÃO
	-- #########################

	EXEC [APP_EXCEL].[PRC_UPDATE_CARTEIRA_FIXA_CONSOLIDADO] no_output
	EXEC [APP_EXCEL].[PRC_UPDATE_CARTEIRA_MOVEL_CONSOLIDADO] no_output


	-- #########################
	-- MAPEAMENTO - ( EXCLUSÃO )
	-- #########################

	--SET @Cmd = 'NET USE ' + @MAPEAMENTO_UNIDADE + ' /delete /y ' ;  
	--EXEC xp_cmdshell @Cmd

END

