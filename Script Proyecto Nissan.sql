/****************************************************************************************************
* PROYECTO BASES DE DATOS AVANZADAS   ultima actualizacion: 09 DE SEPTIEBRE DE 2018   
								Inst. Tecnologico de Leon *
* Autores:  
			•	José Guadalupe de Jesús Cervera Barbosa
			•	Judá Alector Vallejo Herrera
			•	Luis Saul Ornelas Pérez
			•	Miguel Ángel Ramírez Lira

 
*****************************************************************************************************/
--Nota, todas los requerimientos deben ser una transaccion 




use master;    
 go 
--DROP DATABASE Nissan
--go
CREATE DATABASE Nissan; 
GO
use Nissan;
GO

CREATE TABLE ALMACEN_EMPRESA (
	ID_ALMACEN_EMPRESA VARCHAR (10)  NOT null,
	DESCRIPCION VARCHAR (300) NULL,
	ESTADO VARCHAR(30) NOT NULL ,
	CIUDAD VARCHAR (100) NOT NULL ,
	CP VARCHAR (5) NULL ,
	COLONIA VARCHAR (200) NULL ,
	CALLE VARCHAR (200) NULL ,
	NUM_INT VARCHAR (10) NULL
); 
GO

CREATE TABLE DISTRIBUIDOR_O_SUCURSAL(
    ID_SUCURSAL VARCHAR(10) NOT NULL,
	DESCRIPCION VARCHAR (300) NULL,
	ESTADO VARCHAR(30) NOT NULL ,
	CIUDAD VARCHAR (100) NOT NULL ,
	CP VARCHAR (5) NULL ,
	COLONIA VARCHAR (200) NULL ,
	CALLE VARCHAR (200) NULL ,
	NUM_INT VARCHAR (10) NULL,
	PUNTUACION INT NULL
); 
GO

CREATE TABLE VEHICULO (
	ID_VEHICULO VARCHAR (10)  NOT NULL,
	DECRIPCION VARCHAR (300) NULL ,
	TIPO VARCHAR (20) NULL ,
	AÑO VARCHAR(4) NULL ,
	MODELO VARCHAR (5) NULL ,
	COLOR VARCHAR (30) NULL ,
	PRECIO MONEY NULL, 
	EXISTENCIA INT NULL,
	ESTADO VARCHAR
);
GO


CREATE TABLE ACCESORIO (
	ID_ACCESORIO VARCHAR (10)  NOT NULL,
	DECRIPCION VARCHAR (200) NOT NULL,
	PRECIO MONEY NOT NULL, 
	EXISTENCIA int NULL,
	ESTADO VARCHAR NULL
);
GO


CREATE TABLE CLIENTE(
	ID_CLIENTE VARCHAR(10) NOT NULL,
	NOMBRE VARCHAR(60) NOT NULL,
	PRIMER_APELLIDO VARCHAR(60) NOT NULL,
	SEGUNDO_APELLIDO VARCHAR(60) NULL,
	CURP VARCHAR(18) NULL,
	FECHA_NACIMIENTO DATE NULL,
	SEXO VARCHAR(1) NULL
)
GO

CREATE TABLE SERVICIO(
	ID_SERVICIO VARCHAR(10) NOT NULL,
	DESCRIPCION VARCHAR(500) NOT NULL,
	PRECIO MONEY NULL
)
GO


CREATE TABLE FACTURA_ALMACEN (
	NO_PEDIDO VARCHAR (10)  NOT NULL,
	FK_ALMACEN VARCHAR (10)  NOT NULL,
	FK_DISTRIBUIDORA VARCHAR (10) NOT NULL,
	FECHA DATE NULL,
	DESCRIPCION VARCHAR(10) NULL 
);
GO


CREATE TABLE DET_FACTURA_ALMACEN (
	FK_PEDIDO VARCHAR (10)  NOT NULL,
	FK_VEHICULO VARCHAR (10)  NOT NULL,
	CANTIDAD INT
);
GO

CREATE TABLE VENTA_VEHICULO (
	ID_VENTA_VEHICULO VARCHAR (10)  NOT NULL,
	FK_DISTRIBUIDORA VARCHAR (10)  NOT NULL,
	FK_CLIENTE VARCHAR (10) NOT NULL,
	FECHA DATE NULL,
	SUTTOTAL MONEY NULL ,
	TOTAL MONEY NULL ,
	FORMA_PAGO VARCHAR(10) NULL
);
GO


CREATE TABLE DET_VENTA_VEHICULO (
	FK_VENTA_VEHICULO VARCHAR (10)  NOT NULL,
	FK_VEHICULO VARCHAR (10)  NOT NULL,
	CANTIDAD INT
);
GO


CREATE TABLE VENTA_ACCESORIO (
	ID_VENTA_ACCESORIO VARCHAR (10)  NOT NULL,
	FK_DISTRIBUIDORA VARCHAR (10)  NOT NULL,
	FK_CLIENTE VARCHAR (10) NOT NULL,
	FECHA DATE NULL,
	SUTTOTAL MONEY NULL ,
	TOTAL MONEY NULL ,
	FORMA_PAGO VARCHAR(10) NULL
);
GO


CREATE TABLE DET_VENTA_ACCESORIO (
	FK_VENTA_ACCESORIO VARCHAR (10)  NOT NULL,
	FK_ACCESORIO VARCHAR (10)  NOT NULL,
	CANTIDAD INT
);
GO


