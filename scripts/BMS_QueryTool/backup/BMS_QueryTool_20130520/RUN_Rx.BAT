REM start Rx Data Processing


REM osql -r -S 192.168.1.32 -U sa -P love2you -d BMSCNProc2 -i "Rx\0_Prepare_1_Rx.sql" 		1>"Rx\log\0_Prepare_1_Rx.log" 2>"Rx\log\ERROR_0_Prepare_1_Rx.log"

osql -r -S 192.168.1.32 -U sa -P love2you -d BMSCNProc2 -i "Rx\Step_1_Create_tblRxProcessRaw.sql" 		1>"Rx\log\Step_1_Create_tblRxProcessRaw.log" 2>"Rx\log\ERROR_Step_1_Create_tblRxProcessRaw.log"
osql -r -S 192.168.1.32 -U sa -P love2you -d BMSCNProc2 -i "Rx\Step_2_Add_MAT_Data.sql" 			1>"Rx\log\Step_2_Add_MAT_Data.log" 2>"Rx\log\ERROR_Step_2_Add_MAT_Data.log"
osql -r -S 192.168.1.32 -U sa -P love2you -d BMSCNProc2 -i "Rx\Step_3_Create_Rx_TA_Output_Master_Tables.sql" 1>"Rx\log\Step_3_Create_Rx_TA_Output_Master_Tables.log" 2>"Rx\log\ERROR_Step_3_Create_Rx_TA_Output_Master_Tables.log"
osql -r -S 192.168.1.32 -U sa -P love2you -d BMSCNProc2 -i "Rx\Step_4_Create_Rx_TA_Final_Output_Tables.sql" 	1>"Rx\log\Step_4_Create_Rx_TA_Final_Output_Tables.log" 2>"Rx\log\ERROR_Step_4_Create_Rx_TA_Final_Output_Tables.log"

REM output to WEB
osql -r -S 192.168.1.31 -U sa -P love2you -d BMSChinaQueryToolNew -i "99_Output_0_Definition.sql" 		1>"log\99_Output_0_Definition.log" 2>"log\ERROR_99_Output_0_Definition.log"
osql -r -S 192.168.1.31 -U sa -P love2you -d BMSChinaQueryToolNew -i "Rx\99_Output_Rx.sql" 		1>"Rx\log\99_Output_Rx.log" 2>"Rx\log\ERROR_99_Output_Rx.log"

REM END Rx DATA PROCESSING