--CONSULTA PADRÃO
select * from relacional.clientes;
--ATRIBUTOS ESPECIFICIOS E CLAUSULA WHERE
select clientes, sexo, status from relacional.clientes
where status = 'Silver';
--USO DE "OR"
select clientes, sexo, status from relacional.clientes
where status = 'Silver' OR status = 'Platinum';
--USO DE "IN"
select clientes, sexo, status from relacional.clientes
where status IN('Silver','Platinum');
--USO DE NOT
select clientes, sexo, status from relacional.clientes
where status NOT IN('Silver','Platinum');
--USO DE LIKE
select clientes, sexo, status from relacional.clientes
where cliente like '%Alb%';
--OPERADORES DE COMPARAÇÃO
select * from relacional.vendas
where total > 6000;
--BETWEEN
select * from relacional.vendas
where total between 6000 and 8000;
--AGREGAÇÃO
select count(*) from relacional.vendas;
--AGREGAÇÃO COM WHERE
select count(*) from relacional.vendas
where total > 6000;
--AGRUPANDO
select idvendedor, count(idvendedor) from relacional.vendas
group by idvendedor;
--DISTINCT
select distinct status from relacional.clientes;
--INSERT
INSERT INTO relacional.clientes(
	idcliente, cliente, estado, sexo, status)
	VALUES (251, 'Fernando Amaral', 'RS', 'M', 'Silver');
--UPDATE
UPDATE relacional.clientes
	SET estado='MS', status='Platinum'
	WHERE idcliente = 251;
--DELETE
DELETE FROM relacional.clientes
	WHERE idcliente = 251;
--CONTROLE DE TRANSAÇÕES    
--INICIA TRANSAÇÃO
BEGIN;
INSERT INTO relacional.clientes(
	idcliente, cliente, estado, sexo, status)
	VALUES (251, 'Fernando Amaral', 'RS', 'M', 'Silver');
--VERIFICAMOS QUE O REGISTRO ENCONTRA-SE NO BD
SELECT * FROM relacional.clientes WHERE idcliente = 251;
ROLLBACK;
--COMMIT
--VERIFICAMOS QUE O REGISTRO NÃO SE ENCONTRA MAIS NO BD
SELECT * FROM relacional.clientes WHERE idcliente = 251;
--INNER JOINS
--TEMOS 10 VENDEDORES
select COUNT(*) from relacional.vendedores  ;
--TEMOS 400 VENDAS
select COUNT(*) from relacional.vendas ;
--INNER JOIN DEVE RETORNAR 400, POIS TODA VENDA TEM UM VENDEDOR
select count(*) from relacional.vendas as vendas
inner join relacional.vendedores as vendedores  on(vendas.idvendedor = vendedores.idvendedor );
--LEFT JOIN DEVE RETORNAR 400, POIS TODA VENDA TEM VENDEDOR
select count(*)  from relacional.vendas as vendas
left join relacional.vendedores as vendedores  on(vendas.idvendedor = vendedores.idvendedor );
--insere novo vendedores
INSERT INTO Relacional.vendedores(nome) VALUES ('Fernando Amaral');
--RIGHT JOIN DEVE RETORNAR 401 POIS TEMOS 1 VENDEDORES SEM VENDAS
select count(*)  from relacional.vendas as vendas
right join relacional.vendedores as vendedores  on(vendas.idvendedor = vendedores.idvendedor );
--ESTE SCRIPT PARA VER OS 1 ULTIMOS REGISTROS
select *  from relacional.vendas as vendas
right join relacional.vendedores as vendedores  on(vendas.idvendedor = vendedores.idvendedor ) order by idvenda desc limit 1;


-----------------------------------------------------------------------------
--Exercício 1: Compras de um cliente específico
-- * Campos: Nome do cliente, produto, quantidade, valor total, data da venda
-- * Filtros: Código do Cliente;

-- criando a view comprascliente, que conterá o resultado da consulta
CREATE VIEW comprascliente AS 
select clientes.idcliente, clientes.cliente, produtos.produto, itensvenda.quantidade, itensvenda.valortotal, vendas.total, vendas.data 
from relacional.itensvenda as itensvenda 
join relacional.vendas as vendas on itensvenda.idvenda = vendas.idvenda 
join relacional.produtos as produtos on itensvenda.idproduto = produtos.idproduto 
join relacional.clientes as clientes on vendas.idcliente = clientes.idcliente;

-- testando se as somas dos valores de cada produto batem com o valor total da compra
select cliente, sum(quantidade), sum(valortotal), total 
from comprascliente 
group by cliente, total;


-----------------------------------------------------------------------------
--Exercício 2: Lista dos 5 Melhores/Piores Vendedores (2 consultas)
-- * Campos: Nome do vendedor, total de vendas
-- * Agrupados por vendedor
-- * Ordenados pelo total de vendas

-- 5 Melhores vendedors:
select vendedores.nome, count(*) as totalvendas 
from relacional.vendas as vendas 
join relacional.vendedores as vendedores on vendas.idvendedor = vendedores.idvendedor 
group by vendedores.nome 
order by totalvendas desc limit 5;

-- 5 Piores vendedores:
select vendedores.nome, count(*) as totalvendas 
from relacional.vendas as vendas 
join relacional.vendedores as vendedores on vendas.idvendedor = vendedores.idvendedor 
group by vendedores.nome 
order by totalvendas limit 5;

-- Exercício 3: Lista dos Produtos mais vendidos:
select produto as produto, sum(quantidade) as totalvendas 
from relacional.itensvenda as itensvenda 
join relacional.produtos as produtos on itensvenda.idproduto = produtos.idproduto 
group by produto 
order by totalvendas desc;

-- Exercício 4: Lista de Produtos com filtro de data;
-- * Campos: Nome do produto, quantidade, dia, mês e ano
select produto as produto, quantidade, 
		extract(day from data) as dia, 
		extract(month from data) as mes, 
		extract(year from data) as ano 
from relacional.itensvenda as itensvenda 
join relacional.produtos as produtos on itensvenda.idproduto = produtos.idproduto 
join relacional.vendas as vendas on vendas.idvenda = itensvenda.idvenda;

-- Exercício 5: Lista de descontos por produto e vendedor
-- * Campos: nome do produto, vendedor, total de descontos
-- Ordenados por produto e total de descontos

select produto, nome as vendedor, sum(desconto) as totaldescontos 
from relacional.itensvenda as itensvenda 
join relacional.vendas as vendas on itensvenda.idvenda = vendas.idvenda 
join relacional.produtos as produtos on itensvenda.idproduto = produtos.idproduto 
join relacional.vendedores as vendedores on vendas.idvendedor = vendedores.idvendedor 
group by vendedor, produto 
order by produto, totaldescontos desc;

