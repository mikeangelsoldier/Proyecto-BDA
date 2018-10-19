
/*
  Obtener la SUCURSAL ubicada en el ESTADO X que haga generado la mayor CANTIDAD DE GANANCIAS
  en los SERVICIOS ofrecidos en el MES X, AÑO X
  en una nueva tabla los resultados de 'N' transacciones
  para realizar un posible CUBO OLAP*/
  /*LOGICA 
    PASO 1. Obtener los registros de las FACT_SERVICIO realizadas en el ESTADO X en todas las SUCURSALES
		Obtener las FECT_SERVICIO en en MES X, AÑO X
    PASO 2. En base a las FACT_SERVICIO del punto anterior, encontrar todos los DET_FACT_SERVICIO para detectar 
		los servicios ofrecidos dentro de la misma FACT_SERVICIO
	PASO 3. Obtener los PRECIOS fijos de cada SERVICIO y agregarlo en una nueva columna llamada IMPORTE_TOTAL 
		para cada una de las FACT_SERVICIO. 
	PASO 4. Sumar el IMPORTE_TOTAL de todas las FACT_SERVICIO
	PASO 5. obtener la sucursal que obtuvo la mayor CANTIDAD_DE_GANANCIAS en base al valor 
		maximo de las sumas de los importes obtenidos en le punto anterior
	PASO 6. Crear una nueva tabla donde se agreguen las sucursales con 
		mas ganancias en servicios prestados durante el mes especificado y año especificado
	
	*/
	
	/******************************
	PASO 1. Obtener los registros de las FACT_SERVICIO realizadas en el ESTADO X en todas las SUCURSALES
	*********************************/
USE Nissan
GO

--obtener las FECT_SERVICIO realizadas en el MES X, AÑO X
create function fn_fact_servicios_mes_año(@mes SMALLINT, @ANIO smallint)
	returns TABLE
	AS
	  RETURN(select FK_DISTRIBUIDORA,ID_FACT_SERVICIO, FECHA from FACT_SERVICIO
	         where  month(FECHA)=@MES and year(FECHA) = @ANIO) 
    GO

--PRUEBA 
--SELECT * FROM FACT_SERVICIO ORDER BY FECHA
SELECT * FROM DBO.fn_fact_servicios_mes_año(1,2017)--FACT_SERVICIOS realizadas en el MES XX, ANIO XXXX
GO



--obtener las FECT_SERVICIO realizadas en el MES X, AÑO X en las sucursales del estado X
--SELECT * FROM DISTRIBUIDOR_O_SUCURSAL

CREATE FUNCTION fn_fact_servicios_estado_mes_año(@estado VARCHAR (30) ,@mes SMALLINT, @ANIO SMALLINT)
	RETURNS TABLE AS
	RETURN(SELECT s.ID_SUCURSAL,s.DESCRIPCION,fact.ID_FACT_SERVICIO,fact.FECHA FROM DBO.fn_fact_servicios_mes_año(@mes,@ANIO) AS fact
		JOIN DISTRIBUIDOR_O_SUCURSAL AS s 
			ON fact.FK_DISTRIBUIDORA=s.ID_SUCURSAL
			WHERE s.ESTADO=@estado
	)
GO

--PRUEBA 

SELECT * FROM DBO.fn_fact_servicios_estado_mes_año('ESTADO DE MEXICO',1,2017)--FACT_SERVICIOS realizadas en el MES XX, ANIO XXXX, en el ESTADO X
GO


/******************************
	PASO 2. En base a las FACT_SERVICIO del punto anterior, encontrar todos los DET_FACT_SERVICIO para detectar 
		los servicios ofrecidos dentro de la misma FACT_SERVICIO
	*********************************/
	--obtener los detalles de cada factura 
	SELECT * FROM DBO.fn_fact_servicios_estado_mes_año('ESTADO DE MEXICO',1,2017)  a
	INNER JOIN DET_FACT_SERVICIO b ON a.ID_FACT_SERVICIO=b.FK_FACT_SERVICIO
	ORDER BY ID_FACT_SERVICIO,FK_SERVICIO
	GO

	--crear la funcion
CREATE FUNCTION fn_fact_servicios_detalles(@estado VARCHAR (30) ,@mes SMALLINT, @ANIO SMALLINT)
	RETURNS TABLE AS
	RETURN(SELECT a.ID_SUCURSAL,a.DESCRIPCION,a.ID_FACT_SERVICIO,b.FK_SERVICIO FROM DBO.fn_fact_servicios_estado_mes_año(@estado,@mes,@ANIO)  a
		INNER JOIN DET_FACT_SERVICIO b ON a.ID_FACT_SERVICIO=b.FK_FACT_SERVICIO
	)
GO

--prueba
SELECT * FROM DBO.fn_fact_servicios_detalles('ESTADO DE MEXICO',1,2017)--DET_FACT_SERVICIO de las FACT_SERVICIO
GO


	/******************************
	PASO 3. Obtener los PRECIOS fijos de cada SERVICIO y agregarlo en una nueva columna llamada IMPORTE_TOTAL 
		para cada una de las FACT_SERVICIO. 
	*********************************/
