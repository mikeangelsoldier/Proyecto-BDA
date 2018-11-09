USE Nissan
GO

CREATE TABLE MODELOS(
	MODELO VARCHAR(300) PRIMARY KEY
)

SELECT * FROM MODELOS
GO

--DELETE FROM MODELOS
INSERT INTO MODELOS VALUES 
('ZAFIRA'),
('LEAF'),
('MICRA'),
('JUKE'),
('PULSAR'),
('QASHQAI'),
('EVALIA'),
('X-TRAIL'),
('370Z'),
('370Z ROASTER'),
('GT-R'),
('NV200 FURGON'),
('E-NV200'),
('NV200 COMBI'),
('NV300'),
('JAGUAR'),
('NOTE'),
('HIRAKI'),
('ALTIMA'),
('APRIO'),
('DATSUN'),
('LUCINO'),
('MAXIMA'),
('PLATINA'),
('SENTRA'),
('TIIDA'),
('TSURU'),
('VERSA')
GO

CREATE TABLE TIPOS(
	TIPO VARCHAR(300) PRIMARY KEY
)

SELECT * FROM TIPOS
GO

--DELETE FROM TIPOS
INSERT INTO TIPOS VALUES 
('ELÉCTRICO'),
('ESTÁNDAR'),
('AUTOMÁTICO'),
('ELÉCTRICO/AUTOMÁTICO'),
('ELÉCTRICO/ESTÁNDAR')


CREATE TABLE COLORES(
	COLOR VARCHAR(200) PRIMARY KEY
)

SELECT * FROM COLORES
GO

--DELETE FROM COLORES
INSERT INTO COLORES VALUES 
('NEGRO Metalizado'),
('AZUL ULTRAMAR Metalizado'),
('NEGRO AMATISTA Metalizado'),
('AZUL VIVID Metalizado'),
('GRIS Metalizado'),
('BRONCE CHESTNUT Metalizado'),
('ROJO FUSIÓN Metalizado'),
('PLATA DIAMANTE Metalizado'),
('ROJO Sólido'),
('BLANCO PERLADO  Metalizado'),
('BLANCO Sólido'),
('GUNMETAL GREY  Metalizado'),
('PLATINUM SILVER  Metalizado'),
('YVORY Sólido'),
('GLAZE WHITE'),
('SOLID WHITE Sólido'),
('ROJO FUERTE'),
('AMARILLO'),
('AZUR'),
('NEGRO AZABACHE'),
('NEGRO DIAMANTE'),
('GRIS PRECISIÓN'),
('PLATA LUNAR'),
('BLANCO ICEBERG'),
('AZUL BALTICO'),
('ROJO SPORT  Metalizado'),
('PLATA TECNO')
GO


/*************************************************************************************************************
RUTINA DE LLENADO DE LOS VEHICULOS
*****************************************************************************************************************/


/*+++++++++++++CREA INDICE DE LAS SURSALES CORRESPONDIENTES++++++++++++++++++  */
use Nissan
GO


CREATE VIEW ModelosPP
AS
SELECT ROW_NUMBER() OVER (ORDER BY MODELO) AS INDICE, MODELO 
 FROM MODELOS 
GO
 
SELECT * FROM ModelosPP
GO

CREATE VIEW ColoresPP
AS
SELECT ROW_NUMBER() OVER (ORDER BY COLOR) AS INDICE, COLOR 
 FROM COLORES 
GO

SELECT * FROM ColoresPP
GO


CREATE VIEW tiposPP
AS
SELECT ROW_NUMBER() OVER (ORDER BY TIPO) AS INDICE, TIPO 
 FROM TIPOS 
GO

SELECT * FROM tiposPP
GO


/**********************************************************************************************
RUTINA PARA LLENAR ALEATORIAMENTE EN BASE A LOS DATOS BASE LOS VEHICULOS
**************************************************************************************************/
CREATE PROC  SP_LLENA_VEHICULO
  @CUENTA BIGINT,  @N BIGINT
  AS
  begin tran llena_vehiculo
	 DECLARE @ID_VEHICULO VARCHAR(15),  @MODELO VARCHAR(300), @TIPO VARCHAR(300), @AÑO INT, @COLOR VARCHAR(200), @PRECIO MONEY,
      	@CTA BIGINT , @cantidad_modelos BIGINT, @cantidad_tipos BIGINT, @cantidad_colores BIGINT,
      	@CONT BIGINT = 1

	 WHILE (@CONT <=  @N)
        BEGIN    
			SET @ID_VEHICULO =  'VH' + CONVERT(VARCHAR,@CUENTA)
        
			--*Seleccionar tipo aleatorio
			SET @cantidad_tipos= (SELECT COUNT(TIPO) FROM TIPOS)--total de tripo
			SET @CTA = FLOOR( (RAND() * @cantidad_tipos) + 1) 
			--print FLOOR( (RAND() * 5) + 1)
	  
			print @cta
			SELECT  @TIPO = TIPO   
				FROM tiposPP
				WHERE INDICE = @CTA
				
			--*Generar año aleatorio		
			SET @CTA = ROUND(((2018 - 1990 -1) * RAND() + 1990), 0)
			SET @AÑO = @CTA
			--print ROUND(((2018 - 1990 -1) * RAND() + 1990), 0)
			
			--*Generar precio aleatorio		
			SET @CTA = ROUND(((388190 - 40000 -1) * RAND() + 40000), 0)
			SET @PRECIO = @CTA
			--print ROUND(((388190 - 40000 -1) * RAND() + 40000), 0)
	    
			--Seleccionar modelo aleatorio
			SET @cantidad_modelos= (SELECT COUNT(modelo) FROM MODELOS)--total de modelos
			SET @CTA = FLOOR( (RAND() * @cantidad_modelos) + 1) --el valor aleatorio para elegir el indice (la variable es el limite de datos)
	    
			print @cta
			SELECT  @MODELO = MODELO   
				FROM ModelosPP
				WHERE INDICE = @CTA
				
			--Seleccionar color aleatorio
			SET @cantidad_colores= (SELECT COUNT(COLOR) FROM COLORES)--total de colores
			SET @CTA = FLOOR( (RAND() * @cantidad_colores) + 1) --el valor aleatorio para elegir el indice (la variable es el limite de datos)
	    
			print @cta
			SELECT  @COLOR = COLOR   
				FROM ColoresPP
				WHERE INDICE = @CTA
				
			INSERT INTO VEHICULO (ID_VEHICULO,DECRIPCION,TIPO,AÑO,MODELO,COLOR,PRECIO,ESTADO)
			VALUES(@ID_VEHICULO,'Vehiculo',@TIPO,@AÑO,@MODELO,@COLOR, @PRECIO,'NO VENDIDO')
	     
	     SET @CUENTA = @CUENTA + 1
        SET @CONT = @CONT + 1 
     END  -- FIN WHILE PRINC
	IF @@ERROR <> 0
	BEGIN
      RAISERROR(N'MENSAJE', 16, 1);
		PRINT N'Error = ' + CAST(@@ERROR AS NVARCHAR(8));
		ROLLBACK TRAN llena_vehiculo
	END
	ELSE  
		COMMIT TRAN llena_vehiculo 
GO




SELECT * FROM VEHICULO

--ejecucion
--EXEC SP_LLENA_VEHICULO  1, 1000000000
--EXEC SP_LLENA_VEHICULO  1, 100000
EXEC SP_LLENA_VEHICULO  1, 10000

