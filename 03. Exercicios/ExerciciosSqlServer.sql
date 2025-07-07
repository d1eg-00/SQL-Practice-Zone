/*
EXERCÍCIO 1 
Crie o banco de dados treino com as tabelas conforme diagrama.
*/
CREATE DATABASE TREINO;
USE TREINO;

--criando tabelas que nao dependem de outras tabelas
CREATE TABLE CIDADE 
	(
	ID_CIDADE INT IDENTITY (1,1) NOT NULL PRIMARY KEY,
	NOME_CIDADE VARCHAR (60) NOT NULL,
	UF VARCHAR(2) NOT NULL
);

CREATE TABLE CATEGORIA 
	(
	ID_CATEGORIA INT IDENTITY (1,1) NOT NULL PRIMARY KEY,
	NOME_CATEGORIA VARCHAR (20)
);

--- TABELA DE UNIDADE DE MEDIDA DO PRODUTO
CREATE TABLE UNIDADE 
	(
	ID_UNIDADE VARCHAR (3) NOT NULL PRIMARY KEY,
	DESC_UNIDADE VARCHAR(25) NOT NULL,
);


--- TABELA CLIENTE

CREATE TABLE CLIENTE
	(
	ID_CLIENTE INT IDENTITY (1,1) NOT NULL PRIMARY KEY,
	NOME_CLIENTE VARCHAR (60) NOT NULL,
	ENDERECO VARCHAR (60) NOT NULL,
	NUMERO VARCHAR (10) NOT NULL,
	ID_CIDADE INT NOT NULL,
	CEP VARCHAR (9),
	CONSTRAINT FK_Cliente_Cidade FOREIGN KEY (ID_CIDADE) REFERENCES CIDADE(ID_CIDADE)
);

--TABELA VENDEDORES

CREATE TABLE VENDEDORES
	(
	ID_VENDEDOR INT IDENTITY (1,1) NOT NULL PRIMARY KEY,
	NOME_VENDEDOR VARCHAR (60),
	SALARIO DECIMAL (10,2)
);

--TABELA PRODUTOS
CREATE TABLE PRODUTOS 
	(
	ID_PROD INT IDENTITY (1,1) NOT NULL PRIMARY KEY,
	NOME_PROD VARCHAR (50) NOT NULL,
	ID_CATEGORIA INT NOT NULL,
	ID_UNIDADE VARCHAR (3) NOT NULL,
	PRECO DECIMAL (10,2) NOT NULL,
	CONSTRAINT FK_Produto_Categoria FOREIGN KEY (ID_CATEGORIA) REFERENCES CATEGORIA (ID_CATEGORIA),
	CONSTRAINT FK_Produto_Unidade FOREIGN KEY (ID_UNIDADE) REFERENCES UNIDADE (ID_UNIDADE)
);

--TABELA VENDAS

CREATE TABLE VENDAS
	(
	NUM_VENDA INT IDENTITY (1,1) NOT NULL PRIMARY KEY,
	DATA_VENDA DATETIME,
	ID_CLIENTE INT NOT NULL, --fk
	ID_VENDED INT NOT NULL, --FK
	STATUS CHAR (1) DEFAULT ('N'), -- N NORMAL C CANCELADA
	CONSTRAINT FK_Vendas_Cliente FOREIGN KEY (ID_CLIENTE) REFERENCES CLIENTE (ID_CLIENTE),
	CONSTRAINT FK_Vendas_Vendedor FOREIGN KEY (ID_VENDED) REFERENCES VENDEDORES (ID_VENDEDOR)
);

--DETALHE VENDA DE ITENS
CREATE TABLE VENDA_ITENS
	(
	NUM_VENDA INT NOT NULL, --FK
	NUM_SEQ INT NOT NULL,
	ID_PROD INT NOT NULL, --FK
	QTDE DECIMAL (10,2) NOT NULL,
	VAL_UNI DECIMAL (10,2) NOT NULL,
	VAL_TOT DECIMAL (10,2) NOT NULL, --?
	CONSTRAINT FK_VendaItem_Produto FOREIGN KEY (ID_PROD) REFERENCES PRODUTOS (ID_PROD),
	CONSTRAINT FK_VendaItem_VENDAS FOREIGN KEY (NUM_VENDA) REFERENCES VENDAS (NUM_VENDA),
	CONSTRAINT PK_VNDIT1 PRIMARY KEY (NUM_VENDA,NUM_SEQ)
	
);