--obtener los precios de cada servicio por individual

SELECT fact_det.ID_SUCURSAL,fact_det.DESCRIPCION Sucursal,fact_det.ID_FACT_SERVICIO,s.ID_SERVICIO,s.PRECIO  FROM DBO.fn_fact_servicios_detalles('ESTADO DE MEXICO',1,2017) fact_det
	INNER JOIN SERVICIO s ON fact_det.FK_SERVICIO=s.ID_SERVICIO
GO

--crear la funcion
CREATE FUNCTION fn_precios_por_det_servicio(@estado VARCHAR (30) ,@mes SMALLINT, @ANIO SMALLINT)
	RETURNS TABLE AS
	RETURN(SELECT fact_det.ID_SUCURSAL,fact_det.DESCRIPCION Sucursal,fact_det.ID_FACT_SERVICIO,s.ID_SERVICIO,s.PRECIO 
		FROM DBO.fn_fact_servicios_detalles(@estado,@mes,@ANIO) fact_det
		INNER JOIN SERVICIO s ON fact_det.FK_SERVICIO=s.ID_SERVICIO
	)
GO

--prueba
SELECT * FROM fn_precios_por_det_servicio('ESTADO DE MEXICO',1,2017)
GO

--colocar la suma total de cada DET_FACT_SERVICIO para cada FACT_SERVICIO

SELECT ID_SUCURSAL,Sucursal,ID_FACT_SERVICIO,  sum(PRECIO) importe FROM fn_precios_por_det_servicio('ESTADO DE MEXICO',1,2017) 
	GROUP BY ID_SUCURSAL,Sucursal,ID_FACT_SERVICIO
GO

--crear la funcion
CREATE FUNCTION fn_importe_total_det_fact_servicio(@estado VARCHAR (30) ,@mes SMALLINT, @ANIO SMALLINT)
	RETURNS TABLE AS
	RETURN(SELECT ID_SUCURSAL,Sucursal,ID_FACT_SERVICIO, sum(PRECIO) IMPORTE_TOTAL FROM fn_precios_por_det_servicio(@estado,@mes,@ANIO) 
	GROUP BY ID_SUCURSAL,Sucursal,ID_FACT_SERVICIO
	)
GO

--prueba
SELECT * FROM fn_importe_total_det_fact_servicio('ESTADO DE MEXICO',1,2017)
GO

SELECT * FROM fn_importe_total_det_fact_servicio('ESTADO DE MEXICO',1,2017)
ORDER BY ID_SUCURSAL
GO



	/******************************
	PASO 4. Sumar el IMPORTE_TOTAL de todas las FACT_SERVICIO 
	*********************************/
--sumar el IMPORTE_TOTAL de todas las FACT_SERVICIO para cada SUCURSAL
SELECT ID_SUCURSAL,Sucursal,sum(IMPORTE_TOTAL) GANANCIA_TOTAL FROM fn_importe_total_det_fact_servicio('ESTADO DE MEXICO',1,2017)
GROUP BY ID_SUCURSAL,SUCURSAL
GO

--crear la funcion
CREATE FUNCTION fn_ganacia_total_servicios_por_suc(@estado VARCHAR (30) ,@mes SMALLINT, @ANIO SMALLINT)
	RETURNS TABLE AS
	RETURN(SELECT ID_SUCURSAL,Sucursal,sum(IMPORTE_TOTAL) GANANCIA_TOTAL_SERVICIOS FROM fn_importe_total_det_fact_servicio(@estado,@mes,@ANIO)
		GROUP BY ID_SUCURSAL,SUCURSAL
	)
GO

--prueba
SELECT * FROM fn_ganacia_total_servicios_por_suc('ESTADO DE MEXICO',1,2017)
GO


	/******************************
PASO 5. obtener la sucursal que obtuvo la mayor cantidad de GANANCIA_TOTAL_SERVICIOS 
	*********************************/

SELECT ID_SUCURSAL,Sucursal,GANANCIA_TOTAL_SERVICIOS  
	FROM fn_ganacia_total_servicios_por_suc('ESTADO DE MEXICO',1,2017)
	WHERE GANANCIA_TOTAL_SERVICIOS= (SELECT MAX (GANANCIA_TOTAL_SERVICIOS) 
									FROM fn_ganacia_total_servicios_por_suc('ESTADO DE MEXICO',1,2017))
GO


--hacer la funcion
CREATE FUNCTION fn_sucursal_mayor_gannancia_servicios(@estado VARCHAR (30) ,@mes SMALLINT, @ANIO SMALLINT)
	RETURNS TABLE AS
	RETURN(SELECT ID_SUCURSAL,Sucursal,GANANCIA_TOTAL_SERVICIOS  
		FROM fn_ganacia_total_servicios_por_suc(@estado,@mes,@ANIO)
		WHERE GANANCIA_TOTAL_SERVICIOS= (SELECT MAX (GANANCIA_TOTAL_SERVICIOS) 
									FROM fn_ganacia_total_servicios_por_suc(@estado,@mes,@ANIO))
	)
