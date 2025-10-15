-- Borrar el vivero "Vivero Norte"
-- Se borra en cascada:
--  Zonas del vivero
--  Registros zona_producto
--  Asignaciones de empleados a esas zonas
--  Los pedidos realizados en ese vivero se eliminan
--  Las lineas de los pedidos se eliminan al eliminarse el pedido
DELETE FROM vivero
WHERE id_vivero = 1;

-- Borrar el producto "Aloe Vera"
-- Se borra en cascada:
--  Registros zona_producto que contienen este producto
--  Las líneas de pedido de este producto se ponen a NULL
DELETE FROM producto
WHERE id_producto = 1;

-- Borrar el cliente "Pedro Ramos"
-- Se borra en cascada:
--  Bonificaciones asociadas
-- Se actualiza con SET NULL:
--  id_cliente en pedidos que tenía asignados
DELETE FROM cliente
WHERE id_cliente = 1;

-- Borrar el empleado "María López"
-- Se borra en cascada:
--  Asignaciones de empleado en las distintas zonas
-- Se actualiza con SET NULL:
--  id_empleado en pedidos que gestionaba
DELETE FROM empleado
WHERE id_empleado = 1;

-- Borrar la zona "Exterior" del vivero Norte
-- Se borra en cascada:
--  Registros zona_producto asociados a la zona
--  Asignaciones de empleados en la zona
-- Se actualiza con SET NULL:
--  id_zona en pedidos que estaban asociados a esta zona
DELETE FROM zona
WHERE id_zona = 1;
