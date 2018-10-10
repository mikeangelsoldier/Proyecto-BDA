
/*+++++++++++++CREA INDICE PARA RECORRER LOS DATOS DE LAS TABLAS, DE LAS SURSALES CORRESPONDIENTES++++++++++++++++++  */
use Nissan
GO

CREATE VIEW SucursalPP
AS
SELECT ROW_NUMBER() OVER (ORDER BY ID_SUCURSAL) AS INDICE, ID_SUCURSAL 
 FROM Distribuidor_o_sucursal 
GO
 
SELECT * FROM SucursalPP
GO

CREATE VIEW AccesorioPP
AS
SELECT ROW_NUMBER() OVER (ORDER BY ID_ACCESORIO) AS INDICE, ID_ACCESORIO 
 FROM ACCESORIO 
GO

SELECT * FROM AccesorioPP
GO

CREATE VIEW clientePP
AS
SELECT ROW_NUMBER() OVER (ORDER BY ID_CLIENTE) AS INDICE, ID_CLIENTE 
 FROM CLIENTE 
GO

SELECT * FROM clientePP
GO

/**********************************************************************************************
RUTINA PARA LLENAR ALEATORIAMENTE EN BASE A LOS DATOS BASE LAS VENTAS_ACCESORIO que realizan los 
DISTRIBUIDORES_O_SUCURSAL a CLIENTES y  que ACCESORIOS VENDE 
**************************************************************************************************/

CREATE PROC  SP_LLENA_VENTA_ACCESORIO 
  @CUENTA BIGINT,  @N INT
  AS
     begin tran llena_venta_accesorio
	 DECLARE @ID_VENTA VARCHAR(30),  @ID_SUCURSAL VARCHAR(15), 	@FECHA DATE,  
	 @ID_CLIENTE VARCHAR(15),@CONT INT = 1 , @CONT2 INT ,@ID_ACCESORIO VARCHAR(15), @cantidad int,
      	@CTA bigint , @CTA1  bigint, @cantidad_sucursales int, @cantidad_clientes int, @cantidad_accesorios int
      	
      
		
	 WHILE (@CONT <=  @N)
        BEGIN    
        --Seleccionar Sucursal aleatoria
        SET @ID_VENTA =  'VTA' + CONVERT(VARCHAR,@CUENTA)
        SET @cantidad_sucursales= (SELECT COUNT(ID_SUCURSAL) FROM DISTRIBUIDOR_O_SUCURSAL)--total de sucursales
	    SET @CTA = FLOOR( (RAND() * @cantidad_sucursales) + 1) --el valor aleatorio para elegir el indice (la variable es el limite de datos)
	    
		print @cta
	    SELECT  @ID_SUCURSAL = ID_SUCURSAL   
				FROM SucursalPP
				WHERE INDICE = @CTA
				
		--Generar la fecha aleatoria		
	    SET @CTA = FLOOR( (RAND() * 720) + 1)
	    SET @FECHA = GETDATE() - @CTA
	    
	    --Seleccionar CLIENTE aleatoria
        SET @cantidad_clientes= (SELECT COUNT(ID_CLIENTE) FROM CLIENTE)--total de sucursales
	    SET @CTA = FLOOR( (RAND() * @cantidad_clientes) + 1) --el valor aleatorio para elegir el indice (la variable es el limite de datos)
	    
		print @cta
	    SELECT  @ID_CLIENTE = ID_CLIENTE   
				FROM clientePP
				WHERE INDICE = @CTA
				
		
	    
	  INSERT INTO VENTA_ACCESORIO (ID_VENTA_ACCESORIO,FK_DISTRIBUIDORA,FK_CLIENTE,FECHA)VALUES(@ID_VENTA,@ID_SUCURSAL,@ID_CLIENTE,@FECHA )
	    
	  --Poner los detalles de venta aleatorios para una misma venta
	    SET @CTA1 = FLOOR( (RAND() * 20) + 1)
		SET @CONT2 = 1
        WHILE(@CONT2 <= @CTA1)
	    BEGIN
	      --Seleccionar ACCESORIO aleatorio
			SET @cantidad_accesorios= (SELECT COUNT(ID_ACCESORIO) FROM ACCESORIO)--total de sucursales
			SET @CTA = FLOOR( (RAND() * @cantidad_accesorios) + 1) --el valor aleatorio para elegir el indice (la variable es el limite de datos)
	    
			print @cta
			SELECT  @ID_ACCESORIO = ID_ACCESORIO   
				FROM AccesorioPP
				WHERE INDICE = @CTA
            
            
	      SET @CTA = FLOOR( (RAND() * 10) + 4)
	      SET @cantidad= @CTA
	      
         
		  if NOT EXISTS (SELECT FK_VENTA_ACCESORIO,FK_ACCESORIO FROM DET_VENTA_ACCESORIO
		          WHERE FK_ACCESORIO = @ID_ACCESORIO AND FK_VENTA_ACCESORIO = @ID_VENTA)
		  BEGIN  
		     INSERT INTO DET_VENTA_ACCESORIO VALUES(@ID_VENTA,@ID_ACCESORIO,@cantidad)
			 SET @CONT2 = @CONT2 + 1
			 ---POR EL TRIGGER
			 --update articulo set EXISTENCIA_ACTUAL = EXISTENCIA_ACTUAL + @cant_rec,
			   --   precio_actual = @costo_fab*1.30 where NO_ART = @no_art        
          END
	    END   --FIN WHILE INTERNO
        SET @CUENTA = @CUENTA + 2
        SET @CONT = @CONT + 1   
     END  -- FIN WHILE PRINC
  IF @@ERROR <> 0
   BEGIN
      RAISERROR(N'MENSAJE', 16, 1);
     PRINT N'Error = ' + CAST(@@ERROR AS NVARCHAR(8));
     ROLLBACK TRAN tran_llena_recibe 
   END
  ELSE  
    COMMIT TRAN tran_llena_Recibe   
GO














--ejecucion
--EXEC SP_LLENA_VENTA_ACCESORIO  50010,  60000
EXEC SP_LLENA_VENTA_ACCESORIO  20000,  200
--cuando corra el procedimiento cambiar rango o borrar datos de ventas y sus detalles
--DELETE FROM DET_VENTA_ACCESORIO
--DELETE FROM VENTA_ACCESORIO


SELECT * FROM VENTA_ACCESORIO
GO

SELECT FK_VENTA_ACCESORIO,FK_ACCESORIO FROM DET_VENTA_ACCESORIO
ORDER BY FK_VENTA_ACCESORIO
GO

SELECT * FROM DET_VENTA_ACCESORIO
ORDER BY FK_VENTA_ACCESORIO
GO

SELECT * FROM VENTA_ACCESORIO as va INNER JOIN DET_VENTA_ACCESORIO as dta ON va.ID_VENTA_ACCESORIO=dta.FK_VENTA_ACCESORIO
GO


SELECT dta.fk_VENTA_ACCESORIO,a.ID_ACCESORIO,a.DECRIPCION FROM ACCESORIO 
	as a INNER JOIN DET_VENTA_ACCESORIO as dta ON a.ID_ACCESORIO=dta.FK_ACCESORIO
		



