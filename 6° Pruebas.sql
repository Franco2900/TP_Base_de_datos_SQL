USE terminal_automotriz;
-- El mensaje de inserción exitosa esta comentaredo porque genera muchos mensajes cuando se ejecuta el script
-- de carga de datos y eso hace que en algunas computadoras de poco rendimiento se cierre el workbench
-- -----------------------------------------------------------------------------------------------------------------
-- Atributos de la tabla modelo: modelo_vehiculo (PK), nombre
call modeloABM (1, "FORD", 'nuevo'); -- Repetido para testear
-- Si se quita un elemento no olviden añadirlo de vuelta después para que no haya errores con la carga de datos
-- call modeloABM (1, NULL, "eliminar");
-- call modeloABM (1, NULL, "eliminar"); -- Repetido para testear
-- call modeloABM (1, "PEUGEOT", "editar");
-- call modeloABM (2, "HONDA", "editar");
-- call modeloABM (2, NULL, "consulta");

-- Atributos de la tabla linea_montaje: linea (PK), id_modelo_vehiculo
call linea_montajeABM (1, 1, 'nuevo'); -- Repetido para testear
-- Si se quita un elemento no olviden añadirlo de vuelta después para que no haya errores con la carga de datos
-- call linea_montajeABM (1, NULL, "eliminar");
-- call linea_montajeABM (1, NULL, "eliminar"); -- Repetido para testear
-- call linea_montajeABM (1, 2, "editar");
-- call linea_montajeABM (2, 1, "editar");
-- call linea_montajeABM (1, NULL, "consulta");

-- Atributos de la tabla estacion: estacion (PK), funcion, id_linea (PK) 
CALL estacionABM (2, "Pintura", 1, "nuevo"); -- Repetido para testear
-- Si se quita un elemento no olviden añadirlo de vuelta después para que no haya errores con la carga de datos
-- CALL estacionABM (1, NULL, NULL, "eliminar");
-- CALL estacionABM (1, NULL, NULL, "eliminar"); -- Repetido para testear
-- CALL estacionABM (2, "Electricidad", 1, "editar");
-- CALL estacionABM (1, "Chasis", 2, "editar");
-- CALL estacionABM (1, NULL, 2, "consulta");

-- Atributos de la tabla insumo: codigo_insumo (PK), nombre, precio
CALL insumoABM (1, "techo", 250, "nuevo"); -- Repetido para testear
-- Si se quita un elemento no olviden añadirlo de vuelta después para que no haya errores con la carga de datos
-- CALL insumoABM (1, NULL, NULL, "eliminar");
-- CALL insumoABM (1, NULL, NULL, "eliminar");	-- Repetido para testear
-- CALL insumoABM (1, "aceite", 200, "modificar");
-- CALL insumoABM (2, "transmision", 150, "modificar");
-- CALL insumoABM (7, NULL, NULL, "consulta");

-- Atributos de la tabla proveedor: proveedor (PK), nombre
CALL proveedorABM (1, "chasis lanus", "nuevo"); -- Repetido para testear
-- Si se quita un elemento no olviden añadirlo de vuelta después para que no haya errores con la carga de datos
-- CALL proveedorABM (1, NULL, "eliminar");
-- CALL proveedorABM (1, NULL, "eliminar"); -- Repetido para testear
-- CALL proveedorABM (1, "aceite Banfield", "editar");
-- CALL proveedorABM (2, "chasis solano", "editar");
-- CALL proveedorABM (6, NULL, "consulta");

-- Atributos de la tabla: consecionaria (PK), nombre
CALL consecionariaABM (1, "Strianese", "nuevo"); -- Repetido para testear
-- Si se quita un elemento no olviden añadirlo de vuelta después para que no haya errores con la carga de datos
-- CALL consecionariaABM (1, NULL, "eliminar");
-- CALL consecionariaABM (1, NULL, "eliminar"); -- Repetido para testear
-- CALL consecionariaABM (1, "UNLautos", "editar");
-- CALL consecionariaABM (2, "Autos SQL", "editar");
-- CALL consecionariaABM (4, NULL, "consulta");