/*
EXERCÍCIO 2 
Restaurar o arquivo  treino.bak no banco de dados criado.
*/
USE TREINO
RESTORE DATABASE TREINO FROM DISK = 'CAMINHO DO BANCO DE DADOS AQUI'  WITH REPLACE
/*
EXERCÍCIO 3 
Liste todos os clientes com seus nomes e com suas respectivas cidade e estados
*/
SELECT A.NOME_CLIENTE, B.NOME_CIDADE B.UF 
	FROM CLIENTE A
	INNER JOIN CIDADE B
	ON A.ID_CIDADE = B.ID_CIDADE
  
/*
EXERCÍCIO 4 
Liste o código do produto, descrição do produto e descrição das categorias dos produtos que tenham o valor unitário na 
faixa de R$ 10,00 a R$ 1500
*/
SELECT A.ID_PROD, A.NOME_PROD, B.NOME_CATEGORIA, A.PRECO FROM PRODUTOS A
	INNER JOIN CATEGORIA B
	ON A.ID_CATEGORIA = B.ID_CATEGORIA
	WHERE A.PRECO BETWEEN 10 AND 1500;

/*
EXERCÍCIO 5 
Liste o código do produto, descrição do produto e descrição da categorias dos produtos, e também apresente uma coluna condicional  com o  nome de "faixa de preço" 
Com os seguintes critérios
•	preço< 500 : valor da coluna será  igual  "preço abaixo de 500"
•	preço  >= 500 e <=1000 valor da coluna será igual  "preço entre 500 e 1000"
•	preço  > 1000 : valor da coluna será igual  "preço acima de 1000".
*/
SELECT A.ID_PROD, A.NOME_PROD, B.NOME_CATEGORIA, A.PRECO,
CASE
	WHEN A.PRECO < 500 THEN 'PRECO ABAIXO DE 500'
	WHEN A.PRECO >= 500 e <=1000 THEN 'PRECO ENTRE 500 E 1000'
	WHEN A.PRECO > 1000 THEN 'PRECO ACIMA DE 1000' END AS FAIXA_PRECO
	FROM PRODUTOS A
	INNER JOIN CATEGORIA B
	ON A.ID_CATEGORIA = B.ID_CATEGORIA
	
/*
EXERCÍCIO  6
Adicione a coluna faixa_salario na tabela vendedor tipo char(1)
*/
ALTER TABLE VENDEDORES
	ADD COLUMN FAIXA_SALARIO CHAR (1);
/*
EXERCÍCIO 7 
Atualize o valor do campo faixa_salario da tabela vendedor com um update condicional .
Com os seguintes critérios
•	salario <1000 ,atualizar faixa = c
•	salario >=1000  and <2000 , atualizar faixa = b
•	salario >=2000  , atualizar faixa = a

**VERIFIQUE SE OS VALORES FORAM ATUALIZADOS CORRETAMENTE
*/
UPDATE VENDEDORES 
SET FAIXA_SALARIO = CASE
	WHEN SALARIO < 1000 THEN 'C'
	WHEN SALARIO >= 1000 AND SALARIO < 2000 THEN 'B'
	WHEN SALARIO >= 2000 THEN 'A'
	END;
/*
EXERCÍCIO 8
Listar em ordem alfabética os vendedores e seus respectivos salários, mais uma coluna, simulando aumento de 12% em seus salários.
*/
SELECT A.NOME_VENDEDOR, 
	   A.SALARIO AS SALARIO_ATUAL, 
       (A.SALARIO * 1.12) AS SALARIO_AUMENTADO 
FROM VENDEDORES A 
ORDER BY A.NOME_VENDEDOR ASC

/*EXERCÍCIO 9
Listar os nome dos vendedores, salário atual , coluna calculada com salario novo + reajuste de 18% sobre o salário atual, calcular  a coluna acréscimo e calcula uma coluna salario novo+ acresc.
Critérios
Se o vendedor for  da faixa “C”, aplicar  R$ 120 de acréscimo , outras faixas de salario acréscimo igual a 0(Zero )
*/

