
-- FATURAS VALIDADAS
SELECT concat('-',count(*)) AS qtdRegistros
	,CASE ISNULL(CHECK_CAR,0)
            WHEN 0 THEN 'NOVAS'
            WHEN 1 THEN 'EXISTENTES'
			ELSE 'SEM CLASSIFICACAO'
			end  as Tipo
			--into #tmp
FROM [DB_SISCOB].[FILE_CAR].[TB_TRATAMENTO_FIXA_WEB]
WHERE ok = 1
GROUP BY CHECK_CAR



SELECT 
	SUM(CAST(T.QTDREGISTROS AS FLOAT)) AS QTDREGISTROS 
FROM 
	(
		--FATURAS NOVAS 
		SELECT 
			count(*) as qtdRegistros , 'NOVAS' as Tipo
		FROM [DB_SISCOB].[FILE_CAR].[TB_TRATAMENTO_FIXA_WEB] TF
			INNER JOIN [DB_SISCOB].[FILE_CAR].[TB_CAR_FIXA_IMPORT] FX ON TF.ID_IMPORT_FIXA = FX.ID
			LEFT JOIN [DB_SISCOB].[CONSOLIDADO].[TB_CONSOLIDADO] C ON TF.PROCV = C.PROCV
				AND TF.ID_TIPO = C.ID_TIPO
				AND LEFT(C.SEG_DESCR, 3) = LEFT(TF.SEG_DESCR, 3)
			LEFT JOIN [DB_SISCOB].[AUXILIAR].[TB_DESCRICAO_AGING] FH ON TF.ID_FX_FECHO = FH.ID
			LEFT JOIN [DB_SISCOB].[AUXILIAR].[TB_DESCRICAO_AGING] AR ON TF.ID_FX_ARRECADA = AR.ID
			LEFT JOIN [DB_SISCOB].[AUXILIAR].[TB_TIPO] TP ON TF.ID_TIPO = TP.ID
		WHERE TF.OK = 1
			AND TF.CHECK_CAR IS NULL

	UNION

		-- FATURAS EXISTENTES
		SELECT 
			count(*) as qtdRegistros , 'EXISTENTES' as Tipo
		FROM [DB_SISCOB].[CONSOLIDADO].[TB_CONSOLIDADO] TC
			INNER JOIN [DB_SISCOB].[FILE_CAR].[TB_TRATAMENTO_FIXA_WEB] TF ON TC.PROCV = TF.PROCV
				AND TC.ID_TIPO = TF.ID_TIPO
				AND LEFT(TC.SEG_DESCR, 3) = LEFT(TF.SEG_DESCR, 3)
			INNER JOIN [DB_SISCOB].[FILE_CAR].[TB_CAR_FIXA_IMPORT] FX ON TF.ID_IMPORT_FIXA = FX.ID
			LEFT JOIN [DB_SISCOB].[AUXILIAR].[TB_DESCRICAO_AGING] FH ON TF.ID_FX_FECHO = FH.ID
			LEFT JOIN [DB_SISCOB].[AUXILIAR].[TB_DESCRICAO_AGING] AR ON TF.ID_FX_ARRECADA = AR.ID
		WHERE TF.OK = 1
			AND TC.ID_SEGMENTO = 1
			AND TC.ID_PERIODO = 13
			AND TF.CHECK_CAR = 1

	UNION


		SELECT concat('-',count(*)) AS qtdRegistros
			,CASE ISNULL(CHECK_CAR,0)
					WHEN 0 THEN 'NOVAS'
					WHEN 1 THEN 'EXISTENTES'
					ELSE 'SEM CLASSIFICACAO'
					end  as Tipo
		FROM [DB_SISCOB].[FILE_CAR].[TB_TRATAMENTO_FIXA_WEB]
		WHERE ok = 1
		GROUP BY CHECK_CAR
	) t
