--Adrián Perera Hernández - 1DawC
--01ImportacionJSON.sql
use master;
go

create database PruebasJson;
go

use PruebasJson;
go

set dateformat dmy;
go

Declare @JSON varchar(max)

SELECT @JSON = BulkColumn
FROM OPENROWSET (BULK '/datos/ts5.json'
	, SINGLE_CLOB) as j

select * into TarjetaSanitaria FROM OPENJSON (@JSON)
with (FECCARGA nvarchar(100), SEXO char(1),
	CCAANACI varchar(100), PAISNACI varchar(100),
	CODZONAC varchar(100), EXTRANJERO char(1),
	TRAMO varchar(10), CANTIDAD float)
	as TarjetaSanitaria
go

select top 100 *
from TarjetaSanitaria;
go

use PruebasJson;
go

set dateformat dmy;
go

create table ImagenesImportadas
(id int identity primary key,
	nombre varchar(100),
	tipo varchar(50),
	imagen varbinary(max));

insert into ImagenesImportadas
	(nombre,tipo,imagen)
	select 'Kecleon','Normal',
		BulkColumn from
openrowset(
bulk '/datos/250px-Madison_Reddy.png', single_blob) as blob;
go

insert into ImagenesImportadas
	(nombre,tipo,imagen)
	select 'Mega Alakazam','Psiquico-MataKecleons',
		BulkColumn from
openrowset(
bulk '/datos/Ala_grande.png', single_blob) as blob;
go

select nombre, tipo, imagen from ImagenesImportadas;
go