--DECLARANDO VARIAVEIS 

DECLARE @ACRESCIMO DECIMAL (10,2) = 120;
DECLARE @PCT_AUMENTO DECIMAL (10,2) = 1.18;

--SELECT DE DADOS

SELECT A.NOME_VENDEDOR, 
	   A.FAIXA_SALARIO, 
	   A.SALARIO AS SALARIO_ATUAL, 
	   A.SALARIO * @PCT_AUMENTO AS SALARIO_NOVO
	   CASE WHEN A.FAIXA_SALARIO = 'C' THEN @ACRESCIMO ELSE 0 END ACRESC
	   CASE WHEN A.FAIXA_SALARIO = 'C' THEN @ACRESCIMO + A.SALARIO * @PCT_AUMENTO 
		ELSE A.SALARIO * @PCT_AUMENTO END SALARIO_NOVO_ACRESC
FROM VENDEDORES A
ORDER BY 4 DESC
/*
EXERCÍCIO 10
Listar o nome e salários do vendedor com menor salario.
*/
SELECT TOP 1 A.NOME_VENDEDOR, 
	   A.SALARIO
FROM VENDEDORES A
ORDER BY SALARIO ASC
/*
EXERCÍCIO 11
Quantos vendedores ganham acima de R$ 2.000,00 de salário fixo?
*/
SELECT COUNT (*) AS QTD_VENDEDORES_ACIMA_2000
FROM VENDEDORES
WHERE SALARIO > 2000;
/*
EXERCÍCIO 12
Adicione o campo valor_total tipo decimal(10,2) na tabela venda.
*/
ALTER TABLE VENDAS ADD COLUMN VALOR_TOTAL DECIMAL (10,2);
/*
EXERCÍCIO 13
Atualize o campo valor_total da tabela venda, com a soma dos produtos das respectivas vendas.
*/
UPDATE VENDAS SET VALOR_TOTAL 
/*
EXERCÍCIO 14
Realize a conferencia do exercício anterior, certifique-se que o valor  total de cada venda e igual ao valor total da soma dos  produtos da venda, listar as vendas em que ocorrer diferença.
*/

/*
EXERCÍCIO 15
Listar o número de produtos existentes, valor total , média do valor unitário referente ao mês 07/2018 agrupado por venda.
*/

/*
EXERCÍCIO 16
Listar o número de vendas, Valor do ticket médio, menor ticket e maior ticket referente ao mês 07/2017.
*/



/*
EXERCÍCIO 17
Atualize o status das notas abaixo de normal(N) para cancelada (C)
--15,34,80,104,130,159,180,240,350,420,422,450,480,510,530,560,600,640,670,714

*/

/*
EXERCÍCIO 18
Quais clientes realizaram mais de 70 compras?
*/

/*
EXERCÍCIO 19
Listar os produtos que estão incluídos em vendas que a quantidade total de produtos seja superior a 100 unidades.
*/

/*
EXERCÍCIO 20
Trazer total de vendas do ano 2017 por categoria e apresentar total geral
*/

/*
EXERCÍCIO 21
Listar total de vendas do ano 2017 por categoria e mês a mês apresentar subtotal dos meses e total geral ano.
*/

/*
EXERCÍCIO 22
Listar total de vendas por vendedores referente ao ano 2017, mês a mês apresentar subtotal do mês e total geral.
*/

/*
EXERCÍCIO 23
Listar os top 10 produtos mais vendidos por valor total de venda com suas respectivas categorias
*/

/*
EXERCÍCIO 24
Listar os top 10 produtos mais vendidos por valor total de venda com suas respectivas categorias, calcular seu percentual de participação com relação ao total geral.
*/

/*
EXERCÍCIO 25
Listar apenas o produto mais vendido de cada Mês com seu  valor total referente ao ano de 2017.
*/

/*
EXERCÍCIO 26
Lista o cliente e a data da última compra de cada cliente.
*/

/*
EXERCÍCIO 27
Lista o a data da última venda de cada produto.
*/



