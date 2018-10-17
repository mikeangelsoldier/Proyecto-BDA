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