-- Atributos de la tabla pedido_auto: nro_pedido (PK), fecha_pedido, id_consecionaria
CALL pedidoAutoABM (25, '2019-05-23T14:25:10', 1, 'nuevo'); -- Repetido para testear
-- Si se quita un elemento no olviden añadirlo de vuelta después para que no haya errores con la carga de datos
-- CALL pedidoAutoABM (25, NULL, NULL, "eliminar");
-- CALL pedidoAutoABM (25, NULL, NULL, "eliminar"); -- Repetido para testear
-- CALL pedidoAutoABM (2, "2020-8-22T17:25:10", 1, "modificar");
-- CALL pedidoAutoABM (13, "2019-7-22T17:25:10", 1, "modificar");
-- CALL pedidoAutoABM (1, NULL, NULL, "consulta");

-- Atributos de la tabla detalle_pedido: cantidad, id_modelo_vehiculo, id_nro_pedido (PK)
CALL detallePedidoABM (3, 1, 25, 'nuevo'); -- Repetido para testear
-- Si se quita un elemento no olviden añadirlo de vuelta después para que no haya errores con la carga de datos
-- CALL detallePedidoABM (3, NULL, NULL, "eliminar");
-- CALL detallePedidoABM (3, NULL, NULL, "eliminar"); -- Repetido para testear
-- CALL detallePedidoABM (5, 1, 31, "editar");
-- CALL detallePedidoABM (3, 2, 25, "editar");
-- CALL detallePedidoABM (6, NULL, NULL, "consulta");

-- Atributos de la tabla automovil: chasis (PK), id_modelo_vehiculo, id_nro_pedido
CALL automovilABM (111, 1, 25, 'nuevo'); -- Repetido para testear
-- Si se quita un elemento no olviden añadirlo de vuelta después para que no haya errores con la carga de datos
-- CALL automovilABM (111, NULL, NULL, "eliminar");
-- CALL automovilABM (111, NULL, NULL, "eliminar"); -- Repetido para testear
-- CALL automovilABM (111, 117, 14, "editar");
-- CALL automovilABM (105, 2, 40, "editar");
-- CALL automovilABM (102, NULL, NULL, "consulta");


-- Para probar las funciones 8, 9 y 10 se recomienda trabajar con las tablas intermedias vacias
-- PUNTO 8
CALL pedidoAutoABM (87, '2019-08-23T14:25:10', 1, 'nuevo');
CALL detallePedidoABM (4, 2, 87, 'nuevo');
CALL generarAutomovilConPatenteAzar(87);
SELECT * FROM automovil WHERE id_nro_pedido=87;
SELECT * FROM produccion;
SELECT * FROM automovil order by automovil.id_nro_pedido;

-- PUNTO 9
CALL iniciarMontaje(); -- Colocar una de los chasis generadas al azar en el punto 8
CALL iniciarMontaje(); -- Colocar el mismo chasis para mostrar mensaje de error
SELECT * FROM produccion WHERE produccion.id_estacion=1;
SELECT * FROM produccion;

-- PUNTO 10
CALL finalizarTrabajoEnEstacion(); -- Colocar chasis usado en el punto 9
SELECT * FROM produccion;
SELECT * FROM produccion INNER JOIN automovil ON automovil.chasis = produccion.id_chasis ORDER BY automovil.id_modelo_vehiculo;

-- Para probar las funciones 11, 12 y 13 se recomienda cargar las tablas intermedias
-- PUNTO 11
CALL estadoPedido(13);
CALL estadoPedido(25);
CALL estadoPedido(31);

-- PUNTO 12
CALL solicitarInsumos(13);
CALL solicitarInsumos(25);
CALL solicitarInsumos(31);
CALL solicitarInsumos(87);

-- PUNTO 13	
-- NO OLVIDAR que recibe como parametro una linea de montaje
CALL promedio_fabricacion(1);
CALL promedio_fabricacion(2);

-- PUNTO 14
-- El indice en fecha de egreso se usa porque en el punto 13 necesitamos solo verificar la fecha de egreso de los
-- autos que esten en la última estación