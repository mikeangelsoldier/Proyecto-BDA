
/*
  Obtener el VEHICULO  que mayor cantidad se haya VENDIDO en el 
  mes 'X', ANIO 'Y'  de un COLOR  'Z', MODELO  'M', un TIPO 'T',, en el estado X ciudad Y;  almacenelo
  en una nueva tabla los resultados de 'N' transacciones
  para realizar un posible CUBO OLAP*/
  /*LOGICA 
    PASO 1. obtener las VENTAS_VEHICULO realizados en 'X' mes, 'Y' ANIO
    
    PASO2.  Obtener todos los VEHICULOS  que son de 'X' COLOR 
	        'Y'  MODELO , 'T' TIPO
	PASO2.2  Obtener todos los SUCURSAL  que son del estado E ciudad C
	
	PASO 3. Obtener las VEHICULOS_VENDIDOS(CANT_VENDIDA)  de
	        acuerdo a el resultado del  PASO 2 y PASO 1
	PASO 4. Calcular la sumatoria de cada  VEHICULO
	PASO 5. Obtener el(los) VEHICULOS con mayor cantidad 
	PASO 6. ALMACENAR resultado en la nueva tabla dentro de la transaccion. */
	
	/***************************************************************/
USE Nissan
GO

/***********   PASO 1. obtener las VENTAS_VEHICULO realizados en 'X' mes, 'Y' ANIO			***************/
--SELECT * FROM VENTA_VEHICULO  GO;

IF OBJECT_ID (N'dbo.fn_ventas_vehiculos', N'IF') IS NOT NULL 
    DROP FUNCTION dbo.fn_ventas_vehiculos;  
GO  
	create function fn_ventas_vehiculos(@mes SMALLINT, @ANIO smallint)
	returns TABLE
	AS
	  RETURN(select ID_VENTA_VEHICULO, FECHA from VENTA_VEHICULO
	         where  month(FECHA)=@MES and year(FECHA) = @ANIO) 
    GO
 
   -------------------------------------
	--PRUEBA 
	--SELECT * FROM VENTA_VEHICULO 


--SELECT * FROM DBO.fn_ventas_vehiculos(1,2016)--vehiculos vendidos en el MES XX, ANIO XXXX
SELECT * FROM DBO.fn_ventas_vehiculos(1,2017)--vehiculos vendidos en el MES XX, ANIO XXXX
GO




/***********   PASO2.  Obtener todos los VEHICULOS  que son de 'X' COLOR 
	        'Y'  MODELO , 'T' TIPO			***************/

--SELECT * FROM VEHICULO
IF OBJECT_ID (N'dbo.FN_VEHICULOS', N'IF') IS NOT NULL  
    DROP FUNCTION dbo.FN_VEHICULOS;  
GO  

CREATE  FUNCTION FN_VEHICULOS( @MODELO VARCHAR(300),@TIPO VARCHAR(300), @COLOR VARCHAR(200))
	RETURNS TABLE
	AS 
		RETURN( SELECT ID_VEHICULO,MODELO, TIPO,COLOR FROM VEHICULO  
	           WHERE MODELO = @MODELO AND COLOR = @COLOR AND TIPO=@TIPO)
GO

	   /************************************************************/
--SELECT * FROM VEHICULO order by  COLOR

/*
SELECT * FROM MODELOS
SELECT * FROM TIPOS
SELECT * FROM COLORES

*/
/*
SELECT * FROM VENTA_VEHICULO vv JOIN VEHICULO v ON vv.FK_VEHICULO=v.ID_VEHICULO ORDER BY ID_VEHICULO,MODELO
*/
/*
PRUEBA   

SELECT * FROM DBO.FN_VEHICULOS('370z','eléctrico/estándar','NEGRO AMATISTA metalizado')
*/


/***********   PASO2.2    Obtener todos los SUCURSAL  que son del estado E ciudad C			***************/

--SELECT * FROM DISTRIBUIDOR_O_SUCURSAL

IF OBJECT_ID (N'dbo.FN_SUCURSAL', N'IF') IS NOT NULL  
	DROP FUNCTION dbo.FN_SUCURSAL;  
GO 

