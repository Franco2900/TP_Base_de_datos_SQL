USE terminal_automotriz;
-- -----------------------------------------------------------------------------------------------------------------
-- Atributos de la tabla modelo: modelo_vehiculo (PK), nombre
call modeloABM (1, "FORD", 'nuevo');
call modeloABM (2, "FIAT", 'nuevo');

-- Atributos de la tabla linea_montaje: linea (PK), id_modelo_vehiculo
call linea_montajeABM (1, 1, 'nuevo');
call linea_montajeABM (2, 2, 'nuevo');

-- Atributos de la tabla estacion: estacion (PK), funcion, id_linea (PK) 
CALL estacionABM (1, "Chasis", 1, "nuevo");
CALL estacionABM (2, "Pintura", 1, "nuevo"); 
CALL estacionABM (3, "Tren delantero y trasero", 1, "nuevo");
CALL estacionABM (4, "Electricidad", 1, "nuevo");
CALL estacionABM (5, "Motorizacion y banco de prueba", 1, "nuevo");
CALL estacionABM (1, "Chasis", 2, "nuevo");
CALL estacionABM (2, "Pintura", 2, "nuevo");
CALL estacionABM (3, "Tren delantero y trasero", 2, "nuevo");
CALL estacionABM (4, "Electricidad", 2, "nuevo");
CALL estacionABM (5, "Motorizacion y banco de prueba", 2, "nuevo");

-- Atributos de la tabla insumo: codigo_insumo (PK), nombre, precio
CALL insumoABM (1, "techo", 250, "nuevo");
CALL insumoABM (2, "puertas", 350, "nuevo");
CALL insumoABM (3, "carroceria", 550, "nuevo");
CALL insumoABM (9, "hule", 30, "nuevo");
CALL insumoABM (10, "remaches", 47, "nuevo");
CALL insumoABM (12, "cable", 99, "nuevo");
CALL insumoABM (13, "tablero", 300, "nuevo");
CALL insumoABM (14, "ruedas", 400, "nuevo");
CALL insumoABM (15, "anticorrosivo", 80, "nuevo");
CALL insumoABM (16, "pintura", 90, "nuevo");
CALL insumoABM (17, "laca", 100, "nuevo");
CALL insumoABM (18, "aceite de motor", 110, "nuevo");
CALL insumoABM (19, "refrigerante", 85, "nuevo");
CALL insumoABM (20, "liquido de frenos", 96, "nuevo");
CALL insumoABM (21, "motor", 500, "nuevo");
CALL insumoABM (22, "transmision", 350, "nuevo");
CALL insumoABM (23, "ejes", 250, "nuevo");
CALL insumoABM (24, "paragolpes", 250, "nuevo");
CALL insumoABM (25, "faros", 220, "nuevo");

-- Atributos de la tabla proveedor: proveedor (PK), nombre
CALL proveedorABM (1, "chasis lanus", "nuevo");
CALL proveedorABM (2, "chasis banfield", "nuevo");
CALL proveedorABM (3, "chasis avellaneda", "nuevo");
CALL proveedorABM (4, "pinturas lanus", "nuevo");
CALL proveedorABM (5, "pinturas TRIMAX", "nuevo");
CALL proveedorABM (6, "pinturas Sherwin Williams", "nuevo");
CALL proveedorABM (7, "trenes lanus", "nuevo");
CALL proveedorABM (8, "electro banfield", "nuevo");
CALL proveedorABM (9, "electricidad lanus", "nuevo");
CALL proveedorABM (10, "casa del auto", "nuevo");

-- Atributos de la tabla: consecionaria (PK), nombre
CALL consecionariaABM (1, "Strianese", "nuevo");
CALL consecionariaABM (2, "Elian Autos", "nuevo");
CALL consecionariaABM (3, "Auto Next", "nuevo");
CALL consecionariaABM (4, "Él rey de las barredoras", "nuevo");

-- Atributos de la tabla pedido_auto: nro_pedido (PK), fecha_pedido, id_consecionaria
CALL pedidoAutoABM (25, '2019-05-23T14:25:10', 1, 'nuevo');
CALL pedidoAutoABM (13, '2019-06-13T16:25:10', 3, 'nuevo');
CALL pedidoAutoABM (31, '2019-08-22T17:25:10', 2, 'nuevo');

-- Atributos de la tabla detalle_pedido: cantidad, id_modelo_vehiculo, id_nro_pedido (PK)
CALL detallePedidoABM (3, 1, 25, 'nuevo');
CALL detallePedidoABM (5, 2, 13, 'nuevo');
CALL detallePedidoABM (6, 1, 31, 'nuevo');

-- Atributos de la tabla automovil: chasis (PK), id_modelo_vehiculo, id_nro_pedido
CALL automovilABM (111, 1, 25, 'nuevo');
CALL automovilABM (222, 1, 25, 'nuevo');
CALL automovilABM (333, 1, 25, 'nuevo');
CALL automovilABM (444, 2, 13, 'nuevo');
CALL automovilABM (555, 2, 13, 'nuevo');
CALL automovilABM (666, 2, 13, 'nuevo');
CALL automovilABM (777, 2, 13, 'nuevo');
CALL automovilABM (888, 2, 13, 'nuevo');
CALL automovilABM (999, 1, 31, 'nuevo');
CALL automovilABM (101, 1, 31, 'nuevo');
CALL automovilABM (102, 1, 31, 'nuevo');
CALL automovilABM (103, 1, 31, 'nuevo');
CALL automovilABM (104, 1, 31, 'nuevo');
CALL automovilABM (105, 1, 31, 'nuevo');