CREATE TABLE FACT_SERVICIO (
	ID_FACT_SERVICIO VARCHAR (10)  NOT NULL,
	FK_DISTRIBUIDORA VARCHAR (10)  NOT NULL,
	FK_CLIENTE VARCHAR (10) NOT NULL,
	FECHA DATE NULL,
	SUTTOTAL MONEY NULL ,
	TOTAL MONEY NULL ,
	FORMA_PAGO VARCHAR(10) NULL
);
GO


CREATE TABLE DET_FACT_SERVICIO (
	FK_FACT_SERVICIO VARCHAR (10)  NOT NULL,
	FK_SERVICIO VARCHAR (10)  NOT NULL,
	PUNTUACION INT
);
GO



/****************************************************************************************************
ultima actualizacion: 09 DE SEPTIEBRE DE 2018 

RESTRICCIONES DE LLAVE PRIMARIA         PK                 *
*****************************************************************************************************/
-----------------------------------
ALTER TABLE ALMACEN_EMPRESA  ADD 
	CONSTRAINT PK_ALMACEN_EMPRESA 
	PRIMARY KEY  (ID_ALMACEN_EMPRESA); 
GO

ALTER TABLE DISTRIBUIDOR_O_SUCURSAL  ADD 
	CONSTRAINT PK_DISTRIBUIDOR_O_SUCURSAL 
	PRIMARY KEY  (ID_SUCURSAL); 
GO

ALTER TABLE VEHICULO  ADD 
	CONSTRAINT PK_VEHICULO
	PRIMARY KEY  (ID_VEHICULO); 
GO
 
ALTER TABLE ACCESORIO  ADD 
	CONSTRAINT PK_ACCESORIO 
	PRIMARY KEY  (ID_ACCESORIO); 
GO

ALTER TABLE CLIENTE  ADD 
	CONSTRAINT PK_CLIENTE
	PRIMARY KEY  (ID_CLIENTE); 
GO

ALTER TABLE SERVICIO  ADD 
	CONSTRAINT PK_SERVICIO 
	PRIMARY KEY  (ID_SERVICIO); 
GO


ALTER TABLE FACTURA_ALMACEN  ADD 
	CONSTRAINT PK_FACTURA_ALMACEN
	PRIMARY KEY  (NO_PEDIDO); 
GO

ALTER TABLE VENTA_VEHICULO  ADD 
	CONSTRAINT PK_VENTA_VEHICULO
	PRIMARY KEY  (ID_VENTA_VEHICULO); 
GO

ALTER TABLE VENTA_ACCESORIO  ADD 
	CONSTRAINT PK_VENTA_ACCESORIO
	PRIMARY KEY  (ID_VENTA_ACCESORIO); 
GO

ALTER TABLE FACT_SERVICIO  ADD 
	CONSTRAINT PK_FACT_SERVICIO 
	PRIMARY KEY  (ID_FACT_SERVICIO); 
GO


ALTER TABLE DET_FACTURA_ALMACEN  ADD 
	CONSTRAINT PK_DET_FACTURA_ALMACEN
	PRIMARY KEY  (FK_PEDIDO, FK_VEHICULO); 
GO


ALTER TABLE DET_VENTA_VEHICULO  ADD 
	CONSTRAINT PK_DET_VENTA_VEHICULO
	PRIMARY KEY   (FK_VENTA_VEHICULO, FK_VEHICULO); 
GO
	
ALTER TABLE DET_VENTA_ACCESORIO  ADD 
	CONSTRAINT PK_DET_VENTA_ACCESORIO
	PRIMARY KEY  CLUSTERED (FK_VENTA_ACCESORIO, FK_ACCESORIO); 
GO

ALTER TABLE DET_FACT_SERVICIO  ADD 
	CONSTRAINT PK_ET_FACT_SERVICIO 
	PRIMARY KEY  CLUSTERED (FK_FACT_SERVICIO, FK_SERVICIO); 
GO


/****************************************************************************************************
ultima actualizacion: 09 DE SEPTIEBRE DE 2018 
RESTRICCIONES DE LLAVE fORANEA         FK                 *
*****************************************************************************************************/

ALTER TABLE FACTURA_ALMACEN ADD        
	CONSTRAINT FK_FACTURA_ALMACEN_ALMACEN_EMPRESA 
	FOREIGN KEY ( FK_ALMACEN )   
    REFERENCES ALMACEN_EMPRESA( ID_ALMACEN_EMPRESA  );
GO
ALTER TABLE FACTURA_ALMACEN ADD        
	CONSTRAINT FK_FACTURA_ALMACEN_DISTRIBUIDORA
	FOREIGN KEY ( FK_DISTRIBUIDORA )   
    REFERENCES DISTRIBUIDOR_O_SUCURSAL( ID_SUCURSAL  );
GO


ALTER TABLE DET_FACTURA_ALMACEN ADD        
	CONSTRAINT FK_DET_FACTURA_ALMACEN_FACTURA_ALMACEN
	FOREIGN KEY ( FK_PEDIDO )   
    REFERENCES FACTURA_ALMACEN( NO_PEDIDO  );
GO

