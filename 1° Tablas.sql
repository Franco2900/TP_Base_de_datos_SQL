-- PUNTO 2
drop schema if exists terminal_automotriz;
create schema terminal_automotriz;
use terminal_automotriz;

create table modelo(
	modelo_vehiculo int primary key,
    nombre varchar(30)
);


create table linea_montaje(
	linea int primary key,
    id_modelo_vehiculo int
);

create table estacion(
	estacion int,
    funcion varchar(30),
    id_linea int,
    primary key (estacion, ID_linea)
);

create table produccion(
	ingreso DATETIME,
    egreso DATETIME,
    id_estacion int,
    id_chasis int
);

create table automovil(
	chasis int primary key,
    id_modelo_vehiculo int,
    id_nro_pedido int
);

create table detalle_pedido(
	cantidad int,
    id_modelo_vehiculo int,
    id_nro_pedido int primary key
);

create table pedido_auto(
	nro_pedido int primary key,
    fecha_pedido DATETIME,
    id_consecionaria int
);

create table consecionaria(
	consecionaria int primary key,
    nombre varchar(30)
);

create table pedido_insumo(
	cantidad int,
    id_estacion int,
    id_codigo_insumo int,
    primary key(id_estacion, id_codigo_insumo)
);

create table insumo(
	codigo_insumo int primary key,
    nombre varchar(30),
    precio float
);

create table ins_prov(
	id_codigo_insumo int,
    id_proveedor int
);
    
create table proveedor(
	proveedor int primary key,
    nombre varchar(30)
);

alter table linea_montaje add foreign key(id_modelo_vehiculo) references modelo(modelo_vehiculo);

alter table estacion add foreign key(id_linea) references linea_montaje(linea);

alter table produccion add foreign key(id_estacion) references estacion(estacion);
alter table produccion add foreign key(id_chasis) references automovil(chasis);

alter table automovil add foreign key(id_modelo_vehiculo) references modelo(modelo_vehiculo);
alter table automovil add foreign key(id_nro_pedido) references detalle_pedido(id_nro_pedido);

alter table detalle_pedido add foreign key(id_modelo_vehiculo) references modelo(modelo_vehiculo);
alter table detalle_pedido add foreign key(id_nro_pedido) references pedido_auto(nro_pedido);

alter table pedido_auto add foreign key(id_consecionaria) references consecionaria(consecionaria);

alter table pedido_insumo add foreign key(id_estacion) references estacion(estacion);
alter table pedido_insumo add foreign key(id_codigo_insumo) references insumo(codigo_insumo);

alter table ins_prov add foreign key(id_codigo_insumo) references insumo(codigo_insumo);
alter table ins_prov add foreign key(id_proveedor) references proveedor(proveedor);