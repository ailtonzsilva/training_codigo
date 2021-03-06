/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [ID]
      ,[TIPO]
      ,[DESCRICAO]
      ,[DESCRICAO_02]
      ,[DTSUBIDA]
      ,[DESCRICAO_03]
  FROM [DB_SISCOB_HML].[ADM].[TB_APP_CONTROLE]



  --ALTER TABLE [DB_SISCOB].[ADM].[TB_APP_CONTROLE] ALTER COLUMN [DESCRICAO_02] VARCHAR(100) NULL
/****** ADM - CONTROLE  ******/
SELECT TOP 1000 [ID]
      ,[TIPO]
      ,[DESCRICAO]
      ,[DESCRICAO_02]
	  ,[DESCRICAO_03]
  FROM [DB_SISCOB_HML].[ADM].[TB_APP_CONTROLE] 
 -- -- MODELO
  WHERE 
	[TIPO] LIKE 'ACORDO%'

  order by [ID] 


INSERT INTO [DB_SISCOB_HML].[ADM].[TB_APP_CONTROLE] 
	(
	[TIPO]
	,[DESCRICAO]
	,[DESCRICAO_02]
	)
	SELECT TOP 1 'ACORDO_FILE_MODEL_PATH'
		,'\\172.16.0.6\e\sftp_files\FTP_User\SISCOB\fileModel\'
		,null
	union
	SELECT TOP 1 'ACORDO_DOWNLOAD'
		,'\\172.16.0.11\siscob\ACORDO\'
		,null
	union
	SELECT TOP 1 'ACORDO_FILE_MODEL'
		,'ACORDO_MODELO.xlsm'
		,null
	union
	SELECT TOP 1 'ACORDO_APP'
		,'\\172.16.0.11\siscob\ACORDO\'
		,'exportAcordo.exe'


ACORDO_FILE_MODEL_PATH	\\172.16.0.6\e\sftp_files\FTP_User\SISCOB\fileModel\		NULL
ACORDO_DOWNLOAD	\\172.16.0.11\siscob\ACORDO/		NULL
ACORDO_FILE_MODEL	ACORDO_MODELO.xlsm	ACORDO.xlsm	NULL
ACORDO_APP	\\172.16.0.11\siscob\ACORDO\	exportAcordo.exe	NULL