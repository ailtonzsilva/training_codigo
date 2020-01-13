declare @REPORT_EMAIL varchar(255); set @REPORT_EMAIL = @EMAIL
declare @REPORT_SUBJECT varchar(255); set @REPORT_SUBJECT = 'G-CA$H - ARQUIVO RAIZ GRUPO - '+ @RAIZ_GRUPO ;
declare @FILE_PATH varchar(255); set @FILE_PATH = @FILE_DOWNLOAD_TMP + @FILE_COMPACT;
declare @REPORT_Body varchar(255); SET @REPORT_Body  = GETDATE();
PRINT @REPORT_Body;


EXEC msdb.dbo.sp_send_dbmail
@profile_name = 'ENVIO_SISCOB',
@recipients = @REPORT_EMAIL,
@subject = @REPORT_SUBJECT,
@Body = @REPORT_Body ,
@file_attachments = @FILE_PATH;	


SELECT TOP 1000 [ID]
    ,[TIPO]
    ,[DESCRICAO]
    ,[DESCRICAO_02]
    ,[DTSUBIDA]
    ,[DESCRICAO_03]
FROM [DB_SISCOB].[ADM].[TB_APP_CONTROLE] ORDER BY ID DESC
  


DECLARE @SUBJECT VARCHAR(1000); SET @SUBJECT	= (SELECT TOP 1 [DESCRICAO]		AS '_SUBJECT_' FROM [DB_SISCOB].[ADM].[TB_APP_CONTROLE]	WHERE [TIPO] = 'EXPORT_SEGMENTO_EMAIL'  ORDER BY ID DESC);
DECLARE @EMAIL VARCHAR(1000);	SET @EMAIL		= (SELECT TOP 1 [DESCRICAO_02]	AS '_EMAIL_' FROM [DB_SISCOB].[ADM].[TB_APP_CONTROLE]	WHERE [TIPO] = 'EXPORT_SEGMENTO_EMAIL'  ORDER BY ID DESC);
DECLARE @BODY VARCHAR(1000);	SET @BODY		= (SELECT TOP 1 [DESCRICAO_03]	AS '_BODY_' FROM [DB_SISCOB].[ADM].[TB_APP_CONTROLE]	WHERE [TIPO] = 'EXPORT_SEGMENTO_EMAIL'  ORDER BY ID DESC);
DECLARE @LINK VARCHAR(1000);	SET @LINK		= '//tlf-prd-wap03.cloudapp.net:8081/siscob_hml/Segmento/1VPE.7z';

SET @BODY = REPLACE(@BODY,'_LINK_',@LINK)
SET @BODY = REPLACE(@BODY,'_FILTRO_SEGMENTO_','SEGMENTO')

PRINT @BODY

EXEC msdb.dbo.sp_send_dbmail
@profile_name = 'ENVIO_COBRANCA',
@recipients = @EMAIL,
--@copy_recipients = @COPY,
@subject = @SUBJECT,
@Body = @BODY,
--@file_attachments = @ANEXO,
@body_format = 'HTML';	