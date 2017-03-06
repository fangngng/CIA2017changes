/*

Created on 12/22/2011

load IMS Raw Data  to :tblIMSDataRaw

CHINA Level,HINA Level : Pack_Cod 

*/

use BMSCNProc2
go



truncate table tblIMSDataRaw
go
drop index tblIMSDataRaw.idxPack
go
drop index tblIMSDataRaw.idxAudi
go



PRINT N'(--------------------------------
第一步：从源数据导入 MTH 数据
----------------------------------------)'
--Append CHINA Level Data:
insert into tblIMSDataRaw
select 'MTHRMB' as DataType, 'CHN_' as Audi_Cod, Pack_Cod, 
MTH59LC, MTH58LC, MTH57LC, MTH56LC, MTH55LC, MTH54LC, MTH53LC, MTH52LC, MTH51LC, MTH50LC, 
MTH49LC, MTH48LC, MTH47LC, MTH46LC, MTH45LC, MTH44LC, MTH43LC, MTH42LC, MTH41LC, MTH40LC, 
MTH39LC, MTH38LC, MTH37LC, MTH36LC, MTH35LC, MTH34LC, MTH33LC, MTH32LC, MTH31LC, MTH30LC, 
MTH29LC, MTH28LC, MTH27LC, MTH26LC, MTH25LC, MTH24LC, MTH23LC, MTH22LC, MTH21LC, MTH20LC, 
MTH19LC, MTH18LC, MTH17LC, MTH16LC, MTH15LC, MTH14LC, MTH13LC, MTH12LC, MTH11LC, MTH10LC, 
MTH09LC, MTH08LC, MTH07LC, MTH06LC, MTH05LC, MTH04LC, MTH03LC, MTH02LC, MTH01LC, MTH00LC
from MTHCHPA_PKAU
go
insert into tblIMSDataRaw
select 'MTHUSD' as DataType, 'CHN_' as Audi_Cod, Pack_Cod, 
MTH59US, MTH58US, MTH57US, MTH56US, MTH55US, MTH54US, MTH53US, MTH52US, MTH51US, MTH50US, 
MTH49US, MTH48US, MTH47US, MTH46US, MTH45US, MTH44US, MTH43US, MTH42US, MTH41US, MTH40US, 
MTH39US, MTH38US, MTH37US, MTH36US, MTH35US, MTH34US, MTH33US, MTH32US, MTH31US, MTH30US, 
MTH29US, MTH28US, MTH27US, MTH26US, MTH25US, MTH24US, MTH23US, MTH22US, MTH21US, MTH20US, 
MTH19US, MTH18US, MTH17US, MTH16US, MTH15US, MTH14US, MTH13US, MTH12US, MTH11US, MTH10US, 
MTH09US, MTH08US, MTH07US, MTH06US, MTH05US, MTH04US, MTH03US, MTH02US, MTH01US, MTH00US
from MTHCHPA_PKAU
go
insert into tblIMSDataRaw
select 'MTHUNT' as DataType, 'CHN_' as Audi_Cod, Pack_Cod, 
Round(MTH59UN, 0), Round(MTH58UN, 0), Round(MTH57UN, 0), Round(MTH56UN, 0), Round(MTH55UN, 0), Round(MTH54UN, 0), Round(MTH53UN, 0), Round(MTH52UN, 0), Round(MTH51UN, 0), Round(MTH50UN, 0), 
Round(MTH49UN, 0), Round(MTH48UN, 0), Round(MTH47UN, 0), Round(MTH46UN, 0), Round(MTH45UN, 0), Round(MTH44UN, 0), Round(MTH43UN, 0), Round(MTH42UN, 0), Round(MTH41UN, 0), Round(MTH40UN, 0), 
Round(MTH39UN, 0), Round(MTH38UN, 0), Round(MTH37UN, 0), Round(MTH36UN, 0), Round(MTH35UN, 0), Round(MTH34UN, 0), Round(MTH33UN, 0), Round(MTH32UN, 0), Round(MTH31UN, 0), Round(MTH30UN, 0), 
Round(MTH29UN, 0), Round(MTH28UN, 0), Round(MTH27UN, 0), Round(MTH26UN, 0), Round(MTH25UN, 0), Round(MTH24UN, 0), Round(MTH23UN, 0), Round(MTH22UN, 0), Round(MTH21UN, 0), Round(MTH20UN, 0), 
Round(MTH19UN, 0), Round(MTH18UN, 0), Round(MTH17UN, 0), Round(MTH16UN, 0), Round(MTH15UN, 0), Round(MTH14UN, 0), Round(MTH13UN, 0), Round(MTH12UN, 0), Round(MTH11UN, 0), Round(MTH10UN, 0), 
Round(MTH09UN, 0), Round(MTH08UN, 0), Round(MTH07UN, 0), Round(MTH06UN, 0), Round(MTH05UN, 0), Round(MTH04UN, 0), Round(MTH03UN, 0), Round(MTH02UN, 0), Round(MTH01UN, 0), Round(MTH00UN, 0)
from MTHCHPA_PKAU
go



