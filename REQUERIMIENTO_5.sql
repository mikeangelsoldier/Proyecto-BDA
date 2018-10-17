/*
REQUERIMIENTO 5.	Generar un reporte de los autos más vendidos, clasificándolos en modelos,
		  vendidos en una determinada sucursal en un determinado rango de fechas.

LOGICA:
	1.-Obtener las VENTA_VEHICULO realizadas en las fechas especificadas
	2.-Filtrar las VENTAS_VEHICULO anteriores dando solo las que se realizaron en la sucursal X
	3.-Obtener los DET_VENTA_VEHICULO de las VENTAS_VEHICULO del punto anterior para obtener los VEHICULOS vendidos en cada venta
	4.-HACER CONTEO de la cantidad de veces que se vendio cada vehiculo
	5.-Obtener el AUTOMOVIL que se vendió mas de acuerdo al MODELO especificado, sucursal, y fechas indicadas
*/



/******
1.-Obtener las VENTA_VEHICULO realizadas en las fechas especificadas
*****/
--todas las ventas
SELECT * FROM VENTA_VEHICULO
GO

--VENTAS_VEHICULO realizadas en una fecha especifica
SELECT * FROM VENTA_VEHICULO
	WHERE FECHA BETWEEN '2017-02-25' AND '2017-08-27'
	ORDER BY FECHA
GO

--Funcion que regresa esa vista de ventas realizadas
CREATE FUNCTION FN_VENTAS_ENTRE_FECHAS(@FECHA_INCIO date, @FECHA_FIN date)
	   RETURNS TABLE
	   AS 
	    RETURN(SELECT * FROM VENTA_VEHICULO
				WHERE FECHA BETWEEN @FECHA_INCIO AND @FECHA_FIN
				)
GO

--PRUEBA
SELECT * FROM DBO.FN_VENTAS_ENTRE_FECHAS('2017-02-25', '2017-08-27')


/******
2.-Filtrar las VENTAS_VEHICULO anteriores dando solo las que se realizaron en la sucursal X
*****/
--LAS sucrusales que se tienen
SELECT * FROM DISTRIBUIDOR_O_SUCURSAL

--prueba de ventas realizadas en una sucursal especifica
SELECT vf.ID_VENTA_VEHICULO,S.DESCRIPCION,  vf.FECHA FROM DBO.FN_VENTAS_ENTRE_FECHAS('2017-02-25', '2017-03-27') as vf INNER JOIN DISTRIBUIDOR_O_SUCURSAL as S
ON vf.FK_DISTRIBUIDORA= S.ID_SUCURSAL
WHERE s.DESCRIPCION='NISSAN 1 LEON'
GO

--llevar lo anterior a una funcion
CREATE FUNCTION FN_VENTAS_DE_SUCURSAL_EN_FECHAS(@NOMRE_SUCURSAL VARCHAR(300),@FECHA_INCIO date, @FECHA_FIN date)
	RETURNS TABLE
	AS RETURN(
		SELECT vf.ID_VENTA_VEHICULO,S.DESCRIPCION,  vf.FECHA FROM DBO.FN_VENTAS_ENTRE_FECHAS(@FECHA_INCIO, @FECHA_FIN) as vf INNER JOIN DISTRIBUIDOR_O_SUCURSAL as S
			ON vf.FK_DISTRIBUIDORA= S.ID_SUCURSAL
			WHERE s.DESCRIPCION=@NOMRE_SUCURSAL
)
GO

--prueba 
SELECT * FROM DBO.FN_VENTAS_DE_SUCURSAL_EN_FECHAS ('NISSAN 1 LEON','2017-02-25', '2017-04-27')
GO

/******
3.-Obtener los DET_VENTA_VEHICULO de las VENTAS_VEHICULO del punto anterior para obtener los VEHICULOS vendidos en cada venta

*****/
--Detalles de venta de cada venta del punto anterior
SELECT * FROM DBO.FN_VENTAS_DE_SUCURSAL_EN_FECHAS ('NISSAN 1 LEON','2017-02-25', '2017-04-27') as v INNER JOIN DET_VENTA_VEHICULO as dv
ON v.ID_VENTA_VEHICULO=dv.FK_VENTA_VEHICULO
GO

--funcion de la consulta anterior
CREATE FUNCTION FN_AUTOS_VENDIDOS_SUCURSAL_FECHA(@NOMRE_SUCURSAL VARCHAR(300),@FECHA_INCIO date, @FECHA_FIN date)
	RETURNS TABLE
	AS RETURN(
			SELECT * FROM DBO.FN_VENTAS_DE_SUCURSAL_EN_FECHAS (@NOMRE_SUCURSAL,@FECHA_INCIO,@FECHA_FIN ) as v INNER JOIN DET_VENTA_VEHICULO as dv
			ON v.ID_VENTA_VEHICULO=dv.FK_VENTA_VEHICULO
		)
