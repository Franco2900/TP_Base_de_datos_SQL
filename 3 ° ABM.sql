USE terminal_automotriz;
-- El mensaje de inserción exitosa esta comentaredo porque genera muchos mensajes cuando se ejecuta el script
-- de carga de datos y eso hace que en algunas computadoras de poco rendimiento se cierre el workbench
-- ------------------------------------------ ABM TABLA MODELO -----------------------------------------------------------------------
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `modeloABM`(
	in _modelo_vehiculo int,
    in _nombre varchar(30),
    in accion varchar(30)
)
BEGIN
	case accion
    when 'nuevo' then
		if (select modelo_vehiculo from modelo where modelo_vehiculo = _modelo_vehiculo) is not null
		then
			call errorClaveRepetida();
		else
			insert into modelo(modelo_vehiculo, nombre) values(_modelo_vehiculo, _nombre);
            -- call exito();
		end if;
        
	when 'editar' then
    if (select modelo_vehiculo from modelo where modelo_vehiculo = _modelo_vehiculo) is null
		then
			call errorClaveNoExiste();
		else
			update modelo set nombre = _nombre where modelo_vehiculo = _modelo_vehiculo;
            call exito();
		end if;
	
	when'eliminar' then
		if (select modelo_vehiculo from modelo where modelo_vehiculo = _modelo_vehiculo) is null
		then
            call errorClaveNoExiste();
		ELSEIF( ( select linea from linea_montaje where id_modelo_vehiculo = _modelo_vehiculo )is not null OR
				( select chasis from automovil where id_modelo_vehiculo = _modelo_vehiculo )is not null OR
				( select id_nro_pedido from detalle_pedido where id_modelo_vehiculo = _modelo_vehiculo )is not null )
			THEN
			call terminal_automotriz.error_dependencia();
		else
			delete from modelo where modelo_vehiculo = _modelo_vehiculo;
            call exito();
		end if;

	when 'consulta' then 
		select * from modelo where modelo_vehiculo = _modelo_vehiculo;

end case;

END$$
DELIMITER ;
-- -----------------------------------------------ABM TABLA LINEA_MONTAJE-------------------------------------------------------------------------------
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `linea_montajeABM`(
	in _linea int,
    in _id_modelo_vehiculo int,
    in accion varchar(30)
)
BEGIN
	case accion
    when 'nuevo' then
		if (select linea from linea_montaje where linea = _linea) is not null
		then
			call errorClaveRepetida();
		else
			insert into linea_montaje(linea, id_modelo_vehiculo) values(_linea, _id_modelo_vehiculo);
            -- call exito();
		end if;
		
	when 'editar' then
		if (select linea from linea_montaje where linea = _linea) is null
		then
			call errorClaveNoExiste();
		else
			update linea_montaje set id_modelo_vehiculo = _id_modelo_vehiculo where linea = _linea;
            call exito();
		end if;
	
    when 'eliminar' then
		if (select linea from linea_montaje where linea = _linea) is null
		then
			call errorClaveNoExiste();
        else
			delete from linea_montaje where linea = _linea;
			call exito();
		end if;
			
	when 'consulta' then
		select * from linea_montaje where linea = _linea;
		
	end case;

END$$
DELIMITER ;
-- ------------------------------------------------ABM TABLA ESTACION----------------------------------------------------------------------
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `estacionABM`(
	in _estacion int,
    in _funcion varchar(30),
    in _id_linea int,
    in accion varchar(30)
)
BEGIN
	case accion
    when 'nuevo' then
		if (select estacion from estacion where estacion = _estacion and id_linea = _id_linea) is not null
		then
			call errorClaveRepetida();
		else
			insert into estacion(estacion, funcion, id_linea) values(_estacion, _funcion, _id_linea);
            -- call exito();
		end if;
        
	when 'editar' then
		if (select estacion from estacion where estacion = _estacion and id_linea = _id_linea) is null
		then
			call errorClaveNoExiste();
		else
			update estacion set funcion = _funcion, id_linea = _id_linea where estacion = _estacion;
            call exito();
		end if;
		
	when 'eliminar' then
		if (select estacion from estacion where estacion = _estacion and id_linea = _id_linea) is null
		then
			call errorClaveNoExiste();
		ELSEIF( ( select id_estacion from pedido_insumo where id_estacion = _estacion )is not null OR
				( select id_estacion from produccion where id_estacion = _estacion )is not null )
			THEN
			call terminal_automotriz.error_dependencia();
		else
			delete from estacion where estacion = _estacion and id_linea = _id_linea;
            call exito();
		end if;
        
	when 'consulta' then
		select * from estacion where estacion = _estacion and id_linea = _id_linea;
		
	end case;

