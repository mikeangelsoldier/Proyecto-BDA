

DROP SCHEMA IF EXISTS IngenieriaSoftware;
CREATE DATABASE IngenieriaSoftware;
USE IngenieriaSoftware;




USE IngenieriaSoftware;

/******************CREACIÓN DE TABLAS**************************/

CREATE TABLE Profesor(
	NumControl VARCHAR(10) NOT NULL,
	CURP VARCHAR(18) NOT NULL,
	Nombre VARCHAR(60) NULL,
	PrimerApellido VARCHAR(30) NULL,
	SegundoApellido VARCHAR(30) NULL,
	sexo VARCHAR(1),
	Telefono VARCHAR(10),
    correo VARCHAR(30),
	FechaNacimiento date NULL,/*******Decia Nacimeinto************/
	login VARCHAR(30),
    passw VARCHAR(30),
	usuarioALta VARCHAR(10),
	fechaAlta date,
	usuarioMod VARCHAR(10),
	fechaMod date
) ; 




/****** Object:  Table dbo.Alumno    Script Date: 02/22/2018 12:12:26 ******/

CREATE TABLE Alumno(
	NumControl VARCHAR(10) NOT NULL,
	CURP VARCHAR(18) NOT NULL,
	Nombre VARCHAR(60) NOT NULL,
	PrimerApellido VARCHAR(50) NULL,
	SegundoApellido VARCHAR(50) NULL,
	sexo VARCHAR(1) NULL,
	fechaNacimiento date NULL,
    Domicilio VARCHAR(50),
    Telefono VARCHAR(10),
    correo VARCHAR(30),
    semestreAlumno CHAR(1),
    login VARCHAR(30),
    passw VARCHAR(30),
	usuarioAlta VARCHAR(10),
	fechaAlta date,
	usuarioMod VARCHAR(10),
	fechaMod date
) ENGINE=InnoDB CHARSET=latin1;


/****** Object:  Table dbo.Administrador    Script Date: 02/22/2018 12:12:26 ******/

CREATE TABLE Administrador(
	NumControl VARCHAR(10) NOT NULL,
	Nombre VARCHAR(60) NULL,
	PrimerApellido VARCHAR(50) NULL,
	SegundoApellido VARCHAR(50) NULL,
    sexo VARCHAR(1) NULL,
	Cargo VARCHAR(80) NULL,
	Telefono VARCHAR(10),
    correo VARCHAR(30),
    login VARCHAR(30),
    passw VARCHAR(30),
	usuarioALta VARCHAR(10),
	fechaAlta date,
	usuarioMod VARCHAR(10),
	fechaMod date
) ;




