
/*
  Obtener la SUCURSAL ubicada en el ESTADO X que haga generado la mayor CANTIDAD DE GANANCIAS
  en los autos vendidos en el MES X, AÑO X
  en una nueva tabla los resultados de 'N' transacciones
  para realizar un posible CUBO OLAP*/
  /*LOGICA 
    PASO 1. Obtener los registros de las VENTA_VEHICULO realizadas en el ESTADO X en todas las SUCURSALES
		Obtener las VENTA_VEHICULO en en MES X, AÑO X
    PASO 2. En base a las VENTA_VEHICULO del punto anterior, encontrar todos los DET_VENTA_VEHICULO para detectar 
		los vehiculos vendidos dentro de una VENTA_VEHICULO
	PASO 3. Obtener los PRECIOS fijos de cada VEHICULO y agregarlo en una nueva columna llamada IMPORTE_TOTAL 
		para cada una de las VENTA_VEHICULO. 
	PASO 4. Sumar el IMPORTE_TOTAL de todas las VENTA_VEHICULO
	PASO 5. obtener la sucursal que obtuvo la mayor CANTIDAD_DE_GANANCIAS en base al valor 
		maximo de las sumas de los importes obtenidos en le punto anterior
	PASO 6. Crear una nueva tabla donde se agreguen las sucursales con 
		mas ganancias en servicios prestados durante el mes especificado y año especificado
	
	*/
	
	/******************************
	PASO 1. Obtener los registros de las VENTA_VEHICULO realizadas en el ESTADO X en todas las SUCURSALES
	*********************************/
USE Nissan
GO

--obtener las VENTA_VEHICULO realizadas en el MES X, AÑO X
create function fn_venta_vehiculo_mes_año(@mes SMALLINT, @ANIO smallint)
	returns TABLE
	AS
	  RETURN(select FK_DISTRIBUIDORA,ID_VENTA_VEHICULO, FECHA from VENTA_VEHICULO
	         where  month(FECHA)=@MES and year(FECHA) = @ANIO) 
    GO

--PRUEBA 
--SELECT * FROM FACT_SERVICIO ORDER BY FECHA
SELECT * FROM DBO.fn_venta_vehiculo_mes_año(1,2017)--VENTA_VEHICULO realizadas en el MES XX, ANIO XXXX
GO

--obtener las VENTA_VEHICULO realizadas en el MES X, AÑO X en las sucursales del estado X
--SELECT * FROM DISTRIBUIDOR_O_SUCURSAL

CREATE FUNCTION fn_venta_vehiculo_estado_mes_año(@estado VARCHAR (30) ,@mes SMALLINT, @ANIO SMALLINT)
	RETURNS TABLE AS
	RETURN(SELECT s.ID_SUCURSAL,s.DESCRIPCION,venta.ID_VENTA_VEHICULO,venta.FECHA FROM DBO.fn_venta_vehiculo_mes_año(@mes,@ANIO) AS venta
		JOIN DISTRIBUIDOR_O_SUCURSAL AS s 
			ON venta.FK_DISTRIBUIDORA=s.ID_SUCURSAL
			WHERE s.ESTADO=@estado
	)
GO

--PRUEBA 

SELECT * FROM DBO.fn_venta_vehiculo_estado_mes_año('ESTADO DE MEXICO',1,2017)--VENTA_VEHICULO realizadas en el MES XX, ANIO XXXX, en el ESTADO X
GO


/******************************
	PASO 2. En base a las VENTA_VEHICULO del punto anterior, encontrar todos los DET_VENTA_VEHICULO para detectar 
		los vehiculos vendidos dentro de la misma VENTA_VEHICULO
	*********************************/
	--obtener los detalles de cada factura 
	SELECT * FROM DBO.fn_venta_vehiculo_estado_mes_año('ESTADO DE MEXICO',1,2017)  a
	INNER JOIN DET_VENTA_VEHICULO b ON a.ID_VENTA_VEHICULO=b.FK_VENTA_VEHICULO
	ORDER BY ID_VENTA_VEHICULO,FK_VEHICULO
	GO

	--crear la funcion