GO


--prueba
SELECT * FROM fn_sucursal_mayor_gannancia_servicios('ESTADO DE MEXICO',1,2016)
GO


	/*******************PASO 6**************************/
--drop TABLE MEJORES_SUCURSALES_POR_SERVICIOS_PRESTADOS
CREATE TABLE MEJORES_SUCURSALES_POR_SERVICIOS_PRESTADOS(
	ID_SUCURSAL  VARCHAR(15),
	SUCURSAL VARCHAR(300),
	ESTADO VARCHAR(30),
	MES SMALLINT,
	AÑO SMALLINT,
	GANANCIA_TOTAL money
)
GO

	/****************************************************/
--PRUEBA--  SELECT   * FROM MEJORES_SUCURSALES_POR_SERVICIOS_PRESTADOS          
--DELETE FROM MEJORES_SUCURSALES_POR_SERVICIOS_PRESTADOS

SELECT DISTINCT  * FROM MEJORES_SUCURSALES_POR_SERVICIOS_PRESTADOS  
	ORDER BY 1
GO

	/****************************************************/
CREATE PROC TRANS_LLENADO_MEJORES_SUCURSALES
	@ESTADO VARCHAR (30) ,@MES SMALLINT, @AÑO SMALLINT
	AS
	  BEGIN TRAN TRANS_MEJORES_SUCURSALES
	  DECLARE
        @ID_SUCURSAL VARCHAR(15), @SUCURSAL VARCHAR(300),@GANANCIA_TOTAL money

	  	SELECT @ID_SUCURSAL  = ID_SUCURSAL,@SUCURSAL=Sucursal,@GANANCIA_TOTAL=GANANCIA_TOTAL_SERVICIOS
		FROM dbo.fn_sucursal_mayor_gannancia_servicios(@ESTADO,@MES,@AÑO)

		INSERT INTO MEJORES_SUCURSALES_POR_SERVICIOS_PRESTADOS 
			VALUES(@ID_SUCURSAL,@SUCURSAL,@ESTADO,@MES,@AÑO,@GANANCIA_TOTAL)

		IF(@@ERROR > 0)
		  BEGIN
	    	PRINT 'ERRROR....'
		    ROLLBACK TRAN TRANS_MEJORES_SUCURSALES
          END
		ELSE 
		  BEGIN
		     PRINT 'TRANSACCION CORRECCTA....'
			 COMMIT TRAN TRANS_MEJORES_SUCURSALES
          END
 GO
 
 
/**************************************************************/
--PRUEBA:  COLOR: amarillo, blanco escarcha, Camello, Gris,Negro, Plata, Rojo, Rojo/Negro, Verde, Vino;  
--			TIPO: Automático, Electrico, Electrico/automático, Electrico/estandar, Estandar

SELECT * FROM DISTRIBUIDOR_O_SUCURSAL


SELECT * FROM MEJORES_SUCURSALES_POR_SERVICIOS_PRESTADOS

EXEC  TRANS_LLENADO_MEJORES_SUCURSALES 'ESTADO DE MEXICO',1,2017







/**********************************************************************
 TRANSACCION OLPT PARA LLENAR LA TABLA COMPLETA DE 'VEHICULOS-MEJORES_SUCURSALES_POR_SERVICIOS_PRESTADOS'  EN 
TODOS LOS MESES DE ANIO PARA LAS mejores sucursales con mas ganancias en la prestacion de servicios 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/

--delete from MEJORES_SUCURSALES_POR_SERVICIOS_PRESTADOS
SELECT * FROM MEJORES_SUCURSALES_POR_SERVICIOS_PRESTADOS
GO


SELECT * FROM VEHICULO
GO
/********************************************************************/

DROP VIEW fn_total_estados
go

CREATE VIEW fn_total_estados AS
SELECT ESTADO estados FROM DISTRIBUIDOR_O_SUCURSAL GROUP BY ESTADO
go


create proc sp_trans_mejores_sucursales_por_servicios_prestados_etl
	@MES_INICIO SMALLINT ,@MES_FIN  SMALLINT, @ANIO SMALLINT 
as
BEGIN
	SET TRANSACTION ISOLATION LEVEL  READ COMMITTED
	BEGIN TRAN tran_mejores

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
	        EXEC  TRANS_LLENADO_MEJORES_SUCURSALES @estado,@CONT_MES,@ANIO
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
       ROLLBACK TRAN tran_mejores 
     END
    ELSE  
      COMMIT TRAN tran_mejores    
END
GO


/****************************************************************/
--PRUEBA  
EXEC sp_trans_mejores_sucursales_por_servicios_prestados_etl 1,12,2017
GO


--delete from MEJORES_SUCURSALES_POR_SERVICIOS_PRESTADOS
SELECT * FROM MEJORES_SUCURSALES_POR_SERVICIOS_PRESTADOS
order by estado,mes,año
GO



