/*Obtener un reporte de ventas de accesorios, realizadas en el mes 'X' 
  del año 'Y', para el cliente 'C', realizada en la sucursal 'W'
  almacenarlo en una nueva tabla los resultados de N transacciones
  para realizar un posible CUBO OLAP*/
  /*LOGICA
	PASO 1. Obtener el estado y ciudad de la sucursal 'W'
	PASO 2. Obtener las ventas de accesorios realizados en el mes 'X' del año 'Y'
	PASO 3. Obtener todas las ventas de accesorios realizadas al cliente 'C'
	PASO 4. Obtener los accesorios comprados del cliente 'C' en el mes 'X' del 
			año 'Y' de la sucursal 'W' basandonos en el punto 1, 2 y 3
	PASO 5. ALMACENAR los resultados en una tabla dentro de la transaccion*/
  
	/***************************************************************/
	
USE Nissan
GO

--Nota paso 1 aún no se utiliza

	--PASO 1. Obtener el estado y ciudad de la sucursal 'W'
    create function fn_ventas_por_sucursal(@id_sucursal varchar(15))
    returns TABLE
    AS
		RETURN(select ESTADO,CIUDAD from DISTRIBUIDOR_O_SUCURSAL
				where ID_SUCURSAL=@id_sucursal)
	GO
	--select * from DISTRIBUIDOR_O_SUCURSAL
    --go
	--select * from fn_ventas_por_sucursal ('SUC00004')
	
	
	--PASO 2. Obtener las ventas de accesorios realizados en el mes 'X' del año 'Y'
	create function fn_ventas_accesorio(@mes SMALLINT, @año smallint)
	returns TABLE
	AS
	  RETURN(select ID_VENTA_ACCESORIO,FK_CLIENTE from VENTA_ACCESORIO
	         where  month(FECHA)=@MES and year(FECHA) = @AÑO) 
    GO
    --Prueba
    --select * from VENTA_ACCESORIO
    --go
    --select * from fn_ventas_accesorio(07,2017)
    --go
    
    
    --PASO 3. Obtener todas las ventas de accesorios realizadas al cliente 'C'
	--		en el mes 'X' del año 'Y'
	create function fn_ventas_xcliente(@cliente varchar(15))
	returns TABLE
	AS
	  RETURN(select FK_CLIENTE from VENTA_ACCESORIO
	         where  FK_CLIENTE=@cliente) 
    GO
	
	--select * from fn_ventas_xcliente('CL0001001')
	--go
	--PASO 4. Obtener los accesorios comprados del cliente 'C' en el mes 'X' del 
	--año 'Y' de la sucursal 'W' basandonos en el punto 1, 2 y 3
	
	create FUNCTION articulos_xcliente_mes_año(@CLIENTE varchar(15), @MES SMALLINT, @AÑO SMALLINT)
		   RETURNS TABLE
		   AS 
			RETURN(SELECT FK_ACCESORIO,FK_VENTA_ACCESORIO
			FROM DET_VENTA_ACCESORIO WHERE FK_VENTA_ACCESORIO IN
				  (SELECT ID_VENTA_ACCESORIO FROM DBO.fn_ventas_accesorio(@MES,@AÑO)
				  where FK_CLIENTE IN (SELECT FK_CLIENTE FROM fn_ventas_xcliente(@CLIENTE)))
		   GROUP BY FK_ACCESORIO,FK_VENTA_ACCESORIO
		   )
	GO
	
	--select * from articulos_xcliente_mes_año('CL0001001', 3, 2018)
	--go