/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [ID]
      ,[TIPO]
      ,[DESCRICAO]
      ,[DESCRICAO_02]
  FROM [DB_SISCOB].[ADM].[TB_APP_CONTROLE]

  \\172.16.0.6\e\sftp_files\FTP_User\SISCOB\fileModel\