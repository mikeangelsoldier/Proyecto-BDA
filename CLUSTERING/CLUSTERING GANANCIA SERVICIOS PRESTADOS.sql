/*
    Obtener el Servicio que haya sido más VENDIDO  en un
    mes 'X', ANIO 'Y'  en el estado X ciudad Y;  almacenelo
    en una nueva tabla los resultados de 'N' transacciones
    para realizar un posible CUBO OLAP
*/

use Nissan;
go

/******************** LOGICA ********************/

/* Paso 1. 
    Obtener las  FACT_SERVICIO que hayan sido vendidos 
    en el mes X y fecha Y 
*/

create or alter function fn_servicio_fecha(@mes smallint, @anio smallint)
returns table as
    return(select ID_SERVICIO from FACT_SERVICIO fs 
		join DET_FACT_SERVICIO dfs on dfs.FK_FACT_SERVICIO = fs.ID_FACT_SERVICIO
		join SERVICIO s on s.ID_SERVICIO = dfs.FK_SERVICIO
        where month( fs.FECHA ) = @mes and year( fs.FECHA ) = @anio)
go

/******************** Prueba, paso 1********************/
-- Vemos los datos que se consultarán
select * from FACT_SERVICIO;
-- Realizamos pruebas con el select 
select ID_SERVICIO from FACT_SERVICIO fs 
	join DET_FACT_SERVICIO dfs on dfs.FK_FACT_SERVICIO = fs.ID_FACT_SERVICIO
	join SERVICIO s on s.ID_SERVICIO = dfs.FK_SERVICIO
	where month( fs.FECHA ) = 8 and year( fs.FECHA ) = 2017
go
-- Realizamos prueba con la función para comparar con el select
select * from fn_servicio_fecha(8, 2017);
go
/******************** Prueba, paso 1. Realizada con éxito ********************/


/* Paso 2.
    Obtener FACT_SERVICIO que hayan sido vendidas en la ciduad X, estado Y
*/
create or alter function fn_servicio_lugar(@estado varchar(30), @ciudad varchar(100))
returns table as
    return(select ID_SERVICIO from FACT_SERVICIO fs 
	join DET_FACT_SERVICIO dfs on dfs.FK_FACT_SERVICIO = fs.ID_FACT_SERVICIO
	join SERVICIO s on s.ID_SERVICIO = dfs.FK_SERVICIO
	join DISTRIBUIDOR_O_SUCURSAL dos on dos.ID_SUCURSAL = fs.FK_DISTRIBUIDORA
    where dos.ESTADO = @estado and dos.CIUDAD = @ciudad)
go

/******************** Prueba, paso 2 ********************/
-- Realizamos select para ver los datos a consultar
select * from DISTRIBUIDOR_O_SUCURSAL
-- Realizamos prueba con select para ver los datos
select ID_SERVICIO from FACT_SERVICIO fs 
	join DET_FACT_SERVICIO dfs on dfs.FK_FACT_SERVICIO = fs.ID_FACT_SERVICIO
	join SERVICIO s on s.ID_SERVICIO = dfs.FK_SERVICIO
	join DISTRIBUIDOR_O_SUCURSAL dos on dos.ID_SUCURSAL = fs.FK_DISTRIBUIDORA
    where dos.ESTADO = 'Guanajuato' and dos.CIUDAD = 'Leon'
go
-- Realizamos prueba con la función para ver que es igual al select 
select * from fn_servicio_lugar('Guanajuato', 'Leon');
go
/******************** Prueba, paso 2. Realizada con éxito ********************/

/* Paso 3. 
    Obtener fechas espedificadas en la ubicación especificada la FAC_SERVICIO.}

	Le llamo a la función momento porque involucra mes, año, estado y ciudad.
*/
create or alter function fn_servicio_momento(@mes smallint, @anio smallint, @estado varchar(30), @ciudad varchar(100))
returns table as 
    return (
		select * from SERVICIO where 
			ID_SERVICIO in ( select * FROM fn_servicio_lugar(@estado, @ciudad) ) 
				and
			ID_SERVICIO in ( select * from fn_servicio_fecha(@mes, @anio) )
	)
go

