/*
NOTA, es mejor GENERAR los coches desde SQL con el Script llamado "Rutina de llenado de vehiculos.sql" porque deben ser la misma catidad de autos que de ventas
Por lo que YA NO DEBEN DE EJECUTAR ESTE SCRIPT
    Juda Alector 
    2 de Octubre del 2018
    SpreadSheed creado para generar datos : 
        https://docs.google.com/spreadsheets/d/1eVEhgGP1lwOyfhmQ6gK9Ur81weuBYFF26o9CJeQZgqw/edit?usp=sharing
*/

Use Nissan
GO

SELECT * FROM VEHICULO
GO

insert into VEHICULO (ID_VEHICULO, TIPO, AÑO, MODELO,COLOR, PRECIO, EXISTENCIA) VALUES
( 'VH00947233', 'Electrico', 2014, 'TSURU', 'Negro', 689543, 163),
( 'VH01947234', 'Estandar', 2015, 'PLATINA', 'Camello', 2896067, 169),
( 'VH02947235', 'Automático', 2018, 'TSURU', 'Vino', 548754, 64),
( 'VH03947236', 'Electrico/automático', 2008, 'PLATINA', 'Blanco escarcha', 1790211, 100),
( 'VH04947237', 'Electrico/estandar', 2006, 'MICRO', 'Negro', 2814786, 77),
( 'VH05947238', 'Electrico', 2008, 'TSURU', 'Rojo', 728687, 120),
( 'VH06947239', 'Estandar', 2015, 'APRIO', 'Verde', 435954, 43),
( 'VH07947240', 'Automático', 2010, 'LUCINO', 'Amarillo', 360160, 75),
( 'VH08947241', 'Electrico/automático', 2007, 'TSURU', 'Rojo/Negro', 565618, 98),
( 'VH09947242', 'Electrico/estandar', 2005, 'VERSA', 'Gris', 1329877, 145),
( 'VH10947243', 'Electrico', 2016, 'VERSA', 'Plata', 2444207, 95),
( 'VH11947244', 'Estandar', 2014, 'GT-R', 'Negro', 2027062, 178),
( 'VH12947245', 'Automático', 2003, 'VERSA', 'Camello', 617406, 152),
( 'VH13947246', 'Electrico/automático', 2017, 'VERSA', 'Vino', 2704268, 179),
( 'VH14947247', 'Electrico/estandar', 2003, 'VERSA', 'Blanco escarcha', 423711, 148),
( 'VH15947248', 'Electrico', 2007, 'VERSA', 'Negro', 2236048, 35),
( 'VH16947249', 'Estandar', 2015, 'MAXIMA', 'Rojo', 749752, 18),
( 'VH17947250', 'Automático', 2000, 'PLATINA', 'Verde', 1393303, 149),
( 'VH18947251', 'Electrico/automático', 2019, 'TIIDA', 'Amarillo', 904568, 56),
( 'VH19947252', 'Electrico/estandar', 2004, 'SENTRA', 'Rojo/Negro', 1706147, 115),
( 'VH20947253', 'Electrico', 2011, 'MICRO', 'Gris', 2104212, 61),
( 'VH21947254', 'Estandar', 2019, 'VERSA', 'Plata', 1372110, 154),
( 'VH22947255', 'Automático', 2016, 'VERSA', 'Negro', 1885826, 149),
( 'VH23947256', 'Electrico/automático', 2019, 'APRIO', 'Camello', 2837986, 109),
( 'VH24947257', 'Electrico/estandar', 2008, 'HIRAKI', 'Vino', 1385536, 91),
( 'VH25947258', 'Electrico', 2015, 'MAXIMA', 'Blanco escarcha', 1842630, 2),
( 'VH26947259', 'Estandar', 2020, 'MICRA', 'Negro', 2017280, 44),
( 'VH27947260', 'Automático', 2010, 'SENTRA', 'Rojo', 1254461, 39),
( 'VH28947261', 'Electrico/automático', 2013, 'APRIO', 'Verde', 2479883, 165),
( 'VH29947262', 'Electrico/estandar', 2011, 'LUCINO', 'Amarillo', 2171455, 165),
( 'VH30947263', 'Electrico', 2001, 'MICRA', 'Rojo/Negro', 1597460, 32),
( 'VH31947264', 'Estandar', 2015, 'TSURU', 'Gris', 2672848, 181),
( 'VH32947265', 'Automático', 2003, 'LUCINO', 'Plata', 863438, 64),
( 'VH33947266', 'Electrico/automático', 2014, 'HIRAKI', 'Negro', 1320804, 52),
( 'VH34947267', 'Electrico/estandar', 2009, 'PLATINA', 'Camello', 2311239, 119),
( 'VH35947268', 'Electrico', 2014, 'GT-R', 'Vino', 806751, 146),
( 'VH36947269', 'Estandar', 2006, 'DATSUN', 'Blanco escarcha', 1274876, 166),
( 'VH37947270', 'Automático', 2018, 'PLATINA', 'Negro', 621073, 197),
( 'VH38947271', 'Electrico/automático', 2005, 'LUCINO', 'Rojo', 2130502, 136),
( 'VH39947272', 'Electrico/estandar', 2020, 'TSURU', 'Verde', 1096366, 105),
( 'VH40947273', 'Electrico', 2000, 'SENTRA', 'Amarillo', 1025098, 140),
( 'VH41947274', 'Estandar', 2013, 'SENTRA', 'Rojo/Negro', 2633403, 130),
( 'VH42947275', 'Automático', 2000, 'MICRA', 'Gris', 2101321, 126),
( 'VH43947276', 'Electrico/automático', 2011, 'VERSA', 'Plata', 2165465, 191),
( 'VH44947277', 'Electrico/estandar', 2006, 'ALTIMA', 'Negro', 817690, 94),
( 'VH45947278', 'Electrico', 2019, 'GT-R', 'Camello', 2350695, 32),
( 'VH46947279', 'Estandar', 2006, 'MICRA', 'Vino', 441056, 89),
( 'VH47947280', 'Automático', 2020, 'SENTRA', 'Blanco escarcha', 1603554, 178),
( 'VH48947281', 'Electrico/automático', 2012, 'APRIO', 'Negro', 2053540, 92),
( 'VH49947282', 'Electrico/estandar', 2006, 'VERSA', 'Rojo', 1285527, 71),
( 'VH50947283', 'Electrico', 2014, 'DATSUN', 'Verde', 468838, 198),
( 'VH51947284', 'Estandar', 2018, 'NOTE', 'Amarillo', 971641, 161),
( 'VH52947285', 'Automático', 2018, 'DATSUN', 'Rojo/Negro', 693044, 181),
( 'VH53947286', 'Electrico/automático', 2018, 'MICRA', 'Gris', 2893382, 178),
( 'VH54947287', 'Electrico/estandar', 2004, 'MAXIMA', 'Plata', 792863, 85),
( 'VH55947288', 'Electrico', 2015, 'TSURU', 'Negro', 2430054, 38),
( 'VH56947289', 'Estandar', 2004, 'GT-R', 'Camello', 2449340, 129),
( 'VH57947290', 'Automático', 2018, 'GT-R', 'Vino', 1679651, 89),
( 'VH58947291', 'Electrico/automático', 2014, 'VERSA', 'Blanco escarcha', 1277930, 6),
( 'VH59947292', 'Electrico/estandar', 2000, 'HIRAKI', 'Negro', 1286730, 26),
( 'VH60947293', 'Electrico', 2010, 'PLATINA', 'Rojo', 786015, 135),
( 'VH61947294', 'Estandar', 2002, 'LUCINO', 'Verde', 1438836, 109),
( 'VH62947295', 'Automático', 2009, 'PLATINA', 'Amarillo', 216668, 164),
( 'VH63947296', 'Electrico/automático', 2008, 'MAXIMA', 'Rojo/Negro', 1864439, 99),
( 'VH64947297', 'Electrico/estandar', 2003, 'GT-R', 'Gris', 2692717, 197),
( 'VH65947298', 'Electrico', 2002, 'DATSUN', 'Plata', 774391, 106),
( 'VH66947299', 'Estandar', 2006, 'TIIDA', 'Negro', 827894, 108),
( 'VH67947300', 'Automático', 2014, 'DATSUN', 'Camello', 785355, 84),
( 'VH68947301', 'Electrico/automático', 2020, 'TIIDA', 'Vino', 312101, 102),
( 'VH69947302', 'Electrico/estandar', 2017, 'DATSUN', 'Blanco escarcha', 2347645, 115),
( 'VH70947303', 'Electrico', 2000, 'PLATINA', 'Negro', 1105518, 16),
( 'VH71947304', 'Estandar', 2012, 'MICRO', 'Rojo', 2871434, 14),
( 'VH72947305', 'Automático', 2011, 'MICRA', 'Verde', 2791571, 32),
( 'VH73947306', 'Electrico/automático', 2013, 'VERSA', 'Amarillo', 2204228, 143),
( 'VH74947307', 'Electrico/estandar', 2020, 'TIIDA', 'Rojo/Negro', 541459, 36),
( 'VH75947308', 'Electrico', 2020, 'VERSA', 'Gris', 1159012, 167),
( 'VH76947309', 'Estandar', 2009, 'HIRAKI', 'Plata', 2633222, 33),
( 'VH77947310', 'Automático', 2017, 'GT-R', 'Negro', 226464, 56),
( 'VH78947311', 'Electrico/automático', 2007, 'MICRA', 'Camello', 1945998, 12),
( 'VH79947312', 'Electrico/estandar', 2017, 'HIRAKI', 'Vino', 1626089, 72),
( 'VH80947313', 'Electrico', 2016, 'MICRA', 'Blanco escarcha', 715453, 59),
( 'VH81947314', 'Estandar', 2013, 'GT-R', 'Negro', 660147, 60),
( 'VH82947315', 'Automático', 2007, 'ALTIMA', 'Rojo', 1288990, 81),
( 'VH83947316', 'Electrico/automático', 2002, 'MICRA', 'Verde', 330706, 49),
( 'VH84947317', 'Electrico/estandar', 2013, 'VERSA', 'Amarillo', 2059663, 134),
( 'VH85947318', 'Electrico', 2005, 'APRIO', 'Rojo/Negro', 364139, 123),
( 'VH86947319', 'Estandar', 2014, 'GT-R', 'Gris', 1185410, 144),
( 'VH87947320', 'Automático', 2009, 'PLATINA', 'Plata', 558882, 28),
( 'VH88947321', 'Electrico/automático', 2009, 'VERSA', 'Negro', 1515478, 27),
( 'VH89947322', 'Electrico/estandar', 2016, 'DATSUN', 'Camello', 2331242, 170),
( 'VH90947323', 'Electrico', 2002, 'ALTIMA', 'Vino', 348628, 24),
( 'VH91947324', 'Estandar', 2020, 'ALTIMA', 'Blanco escarcha', 1480524, 131),
( 'VH92947325', 'Automático', 2018, 'LUCINO', 'Negro', 1637954, 115),
( 'VH93947326', 'Electrico/automático', 2001, 'GT-R', 'Rojo', 328761, 105),
( 'VH94947327', 'Electrico/estandar', 2014, 'VERSA', 'Verde', 1634885, 189),
( 'VH95947328', 'Electrico', 2002, 'ALTIMA', 'Amarillo', 2511763, 65),
( 'VH96947329', 'Estandar', 2002, 'VERSA', 'Rojo/Negro', 2130170, 96),
( 'VH97947330', 'Automático', 2007, 'SENTRA', 'Gris', 1607227, 183),
( 'VH98947331', 'Electrico/automático', 2017, 'SENTRA', 'Plata', 802379, 158),
( 'VH99947332', 'Electrico/estandar', 2014, 'DATSUN', 'Negro', 1082146, 97),
( 'VH100947333', 'Electrico', 2003, 'MICRO', 'Camello', 1724683, 141),
( 'VH101947334', 'Estandar', 2011, 'MICRO', 'Vino', 1325667, 68),
( 'VH102947335', 'Automático', 2006, 'GT-R', 'Blanco escarcha', 2808431, 192),
( 'VH103947336', 'Electrico/automático', 2013, 'VERSA', 'Negro', 1405128, 181),
( 'VH104947337', 'Electrico/estandar', 2013, 'GT-R', 'Rojo', 877245, 63),
( 'VH105947338', 'Electrico', 2012, 'TSURU', 'Verde', 2241916, 35),
( 'VH106947339', 'Estandar', 2016, 'GT-R', 'Amarillo', 1168127, 57),
( 'VH107947340', 'Automático', 2003, 'TSURU', 'Rojo/Negro', 2150294, 69),
( 'VH108947341', 'Electrico/automático', 2006, 'TIIDA', 'Gris', 2746252, 163),
( 'VH109947342', 'Electrico/estandar', 2017, 'MICRO', 'Plata', 316365, 135),
( 'VH110947343', 'Electrico', 2003, 'LUCINO', 'Negro', 2197922, 173),
( 'VH111947344', 'Estandar', 2017, 'ALTIMA', 'Camello', 1615748, 122),
( 'VH112947345', 'Automático', 2015, 'HIRAKI', 'Vino', 2231336, 42),
( 'VH113947346', 'Electrico/automático', 2007, 'GT-R', 'Blanco escarcha', 377609, 59),
( 'VH114947347', 'Electrico/estandar', 2008, 'MICRA', 'Negro', 267593, 39),
( 'VH115947348', 'Electrico', 2009, 'MICRA', 'Rojo', 899120, 128),
( 'VH116947349', 'Estandar', 2008, 'MICRA', 'Verde', 1144564, 156),
( 'VH117947350', 'Automático', 2009, 'TIIDA', 'Amarillo', 698413, 75),
( 'VH118947351', 'Electrico/automático', 2011, 'GT-R', 'Rojo/Negro', 1284025, 147),
( 'VH119947352', 'Electrico/estandar', 2015, 'DATSUN', 'Gris', 265611, 135),
( 'VH120947353', 'Electrico', 2012, 'MICRO', 'Plata', 1487652, 76),
( 'VH121947354', 'Estandar', 2014, 'MICRA', 'Negro', 830447, 12),
( 'VH122947355', 'Automático', 2009, 'TSURU', 'Camello', 1930230, 175),
( 'VH123947356', 'Electrico/automático', 2005, 'PLATINA', 'Vino', 1411527, 130),
( 'VH124947357', 'Electrico/estandar', 2017, 'TIIDA', 'Blanco escarcha', 2308658, 145),
( 'VH125947358', 'Electrico', 2010, 'SENTRA', 'Negro', 946224, 4),
( 'VH126947359', 'Estandar', 2013, 'TIIDA', 'Rojo', 883061, 164),
( 'VH127947360', 'Automático', 2016, 'PLATINA', 'Verde', 1021725, 56),
( 'VH128947361', 'Electrico/automático', 2012, 'MICRA', 'Amarillo', 1111573, 0),
( 'VH129947362', 'Electrico/estandar', 2019, 'GT-R', 'Rojo/Negro', 836677, 64),
( 'VH130947363', 'Electrico', 2014, 'GT-R', 'Gris', 1333051, 184),
( 'VH131947364', 'Estandar', 2018, 'MAXIMA', 'Plata', 919431, 97),
( 'VH132947365', 'Automático', 2016, 'SENTRA', 'Negro', 1492266, 129),
( 'VH133947366', 'Electrico/automático', 2008, 'NOTE', 'Camello', 1812810, 84),
( 'VH134947367', 'Electrico/estandar', 2001, 'TSURU', 'Vino', 1229806, 74),
( 'VH135947368', 'Electrico', 2016, 'VERSA', 'Blanco escarcha', 2006841, 34),
( 'VH136947369', 'Estandar', 2017, 'NOTE', 'Negro', 1374190, 52),
( 'VH137947370', 'Automático', 2003, 'TSURU', 'Rojo', 1459870, 46),
( 'VH138947371', 'Electrico/automático', 2015, 'GT-R', 'Verde', 1976404, 89),
( 'VH139947372', 'Electrico/estandar', 2000, 'DATSUN', 'Amarillo', 294961, 92),
( 'VH140947373', 'Electrico', 2000, 'GT-R', 'Rojo/Negro', 1317326, 194),
( 'VH141947374', 'Estandar', 2005, 'NOTE', 'Gris', 2692466, 136),
( 'VH142947375', 'Automático', 2013, 'VERSA', 'Plata', 2596227, 107),
( 'VH143947376', 'Electrico/automático', 2004, 'APRIO', 'Negro', 1221123, 183),
( 'VH144947377', 'Electrico/estandar', 2019, 'ALTIMA', 'Camello', 273769, 122),
( 'VH145947378', 'Electrico', 2000, 'LUCINO', 'Vino', 459075, 46),
( 'VH146947379', 'Estandar', 2012, 'VERSA', 'Blanco escarcha', 295669, 150),
( 'VH147947380', 'Automático', 2013, 'NOTE', 'Negro', 1952596, 73),
( 'VH148947381', 'Electrico/automático', 2008, 'MICRA', 'Rojo', 2863415, 131),
( 'VH149947382', 'Electrico/estandar', 2002, 'DATSUN', 'Verde', 2544390, 56)
GO




