CREATE TABLE LIVROS (
ID INT AUTO_INCREMENT PRIMARY KEY,
TITULO VARCHAR(30) NOT NULL,
AUTOR VARCHAR(30) NOT NULL,
SEXO_AUTOR VARCHAR(15) NOT NULL,
PAGINAS INT NOT NULL,
EDITORA VARCHAR(30) NOT NULL,
VALOR DECIMAL(5,2) NOT NULL,
UF_EDITORA CHAR(2) NOT NULL,
ANO_PUBLICACAO VARCHAR(10) NOT NULL
);

SHOW TABLES;

DESC LIVROS;

USE LIVROS;

-- populando a tabela

INSERT INTO LIVROS(TITULO, AUTOR, SEXO_AUTOR, PAGINAS, EDITORA, VALOR, UF_EDITORA, ANO_PUBLICACAO) VALUES(
'Cavaleiro Real',	'Ana Claudia',	'Feminino',	'465',	'Atlas',	'49,9',	'RJ',	'2009'),
('SQL para leigos',	'João Nunes',	'Masculino',	'450',	'Addison',	'98',	'SP',	2018),
('Receitas Caseiras',	'Celia Tavares',	'Feminino',	'210',	'Atlas',	'45',	'RJ',	'2008'),
Pessoas Efetivas	Eduardo Santos	Masculino	390	Beta	78,99	RJ	2018
Habitos Saudáveis	Eduardo Santos	Masculino	630	Beta	150,98	RJ	2019
A Casa Marrom	Hermes Macedo	Masculino	250	Bubba	60	MG	2016
Estacio Querido	Geraldo Francisco	Masculino	310	Insignia	100	ES	2015
Pra sempre amigas	Leda Silva	Feminino	510	Insignia	78,98	ES	2011
Copas Inesqueciveis	Marco Alcantara	Masculino	200	Larson	130,98	RS	2018
O poder da mente	Clara Mafra	Feminino	120	Continental	56,58	SP	2017



