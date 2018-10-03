/*
	Obtener el ACCESORIO más vendido de una sucursal, por mes y año. 

	1. Obtener los ACCEORIOS vendidos entre la fecha de inicio y la fecha fin.
	2. Obtener los ACCESORIOS vendidos por la SUCURSAL.
	3. Objetener el ACCESORIO con mayor venta.
*/

USE NISSAN;
select * from DET_VENTA_ACCESORIO;
select * from ACCESORIO;
select * from VENTA_ACCESORIO;

select count(FK_DISTRIBUIDORA) from VENTA_ACCESORIO group by FK_DISTRIBUIDORA;
-- Ver las fechas ordenas
select * from VENTA_ACCESORIO order by FECHA asc

-- Prueba de fechas
select * from VENTA_ACCESORIO where year(FECHA) = '2016' and month(FECHA) = '11';


create function fn_obtener_accesorios_mes(@mes smallint, @ano smallint) 
returns table
as 	return (select * from VENTA_ACCESORIO where year(FECHA) = @ano and month(FECHA) = @mes)
go 

-- Prueba para la función 
select * from fn_obtener_accesorios_mes('11', '2016');

-- Prueba obtener datos de la sucursal+


select * from fn_obtener_accesorios_mes('11', '2016') accemes 
join  DISTRIBUIDOR_O_SUCURSAL dos 
on accemes.FK_DISTRIBUIDORA = dos.ID_SUCURSAL
where dos.DESCRIPCION = 'NISSAN LERMA';