




	EXEC xp_cmdshell 'BCP tempdb..##TB_HISTORICO in "Z:\_siscob\___CARLAO\DB_SISCOB.TB_HISTORICO\DB_SISCOB.TB_HISTORICO.EXP" -STLF-PRD-WBD04 -T -n -N -CRAW'


	SELECT * FROM tempdb..##TB_HISTORICO


	
	SELECT TOP 0 * INTO ##TB_HISTORICO FROM '[TRANSITO].[tmp_TB_HISTORICO_v23112016]'


	INSERT INTO [TRANSITO].[tmp_TB_HISTORICO_v23112016]
	SELECT * FROM tempdb..##TB_HISTORICO



	select top 1000 * from [TRANSITO].[tmp_TB_HISTORICO_v23112016]