--Append City level data:
insert into tblIMSDataRaw
select 'MTHRMB' as DataType, Audi_Cod, Pack_Cod, 
MTH59LC, MTH58LC, MTH57LC, MTH56LC, MTH55LC, MTH54LC, MTH53LC, MTH52LC, MTH51LC, MTH50LC, 
MTH49LC, MTH48LC, MTH47LC, MTH46LC, MTH45LC, MTH44LC, MTH43LC, MTH42LC, MTH41LC, MTH40LC, 
MTH39LC, MTH38LC, MTH37LC, MTH36LC, MTH35LC, MTH34LC, MTH33LC, MTH32LC, MTH31LC, MTH30LC, 
MTH29LC, MTH28LC, MTH27LC, MTH26LC, MTH25LC, MTH24LC, MTH23LC, MTH22LC, MTH21LC, MTH20LC, 
MTH19LC, MTH18LC, MTH17LC, MTH16LC, MTH15LC, MTH14LC, MTH13LC, MTH12LC, MTH11LC, MTH10LC, 
MTH09LC, MTH08LC, MTH07LC, MTH06LC, MTH05LC, MTH04LC, MTH03LC, MTH02LC, MTH01LC, MTH00LC
from MTHCITY_PKAU
go
insert into tblIMSDataRaw
select 'MTHUSD' as DataType, Audi_Cod, Pack_Cod, 
MTH59US, MTH58US, MTH57US, MTH56US, MTH55US, MTH54US, MTH53US, MTH52US, MTH51US, MTH50US, 
MTH49US, MTH48US, MTH47US, MTH46US, MTH45US, MTH44US, MTH43US, MTH42US, MTH41US, MTH40US, 
MTH39US, MTH38US, MTH37US, MTH36US, MTH35US, MTH34US, MTH33US, MTH32US, MTH31US, MTH30US, 
MTH29US, MTH28US, MTH27US, MTH26US, MTH25US, MTH24US, MTH23US, MTH22US, MTH21US, MTH20US, 
MTH19US, MTH18US, MTH17US, MTH16US, MTH15US, MTH14US, MTH13US, MTH12US, MTH11US, MTH10US, 
MTH09US, MTH08US, MTH07US, MTH06US, MTH05US, MTH04US, MTH03US, MTH02US, MTH01US, MTH00US
from MTHCITY_PKAU
go
insert into tblIMSDataRaw
select 'MTHUNT' as DataType, Audi_Cod, Pack_Cod, 
Round(MTH59UN, 0), Round(MTH58UN, 0), Round(MTH57UN, 0), Round(MTH56UN, 0), Round(MTH55UN, 0), Round(MTH54UN, 0), Round(MTH53UN, 0), Round(MTH52UN, 0), Round(MTH51UN, 0), Round(MTH50UN, 0), 
Round(MTH49UN, 0), Round(MTH48UN, 0), Round(MTH47UN, 0), Round(MTH46UN, 0), Round(MTH45UN, 0), Round(MTH44UN, 0), Round(MTH43UN, 0), Round(MTH42UN, 0), Round(MTH41UN, 0), Round(MTH40UN, 0), 
Round(MTH39UN, 0), Round(MTH38UN, 0), Round(MTH37UN, 0), Round(MTH36UN, 0), Round(MTH35UN, 0), Round(MTH34UN, 0), Round(MTH33UN, 0), Round(MTH32UN, 0), Round(MTH31UN, 0), Round(MTH30UN, 0), 
Round(MTH29UN, 0), Round(MTH28UN, 0), Round(MTH27UN, 0), Round(MTH26UN, 0), Round(MTH25UN, 0), Round(MTH24UN, 0), Round(MTH23UN, 0), Round(MTH22UN, 0), Round(MTH21UN, 0), Round(MTH20UN, 0), 
Round(MTH19UN, 0), Round(MTH18UN, 0), Round(MTH17UN, 0), Round(MTH16UN, 0), Round(MTH15UN, 0), Round(MTH14UN, 0), Round(MTH13UN, 0), Round(MTH12UN, 0), Round(MTH11UN, 0), Round(MTH10UN, 0), 
Round(MTH09UN, 0), Round(MTH08UN, 0), Round(MTH07UN, 0), Round(MTH06UN, 0), Round(MTH05UN, 0), Round(MTH04UN, 0), Round(MTH03UN, 0), Round(MTH02UN, 0), Round(MTH01UN, 0), Round(MTH00UN, 0)
from MTHCITY_PKAU
go