END$$
DELIMITER ;
-- -------------------------------------------------ABM TABLA INSUMO-----------------------------------------------------------------------
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insumoABM`(
	in _codigo_insumo int,
    in _nombre varchar(30),
    in _precio float,
    in accion varchar(30)
)
BEGIN
	case accion
	when 'nuevo' then
		if (select codigo_insumo from insumo where codigo_insumo = _codigo_insumo) is not null
		then
			call errorClaveRepetida();
		else
			insert into insumo(codigo_insumo, nombre, precio) values(_codigo_insumo, _nombre, _precio);
            -- call exito();
		end if;
	
    when 'editar' then 
		if (select codigo_insumo from insumo where codigo_insumo = _codigo_insumo) is null
		then
			call errorClaveNoExiste();
		else
			update insumo set nombre = _nombre, precio = precio where codigo_insumo = _codigo_insumo;
            call exito();
		end if;
		
    when 'eliminar' then
		if (select codigo_insumo from insumo where codigo_insumo = _codigo_insumo) is null
		then
			call errorClaveNoExiste();
		ELSEIF( ( select id_codigo_insumo from pedido_insumo where id_codigo_insumo = _codigo_insumo )is not null OR
				( select id_codigo_insumo from ins_prov where id_codigo_insumo = _codigo_insumo )is not null )
			THEN
			call terminal_automotriz.error_dependencia();
		else
			delete from insumo where codigo_insumo = _codigo_insumo;
            call exito();
		end if;
		
	when 'consulta' then
		select * from insumo where codigo_insumo = _codigo_insumo;

	end case;
END$$
DELIMITER ;
-- --------------------------------------------------ABM TABLA PROVEEDOR--------------------------------------------------------------
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `proveedorABM`(
	in _proveedor int,
    in _nombre varchar(30),
    in accion varchar(30)
)
BEGIN
	case accion
    when 'nuevo' then
		if (select proveedor from proveedor where proveedor = _proveedor) is not null
		then
			call errorClaveRepetida();
		else
			insert into proveedor(proveedor, nombre) values(_proveedor, _nombre);
            -- call exito();
		end if;

	when 'editar' then
		if (select proveedor from proveedor where proveedor = _proveedor) is null
		then
			call errorClaveNoExiste();
		else
			update proveedor set nombre = _nombre where proveedor = _proveedor;
            call exito();
		end if;
		
	when 'eliminar' then
		if (select proveedor from proveedor where proveedor = _proveedor) is null
		then
			call errorClaveNoExiste();
		ELSEIF(  select id_proveedor from ins_prov where id_proveedor = _proveedor )is not null
			THEN
			call terminal_automotriz.error_dependencia();
		else
			delete from proveedor where proveedor = _proveedor;
            call exito();
		end if;
		
	when 'consulta' then
		select * from proveedor where  proveedor = _proveedor;
        
	end  case;
END$$
DELIMITER ;
-- -----------------------------------------------------ABM TABLA CONSECIONARIA------------------------------------------------------------
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `consecionariaABM`(
	in _consecionaria int,
    in _nombre varchar(30),
    in accion varchar(30)
)
BEGIN
	case accion
    when 'nuevo' then
		if (select consecionaria from consecionaria where consecionaria = _consecionaria) is not null
		then
			call errorClaveRepetida();
		else
			insert into consecionaria(consecionaria, nombre) values(_consecionaria, _nombre);
            -- call exito();
		end if;
	
    when 'editar' then
		if (select consecionaria from consecionaria where consecionaria = _consecionaria) is null
		then
			call errorClaveNoExiste();
		else
			update consecionaria set nombre = _nombre where consecionaria = _consecionaria;
            call exito();
		end if;
        
	when 'eliminar' then
		if (select consecionaria from consecionaria where consecionaria = _consecionaria) is null
		then
			call errorClaveNoExiste();
		ELSEIF( select id_consecionaria from pedido_auto where id_consecionaria = _consecionaria )is not null
			THEN
			call error_dependencia();
		else
			delete from consecionaria where consecionaria = _consecionaria;
            call exito();
		end if;
        
	when 'consulta' then
		select * from consecionaria where consecionaria = _consecionaria;
		
	end case;

END$$
DELIMITER ;
-- -----------------------------------------------------ABM TABLA PEDIDO AUTO----------------------------------------------------------------
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `pedidoAutoABM`(
	in _nro_pedido int,
	in _fecha_pedido datetime,
    in _id_consecionaria int,
    in accion varchar(30)
)
BEGIN
	case accion
    when 'nuevo' then
		if (select nro_pedido from pedido_auto where nro_pedido = _nro_pedido) is not null
		then
			call errorClaveRepetida();
		else
			insert into pedido_auto(nro_pedido, fecha_pedido, id_consecionaria) values(_nro_pedido, _fecha_pedido, _id_consecionaria);
			-- call exito();
        end if;
        
	when 'editar' then
		if (select nro_pedido from pedido_auto where nro_pedido = _nro_pedido) is null
		then
			call errorClaveNoExiste();
		else
			update pedido_auto set fecha_pedido = _fecha_pedido, id_consecionaria = _id_consecionaria where chasis = _chasis;
            call exito();
		end if;
		
	when 'eliminar' then
		if (select nro_pedido from pedido_auto where nro_pedido = _nro_pedido) is null
		then
			call errorClaveNoExiste();
		ELSEIF(  select id_nro_pedido from detalle_pedido where id_nro_pedido = _nro_pedido )is not null
			THEN
			call terminal_automotriz.error_dependencia();
		else
			delete from pedido_auto where nro_pedido = _nro_pedido;
            call exito();
		end if;
        
	when 'consulta' then
		select * from pedido_auto where nro_pedido = _nro_pedido;
        
	end case;

END$$
DELIMITER ;
-- -----------------------------------------------------ABM TABLA DETALLE PEDIDO ----------------------------------------------------------------
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `detallePedidoABM`(
	in _cantidad int,
	in _id_modelo_vehiculo  int,
    in _id_nro_pedido int,
    in accion varchar(30)
)
BEGIN
	case accion
    when 'nuevo' then
		if (select id_nro_pedido from detalle_pedido where id_nro_pedido = _id_nro_pedido) is not null
		then
			call errorClaveRepetida();
		else
			insert into detalle_pedido(cantidad, id_modelo_vehiculo, id_nro_pedido) values(_cantidad, _id_modelo_vehiculo, _id_nro_pedido);
			-- call exito();
        end if;
        
	when 'editar' then
		if (select id_nro_pedido from detalle_pedido where id_nro_pedido = _id_nro_pedido) is null
		then
			call errorClaveNoExiste();
		else
			update detalle_pedido set cantidad = _cantidad, id_modelo_vehiculo = _id_modelo_vehiculo where id_nro_pedido = _id_nro_pedido;
			call exito();
        end if;
		
	when 'eliminar' then
		if (select id_nro_pedido from detalle_pedido where id_nro_pedido = _id_nro_pedido) is null
		then
			call errorClaveNoExiste();
		ELSEIF( select id_nro_pedido from automivil where id_nro_pedido = _id_nro_pedido )is not null
			THEN
			call terminal_automotriz.error_dependencia();
		else
			delete from detalle_pedido where id_nro_pedido = _id_nro_pedido;
            call exito();
		end if;
        
	when 'consulta' then
		select * from detalle_pedido where id_nro_pedido = _id_nro_pedido;
        
	end case;

END$$
DELIMITER ;
-- -----------------------------------------------------ABM TABLA AUTOMOVIL----------------------------------------------------------------
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `automovilABM`(
	in _chasis int,
	in _id_modelo_vehiculo int,
    in _id_nro_pedido int,
    in accion varchar(30)
)
BEGIN
	case accion
    when 'nuevo' then
		if (select chasis from automovil where chasis = _chasis) is not null
		then
			call errorClaveRepetida();
		else
			insert into automovil(chasis, id_modelo_vehiculo, id_nro_pedido) values(_chasis, _id_modelo_vehiculo, _id_nro_pedido);
			-- call exito();
        end if;
		
	when 'editar' then
		if (select chasis from automovil where chasis = _chasis) is null
		then
			call errorClaveNoExiste();
		else
			update automovil set id_modelo_vehiculo = _id_modelo_vehiculo, id_nro_pedido = _id_nro_pedido where chasis = _chasis;
            call exito();
		end if;
            
	when 'eliminar' then
		if (select chasis from automovil where chasis = _chasis) is null
		then
			call errorClaveNoExiste();
		ELSEIF( select ID_chasis from produccion where ID_chasis = _chasis)is not null
			THEN
			call terminal_automotriz.error_dependencia();	
		else
			delete from automovil where chasis = _chasis;
			call exito();
		end if;
        
	when 'consulta' then
		select * from automovil where chasis = _chasis;
        
	end case;

END$$
DELIMITER ;