CREATE FUNCTION FN_SUCURSAL( @ESTADO VARCHAR(30),@CIUDAD VARCHAR(100))
	RETURNS TABLE
	AS 
		RETURN( SELECT ID_SUCURSAL,ESTADO, CIUDAD FROM DISTRIBUIDOR_O_SUCURSAL  
	           WHERE ESTADO = @ESTADO AND CIUDAD = @CIUDAD )
GO


--SELECT * FROM DISTRIBUIDOR_O_SUCURSAL 


/*
PRUEBA   

SELECT * FROM DBO.FN_SUCURSAL('guanajuato','leon')
*/




/***********  PASO 3.3 VENTAS en fechas especificadas en la ubicacion especificada de
	        acuerdo a el resultado del  PASO 2 y PASO 1	y paso 3		***************/
	        
	       /*
	       ESTADO VARCHAR(30) NOT NULL ,
	CIUDAD VARCHAR (100) NOT NULL ,
	       
	       */ 
IF OBJECT_ID (N'dbo.FN_VENTAS_FECHAS_UBICACION', N'IF') IS NOT NULL  
	DROP FUNCTION dbo.FN_VENTAS_FECHAS_UBICACION;  
GO 	      
CREATE FUNCTION FN_VENTAS_FECHAS_UBICACION( @ESTADO VARCHAR(30),@CIUDAD VARCHAR(100),@mes SMALLINT, @ANIO smallint)
	RETURNS TABLE
	AS 
	RETURN(SELECT ID_VENTA_VEHICULO
			FROM VENTA_VEHICULO WHERE FK_DISTRIBUIDORA IN
				(SELECT ID_SUCURSAL FROM DBO.FN_SUCURSAL(@ESTADO,@CIUDAD ))
				AND 
				ID_VENTA_VEHICULO IN (SELECT ID_VENTA_VEHICULO FROM fn_ventas_vehiculos(@mes,@ANIO))
					
				
			GROUP BY ID_VENTA_VEHICULO 
			)
GO

SELECT * FROM VENTA_VEHICULO vv JOIN VEHICULO v ON vv.FK_VEHICULO=v.ID_VEHICULO 
			JOIN DISTRIBUIDOR_O_SUCURSAL ds ON vv.FK_DISTRIBUIDORA=ds.ID_SUCURSAL  ORDER BY ID_VEHICULO,MODELO

/*
PRUEBA   

SELECT * FROM DBO.FN_VENTAS_FECHAS_UBICACION('guanajuato','silao','11','2018')
*/








 
 





/***********  PASO 3. Obtener las VEHICULOS_VENDIDOS en las fechas especificas y ubacion espeficada de
	        acuerdo a el resultado del  PASO 2 y PASO 1			***************/
	        
	        
IF OBJECT_ID (N'dbo.FN_VENTAS_VEHICULOS_FECHAS_UBICACION', N'IF') IS NOT NULL  
	DROP FUNCTION dbo.FN_VENTAS_VEHICULOS_FECHAS_UBICACION;  
GO 	      
CREATE FUNCTION FN_VENTAS_VEHICULOS_FECHAS_UBICACION(@ESTADO VARCHAR(30),@CIUDAD VARCHAR(100),@MES SMALLINT, @ANIO SMALLINT,@MODELO VARCHAR(300),@TIPO VARCHAR(300), @COLOR VARCHAR(200))
	RETURNS TABLE
	AS 
	RETURN(SELECT *
			FROM VENTA_VEHICULO vv WHERE ID_VENTA_VEHICULO IN
				(SELECT ID_VENTA_VEHICULO FROM DBO.FN_VENTAS_FECHAS_UBICACION(@ESTADO,@CIUDAD,@MES,@ANIO))
					AND FK_VEHICULO IN 
				(SELECT ID_VEHICULO FROM FN_VEHICULOS(@MODELO, @TIPO,@COLOR ))
				
			--GROUP BY vv.ID_VENTA_VEHICULO 
			)
GO
 
 
 /*
 SELECT * FROM VENTA_VEHICULO vv JOIN VEHICULO v ON vv.FK_VEHICULO=v.ID_VEHICULO
		JOIN DISTRIBUIDOR_O_SUCURSAL ds ON vv.FK_DISTRIBUIDORA=ds.ID_SUCURSAL
		
 */
 