ALTER TABLE DET_FACTURA_ALMACEN ADD        
	CONSTRAINT FK_DET_FACTURA_ALMACEN_VEHICULO
	FOREIGN KEY ( FK_VEHICULO )   
    REFERENCES VEHICULO( ID_VEHICULO  );
GO

ALTER TABLE VENTA_VEHICULO ADD        
	CONSTRAINT FK_SUCURSAL_VENTA_VEHICULO
	FOREIGN KEY ( FK_DISTRIBUIDORA )   
    REFERENCES DISTRIBUIDOR_O_SUCURSAL( ID_SUCURSAL  );
GO
ALTER TABLE VENTA_VEHICULO ADD        
	CONSTRAINT FK_CLIENTE_VENTA_VEHICULO
	FOREIGN KEY ( FK_CLIENTE )   
    REFERENCES CLIENTE( ID_CLIENTE  );
GO





ALTER TABLE VENTA_ACCESORIO ADD        
	CONSTRAINT FK_SUCURSAL_VENTA_ACCESORIO
	FOREIGN KEY ( FK_DISTRIBUIDORA )   
    REFERENCES DISTRIBUIDOR_O_SUCURSAL( ID_SUCURSAL  );
GO
ALTER TABLE VENTA_ACCESORIO ADD        
	CONSTRAINT FK_CLIENTE_VENTA_ACCESORIO
	FOREIGN KEY ( FK_CLIENTE )   
    REFERENCES CLIENTE( ID_CLIENTE  );
GO


ALTER TABLE FACT_SERVICIO ADD        
	CONSTRAINT FK_SUCURSAL_FACT_SERVICIO
	FOREIGN KEY ( FK_DISTRIBUIDORA )   
    REFERENCES DISTRIBUIDOR_O_SUCURSAL( ID_SUCURSAL  );
GO
ALTER TABLE FACT_SERVICIO ADD        
	CONSTRAINT FK_CLIENTE_FACT_SERVICIO
	FOREIGN KEY ( FK_CLIENTE )   
    REFERENCES CLIENTE( ID_CLIENTE  );
GO





ALTER TABLE DET_FACT_SERVICIO ADD        
	CONSTRAINT DET_FACT_SERVICIO_SERVICIO
	FOREIGN KEY ( FK_SERVICIO )   
    REFERENCES SERVICIO( ID_SERVICIO  );
GO

ALTER TABLE DET_FACT_SERVICIO ADD        
	CONSTRAINT DET_FACT_SERVICIO_FACT_SERVICIO
	FOREIGN KEY ( FK_FACT_SERVICIO )   
    REFERENCES FACT_SERVICIO( ID_FACT_SERVICIO  );
GO






ALTER TABLE DET_VENTA_ACCESORIO ADD        
	CONSTRAINT DET_VENTA_ACCESORIO_ACCESORIO
	FOREIGN KEY ( FK_ACCESORIO )   
    REFERENCES ACCESORIO( ID_ACCESORIO  );
GO
ALTER TABLE DET_VENTA_ACCESORIO ADD        
	CONSTRAINT DET_VENTA_ACCESORIO_VENTA_ACCESORIO
	FOREIGN KEY ( FK_VENTA_ACCESORIO)   
    REFERENCES VENTA_ACCESORIO( ID_VENTA_ACCESORIO  );
GO



ALTER TABLE DET_VENTA_VEHICULO ADD        
	CONSTRAINT DET_VENTA_ACCESORIO_VEHICULO
	FOREIGN KEY ( FK_VEHICULO )   
    REFERENCES VEHICULO( ID_VEHICULO  );
GO
ALTER TABLE DET_VENTA_VEHICULO ADD        
	CONSTRAINT DET_VENTA_ACCESORIO_VENTA_VEHICULO
	FOREIGN KEY ( FK_VENTA_VEHICULO)   
    REFERENCES VENTA_VEHICULO( ID_VENTA_VEHICULO  );
GO




/*******************************RESTRICCION UNIQUE**************************/
ALTER TABLE CLIENTE
ADD CONSTRAINT UX_curp
UNIQUE NONCLUSTERED (CURP)
GO




/******************************1. Restricciones de dominio: DEFAULT*****************************/
/*valor por defecto para sexo es 'M' (masculino), 'F'(Femenino) insertarlo*/
create default df_sexo
as 'M'
go
exec sp_bindefault 'df_sexo', 'CLIENTE.SEXO'--variable sexo de persona, tome la variable df_sexo
go

/*valor por defecto para municipio es Leon*/
create default df_ciudad
as 'León'
go
exec sp_bindefault 'df_municipio', 'DISTRIBUIDOR_O_SUCURSAL.CIUDAD'
go
exec sp_bindefault 'df_municipio', 'DISTRIBUIDOR_O_SUCURSAL.CIUDAD'
go

/*valor por defecto para municipio es Guanajuato*/
create default df_estado
as 'Guanajuato'
go
exec sp_bindefault 'df_estado', 'DISTRIBUIDOR_O_SUCURSAL.estado'
go
exec sp_bindefault 'df_estado', 'DISTRIBUIDOR_O_SUCURSAL.estado'
go


/*************************************************2. RESTRICCIONES DE DOMINIO:  RULES****************/
/*REGLA: solo admite en atributo sexo de la tabla persona M -> masculino  y una F- > femenino*/
create rule rl_sexo
as 
	@mivariable = 'M' or @mivariable ='F'
	--otra forma cuando son muchas @mivar IN('M','F')
