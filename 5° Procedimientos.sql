USE terminal_automotriz;
-- Hasta el punto 11 anda todo, el 12 y el 13 todavía están en desarrollo. El punto 14 se trata de un tema que el profe todavía no explico
-- -----------------------------------------------------------------------------------------------------------------
-- PUNTO 8
-- Genera los automóviles con la patente asignada al azar (la patente no debe repetirse)
-- Deben generarse con la línea de montaje asignada, pero sin ingresar a la primer estación de dicha línea.
-- Se deben recorrer los detalles del pedido y en cada uno de ellos se deben crear los vehiculos 
-- por modelo que se indican según el campo “cantidad”.

DELIMITER $$
CREATE PROCEDURE generarAutomovilConPatenteAzar(nro_pedido int)
BEGIN

	DECLArE _cantidad int default 0;
	DECLARE _id_modelo_vehiculo int default 0;
	DECLARE _id_nro_pedido int default 0;
	
    DECLARE terminado int default 0;
    DECLARE chasisAlAzar int default null;
    
    DECLARE cursorAutomovil CURSOR FOR 
    SELECT cantidad, id_modelo_vehiculo, id_nro_pedido FROM detalle_pedido WHERE detalle_pedido.id_nro_pedido = nro_pedido;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET terminado = 1;
	
    OPEN cursorAutomovil;	
    
    
	recorrerTablaDetallePedido: LOOP
		FETCH cursorAutomovil INTO _cantidad, _id_modelo_vehiculo, _id_nro_pedido;
        SET chasisAlAzar = CEILING(RAND()*999);  -- Le asigno un valor al azar entre 1 y 999
        
        IF terminado=1 THEN
			LEAVE recorrerTablaDetallePedido;
        END IF;
		
		WHILE (_cantidad > 0)
        DO
			WHILE (SELECT chasis FROM automovil WHERE chasis = chasisAlAzar) IS TRUE -- Mientras el número de la tabla y el número al azar sean iguales
			DO 
				SET chasisAlAzar = CEILING(RAND()*999); -- Le vuelvo a asignar un valor al azar hasta
			END WHILE;
			
			INSERT INTO automovil VALUES (chasisAlAzar, _id_modelo_vehiculo, _id_nro_pedido);
            INSERT INTO produccion VALUES (null, null, null, chasisAlAzar);
        
			SET _cantidad = _cantidad - 1;
        END WHILE;
        
    END LOOP;
    
	CLOSE cursorAutomovil;
END$$
DELIMITER ;

-- -----------------------------------------------------------------------------------------------------------------
-- PUNTO 9
-- Al recibir como parámetro la patente del automóvil, el automóvil es “posicionado” en la primer estación de
-- la línea de montaje que le fue asignada.
-- En caso de no ser posible la inserción del vehículo en la primer estación por encontrarse ocupada, deberá 
-- retornar un resultado informando esta situación, además del chasis del vehículo que está ocupando dicha estación.

DELIMITER $$
CREATE PROCEDURE iniciarMontaje (chasis int) 
BEGIN
    DECLARE egresoEstacion datetime;
    DECLARE NumeroEstacion int default 0;
    DECLARE NumeroChasis int default 0;
    
    DECLARE terminado int default 0;
    
    DECLARE cursorProduccion CURSOR FOR
    SELECT egreso, id_estacion, id_chasis FROM produccion;
	
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET terminado = 1;
    
    OPEN cursorProduccion;
		
	loopRecorrerCursor: loop   
        FETCH cursorProduccion INTO egresoEstacion, NumeroEstacion, NumeroChasis;
        
        IF (NumeroChasis = chasis AND NumeroEstacion IS NOT NULL) THEN -- En caso de chasis repetido
			CALL errorClaveRepetida();
            LEAVE loopRecorrerCursor;
		END IF;
        
        IF (SELECT id_modelo_vehiculo FROM automovil WHERE automovil.chasis = chasis) = (SELECT id_modelo_vehiculo FROM automovil WHERE automovil.chasis = NumeroChasis)
        -- Si los autos son del mismo modelo
			AND NumeroEstacion=1
            AND egresoEstacion IS  NULL
		-- Si un auto entro y no salio significa que esa estación esta ocupada
        THEN
			CALL errorEstacionOcupada(NumeroChasis);
			LEAVE loopRecorrerCursor;
        END IF;
        
        -- Si un auto es de un modelo diferente lo ignoro, lo mismo pasa si los autos son del mismo modelo pero uno tiene fecha de salida
        IF terminado=1 THEN 
			UPDATE produccion SET ingreso=NOW(), egreso=NULL, id_estacion=1, id_chasis=chasis WHERE id_chasis=chasis;
			LEAVE loopRecorrerCursor;
        END IF;
    END LOOP;
    
    CLOSE cursorProduccion;
    
END$$
DELIMITER ;

