/****** PAINEL DE CONTROLE  ******/

declare @id as int; set @id=1853164;

/****** TB_CONSOLIDADO  ******/

SELECT *
  FROM [DB_SISCOB].[CONSOLIDADO].[TB_CONSOLIDADO]
  WHERE ID=@id

/****** TB_HISTORICO  ******/

SELECT *
FROM [DB_SISCOB].[CONSOLIDADO].[TB_HISTORICO]
  WHERE 
  [ID_CONSOLIDADO] =@ID
  ORDER BY ID DESC
