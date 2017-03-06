use BMSCNProc2
go








--select top 10 * from tblOutput_Hosp_TA_Master_Inline(nolock)
truncate table [tblOutput_Hosp_TA_Master_Inline_Aric]
go
Insert into [tblOutput_Hosp_TA_Master_Inline_Aric]
select *, 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
from tblOutput_Hosp_TA_Master
where MktType='In-line Market'
go

Update [tblOutput_Hosp_TA_Master_Inline_Aric] 
Set
MTH_SHR_48 = (case t2.MTH_48 when 0 then 0 else t1.MTH_48*1.0/t2.MTH_48 end),
MTH_SHR_47 = (case t2.MTH_47 when 0 then 0 else t1.MTH_47*1.0/t2.MTH_47 end),
MTH_SHR_46 = (case t2.MTH_46 when 0 then 0 else t1.MTH_46*1.0/t2.MTH_46 end),
MTH_SHR_45 = (case t2.MTH_45 when 0 then 0 else t1.MTH_45*1.0/t2.MTH_45 end),
MTH_SHR_44 = (case t2.MTH_44 when 0 then 0 else t1.MTH_44*1.0/t2.MTH_44 end),
MTH_SHR_43 = (case t2.MTH_43 when 0 then 0 else t1.MTH_43*1.0/t2.MTH_43 end),
MTH_SHR_42 = (case t2.MTH_42 when 0 then 0 else t1.MTH_42*1.0/t2.MTH_42 end),
MTH_SHR_41 = (case t2.MTH_41 when 0 then 0 else t1.MTH_41*1.0/t2.MTH_41 end),
MTH_SHR_40 = (case t2.MTH_40 when 0 then 0 else t1.MTH_40*1.0/t2.MTH_40 end),
MTH_SHR_39 = (case t2.MTH_39 when 0 then 0 else t1.MTH_39*1.0/t2.MTH_39 end),
MTH_SHR_38 = (case t2.MTH_38 when 0 then 0 else t1.MTH_38*1.0/t2.MTH_38 end),
MTH_SHR_37 = (case t2.MTH_37 when 0 then 0 else t1.MTH_37*1.0/t2.MTH_37 end),
MTH_SHR_36 = (case t2.MTH_36 when 0 then 0 else t1.MTH_36*1.0/t2.MTH_36 end),
MTH_SHR_35 = (case t2.MTH_35 when 0 then 0 else t1.MTH_35*1.0/t2.MTH_35 end),
MTH_SHR_34 = (case t2.MTH_34 when 0 then 0 else t1.MTH_34*1.0/t2.MTH_34 end),
MTH_SHR_33 = (case t2.MTH_33 when 0 then 0 else t1.MTH_33*1.0/t2.MTH_33 end),
MTH_SHR_32 = (case t2.MTH_32 when 0 then 0 else t1.MTH_32*1.0/t2.MTH_32 end),
MTH_SHR_31 = (case t2.MTH_31 when 0 then 0 else t1.MTH_31*1.0/t2.MTH_31 end),
MTH_SHR_30 = (case t2.MTH_30 when 0 then 0 else t1.MTH_30*1.0/t2.MTH_30 end),
MTH_SHR_29 = (case t2.MTH_29 when 0 then 0 else t1.MTH_29*1.0/t2.MTH_29 end),
MTH_SHR_28 = (case t2.MTH_28 when 0 then 0 else t1.MTH_28*1.0/t2.MTH_28 end),
MTH_SHR_27 = (case t2.MTH_27 when 0 then 0 else t1.MTH_27*1.0/t2.MTH_27 end),
MTH_SHR_26 = (case t2.MTH_26 when 0 then 0 else t1.MTH_26*1.0/t2.MTH_26 end),
MTH_SHR_25 = (case t2.MTH_25 when 0 then 0 else t1.MTH_25*1.0/t2.MTH_25 end),
MTH_SHR_24 = (Case t2.MTH_24 When 0 Then 0 Else t1.MTH_24*1.0/t2.MTH_24 End), 
MTH_SHR_23 = (Case t2.MTH_23 When 0 Then 0 Else t1.MTH_23*1.0/t2.MTH_23 End), 
MTH_SHR_22 = (Case t2.MTH_22 When 0 Then 0 Else t1.MTH_22*1.0/t2.MTH_22 End), 
MTH_SHR_21 = (Case t2.MTH_21 When 0 Then 0 Else t1.MTH_21*1.0/t2.MTH_21 End), 
MTH_SHR_20 = (Case t2.MTH_20 When 0 Then 0 Else t1.MTH_20*1.0/t2.MTH_20 End), 
MTH_SHR_19 = (Case t2.MTH_19 When 0 Then 0 Else t1.MTH_19*1.0/t2.MTH_19 End), 
MTH_SHR_18 = (Case t2.MTH_18 When 0 Then 0 Else t1.MTH_18*1.0/t2.MTH_18 End), 
MTH_SHR_17 = (Case t2.MTH_17 When 0 Then 0 Else t1.MTH_17*1.0/t2.MTH_17 End), 
MTH_SHR_16 = (Case t2.MTH_16 When 0 Then 0 Else t1.MTH_16*1.0/t2.MTH_16 End), 
MTH_SHR_15 = (Case t2.MTH_15 When 0 Then 0 Else t1.MTH_15*1.0/t2.MTH_15 End), 
MTH_SHR_14 = (Case t2.MTH_14 When 0 Then 0 Else t1.MTH_14*1.0/t2.MTH_14 End), 
MTH_SHR_13 = (Case t2.MTH_13 When 0 Then 0 Else t1.MTH_13*1.0/t2.MTH_13 End), 
MTH_SHR_12 = (Case t2.MTH_12 When 0 Then 0 Else t1.MTH_12*1.0/t2.MTH_12 End), 
MTH_SHR_11 = (Case t2.MTH_11 When 0 Then 0 Else t1.MTH_11*1.0/t2.MTH_11 End), 
MTH_SHR_10 = (Case t2.MTH_10 When 0 Then 0 Else t1.MTH_10*1.0/t2.MTH_10 End), 
MTH_SHR_9  = (Case t2.MTH_9  When 0 Then 0 Else t1.MTH_9*1.0/t2.MTH_9   End), 
MTH_SHR_8  = (Case t2.MTH_8  When 0 Then 0 Else t1.MTH_8*1.0/t2.MTH_8   End), 
MTH_SHR_7  = (Case t2.MTH_7  When 0 Then 0 Else t1.MTH_7*1.0/t2.MTH_7   End), 
MTH_SHR_6  = (Case t2.MTH_6  When 0 Then 0 Else t1.MTH_6*1.0/t2.MTH_6   End), 
MTH_SHR_5  = (Case t2.MTH_5  When 0 Then 0 Else t1.MTH_5*1.0/t2.MTH_5   End), 
MTH_SHR_4  = (Case t2.MTH_4  When 0 Then 0 Else t1.MTH_4*1.0/t2.MTH_4   End), 
MTH_SHR_3  = (Case t2.MTH_3  When 0 Then 0 Else t1.MTH_3*1.0/t2.MTH_3   End), 
MTH_SHR_2  = (Case t2.MTH_2  When 0 Then 0 Else t1.MTH_2*1.0/t2.MTH_2   End), 
MTH_SHR_1  = (Case t2.MTH_1  When 0 Then 0 Else t1.MTH_1*1.0/t2.MTH_1   End)
from [tblOutput_Hosp_TA_Master_Inline_Aric] t1 inner join tblOutput_Hosp_TA_Master_InLine_Mkt t2
on t1.DataType=t2.DataType and t1.Mkt=t2.Mkt and t1.Geo=t2.Geo and t1.Hosp_ID=t2.Hosp_ID and t1.Tier=t2.Tier
go

















