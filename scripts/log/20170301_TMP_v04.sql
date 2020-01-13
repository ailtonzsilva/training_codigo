/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
	[CONTA]
	,[DT_CORTE]
	,[CHAVE] 
	,sum([VALOR_PAGTO]) as [VALOR_PAGTO]
	,sum([VALOR_AJUSTE]) as [VALOR_AJUSTE]
FROM [DB_SISCOB_HML].[TRANSITO_PAGAMENTO_AJUSTE].[CAR_MANUAL]
where 
conta = 144
group by
	[CONTA]
	,[DT_CORTE]
	,[CHAVE]


