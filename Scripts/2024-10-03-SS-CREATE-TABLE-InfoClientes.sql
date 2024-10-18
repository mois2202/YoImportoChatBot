/* =========================================
* Author : SAMUEL SANCHEZ
* Cre.	 : 14-10-24
* ========================================= */ 
CREATE TABLE InfoClientes (
	idCliente 	SERIAL PRIMARY KEY ,
	nombre		VARCHAR(200),
	edad		int,
	FOREIGN KEY (idCliente) REFERENCES Clientes(idCliente)ON DELETE CASCADE ON UPDATE CASCADE)