/******************** Prueba, paso 3 ********************/
-- Realizamos prueba para ver los datos que debe arrojar conforme a los servicios
select * from SERVICIO where 
	ID_SERVICIO in (select ID_SERVICIO FROM dbo.fn_servicio_lugar('Guanajuato', 'Leon')) 
		and
	ID_SERVICIO in (select ID_SERVICIO from fn_servicio_fecha(8, 2017))
go
-- Realimos consulta con la función para comparar los datos 
select * from fn_servicio_momento(8, 2017, 'Guanajuato', 'Leon')
go
/******************** Prueba, paso 3. Realizada con éxito ********************/

/* Paso 4
    Sumar la importe de cada uno de las facturas para obtener el total por 
    cada factura de servico 
*/
create or alter function fn_servicio_suma(@mes smallint, @anio smallint, @estado varchar(30), @ciudad varchar(100))
returns table as 
    return (
		select s.ID_SERVICIO, sum(s.PRECIO) as 'TOTAL' from SERVICIO s where 
			s.ID_SERVICIO in (select ID_SERVICIO FROM dbo.fn_servicio_lugar(@estado, @ciudad)) 
				and
			s.ID_SERVICIO in (select ID_SERVICIO from fn_servicio_fecha(@mes, @anio))
			group by ( s.ID_SERVICIO )
	)
go

/******************** Prueba, paso 4 ********************/
-- Realizamos prueba para ver los datos que debe arrojar conforme a los servicios
select s.ID_SERVICIO, sum(s.PRECIO) as 'TOTAL' from SERVICIO s where 
	s.ID_SERVICIO in (select ID_SERVICIO FROM dbo.fn_servicio_lugar('Guanajuato', 'Leon')) 
		and
	s.ID_SERVICIO in (select ID_SERVICIO from fn_servicio_fecha(8, 2017))
	group by ( s.ID_SERVICIO ) 
go
-- Realimos consulta con la función para comparar los datos 
select * from fn_servicio_suma(8, 2017, 'Guanajuato', 'Leon')
go
/******************** Prueba, paso 4. Realizada con éxito ********************/

/* Paso 5
     Obtener la suma de las veces que se vendió un servicio. 
*/
create or alter function fn_servicio_suma_vendidos(@mes smallint, @anio smallint, @estado varchar(30), @ciudad varchar(100))
returns table as 
    return (
		select s.ID_SERVICIO, count(s.ID_SERVICIO) as 'SELLER' from SERVICIO s where 
			s.ID_SERVICIO in (select ID_SERVICIO FROM dbo.fn_servicio_lugar(@estado, @ciudad)) 
				and
			s.ID_SERVICIO in (select ID_SERVICIO from fn_servicio_fecha(@mes, @anio))
			group by ( s.ID_SERVICIO )
	)
go

/******************** Prueba, paso 5 ********************/
-- Realizamos un select de prueba para ver lso datos 
select s.ID_SERVICIO, count(s.ID_SERVICIO) as 'SELLER' from SERVICIO s where 
	s.ID_SERVICIO in (select ID_SERVICIO FROM dbo.fn_servicio_lugar('Guanajuato', 'Leon')) 
		and
	s.ID_SERVICIO in (select ID_SERVICIO from fn_servicio_fecha(8, 2017))
	group by ( s.ID_SERVICIO ) order by SELLER desc
go
-- Realimos consulta con la función para comparar los datos 
select * from fn_servicio_suma_vendidos(8, 2017, 'Guanajuato', 'Leon')
go
/******************** Prueba, paso 5. Realizada con éxito ********************/


/* Paso 6. 
    Obtener el producto más vendido
*/
create or alter function fn_servicio_mas_vendido(@mes smallint,  @anio smallint, @estado varchar(30), @ciudad varchar(100))
returns table as 
    return (
        select top( 1 ) SELLER, ID_SERVICIO from fn_servicio_suma_vendidos(@mes, @anio, @estado, @ciudad) fssv
    )
go

/******************** Prueba, paso 6 ********************/
-- Realizamos consulta para ver el resultado 
select top( 1 ) SELLER, ID_SERVICIO from fn_servicio_suma_vendidos(8, 2017, 'Guanajuato', 'Leon') fssv
go
-- Realizamos consulta a la función para ver sí se ejecuta correctamente 
select * from fn_servicio_mas_vendido(8, 2017, 'Guanajuato', 'Leon')
go
/******************** Prueba, paso 5. Realizada con éxito ********************/

/* Paso 7. 
    Crear la tabla donde se vacian los datos
*/