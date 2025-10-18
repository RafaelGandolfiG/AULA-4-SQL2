--02_insert_variaveis_avançado.sql

USE db1410_vendas;
GO

--insere a coluna de valor total que falta na tabela de vendas
ALTER TABLE vendas
ADD valor_total DECIMAL(10,2);

/*
a logica aqui é realizar multiplas inserções
de forma controlada, usando variaveis
para armazenar os dados
*/

--iniciar a transação
BEGIN TRANSACTION;


DECLARE @cliente_id INT = 1; --cliente para o pedido (caio)
DECLARE @produto_id INT = 2; --produto comprado (notebook)
DECLARE @quantidade INT = 3; --quantidade comprada (3 unidades)
DECLARE @valor_total DECIMAL(10,2); --valor total do pedido
DECLARE @data_venda DATETIME = GETDATE(); --data atual da venda
DECLARE @status_transacao VARCHAR(50);

--calcular o valor total da venda
SELECT @valor_total = p.preco*@quantidade
FROM produtos p
WHERE p.produto_id = @produto_id;

--validação para garantir que a quantidade seja valida
IF @quantidade <=0
BEGIN
	SET @status_transacao='Falha: quantidade invalida';
	--reverte a transacao caso a quantidade seja invalida
	ROLLBACK TRANSACTION; 
	PRINT @status_transacao;
	RETURN;
END

--inserindo outra venda usando nosso novo metodo
INSERT INTO vendas
(cliente_id,produto_id,quantidade,valor_total,data_venda)
VALUES
	(@cliente_id,@produto_id,@quantidade,@valor_total,@data_venda)

IF @@ERROR<>0
BEGIN
	SET @status_transacao='Falha: erro na inserção da venda';
	ROLLBACK TRANSACTION;
	PRINT @status_transacao;
	RETURN
END

--se todas as inserções forem ok, confirma a trasação
SET @status_transacao='Sucesso: vendas inseridas com sucesso'

COMMIT TRANSACTION;

--Verificando
SELECT * FROM vendas;



/*=========================================
               CASO DE FALHA
=========================================*/

BEGIN TRANSACTION

DECLARE @cliente_id INT = 1; --cliente para o pedido (caio)
DECLARE @produto_id INT = 2; --produto comprado (notebook)
DECLARE @quantidade INT = 3; --quantidade comprada (3 unidades)
DECLARE @valor_total DECIMAL(10,2); --valor total do pedido
DECLARE @data_venda DATETIME = GETDATE(); --data atual da venda
DECLARE @status_transacao VARCHAR(50);

SET @quantidade=-1;
SET @cliente_id=1;
SET @produto_id=1;
SET @data_venda= GETDATE();

SELECT @valor_total = p.preco*@quantidade
FROM produtos p
WHERE p.produto_id = @produto_id;

IF @quantidade <=0
BEGIN
	SET @status_transacao='Falha: quantidade invalida';
	--reverte a transacao caso a quantidade seja invalida
	ROLLBACK TRANSACTION; 
	PRINT @status_transacao;
	RETURN;
END

INSERT INTO vendas
(cliente_id,produto_id,quantidade,valor_total,data_venda)
VALUES
	(@cliente_id,@produto_id,@quantidade,@valor_total,@data_venda)

COMMIT TRANSACTION;