/* Los siguientes datos son de tablas intermedias. Para probar las funciones 8, 9 y 10 hay que comentarear
   las siguientes lineas
*/
insert into produccion values ( '2019-05-23T8:00:00', '2019-05-23T20:00:00', 1, 111);
insert into produccion values ( '2019-05-24T8:00:00', '2019-05-24T20:00:00', 2, 111);
insert into produccion values ( '2019-05-25T8:00:00', '2019-05-25T20:00:00', 3, 111);
insert into produccion values ( '2019-05-26T8:00:00', '2019-05-26T20:00:00', 4, 111);
insert into produccion values ( '2019-05-27T8:00:00', '2019-05-27T20:00:00', 5, 111);

insert into produccion values ( '2019-05-24T8:00:00', '2019-05-24T20:00:00', 1, 222);
insert into produccion values ( '2019-05-25T8:00:00', '2019-05-25T20:00:00', 2, 222);
insert into produccion values ( '2019-05-26T8:00:00', '2019-05-26T20:00:00', 3, 222);
insert into produccion values ( '2019-05-27T8:00:00', '2019-05-27T20:00:00', 4, 222);
insert into produccion values ( '2019-05-28T8:00:00', '2019-05-28T20:00:00', 5, 222);

insert into produccion values ( '2019-05-24T8:00:00', '2019-05-24T20:00:00', 1, 555);

insert into produccion values ( '2019-05-25T8:00:00', '2019-05-25T20:00:00', 1, 333);
insert into produccion values ( '2019-05-26T8:00:00', '2019-05-26T20:00:00', 2, 333);
insert into produccion values ( '2019-05-27T8:00:00', '2019-05-27T20:00:00', 3, 333);
insert into produccion values ( '2019-05-28T8:00:00', '2019-05-28T20:00:00', 4, 333);
insert into produccion values ( '2019-05-29T8:00:00', '2019-05-29T20:00:00', 5, 333);

insert into produccion values ( '2019-06-13T8:00:00', null, 1, 444);

insert into produccion values ( '2019-06-14T8:00:00', '2019-06-14T20:00:00', 1, 555);
insert into produccion values ( '2019-06-15T8:00:00', null, 2, 555);

insert into produccion values ( '2019-06-15T8:00:00', '2019-06-15T20:00:00', 1, 666);
insert into produccion values ( '2019-06-16T8:00:00', '2019-06-16T20:00:00', 2, 666);
insert into produccion values ( '2019-06-17T8:00:00', null, 3, 666);

insert into produccion values ( '2019-06-16T8:00:00', '2019-06-16T20:00:00', 1, 777);
insert into produccion values ( '2019-06-17T8:00:00', '2019-06-17T20:00:00', 2, 777);
insert into produccion values ( '2019-06-18T8:00:00', '2019-06-18T20:00:00', 3, 777);
insert into produccion values ( '2019-06-19T8:00:00', null, 4, 777);

insert into produccion values ( '2019-06-17T8:00:00', '2019-06-17T20:00:00', 1, 888);
insert into produccion values ( '2019-06-18T8:00:00', '2019-06-18T20:00:00', 2, 888);
insert into produccion values ( '2019-06-19T8:00:00', '2019-06-19T20:00:00', 3, 888);
insert into produccion values ( '2019-06-20T8:00:00', '2019-06-20T20:00:00', 4, 888);
insert into produccion values ( '2019-06-21T8:00:00', null, 5, 888);

insert into produccion values ( null, null, null, 999);
insert into produccion values ( null, null, null, 101);
insert into produccion values ( null, null, null, 102);
insert into produccion values ( null, null, null, 103);
insert into produccion values ( null, null, null, 104);
insert into produccion values ( null, null, null, 105);

insert into pedido_insumo values ( 5, 1, 3);
insert into pedido_insumo values ( 3, 1, 12);
insert into pedido_insumo values ( 7, 1, 14);
insert into pedido_insumo values ( 1, 1, 21);
insert into pedido_insumo values ( 1, 2, 15);
insert into pedido_insumo values ( 1, 2, 16);
insert into pedido_insumo values ( 1, 2, 17);
insert into pedido_insumo values ( 1, 2, 24);
insert into pedido_insumo values ( 1, 3, 10);
insert into pedido_insumo values ( 1, 3, 22);
insert into pedido_insumo values ( 1, 3, 24);
insert into pedido_insumo values ( 1, 3, 25);
insert into pedido_insumo values ( 1, 4, 9);
insert into pedido_insumo values ( 1, 4, 12);
insert into pedido_insumo values ( 1, 4, 13);
insert into pedido_insumo values ( 1, 4, 25);
insert into pedido_insumo values ( 1, 5, 10);
insert into pedido_insumo values ( 1, 5, 12);
insert into pedido_insumo values ( 1, 5, 18);
insert into pedido_insumo values ( 1, 5, 19);
insert into pedido_insumo values ( 1, 5, 20);
