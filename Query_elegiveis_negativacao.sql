


--------------------------- Clientes passiveis de negativação 
with CTE as (
select 
CLI.nm_completo,
CLI.nr_cpf_cnpj,
CONCAT(LIG.id_entidade_ligacao,'-',LIG.nr_digito_matricula) as matricula,
UNI.ds_unidade,
DOC.id_documento,
DOC.dt_emissao,
DOC.dt_referencia,
DOC.dt_vencimento,
DOC.id_situacao,
DOC.dt_situacao,
DOC.vl_total,
TD.ds_tipo_documento,
CASE WHEN DOC.id_situacao = 13 THEN DATEDIFF(DD, DOC.dt_vencimento,GETDATE())
ELSE ''
END AS dias_atraso,
ROW_NUMBER() OVER(
	PARTITION BY CONCAT(LIG.id_entidade_ligacao,'-',LIG.nr_digito_matricula)
	ORDER BY DATEDIFF(DD,DOC.dt_vencimento,GETDATE()) DESC 
					) as rn,
NEG.dt_inclusao,
NEG.dt_exclusao
from entidade_doc_cobranca DOC

INNER JOIN entidade_ligacao LIG ON LIG.id_entidade_ligacao = DOC.id_entidade_ligacao AND DOC.id_categoria_tarifa NOT IN (0,3,4)  -- filtro tirando publico, publica e nao cadastrado
INNER JOIN tab_tipo_documento TD ON TD.id_tipo_documento = DOC.id_tipo_documento
INNER JOIN entidade_cliente_ligacao CLIG ON CLIG.id_entidade_ligacao = LIG.id_entidade_ligacao AND CLIG.id_tipo_cliente = 1 -- filtro morador
INNER JOIN entidade_cliente CLI ON CLI.id_entidade_cliente = CLIG.id_entidade_cliente
INNER JOIN tab_unidade UNI ON UNI.id_unidade = DOC.id_unidade
LEFT JOIN entidade_negativacao NEG ON NEG.id_entidade_cliente = CLI.id_entidade_cliente

where 

-- PATY

DOC.id_unidade = 370 
AND DOC.vl_total >= 50
AND DOC.id_situacao = 13
AND (
        DOC.id_tipo_documento = 1 AND
		 DATEDIFF(DAY, DOC.dt_vencimento,GETDATE()) >= 45
        OR (
            DOC.id_tipo_documento = 2
            AND  DATEDIFF(DAY, DOC.dt_vencimento,GETDATE()) >= 10
        ))
OR -- RIO DE JANEIRO

( DOC.id_unidade = 372  
AND DOC.vl_total >= 61.69
AND DOC.id_situacao = 13
AND (
		 DOC.id_tipo_documento = 1 AND
		 DATEDIFF(DAY, DOC.dt_vencimento,GETDATE()) >= 45
		 OR
		  DOC.id_tipo_documento = 2
          AND  DATEDIFF(DAY, DOC.dt_vencimento,GETDATE()) >= 10
	) ) 
	
--- MIGUEL PEREIRA

OR ( DOC.id_unidade = 371  
AND DOC.vl_total >= 50
AND DOC.id_situacao = 13
AND (
		 DOC.id_tipo_documento = 1 AND
		 DATEDIFF(DAY, DOC.dt_vencimento,GETDATE()) >= 45
		 OR
		  DOC.id_tipo_documento = 2
          AND  DATEDIFF(DAY, DOC.dt_vencimento,GETDATE()) >= 10
	) ) 

-- CUIABÁ

OR ( 
DOC.id_unidade = 77  
AND DOC.vl_total >= 47.10
AND DOC.id_situacao = 13
AND DOC.id_tipo_documento in (1,2) 
AND DATEDIFF(DAY, DOC.dt_vencimento,GETDATE()) >= 45

 ) 

-- PARANAGUÁ

OR ( 
DOC.id_unidade = 75  
AND DOC.vl_total >= 54.76
AND DOC.id_situacao = 13
AND DOC.id_tipo_documento in (1,2) 
AND DATEDIFF(DAY, DOC.dt_vencimento,GETDATE()) >= 45

 ) 


 -- SANESSOL

OR ( 
DOC.id_unidade = 35  
AND DOC.vl_total >= 33.76
AND DOC.id_situacao = 13
AND DOC.id_tipo_documento in (1,2) 
AND DATEDIFF(DAY, DOC.dt_vencimento,GETDATE()) >= 60

 ) 

 -- CASTILHO

OR ( 
DOC.id_unidade = 60  
AND DOC.vl_total >= 30.70
AND DOC.id_situacao = 13
AND DOC.id_tipo_documento in (1,2) 
AND DATEDIFF(DAY, DOC.dt_vencimento,GETDATE()) >= 45

 ) 

 -- ANDRADINA

OR ( 
DOC.id_unidade = 61  
AND DOC.vl_total >= 23.98
AND DOC.id_situacao = 13
AND DOC.id_tipo_documento in (1,2) 
AND DATEDIFF(DAY, DOC.dt_vencimento,GETDATE()) >= 45

 ) 

	
	)

select * from cte
where rn = 1