Go 
EXEC sp_bindrule 'rl_sexo','CLIENTE.sexo'
go

create rule rl_cp
as --char (5)
	@cp LIKE('[0-9][0-9][0-9][0-9][0-9]')--Primer caracter es numero, el seguno igual, asi hasta el quinto
go
exec sp_bindrule 'rl_cp','DISTRIBUIDOR_O_SUCURSAL.cp'
exec sp_bindrule 'rl_cp','DISTRIBUIDOR_O_SUCURSAL.cp'
GO

create rule rl_curp as
--like compara cadenas
	@curp LIKE
	('[a-z][a-z][a-z][a-z][0-9][0-9][0-9][0-9][0-9][0-9][HM][a-z][a-z][a-z][a-z][a-z][0-9][0-9]')
go
exec sp_bindrule'rl_curp','CLIENTE.curp'
go


/**************************************3. Restricciones de dominio: CHECK*********************/
/*Restriccion CHECK: las fechas finales deben ser mayores a las fechas de inicio*/
/*
ALTER TABLE CLIENTE
ADD CONSTRAINT 
check_curp CHECK
	(curp LIKE '[a-z][a-z][a-z][a-z][0-9][0-9][0-9][0-9][0-9][0-9][HM][a-z][a-z][a-z][a-z][a-z][0-9][0-9]')
go
*/











/*************************************************************************************************************************************
					POBLAR BASE DE DATOS
**************************************************************************************************************************************/


use Nissan
go

-----------------------------------CLIENTES-------------------------------------------------------------SELECT * FROM CLIENTE
INSERT INTO CLIENTE (ID_CLIENTE,NOMBRE,PRIMER_APELLIDO,SEGUNDO_APELLIDO,CURP,FECHA_NACIMIENTO,SEXO) 
VALUES('CL0000001','Miguel','Ramirez','Lira','RALM960925HGTMRG04','1996/09/25','M')
go
INSERT INTO CLIENTE (ID_CLIENTE,NOMBRE,PRIMER_APELLIDO,SEGUNDO_APELLIDO,CURP,FECHA_NACIMIENTO,SEXO) 
VALUES ('CL0000002','Layla','Smith','Adams','TRYI991025MGTMRG44','1990/10/24','F'),
		('CL0000003','Laura','Gonzales','Ortega','RLSA911228MGTMRG75','1991/11/28','F'),
(	'CL0000004',	'Raul'	,'Fermin',	'Luz',	'sdgg982868Haaaas57',		'1988/11/03','M'),
 (	'CL0000005'	,'Jose'	,'Luna',	'Olvera',	'rdfg869805Hsdfgh78'	,'1997/03/29',	'M'	),
(	'CL0000006',	'Luis',	'Lorenzo'	,'Quintero',	'tyyh531298Hertyu82',	'1982/02/14',	'M'	),
 (	'CL0000007',	'Eder'	,'Padilla',	'Plaza'	,'dfgt924343Hdfghj12',	'1984/04/15',	'M'	),
 (	'CL0000008'	,'Rafael',	'Osuna',	'Servin',	'fghh133835Haaaas98',	'1992/03/30',	'M'	),
 (	'CL0000009'	,'Genaro',	'Napoles',	'Davila',	'oiuy412329Hsdfgh12'	,'1985/10/11',	'M'),
 (	'CL0000010'	,'Isai',	'Montez',	'Guevara',	'sdfg952846Hertyu76',	'1990/05/04',	'M'	),
 (	'CL0000011'	,'Omar'	,'Ortega'	,'Mojica',	'sdfg656233Hdfghj66',	'1996/09/14',	'M'	),
 (	'CL0000012',	'Cesar'	,'Osorio',	'Garcia',	'sdfg492094Haaaas91'	,'1995/03/04',	'M'	),
 (	'CL0000013'	,'Guadalupe',	'Montero',	'Rios'	,'sdfg952189Hsdfgh77',	'1997/07/14',	'M'	),
 (	'CL0000014',	'Jesus',	'Lopez'	,'Soto',	'dfgs265409Hertyu37'		,'1983/01/05'	,'M'	),
 (	'CL0000015'	,'Osvaldo'	,'Orosco'	,'Padilla'	,'sdfg262688Hdfghj90'		,'1984/07/20'	,'M'	),
 (	'CL0000016'	,'Gabriel'	,'Perez'	,'Peralta',	'sdfg203210Maaaas19',	'1989/06/16'	,'M'	),
 (	'CL0000017'	,'Conia'	,'Pardo'	,'Valdes',	'sdfg919434Msdfgh36'		,'1997/04/02','F'),
 (	'CL0000018'	,'Elena'	,'Velazco'	,'Ortiz'	,'sdfg345995Mertyu48'		,'1982/11/30','F'),
 (	'CL0000019'	,'Rosa',	'Rivas'	,'Villa'	,'sdfg960415Mdfghj95'		,'1984/10/19','F'	),
 (	'CL0000020'	,'Monica',	'Cortes'	,'Trinidad'	,'sdfg967563Maaaas71'		,'1993/10/01','F'	),
 (	'CL0000021'	,'Alejandra'	,'Falcon'	,'Vallejo'	,'sdfg817099Msdfgh18',		'1998/03/01','F'	),
 (	'CL0000022',	'Angelica'	,'Guerra',	'Vivas'	,'dfgh886954Mertyu43'		,'1990/06/20','F'	),
 (	'CL0000023'	,'Marilu',	'Marmolejo'	,'Reyna',	'fghj415838Mdfghj27',		'1997/04/02','F'	),
 (	'CL0000024',	'Fatima'	,'Villalobos'	,'Arguello'	,'ghjk634343Maaaas42',		'1981/03/23','F'),
