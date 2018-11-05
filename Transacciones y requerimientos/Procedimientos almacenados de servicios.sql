use Nissan
go

--Procedimiento para obtener todos los servicios
create procedure getServicio
as
select * from SERVICIO
go

--Procedimiento para agregar servicios
create procedure insertServicio
@ID_SERVICIO VARCHAR(15),
@DESCRIPCION VARCHAR(500),
@PRECIO MONEY
as
insert into SERVICIO Values(@ID_SERVICIO,@DESCRIPCION,@PRECIO)
go

--Procedimiento para actualizar los servicios
create procedure updateServicio
@ID_SERVICIO varchar(15),
@DESCRIPCION varchar(500),
@PRECIO money
as
update SERVICIO set DESCRIPCION=@DESCRIPCION, PRECIO=@PRECIO where ID_SERVICIO=@ID_SERVICIO
go



-- Procedimientos para cliente
create or alter procedure insert_client 
@id varchar(15), 
@nombre varchar(100), 
@papellido varchar (100), 
@sapellido varchar(100), 
@curp varchar(20), 
@fnacimiento date, 
@sexo varchar(1) as 
	insert into CLIENTE values (@id, @nombre, @papellido, @sapellido, @curp, @fnacimiento, @sexo)
go 

create or alter procedure update_client
@id varchar(15), 
@nombre varchar(100), 
@papellido varchar (100), 
@sapellido varchar(100), 
@curp varchar(20), 
@fnacimiento date, 
@sexo varchar(1) as
	update CLIENTE set 
		NOMBRE =  @nombre, PRIMER_APELLIDO = @papellido, SEGUNDO_APELLIDO = @sapellido, CURP = @curp, FECHA_NACIMIENTO = @fnacimiento, SEXO = @sexo WHERE ID_CLIENTE = @id
go

-- Probando insertar un nuevo cliente
exec insert_client @id = 'JA0134641', @nombre = 'VENTURA', @papellido = 'ZUÑIGA', @sapellido = 'JARAMILLO',  @curp = 'ZUJV930711HMNXRN01', @fnacimiento = '1960/12/05', @sexo = 'M'
go
exec update_client @id = 'JA0134641', @nombre = 'Juda', @papellido = 'Alector', @sapellido = 'Vallejo',  @curp = 'JAVH930711HMNXRN01', @fnacimiento = '1994/04/15', @sexo = 'M'
go
select * from CLIENTE where ID_CLIENTE like '%34641';


-- Procedimientos para vehiculo
create or alter procedure insert_vehiculo
@id varchar(15), 
@descripcion varchar(300), 
@tipo varchar (300), 
@ano int, 
@modelo varchar(300), 
@color varchar (200),  
@precio money,
@existencia bigint as 
	insert into VEHICULO values (@id, @descripcion, @tipo, @ano, @modelo, @color, @precio, @existencia)
go 

create or alter procedure update_vehiculo
@id varchar(15), 
@descripcion varchar(300), 
@tipo varchar (300), 
@ano int, 
@modelo varchar(300), 
@color varchar (200),  
@precio money,
@existencia bigint as 
	update VEHICULO set DECRIPCION = @descripcion, TIPO = @tipo, AÑO = @ano, MODELO = @modelo, COLOR = @color, PRECIO = @precio, EXISTENCIA = @existencia where ID_VEHICULO = @id;
go 

-- Prueabs para procedimientos
exec insert_vehiculo 
	@id = 'JJ149947382', 
	@descripcion = '',
	@tipo = 'Electrico/estandar',
	@ano = 2002,
	@modelo = 'DATSUN',
	@color = 'Verde',
	@precio = 2544390,
	@existencia = 56
go

exec update_vehiculo 
	@id = 'JJ149947382', 
	@descripcion = 'Bien padre',
	@tipo = 'Electrico/Eloico',
	@ano = 2032,
	@modelo = 'DATZUN',
	@color = 'Morado',
	@precio = 25390,
	@existencia = 6
go

-- Verificación de valores generados y asignados
select * from VEHICULO where ID_VEHICULO = 'JJ149947382';

-- Procedimientos para accesorio 
create or alter procedure insert_accesorio
@id varchar(15), 
@descripcion varchar(200),   
@precio money,
@existencia int as 
	insert into ACCESORIO values (@id, @descripcion, @precio, @existencia)
go 

create or alter procedure update_accesorio
@id varchar(15), 
@descripcion varchar(200),   
@precio money,
@existencia int as 
	update ACCESORIO SET DECRIPCION = @descripcion, PRECIO = @precio, EXISTENCIA = @existencia WHERE ID_ACCESORIO = @id;
go 

exec insert_accesorio
	@id = 'AGG002294632279', 
	@descripcion = 'Asador para coche',	
	@precio = 2544390,
	@existencia = 56
go

exec update_accesorio
	@id = 'AGG002294632279', 
	@descripcion = 'Asador para tsuru',	
	@precio = 2544390,
	@existencia = 56
go


select * from ACCESORIO where ID_ACCESORIO = 'AGG002294632279';