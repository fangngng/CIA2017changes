REM start Hospital Data Processing


REM Hosp Pipeline
osql -r -S 172.20.0.82 -U sa -P love2you -d BMSCNProc2 -i "Hospital_Pipeline\0_Prepare_1_Hospital_Pipeline.sql" 		1>"Hospital_Pipeline\log\0_Prepare_1_Hospital_Pipeline.log" 2>"Hospital_Pipeline\log\ERROR_0_Prepare_1_Hospital_Pipeline.log"

osql -r -S 172.20.0.82 -U sa -P love2you -d BMSCNProc2 -i "Hospital_Pipeline\Step_1_Create_tblHospitalDataRaw.sql" 		1>"Hospital_Pipeline\log\Step_1_Create_tblHospitalDataRaw.log" 2>"Hospital_Pipeline\log\ERROR_Step_1_Create_tblHospitalDataRaw.log"
osql -r -S 172.20.0.82 -U sa -P love2you -d BMSCNProc2 -i "Hospital_Pipeline\Step_2_RollupMAT.sql" 				1>"Hospital_Pipeline\log\Step_2_RollupMAT.log" 2>"Hospital_Pipeline\log\ERROR_Step_2_RollupMAT.log"
osql -r -S 172.20.0.82 -U sa -P love2you -d BMSCNProc2 -i "Hospital_Pipeline\Step_3_Create_Hosp_TA_Output_Master_Table.sql" 	1>"Hospital_Pipeline\log\Step_3_Create_Hosp_TA_Output_Master_Table.log" 2>"Hospital_Pipeline\log\ERROR_Step_3_Create_Hosp_TA_Output_Master_Table.log"
osql -r -S 172.20.0.82 -U sa -P love2you -d BMSCNProc2 -i "Hospital_Pipeline\Step_4_Create_Output_Hosp_TA.sql" 		1>"Hospital_Pipeline\log\Step_4_Create_Output_Hosp_TA.log" 2>"Hospital_Pipeline\log\ERROR_Step_4_Create_Output_Hosp_TA.log"

REM output to WEB
osql -r -S 172.20.0.82 -U sa -P love2you -d BMSChinaQueryToolNew -i "99_Output_0_Definition.sql" 		1>"log\99_Output_0_Definition.log" 2>"log\ERROR_99_Output_0_Definition.log"
osql -r -S 172.20.0.82 -U sa -P love2you -d BMSChinaQueryToolNew -i "Hospital_Pipeline\99_Output_Hosp_Pipeline.sql" 		1>"Hospital_Pipeline\log\99_Output_Hosp_Pipeline.log" 2>"Hospital_Pipeline\log\ERROR_99_Output_Hosp_Pipeline.log"


REM END Hospital DATA PROCESSING
