USE [DB_SISCOB]
GO
/****** Object:  StoredProcedure [FILE_CAR].[PRC_002_B_ATRIBUI_FORNECEDOR]    Script Date: 12/5/2016 7:37:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- ==========================================================================
-- Author:		Alencar, Luiz
-- Create date: 2016-09-14
-- Obs> : O processo de inserção guardará histórico mensal dos registros
-- Sempre que iniciar um periodo novo (CAR 26) Iniciará um novo preenchimento
-- ==========================================================================
CREATE PROCEDURE [FILE_CAR].[PRC_002_B_ATRIBUI_FORNECEDOR] 

AS
BEGIN
		
	---- Verificar a data do Car que foi importado por ultimo 	
	DECLARE @sDiaCar AS CHAR(2)
	--SET @sDiaCar = (SELECT TOP 1 DESCRICAO_02 FROM [DB_SISCOB].[ADM].[TB_APP_CONTROLE] ORDER BY ID DESC)
   
 --  	IF @sDiaCar = '26'
 --  		BEGIN
 --  				TRUNCATE TABLE [DB_SISCOB].[AUXILIAR].[VW_VIVO_CARTEIRA];
 --  		END
   	
 --  	ELSE
 --  		BEGIN
 --  				UPDATE [DB_SISCOB].[FILE_CAR].[TB_TRATAMENTO_MOVEL] SET FORNECEDOR =  NULL ;
   				
 --  				UPDATE M SET 
 --  							M.FORNECEDOR =  C.FORNECEDOR
 --  				FROM 
 --  								[DB_SISCOB].[AUXILIAR].[VW_VIVO_CARTEIRA] C 
	--				INNER JOIN	[DB_SISCOB].[FILE_CAR].[TB_CAR_MOVEL_IMPORT] MI ON C.CONTA = MI.CONTA AND C.DT_PROCESS = MI.DT_PROCESS
	--				INNER JOIN	[DB_SISCOB].[FILE_CAR].[TB_TRATAMENTO_MOVEL] M	ON MI.ID  = M.ID_IMPORT_MOVEL
	--			WHERE 
	--				M.OK = 'OK';
					
					
	--			UPDATE M SET 
	--						M.FORNECEDOR = C.FORNECEDOR
	--			FROM
							
	--						[DB_SISCOB].[FILE_CAR].[TB_TRATAMENTO_MOVEL] M
	--			INNER JOIN  [DB_SISCOB].[FILE_CAR].[TB_CAR_MOVEL_IMPORT] MI ON M.ID_IMPORT_MOVEL = MI.ID
	--			INNER JOIN	(
	--							SELECT 
	--									DISTINCT 
	--											 C.RAIZ_GRUPO
	--											,C.FORNECEDOR
	--							FROM
	--									[DB_SISCOB].[FILE_CAR].[TB_TRATAMENTO_MOVEL] C
	--							WHERE
	--									FORNECEDOR IS NOT NULL
	--									AND NOT FORNECEDOR = 'IP'
										
										
									
								
	--						) C ON M.RAIZ_GRUPO = C.RAIZ_GRUPO
	
	--			WHERE 
	--						OK = 'OK'
	--						--AND (
	--						--		CONVERT(DATE,MI.DT_PROCESS,103) > 
	--						--			   (SELECT CONVERT(DATE,
	--						--										CONVERT(CHAR(4),YEAR(GETDATE())) + '-' 
	--						--									+	REPLICATE('0',2-LEN(MONTH(GETDATE())-1)) 
	--						--									+	CONVERT(VARCHAR(2),MONTH(GETDATE())-1) + '-23')
	--						--				)
	--						--		OR MI.DT_PROCESS IS NULL
	--						--	 )
	--						AND M.FORNECEDOR IS NULL
	--						AND M.GRUPO_ANALISE = 'ATIVO'
   		
 --  		END
END