PRINT N'(--------------------------------
第二步：根据 MTH数据 Roll up
----------------------------------------)'
--Roll up MQT data:
insert into tblIMSDataRaw
select 'MQT'+substring(DataType, 4, 3) as DataType, Audi_Cod, Pack_Cod, 0, 0, isnull(MTH_60,0)+isnull(MTH_59,0)+isnull(MTH_58,0),
isnull(MTH_59,0)+isnull(MTH_58,0)+isnull(MTH_57,0), isnull(MTH_58,0)+isnull(MTH_57,0)+isnull(MTH_56,0), isnull(MTH_57,0)+isnull(MTH_56,0)+isnull(MTH_55,0), isnull(MTH_56,0)+isnull(MTH_55,0)+isnull(MTH_54,0), isnull(MTH_55,0)+isnull(MTH_54,0)+isnull(MTH_53,0), isnull(MTH_54,0)+isnull(MTH_53,0)+isnull(MTH_52,0), isnull(MTH_53,0)+isnull(MTH_52,0)+isnull(MTH_51,0), 
isnull(MTH_52,0)+isnull(MTH_51,0)+isnull(MTH_50,0), isnull(MTH_51,0)+isnull(MTH_50,0)+isnull(MTH_49,0), isnull(MTH_50,0)+isnull(MTH_49,0)+isnull(MTH_48,0), isnull(MTH_49,0)+isnull(MTH_48,0)+isnull(MTH_47,0), isnull(MTH_48,0)+isnull(MTH_47,0)+isnull(MTH_46,0), isnull(MTH_47,0)+isnull(MTH_46,0)+isnull(MTH_45,0), isnull(MTH_46,0)+isnull(MTH_45,0)+isnull(MTH_44,0), 
isnull(MTH_45,0)+isnull(MTH_44,0)+isnull(MTH_43,0), isnull(MTH_44,0)+isnull(MTH_43,0)+isnull(MTH_42,0), isnull(MTH_43,0)+isnull(MTH_42,0)+isnull(MTH_41,0), isnull(MTH_42,0)+isnull(MTH_41,0)+isnull(MTH_40,0), isnull(MTH_41,0)+isnull(MTH_40,0)+isnull(MTH_39,0), isnull(MTH_40,0)+isnull(MTH_39,0)+isnull(MTH_38,0), isnull(MTH_39,0)+isnull(MTH_38,0)+isnull(MTH_37,0), 
isnull(MTH_38,0)+isnull(MTH_37,0)+isnull(MTH_36,0), isnull(MTH_37,0)+isnull(MTH_36,0)+isnull(MTH_35,0), isnull(MTH_36,0)+isnull(MTH_35,0)+isnull(MTH_34,0), isnull(MTH_35,0)+isnull(MTH_34,0)+isnull(MTH_33,0), isnull(MTH_34,0)+isnull(MTH_33,0)+isnull(MTH_32,0), isnull(MTH_33,0)+isnull(MTH_32,0)+isnull(MTH_31,0), isnull(MTH_32,0)+isnull(MTH_31,0)+isnull(MTH_30,0), 
isnull(MTH_31,0)+isnull(MTH_30,0)+isnull(MTH_29,0), isnull(MTH_30,0)+isnull(MTH_29,0)+isnull(MTH_28,0), isnull(MTH_29,0)+isnull(MTH_28,0)+isnull(MTH_27,0), isnull(MTH_28,0)+isnull(MTH_27,0)+isnull(MTH_26,0), isnull(MTH_27,0)+isnull(MTH_26,0)+isnull(MTH_25,0), isnull(MTH_26,0)+isnull(MTH_25,0)+isnull(MTH_24,0), isnull(MTH_25,0)+isnull(MTH_24,0)+isnull(MTH_23,0), 
isnull(MTH_24,0)+isnull(MTH_23,0)+isnull(MTH_22,0), isnull(MTH_23,0)+isnull(MTH_22,0)+isnull(MTH_21,0), isnull(MTH_22,0)+isnull(MTH_21,0)+isnull(MTH_20,0), isnull(MTH_21,0)+isnull(MTH_20,0)+isnull(MTH_19,0), isnull(MTH_20,0)+isnull(MTH_19,0)+isnull(MTH_18,0), isnull(MTH_19,0)+isnull(MTH_18,0)+isnull(MTH_17,0), isnull(MTH_18,0)+isnull(MTH_17,0)+isnull(MTH_16,0), 
isnull(MTH_17,0)+isnull(MTH_16,0)+isnull(MTH_15,0), isnull(MTH_16,0)+isnull(MTH_15,0)+isnull(MTH_14,0), isnull(MTH_15,0)+isnull(MTH_14,0)+isnull(MTH_13,0), isnull(MTH_14,0)+isnull(MTH_13,0)+isnull(MTH_12,0), isnull(MTH_13,0)+isnull(MTH_12,0)+isnull(MTH_11,0), isnull(MTH_12,0)+isnull(MTH_11,0)+isnull(MTH_10,0), isnull(MTH_11,0)+isnull(MTH_10,0)+isnull(MTH_9,0), 
isnull(MTH_10,0)+isnull(MTH_9,0)+isnull(MTH_8,0), isnull(MTH_9,0)+isnull(MTH_8,0)+isnull(MTH_7,0), isnull(MTH_8,0)+isnull(MTH_7,0)+isnull(MTH_6,0), isnull(MTH_7,0)+isnull(MTH_6,0)+isnull(MTH_5,0), isnull(MTH_6,0)+isnull(MTH_5,0)+isnull(MTH_4,0), isnull(MTH_5,0)+isnull(MTH_4,0)+isnull(MTH_3,0), isnull(MTH_4,0)+isnull(MTH_3,0)+isnull(MTH_2,0), isnull(MTH_3,0)+isnull(MTH_2,0)+isnull(MTH_1,0)
from tblIMSDataRaw
go


