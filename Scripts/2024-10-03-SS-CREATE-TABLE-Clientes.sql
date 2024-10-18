/* =========================================
* Author : SAMUEL SANCHEZ
* Cre.	 : 14-10-24
* ========================================= */ 
CREATE TABLE Clientes (
	idCliente 	SERIAL PRIMARY KEY,
	numero 		VARCHAR(20) unique NOT NULL,
	ultimoMsj	DATE,
	seguimiento	VARCHAR(200)
)