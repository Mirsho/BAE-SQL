--Adri�n Perera Hern�ndez - 1DawC
--Presentaci�n SubconsultasNuevo.pdf

--P�gina 25 en adelante

use Mundo;
go

set dateformat dmy;
go

--Subconsulta como Tabla
--N� de ciudades y n� de idiomas de un pa�s.

select Name, Nleng as Idiomas, Ncity as Ciudades
from Country as c
inner join (select countrycode, count (*) as Nleng
			from CountryLanguage
			group by CountryCode
			) as nl
	on nl.CountryCode=c.Code
inner join (select CountryCode, count(*) as Ncity
			from City
			group by CountryCode
			) as nc
	on nc.CountryCode=c.Code;
go

--Subconsulta con campos.
--Pa�s con m�s habitantes y ciudad con m�s habitantes.

select top 1 Name as paismas,
		(select top 1 name
		from City
		order by Population desc) as ciudadmas
from Country
order by Population desc;
go

--Subconsulta como valor en el Where
--Pa�ses con poblaci�n m�s alta que el 50% de la mayor.
--	*Para esto es lo t�pico para lo que se usan las subconsultas.

select Name
from Country
where Population >
	((select MAX(population) from Country) * 0.5);
go

/*	En orden:
	1. Se realiza la consulta para saber cual es la poblaci�n m�xima.
	2. Se hace la multiplicaci�n para sacar el 50% de dicho valor.
	3. Se hacen las consultas por cada pa�s comparando la poblaci�n con el 50% del m�ximo.
			*Si el sistema gestor de BD hace una compilaci�n previa, no repetir� la operaci�n del 50%
			 sino que conserva el valor ya que determina que en la consulta no hay nada que lo pueda modificar.
*/

--Subconsulta en el where mediante el exists y usando campos enlazados.
--Pa�ses con idioma con m�s del 70% de la poblaci�n.

select Name
from Country as c
where exists (select Language
				from CountryLanguage as l
				where c.Code=l.CountryCode
					and Percentage>70);
go

--Repite la consulta para calcular los porcentages mayores al 70% por cada pa�s.

--Subconsulta en el Where mediante el in
--Pa�ses con alguno de los idiomas hablados en Jap�n (Japan)

select p1.Name
from Country as p1
inner join CountryLanguage as l1
	on l1.CountryCode=p1.Code
where l1.Language in (select Language
						from Country as p2
						inner join CountryLanguage as l2
							on l2.CountryCode=p2.Code
						where p2.Name='japan')
group by p1.Name;
go

--Subconsulta para ver los idiomas (comunes a Jap�n) que se hablan:
select p1.Name, l1.Language
from Country as p1
inner join CountryLanguage as l1
	on l1.CountryCode=p1.Code
where l1.Language in (select Language
						from Country as p2
						inner join CountryLanguage as l2
							on l2.CountryCode=p2.Code
						where p2.Name='japan')
group by p1.Name, l1.Language;
go

--Subconsultas en el where usando any/some
--Pa�s poblaci�n menor que alguna de las ciudades de Espa�a.

select name
from Country
where Population < any (select c.Population
						from city as c
						inner join Country as p
							on p.Code=c.CountryCode
						where p.Name='Spain');
go

--Subconsultas en el where mediante all
--Pa�ses con poblaci�n mayor que todos los pa�ses europeos.

select name, Population
from Country
where Population > all (select p.population
						from Country as p
						where p.Continent = 'Europe');
go

--Consulta de inter�s: Pa�s con mayor poblaci�n en europa
select top 1 Name, Population
from Country
where Continent = 'Europe'
order by Population desc;
go

--Subconsultas mediante campos enlazados
--Ciudad e idioma con m�s poblaci�n por pa�s.

select name,
	(select top 1 Language
		from CountryLanguage
		where Country.Code=CountryLanguage.CountryCode
		order by percentage desc) as IdiomaMas,
	(select top 1 Name
		from City
		where Country.Code=City.CountryCode
		order by Population desc) as CiudadMas
from Country
order by name;
go

--Consulta de prueba: quitando los null

select name,
	(select top 1 Language
		from CountryLanguage
		where (Country.Code=CountryLanguage.CountryCode) and (Language is not null)
		order by percentage desc) as IdiomaMas,
	(select top 1 Name
		from City
		where (Country.Code=City.CountryCode) and (City.Name is not null)
		order by Population desc) as CiudadMas
from Country
order by name;
go
--ATENCION: No funciona. Probar con Join.