/*
SELECT ESTADO,SUM(PRECIO) FROM VENTA_VEHICULO vv JOIN VEHICULO v ON vv.FK_VEHICULO=v.ID_VEHICULO
		JOIN DISTRIBUIDOR_O_SUCURSAL ds ON vv.FK_DISTRIBUIDORA=ds.ID_SUCURSAL
		
*/
SELECT SUM(PRECIO) FROM VENTA_VEHICULO vv JOIN VEHICULO v ON vv.FK_VEHICULO=v.ID_VEHICULO
		JOIN DISTRIBUIDOR_O_SUCURSAL ds ON vv.FK_DISTRIBUIDORA=ds.ID_SUCURSAL
		
		
/*
SELECT ds.COLOR,SUM(PRECIO) FROM VENTA_VEHICULO vv JOIN VEHICULO v ON vv.FK_VEHICULO=v.ID_VEHICULO
		JOIN DISTRIBUIDOR_O_SUCURSAL ds ON vv.FK_DISTRIBUIDORA=ds.ID_SUCURSAL
		GROUP BY ds.COLOR*/


SELECT * FROM DBO.FN_VENTAS_VEHICULOS_FECHAS_UBICACION ('guanajuato','silao','11','2018','370z','eléctrico/estándar','NEGRO AMATISTA metalizado') 
SELECT * FROM DBO.FN_VENTAS_VEHICULOS_FECHAS_UBICACION ('guanajuato','leon','11','2018','370z','eléctrico/estándar','NEGRO AMATISTA metalizado') 

/*
SELECT  COUNT(ID_VENTA_VEHICULO) 
from  DBO.FN_VENTAS_VEHICULOS_FECHAS_UBICACION ('guanajuato','silao','11','2018','370z','eléctrico/estándar','NEGRO AMATISTA metalizado')   
GROUP BY ID_VENTA_VEHICULO 

SELECT  COUNT(ID_VENTA_VEHICULO) 
from  DBO.FN_VENTAS_VEHICULOS_FECHAS_UBICACION ('guanajuato','leon','11','2018','370z','eléctrico/estándar','NEGRO AMATISTA metalizado')  
GROUP BY ID_VENTA_VEHICULO 
        */


 


/*
ESTADO VARCHAR(30) NOT NULL ,
	CIUDAD VARCHAR (100) NOT NULL ,


*/

	/*******************PASO 6**************************/
	
	
CREATE TABLE VEHICULOS_DEMANDADOS(
	ID_VEHICULO  VARCHAR(15),
	MES SMALLINT,
	ANIO SMALLINT,
	MODELO VARCHAR(300),
	TIPO VARCHAR (300),
	COLOR VARCHAR(200),
	ESTADO VARCHAR(30) NOT NULL ,
	CIUDAD VARCHAR (100) NOT NULL ,
	CANT_MAXIMA_VENDIDA BIGINT
)
GO


	/****************************************************/
--PRUEBA--  SELECT   * FROM VEHICULOS_DEMANDADOS          DELETE FROM VEHICULOS_DEMANDADOS
SELECT DISTINCT  * FROM VEHICULOS_DEMANDADOS  
	ORDER BY 1
GO

	/****************************************************/
CREATE  PROC TRANS_LLENADO_VEHICULOS_DEMANDADOS
	@MES SMALLINT, @ANIO SMALLINT,@MODELO VARCHAR(300),@TIPO VARCHAR(300), @COLOR VARCHAR(200),@ESTADO VARCHAR(30),@CIUDAD VARCHAR(100)
	AS
	  BEGIN TRAN TRANS_VEHICULOS_DEMANDADOS
	  DECLARE
        @ID_VEHICULO VARCHAR(15),@cantidad int
        
        SET @cantidad=(SELECT  COUNT(ID_VENTA_VEHICULO) 
						from  DBO.FN_VENTAS_VEHICULOS_FECHAS_UBICACION (@ESTADO,@CIUDAD,@MES,@ANIO,@MODELO,@TIPO,@COLOR)   
						GROUP BY ID_VENTA_VEHICULO )
        
         IF @cantidad >= 1  --solo si existe alguna coincidencia
			BEGIN
				SELECT @ID_VEHICULO  = FK_VEHICULO 
				FROM DBO.FN_VENTAS_VEHICULOS_FECHAS_UBICACION (@ESTADO,@CIUDAD ,@MES , @ANIO,@MODELO,@TIPO , @COLOR)
		
				INSERT INTO VEHICULOS_DEMANDADOS VALUES(@ID_VEHICULO,@MES,@ANIO,@MODELO,@TIPO,@COLOR,@ESTADO,@CIUDAD,1)
			END
	  	
		
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