(	'CL0000025'	,'Maria'	,'Martinez',	'Benito'	,'wert672993Msdfgh30','1981/12/05',	'F'		),
 (	'CL0000026'	,'Yolanda',	'Alvarez'	,'Alamo',	'erty325982Mertyu23'	,'1986/10/01',	'F'	),
 (	'CL0000027',	'Esperanza'	,'Moreno'	,'Bonilla',	'tytu637072Mdfghj13',	'1986/03/25',	'F'	),
 (	'CL0000028'	,'Luz',	'Vasquez',	'Segura',	'yuio248488Maaaas25'		,'1994/02/28','F'	),
 (	'CL0000029'	,'Martha'	,'Bustos'	,'Bonfil',	'yuio913764Msdfgh24','1981/08/03',	'F'		)

INSERT INTO CLIENTE (ID_CLIENTE,NOMBRE,PRIMER_APELLIDO,SEGUNDO_APELLIDO,CURP,FECHA_NACIMIENTO,SEXO) 
VALUES  ('CL0000030','Acton','Fuentes','Blackwell','BCHZ302937HAEUZG18','1978/09/16','M'),
('CL0000031','Yolanda','Warner','Cooper','WVDN598645MMFBBE48','1986/03/05','F'),
('CL0000032','Kasper','Brock','Hansen','NIXZ747047HVSACV80','1978/09/26','M'),
('CL0000033','Nicholas','Oliver','Hooper','SXAX290019HEVNPY59','1970/02/02','M'),
('CL0000034','Dante','Head','Cameron','NDYQ200639HCFHBD43','1980/07/28','M'),
('CL0000035','Cara','Hooper','Medina','OZDA469781MSZLJK14','1989/03/17','F'),
('CL0000036','Linus','Shannon','Vinson','XXFD993707MYTZPZ52','1986/07/16','F'),
('CL0000037','Ashely','Norton','Coleman','XFIG009167MSDXWA73','1996/01/06','F'),
('CL0000038','Timon','Massey','Giles','ONHY126097HSUHJD56','1985/03/02','M'),
('CL0000039','Kieran','Sanders','Martinez','XNOY987874HXVMXQ90','1980/09/19','M'),
('CL0000040','Anne','Zimmerman','Murray','UHOL591914MGWYQP68','1985/05/17','F'),
('CL0000041','Erica','Dunlap','Hernandez','ENWN312980MWKXAZ82','1982/12/06','F'),
('CL0000042','Margaret','Weiss','Gillespie','BDAK165014MUFKKN56','1992/07/16','F'),
('CL0000043','Camden','Sullivan','Robertson','EGXI357125HWLMGQ14','1989/01/08','M'),
('CL0000044','Jermaine','Houston','Lowe','JOUN615691MHCSVR87','1976/03/23','F'),
('CL0000045','Jordan','Allen','Beard','KPHV586590HALBDC56','1991/06/21','M'),
('CL0000046','Quinn','Hawkins','Clarke','DWAL814195MKVWYK96','1977/05/20','F'),
('CL0000047','Lenore','Martinez','Gallagher','YHQT253421MQFHNQ49','1980/10/25','F'),
('CL0000048','Lucius','Pace','Pratt','DGTE595242HRHJRZ28','1974/04/27','M'),
('CL0000049','Gretchen','Shaffer','Frost','QEVX915079MGXAJS95','1996/07/22','F'),
('CL0000050','Charissa','Cherry','Gentry','UTRB001814MQEUTQ45','1971/05/28','F'),
('CL0000500','Rashad','Gross','Forbes','LZJK566411HDYEDT82','1977/07/04','M'),
('CL0000501','Dexter','Eaton','Abbott','AYNQ231394HIGXES21','1986/03/20','M'),
('CL0000502','Honorato','Rivers','Hopkins','GYVX838029HHOFPM73','1974/12/18','M'),
('CL0000503','Gray','Russo','Price','CWZI601896HSLWRQ64','1981/09/17','M'),
('CL0000504','Cyrus','Melton','Randall','CARO452833HAVYMF35','1991/01/24','M'),
('CL0000505','Conan','Gomez','Bernard','EYXL197079HSKJQN55','1986/06/29','M'),
('CL0000506','Erasmus','Gray','Calhoun','KLLW044809HHFSKC46','1996/04/24','M'),
('CL0000507','Elizabeth','Jimenez','Franklin','MTWN721234MFBUXN49','1984/03/21','F'),
('CL0000508','Nicholas','Tanner','Sandoval','AIKI595782HKITIQ27','1992/09/25','M'),
('CL0000509','Chester','Tanner','Levine','TQCK580274HZWWYO51','1992/09/09','M'),
('CL0000510','Serina','Clark','Potts','POTX334477MXKNXF78','1984/07/22','F'),
('CL0000511','Yasir','Maldonado','Dunlap','ZAXR511058HUORRH11','1994/10/26','M'),
('CL0000512','Arthur','Mcgowan','Key','FLNJ156755HYLYRM78','1981/11/25','M'),
('CL0000513','Britanney','Mejia','Dale','NEMK499174MUCOAG19','1983/10/08','F'),
('CL0000514','Rose','Patterson','Bryant','WLVG819238MKAJIC09','1983/08/31','F'),
('CL0000515','Channing','Little','Gilbert','CQYQ565920HOPIWK02','1993/02/03','M'),
('CL0000516','Kuame','Hurst','Frazier','IKZS432734HDRLKU29','1975/05/15','M'),
('CL0000517','Ezekiel','Bates','Copeland','SNHM610475HGPSVM21','1995/06/01','M'),
('CL0000518','Irma','Vargas','Kinney','TYMR086972MBTHJK23','1984/03/15','F'),
('CL0000519','Zahir','Kirk','Clarke','KJNF347637HEJDVJ54','1977/10/27','M'),
('CL0000520','Maggie','Norman','Graves','LSGB645717MPTKIC17','1979/03/14','F'),
('CL0000521','Beck','Eaton','Vaughan','HPRP651258HYTKSK21','1988/11/30','M'),
('CL0000522','Salvador','Hines','Guthrie','NBGZ111577HFXDHN58','1984/02/04','M'),
('CL0000523','Gabriel','Mcmahon','Moses','MYYR756087HAXIVT86','1994/04/16','M'),
('CL0000524','Forrest','Meyer','Hess','QMCC800093HALUUX50','1994/02/13','M'),
('CL0000525','Timothy','Herman','Rosario','MMYE876269HGABQN91','1978/03/11','M'),
('CL0000526','Xandra','Cotton','Spencer','EHDX541151MGEBXA30','1992/02/08','F'),
('CL0000527','Nehru','Head','Brady','IMVR299735HBPZRF40','1991/02/19','M'),
('CL0000528','Jaime','Gardner','Stewart','RQIU724354HMNCXY01','1972/01/03','M'),
('CL0000529','Melodie','Lester','Bridges','ZXAP662427MGIMBI42','1993/05/28','F'),
('CL0000530','Grady','Cobb','Yang','HRBX775522MEMDVM18','1974/12/21','F'),
('CL0000531','Xanthus','Cleveland','Mills','NPLI532483HMOQKI22','1986/10/31','M'),
('CL0000532','Shea','Flynn','Simon','VOCU391234MDFYGR13','1989/10/22','F'),
('CL0000533','Carol','Fitzgerald','Beach','IVOM700874MXTWEU28','1986/08/08','F'),
('CL0000534','Marah','Clements','Bartlett','UXDS272876MRSLPZ78','1986/11/21','F'),
('CL0000535','Jermaine','Mcbride','Robinson','HVOJ659512MZVPLQ87','1989/04/14','F'),
('CL0000536','Lev','Gay','Mcclain','OVSM113783HEZLSF34','1982/11/24','M'),
('CL0000537','Jelani','Mckenzie','Green','CSVS444434MWSCDG78','1972/07/03','F'),
('CL0000538','Hollee','Vasquez','Valenzuela','USLU511482MMFXJB05','1992/05/26','F'),
('CL0000539','Amir','Moran','Palmer','VQBC836110MXIPNY19','1984/12/09','F'),
('CL0000540','Zeph','Tyson','Kirk','DXXU956217HLKOCB76','1982/07/28','M'),
('CL0000541','Arsenio','Green','Waller','CXLZ118892HRAZTG50','1986/03/11','M'),
('CL0000542','Wynne','Jarvis','Snider','MINQ226549MNMSBS09','1991/02/04','F'),
('CL0000543','Constance','Benton','Williamson','TPJW234693MXJLDT87','1973/10/13','F'),
('CL0000544','Brynn','Spencer','Bishop','FNFO237822HSSJHX21','1981/06/01','M'),
('CL0000545','Price','Obrien','Dale','ZPPO617376HMZBVU26','1979/03/13','M'),
('CL0000546','Pamela','Crosby','Norman','ZJPH660022MCXMUL12','1997/03/09','F'),
('CL0000547','Slade','Dawson','Riddle','YDGP518169HLZQVL18','1977/01/02','M'),
('CL0000548','Timon','Powell','Bonner','HSVX617460HVSCKP11','1989/09/29','M'),
('CL0000549','Dominic','Richards','Delgado','GGCP647332HGULOS00','1986/04/20','M'),
('CL0000550','Jordan','Blevins','Green','KFBF423231HKQPPG39','1972/11/27','M'),
('CL0000551','Owen','Gilbert','Reese','UTJN837985HEBNRO07','1989/11/06','M'),
('CL0000552','Demetria','Irwin','Morgan','CFKX322180MSVJAG82','1986/07/25','F'),
('CL0000553','Marvin','Sosa','Burnett','KPBD981139HPMMXG78','1974/12/11','M'),
('CL0000554','Jerry','Frost','Phelps','XQPH851508HHFZMS57','1978/08/31','M'),
('CL0000555','Ocean','David','Fowler','CPWR865288HPUJJJ05','1995/01/30','M'),
('CL0000556','Craig','Mullen','Saunders','KLNU654115HQSZFW67','1970/08/09','M'),
('CL0000557','Cailin','Hernandez','Craft','MKVH431966MTHCEG79','1991/12/09','F'),
('CL0000558','Cooper','Boone','Franklin','NCMM538982HWHNJV39','1980/03/06','M'),
('CL0000559','Aiko','Mack','Lawson','KFFZ567924HWZVJI64','1984/02/29','M'),
('CL0000560','Michael','Battle','Kerr','SWUW998480HHNINC47','1997/10/08','M'),
('CL0000561','Hyacinth','Church','Wolf','HTOG589633HDYCKK64','1973/09/21','M'),
('CL0000562','Nyssa','Buckley','Powers','ZRAD584317MWFNBT77','1988/03/02','F'),
('CL0000563','Olympia','Mills','Baldwin','DGFC164886MZKDRA61','1982/11/06','F'),
('CL0000564','Samson','Bray','Mack','GFCC038205HOFUHB60','1991/12/29','M'),
('CL0000565','Ocean','Reed','Bradford','LMAF752923HCRDWP35','1983/12/16','M'),
('CL0000566','Brooke','Macias','Norris','NYFC260622HZTNEE12','1973/11/25','M'),
('CL0000567','Alan','Clements','Sutton','ZDDW468378HPTAAG49','1978/12/14','M'),
('CL0000568','Venus','Byrd','Goodwin','WDNR398264MBXUSL56','1971/05/05','F'),
('CL0000569','Bell','Durham','Justice','TQJW342479HULRAX75','1972/05/16','M'),
('CL0000570','Camilla','Emerson','Talley','OORS619092MPNERT61','1978/04/15','F'),
('CL0000571','Gabriel','Colon','Carey','UDHG956181HVMVUE79','1974/09/30','M'),
('CL0000572','Quintessa','Castro','King','RIPM597659MWRNNH02','1984/01/02','F'),
('CL0000573','Melinda','Bradley','Russell','YBYY097863MWHOPI94','1990/07/18','F'),
('CL0000574','Conan','Green','Schwartz','AHEO770404HXGQBJ89','1974/05/05','M'),
('CL0000575','Carol','Noble','Rogers','QFOQ811134MAXHPP96','1978/03/22','F'),
('CL0000576','Melodie','Harrison','Hodges','IWNP367417MJWNZJ64','1990/06/26','F'),
('CL0000577','Clark','Woods','Farrell','PTUQ093636HYRVNG15','1976/08/06','M'),
('CL0000578','Zelda','Carroll','Dotson','MCBD597105HGPKLA13','1989/02/22','M')






