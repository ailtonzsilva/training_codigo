--028949436231/10/2016NFTBRAD59104422 
--028462637230/09/2016NFTBRAD59104422 
--028462637231/10/2016NFTBRAD59104422 
--025677611530/09/2016NFTBRAD43076702 

SELECT 'PAGAMENTOS' AS TIPO, * FROM [DB_SISCOB_HML].[TRANSITO_PAGAMENTO_AJUSTE].[ATLYS_PAGAMENTOS] WHERE CONTA = '0256776115'
SELECT 'AJUSTES' AS TIPO, * FROM [DB_SISCOB_HML].[TRANSITO_PAGAMENTO_AJUSTE].[ATLYS_AJUSTES] WHERE  CONTA = '0256776115'


--8521.86
--852.18

--9374,04

--25565.58


/****** CONSOLIDADO  ******/

DECLARE @TMP VARCHAR(255) SET @TMP='025677611530/09/2016NFTBRAD43076702'

SELECT TOP 1000 [ID],[ID_SEGMENTO],[SEG_DESCR]
	,[NOTA_FISCAL]
	,[CONTA]
	,[PROCV]
	,[SALDO_CAR]
	FROM [DB_SISCOB].[CONSOLIDADO].[TB_CONSOLIDADO]
	WHERE 
	PROCV = @TMP
	 
	--ID_TIPO=3 and [SEG_DESCR] not like '%VPG%'
	--AND NOTA_FISCAL='0000000051'