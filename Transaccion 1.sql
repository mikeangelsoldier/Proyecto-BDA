
/*
  Obtener el VEHICULO  que mayor cantidad se haya VENDIDO en el 
  mes 'X', año 'Y'  de un COLOR  'Z', TIPO  'T';  almacenelo
  en una nueva tabla los resultados de 'N' transacciones
  para realizar un posible CUBO OLAP*/
  /*LOGICA 
    PASO 1. obtener las VENTAS_VEHICULO realizados en 'X' mes, 'Y' año
    PASO2.  Obtener todos los VEHICULOS  que son de 'X' COLOR 
	        'Y'  TIPO 
	PASO 3. Obtener las VEICHULOS_PEDIDOS(CANT_PEDIDA)  de
	        acuerdo a el resultado del  PASO 2 y PASO 1
	PASO 4. Calcular la sumatoria de cada  VEHICULO
	PASO 5. Obtener el(los) VEHICULOS con mayor cantidad 
	PASO 6. ALMACENAR resultado en la nueva tabla dentro de la transaccion. */
	
	/***************************************************************/
USE Nissan
GO

	create function fn_ventas_vehiculos(@mes SMALLINT, @año smallint)
	returns TABLE
	AS
	  RETURN(select ID_VENTA_VEHICULO, FECHA from VENTA_VEHICULO
	         where  month(FECHA)=@MES and year(FECHA) = @AÑO) 
    GO
   /*******************************************************************/
	--PRUEBA 
	--SELECT * FROM VENTA_VEHICULO 

SELECT * FROM DBO.fn_ventas_vehiculos(1,2017)--vehiculos vendidos en el MES XX, año XXXX
GO
    
	   /*************************************************************/
CREATE  FUNCTION FN_VEHICULOS(@TIPO VARCHAR(300), @COLOR VARCHAR(50))
	RETURNS TABLE
	AS 
		RETURN( SELECT ID_VEHICULO,MODELO, COLOR FROM VEHICULO  
	           WHERE TIPO = @TIPO AND COLOR = @COLOR )
GO
	   /************************************************************/
--SELECT * FROM VEHICULO order by  TIPO

--PRUEBA   SELECT * FROM DBO.FN_VEHICULOS('automático','amarillo')
GO

/******************************************************************************************/
CREATE FUNCTION FN_SUMA_TOTALES(@MES SMALLINT, @AÑO SMALLINT,@TIPO VARCHAR(300), @COLOR VARCHAR(50))
	   RETURNS TABLE
	   AS 
	    RETURN(SELECT FK_VEHICULO, SUM(CANTIDAD) SUM_TOT
	    FROM DET_VENTA_VEHICULO WHERE FK_VENTA_VEHICULO IN
	          (SELECT ID_VENTA_VEHICULO FROM DBO.fn_ventas_vehiculos(@MES,@AÑO))
			  AND FK_VEHICULO 
			    IN (SELECT ID_VEHICULO FROM FN_VEHICULOS(@TIPO, @COLOR ))
       GROUP BY FK_VEHICULO 
	   )
GO

/************************************************************************************/
-- PRUEBA   
SELECT * FROM DBO.FN_SUMA_TOTALES (1,2017,'automático','amarillo') WHERE SUM_TOT =   
			( SELECT MAX(SUM_TOT) FROM DBO.FN_SUMA_TOTALES (1,2017,'automático','amarillo'))
GO


	/*******************PASO 6**************************/
CREATE TABLE VEHICULOS_DEMANDADOS(
	ID_VEHICULO  VARCHAR(15),
	MES SMALLINT,
	AÑO SMALLINT,
	TIPO VARCHAR(300),
	COLOR VARCHAR(50)   
)
GO
	/****************************************************/
--PRUEBA--  SELECT   * FROM VEHICULOS_DEMANDADOS          DELETE FROM VEHICULOS_DEMANDADOS
           SELECT DISTINCT  * FROM VEHICULOS_DEMANDADOS 
		   ORDER BY 1