-----------------------------------ALMACEN_EMPRESA-------------------------------------------------------------    SELECT * FROM ALMACEN_EMPRESA

INSERT INTO ALMACEN_EMPRESA(ID_ALMACEN_EMPRESA,DESCRIPCION,ESTADO,CIUDAD,CP,COLONIA,CALLE,NUM_INT) 
VALUES
('ALM0001','ALMACEN PRINCIPAL','Mexico','Atotonilco','15208','centro','Teoloyucan','878'),
('ALM0002','ALMACEN SECUNDARIO','Ciudad de Mexico','Coyoacan','29534','centro','Liberta','711'),
('ALM0003','ALMACEN PRINCIPAL','Ciudad de Mexico','Itztapalapa','47574','centro','El refugio','219'),
('ALM0004','ALMACEN PRINCIPAL','Ciudad de Mexico','Alvaro Obregon','93148','centro','Omega','940')




-----------------------------------DISTRIBUIDOR_O_SUCURSAL  -------------------------------------------------   SELECT * FROM DISTRIBUIDOR_O_SUCURSAL



INSERT INTO DISTRIBUIDOR_O_SUCURSAL(ID_SUCURSAL,DESCRIPCION,ESTADO,CIUDAD,CP,COLONIA,CALLE,NUM_INT,PUNTUACION) 
VALUES				
('SUC00001','NISSAN GUANAJUATO','Guanajuato','Guanajuato','93100','centro'		,'20 de Enero'			,'611'	  ,0										),
('SUC00002','NISSAN IRAPUATO','Guanajuato','Irapuato','59392','centro'			,'Alamo'				,'549'	,0										),
('SUC00003','NISSAN 1 LEON','Guanajuato','Leon','66743'	,'centro'				,'Agua Azul'			,'578'	,0										),
('SUC00004','NISSAN 2 LEON','Guanajuato','Leon','66743'	,'centro'				,'San  Miguel'			,'500'	,0										),
('SUC00005','SUC NISSAN DE SILAO','Guanajuato','Silao','84160','centro'		,'Alamo del valle'		,'429'		,0										),
('SUC00006','NISSAN YURIDIA','Guanajuato','Yuridia','25524'	,'centro'		,'Morelos'				,'780'		,0										),
('SUC00007','NISSAN SMA','Guanajuato','San  Miguel de Allende','50783'	,'centro'			,'Madero'				,'102'		,0					),
('SUC00008','NISSAN LA PAZ','Mexico','La paz','14764','centro'				,'Valadez'				,'623'		,0										),
('SUC00009','NISSAN LERMA','Mexico','Lerma','50508'	,'centro'			,'El dorado'			,'649'			,0								),
('SUC000010','NISSAN 1 MORELOS','Mexico','Morelos','30897','centro'				,'Lopez'				,'487'	,0										)





