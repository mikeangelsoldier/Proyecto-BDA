
/*+++++++++++++CREA INDICE DE LAS SURSALES CORRESPONDIENTES++++++++++++++++++  */
use Nissan
GO


CREATE VIEW AlmacenPP
AS
SELECT ROW_NUMBER() OVER (ORDER BY ID_AlMACEN_EMPRESA) AS INDICE, ID_AlMACEN_EMPRESA 
 FROM ALMACEN_EMPRESA 
GO
 
SELECT * FROM AlmacenPP
GO

CREATE VIEW SucursalPP5
AS
SELECT ROW_NUMBER() OVER (ORDER BY ID_SUCURSAL) AS INDICE, ID_SUCURSAL 
 FROM Distribuidor_o_sucursal 
GO
 
SELECT * FROM SucursalPP5
GO



CREATE VIEW VehiculoPP5
AS
SELECT ROW_NUMBER() OVER (ORDER BY ID_VEHICULO) AS INDICE, ID_VEHICULO 
 FROM VEHICULO 
GO

SELECT * FROM VehiculoPP5
GO


/**********************************************************************************************
RUTINA PARA LLENAR ALEATORIAMENTE EN BASE A LOS DATOS BASE LAS VENTAS_VEHICULO que realizan los 
DISTRIBUIDORES_O_SUCURSAL a CLIENTES y  que VEHICULOS VENDE 
**************************************************************************************************/

CREATE PROC SP_TRASLADO_AUTOS
	@CUENTA BIGINT,  @N BIGINT
	AS
		begin tran llena_factura_almacen
			DECLARE 
			@NO_PEDIDO VARCHAR(30),  @ID_SUCURSAL VARCHAR(15), @FECHA DATE,  
			@ID_ALMACEN_EMPRESA VARCHAR(15),@ID_VEHICULO VARCHAR(15),
			@CONT BIGINT = 1 , @CONT2 BIGINT ,
      		@CTA BIGINT , @CTA1  BIGINT, @cantidad_sucursales BIGINT, @cantidad_almacenes BIGINT, @cantidad_vehiculos BIGINT
    
			WHILE (@CONT <=  @N)
			BEGIN    
				SET @NO_PEDIDO ='PED'+CONVERT(VARCHAR,@CUENTA)

				--****Seleccionar Sucursal aleatoria
				SET @cantidad_sucursales= (SELECT COUNT(ID_SUCURSAL) FROM DISTRIBUIDOR_O_SUCURSAL)--total de sucursales
				SET @CTA = FLOOR( (RAND() * @cantidad_sucursales) + 1) --el valor aleatorio para elegir el indice (la variable es el limite de datos)
	    
				--print @cta
				SELECT  @ID_SUCURSAL = ID_SUCURSAL   
					FROM SucursalPP5
					WHERE INDICE = @CTA
				
				--Generar la fecha aleatoria		
				SET @CTA = FLOOR( (RAND() * 2000) + 1)--N dias atras de fechas aleatorias
				SET @FECHA = GETDATE() - @CTA
	    
				--****Seleccionar ALMACEN aleatorio
				SET @cantidad_almacenes= (SELECT COUNT(ID_ALMACEN_EMPRESA) FROM ALMACEN_EMPRESA)--total de almacenes
				SET @CTA = FLOOR( (RAND() * @cantidad_almacenes) + 1) --el valor aleatorio para elegir el indice (la variable es el limite de datos)
				--print FLOOR( (RAND() * 4) + 1)

				--print @cta
				SELECT  @ID_ALMACEN_EMPRESA = ID_AlMACEN_EMPRESA   
						FROM AlmacenPP
						WHERE INDICE = @CTA
			
				INSERT INTO FACTURA_ALMACEN (NO_PEDIDO,FK_ALMACEN,FK_DISTRIBUIDORA,FECHA)
					VALUES(@NO_PEDIDO,@ID_ALMACEN_EMPRESA,@ID_SUCURSAL,@FECHA )
				
				print getDAte()

				--Poner los detalles de venta aleatorios para una misma venta
				SET @CTA1 = FLOOR( (RAND() * 10) + 1)
				--print FLOOR( (RAND() * 10) + 1)
				SET @CONT2 = 1
				WHILE(@CONT2 <= @CTA1)
					BEGIN
						--Seleccionar VEHICULO aleatorio
						SET @cantidad_vehiculos= (SELECT COUNT(ID_VEHICULO) FROM VEHICULO)--total de sucursales
						SET @CTA = FLOOR( (RAND() * @cantidad_vehiculos) + 1) --el valor aleatorio para elegir el indice (la variable es el limite de datos)
						--print @cta

						SELECT  @ID_VEHICULO = ID_VEHICULO   
							FROM VehiculoPP5
							WHERE INDICE = @CTA
            
            
							if NOT EXISTS (SELECT FK_PEDIDO,FK_VEHICULO FROM DET_FACTURA_ALMACEN
								WHERE FK_VEHICULO = @ID_VEHICULO AND FK_PEDIDO = @NO_PEDIDO)
							BEGIN  
								INSERT INTO DET_FACTURA_ALMACEN (FK_PEDIDO,FK_VEHICULO) VALUES(@NO_PEDIDO,@ID_VEHICULO)
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

SELECT *  from FACTURA_ALMACEN
SELECT * from DET_FACTURA_ALMACEN

--delete from DET_FACTURA_ALMACEN
--delete from FACTURA_ALMACEN


--

--ejecucion
EXEC SP_TRASLADO_AUTOS  1,  600
--EXEC SP_TRASLADO_AUTOS  100,  40100
--EXEC SP_TRASLADO_AUTOS  2,  13780

