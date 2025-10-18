--delete_com_cascade.sql

CREATE DATABASE db1410_fallscompany;
GO

USE db1410_fallscompany;
GO

DROP TABLE IF EXISTS clientes
CREATE TABLE clientes(
	cliente_id INT PRIMARY KEY IDENTITY(1,1),
	nome_cliente VARCHAR (100),
	email_cliente VARCHAR(100)
);

DROP TABLE IF EXISTS pedidos
CREATE TABLE pedidos(
	pedido_id INT PRIMARY KEY IDENTITY(1,1),
	cliente_id INT,
	data_pedido DATETIME,
	valor_total DECIMAL(10,2),
	FOREIGN KEY (cliente_id)
		REFERENCES clientes(cliente_id)
		ON DELETE CASCADE
);

--Inserir 4 clientes 
INSERT INTO clientes
(nome_cliente,email_cliente)
VALUES
('Rafael','rafael@gmail.com'),
('Rodrigo','rodrigo@gmail.com'),
('Caio','caio@gmail.com'),
('Gustavo','gustavo@gmail.com');

--inserir 4 pedidos
INSERT INTO pedidos
(cliente_id,data_pedido,valor_total)
VALUES
(1,'2025-01-01',1200.00),
(2,'2025-01-02',2500.00),
(3,'2025-01-04',3200.00),
(4,'2025-01-08',5000.00);

--exibir as duas tabelas
SELECT * FROM clientes
SELECT * FROM pedidos

--realizar a exclusão de um cliente da tabela clientes
--usando try e transaction

BEGIN TRY
	BEGIN TRANSACTION
		DELETE FROM clientes WHERE cliente_id = 1;
	COMMIT TRANSACTION
	PRINT 'EXCLUSAO REALIZADA COM SUCESSO'
END TRY

BEGIN CATCH
	IF @@TRANCOUNT>0
	BEGIN
		ROLLBACK TRANSACTION
	END
	PRINT'ERRO DURANTE A EXCLUSAO: '+ ERROR_MESSAGE();
END CATCH;