/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [ID]
  ,[TIME_STAMP]
  ,[OBS]
  ,[ID_CONSOLIDADO]
  ,[RESPONSAVEL]
  ,[RESUMO_EXECUTIVO]
  ,[HISTORICO_DETALHADO]
  ,[HD_ACUMULADO]
  ,[STATUS]
  ,[RE_PROBLEMA]
  ,[RE_ACAO]
  ,[ID_SEMANA]
  ,[ID_FOCO_FEEDBACK]
  ,[ID_TIPO_PAGAMENTO]
  ,[ID_ANALISTA]

  ,[DT_FOLLOW]
  ,[DT_CONTATO]
  ,[DT_ENCERRAMENTO]
  ,[DT_ABERTURA]
  ,[DT_AJUSTE]
  ,[DT_PAGAMENTO]
  ,[VALOR_PAGO]
  ,[VALOR_AJUSTE]
  ,[LOTE]
  ,[GESTAO_CONTA]

  ,[CBPM]
  ,[ID_PORTAL_DEMANDA]
  ,[NUMERO_BOLETO]
  ,[DATA_EMISSAO_BOLETO]

  ,[ID_GESTAO_CONTA]
  FROM [DB_SISCOB_HML].[CONSOLIDADO].[TB_HISTORICO] 
  WHERE 
	--ID_CONSOLIDADO in (SELECT ID FROM [DB_SISCOB].[CONSOLIDADO].[TB_CONSOLIDADO] WHERE RAIZ_GRUPO = '4005014109')
	ID_CONSOLIDADO='1887304'
	
  ORDER BY ID DESC


  select *  from  [DB_SISCOB].[CONSOLIDADO].[TB_CONSOLIDADO] c where id='1887304'