SELECT * FROM VEHICULO 
SELECT * FROM VEHICULOS_DEMANDADOS

EXEC  TRANS_LLENADO_VEHICULOS_DEMANDADOS  11,2018,'370z','eléctrico/estándar','NEGRO AMATISTA metalizado' ,'guanajuato','silao'
GO
/*

*/

CREATE VIEW VIEW_todos_los_estados 
AS 
SELECT ESTADO FROM DISTRIBUIDOR_O_SUCURSAL GROUP BY ESTADO
GO

SELECT COUNT(*) FROM VIEW_todos_los_estados
GO



CREATE VIEW VIEW_todos_las_ciudades 
AS 
SELECT CIUDAD FROM DISTRIBUIDOR_O_SUCURSAL GROUP BY CIUDAD
GO

SELECT COUNT(*) FROM VIEW_todos_las_ciudades



/**********************************************************************
 TRANSACCION OLPT PARA LLENAR LA TABLA COMPLETA DE 'VEHICULOS-DEMANDADOS'  EN 
TODOS LOS MESES DE ANIO PARA TODOS LOS VEHICULOS DE 'COLOR'  Y 'TIPO' y 'MODELO'  en cualquier estado y ciudad
REALIZAR 
'ETL' EN UN CUBO OLAP
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/

--delete from VEHICULOS_DEMANDADOS
SELECT * FROM VEHICULOS_DEMANDADOS
--GROUP BY ID_VEHICULO,MES,AÑO,MODELO,COLOR
order by 2,3,4
GO


SELECT * FROM VEHICULO
GO


/**********************************************************************

				CURSORES
*******************************************************************/
CREATE VIEW coloresC
AS
SELECT ROW_NUMBER() OVER (ORDER BY COLOR) AS INDICE, COLOR 
 FROM COLORES 
GO
 
SELECT * FROM coloresC
GO
--------------------------------------------------------

CREATE VIEW tiposC
AS
SELECT ROW_NUMBER() OVER (ORDER BY TIPO) AS INDICE, TIPO 
 FROM TIPOS 
GO
 
SELECT * FROM tiposC
GO
---------------------------------------------------------------

CREATE VIEW modelosC
AS
SELECT ROW_NUMBER() OVER (ORDER BY modelo) AS INDICE, modelo 
 FROM MODELOS 
GO
 
SELECT * FROM modelosC
GO
-----------------------------------------------------------------
CREATE VIEW estadosC
AS
SELECT ROW_NUMBER() OVER (ORDER BY estado) AS INDICE, ESTADO 
 FROM VIEW_todos_los_estados 
GO
 
SELECT * FROM estadosC
GO

-------------------------------------------------------------------
CREATE VIEW ciudadesC
AS
SELECT ROW_NUMBER() OVER (ORDER BY ciudad) AS INDICE, ciudad 
 FROM VIEW_todos_las_ciudades
GO
 
SELECT * FROM ciudadesC
GO


------------------------------------------------


/********************************************************************/

create proc sp_trans_autos_demandados_etl
	@MES_INICIO SMALLINT ,@MES_FIN  SMALLINT, @ANIO SMALLINT 