--Roll up MAT data:
insert into tblIMSDataRaw
select 'MAT'+substring(DataType, 4, 3) as DataType, Audi_Cod, Pack_Cod, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
isnull(MTH_60,0)+isnull(MTH_59,0)+isnull(MTH_58,0)+isnull(MTH_57,0)+isnull(MTH_56,0)+isnull(MTH_55,0)+isnull(MTH_54,0)+isnull(MTH_53,0)+isnull(MTH_52,0)+isnull(MTH_51,0)+isnull(MTH_50,0)+isnull(MTH_49,0), 
isnull(MTH_59,0)+isnull(MTH_58,0)+isnull(MTH_57,0)+isnull(MTH_56,0)+isnull(MTH_55,0)+isnull(MTH_54,0)+isnull(MTH_53,0)+isnull(MTH_52,0)+isnull(MTH_51,0)+isnull(MTH_50,0)+isnull(MTH_49,0)+isnull(MTH_48,0), 
isnull(MTH_58,0)+isnull(MTH_57,0)+isnull(MTH_56,0)+isnull(MTH_55,0)+isnull(MTH_54,0)+isnull(MTH_53,0)+isnull(MTH_52,0)+isnull(MTH_51,0)+isnull(MTH_50,0)+isnull(MTH_49,0)+isnull(MTH_48,0)+isnull(MTH_47,0), 
isnull(MTH_57,0)+isnull(MTH_56,0)+isnull(MTH_55,0)+isnull(MTH_54,0)+isnull(MTH_53,0)+isnull(MTH_52,0)+isnull(MTH_51,0)+isnull(MTH_50,0)+isnull(MTH_49,0)+isnull(MTH_48,0)+isnull(MTH_47,0)+isnull(MTH_46,0), 
isnull(MTH_56,0)+isnull(MTH_55,0)+isnull(MTH_54,0)+isnull(MTH_53,0)+isnull(MTH_52,0)+isnull(MTH_51,0)+isnull(MTH_50,0)+isnull(MTH_49,0)+isnull(MTH_48,0)+isnull(MTH_47,0)+isnull(MTH_46,0)+isnull(MTH_45,0), 
isnull(MTH_55,0)+isnull(MTH_54,0)+isnull(MTH_53,0)+isnull(MTH_52,0)+isnull(MTH_51,0)+isnull(MTH_50,0)+isnull(MTH_49,0)+isnull(MTH_48,0)+isnull(MTH_47,0)+isnull(MTH_46,0)+isnull(MTH_45,0)+isnull(MTH_44,0), 
isnull(MTH_54,0)+isnull(MTH_53,0)+isnull(MTH_52,0)+isnull(MTH_51,0)+isnull(MTH_50,0)+isnull(MTH_49,0)+isnull(MTH_48,0)+isnull(MTH_47,0)+isnull(MTH_46,0)+isnull(MTH_45,0)+isnull(MTH_44,0)+isnull(MTH_43,0), 
isnull(MTH_53,0)+isnull(MTH_52,0)+isnull(MTH_51,0)+isnull(MTH_50,0)+isnull(MTH_49,0)+isnull(MTH_48,0)+isnull(MTH_47,0)+isnull(MTH_46,0)+isnull(MTH_45,0)+isnull(MTH_44,0)+isnull(MTH_43,0)+isnull(MTH_42,0), 
isnull(MTH_52,0)+isnull(MTH_51,0)+isnull(MTH_50,0)+isnull(MTH_49,0)+isnull(MTH_48,0)+isnull(MTH_47,0)+isnull(MTH_46,0)+isnull(MTH_45,0)+isnull(MTH_44,0)+isnull(MTH_43,0)+isnull(MTH_42,0)+isnull(MTH_41,0), 
isnull(MTH_51,0)+isnull(MTH_50,0)+isnull(MTH_49,0)+isnull(MTH_48,0)+isnull(MTH_47,0)+isnull(MTH_46,0)+isnull(MTH_45,0)+isnull(MTH_44,0)+isnull(MTH_43,0)+isnull(MTH_42,0)+isnull(MTH_41,0)+isnull(MTH_40,0), 
isnull(MTH_50,0)+isnull(MTH_49,0)+isnull(MTH_48,0)+isnull(MTH_47,0)+isnull(MTH_46,0)+isnull(MTH_45,0)+isnull(MTH_44,0)+isnull(MTH_43,0)+isnull(MTH_42,0)+isnull(MTH_41,0)+isnull(MTH_40,0)+isnull(MTH_39,0), 
isnull(MTH_49,0)+isnull(MTH_48,0)+isnull(MTH_47,0)+isnull(MTH_46,0)+isnull(MTH_45,0)+isnull(MTH_44,0)+isnull(MTH_43,0)+isnull(MTH_42,0)+isnull(MTH_41,0)+isnull(MTH_40,0)+isnull(MTH_39,0)+isnull(MTH_38,0), 
isnull(MTH_48,0)+isnull(MTH_47,0)+isnull(MTH_46,0)+isnull(MTH_45,0)+isnull(MTH_44,0)+isnull(MTH_43,0)+isnull(MTH_42,0)+isnull(MTH_41,0)+isnull(MTH_40,0)+isnull(MTH_39,0)+isnull(MTH_38,0)+isnull(MTH_37,0), 
isnull(MTH_47,0)+isnull(MTH_46,0)+isnull(MTH_45,0)+isnull(MTH_44,0)+isnull(MTH_43,0)+isnull(MTH_42,0)+isnull(MTH_41,0)+isnull(MTH_40,0)+isnull(MTH_39,0)+isnull(MTH_38,0)+isnull(MTH_37,0)+isnull(MTH_36,0), 
isnull(MTH_46,0)+isnull(MTH_45,0)+isnull(MTH_44,0)+isnull(MTH_43,0)+isnull(MTH_42,0)+isnull(MTH_41,0)+isnull(MTH_40,0)+isnull(MTH_39,0)+isnull(MTH_38,0)+isnull(MTH_37,0)+isnull(MTH_36,0)+isnull(MTH_35,0), 
isnull(MTH_45,0)+isnull(MTH_44,0)+isnull(MTH_43,0)+isnull(MTH_42,0)+isnull(MTH_41,0)+isnull(MTH_40,0)+isnull(MTH_39,0)+isnull(MTH_38,0)+isnull(MTH_37,0)+isnull(MTH_36,0)+isnull(MTH_35,0)+isnull(MTH_34,0), 
isnull(MTH_44,0)+isnull(MTH_43,0)+isnull(MTH_42,0)+isnull(MTH_41,0)+isnull(MTH_40,0)+isnull(MTH_39,0)+isnull(MTH_38,0)+isnull(MTH_37,0)+isnull(MTH_36,0)+isnull(MTH_35,0)+isnull(MTH_34,0)+isnull(MTH_33,0), 
isnull(MTH_43,0)+isnull(MTH_42,0)+isnull(MTH_41,0)+isnull(MTH_40,0)+isnull(MTH_39,0)+isnull(MTH_38,0)+isnull(MTH_37,0)+isnull(MTH_36,0)+isnull(MTH_35,0)+isnull(MTH_34,0)+isnull(MTH_33,0)+isnull(MTH_32,0), 
isnull(MTH_42,0)+isnull(MTH_41,0)+isnull(MTH_40,0)+isnull(MTH_39,0)+isnull(MTH_38,0)+isnull(MTH_37,0)+isnull(MTH_36,0)+isnull(MTH_35,0)+isnull(MTH_34,0)+isnull(MTH_33,0)+isnull(MTH_32,0)+isnull(MTH_31,0), 
isnull(MTH_41,0)+isnull(MTH_40,0)+isnull(MTH_39,0)+isnull(MTH_38,0)+isnull(MTH_37,0)+isnull(MTH_36,0)+isnull(MTH_35,0)+isnull(MTH_34,0)+isnull(MTH_33,0)+isnull(MTH_32,0)+isnull(MTH_31,0)+isnull(MTH_30,0), 
isnull(MTH_40,0)+isnull(MTH_39,0)+isnull(MTH_38,0)+isnull(MTH_37,0)+isnull(MTH_36,0)+isnull(MTH_35,0)+isnull(MTH_34,0)+isnull(MTH_33,0)+isnull(MTH_32,0)+isnull(MTH_31,0)+isnull(MTH_30,0)+isnull(MTH_29,0), 
isnull(MTH_39,0)+isnull(MTH_38,0)+isnull(MTH_37,0)+isnull(MTH_36,0)+isnull(MTH_35,0)+isnull(MTH_34,0)+isnull(MTH_33,0)+isnull(MTH_32,0)+isnull(MTH_31,0)+isnull(MTH_30,0)+isnull(MTH_29,0)+isnull(MTH_28,0), 
isnull(MTH_38,0)+isnull(MTH_37,0)+isnull(MTH_36,0)+isnull(MTH_35,0)+isnull(MTH_34,0)+isnull(MTH_33,0)+isnull(MTH_32,0)+isnull(MTH_31,0)+isnull(MTH_30,0)+isnull(MTH_29,0)+isnull(MTH_28,0)+isnull(MTH_27,0), 
isnull(MTH_37,0)+isnull(MTH_36,0)+isnull(MTH_35,0)+isnull(MTH_34,0)+isnull(MTH_33,0)+isnull(MTH_32,0)+isnull(MTH_31,0)+isnull(MTH_30,0)+isnull(MTH_29,0)+isnull(MTH_28,0)+isnull(MTH_27,0)+isnull(MTH_26,0), 
isnull(MTH_36,0)+isnull(MTH_35,0)+isnull(MTH_34,0)+isnull(MTH_33,0)+isnull(MTH_32,0)+isnull(MTH_31,0)+isnull(MTH_30,0)+isnull(MTH_29,0)+isnull(MTH_28,0)+isnull(MTH_27,0)+isnull(MTH_26,0)+isnull(MTH_25,0), 
isnull(MTH_35,0)+isnull(MTH_34,0)+isnull(MTH_33,0)+isnull(MTH_32,0)+isnull(MTH_31,0)+isnull(MTH_30,0)+isnull(MTH_29,0)+isnull(MTH_28,0)+isnull(MTH_27,0)+isnull(MTH_26,0)+isnull(MTH_25,0)+isnull(MTH_24,0), 
isnull(MTH_34,0)+isnull(MTH_33,0)+isnull(MTH_32,0)+isnull(MTH_31,0)+isnull(MTH_30,0)+isnull(MTH_29,0)+isnull(MTH_28,0)+isnull(MTH_27,0)+isnull(MTH_26,0)+isnull(MTH_25,0)+isnull(MTH_24,0)+isnull(MTH_23,0), 
isnull(MTH_33,0)+isnull(MTH_32,0)+isnull(MTH_31,0)+isnull(MTH_30,0)+isnull(MTH_29,0)+isnull(MTH_28,0)+isnull(MTH_27,0)+isnull(MTH_26,0)+isnull(MTH_25,0)+isnull(MTH_24,0)+isnull(MTH_23,0)+isnull(MTH_22,0), 
isnull(MTH_32,0)+isnull(MTH_31,0)+isnull(MTH_30,0)+isnull(MTH_29,0)+isnull(MTH_28,0)+isnull(MTH_27,0)+isnull(MTH_26,0)+isnull(MTH_25,0)+isnull(MTH_24,0)+isnull(MTH_23,0)+isnull(MTH_22,0)+isnull(MTH_21,0), 
isnull(MTH_31,0)+isnull(MTH_30,0)+isnull(MTH_29,0)+isnull(MTH_28,0)+isnull(MTH_27,0)+isnull(MTH_26,0)+isnull(MTH_25,0)+isnull(MTH_24,0)+isnull(MTH_23,0)+isnull(MTH_22,0)+isnull(MTH_21,0)+isnull(MTH_20,0), 
isnull(MTH_30,0)+isnull(MTH_29,0)+isnull(MTH_28,0)+isnull(MTH_27,0)+isnull(MTH_26,0)+isnull(MTH_25,0)+isnull(MTH_24,0)+isnull(MTH_23,0)+isnull(MTH_22,0)+isnull(MTH_21,0)+isnull(MTH_20,0)+isnull(MTH_19,0), 
isnull(MTH_29,0)+isnull(MTH_28,0)+isnull(MTH_27,0)+isnull(MTH_26,0)+isnull(MTH_25,0)+isnull(MTH_24,0)+isnull(MTH_23,0)+isnull(MTH_22,0)+isnull(MTH_21,0)+isnull(MTH_20,0)+isnull(MTH_19,0)+isnull(MTH_18,0), 
isnull(MTH_28,0)+isnull(MTH_27,0)+isnull(MTH_26,0)+isnull(MTH_25,0)+isnull(MTH_24,0)+isnull(MTH_23,0)+isnull(MTH_22,0)+isnull(MTH_21,0)+isnull(MTH_20,0)+isnull(MTH_19,0)+isnull(MTH_18,0)+isnull(MTH_17,0), 
isnull(MTH_27,0)+isnull(MTH_26,0)+isnull(MTH_25,0)+isnull(MTH_24,0)+isnull(MTH_23,0)+isnull(MTH_22,0)+isnull(MTH_21,0)+isnull(MTH_20,0)+isnull(MTH_19,0)+isnull(MTH_18,0)+isnull(MTH_17,0)+isnull(MTH_16,0), 
isnull(MTH_26,0)+isnull(MTH_25,0)+isnull(MTH_24,0)+isnull(MTH_23,0)+isnull(MTH_22,0)+isnull(MTH_21,0)+isnull(MTH_20,0)+isnull(MTH_19,0)+isnull(MTH_18,0)+isnull(MTH_17,0)+isnull(MTH_16,0)+isnull(MTH_15,0), 
isnull(MTH_25,0)+isnull(MTH_24,0)+isnull(MTH_23,0)+isnull(MTH_22,0)+isnull(MTH_21,0)+isnull(MTH_20,0)+isnull(MTH_19,0)+isnull(MTH_18,0)+isnull(MTH_17,0)+isnull(MTH_16,0)+isnull(MTH_15,0)+isnull(MTH_14,0), 
isnull(MTH_24,0)+isnull(MTH_23,0)+isnull(MTH_22,0)+isnull(MTH_21,0)+isnull(MTH_20,0)+isnull(MTH_19,0)+isnull(MTH_18,0)+isnull(MTH_17,0)+isnull(MTH_16,0)+isnull(MTH_15,0)+isnull(MTH_14,0)+isnull(MTH_13,0), 
isnull(MTH_23,0)+isnull(MTH_22,0)+isnull(MTH_21,0)+isnull(MTH_20,0)+isnull(MTH_19,0)+isnull(MTH_18,0)+isnull(MTH_17,0)+isnull(MTH_16,0)+isnull(MTH_15,0)+isnull(MTH_14,0)+isnull(MTH_13,0)+isnull(MTH_12,0), 
isnull(MTH_22,0)+isnull(MTH_21,0)+isnull(MTH_20,0)+isnull(MTH_19,0)+isnull(MTH_18,0)+isnull(MTH_17,0)+isnull(MTH_16,0)+isnull(MTH_15,0)+isnull(MTH_14,0)+isnull(MTH_13,0)+isnull(MTH_12,0)+isnull(MTH_11,0), 
isnull(MTH_21,0)+isnull(MTH_20,0)+isnull(MTH_19,0)+isnull(MTH_18,0)+isnull(MTH_17,0)+isnull(MTH_16,0)+isnull(MTH_15,0)+isnull(MTH_14,0)+isnull(MTH_13,0)+isnull(MTH_12,0)+isnull(MTH_11,0)+isnull(MTH_10,0), 
isnull(MTH_20,0)+isnull(MTH_19,0)+isnull(MTH_18,0)+isnull(MTH_17,0)+isnull(MTH_16,0)+isnull(MTH_15,0)+isnull(MTH_14,0)+isnull(MTH_13,0)+isnull(MTH_12,0)+isnull(MTH_11,0)+isnull(MTH_10,0)+isnull(MTH_9,0), 
isnull(MTH_19,0)+isnull(MTH_18,0)+isnull(MTH_17,0)+isnull(MTH_16,0)+isnull(MTH_15,0)+isnull(MTH_14,0)+isnull(MTH_13,0)+isnull(MTH_12,0)+isnull(MTH_11,0)+isnull(MTH_10,0)+isnull(MTH_9,0)+isnull(MTH_8,0), 
isnull(MTH_18,0)+isnull(MTH_17,0)+isnull(MTH_16,0)+isnull(MTH_15,0)+isnull(MTH_14,0)+isnull(MTH_13,0)+isnull(MTH_12,0)+isnull(MTH_11,0)+isnull(MTH_10,0)+isnull(MTH_9,0)+isnull(MTH_8,0)+isnull(MTH_7,0), 
isnull(MTH_17,0)+isnull(MTH_16,0)+isnull(MTH_15,0)+isnull(MTH_14,0)+isnull(MTH_13,0)+isnull(MTH_12,0)+isnull(MTH_11,0)+isnull(MTH_10,0)+isnull(MTH_9,0)+isnull(MTH_8,0)+isnull(MTH_7,0)+isnull(MTH_6,0), 
isnull(MTH_16,0)+isnull(MTH_15,0)+isnull(MTH_14,0)+isnull(MTH_13,0)+isnull(MTH_12,0)+isnull(MTH_11,0)+isnull(MTH_10,0)+isnull(MTH_9,0)+isnull(MTH_8,0)+isnull(MTH_7,0)+isnull(MTH_6,0)+isnull(MTH_5,0), 
isnull(MTH_15,0)+isnull(MTH_14,0)+isnull(MTH_13,0)+isnull(MTH_12,0)+isnull(MTH_11,0)+isnull(MTH_10,0)+isnull(MTH_9,0)+isnull(MTH_8,0)+isnull(MTH_7,0)+isnull(MTH_6,0)+isnull(MTH_5,0)+isnull(MTH_4,0), 
isnull(MTH_14,0)+isnull(MTH_13,0)+isnull(MTH_12,0)+isnull(MTH_11,0)+isnull(MTH_10,0)+isnull(MTH_9,0)+isnull(MTH_8,0)+isnull(MTH_7,0)+isnull(MTH_6,0)+isnull(MTH_5,0)+isnull(MTH_4,0)+isnull(MTH_3,0), 
isnull(MTH_13,0)+isnull(MTH_12,0)+isnull(MTH_11,0)+isnull(MTH_10,0)+isnull(MTH_9,0)+isnull(MTH_8,0)+isnull(MTH_7,0)+isnull(MTH_6,0)+isnull(MTH_5,0)+isnull(MTH_4,0)+isnull(MTH_3,0)+isnull(MTH_2,0), 
isnull(MTH_12,0)+isnull(MTH_11,0)+isnull(MTH_10,0)+isnull(MTH_9,0)+isnull(MTH_8,0)+isnull(MTH_7,0)+isnull(MTH_6,0)+isnull(MTH_5,0)+isnull(MTH_4,0)+isnull(MTH_3,0)+isnull(MTH_2,0)+isnull(MTH_1,0) 
from tblIMSDataRaw where DataType like 'MTH%'
go


