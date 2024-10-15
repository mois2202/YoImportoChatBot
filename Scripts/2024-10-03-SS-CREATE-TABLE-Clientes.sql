CREATE TABLE Clientes (
	idCliente 	SERIAL PRIMARY KEY,
	numero 		INT unique NOT NULL,
	ultimoMsj	DATE,
	seguimiento	VARCHAR(200)
)