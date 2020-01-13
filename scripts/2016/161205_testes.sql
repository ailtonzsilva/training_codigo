DECLARE @SQL NVARCHAR(MAX);	
DECLARE @QUERY NVARCHAR(MAX);
DECLARE @FILE_DOWNLOAD_TMP		VARCHAR(100);  SET @FILE_DOWNLOAD_TMP	= 'Z:\_siscob\'
DECLARE @FILE_EXIT_TMP			VARCHAR(1000); SET @FILE_EXIT_TMP		= 'CONSUMO_CONSOLIDADO_ANALISTA.xlsx';

SET @SQL = 'INSERT INTO OPENROWSET(''Microsoft.ACE.OLEDB.12.0'',''Excel 12.0 Xml;HDR=YES;IMEX=0;Database=' + @FILE_DOWNLOAD_TMP + @FILE_EXIT_TMP  + ''',''SELECT * FROM [Dados$]'') '


SET @QUERY = ' 
SELECT  
	[PROCV]
      ,[ID]
      ,[NOME_ANALISTA]
      ,[NOME_ANALISTA_TMP]
      ,[FEEDBACK]
      ,[AREA_OFENSORA]
      ,[TIPO_PAGTO]
      ,[DT_PAGTO]
      ,[VALOR_PAGTO]
      ,[DT_AJUSTE]
      ,[VALOR_AJUSTADO]
      ,[RESUMO_EXECUTIVO_PROBLEMA]
      ,[RESUMO_EXECUTIVO_ACAO]
      ,[HISTORICO_DETALHADO]
      ,[DT_FOLLOW_UP]
      ,[LOTE]
      ,[GESTAO_CONTA]
      ,[DT_ABERTURA]
      ,[DT_ENCERRAMENTO]
      ,[DT_CONTATO]
      ,[RESPONSAVEL]
      ,[FAIXA_FORNECEDOR]
      ,[FAIXA_FECHO]
      ,[FAIXA_ARRECADA_INICIAL]
      ,[FAIXA_ARRECADA_ATUAL]
      ,[RAIZ_GRUPO]
      ,[GRUPO]
      ,[RAIZ]
      ,[CNPJ]
      ,[NOME]
      ,[NOME_CLIENTE]
      ,[TIPO]
      ,[EMPRESA]
      ,[CONTA]
      ,[TEL]
      ,[LOCAL]
      ,[TERMINAL]
      ,[DV]
      ,[NRC]
      ,[CLASSERV]
      ,[TITULO]
      ,[FILIAL]
      ,[LJ_CLI]
      ,[COD_CLI]
      ,[DOCUMENTO_SAP]
      ,[DOC_FAT]
      ,[N_DOC_DE_PARA_ATLYS]
      ,[NOTA_FISCAL]
      ,[VENC_ATUAL]
      ,[VENC_ORIGINAL]
      ,[DT_PROCESS]
      ,[ANOMES]
      ,[DIA_VENCIMENTO_LOTE]
      ,[NUMERO_LOTE]
      ,[VALOR_LOTE]
      ,[SALDO_CAR_26]
      ,[SALDO_CAR_05]
      ,[SALDO_CAR_30]
      ,[SALDO_CAR_14]
      ,[SALDO_CAR_21]
      ,[SALDO_CAR_25]
      ,[SALDO_TOTAL]
      ,[SOMA_FXE_PDD_26]
      ,[SOMA_FXE_PDD_30]
      ,[SOMA_FXE_PDD_05]
      ,[SOMA_FXE_PDD_14]
      ,[SOMA_FXE_PDD_21]
      ,[SOMA_FXE_PDD_25]
      ,[VALOR_PAGAMENTO]
      ,[VALOR_AJUSTE]
      ,[dt_atrib]
      ,[DTCORTE]
      ,[SALDO_ATUAL]
      ,[CICLO]
      ,[UF]
      ,[STATUS]
      ,[CLASSE]
      ,[SEGMENTO_GERENCIA]
      ,[GN]
      ,[GV]
      ,[DIRETOR]
      ,[ANALISTA_TLF_VIVO]
      ,[INTRAGOV]
      ,[INTERCOMPANY]
      ,[FEEDBACK_00]
      ,[FEEDBACK_01]
      ,[FEEDBACK_02]
      ,[FEEDBACK_03]
      ,[FEEDBACK_04]
      ,[FEEDBACK_05]
      ,[PENDENTE_ID_ANALISE_CONTA]
      ,[PENDENTE_DATA_ANALISE_CONTA]
      ,[CONCLUIDO_ID_ANALISE_CONTA]
      ,[CONCLUIDO_DATA_ANALISE_CONTA]
      ,[REABERTO_ID_ANALISE_CONTA]
      ,[REABERTO_DATA_ANALISE_CONTA]
      ,[QTD_REG_AGRUPADO]
      ,[DT_ULT_ALTERACAO]
      ,[USUARIO_ATUALIZACAO]
      ,[ID_ANALISTA]
      ,[ID_ANALISTA_TMP]
      ,[AREA_ATUACAO]
      ,[TASK_FORCE]
      ,[SEG_DESCR]
      ,[PARCELAMENTO]
      ,[CONTA_BONUS]
      ,[FORNECEDOR]
      ,[ESCALATION]
      ,[REGRA_PDD]
      ,[FAIXA_CORTE]
      ,[PROVISAO]
      ,[SITUACAO_SERVICO]
      ,[ENDERECO]
      ,[ID_ESCALATION]
      ,[DESCRICAO_STATUS]
      ,[ID_EQUIPE]
      ,[ID_LIDER]
      ,[ID_COOREDENADOR]
      ,[ID_TIPO]
      ,[ID_FORNECEDOR]
      ,[ID_FEEDBACK]
      ,[ID_TIPO_PAGAMENTO]
      ,[ID_AREA_OFENSORA]
  FROM [DB_SISCOB].[APP_EXCEL].[VW_CONSUMO_CONSOLIDADO_ANALISTA] WHERE NOME_ANALISTA_TMP = ''FABIO CARMINHOLI'' '
  
SET @SQL = @SQL + @QUERY 

--PRINT @SQL

EXEC(@SQL) 