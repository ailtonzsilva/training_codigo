/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [ID]
      ,[TIPO]
      ,[DESCRICAO]
      ,[DESCRICAO_02]
  FROM [DB_SISCOB].[ADM].[TB_APP_CONTROLE]

  \\172.16.0.6\CARTEIRA\CARTEIRIZACAO.xlsx


  update [DB_SISCOB].[ADM].[TB_APP_CONTROLE]
	set [DESCRICAO_02] =  'rdp@2016'
	where id in (1)


update [DB_SISCOB].[ADM].[TB_APP_CONTROLE]
set [DESCRICAO] =  '\\172.16.0.11\uploads\siscob\carteira\'
where id in (3)