/*Obtener un reporte de ventas de accesorios, realizadas en el mes 'X' 
  del año 'Y', para el cliente de genero 'X'
  almacenarlo en una nueva tabla los resultados de N transacciones
  para realizar un posible CUBO OLAP
  
	PASO 1. Obtener las ventas de accesorios realizados en el mes 'M' del año 'A'
	PASO 2. Obtener todas las ventas de accesorios realizadas al los clientes de sexo 'X'
	PASO 3. Obtener los accesorios comprados del cliente de sexo 'X' en el mes 'M' del 
			año 'A' basandonos en el punto 1 y 2
	PASO 4. ALMACENAR los resultados en una tabla dentro de la transaccion
  */
	/***************************************************************/
	select * from Cliente;
USE Nissan
GO

--Nota: este paso aún no se utiliza

	--PASO. Obtener el estado y ciudad de la sucursal 'W'
	/*
    create function fn_ventas_por_sucursal(@id_sucursal varchar(15))
    returns TABLE
    AS
		RETURN(select ESTADO,CIUDAD from DISTRIBUIDOR_O_SUCURSAL
				where ID_SUCURSAL=@id_sucursal)
	GO
	*/
	
	--PASO 1. Obtener las ventas de accesorios realizados en el mes 'X' del año 'Y'
	alter function fn_ventas_accesorio(@mes SMALLINT, @año smallint)
	returns TABLE
	AS
	  RETURN(select ID_VENTA_ACCESORIO,FK_CLIENTE,FECHA from VENTA_ACCESORIO
	         where  month(FECHA)=@MES and year(FECHA) = @AÑO) 
    GO
    
   --PASO 2. Obtener todas las ventas de accesorios realizadas al los clientes de sexo 'X'
	alter function fn_ventas_xcliente(@sexo varchar(1))
	returns TABLE
	AS
	  RETURN(select c.ID_CLIENTE, c.SEXO, v.FECHA FROM VENTA_ACCESORIO v 
	  join CLIENTE c on c.ID_CLIENTE=v.FK_CLIENTE and c.SEXO=@sexo
	  ) 
    GO
    
	--PASO 3. Obtener los accesorios comprados del cliente de sexo 'X' en el mes 'M' del 
	--		año 'A' basandonos en el punto 1 y 2
	alter FUNCTION articulos_xcliente_mes_año(@SEXO varchar(15), @MES SMALLINT, @AÑO SMALLINT)
		   RETURNS TABLE
		   AS 
			RETURN(
			SELECT  ac.ID_ACCESORIO, ac.DECRIPCION, @SEXO as GENERO, COUNT(dv.FK_ACCESORIO) CANTIDAD_VENDIDA, @MES MES, @AÑO AÑO
			FROM DET_VENTA_ACCESORIO dv join ACCESORIO ac on dv.FK_ACCESORIO = ac.ID_ACCESORIO
			WHERE FK_VENTA_ACCESORIO IN
				  (SELECT ID_VENTA_ACCESORIO FROM DBO.fn_ventas_accesorio(@MES,@AÑO)
				  where FK_CLIENTE IN (SELECT ID_CLIENTE FROM fn_ventas_xcliente(@SEXO)))
		   GROUP BY ac.ID_ACCESORIO,dv.FK_ACCESORIO, ac.DECRIPCION
		   )
	GO
	
	
	--select * from VENTA_ACCESORIO
	--select * from fn_ventas_accesorio(03,2017)
    --go
    --select * from fn_ventas_xcliente('CL0001001')
	--go
	--select * from articulos_xcliente_mes_año('M', 3, 2018)
	--go