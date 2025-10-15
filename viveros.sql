--------- Si estamos dentro de la base de datos eliminar las dos lineas siguientes
CREATE DATABASE viveros;
\c viveros
---------

CREATE TABLE vivero (
	id_vivero serial4 NOT NULL,
	nombre varchar NOT NULL,
	latitud float8 NOT NULL,
	longitud float8 NOT NULL,
	CONSTRAINT vivero_pk PRIMARY KEY (id_vivero)
);

CREATE TABLE zona (
	id_zona serial4 NOT NULL,
	nombre varchar NOT NULL,
	latitud float8 NOT NULL,
	longitud float8 NOT NULL,
	id_vivero int4 NOT NULL,
	CONSTRAINT zona_pk PRIMARY KEY (id_zona),
    CONSTRAINT zona_vivero_fk FOREIGN KEY (id_vivero) REFERENCES vivero(id_vivero) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE producto (
	id_producto serial4 NOT NULL,
	nombre varchar NOT NULL,
    tipo varchar NOT NULL,
    CONSTRAINT producto_check CHECK (tipo IN ('Jardinería', 'Planta', 'Decoración')),
	CONSTRAINT producto_pk PRIMARY KEY (id_producto),
	CONSTRAINT producto_unique UNIQUE (nombre)
);

CREATE TABLE zona_producto (
	cantidad int4 NOT NULL,
	id_producto int4 NOT NULL,
	id_zona int4 NOT NULL,
	id_vivero int4 NOT NULL,
	CONSTRAINT zona_producto_pk PRIMARY KEY (id_producto, id_zona),
	CONSTRAINT zona_producto_check CHECK ((cantidad >= 0)),
    CONSTRAINT zona_producto_producto_fk FOREIGN KEY (id_producto) REFERENCES producto(id_producto) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT zona_producto_vivero_fk FOREIGN KEY (id_vivero) REFERENCES vivero(id_vivero) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT zona_producto_zona_fk FOREIGN KEY (id_zona) REFERENCES zona(id_zona) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE empleado (
	id_empleado serial4 NOT NULL,
	nombre varchar NOT NULL,
	dni varchar NOT NULL,
	CONSTRAINT empleado_pk PRIMARY KEY (id_empleado),
	CONSTRAINT empleado_unique UNIQUE (dni)
);

CREATE TABLE asignacion_empleado (
	id_asignacion serial4 NOT NULL,
	puesto varchar NOT NULL,
	fecha_inicio date NOT NULL,
	fecha_fin date NULL,
	id_empleado int4 NOT NULL,
	id_vivero int4 NOT NULL,
	id_zona int4 NOT NULL,
	CONSTRAINT asignacion_empleado_pk PRIMARY KEY (id_asignacion),
	CONSTRAINT check_fecha CHECK (((fecha_fin IS NULL) OR (fecha_fin >= fecha_inicio))),
	CONSTRAINT asignacion_empleado_empleado_fk FOREIGN KEY (id_empleado) REFERENCES empleado(id_empleado) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT asignacion_empleado_vivero_fk FOREIGN KEY (id_vivero) REFERENCES vivero(id_vivero) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT asignacion_empleado_zona_fk FOREIGN KEY (id_zona) REFERENCES zona(id_zona) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE cliente (
	id_cliente serial4 NOT NULL,
	nombre varchar NOT NULL,
	dni varchar NULL,
	fidelizado bool DEFAULT false NOT NULL,
	email varchar NULL,
	CONSTRAINT cliente_pk PRIMARY KEY (id_cliente),
	CONSTRAINT cliente_check CHECK ((((fidelizado = true) AND (dni IS NOT NULL) AND (email IS NOT NULL)) OR ((fidelizado = false) AND (dni IS NULL) AND (email IS NULL)))),
	CONSTRAINT cliente_unique UNIQUE (dni),
	CONSTRAINT cliente_unique_1 UNIQUE (email)
);

CREATE TABLE pedido (
	id_pedido serial4 NOT NULL,
	fecha date NOT NULL,
	id_cliente int4 NOT NULL,
	id_vivero int4 NOT NULL,
	id_zona int4 NOT NULL,
	id_empleado int4 NOT NULL,
	total int4 NOT NULL,
	CONSTRAINT pedido_pk PRIMARY KEY (id_pedido),
    CONSTRAINT pedido_cliente_fk FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente) ON DELETE SET NULL,
    CONSTRAINT pedido_empleado_fk FOREIGN KEY (id_empleado) REFERENCES empleado(id_empleado) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT pedido_vivero_fk FOREIGN KEY (id_vivero) REFERENCES vivero(id_vivero) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT pedido_zona_fk FOREIGN KEY (id_zona) REFERENCES zona(id_zona) ON DELETE SET NULL
);

CREATE TABLE pedido_linea (
	id_linea serial4 NOT NULL,
	cantidad int4 NOT NULL,
	precio_unitario float8 NOT NULL,
	id_pedido int4 NOT NULL,
	id_producto int4 NOT NULL,
	CONSTRAINT pedido_linea_pk PRIMARY KEY (id_linea),
	CONSTRAINT check_cantidad CHECK ((cantidad > 0)),
	CONSTRAINT pedido_linea_check CHECK ((precio_unitario >= (0.0))),
    CONSTRAINT pedido_linea_pedido_fk FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT pedido_linea_producto_fk FOREIGN KEY (id_producto) REFERENCES producto(id_producto) ON DELETE SET NULL
);

CREATE TABLE bonificacion (
	id_bonificacion serial4 NOT NULL,
	cantidad float8 NOT NULL,
	id_cliente int4 NOT NULL,
	CONSTRAINT bonficiacion_pk PRIMARY KEY (id_bonificacion),
    CONSTRAINT bonficiacion_cliente_fk FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente) ON DELETE CASCADE ON UPDATE CASCADE
);

--- Insertar elementos en la base de datos
-- Insertar viveros
INSERT INTO vivero (nombre, latitud, longitud) VALUES
('Vivero Norte', 28.4682, -16.2546),
('Vivero Sur', 27.9876, -15.4567),
('Vivero Este', 28.1234, -16.7890),
('Vivero Oeste', 28.5678, -16.1111),
('Vivero Central', 28.0000, -16.0000);

-- Insertar zonas
INSERT INTO zona (nombre, latitud, longitud, id_vivero) VALUES
('Exterior', 28.4681, -16.2547, 1),
('Invernadero', 28.4683, -16.2545, 1),
('Almacén', 27.9877, -15.4568, 2),
('Zona Decoración', 28.1235, -16.7891, 3),
('Jardín Muestra', 28.5679, -16.1112, 4),
('Garaje Plantas', 28.4684, -16.2544, 1),
('Sección Macetas', 28.4685, -16.2543, 1),
('Zona de Sustratos', 27.9878, -15.4569, 2),
('Abonos', 28.1236, -16.7892, 3),
('Expositor Rosales', 28.5680, -16.1113, 4);

-- Insertar productos
INSERT INTO producto (nombre, tipo) VALUES
('Aloe Vera', 'Planta'),
('Maceta cerámica', 'Decoración'),
('Sustrato universal', 'Jardinería'),
('Abono líquido', 'Jardinería'),
('Rosa roja', 'Planta'),
('Helecho', 'Planta'),
('Orquídea', 'Planta'),
('Maceta de barro', 'Decoración'),
('Fertilizante orgánico', 'Jardinería'),
('Set de herramientas', 'Jardinería');

-- Insertar en zona_producto
INSERT INTO zona_producto (cantidad, id_producto, id_zona, id_vivero) VALUES
(50, 1, 1, 1),
(100, 2, 2, 1),
(200, 3, 3, 2),
(80, 4, 4, 3),
(60, 5, 5, 4),
(30, 6, 6, 1),
(20, 7, 7, 1),
(50, 8, 8, 2),
(40, 9, 9, 3),
(15, 10, 10, 4);

-- Insertar empleados
INSERT INTO empleado (nombre, dni) VALUES
('María López', '11111111A'),
('Juan Pérez', '22222222B'),
('Ana Gómez', '33333333C'),
('Carlos Díaz', '44444444D'),
('Lucía Torres', '55555555E'),
('Elena Márquez', '66666666K'),
('Sergio Ruiz', '77777777L');

-- Insertar asignaciones
INSERT INTO asignacion_empleado (puesto, fecha_inicio, fecha_fin, id_empleado, id_vivero, id_zona) VALUES
('Vendedor', '2025-01-10', NULL, 1, 1, 1),
('Encargado', '2024-10-01', NULL, 2, 1, 2),
('Mozo de almacén', '2025-03-05', NULL, 3, 2, 3),
('Decorador', '2024-11-20', NULL, 4, 3, 4),
('Jardinero', '2025-02-15', NULL, 5, 4, 5),
('Vendedor', '2025-05-01', NULL, 6, 1, 6),
('Mozo de almacén', '2025-06-01', NULL, 7, 2, 8);

-- Insertar clientes
INSERT INTO cliente (nombre, dni, fidelizado, email) VALUES
('Anonimo', NULL, false, NULL),
('Pedro Ramos', '66666666F', true, 'pedro@example.com'),
('Laura Ruiz', '77777777G', true, 'laura@example.com'),
('Mario Martín', '88888888H', true, 'mario@example.com'),
('Carmen Soto', '99999999J', true, 'carmen@example.com');

-- Insertar pedidos
INSERT INTO pedido (fecha, id_cliente, id_vivero, id_zona, id_empleado, total) VALUES
('2025-03-10', 1, 1, 1, 1, 120),
('2025-03-15', 2, 1, 2, 2, 80),
('2025-04-01', 3, 2, 3, 3, 200),
('2025-04-10', 4, 3, 4, 4, 150),
('2025-04-20', 1, 4, 5, 5, 60),
('2025-05-05', 5, 1, 6, 6, 90),
('2025-05-06', 1, 1, 7, 1, 120),
('2025-05-07', 2, 2, 8, 7, 150),
('2025-05-08', 3, 3, 9, 4, 200),
('2025-05-09', 4, 4, 10, 5, 180);

-- Insertar en líneas de pedido
INSERT INTO pedido_linea (cantidad, precio_unitario, id_pedido, id_producto) VALUES
(2, 15.50, 1, 1),
(3, 10.00, 2, 2),
(5, 8.00, 3, 3),
(1, 25.00, 4, 4),
(2, 12.50, 5, 5),
(1, 12.0, 6, 6),
(2, 15.0, 7, 7),
(3, 8.5, 8, 8),
(2, 20.0, 9, 9),
(1, 25.0, 10, 10);

-- Insertar en bonificaciones
INSERT INTO bonificacion (cantidad, id_cliente) VALUES
(10.5, 3),
(15.0, 2),
(8.0, 3),
(20.0, 4),
(0.0, 5);