--------------------------------------			SERVICIO	----------------------  SELECT * FROM SERVICIO
insert into SERVICIO (ID_SERVICIO,DESCRIPCION,PRECIO)
values ('SE0000001','Aceite semi-sintetico',326),
('SE0000002','Aceite sintetico',760),
('SE0000003','Filtro de aire',470),
('SE0000004','Filtro de aire acondicionado',769),
('SE0000005','Pastillas de freno delanteras',1777),
('SE0000007','Revision del filtro de agua',150),
('SE0000008','Ajuste de bombillas',200),
('SE0000009','tensor de faja',700),
('SE0000010','Juego libre de clutch',500),
('SE0000011','Limpieza de terminales',350),
('SE0000012','Servicio general 10mil Km',5130),
('SE0000013','Servicio general 20mil Km',7780),
('SE0000014','Servicio general 30mil Km',5130),
('SE0000015','Servicio general 40mil Km',8720),
('SE0000016','Servicio general 50mil Km',5130),
('SE0000017','Servicio general 60mil Km',7780),
('SE0000018','Servicio general 70mil Km',5130),
('SE0000019','Servicio general 80mil Km',10060),
('SE0000020','Servicio general 90mil Km',5130),
('SE0000021','Servicio general 100mil Km',9540);
GO




-----------------------------			ACCESORIO			-----------------   SELECT * FROM ACCESORIO

