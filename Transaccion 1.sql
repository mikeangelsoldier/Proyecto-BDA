
/*
  Obtener el VEHICULO  que mayor cantidad se haya VENDIDO en el 
  mes 'X', ANIO 'Y'  de un COLOR  'Z', MODELO  'M';  almacenelo
  en una nueva tabla los resultados de 'N' transacciones
  para realizar un posible CUBO OLAP*/
  /*LOGICA 
    PASO 1. obtener las VENTAS_VEHICULO realizados en 'X' mes, 'Y' ANIO
    PASO2.  Obtener todos los VEHICULOS  que son de 'X' COLOR 
	        'Y'  MODELO 
	PASO 3. Obtener las VEHICULOS_PEDIDOS(CANT_PEDIDA)  de
	        acuerdo a el resultado del  PASO 2 y PASO 1
	PASO 4. Calcular la sumatoria de cada  VEHICULO
	PASO 5. Obtener el(los) VEHICULOS con mayor cantidad 
	PASO 6. ALMACENAR resultado en la nueva tabla dentro de la transaccion. */
	
	/***************************************************************/
USE Nissan
GO

	create function fn_ventas_vehiculos(@mes SMALLINT, @ANIO smallint)
	returns TABLE
	AS
	  RETURN(select ID_VENTA_VEHICULO, FECHA from VENTA_VEHICULO
	         where  month(FECHA)=@MES and year(FECHA) = @ANIO) 
    GO
   /*******************************************************************/
	--PRUEBA 
	--SELECT * FROM VENTA_VEHICULO 

SELECT * FROM DBO.fn_ventas_vehiculos(1,2017)--vehiculos vendidos en el MES XX, ANIO XXXX
GO
    
	   /*************************************************************/
CREATE FUNCTION FN_VEHICULOS( @MODELO VARCHAR(300),@COLOR VARCHAR(200))
	RETURNS TABLE
	AS 
		RETURN( SELECT ID_VEHICULO,MODELO, COLOR FROM VEHICULO  
	           WHERE MODELO = @MODELO AND COLOR = @COLOR )
GO

	   /************************************************************/
--SELECT * FROM VEHICULO order by  COLOR

--PRUEBA   SELECT * FROM DBO.FN_VEHICULOS('LUCINO','amarillo')
GO

/******************************************************************************************/
--vehiculo mas vendido en el MES X, ANIO Y,  del modelo A, COLOR B
CREATE FUNCTION FN_SUMA_TOTALES(@MES SMALLINT, @ANIO SMALLINT,@MODELO VARCHAR(300), @COLOR VARCHAR(200))
	   RETURNS TABLE
	   AS 
	    RETURN(SELECT FK_VEHICULO, SUM(CANTIDAD) SUM_TOT
	    FROM DET_VENTA_VEHICULO WHERE FK_VENTA_VEHICULO IN
	          (SELECT ID_VENTA_VEHICULO FROM DBO.fn_ventas_vehiculos(@MES,@ANIO))
			  AND FK_VEHICULO 
			    IN (SELECT ID_VEHICULO FROM FN_VEHICULOS(@MODELO, @COLOR ))
       GROUP BY FK_VEHICULO 
	   )
GO

/************************************************************************************/
-- PRUEBA   
SELECT * FROM DBO.FN_SUMA_TOTALES (1,2017,'VERSA','amarillo') WHERE SUM_TOT =   
			( SELECT MAX(SUM_TOT) FROM DBO.FN_SUMA_TOTALES (1,2017,'VERSA','amarillo'))
GO


	/*******************PASO 6**************************/
CREATE TABLE VEHICULOS_DEMANDADOS(
	ID_VEHICULO  VARCHAR(15),
	MES SMALLINT,
	ANIO SMALLINT,
	MODELO VARCHAR(300),
	COLOR VARCHAR(200)   
)
GO
	/****************************************************/
--PRUEBA--  SELECT   * FROM VEHICULOS_DEMANDADOS          DELETE FROM VEHICULOS_DEMANDADOS
SELECT DISTINCT  * FROM VEHICULOS_DEMANDADOS  
	ORDER BY 1
GO

	/****************************************************/
CREATE PROC TRANS_LLENADO_VEHICULOS_DEMANDADOS
	@MES SMALLINT, @ANIO SMALLINT,@MODELO VARCHAR(300), @COLOR VARCHAR(200)
	AS
	  BEGIN TRAN TRANS_VEHICULOS_DEMANDADOS
	  DECLARE
        @ID_VEHICULO VARCHAR(15)
	  	SELECT @ID_VEHICULO  = FK_VEHICULO 
		FROM DBO.FN_SUMA_TOTALES (@MES, @ANIO,@MODELO, @COLOR)
		 WHERE SUM_TOT =   
        ( SELECT MAX(SUM_TOT) FROM DBO.FN_SUMA_TOTALES (@MES, @ANIO,@MODELO, @COLOR))
		INSERT INTO VEHICULOS_DEMANDADOS VALUES(@ID_VEHICULO,@MES,@ANIO,@MODELO,@COLOR)
		IF(@@ERROR > 0)
		  BEGIN
	    	PRINT 'ERRROR....'
		    ROLLBACK TRAN TRANS_VEHICULOS_DEMANDADOS
          END
		ELSE 
		  BEGIN
		     PRINT 'TRANSACCION CORRECCTA....'
			 COMMIT TRAN TRANS_VEHICULOS_DEMANDADOS
          END
 GO
 
 
