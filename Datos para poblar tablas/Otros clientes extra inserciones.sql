
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



