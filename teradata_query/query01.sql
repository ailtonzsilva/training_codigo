﻿select  top 10
b.ID_UNICO_SISTEMA_LEGADO as NRC,
e.ID_PRODUTO_COMERCIAL as Tel,

	D.ID_TP_LOGRADOURO,
	D.DS_LOGRADOURO,
	D.NR_IMOVEL,
	D.ID_LOCALIDADE,
	D.DS_COMPLEM_ENDERECO,
	D.DS_COMPLEM_ENDERECO2,
	D.NR_CEP,
	D.DS_BAIRRO

from
	(select ID_FTRA, ID_PC_PRODUTO_COMERCIAL, ID_CICLO, DT_MES_FTRA, DT_VNCMO_FTRA_TLFNA, 
	ID_SISTEMA_FONTE, ID_SUBSEGMENTO_CLIENTE,ID_LOCALIDADE, ID_SUBTP_PRODUTO_COMERCIAL,
	sum(VL_DBITO_ITEM) as valor from PW_VIEDB.V245_ITEM_FTRA 
	where ID_SISTEMA_FONTE=2 
	
	--and ID_PC_PRODUTO_COMERCIAL = 1127028499 
	group by 1,2,3,4,5,6,7,8,9) as A
left join
                PW_VIEDB.PARQUE_CONTRATADO as B
on a.ID_PC_PRODUTO_COMERCIAL = b.ID_PC_PRODUTO_COMERCIAL
--and b.ID_PC_PRODUTO_COMERCIAL = 1127028499 

left join
		(SELECT ID_ENDERECO, ID_PC_PRODUTO_COMERCIAL, ID_TP_USO_ENDERECO,DT_INICIO, DT_FIM, ID_RUN, IN_MGRO_ATIS_AC FROM PW_VIEDB.PARQUE_PC_ENDERECO_HIST) as C
on a.ID_PC_PRODUTO_COMERCIAL = c.ID_PC_PRODUTO_COMERCIAL

left join
		(SELECT	ID_ENDERECO, ID_TP_LOGRADOURO, ID_LOCALIDADE, NR_IMOVEL,
		DS_LOGRADOURO, DS_COMPLEM_ENDERECO, DS_COMPLEM_ENDERECO2, NR_CEP,
		CD_SECAO_SERVICO, DS_BAIRRO, NR_TELEFONE1, NR_TELEFONE2, DS_END_ELETRONICO,
		ID_SISTEMA_FONTE, CD_ENDERECO, ID_LOGRADOURO, ID_RUN, ID_ENDERECO_UNICO,
		CD_ENDERECO_SIEBEL, NM_REDE
		FROM PW_VIEDB.ENDERECO_FISICO) as D
on c.ID_ENDERECO = d.ID_ENDERECO

left join
                ( select * from PW_VIEDB.PARQUE_CONTRATADO_hist where LENGTH(ID_PRODUTO_COMERCIAL)=15) as e
on a.ID_PC_PRODUTO_COMERCIAL = e.ID_PC_PRODUTO_COMERCIAL
and e.dt_fim = '2100-12-31'