/**************************************************************/
--PRUEBA:  COLOR: amarillo, blanco escarcha, Camello, Gris,Negro, Plata, Rojo, Rojo/Negro, Verde, Vino;  
--			TIPO: Automático, Electrico, Electrico/automático, Electrico/estandar, Estandar

SELECT * FROM VEHICULO order by COLOR
SELECT * FROM VEHICULO order by MODELO


SELECT * FROM VEHICULO 
SELECT * FROM VEHICULOS_DEMANDADOS

EXEC  TRANS_LLENADO_VEHICULOS_DEMANDADOS  1,2017,'VERSA','amarillo'






/**********************************************************************
 TRANSACCION OLPT PARA LLENAR LA TABLA COMPLETA DE 'VEHICULOS-DEMANDADOS'  EN 
TODOS LOS MESES DE ANIO PARA TODOS LOS VEHICULOS DE 'COLOR'  Y 'TIPO' REALIZAR 
'ETL' EN UN CUBO OLAP
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/

delete from VEHICULOS_DEMANDADOS
SELECT * FROM VEHICULOS_DEMANDADOS


SELECT * FROM VEHICULO
GO
/********************************************************************/

create proc sp_trans_autos_demandados_etl
	@MES_INICIO SMALLINT ,@MES_FIN  SMALLINT, @ANIO SMALLINT 
as
BEGIN
	SET TRANSACTION ISOLATION LEVEL  READ COMMITTED
	BEGIN TRAN tran_demandas
		DECLARE 
		@ID_VEHICULO CHAR(15),
		@MODELO CHAR(300) ,
		@COLOR CHAR(200),
		@NO_DE_VEHICULOS SMALLINT,
		@CONT_VEHICULOS SMALLINT = 1,
		@CONT_MES SMALLINT

	  SELECT  @NO_DE_VEHICULOS =COUNT(*) FROM VEHICULO
	  --print @NO_DE_VEHICULOS

	DECLARE VEHICULO_CURSOR CURSOR FOR
		SELECT ID_VEHICULO, MODELO, COLOR
		FROM VEHICULO(HOLDLOCK)              
    OPEN VEHICULO_CURSOR;
	WHILE( @CONT_VEHICULOS <= @NO_DE_VEHICULOS)
    BEGIN
       FETCH NEXT FROM VEHICULO_CURSOR INTO @ID_VEHICULO, @MODELO,@COLOR
	    set @CONT_MES = @MES_INICIO
        WHILE( @CONT_MES <= @MES_FIN)
	    BEGIN 
	        EXEC  TRANS_LLENADO_VEHICULOS_DEMANDADOS  @CONT_MES, @ANIO, @MODELO, @color
	    	set @CONT_MES = @CONT_MES + 1
	    END 
	     SET @CONT_VEHICULOS = @CONT_VEHICULOS + 1
    END  
     CLOSE VEHICULO_CURSOR;
     DEALLOCATE VEHICULO_CURSOR;
	 IF @@ERROR <> 0  --  !=
      BEGIN
       RAISERROR(N'MENSAJE', 16, 1);
       PRINT N'Error = ' + CAST(@@ERROR AS NVARCHAR(8));
       ROLLBACK TRAN tran_demandas 
     END
    ELSE  
      COMMIT TRAN tran_demandas    
END
GO


/****************************************************************/
--PRUEBA  
EXEC sp_trans_autos_demandados_etl 1,12,2017
GO


SELECT * FROM VEHICULOS_DEMANDADOS
SELECT * FROM VEHICULO
GO


--EXEC sp_trans_autos_demandados_etl 1,12,2017
--GO



SELECT * FROM VEHICULOS_DEMANDADOS 
GO

SELECT DISTINCT * FROM VEHICULOS_DEMANDADOS 
ORDER BY 1,2,4,5
GO



/*
--articulos que no tienen demanda, osea aquellos que no están en la tabla articuos demandados
--forma 1
SELECT DISTINCT * FROM ARTICULO WHERE NO_ART NOT IN (
			SELECT DISTINCT NO_ART FROM ARTICULOS_DEMANDADOS
			)
GO

--forma 2
SELECT NO_ART FROM ARTICULO 
	EXCEPT 
SELECT DISTINCT NO_ART FROM ARTICULOS_DEMANDADOS	
GO

*/









































