Select
cast(a.[SalesOrderID] as varchar(100)) +';'+
convert(varchar,a.[OrderDate],102) +';'+
cast(b.[AccountNumber] as varchar(100)) +';'+
cast(d.FirstName + ' ' + d.LastName as varchar(100))+';'+
cast(e.EmailAddress as varchar(100)) +';'+
cast(c.[Name] as varchar(100)) +';'+
cast(c.[CountryRegionCode] as varchar(100)) +';'+
cast(c.[Group] as varchar(100)) +';'+
Isnull(f.[LoginID], 'Sistema') +';'+
Isnull(g.FirstName + ' ' + g.LastName, 'Sistema') +';'+
-- os dados a seguir são inventados para criar a nossa masssa de testes do Chefe do Vendedor:
case
	when g.FirstName + ' ' + g.LastName = 'Rachel Valdez' then '' -- Elaé a Chefe!
	when g.FirstName + ' ' + g.LastName in ('Amy Alberts','Garrett Vargas') then 'Rachel Valdez' -- Eles são o Segundo nivel.
	when g.FirstName + ' ' + g.LastName in ('David Campbell', 'Jae Pak', 'Jillian Carson') then 'Amy Alberts' -- Esses são funcionarios da Amy.
	when g.FirstName + ' ' + g.LastName in ('José Saraiva', 'Linda Mitchell', 'Lynn Tsoflias', 'Michael Blythe') then 'Garrett Vargas' -- Esses são funcionarios do Garrett.
	when g.FirstName + ' ' + g.LastName in ('Pamela Ansman-Wolfe', 'Ranjit Varkey Chudukatil') then 'Jillian Carson' -- Esses são funcionarios da Jillian.
	when g.FirstName + ' ' + g.LastName in ('Shu Ito', 'Stephen Jiang', 'Syed Abbas') then 'Michael Blythe' -- Esses são funcionarios do Michael.
	when g.FirstName + ' ' + g.LastName in ('Tete Mensa-Annan', 'Tsvi Reiter') then 'Stephen Jiang' -- Esses são funcionarios do Stephen.
	Else 'Sistema' -- O Sistema (venda on-line, por exemplo) terá ele mesmo como chefe!
	End +';'+
--	
isnull(i.ProductNumber,'00000') +';'+
isnull(i.Name,'-') +';'+
isnull(i.[Size],'-') +';'+
isnull(i.[ProductLine],'-') +';'+
isnull(i.[Color],'-') +';'+
cast(a.[SubTotal] as varchar(100)) +';'+
cast(a.[TaxAmt] as varchar(100)) +';'+
cast(a.[Freight] as varchar(100)) +';'+
cast(h.UnitPrice as varchar(100)) +';'+
cast(h.OrderQty as varchar(100)) as Texto
from [Sales].[SalesOrderHeader] as a inner join [Sales].[Customer]
as b
on a.CustomerID = b.CustomerID
inner join [Sales].[SalesTerritory] as c
on a.TerritoryID = c.TerritoryID
inner join [Person].[Person] as d
on b.PersonID = d.BusinessEntityID
inner join [Person].[EmailAddress]as e
on d.BusinessEntityID = e.BusinessEntityID
left join [HumanResources].[Employee] as f
on a.SalesPersonID = f.BusinessEntityID
left join [Person].[Person] as g
on f.BusinessEntityID = g.BusinessEntityID
inner join [Sales].[SalesOrderDetail] as h
on a.SalesOrderID = h.SalesOrderID
inner join [Production].[Product] as i
on h.ProductID = i.ProductID
where year([OrderDate]) = 2005