-- -----------------------------------------------------------------------------------------------------------------
-- Punto 10
-- Al recibir como parámetro la patente del automóvil, se finaliza la labor de la estación en la que se encuentra y 
-- se le ingresa en la estación siguiente.
-- Debe analizarse si es posible ingresar el automóvil en dicha estación. En caso de no ser posible deberá informarse
-- la situación.
-- En caso de que la estación en la que estoy finalizando la labor sea la última de la línea de montaje, debemos
-- marcar el automóvil como finalizado, lo que implica modificar la fecha de finalización del registro de la tabla vehiculos.

DELIMITER $$
CREATE PROCEDURE finalizarTrabajoEnEstacion(chasis int)
BEGIN
	DECLARE ingresoEstacion datetime;
	DECLARE egresoEstacion datetime;
    DECLARE NumeroEstacion int default 0;
    DECLARE NumeroChasis int default 0;
    
    DECLARE estacionActual int;
    -- Como cada chasis puede estar en una estacion diferente me fijo primero cual es la estación en la que esta
    DECLARE ultimaEstacion int;
    -- Como cada linea de montaje puede tener distinta cantidad de estaciones me fijo primero cual es la ultima estación
    
    DECLARE terminado int default 0;
    
    DECLARE cursorProduccion CURSOR FOR
    SELECT ingreso, egreso, id_estacion, id_chasis FROM produccion
    INNER JOIN automovil ON automovil.chasis = produccion.id_chasis ORDER BY automovil.id_modelo_vehiculo;
	
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET terminado = 1;
    
    OPEN cursorProduccion;
		
	loopRecorrerCursor: loop   
        FETCH cursorProduccion INTO ingresoEstacion, egresoEstacion, NumeroEstacion, NumeroChasis;
        
        SET estacionActual = (SELECT max(id_estacion) FROM produccion WHERE id_chasis = chasis);
        SET ultimaEstacion = (SELECT max(estacion) FROM estacion 
							  INNER JOIN linea_montaje ON id_linea = linea
                              INNER JOIN produccion WHERE produccion.id_chasis = chasis);
        
        IF (SELECT id_modelo_vehiculo FROM automovil WHERE automovil.chasis = chasis) = (SELECT id_modelo_vehiculo FROM automovil WHERE automovil.chasis = NumeroChasis)
        -- Si los autos son del mismo modelo
			AND NumeroEstacion = estacionActual+1
            AND egresoEstacion IS  NULL
		-- Si un auto de la estacion siguiente entro y no salio significa que esa estación esta ocupada
        THEN
			CALL errorEstacionOcupada(NumeroChasis);
			LEAVE loopRecorrerCursor;
        END IF;
        
        -- Si un auto es de un modelo diferente lo ignoro, lo mismo pasa si los autos son del mismo modelo pero uno tiene fecha de salida
        IF terminado=1 THEN
        
			IF (SELECT egreso FROM produccion WHERE produccion.id_chasis = chasis AND produccion.id_estacion = estacionActual) IS NULL THEN
				SET SQL_SAFE_UPDATES=0;
				UPDATE produccion SET egreso=NOW() WHERE produccion.id_chasis = chasis AND produccion.id_estacion = estacionActual;
				SET SQL_SAFE_UPDATES=1;
            END IF;
            
            IF (estacionActual+1 <= ultimaEstacion) THEN
				INSERT INTO produccion VALUES(NOW(), NULL, estacionActual+1, chasis);
            END IF;
	
			LEAVE loopRecorrerCursor;
        END IF;
        
    END LOOP;
    
    CLOSE cursorProduccion;
   
END$$
DELIMITER ;

-- -----------------------------------------------------------------------------------------------------------------
-- PUNTO 11
-- Dado un número de pedido, se requiere listar los vehículos indicando el chasis, si se encuentra finalizado, y si 
-- no esta terminado, indicar en qué estación se encuentra.

DELIMITER $$
CREATE PROCEDURE estadoPedido(nro_pedido int)
BEGIN
	
    DECLARE ultimaEstacion int;
    SET ultimaEstacion = (SELECT max(estacion) FROM estacion 
						  inner join linea_montaje on id_linea = linea
						  inner join produccion on id_estacion = estacion
                          inner join automovil on id_chasis = chasis
                          WHERE id_nro_pedido = nro_pedido); 
    -- Como cada linea de montaje puede tener distinta cantidad de estaciones me fijo primero cual es la ultima estación

    select chasis, a.id_modelo_vehiculo, a.id_nro_pedido, pr.egreso as FECHA, 'Terminado' as estado_estacion
	from automovil a
	inner join produccion pr on pr.id_chasis   = a.chasis
	inner join estacion est  on pr.id_estacion = est.estacion
	where est.estacion=ultimaEstacion and pr.egreso is not null and a.id_nro_pedido = nro_pedido
	union 
	select chasis, a.id_modelo_vehiculo, a.id_nro_pedido, pr.ingreso as FECHA, est.funcion as estado_estacion
	from automovil a
	inner join produccion pr on pr.id_chasis   = a.chasis
	inner join estacion est  on pr.id_estacion = est.estacion
	where pr.ingreso is not null and pr.egreso is null and a.id_nro_pedido = nro_pedido
	union 
	select chasis, a.id_modelo_vehiculo, a.id_nro_pedido, pr.ingreso as FECHA, 'A fabricar' as estado_estacion
	from automovil a
	inner join produccion pr on pr.id_chasis   = a.chasis
	where pr.ingreso is null and a.id_nro_pedido = nro_pedido
	;
    
