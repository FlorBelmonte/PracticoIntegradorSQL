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


-- Crea una VIEW que muestre los productos con descuento.

CREATE VIEW ProductosConDescuento AS
SELECT * FROM Producto WHERE descuento > 0;

select * from Productoscondescuento;

-- Crea un INDEX en la columna "nombre" de la tabla "Productos" para mejorar la velocidad de las consultas.

CREATE INDEX idx_nombre ON Producto (nombre);

-- 5) Procedimientos almacenados:
-- ● Crea un STORE PROCEDURE que calcule el total de ventas para un cliente dado.

DELIMITER //

CREATE PROCEDURE calcular_total_ventas(IN cliente_id INT, OUT total_ventas DECIMAL(10, 2))
BEGIN
    SELECT SUM(p.precio * c.cantidad) INTO total_ventas
    FROM Compra c
    JOIN Producto p ON c.idProducto = p.idProducto
    WHERE c.idCliente = cliente_id;
END //

DELIMITER ;

-- Utiliza el STORE PROCEDURE para obtener el total de ventas de un cliente específico.

CALL calcular_total_ventas(12, @total_ventas_cliente); --ejemplo con Cliente Id 12

SELECT @total_ventas_cliente;

--6. Funciones:
--● Crea una función que calcule el promedio de precios de los productos.

CREATE DEFINER=`root`@`localhost` FUNCTION `CalcularPromedioDePrecios`() RETURNS decimal(10,0)
    READS SQL DATA
BEGIN
  DECLARE promedio DECIMAL;
  SELECT AVG(precio) INTO promedio
  FROM Producto;
  RETURN promedio;
END

--● Utiliza la función para obtener el promedio de precios de todos los productos.
select practicointegrador.CalcularPromedioDePrecios();

select CalcularPromedioDePrecios() as PromedioDePrecios;

--7. Transacciones:
--● Crea una transacción que inserte un nuevo cliente y una nueva orden de compra al mismo tiempo.
--● Asegúrate de que la transacción se ejecute correctamente y se haga un rollback en caso de error.

START TRANSACTION;

SAVEPOINT savepoint_name;

INSERT INTO Cliente (idCliente, nombre, email, direccion)
VALUES (102, 'Joaquin', 'cliente@example.com', 'Dirección 1');

INSERT INTO Compra (idCompra, idCliente, cantidad, fecha, idProducto)
VALUES (107, 102, 5, '2023-07-05 19:30:00', 1);

COMMIT;

ROLLBACK TO SAVEPOINT savepoint_name;


-- 8. Triggers:
-- ● Crea un TRIGGER que actualice el stock de un producto después de realizar una orden de compra.
-- ● Verifica que el TRIGGER se dispare correctamente y actualice el stock de manera adecuada.

DELIMITER //

CREATE TRIGGER verificacionStock BEFORE INSERT ON compra --Creo un trigger BEFORE para que verifique el stock del producto
FOR EACH ROW
BEGIN
    DECLARE stockActual INT;
    
    SELECT stock INTO stockActual FROM Producto WHERE idProducto = NEW.idProducto;
    
    IF stockActual < NEW.cantidad THEN 
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No hay suficiente stock para realizar la compra.';
    END IF;
END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER actualizarStock AFTER INSERT ON Compra -- Creo un trigger AFTER para que me actualice el stock luego de una compra 
FOR EACH ROW
BEGIN
    UPDATE Producto
    SET stock = stock - NEW.cantidad
    WHERE idProducto = NEW.idProducto;
END //

DELIMITER ;
INSERT INTO Compra (idCompra, idCliente, cantidad, fecha, idProducto) 
VALUES (124, 102, 1, '2023-07-05', 6);

SELECT stock FROM Producto WHERE idProducto = 6;