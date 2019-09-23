--Adrián Perera Hernández - 1DawC
--EjerciciosAdministracionBasicaSQL.sql
use master;
go

set dateformat dmy;
go

--1. Crear la Base de datos en la carpeta C:\SQLDatos con tamaño inicial 5M, tamaño mayor 20 M e incrementos 4M.

create database EJER12
on
(NAME = EJER12_dat,
	FILENAME = '/SQLDatos/EJER12.mdf',
	SIZE = 5MB,
	MAXSIZE = 20MB,
	FILEGROWTH = 4MB)
log on
(NAME = EJER2_log,
	FILENAME = '/SQLDatos/EJER12_log.ldf',
	SIZE = 5MB,
	MAXSIZE = 20MB,
	FILEGROWTH = 4MB);
go

/*2. Crear una tabla con la estructura siguiente:
	create table empleados (
	DNI varchar(8),
	nombre varchar(30),
	apellidos varchar(30),
	fechanacimiento datetime,
	cantidadhijos tinyint,
	seccion varchar(20),
	sueldo decimal(6,2)
	);*/

use EJER12;
go

create table empleados (
	DNI varchar(8),
	nombre varchar(30),
	apellidos varchar(30),
	fechanacimiento datetime,
	cantidadhijos tinyint,
	seccion varchar(20),
	sueldo decimal(6,2)
	);
go

exec sp_helpconstraint empleados; --Comprobamos los constraints generados en la creación de la tabla.
go

--3. Crear las sentencias para que valide lo siguiente:
	--a. clave primaria DNI
	--b. no nulo apellidos
	--c. no nulo nombre
	--d. valor único apellidos y nombre
	--e. validar que fechanacimiento sea menor que la fecha actual
	--f. validar que cantidad de hijos no sea negativa ni mayor que 20
	--g. validar que sección no esté vacío

--a.
alter table empleados
ALTER COLUMN DNI varchar(8) NOT NULL;
go

alter table empleados
add constraint pk_empleados
primary key (DNI)

--b.
alter table empleados
ALTER COLUMN apellidos varchar(30) NOT NULL;
go

--c.
alter table empleados
ALTER COLUMN nombre varchar(8) NOT NULL;
go

--d.
alter table empleados
add constraint uq_apellidosnombre
unique (apellidos, nombre)

--e.
alter table empleados
add constraint ck_fechanacimiento
check (fechanacimiento < getdate())

--f.
alter table empleados
add constraint ck_cantidadhijos
check (cantidadhijos >= 0 and cantidadhijos <= 20)

--g.

alter table empleados
drop column seccion;	--Para añadir la constraint defaul, primero tenemos que eliminar el campo
go

alter table empleados
add seccion varchar(20) NOT NULL default 'No asignada';	--y lo volvemos a crear con las restricciones NOT NULL y default
go

exec sp_helpconstraint empleados; --Comprobamos los constraints generados en la creación de la tabla.
go

--4. Ver los índices que tiene.

exec sp_helpindex empleados;
go

--5. Añadir índice por fecha de nacimiento

create nonclustered index ix_fechanacimiento
on empleados(fechanacimiento);
go

--6. Añadir índice por sueldo

create nonclustered index ix_sueldo
on empleados(sueldo);
go

--7. Modificar lo siguiente en la tabla
	--a. Añadir campo dirección varchar(100)
alter table empleados
add direccion varchar(100);
go

	--b. Cambiar a no nulo seccion
alter table empleados
ALTER COLUMN direccion varchar(100) not null;
go

	--c. Validar que sueldo sean >0 y <10000
alter table empleados
add constraint ck_sueldo
check (sueldo >= 0 and sueldo <= 10000)

--comprobaciones finales de las características de la tabla:
exec sp_helpconstraint empleados;
go

exec sp_helpindex empleados;
go