as
BEGIN
	
	BEGIN TRAN tran_demandas
		DECLARE 
		@MODELO VARCHAR(300),
		@TIPO VARCHAR(300), 
		@COLOR VARCHAR(200),
		@ESTADO VARCHAR(30),
		@CIUDAD VARCHAR(100),
		
		

		@CANTIDAD_COLORES INT= (SELECT COUNT(*) FROM COLORES),
		@CANTIDAD_MODELOS INT= (SELECT COUNT(*) FROM MODELOS),
		@CANTIDAD_TIPOS INT= (SELECT COUNT(*) FROM TIPOS),
		@CANTIDAD_ESTADOS INT= (SELECT COUNT(*) FROM estadosC),
		@CANTIDAD_CIUDADES INT= (SELECT COUNT(*) FROM ciudadesC),
		
		@CONT_COLORES INT = 1,
		@CONT_MODELOS INT = 1,
		@CONT_TIPOS INT = 1,
		@CONT_ESTADOS INT = 1,
		@CONT_CIUDADES INT = 1,
		
		
		@CONT_MES INT=@MES_INICIO

	  
	  --print 'Antes del while de estados'
	  WHILE( @CONT_ESTADOS <= @CANTIDAD_ESTADOS)
    BEGIN
		--print 'en el while de estados'
	set @CONT_CIUDADES=1
	
		WHILE( @CONT_CIUDADES <= @CANTIDAD_CIUDADES)
		BEGIN
		--print 'en el while de ciudades'
		
		SET @CONT_TIPOS=1
		
			WHILE( @CONT_TIPOS <= @CANTIDAD_TIPOS)
			BEGIN
			--print 'en el while de tipos'
			
			SET @CONT_MODELOS=1
			
				WHILE( @CONT_MODELOS <= @CANTIDAD_MODELOS)
				BEGIN
				--print 'en el while de modelos'
				
				SET @CONT_COLORES=1
					WHILE( @CONT_COLORES <= @CANTIDAD_COLORES)
					BEGIN
					--print 'en el while de colores'
					
					SET @CONT_MES=@MES_INICIO
					
						WHILE( @CONT_MES <= @MES_FIN)
						BEGIN 
						--print 'en el while de mes'
						
							SELECT  @MODELO = MODELO 
							FROM modelosC
							WHERE INDICE = @CONT_MODELOS
							
							SELECT  @TIPO = TIPO 
							FROM tiposC
							WHERE INDICE = @CONT_TIPOS
							
							SELECT  @COLOR = color 
							FROM coloresC
							WHERE INDICE = @CONT_COLORES
							
							SELECT  @ESTADO = estado 
							FROM estadosC
							WHERE INDICE = @CONT_ESTADOS
							
							SELECT  @CIUDAD = ciudad 
							FROM ciudadesC
							WHERE INDICE = @CONT_CIUDADES
							
							EXEC  TRANS_LLENADO_VEHICULOS_DEMANDADOS  @CONT_MES,@ANIO,@MODELO,@TIPO,@COLOR ,@ESTADO,@CIUDAD
						
						
						set @CONT_MES = @CONT_MES + 1
						END --fin while mes
					
					set @CONT_COLORES = @CONT_COLORES + 1
					END --FIN WHILE colores
				
				set @CONT_MODELOS = @CONT_MODELOS + 1
				END  --FIN WHILE modelos
			
			set @CONT_TIPOS = @CONT_TIPOS + 1
			END  --FIN WHILE tipos
			
		set @CONT_CIUDADES = @CONT_CIUDADES + 1
		END  --FIN WHILE ciudades
		
	set @CONT_ESTADOS = @CONT_ESTADOS + 1
    END   --FIN WHILE estados
  
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
EXEC sp_trans_autos_demandados_etl 1,12,2018
GO

--DELETE FROM VEHICULOS_DEMANDADOS
SELECT * FROM VEHICULOS_DEMANDADOS
SELECT * FROM VEHICULO
GO


--EXEC sp_trans_autos_demandados_etl 1,12,2017
--GO


SELECT * FROM VEHICULOS_DEMANDADOS
ORDER BY MODELO

/*
CREATE VIEW vista_modelos_mes AS
SELECT ANIO,MES,MODELO, SUM(CANT_MAXIMA_VENDIDA) suma_total_vendida FROM VEHICULOS_DEMANDADOS
GROUP BY MODELO, MES,ANIO
GO*/


SELECT * FROM vista_modelos_mes

USE Nissan
GO

SELECT * FROM VEHICULOS_DEMANDADOS 
GO

SELECT DISTINCT * FROM VEHICULOS_DEMANDADOS 
ORDER BY 1,2,4,5
GO

SELECT MODELO,SUM(CANT_MAXIMA_VENDIDA) FROM VEHICULOS_DEMANDADOS 
GROUP BY MODELO
GO

SELECT MES,COLOR, SUM(CANT_MAXIMA_VENDIDA) FROM VEHICULOS_DEMANDADOS 
GROUP BY MES,COLOR

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

