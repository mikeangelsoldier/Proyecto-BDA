/*Obtener el ACCESORIO m�s vendido de una sucursal, por mes y a�o. 

	1. Obtener los ACCESORIO vendidos entre la fecha de inicio y la fecha fin.
	2. Obtener los ACCESORIOS vendidos por la SUCURSAL.
	3. Objetener el ACCESORIO con mayor venta.
*/

USE NISSAN;
GO

-- Revisamos las tablas a revizar
select * from DET_VENTA_ACCESORIO;
select * from ACCESORIO;
select * from VENTA_ACCESORIO;
GO

select count(FK_DISTRIBUIDORA) from VENTA_ACCESORIO group by FK_DISTRIBUIDORA;
-- Ver las fechas ordenas
select * from VENTA_ACCESORIO order by FECHA asc

-- Prueba de fechas
select * from VENTA_ACCESORIO where year(FECHA) = '2016' and month(FECHA) = '11';


--Obtenemos las ventas realizadas en MES X y ANIO Y
create function fn_obtener_accesorios_mes(@mes smallint, @ano smallint) 
returns table
as 	return (select * from VENTA_ACCESORIO where year(FECHA) = @ano and month(FECHA) = @mes)
go 

-- Prueba para la función
select * from fn_obtener_accesorios_mes('11', '2016');



-- Obtenemos las ventas realizadas en fecha X, a�o Y para una sucursal en especifico
select * from fn_obtener_accesorios_mes('11', '2016') accemes 
join  DISTRIBUIDOR_O_SUCURSAL dos 
on accemes.FK_DISTRIBUIDORA = dos.ID_SUCURSAL
join DET_VENTA_ACCESORIO dva
on dva.FK_VENTA_ACCESORIO = accemes.ID_VENTA_ACCESORIO
where dos.DESCRIPCION = 'NISSAN LERMA';



-- Creamos la prueba a partir de la prueba anterior para obtener los accesorios con su detalle.
create or alter function fn_accesorios_sucursal_mes(@sucursal varchar(15), @mes smallint, @ano smallint)
returns table 
as return select ID_VENTA_ACCESORIO, FK_DISTRIBUIDORA, FECHA, ID_SUCURSAL, FK_VENTA_ACCESORIO, CANTIDAD, FK_ACCESORIO from fn_obtener_accesorios_mes(@mes, @ano)  accemes 
join  DISTRIBUIDOR_O_SUCURSAL dos 
on accemes.FK_DISTRIBUIDORA = dos.ID_SUCURSAL
join DET_VENTA_ACCESORIO dva
on dva.FK_VENTA_ACCESORIO = accemes.ID_VENTA_ACCESORIO
where dos.DESCRIPCION=@sucursal
GO

-- Realizamos una prueba
select * from fn_accesorios_sucursal_mes('NISSAN LERMA','11', '2016');

select TOP 1 acc.DECRIPCION, CANTIDAD, PRECIO, CANTIDAD*PRECIO AS 'MONTO' from fn_accesorios_sucursal_mes('NISSAN LERMA','11', '2016') fas
join ACCESORIO acc
on fas.FK_ACCESORIO = acc.ID_ACCESORIO 
order by fas.CANTIDAD desc;

-- Obetenemos el monto del accesorio más vendido. 
create or alter function fn_accessorio_best_seller(@sucursal varchar(15), @mes smallint, @ano smallint)
returns table
as return 
select TOP 1 acc.DECRIPCION, CANTIDAD, PRECIO, CANTIDAD*PRECIO AS 'MONTO' from fn_accesorios_sucursal_mes('NISSAN LERMA','11', '2016') fas
join ACCESORIO acc
on fas.FK_ACCESORIO = acc.ID_ACCESORIO 
order by fas.CANTIDAD desc;
go

-- Realizamos una prueba
select * from fn_accessorio_best_seller('NISSAN LERMA','11', '2016');