CREATE FUNCTION fn_venta_vehiculo_detalles(@estado VARCHAR (30) ,@mes SMALLINT, @ANIO SMALLINT)
	RETURNS TABLE AS
	RETURN(SELECT a.ID_SUCURSAL,a.DESCRIPCION,a.ID_VENTA_VEHICULO,b.FK_VEHICULO FROM DBO.fn_venta_vehiculo_estado_mes_año(@estado,@mes,@ANIO)  a
		INNER JOIN DET_VENTA_VEHICULO b ON a.ID_VENTA_VEHICULO=b.FK_VENTA_VEHICULO
	)
GO

--prueba
SELECT * FROM DBO.fn_venta_vehiculo_detalles('ESTADO DE MEXICO',1,2017)--DET_VENTA_VEHICULO de las VENTA_VEHICULO
GO


	/******************************
	PASO 3. Obtener los PRECIOS fijos de cada VEHICULO y agregarlo en una nueva columna llamada IMPORTE_TOTAL 
		para cada una de las VENTA_VEHICULO. 
	*********************************/
--obtener los precios de cada servicio por individual

SELECT det_venta.ID_SUCURSAL,det_venta.DESCRIPCION Sucursal,det_venta.ID_VENTA_VEHICULO,v.ID_VEHICULO,v.PRECIO  FROM DBO.fn_venta_vehiculo_detalles('ESTADO DE MEXICO',1,2017) det_venta
	INNER JOIN VEHICULO v ON det_venta.FK_VEHICULO=v.ID_VEHICULO
GO

--crear la funcion
CREATE FUNCTION fn_precios_por_det_vehiculo(@estado VARCHAR (30) ,@mes SMALLINT, @ANIO SMALLINT)
	RETURNS TABLE AS
	RETURN(SELECT det_venta.ID_SUCURSAL,det_venta.DESCRIPCION Sucursal,det_venta.ID_VENTA_VEHICULO,v.ID_VEHICULO,v.PRECIO 
		FROM DBO.fn_venta_vehiculo_detalles(@estado,@mes,@ANIO) det_venta
		INNER JOIN VEHICULO v ON det_venta.FK_VEHICULO=v.ID_VEHICULO
	)
GO

--prueba
SELECT * FROM fn_precios_por_det_vehiculo('ESTADO DE MEXICO',1,2017)
GO

--colocar la suma total de cada DET_VENTA_VEHICULO para cada VENTA_VEHICULO

SELECT ID_SUCURSAL,Sucursal,ID_VENTA_VEHICULO,  sum(PRECIO) importe FROM fn_precios_por_det_vehiculo('ESTADO DE MEXICO',1,2017) 
	GROUP BY ID_SUCURSAL,Sucursal,ID_VENTA_VEHICULO
GO

--crear la funcion
CREATE FUNCTION fn_importe_total_det_venta_vehiculo(@estado VARCHAR (30) ,@mes SMALLINT, @ANIO SMALLINT)
	RETURNS TABLE AS
	RETURN(SELECT ID_SUCURSAL,Sucursal,ID_VENTA_VEHICULO, sum(PRECIO) IMPORTE_TOTAL FROM fn_precios_por_det_vehiculo(@estado,@mes,@ANIO) 
	GROUP BY ID_SUCURSAL,Sucursal,ID_VENTA_VEHICULO
	)
GO

--prueba
SELECT * FROM fn_importe_total_det_venta_vehiculo('ESTADO DE MEXICO',1,2017)
GO

SELECT * FROM fn_importe_total_det_venta_vehiculo('ESTADO DE MEXICO',1,2017)
ORDER BY ID_SUCURSAL
GO



	/******************************
	PASO 4. Sumar el IMPORTE_TOTAL de todas las VENTA_VEHICULO 
	*********************************/
--sumar el IMPORTE_TOTAL de todas las VENTAS_VEHICULO para cada SUCURSAL
SELECT ID_SUCURSAL,Sucursal,sum(IMPORTE_TOTAL) GANANCIA_TOTAL FROM fn_importe_total_det_venta_vehiculo('ESTADO DE MEXICO',1,2017)
GROUP BY ID_SUCURSAL,SUCURSAL
GO

