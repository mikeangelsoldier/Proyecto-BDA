
/*
  Obtener el VEHICULO  que mayor cantidad se haya VENTA en el 
  mes 'X', año 'Y'  de un COLOR  'Z', MODELO  'T';  almacenelo
  en una nueva tabla los resultados de 'N' transacciones
  para realizar un posible CUBO OLAP*/
  /*LOGICA 
    PASO 1. obtener las VENTAS_VEHICULO realizados en 'X' mes, 'Y' año
    PASO2.  Obtener todos los VEHICULOS  que son de 'X' COLOR 
	        'Y'  MODELO 
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

SELECT * FROM DBO.fn_ventas_vehiculos(1,2015)
    
	   /*************************************************************/
	   CREATE FUNCTION FN_ARTICULOS(@TALLA CHAR(2), @COLOR CHAR(15))
	   RETURNS TABLE
	   AS 
        RETURN( SELECT NO_ART,TALLA, COLOR FROM ARTICULO  
	           WHERE COLOR = @COLOR AND TALLA = @TALLA )
       GO
	   /************************************************************/

--PRUEBA   SELECT * FROM DBO.FN_ARTICULOS('25','NEGRO')


       /******************************************************************************************/
       CREATE FUNCTION FN_SUMA_TOTALES(@MES SMALLINT, @AÑO SMALLINT,@TALLA CHAR(2), @COLOR CHAR(15))
	   RETURNS TABLE
	   AS 
	    RETURN(SELECT NO_ART, SUM(CANT_PEDIDA) SUM_TOT
	    FROM LINEA_DETALLE WHERE NO_FOLIO IN
	          (SELECT NO_FOLIO FROM DBO.FN_PEDIDOS(@MES,@AÑO))
			  AND NO_ART 
			    IN (SELECT NO_ART FROM FN_ARTICULOS(@TALLA, @COLOR))
       GROUP BY NO_ART 
	   )
/************************************************************************************/
-- PRUEBA   
	SELECT * FROM DBO.FN_SUMA_TOTALES (9,2018,'25','NEGRO') WHERE SUM_TOT =   
    ( SELECT MAX(SUM_TOT) FROM DBO.FN_SUMA_TOTALES (9,2018,'25','NEGRO'))

	/*********************************************/
	CREATE TABLE ARTICULOS_DEMANDADOS(
	NO_ART  CHAR(10),
	MES SMALLINT,
	AÑO SMALLINT,
	TALLA CHAR(2),
	COLOR CHAR(15)   )
	/****************************************************/
PRUEBA--  SELECT   * FROM ARTICULOS_DEMANDADOS          DELETE FROM ARTICULOS_DEMANDADOS
           SELECT DISTINCT  * FROM ARTICULOS_DEMANDADOS 
		   ORDER BY 1


	/****************************************************/
	CREATE PROC  TRANS12
	@MES SMALLINT, @AÑO SMALLINT,@TALLA CHAR(2), @COLOR CHAR(15)
	AS
	  BEGIN TRAN TRANSA_12
	  DECLARE
        @NO_ART CHAR(10)
	  	SELECT @NO_ART  = NO_ART 
		FROM DBO.FN_SUMA_TOTALES (@MES, @AÑO,@TALLA, @COLOR)
		 WHERE SUM_TOT =   
        ( SELECT MAX(SUM_TOT) FROM DBO.FN_SUMA_TOTALES (@MES, @AÑO,@TALLA, @COLOR))
		INSERT INTO ARTICULOS_DEMANDADOS VALUES(@NO_ART,@MES,@AÑO,@TALLA,@COLOR)
		IF(@@ERROR > 0)
		  BEGIN
	    	PRINT 'ERRROR....'
		    ROLLBACK TRAN TRANSA_12
          END
		ELSE 
		  BEGIN
		     PRINT 'TRANSACCION CORRECCTA....'
			 COMMIT TRAN TRANSA_12
          END
/**************************************************************/
--PRUEBA: VINO, NEGRO, BLANCO, CAFE,AMARILLO, ROJO;  TALLA 22 A 29, CH MD, GD, 
EXEC  TRANS12  9,2018,'25','NEGRO'
EXEC  TRANS12  9,2018,'23','NEGRO'
EXEC  TRANS12  8,2018,'25','NEGRO'
EXEC  TRANS12  10,2018,'25','NEGRO'
EXEC  TRANS12  1,2019,'25','NEGRO'
EXEC  TRANS12  9,2018,'26','BLANCO'
EXEC  TRANS12  9,2018,'25','ROJO'
EXEC  TRANS12  9,2018,'25','CAFE'
EXEC  TRANS12  2,2019,'27','NEGRO'
EXEC  TRANS12  12,2018,'23','NEGRO'
EXEC  TRANS12  12,2018,'26','vino'
EXEC  TRANS12  11,2018,'23','blanco'
EXEC  TRANS12  2,2019,'22','AMARILLO'
EXEC  TRANS12  9,2018,'26','CAFE'
EXEC  TRANS12  9,2018,'25','BLANCO'
EXEC  TRANS12  9,2018,'23','BLANCO'
EXEC  TRANS12  9,2018,'27','rojo'




/**********************************************************************
 TRANSACCION OLPT PARA LLENAR LA TABLA COMPLETA DE 'ARTICULOS-DEMANDADOS'  EN 
TODOS LOS MESES DE AÑO PARA TODOS LOS ARTICULOS DE 'COLOR'  Y 'TALLA' REALIZAR 
'ETL' EN UN CUBO OLAP
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/

SELECT * FROM ARTICULOS_DEMANDADOS
delete from ARTICULOS_DEMANDADOS


SELECT * FROM ARTICULO
/********************************************************************/
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
/****************************************************************//
--PRUEBA   
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











































