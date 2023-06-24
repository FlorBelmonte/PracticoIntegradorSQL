use practicointegrador;

--- 1) CREACION DE TABLAS:
--- Crea la tabla "Productos" con al menos los campos: "id" (clave primaria), "nombre", "precio", "stock".
--- Crea la tabla "Clientes" con al menos los campos: "id" (clave primaria), "nombre", "correo", "dirección".
--- Crea la tabla "Compras" con al menos los campos: "id" (clave primaria), "cliente_id" (clave externa), "producto_id" (clave externa), "cantidad", "fecha".

CREATE TABLE Cliente (
  idCliente INT PRIMARY KEY,
  nombre VARCHAR(50),
  email VARCHAR(50),
  direccion VARCHAR(100)
);

CREATE TABLE Producto (
  idProducto INT PRIMARY KEY,
  nombre VARCHAR(50),
  precio DECIMAL(10, 2),
  stock INT,
  descuento DECIMAL (10,2)
);

CREATE TABLE Compra (
  idCompra INT PRIMARY KEY,
  idCliente INT,
  cantidad INT,
  fecha DATE,
  idProducto INT,
  FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente),
  FOREIGN KEY (idProducto) REFERENCES Producto(idProducto)
);




--- 3) MODIFICACIÓN DE TABLA:
--- Agrega una columna "descuento" a la tabla "Productos" utilizando ALTER TABLE.

ALTER TABLE producto ADD COLUMN descuento DECIMAL(10, 2);

--- Modifica el tipo de datos de la columna "precio" en la tabla "Productos" utilizando ALTER COLUMN.

ALTER TABLE Producto modify precio tinyint not null;

--- 4) CONSULTAS:
--- Realiza una consulta utilizando SELECT JOIN para obtener la información de los productos comprados por cada cliente.

SELECT Cliente.idCliente, Cliente.nombre, Compra.idCompra, Compra.idProducto, Compra.cantidad, Compra.fecha
FROM Cliente
JOIN Compra ON Cliente.idCliente = Compra.idCliente;