END$$
DELIMITER ;

-- -----------------------------------------------------------------------------------------------------------------
-- PUNTO 12
-- Dado un número de pedido, se requiere listar los insumos que será necesario solicitar, indicando código de insumo
-- y cantidad requerida para ese pedido.

DELIMITER $$
CREATE PROCEDURE solicitarInsumos(nro_pedido int)
BEGIN
    
    DECLARE autos INT DEFAULT (SELECT count(id_chasis) AS Autos_en_espera FROM produccion
							   INNER JOIN automovil ON id_chasis = chasis
							   WHERE id_nro_pedido = nro_pedido
							   AND id_estacion IS NULL); 
    
	SELECT id_codigo_insumo AS Codigo, insumo.nombre AS Insumo, pedido_insumo.cantidad*autos AS Cantidad FROM pedido_insumo
    INNER JOIN estacion 	  ON estacion.estacion = pedido_insumo.id_estacion
    INNER JOIN linea_montaje  ON estacion.id_linea    = linea_montaje.linea
    INNER JOIN modelo 		  ON linea_montaje.id_modelo_vehiculo = modelo.modelo_vehiculo
    INNER JOIN detalle_pedido ON modelo.modelo_vehiculo = detalle_pedido.id_modelo_vehiculo
    INNER JOIN insumo		  ON pedido_insumo.id_codigo_insumo = insumo.codigo_insumo
    WHERE detalle_pedido.id_nro_pedido = nro_pedido;    

    
END$$
DELIMITER ;

-- -----------------------------------------------------------------------------------------------------------------
-- PUNTO 13
-- Dada una línea de montaje, indicar el tiempo promedio de construcción de los vehículos (tener en cuenta 
-- sólo los vehculos terminados).

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `tiempo_produccion`(_chasis int) RETURNS time
    READS SQL DATA
BEGIN
/*  Esta funcion recibe como parametro un chasis y devuelve el tiempo
total de produccion*/
DECLARE _tiempo TIME ;

SET _tiempo = (select  CAST(sum(egreso - ingreso) AS TIME) from produccion where id_chasis =_chasis and ingreso is not null and egreso is not null);
    
RETURN _tiempo;
END

$$ DELIMITER ;



DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `promedio_fabricacion`(_linea_montaje int)
BEGIN
	DECLARE _chasis int default 0;
	DECLARE _autos int default 0;
	DECLARE _tiempo TIME default 0;
	DECLARE terminado int default 0;

	DECLARE ultimaEstacion INT DEFAULT (SELECT max(estacion) FROM estacion 
										INNER JOIN linea_montaje ON id_linea = linea
										WHERE linea = _linea_montaje);

	DECLARE cursor_autos_terminados CURSOR FOR 
	select pro.id_chasis from produccion pro  
	inner join automovil au on pro.id_chasis = au.chasis
	inner join modelo m on au.id_modelo_vehiculo = m.modelo_vehiculo
	inner join linea_montaje lm on  m.modelo_vehiculo = lm.id_modelo_vehiculo                
	where lm.linea = _linea_montaje and pro.id_estacion = ultimaEstacion and egreso is not null;
	
    
    
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET terminado = 1;

	OPEN cursor_autos_terminados;
	loopRecorrerCursor: LOOP
		FETCH cursor_autos_terminados INTO _chasis;	
		
        IF (terminado=1)
			THEN 
				LEAVE loopRecorrerCursor;
		END IF;
		
        SET _tiempo =  (_tiempo +  CAST((select tiempo_produccion(_chasis)) AS TIME) ) ;
		SET _autos = (_autos + 1);
	END LOOP;
	CLOSE cursor_autos_terminados;

	select _linea_montaje AS LINEA, _autos AS AUTOS, _tiempo AS TIEMPO_TOTAL, CAST((_tiempo/_autos) AS TIME) AS TIEMPO_PROMEDIO;

	END
$$ DELIMITER ;

-- -----------------------------------------------------------------------------------------------------------------
-- PUNTO 14
-- Teniendo en cuenta las consultas anteriores construir algún índice que pueda facilitar la lectura de los datos.
-- DROP INDEX idx_fechaEgreso ON produccion;

CREATE index idx_fechaEgreso ON produccion (egreso);
-- El indice en fecha de egreso se usa porque en el punto 13 necesitamos solo verificar la fecha de egreso de los
-- autos que esten en la última estación