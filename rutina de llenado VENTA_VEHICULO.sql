
/*+++++++++++++CREA INDICE DE LAS SURSALES CORRESPONDIENTES++++++++++++++++++  */
use Nissan
GO


CREATE VIEW SucursalPP2
AS
SELECT ROW_NUMBER() OVER (ORDER BY ID_SUCURSAL) AS INDICE, ID_SUCURSAL 
 FROM Distribuidor_o_sucursal 
GO
 
SELECT * FROM SucursalPP2
GO

CREATE VIEW VehiculoPP
AS
SELECT ROW_NUMBER() OVER (ORDER BY ID_VEHICULO) AS INDICE, ID_VEHICULO 
 FROM VEHICULO 
GO

SELECT * FROM VehiculoPP
GO


CREATE VIEW clientePP2
AS
SELECT ROW_NUMBER() OVER (ORDER BY ID_CLIENTE) AS INDICE, ID_CLIENTE 
 FROM CLIENTE 
GO

SELECT * FROM clientePP2
GO

/**********************************************************************************************
RUTINA PARA LLENAR ALEATORIAMENTE EN BASE A LOS DATOS BASE LAS VENTAS_VEHICULO que realizan los 
DISTRIBUIDORES_O_SUCURSAL a CLIENTES y  que VEHICULOS VENDE 
**************************************************************************************************/

CREATE PROC  SP_LLENA_VENTA_VEHICULO
  @CUENTA BIGINT,  @N INT,@FORMA_PAGO VARCHAR(10)
  AS
     begin tran llena_venta_vehiculo
	 DECLARE @ID_VENTA VARCHAR(30),  @ID_SUCURSAL VARCHAR(15), 	@FECHA DATE,  
	 @ID_CLIENTE VARCHAR(15),@CONT INT = 1 , @CONT2 INT ,@ID_VEHICULO VARCHAR(15), @cantidad int,
      	@CTA bigint , @CTA1  bigint, @cantidad_sucursales int, @cantidad_clientes int, @cantidad_vehiculos int
      	
      
		
	 WHILE (@CONT <=  @N)
        BEGIN    
        --Seleccionar Sucursal aleatoria
        SET @ID_VENTA =  'VTA' + CONVERT(VARCHAR,@CUENTA)
        SET @cantidad_sucursales= (SELECT COUNT(ID_SUCURSAL) FROM DISTRIBUIDOR_O_SUCURSAL)--total de sucursales
	    SET @CTA = FLOOR( (RAND() * @cantidad_sucursales) + 1) --el valor aleatorio para elegir el indice (la variable es el limite de datos)
	    
		print @cta
	    SELECT  @ID_SUCURSAL = ID_SUCURSAL   
				FROM SucursalPP2
				WHERE INDICE = @CTA
				
		--Generar la fecha aleatoria		
	    SET @CTA = FLOOR( (RAND() * 720) + 1)
	    SET @FECHA = GETDATE() - @CTA
	    
	    --Seleccionar CLIENTE aleatoria
        SET @cantidad_clientes= (SELECT COUNT(ID_CLIENTE) FROM CLIENTE)--total de sucursales
	    SET @CTA = FLOOR( (RAND() * @cantidad_clientes) + 1) --el valor aleatorio para elegir el indice (la variable es el limite de datos)
	    
		print @cta
	    SELECT  @ID_CLIENTE = ID_CLIENTE   
				FROM clientePP2
				WHERE INDICE = @CTA
				
		
	    
	  INSERT INTO VENTA_VEHICULO (ID_VENTA_VEHICULO,FK_DISTRIBUIDORA,FK_CLIENTE,FECHA,FORMA_PAGO)VALUES(@ID_VENTA,@ID_SUCURSAL,@ID_CLIENTE,@FECHA,@FORMA_PAGO )
	    
	  --Poner los detalles de venta aleatorios para una misma venta
	    SET @CTA1 = FLOOR( (RAND() * 20) + 1)
		SET @CONT2 = 1
        WHILE(@CONT2 <= @CTA1)
	    BEGIN
	      --Seleccionar VEHICULO aleatorio
			SET @cantidad_vehiculos= (SELECT COUNT(ID_VEHICULO) FROM VEHICULO)--total de sucursales
			SET @CTA = FLOOR( (RAND() * @cantidad_vehiculos) + 1) --el valor aleatorio para elegir el indice (la variable es el limite de datos)
	    
			print @cta
			SELECT  @ID_VEHICULO = ID_VEHICULO   
				FROM VehiculoPP
				WHERE INDICE = @CTA
            
            
	      SET @CTA = FLOOR( (RAND() * 10) + 4)
	      SET @cantidad= @CTA
	      
         
		  if NOT EXISTS (SELECT FK_VENTA_VEHICULO,FK_VEHICULO FROM DET_VENTA_VEHICULO
		          WHERE FK_VEHICULO = @ID_VEHICULO AND FK_VENTA_VEHICULO = @ID_VENTA)
		  BEGIN  
		     INSERT INTO DET_VENTA_VEHICULO VALUES(@ID_VENTA,@ID_VEHICULO,@cantidad)
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
EXEC SP_LLENA_VENTA_VEHICULO  30,  750,'EFECTIVO'
--EXEC SP_LLENA_VENTA_VEHICULO  10,  70000,'EFECTIVO'
--EXEC SP_LLENA_VENTA_VEHICULO  2,  20300, 'TARJETA'


SELECT * from VENTA_VEHICULO
SELECT * from DET_VENTA_VEHICULO
