SELECT 
w.raiz_grupo
,i.CONTA
,i.DT_PROCESS
,i.SEG_DESCR
,w.FORNECEDOR
,w.SALDO_CAR
,i.DTCORTE
--INTO [DB_SISCOB].TRANSITO.VALIDACAO_ANALITICO_MOVEL
FROM 
[DB_SISCOB].[FILE_CAR].[TB_TRATAMENTO_MOVEL_WEB] w
INNER JOIN 
[DB_SISCOB].[FILE_CAR].[TB_CAR_MOVEL_IMPORT] i on i.ID=w.ID_IMPORT_MOVEL
WHERE
w.ok=1
and
conta = '0030936416'