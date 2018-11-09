/*
    Juda Alector   
    2 de Octubre del 2018
    SpreadSheed creado para generar datos : 
        https://docs.google.com/spreadsheets/d/1zDV00ki-q4fvIUi2kwDyBLcQHeFxqic65LjFI68-H0s/edit?usp=sharing        

    Referencias para los servicios: 
        https://www.nissan.com.mx/servicios/
        https://www.mazda.mx/mi-mazda/mantenimiento
*/
use Nissan
GO


--------------------------------------			SERVICIO	----------------------  SELECT * FROM SERVICIO


insert into SERVICIO values 
('SERV00086734563', 'Cambio de llanta (se cambiará por la de refacción)', 3000),
('SERV00086734564', 'Suministro de gasolina (10 litros con costo para el beneficiario)', 2500),
('SERV00086734565', 'Cerrajería', 1000),
('SERV00086734566', 'Transmisión de mensajes urgentes', 500),
('SERV00086734567', 'Información turística', 750),
('SERV00086734568', 'Consultoría médica telefónica', 1600),
('SERV00086734569', 'Traslado médico terrestre al centro hospitalario más cercano y/o adecuado.', 3500),
('SERV00086734570', 'Asistencia legal telefónica', 2000),
('SERV00086734571', 'Asesoría legal telefónica en caso de robo', 500),
('SERV00086734572', 'Asistencia legal presencial por robo total del vehículo', 3000),
('SERV00086734573', 'Asistencia legal presencial en caso de accidente automovilístico', 6000),
('SERV00086734574', 'Servicio de taxi', 900),
('SERV00086734575', 'Médico a domicilio', 7000),
('SERV00086734576', 'Envío y pago de remolque', 5500),
('SERV00086734577', 'Traslado a domicilio después de un accidente automovilístico', 4000),
('SERV00086734578', 'Gastos de hotel por avería', 10500),
('SERV00086734579', 'Renta de auto por avería', 6000),
('SERV00086734580', 'Chofer', 12000),
('SERV00086734581', 'Gastos de hotel por prescripción médica', 13000),
('SERV00086734582', 'Boleto redondo para un familiar', 25000),
('SERV00086734583', 'Traslado en caso de fallecimiento y entierro local', 15000),
('SERV00086734584', 'Transportación por regreso o continuación de viaje por avería', 5000),
('SERV00086734585', 'Boleto para recoger el auto reparado', 7000),
('SERV00086734586', 'Gastos de hotel por robo total del vehículo', 18000),
('SERV00086734587', 'Transportación a lugar de origen o destino por robo de auto', 22000),
('SERV00086734588', 'Boleto para recoger el vehículo recuperado', 1000),
('SERV00086734589', 'Aceite de motor y filtro de aceite', 500),
('SERV00086734590', 'Filtro de aire', 750),
('SERV00086734591', 'Filtro de aire de la cabina', 600),
('SERV00086734592', 'Líquido de frenos', 600),
('SERV00086734593', 'Chapas y bisagras', 1200),
('SERV00086734594', 'Cubre polvos de semiejes', 500),
('SERV00086734595', 'Líneas de combustible y mangueras', 750),
('SERV00086734596', 'Líneas y mangueras de frenos', 750),
('SERV00086734597', 'Mangueras y tubos del sistema de emisiones', 800),
('SERV00086734598', 'Niveles / rellenar', 1000),
('SERV00086734599', 'Sistema de enfriamiento', 2500),
('SERV00086734600', 'Sistema de escape y deflectores de calor', 3000),
('SERV00086734601', 'Tensión de bandas', 1500),
('SERV00186734601', 'Varillaje y funcionamiento de la dirección', 500),
('SERV00286734601', 'Frenos', 700),
('SERV00386734601', 'Suspensión delantera y trasera, rótulas y juego axial de baleros', 4000),
('SERV00486734601', 'Presión de llantas / ajustar', 200);




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