--crear la funcion
CREATE FUNCTION fn_ganacia_total_vehiculos_por_suc(@estado VARCHAR (30) ,@mes SMALLINT, @ANIO SMALLINT)
	RETURNS TABLE AS
	RETURN(SELECT ID_SUCURSAL,Sucursal,sum(IMPORTE_TOTAL) GANANCIA_TOTAL_VEHICULOS FROM fn_importe_total_det_venta_vehiculo(@estado,@mes,@ANIO)
		GROUP BY ID_SUCURSAL,SUCURSAL
	)
GO

--prueba
SELECT * FROM fn_ganacia_total_vehiculos_por_suc('ESTADO DE MEXICO',1,2017)
GO


	/******************************
PASO 5. obtener la sucursal que obtuvo la mayor cantidad de GANANCIA_TOTAL_VEHICULOS
	*********************************/

SELECT ID_SUCURSAL,Sucursal,GANANCIA_TOTAL_VEHICULOS 
	FROM fn_ganacia_total_vehiculos_por_suc('ESTADO DE MEXICO',1,2017)
	WHERE GANANCIA_TOTAL_VEHICULOS= (SELECT MAX (GANANCIA_TOTAL_VEHICULOS) 
									FROM fn_ganacia_total_vehiculos_por_suc('ESTADO DE MEXICO',1,2017))
GO


--hacer la funcion
CREATE FUNCTION fn_sucursal_mayor_gannancia_vehiculos(@estado VARCHAR (30) ,@mes SMALLINT, @ANIO SMALLINT)
	RETURNS TABLE AS
	RETURN(SELECT ID_SUCURSAL,Sucursal,GANANCIA_TOTAL_VEHICULOS  
		FROM fn_ganacia_total_vehiculos_por_suc(@estado,@mes,@ANIO)
		WHERE GANANCIA_TOTAL_VEHICULOS= (SELECT MAX (GANANCIA_TOTAL_VEHICULOS) 
									FROM fn_ganacia_total_vehiculos_por_suc(@estado,@mes,@ANIO))
	)
GO


--prueba
SELECT * FROM fn_sucursal_mayor_gannancia_vehiculos('ESTADO DE MEXICO',1,2017)
GO


	/*******************PASO 6**************************/
--drop TABLE MEJORES_SUCURSALES_POR_VEHICULOS_VENDIDOS
CREATE TABLE MEJORES_SUCURSALES_POR_VEHICULOS_VENDIDOS(
	ID_SUCURSAL  VARCHAR(15),
	SUCURSAL VARCHAR(300),
	ESTADO VARCHAR(30),
	MES SMALLINT,
	AÑO SMALLINT,
	GANANCIA_TOTAL money
)
GO

	/****************************************************/
--PRUEBA--  SELECT   * FROM MEJORES_SUCURSALES_POR_VEHICULOS_VENDIDOS         
--DELETE FROM MEJORES_SUCURSALES_POR_VEHICULOS_VENDIDOS

SELECT DISTINCT  * FROM MEJORES_SUCURSALES_POR_VEHICULOS_VENDIDOS  
	ORDER BY 1
GO

	/****************************************************/
CREATE PROC TRANS_LLENA_MEJ_SUC_POR_VEH_VEN
	@ESTADO VARCHAR (30) ,@MES SMALLINT, @AÑO SMALLINT
	AS
	  BEGIN TRAN TRANS_MEJORES_SUCURSALES
	  DECLARE
        @ID_SUCURSAL VARCHAR(15), @SUCURSAL VARCHAR(300),@GANANCIA_TOTAL money

	  	SELECT @ID_SUCURSAL  = ID_SUCURSAL,@SUCURSAL=Sucursal,@GANANCIA_TOTAL=GANANCIA_TOTAL_VEHICULOS
		FROM dbo.fn_sucursal_mayor_gannancia_vehiculos(@ESTADO,@MES,@AÑO)

		INSERT INTO MEJORES_SUCURSALES_POR_VEHICULOS_VENDIDOS
			VALUES(@ID_SUCURSAL,@SUCURSAL,@ESTADO,@MES,@AÑO,@GANANCIA_TOTAL)

		IF(@@ERROR > 0)
		  BEGIN
	    	PRINT 'ERRROR....'
		    ROLLBACK TRAN TRANS_LLENA_MEJ_SUC_POR_VEH_VEN
          END
		ELSE 
		  BEGIN
		     PRINT 'TRANSACCION CORRECCTA....'
			 COMMIT TRAN TRANS_LLENA_MEJ_SUC_POR_VEH_VEN
          END
 GO
 
 