--1.
truncate table tblOutput_Hosp_TA_RMB_MTH_Inline
go
Insert into tblOutput_Hosp_TA_RMB_MTH_Inline
select * from [tblOutput_Hosp_TA_Master_Inline_Aric] where DataType='MTHRMB'
go
--2.
truncate table tblOutput_Hosp_TA_RMB_MQT_Inline
go
Insert into tblOutput_Hosp_TA_RMB_MQT_Inline
select * from [tblOutput_Hosp_TA_Master_Inline_Aric] where DataType='MQTRMB'
go
--3.
truncate table tblOutput_Hosp_TA_RMB_MAT_Inline
go
Insert into tblOutput_Hosp_TA_RMB_MAT_Inline
select * from [tblOutput_Hosp_TA_Master_Inline_Aric] where DataType='MATRMB'
go



--4.
truncate table tblOutput_Hosp_TA_USD_MTH_Inline
go
Insert into tblOutput_Hosp_TA_USD_MTH_Inline
select * from [tblOutput_Hosp_TA_Master_Inline_Aric] where DataType='MTHUSD'
go
--5.
truncate table tblOutput_Hosp_TA_USD_MQT_Inline
go
Insert into tblOutput_Hosp_TA_USD_MQT_Inline
select * from [tblOutput_Hosp_TA_Master_Inline_Aric] where DataType='MQTUSD'
go
--6.
truncate table tblOutput_Hosp_TA_USD_MAT_Inline
go
Insert into tblOutput_Hosp_TA_USD_MAT_Inline
select * from [tblOutput_Hosp_TA_Master_Inline_Aric] where DataType='MATUSD'
go


--7.
truncate table tblOutput_Hosp_TA_UNT_MTH_Inline
go
Insert into tblOutput_Hosp_TA_UNT_MTH_Inline
select * from [tblOutput_Hosp_TA_Master_Inline_Aric] where DataType='MTHUNT'
go
--8.
truncate table tblOutput_Hosp_TA_UNT_MQT_Inline
go
Insert into tblOutput_Hosp_TA_UNT_MQT_Inline
select * from [tblOutput_Hosp_TA_Master_Inline_Aric] where DataType='MQTUNT'
go
--9.
truncate table tblOutput_Hosp_TA_UNT_MAT_Inline
go
Insert into tblOutput_Hosp_TA_UNT_MAT_Inline
select * from [tblOutput_Hosp_TA_Master_Inline_Aric] where DataType='MATUNT'
























