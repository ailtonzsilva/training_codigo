/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [id]
      ,[nm_arquivo]
      ,[diretorio]
      ,[inativo]
  FROM [DB_SISCOB].[APP_WEB].[TBL_ARQUIVOS]