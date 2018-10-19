/*+++++++++++++CREA INDICE DE LAS SURSALES CORRESPONDIENTES++++++++++++++++++  */
use Nissan
GO


CREATE VIEW SucursalPP3
AS
SELECT ROW_NUMBER() OVER (ORDER BY ID_SUCURSAL) AS INDICE, ID_SUCURSAL 
 FROM Distribuidor_o_sucursal 
GO
 
SELECT * FROM SucursalPP3
GO

CREATE VIEW ServicioPP
AS
SELECT ROW_NUMBER() OVER (ORDER BY ID_SERVICIO) AS INDICE, ID_SERVICIO 
 FROM SERVICIO 
GO

SELECT * FROM ServicioPP
GO

CREATE VIEW clientePP3
AS
SELECT ROW_NUMBER() OVER (ORDER BY ID_CLIENTE) AS INDICE, ID_CLIENTE 
 FROM CLIENTE 
GO

SELECT * FROM clientePP3
GO

/**********************************************************************************************
RUTINA PARA LLENAR ALEATORIAMENTE EN BASE A LOS DATOS BASE LAS VENTAS_servicio que realizan los 
DISTRIBUIDORES_O_SUCURSAL a CLIENTES y  que servicioS VENDE 
**************************************************************************************************/

CREATE alter PROC  SP_LLENA_FACT_SERVICIO
  @CUENTA BIGINT,  @N INT , @FORMA_PAGO VARCHAR(10)
  AS
     begin tran llena_fact_servicio
	 DECLARE @ID_FACTURA VARCHAR(30),  @ID_SUCURSAL VARCHAR(15), 	@FECHA DATE,  
	 @ID_CLIENTE VARCHAR(15),@CONT INT = 1 , @CONT2 INT ,@ID_SERVICIO VARCHAR(15), @puntuacion int,
      	@CTA bigint , @CTA1  bigint, @cantidad_sucursales int, @cantidad_clientes bigint, @cantidad_servicios int
      	
      
		
	 WHILE (@CONT <=  @N)
        BEGIN    
        --Seleccionar Sucursal aleatoria
        SET @ID_FACTURA =  'FCT' + CONVERT(VARCHAR,@CUENTA)
        SET @cantidad_sucursales= (SELECT COUNT(ID_SUCURSAL) FROM DISTRIBUIDOR_O_SUCURSAL)--total de clientes
	    SET @CTA = FLOOR( (RAND() * @cantidad_sucursales) + 1) --el valor aleatorio para elegir el indice (la variable es el limite de datos)
	    
		print @cta
	    SELECT  @ID_SUCURSAL = ID_SUCURSAL   
				FROM SucursalPP3
				WHERE INDICE = @CTA
				
		--Generar la fecha aleatoria		
	    SET @CTA = FLOOR( (RAND() * 720) + 1)
	    SET @FECHA = GETDATE() - @CTA
	    --print GETDATE()


	    --Seleccionar CLIENTE aleatoria
        SET @cantidad_clientes= (SELECT COUNT(ID_CLIENTE) FROM CLIENTE)--total de sucursales
	    SET @CTA = FLOOR( (RAND() * @cantidad_clientes) + 1) --el valor aleatorio para elegir el indice (la variable es el limite de datos)
	    
		--print @cta
	    SELECT  @ID_CLIENTE = ID_CLIENTE   
				FROM clientePP3
				WHERE INDICE = @CTA
				
		
	    
	  INSERT INTO FACT_SERVICIO (ID_FACT_SERVICIO,FK_DISTRIBUIDORA,FK_CLIENTE,FECHA,FORMA_PAGO)VALUES(@ID_FACTURA,@ID_SUCURSAL,@ID_CLIENTE,@FECHA,@FORMA_PAGO )
	    --SELECT * FROM FACT_SERVICIO

	  --Poner los detalles de venta aleatorios para una misma venta
	    SET @CTA1 = FLOOR( (RAND() * 20) + 1)
		SET @CONT2 = 1
        WHILE(@CONT2 <= @CTA1)
	    BEGIN
	      --Seleccionar servicio aleatorio
			SET @cantidad_servicios= (SELECT COUNT(ID_SERVICIO) FROM servicio)--total de sucursales
			SET @CTA = FLOOR( (RAND() * @cantidad_servicios) + 1) --el valor aleatorio para elegir el indice (la variable es el limite de datos)
	    
			print @cta
			SELECT  @ID_servicio = ID_servicio   
				FROM servicioPP
				WHERE INDICE = @CTA
            
            
	      SET @CTA = FLOOR( (RAND() * 10) + 4)

		  --Valor aleatorio para el nivel de satisfaccion o puntuacion para un servicio prestado
	      SET @puntuacion= FLOOR( (RAND() * 10) + 1) 
         
		  if NOT EXISTS (SELECT FK_FACT_SERVICIO,FK_servicio FROM DET_FACT_SERVICIO
		          WHERE FK_servicio = @ID_servicio AND FK_FACT_SERVICIO = @ID_FACTURA)
		  BEGIN  
		     INSERT INTO DET_FACT_SERVICIO VALUES(@ID_FACTURA,@ID_servicio,@puntuacion)
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
     ROLLBACK TRAN tran_llena 
   END
  ELSE  
    COMMIT TRAN tran_llena  
GO














--ejecucion
EXEC SP_LLENA_FACT_SERVICIO  400,  586, 'EFECTIVO'
--EXEC SP_LLENA_FACT_SERVICIO  100,  40100, 'EFECTIVO'
--EXEC SP_LLENA_FACT_SERVICIO  2,  13780, 'TARJETA'


SELECT * from FACT_SERVICIO WHERE FORMA_PAGO='EFECTIVO'
SELECT * from FACT_SERVICIO WHERE FORMA_PAGO='TARJETA'

SELECT * from DET_FACT_SERVICIO