GO

--prueba 
SELECT DESCRIPCION as sucursal,ID_VENTA_VEHICULO,FK_VEHICULO,CANTIDAD 
FROM DBO.FN_AUTOS_VENDIDOS_SUCURSAL_FECHA ('NISSAN 1 LEON','2017-02-25', '2017-04-27')
ORDER BY FK_VEHICULO
GO

/******
4.-HACER CONTEO de la cantidad de veces que se vendio cada vehiculo
*****/
SELECT FK_VEHICULO, SUM(CANTIDAD) as cantidad_total_vendidos
FROM DBO.FN_AUTOS_VENDIDOS_SUCURSAL_FECHA ('NISSAN 1 LEON','2017-02-25', '2017-04-27')
GROUP BY FK_VEHICULO
ORDER BY FK_VEHICULO
GO

/******
5.-Obtener los vehiculos que se vendieron mas de acuerdo al MODELO especificado
*****/
--Obtenemos los vehiculos vendidos de modelo X

SELECT a.FK_VEHICULO,b.MODELO, SUM(a.CANTIDAD) as cantidad_total_vendidos
FROM DBO.FN_AUTOS_VENDIDOS_SUCURSAL_FECHA ('NISSAN 1 LEON','2017-02-25', '2017-04-27') A JOIN VEHICULO B
ON a.FK_VEHICULO=b.ID_VEHICULO
GROUP BY a.FK_VEHICULO,b.MODELO
ORDER BY b.MODELO
GO	
		
/******
5.-Obtener los vehiculos que mas se vendieron mas de acuerdo al MODELO especificado
*****/

CREATE FUNCTION FN_AUTOS_MODELOS_MAS_VENDIDOS_FECHAS_SUCURSAL(
	@NOMRE_SUCURSAL VARCHAR(300),
	@MODELO VARCHAR (300),
	@FECHA_INCIO date, 
	@FECHA_FIN date)
	RETURNS TABLE
	AS RETURN(
		SELECT a.FK_VEHICULO ID_VEHICULO,b.MODELO modelo, SUM(a.CANTIDAD) as cantidad_total_vendidos
			FROM DBO.FN_AUTOS_VENDIDOS_SUCURSAL_FECHA (@NOMRE_SUCURSAL,@FECHA_INCIO,@FECHA_FIN) A JOIN VEHICULO B
				ON a.FK_VEHICULO=b.ID_VEHICULO
				WHERE b.MODELO=@MODELO
				GROUP BY a.FK_VEHICULO,b.MODELO
)
GO






--seleccionar el VEHICULO mas vendido del modelo X, en la SUCURSAL Y, entre las fechas A y B

SELECT ID_VEHICULO
FROM dbo.FN_AUTOS_MODELOS_MAS_VENDIDOS_FECHAS_SUCURSAL('NISSAN 1 LEON','ALTIMA','2017-02-25', '2017-04-27') 
WHERE cantidad_total_vendidos=(
				SELECT max(cantidad_total_vendidos)
					FROM dbo.FN_AUTOS_MODELOS_MAS_VENDIDOS_FECHAS_SUCURSAL('NISSAN 1 LEON','ALTIMA','2017-02-25', '2017-04-27') 
				)
GO


CREATE FUNCTION FN_AUTO_MAS_VENDIDO_FECHAS_SUCURSAL(
	@NOMRE_SUCURSAL VARCHAR(300),
	@MODELO VARCHAR (300),
	@FECHA_INCIO date, 
	@FECHA_FIN date)
	RETURNS TABLE
	AS RETURN(
		SELECT ID_VEHICULO
			FROM dbo.FN_AUTOS_MODELOS_MAS_VENDIDOS_FECHAS_SUCURSAL(@NOMRE_SUCURSAL,@MODELO,@FECHA_INCIO, @FECHA_FIN) 
			WHERE cantidad_total_vendidos=(SELECT max(cantidad_total_vendidos)
					FROM dbo.FN_AUTOS_MODELOS_MAS_VENDIDOS_FECHAS_SUCURSAL(@NOMRE_SUCURSAL,@MODELO,@FECHA_INCIO, @FECHA_FIN) 
			)
)
GO

--prueba
SELECT * FROM DBO.FN_AUTO_MAS_VENDIDO_FECHAS_SUCURSAL ('NISSAN 2 LEON','ALTIMA','2017-02-01', '2017-03-01')





/*****************************************************************************************************************
CREAR UN ETL......
**********************************************************************************************************/

--crear indices para obtener todas las sucursales

--crear indice para obtener todos los modelos

--crear una nueva tabla que contenga: Sucursal, vehiculo_mas_vendido_en_esa_sucursal,fecha de incio, fecha de fin (o mes y año especifico)

--crear un procedimiento almacenado que guarde para cada sucursal el auto que mas vendio en un periodo especifico






