--Roll up YTD data:
declare @mth varchar(10),@sql01 nvarchar(MAX), @sql02 nvarchar(MAX)

select  @mth = DataPeriod from tblDataPeriod where QType = 'IMS'

set @sql01 = 'insert into tblIMSDataRaw
select ''YTD''+substring(DataType, 4, 3) as DataType, Audi_Cod, Pack_Cod
  ,' + dbo.fun_getYTDMonths_IMS(convert(varchar(6), dateadd(month, -59, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_IMS(convert(varchar(6), dateadd(month, -58, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_IMS(convert(varchar(6), dateadd(month, -57, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_IMS(convert(varchar(6), dateadd(month, -56, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_IMS(convert(varchar(6), dateadd(month, -55, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_IMS(convert(varchar(6), dateadd(month, -54, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_IMS(convert(varchar(6), dateadd(month, -53, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_IMS(convert(varchar(6), dateadd(month, -52, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_IMS(convert(varchar(6), dateadd(month, -51, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_IMS(convert(varchar(6), dateadd(month, -50, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_IMS(convert(varchar(6), dateadd(month, -49, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_IMS(convert(varchar(6), dateadd(month, -48, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_IMS(convert(varchar(6), dateadd(month, -47, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_IMS(convert(varchar(6), dateadd(month, -46, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_IMS(convert(varchar(6), dateadd(month, -45, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_IMS(convert(varchar(6), dateadd(month, -44, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_IMS(convert(varchar(6), dateadd(month, -43, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_IMS(convert(varchar(6), dateadd(month, -42, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_IMS(convert(varchar(6), dateadd(month, -41, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_IMS(convert(varchar(6), dateadd(month, -40, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_IMS(convert(varchar(6), dateadd(month, -39, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_IMS(convert(varchar(6), dateadd(month, -38, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_IMS(convert(varchar(6), dateadd(month, -37, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_IMS(convert(varchar(6), dateadd(month, -36, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_IMS(convert(varchar(6), dateadd(month, -35, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_IMS(convert(varchar(6), dateadd(month, -34, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_IMS(convert(varchar(6), dateadd(month, -33, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_IMS(convert(varchar(6), dateadd(month, -32, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_IMS(convert(varchar(6), dateadd(month, -31, cast(@mth+'01' as datetime)), 112))+'