/**************************************************************/
--PRUEBA:  COLOR: amarillo, blanco escarcha, Camello, Gris,Negro, Plata, Rojo, Rojo/Negro, Verde, Vino;  
--			TIPO: Automático, Electrico, Electrico/automático, Electrico/estandar, Estandar

SELECT * FROM DISTRIBUIDOR_O_SUCURSAL


SELECT * FROM MEJORES_SUCURSALES_POR_VEHICULOS_VENDIDOS

EXEC  TRANS_LLENA_MEJ_SUC_POR_VEH_VEN 'ESTADO DE MEXICO',1,2017







/**********************************************************************
 TRANSACCION OLPT PARA LLENAR LA TABLA COMPLETA DE 'VEHICULOS-MEJORES_SUCURSALES_POR_VEHICULOS_VENDIDOS'  EN 
TODOS LOS MESES DE ANIO PARA LAS mejores sucursales con mas ganancias en la venta de vehiculos
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/

--delete from MEJORES_SUCURSALES_POR_VEHICULOS_VENDIDOS
SELECT * FROM MEJORES_SUCURSALES_POR_VEHICULOS_VENDIDOS
GO


SELECT * FROM VEHICULO
GO
/********************************************************************/


CREATE VIEW fn_total_estados AS
SELECT ESTADO estados FROM DISTRIBUIDOR_O_SUCURSAL GROUP BY ESTADO
go


create proc sp_trans_mejores_sucursales_por_vehiculos_vendidos_etl
	@MES_INICIO SMALLINT ,@MES_FIN  SMALLINT, @ANIO SMALLINT 
as
BEGIN
	SET TRANSACTION ISOLATION LEVEL  READ COMMITTED
	BEGIN TRAN tran_mejores_suc_vehiculos

		DECLARE 
		@ESTADO VARCHAR(30),
		@NO_DE_ESTADOS SMALLINT,
		@CONT_ESTADOS SMALLINT = 1,
		@CONT_MES SMALLINT

		--SELECT count(estados) FROM dbo.fn_total_estados
	  SELECT  @NO_DE_ESTADOS = count(estados) FROM dbo.fn_total_estados
	  --print @@NO_DE_ESTADOS

	DECLARE ESTADOS_CURSOR CURSOR FOR
		SELECT estados
		FROM dbo.fn_total_estados(HOLDLOCK)   
		           
    OPEN ESTADOS_CURSOR;
	WHILE( @CONT_ESTADOS <= @NO_DE_ESTADOS)
    BEGIN
       FETCH NEXT FROM ESTADOS_CURSOR INTO @ESTADO
	    set @CONT_MES = @MES_INICIO
        WHILE( @CONT_MES <= @MES_FIN)
	    BEGIN 
	        EXEC  TRANS_LLENA_MEJ_SUC_POR_VEH_VEN @estado,@CONT_MES,@ANIO
	    	set @CONT_MES = @CONT_MES + 1
	    END 
	     SET @CONT_ESTADOS = @CONT_ESTADOS + 1
    END  
     CLOSE ESTADOS_CURSOR;
     DEALLOCATE ESTADOS_CURSOR;
	 IF @@ERROR <> 0  --  !=
      BEGIN
       RAISERROR(N'MENSAJE', 16, 1);
       PRINT N'Error = ' + CAST(@@ERROR AS NVARCHAR(8));
       ROLLBACK TRAN tran_mejores_suc_vehiculos
     END
    ELSE  
      COMMIT TRAN tran_mejores_suc_vehiculos  
END
GO


/****************************************************************/
--PRUEBA  
EXEC sp_trans_mejores_sucursales_por_vehiculos_vendidos_etl 1,12,2017
GO


--delete from MEJORES_SUCURSALES_POR_VEHICULOS_VENDIDOS
SELECT * FROM MEJORES_SUCURSALES_POR_VEHICULOS_VENDIDOS
order by estado,mes,año
GO



