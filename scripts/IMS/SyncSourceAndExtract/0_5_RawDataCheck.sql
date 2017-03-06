USE BMSChinaCIARawdata
GO








--todo : 201304 (current month)
--todo : 201303 (last month)







--new Pack_Code
select a.Pack_Code,b.Product_Name + ' ' + a.Pack_Description as Pack_Name
from Dim_Pack_201304 a left join Dim_Product_201304 b on a.Product_ID = b.Product_ID
where not exists (select * from Dim_Pack_201303 c where a.Pack_Code = c.Pack_Code)
go

--removed Pack_Code
select a.Pack_Code,b.Product_Name + ' ' + a.Pack_Description as Pack_Name
from Dim_Pack_201303 a left join Dim_Product_201303 b on a.Product_ID = b.Product_ID
where not exists (select * from Dim_Pack_201304 c where a.Pack_Code = c.Pack_Code)
go


--Units Data change
if object_id(N'tempFackSalesCW', N'U') is not null
	drop table tempFackSalesCW
go
if object_id(N'tempFackSalesPW', N'U') is not null
	drop table tempFackSalesPW
go

select a.[Year], a.[Month], 
a.Pack_ID, b.Pack_Code, a.City_ID, c.City_Code,
a.Quantity_DT, a.Quantity_ST, a.Quantity_UN, a.Amount_IC, a.Amount_US
into tempFackSalesCW from Dim_Fact_Sales_201304 a
left join Dim_Pack_201304 b on a.Pack_ID = b.Pack_ID
left join Dim_City_201304 c on a.City_ID = c.City_ID
go

select a.[Year], a.[Month], 
a.Pack_ID, b.Pack_Code, a.City_ID, c.City_Code,
a.Quantity_DT, a.Quantity_ST, a.Quantity_UN, a.Amount_IC, a.Amount_US
into tempFackSalesPW from Dim_Fact_Sales_201303 a
left join Dim_Pack_201303 b on a.Pack_ID = b.Pack_ID
left join Dim_City_201303 c on a.City_ID = c.City_ID
go

select a.[Year],a.[Month],a.Pack_Code,a.City_Code,
a.Quantity_DT, a.Quantity_ST, a.Quantity_UN, a.Amount_IC, a.Amount_US,
b.Quantity_DT, b.Quantity_ST, b.Quantity_UN, b.Amount_IC, b.Amount_US
from tempFackSalesCW a inner join tempFackSalesPW b
on a.[Year] = b.[Year] and a.[Month] = b.[Month] and 
a.Pack_Code = b.Pack_Code and a.City_Code = b.City_Code and abs(a.Quantity_UN - b.Quantity_UN) > 1
order by a.[Year], a.[Month], a.Pack_Code, a.City_Code
go