insert into ACCESORIO (ID_ACCESORIO,DECRIPCION,PRECIO,EXISTENCIA) 
values ('AC0000001','Antifaz',2429,2453),
('AC0000002','Calcomanias deportivas',4630,4606),
('AC0000003','Canastilla portaequipaje',5324,560),
('AC0000004','Cenicero con luz',626,3452),
('AC0000005','Faldon delantero',4851,780),
('AC0000006','Faldon tracero',4851,850),
('AC0000007','Faldones laterales',4925,355),
('AC0000008','Iluminacion interior',7006,742),
('AC0000009','Kit de emergencia',1564,4003),
('AC0000010','Portaplacas cromado',980,7430),
('AC0000011','Portacasco cromado',731,564),
('AC0000012','Protectores espejo',649,304),
('AC0000013','Punta de escape',908,501),
('AC0000014','Spoiler trasero naranja',4960,6430),
('AC0000015','Tapete de vinil',676,6700),
('AC0000016','Tuercas de seguridad',615,120234);
GO




insert into ACCESORIO (ID_ACCESORIO,DECRIPCION,PRECIO,EXISTENCIA) 
values  ('AC0000017','Barras porta equipaje Osun reforzadas',550,320),
	('AC0000018','Daewoo kit Auto con 2 bocinas 6.5 con control',965,2099),
	('AC0000019','Lip Universal flexible faldon estribo',350,1315),
	('AC0000020','Luz de cortesia Puerta Proyector Led logo inalambrico',294,934),
	('AC0000021','Moldura vista decorativa brilla metalica interior',139,465),
	('AC0000022','Cantoneras Universales JETTA',679,2345),
	('AC0000023','Kit polarizado',300,192),
	('AC0000024','Carcasa llave control VW Jetta Golf',249,1661),
	('AC0000025','Juego de Pedales Vocho VW Sedan',921,244),
	('AC0000026','Inversor de correinte automotriz de 12v',225,86),
	('AC0000027','Aleron Cajuela Spoiler',399,12345),
	('AC0000028','Antena Aleta de tiburon para radio VW',279,606),
	('AC0000029','Hankook letras para llantas de caucho',1000,21),
	('AC0000030','Canastilla portaequipaje',549,442),
	('AC0000031','Tacometro digital luz laser optico',294,98),
	('AC0000032','Juego marco portaplacas marca razen',37,9876),
	('AC0000033','Vinil reflejante',65,100000),
	('AC0000034','20 modulos luz LED 5630',96,1234),
	('AC0000035','Asidero Volkswagen Jetta Izquierdo Golf',299,286),
	('AC0000036','Porta bicicletas Osun Universal',4321,12),
	('AC0000037','Tapetes Originales VW Jetta A4 Clasico',584,720),
	('AC0000038','Funda portectora afelpada ultraligera',850,633),
	('AC0000039','Simulador Turbo Whistle Escape mediano',119,83),
	('AC0000040','Papel polarizado anriraya 30m x 50 cm',342,111111),
	('AC0000041','Agarradera Jeep Wrangler JK',289,493),
	('AC0000042','Tapon 33 alto de pico de plastico',14,89765),
	('AC0000043','Tapones cromados para valvula o pivote de rin',99,12345),
	('AC0000044','Moldura vista decorativa autoadherible',199,345),
	('AC0000045','Funda silicon Honda 3 Accord Civic',58,7676),
	('AC0000046','Switch maestro volkswagen Jetta A4',1342,11),
	('AC0000047','Aleron Cajuela Original VW JETTA A6',972,1123),
	('AC0000048','Boton palanca de cambios Sonic 2012',1342,19),
	('AC0000049','Porta placa europea',160,100),
	('AC0000050','Tapa codera vinilpiel Jetta Clasico A4',389,1998)


















