'

set @sql02 = '
  ,' + dbo.fun_getYTDMonths_IMS(convert(varchar(6), dateadd(month, -30, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_IMS(convert(varchar(6), dateadd(month, -29, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_IMS(convert(varchar(6), dateadd(month, -28, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_IMS(convert(varchar(6), dateadd(month, -27, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_IMS(convert(varchar(6), dateadd(month, -26, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_IMS(convert(varchar(6), dateadd(month, -25, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_IMS(convert(varchar(6), dateadd(month, -24, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_IMS(convert(varchar(6), dateadd(month, -23, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_IMS(convert(varchar(6), dateadd(month, -22, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_IMS(convert(varchar(6), dateadd(month, -21, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_IMS(convert(varchar(6), dateadd(month, -20, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_IMS(convert(varchar(6), dateadd(month, -19, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_IMS(convert(varchar(6), dateadd(month, -18, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_IMS(convert(varchar(6), dateadd(month, -17, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_IMS(convert(varchar(6), dateadd(month, -16, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_IMS(convert(varchar(6), dateadd(month, -15, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_IMS(convert(varchar(6), dateadd(month, -14, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_IMS(convert(varchar(6), dateadd(month, -13, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_IMS(convert(varchar(6), dateadd(month, -12, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_IMS(convert(varchar(6), dateadd(month, -11, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_IMS(convert(varchar(6), dateadd(month, -10, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_IMS(convert(varchar(6), dateadd(month, -9, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_IMS(convert(varchar(6), dateadd(month, -8, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_IMS(convert(varchar(6), dateadd(month, -7, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_IMS(convert(varchar(6), dateadd(month, -6, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_IMS(convert(varchar(6), dateadd(month, -5, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_IMS(convert(varchar(6), dateadd(month, -4, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_IMS(convert(varchar(6), dateadd(month, -3, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_IMS(convert(varchar(6), dateadd(month, -2, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_IMS(convert(varchar(6), dateadd(month, -1, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_IMS(@mth)+'
from tblIMSDataRaw where DataType like ''MTH%''
'
exec(@sql01+@sql02)
GO

-- select * from tblIMSDataRaw where DataType like 'YTD%' 




--建索引
create index idxPack on tblIMSDataRaw(Pack_Cod)
go
create index idxAudi on tblIMSDataRaw(Audi_Cod)
go
