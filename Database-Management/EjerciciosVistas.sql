--Adrián Perera Hernández - 1DawC
--EjerciciosVistas.sql

--Cargamos la base de datos paro con el script de creación de base de datos Paro.sql suministrado por el profesor.

use Paro;
go

set dateformat dmy;
go

--Join de todas las tablas

select *
from paromes as pm
inner join municipios as m 
	on pm.codmunicipio=m.codmunicipio
inner join MunicipiosIslas as mi
	on m.CodMunicipio=mi.CodMunicipio
inner join Islas as i
	on mi.CISLA=i.CISLA
inner join provincias as p 
	on p.codprovincia=m.codprovincia
inner join comunidadesautonomas as c 
	on p.codca=c.codca
inner join padron as pd 
	on pd.codmunicipio=m.codmunicipio;
go

--1. Probar una consulta que nos muestre el total de parados por provincia para el mes de enero. Sacará también el nombre de la Comunidad autónoma.

select sum(pm.TotalParoRegistrado) as TotalParados, p.Provincia, c.CA, datename(month, pm.Fecha) as Mes
from paromes as pm
inner join municipios as m 
	on pm.codmunicipio=m.codmunicipio
inner join provincias as p 
	on p.codprovincia=m.codprovincia
inner join comunidadesautonomas as c 
	on p.codca=c.codca
where datename(month, pm.Fecha) = 'enero'
group by p.Provincia, c.CA, pm.Fecha;
go

--2. Crear una vista basada en esa consulta. (ver_paro_provincia)

create view ver_paro_provincia
as
select sum(pm.TotalParoRegistrado) as TotalParados, p.Provincia, c.CA, datename(month, pm.Fecha) as Mes
from paromes as pm
inner join municipios as m 
	on pm.codmunicipio=m.codmunicipio
inner join provincias as p 
	on p.codprovincia=m.codprovincia
inner join comunidadesautonomas as c 
	on p.codca=c.codca
where datename(month, pm.Fecha) = 'enero'
group by p.Provincia, c.CA, pm.Fecha;
go

--3. Usar la vista sacando todos sus datos.

select *
from ver_paro_provincia;
go
--Como es lógico, muestra exactamente los mismos datos que el select del apartado 1.

--4. Usar la vista para sacar la suma de parados por Comunidad Autónoma.

select sum(TotalParados) as ParoCA, CA
from ver_paro_provincia
group by CA;
go 

--5. Crear una vista sobre la tabla ComunidadesAutonomas

create view vista_CA
as
select *
from ComunidadesAutonomas;
go

--6. Ver los datos que contiene

select *
from vista_CA;
go

--7. Borrar la vista anterior comprobando que existe

if OBJECT_ID('vista_CA', 'V') IS NOT NULL
	drop view vista_CA;
go

--8. Mostrar la estructura de la vista ver_paro_provincia

exec sp_helptext ver_paro_provincia;
go

--9. Crear de nuevo la vista pero encriptada

create view vista_CA
with encryption	--Añadimos la cláusula para encriptar la vista
as
select *
from ComunidadesAutonomas;
go

--Comprobamos que podemos ver los datos de la nueva vista encriptada
select *
from vista_CA;
go

--10. Comprobar que no se puede ver su estructura

exec sp_helptext vista_CA;
go


--11. Actualizar el nombre de una Comunidad Autónoma a través de la vista
--Buscamos el nombre de la Comunidad Autonoma que queremos actualizar:
select CA
from vista_CA
where CA like 'C%'
group by CA;
go

update vista_CA
set CA='Canarias la mejor'	--Actualización del registro
where CA='Canarias';
go

--Comprobación
select CA
from vista_CA
where CA like 'C%'
group by CA;
go

--12. Intentar una inserción

insert into vista_CA
values (70,'República Independiente de mi Choso');
go
--La incersión se ha realizado correctamente: (1 row affected).
--Comprobación
select CA
from vista_CA
where CA like 'R%'
group by CA;
go

--13. Crear una vista que acceda a las Comunidades autónomas solamente

create view vista_CAsolo
as
select CA
from ComunidadesAutonomas;
go

--14. Hacer una inserción correcta sobre esa vista


--15. Borrar el registro creado anteriormente, usando también la vista


--16. Crear una vista que muestre sólo las Comunidades autónomas que comiencen con C y con la opción with check option


--17. Probar inserciones y modificaciones que validen el funcionamiento de la opción aplicada


--18. Modificar la vista anterior filtrando a comunidades autónomas que comiencen por A
