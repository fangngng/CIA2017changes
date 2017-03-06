REM start 
REM 0_1_Import_Rowdata.sql
REM 0_2_manually_DataPreparation.sql
REM 0_3_MktDefinition.sql


osql -r -S 192.168.1.32 -U sa -P love2you -d BMSCNProc2 -i "Hospital_CPA_SeaRainbow\Step_1_Create_tblHospitalDataRaw.sql" 			1>"Hospital_CPA_SeaRainbow\log\Step_1_Create_tblHospitalDataRaw.log" 2>"Hospital_CPA_SeaRainbow\log\ERROR_Step_1_Create_tblHospitalDataRaw.log"
osql -r -S 192.168.1.32 -U sa -P love2you -d BMSCNProc2 -i "Hospital_CPA_SeaRainbow\Step_2_RollupMQT&MAT.sql" 					1>"Hospital_CPA_SeaRainbow\log\Step_2_RollupMQT&MAT.log" 2>"Hospital_CPA_SeaRainbow\log\ERROR_Step_2_RollupMQT&MAT.log"
osql -r -S 192.168.1.32 -U sa -P love2you -d BMSCNProc2 -i "Hospital_CPA_SeaRainbow\Step_3_Create_Output_Hosp_TA_Master_Tables.sql" 		1>"Hospital_CPA_SeaRainbow\log\Step_3_Create_Output_Hosp_TA_Master_Tables.log" 2>"Hospital_CPA_SeaRainbow\log\ERROR_Step_3_Create_Output_Hosp_TA_Master_Tables.log"
osql -r -S 192.168.1.32 -U sa -P love2you -d BMSCNProc2 -i "Hospital_CPA_SeaRainbow\Step_4_Create_Output_Hosp_TA_Inline.sql" 			1>"Hospital_CPA_SeaRainbow\log\Step_4_Create_Output_Hosp_TA_Inline.log" 2>"Hospital_CPA_SeaRainbow\log\ERROR_Step_4_Create_Output_Hosp_TA_Inline.log"

REM to WEB
osql -r -S 192.168.1.31 -U sa -P love2you -d BMSChinaQueryToolNew -i "99_Output_0_Definition.sql" 		1>"log\99_Output_0_Definition.log" 2>"log\ERROR_99_Output_0_Definition.log"
osql -r -S 192.168.1.31 -U sa -P love2you -d BMSChinaQueryToolNew -i "Hospital_CPA_SeaRainbow\99_Output_Hosp_Inline.sql" 			1>"Hospital_CPA_SeaRainbow\log\99_Output_Hosp_Inline.log" 2>"Hospital_CPA_SeaRainbow\log\ERROR_99_Output_Hosp_Inline.log"

REM end 
