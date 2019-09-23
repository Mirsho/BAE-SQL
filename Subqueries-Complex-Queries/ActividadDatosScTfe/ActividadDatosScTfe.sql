--Adrián Perera Hernández - 1DawC
--ActividadDatosScTfe.pdf

use DatosSCTFE;
go

set dateformat dmy;
go

--1.- Total del Valor de padrón por barrio ordenado por dicho total de mayor a menor:

select BARRIO, sum(Valor) as TotalPadron
from DatosPadron as p
inner join Barrio as b
	on p.COD_BARRIO=b.COD_BARRIO
group by Barrio
order by TotalPadron desc;
go

--2.- Número de paradas de taxis por barrio, sacando también barrios sin parada y paradas sin barrio, para los que tienen menos de tres paradas:

select b.BARRIO, count(pt.CODIGO) as Paradas
from Paradas_taxi as pt
full join Barrio as b
	on pt.COD_BARRIO=b.COD_BARRIO							--REVISAR
group by b.BARRIO
having count(*) < 3
order by Paradas desc;
go

--5.- Suma de la LONG_SIG (longitud) de las paradas de taxis de los distritos que  comiencen con S:

select sum(LONG_SIG) as 'Longitud Total'
from Paradas_taxi as pt
left join Barrio as b
	on pt.COD_BARRIO=b.COD_BARRIO
left join Distrito as d
	on b.Cod_Distrito=d.CodDistrito
where DISTRITO like 'S%';
go

--8.-  Número de Barrios sin paradas:

select count(*) as 'Total Barrios sin parada'		--En este caso, como estamos buscando los valores null, no se pueden repetir los barrios,
from Barrio as b									--así que consultamos con un count(*)
left join Paradas_taxi as pt
	on b.COD_BARRIO=pt.COD_BARRIO
where pt.CODIGO is null
go

--(*) 10.- Total de padrón de barrios con más de 3 paradas de taxi:

select b.BARRIO, sum(Valor) as TotalPadron
from DatosPadron as dt
left join Barrio as b
	on dt.COD_BARRIO=b.COD_BARRIO
inner join (select count(pt.CODIGO) as Paradas, pt.COD_BARRIO
			from Paradas_taxi as pt
			group by pt.COD_BARRIO
			having count(*) > 3) as bt3
				on b.COD_BARRIO=bt3.COD_BARRIO
group by b.BARRIO;
go
--CORRECCIÓN: Tenía que mostrar la suma total de los 3 barrios que tienen más de tres paradas.
select sum(Valor) as 'Padron>3Paradas'
from DatosPadron as dp
inner join Barrio as b
	on b.COD_BARRIO=dp.COD_BARRIO
where b.COD_BARRIO in
		(select COD_BARRIO
		from Paradas_taxi
		group by COD_BARRIO
		having count(*) > 3);

--CONSULTA DE COMPROBACIÓN - Barrios con más de 3 paradas:
select b2.BARRIO, count(pt.CODIGO) as Paradas
from Paradas_taxi as pt
full join Barrio as b2
	on pt.COD_BARRIO=b2.COD_BARRIO
group by b2.BARRIO
having count(*) > 3
go

--Consulta adicional - Mostrar el número de paradas de los barrios.
select b.BARRIO, sum(Valor) as TotalPadron, bt3.Paradas
from DatosPadron as dt
left join Barrio as b
	on dt.COD_BARRIO=b.COD_BARRIO
inner join (select count(pt.CODIGO) as Paradas, pt.COD_BARRIO
			from Paradas_taxi as pt
			group by pt.COD_BARRIO
			having count(*) > 3) as bt3
				on b.COD_BARRIO=bt3.COD_BARRIO
group by b.BARRIO, bt3.Paradas;
go

--(*)11.- Para grupoedad que contenga 99 dar el total de padrón por barrio. Sacando todos los barrios:

--REVISAR
select b.BARRIO, sum(Valor) as TotalPadron
from Barrio as b
left join DatosPadron as dp
	on b.COD_BARRIO=dp.COD_BARRIO
left join (select Clave
			from GrupoEdad
			where clave like '%99%') as ge99	--En el where no funciona nunca en este tipo de consultas.
				on dp.ClaveGrupo=ge99.Clave
group by b.BARRIO;
go

--Correccion en base a mi ejercicio
select barrio, sum(valor) as TotalPadron
from DatosPadron as dp
inner join (select Clave
			from GrupoEdad
			where clave like '%99%') as ge99
				on dp.ClaveGrupo=ge99.Clave