/*Proc Administrador--------------------------------------------------------------------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS getAdministradores;
CREATE PROCEDURE getAdministradores ()
	SELECT * FROM Administrador;

DROP PROCEDURE IF EXISTS addAdministrador;
CREATE PROCEDURE addAdministrador(
numControl VARCHAR(10), 
nombre VARCHAR(60), 
primerApellido VARCHAR(50), 
segundoApellido VARCHAR(50), 
sexo VARCHAR(1), 
cargo VARCHAR(80), 
telefono VARCHAR(10),
correo VARCHAR(30),
login VARCHAR(30),
passw VARCHAR(30),
usuarioMod VARCHAR(10))
INSERT INTO Administrador VALUES(numControl, nombre, primerApellido, segundoApellido, sexo, 
            cargo, telefono, correo, login, passw, usuarioMod, curdate(), usuarioMod, curdate());



DROP PROCEDURE IF EXISTS updateAdministrador;
CREATE PROCEDURE updateAdministrador(
actualID VARCHAR(10), 
nombre VARCHAR(60), 
primerApellido VARCHAR(50), 
segundoApellido VARCHAR(50), 
sexo VARCHAR(1), 
cargo VARCHAR(80), 
telefono VARCHAR(10),
correo VARCHAR(30),
login VARCHAR(30),
passw VARCHAR(30),
usuarioMod VARCHAR(10))
UPDATE Administrador SET Administrador.nombre = nombre, Administrador.primerApellido = primerApellido, Administrador.segundoApellido = segundoApellido, 
Administrador.sexo = sexo, Administrador.cargo = cargo, Administrador.telefono = telefono, Administrador.correo = correo, 
Administrador.login = login, Administrador.passw = passw, Administrador.usuarioMod = usuarioMod, 
Administrador.fechaMod = curdate() WHERE Administrador.NumControl = actualID;


/*Proc Alumno--------------------------------------------------------------------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS getALumnos;
CREATE PROCEDURE getAlumnos ()
	SELECT * FROM Alumno;

DROP PROCEDURE IF EXISTS addAlumno;
CREATE PROCEDURE addAlumno(
ID VARCHAR(10), 
curp VARCHAR(18), 
nombre VARCHAR(60), 
apellidoP VARCHAR(50), 
apellidoM VARCHAR(50), 
sexo VARCHAR(1), 
fechaNac date,
domicilio VARCHAR(50),
telefono VARCHAR(10),
correo VARCHAR(30),
semestreAlumno CHAR(1),
user VARCHAR(30),
password VARCHAR(30),
usuarioMod VARCHAR(10))
INSERT INTO Alumno VALUES(ID, curp, nombre, apellidoP, apellidoM, sexo, fechaNac, domicilio, telefono, correo, semestreAlumno, user, password, usuarioMod, curdate(), usuarioMod, curdate());


DROP PROCEDURE IF EXISTS updateAlumno;
CREATE PROCEDURE updateAlumno(
actualID VARCHAR(10), 
curp VARCHAR(18), 
nombre VARCHAR(60), 
apellidoP VARCHAR(50), 
apellidoM VARCHAR(50), 
sexo VARCHAR(1), 
fechaNac date,
domicilio VARCHAR(50),
telefono VARCHAR(10),
correo VARCHAR(30),
semestreAlumno CHAR(1),
user VARCHAR(30),
password VARCHAR(30),
usuarioMod VARCHAR(10))
UPDATE Alumno SET Alumno.curp = curp, Alumno.Nombre = nombre, Alumno.PrimerApellido = apellidoP, 
Alumno.SegundoAPellido = apellidoM, Alumno.sexo = sexo, Alumno.fechaNacimiento = fechaNac, Alumno.domicilio = domicilio, 
Alumno.Telefono = telefono, Alumno.Correo = correo, Alumno.semestreAlumno = semestreAlumno, Alumno.login = user, Alumno.passw = password, Alumno.usuarioMod = usuarioMod, 
Alumno.fechaMod = curdate() WHERE Alumno.NumControl = actualID;




/*PROC Profesor--------------------------------------------------------------------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS getProfesor;
CREATE PROCEDURE getProfesor ()
	SELECT * FROM Profesor;



DROP PROCEDURE IF EXISTS addProfesor;
CREATE PROCEDURE addProfesor(
ID VARCHAR(10), 
curp VARCHAR(18), 
nombre VARCHAR(60), 
apellidoP VARCHAR(50), 
apellidoM VARCHAR(50), 
sexo VARCHAR(1), 
telefono VARCHAR(10),
correo VARCHAR(30),
fechaNac date,
login VARCHAR(30),
passw VARCHAR(30),
usuarioMod VARCHAR(10))
INSERT INTO Profesor VALUES(ID, curp, nombre, apellidoP, apellidoM, sexo, telefono, correo, fechaNac, login,passw,usuarioMod, curdate(), usuarioMod, curdate());



DROP PROCEDURE IF EXISTS updateProfesor;
CREATE PROCEDURE updateProfesor(
actualID VARCHAR(10), 
curp VARCHAR(18), 
nombre VARCHAR(60), 
apellidoP VARCHAR(50), 
apellidoM VARCHAR(50), 
sexo VARCHAR(1), 
telefono VARCHAR(10),
correo VARCHAR(30),
fechaNac date,
login VARCHAR(30),
passw VARCHAR(30),
usuarioMod VARCHAR(10))
UPDATE profesor SET profesor.CURP = curp, profesor.Nombre = nombre, profesor.PrimerApellido = apellidoP, 
profesor.SegundoApellido = apellidoM, profesor.sexo = sexo, profesor.Telefono = telefono, profesor.correo = correo, 
profesor.FechaNacimiento = fechaNac, profesor.login=login, profesor.passw=passw, profesor.usuarioMod = usuarioMod, 
profesor.fechaMod = curdate() WHERE profesor.NumControl = actualID;


