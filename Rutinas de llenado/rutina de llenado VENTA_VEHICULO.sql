
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

CREATE PROC  SP_LLENA_VENTA_VEHICULO_AUTOMATICAMENTE
  @CUENTA BIGINT, @FORMA_PAGO VARCHAR(10)
  AS
     begin tran llena_venta_vehiculo
	 DECLARE @ID_VENTA VARCHAR(30), @ID_SUCURSAL VARCHAR(15), 	@FECHA DATE,  
	 @ID_CLIENTE VARCHAR(15), @ID_VEHICULO VARCHAR(15),  
	 @CONT BIGINT = 1,  @N BIGINT,
      	@CTA BIGINT , @cantidad_sucursales BIGINT, @cantidad_clientes BIGINT, @cantidad_vehiculos BIGINT,
      	@contador_vehiculo BIGINT=1;
      	
      SET @cantidad_vehiculos= (SELECT COUNT(ID_VEHICULO) FROM VEHICULO)--total de sucursales
      SET @N= @cantidad_vehiculos/2
      
		
	 WHILE (@CONT <=  @N)
        BEGIN    
        
        SET @ID_VENTA =  'VTA' + CONVERT(VARCHAR,@CUENTA)
        
        --Seleccionar Sucursal aleatoria
        SET @cantidad_sucursales= (SELECT COUNT(ID_SUCURSAL) FROM DISTRIBUIDOR_O_SUCURSAL)--total de sucursales
	    SET @CTA = FLOOR( (RAND() * @cantidad_sucursales) + 1) --el valor aleatorio para elegir el indice (la variable es el limite de datos)
	    
		print @cta
	    SELECT  @ID_SUCURSAL = ID_SUCURSAL   
			FROM SucursalPP2
			WHERE INDICE = @CTA
				
		--Generar la fecha aleatoria		
	    SET @CTA = FLOOR( (RAND() * 1030) + 1)
	    SET @FECHA = GETDATE() - @CTA
	    
	    --Seleccionar CLIENTE aleatorio
        SET @cantidad_clientes= (SELECT COUNT(ID_CLIENTE) FROM CLIENTE)--total de clientes
	    SET @CTA = FLOOR( (RAND() * @cantidad_clientes) + 1) --el valor aleatorio para elegir el indice (la variable es el limite de datos)
	    
	    --print @cta
	    SELECT  @ID_CLIENTE = ID_CLIENTE   
			FROM clientePP2
			WHERE INDICE = @CTA
	    
	    --seleccionar un VEHICULO aleatorio
	    
	    SET @CTA = @contador_vehiculo
		--print @cta
		SELECT  @ID_VEHICULO = ID_VEHICULO   
			FROM VehiculoPP
			WHERE INDICE = @CTA
            			
	  INSERT INTO VENTA_VEHICULO (ID_VENTA_VEHICULO,FK_DISTRIBUIDORA,FK_CLIENTE,FK_VEHICULO,FECHA,FORMA_PAGO)
			VALUES(@ID_VENTA,@ID_SUCURSAL,@ID_CLIENTE,@ID_VEHICULO, @FECHA,@FORMA_PAGO )
	  
	  update VEHICULO set ESTADO = 'VENDIDO' WHERE ID_VEHICULO=@ID_VEHICULO  
	   

        SET @CUENTA = @CUENTA + 1
        SET @CONT = @CONT + 1   
        SET @contador_vehiculo=@contador_vehiculo + 2
        
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






--DELETE FROM DET_VENTA_VEHICULO
--DELETE FROM VENTA_VEHICULO



--ejecucion
EXEC SP_LLENA_VENTA_VEHICULO_AUTOMATICAMENTE  1, 'EFECTIVO'
GO
--EXEC SP_LLENA_VENTA_VEHICULO_AUTOMATICAMENTE  200,'EFECTIVO'
--EXEC SP_LLENA_VENTA_VEHICULO_AUTOMATICAMENTE 300, 'TARJETA'


SELECT * from VENTA_VEHICULO WHERE FORMA_PAGO='EFECTIVO'
SELECT * from VENTA_VEHICULO WHERE FORMA_PAGO='TARJETA'

SELECT * from VENTA_VEHICULO 
SELECT * from VEHICULO