right join barrio as b
on b.COD_BARRIO=dp.COD_BARRIO
group by barrio;

--Corrección óptima
select barrio, sum(valor) as TotalPadron
from DatosPadron as dp
inner join (select Clave
			from GrupoEdad
			where 99 between EdadInicial and EdadFinal) as ge99 --Mejor con el uso del between
				on dp.ClaveGrupo=ge99.Clave
right join barrio as b
on b.COD_BARRIO=dp.COD_BARRIO
group by barrio;


--15.- Total del valor de padrón por edadinicial y edadfinal, para los de suma mayor de 12000:

--REVISAR
select dp.COD_BARRIO, count(ge.EdadInicial), count(ge.EdadFinal)
from DatosPadron as dp
inner join GrupoEdad as ge
	on dp.ClaveGrupo=ge.Clave
where dp.Valor > 1200
group by dp.COD_BARRIO, ge.EdadInicial, ge.EdadFinal
go

select dp.COD_BARRIO, dp.valor as Padron
from DatosPadron as dp
left join GrupoEdad as ge
	on dp.ClaveGrupo=ge.Clave
where dp.Valor > 1200
group by dp.COD_BARRIO, dp.Valor, ge.EdadInicial, ge.EdadFinal
go
--Las dos consultas están mal.

--Corrección:
select EdadInicial, EdadFinal, sum(valor) as Padron
from GrupoEdad as g
inner join DatosPadron as dp
	on g.Clave=dp.ClaveGrupo
group by EdadInicial, EdadFinal
having sum(valor) > 12000
order by EdadInicial asc;
go


--18.- Grupo de edad (dando edadinicial y sexo) con mayor valor de padrón para distritos CENTRO - IFARA, OFRA - COSTA SUR y SALUD - LA SALLE:

select top 1 dp.Valor, ge.Clave, ge.EdadInicial, ge.Sexo
from GrupoEdad as ge
left join DatosPadron as dp
	on ge.Clave=dp.ClaveGrupo
left join Barrio as b
	on dp.COD_BARRIO=b.COD_BARRIO
left join Distrito as d
	on b.Cod_Distrito=d.CodDistrito
where d.DISTRITO in ('CENTRO - IFARA', 'OFRA - COSTA SUR', 'SALUD - LA SALLE')
order by valor desc;
go

--PRIMERA CONSULTA REALIZADA:
select top 1 dp.Valor, ge.Clave, ge.EdadInicial, ge.Sexo
from GrupoEdad as ge
left join DatosPadron as dp
	on ge.Clave=dp.ClaveGrupo
left join Barrio as b
	on dp.COD_BARRIO=b.COD_BARRIO
left join Distrito as d
	on b.Cod_Distrito=d.CodDistrito
where (d.DISTRITO = 'CENTRO - IFARA') or (d.DISTRITO = 'OFRA - COSTA SUR') or (d.DISTRITO = 'SALUD - LA SALLE')
order by valor desc;
go

--CORRECCIÓN:
select top 1 ge.EdadInicial, ge.Sexo, sum(dp.Valor) as Padron --Sobraba la clave y faltaba sum(dp.Valor) as Padron
from GrupoEdad as ge
left join DatosPadron as dp
	on ge.Clave=dp.ClaveGrupo
left join Barrio as b
	on dp.COD_BARRIO=b.COD_BARRIO
left join Distrito as d
	on b.Cod_Distrito=d.CodDistrito
where d.DISTRITO in ('CENTRO - IFARA', 'OFRA - COSTA SUR', 'SALUD - LA SALLE')
group by EdadInicial, Sexo	--Faltaba agrupación.
order by Padron desc; --Ponemos Padron en el order by, siendo el alias de sum(dp.Valor).
go

--(*) 19.- Suma de padrón y suma de longitud de paradas de taxi (LONG_SIG) por distrito:



--20.- Tres grupos de edad dando edadinicial y sexo con mayor suma de valor de padrón:

--(*) 23.- Para barrios que contengan villa dar la suma del valor de padrón de sus distritos, ordenados por la suma de valor de padrón de mayor a menor:

--24.- Barrio con mayor número de mujeres:

--29.- Barrios que contengan una R y tengan alguna parada comenzando en miércoles:

--(*) 31.- Grupos (edadinicial y sexo) sin padrón en Barrio AFUR:

--33.- Total de valor de padrón por barrio para los que la suma sea mayor que 10000: