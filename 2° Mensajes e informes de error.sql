USE terminal_automotriz;
-- ----------------------------------------------------------------------------------------------------------------
-- Para imprimir los mensajes que se piden
create table resultado(
	nResultado int primary key, -- 0=exito,   -1=error
    cMensaje varchar (60) -- vacio en caso de exito,    mensaje en caso de error
);

DELIMITER $$
CREATE PROCEDURE exito()
BEGIN
	insert into resultado values (0, '');
	select * from resultado;
	delete from resultado where nResultado = 0;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `error_dependencia`()
BEGIN
	insert into resultado values (-1, 'existe una dependencia');
	select * from resultado;
	delete from resultado where nResultado = -1;
END$$
DELIMITER;

DELIMITER $$
CREATE PROCEDURE errorClaveRepetida()
BEGIN
	insert into resultado values (-1, 'Clave primaria repetida');
	select * from resultado;
	delete from resultado where nResultado = -1;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE errorClaveNoExiste()
BEGIN
	insert into resultado values (-1, 'La clave primaria no existe');
	select * from resultado;
	delete from resultado where nResultado = -1;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE errorEstacionOcupada(chasis int)
BEGIN
	insert into resultado values (-1, CONCAT('La estacion esta ocupada por el auto ', chasis) );
	select * from resultado;
	delete from resultado where nResultado = -1;
END$$
DELIMITER ;