GO

	/****************************************************/
	CREATE PROC  TRANS_LLENADO_VEHICULOS_DEMANDADOS
	@MES SMALLINT, @AÑO SMALLINT,@TIPO VARCHAR(300), @COLOR VARCHAR(50)
	AS
	  BEGIN TRAN TRANS_VEHICULOS_DEMANDADOS
	  DECLARE
        @ID_VEHICULO VARCHAR(15)
	  	SELECT @ID_VEHICULO  = FK_VEHICULO 
		FROM DBO.FN_SUMA_TOTALES (@MES, @AÑO,@TIPO, @COLOR)
		 WHERE SUM_TOT =   
        ( SELECT MAX(SUM_TOT) FROM DBO.FN_SUMA_TOTALES (@MES, @AÑO,@TIPO, @COLOR))
		INSERT INTO VEHICULOS_DEMANDADOS VALUES(@ID_VEHICULO,@MES,@AÑO,@TIPO,@COLOR)
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
SELECT * FROM VEHICULO order by TIPO


SELECT * FROM VEHICULO 
SELECT * FROM VEHICULOS_DEMANDADOS

EXEC  TRANS_LLENADO_VEHICULOS_DEMANDADOS  1,2017,'automático','amarillo'
EXEC  TRANS_LLENADO_VEHICULOS_DEMANDADOS  2,2017,'automático','amarillo'
EXEC  TRANS_LLENADO_VEHICULOS_DEMANDADOS  2,2018,'automático','negro'
EXEC  TRANS_LLENADO_VEHICULOS_DEMANDADOS  3,2017,'automático','amarillo'
EXEC  TRANS_LLENADO_VEHICULOS_DEMANDADOS  4,2017,'automático','amarillo'






/**********************************************************************
 TRANSACCION OLPT PARA LLENAR LA TABLA COMPLETA DE 'VEHICULOS-DEMANDADOS'  EN 
TODOS LOS MESES DE AÑO PARA TODOS LOS VEHICULOS DE 'COLOR'  Y 'TIPO' REALIZAR 
'ETL' EN UN CUBO OLAP
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/

SELECT * FROM VEHICULOS_DEMANDADOS
delete from VEHICULOS_DEMANDADOS


SELECT * FROM VEHICULO
/********************************************************************/
/*
create   proc sp_trans_ped_etl
@MES_INICIO SMALLINT ,@MES_FIN  SMALLINT, @AÑO SMALLINT 
as
BEGIN
      SET TRANSACTION ISOLATION LEVEL  READ COMMITTED
      BEGIN TRAN tran12
    DECLARE 
      @NO_ART CHAR(10),
	  @TALLA CHAR(2) ,
	  @COLOR CHAR(15),
	  @NO_DE_ARTS SMALLINT,
	  @CONT_ARTS SMALLINT = 1,
	  @CONT_MES SMALLINT

	  SELECT  @NO_DE_ARTS =COUNT(*) FROM ARTICULO
	  --print @no_de_arts
     DECLARE ARTICULO_Cursor CURSOR FOR
         SELECT NO_ART, TALLA, COLOR
         FROM ARTICULO(HOLDLOCK)              
     OPEN ARTICULO_Cursor;
    WHILE( @CONT_ARTS <= @NO_DE_ARTS)
    BEGIN
       FETCH NEXT FROM ARTICULO_Cursor INTO @NO_ART, @TALLA,@COLOR
	    set @CONT_MES = @MES_INICIO
        WHILE( @CONT_MES <= @MES_FIN)
	    BEGIN 
	        EXEC  TRANS12  @CONT_MES, @AÑO, @talla, @color
	    	set @CONT_MES = @CONT_MES + 1
	    END 
	     SET @CONT_ARTS = @CONT_ARTS + 1
    END  
     CLOSE articulo_Cursor;
     DEALLOCATE ARTICULO_Cursor;
	 IF @@ERROR <> 0  --  !=
      BEGIN
       RAISERROR(N'MENSAJE', 16, 1);
       PRINT N'Error = ' + CAST(@@ERROR AS NVARCHAR(8));
       ROLLBACK TRAN tran12 
     END
    ELSE  
      COMMIT TRAN tran12    
END
GO

*/
/****************************************************************//
--PRUEBA  

/* 
EXEC   sp_trans_ped_etl  9,12,2018



SELECT * FROM ARTICULOS_DEMANDADOS 
GO

SELECT DISTINCT * FROM ARTICULOS_DEMANDADOS 
ORDER BY 1,2
GO

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









































