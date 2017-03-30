REM start IMS Data Processing


osql -r -S 172.20.0.82 -U sa -P love2you -d BMSCNProc2 -i "IMS\0_Prepare_IMS.sql" 			1>"IMS\log\0_Prepare_IMS.log" 2>"IMS\log\ERROR_0_Prepare_IMS.log"


REM osql -r -S 172.20.0.82 -U sa -P love2you -d BMSCNProc2 -i "IMS\Step_1_Load_tblIMSRawData.sql" 			1>"IMS\log\Step_1_Load_tblIMSRawData.log" 2>"IMS\log\ERROR_Step_1_Load_tblIMSRawData.log"
REM osql -r -S 172.20.0.82 -U sa -P love2you -d BMSCNProc2 -i "IMS\Step_2_1_Create_IMS_TA_Output_Master_Tables.sql" 	1>"IMS\log\Step_2_1_Create_IMS_TA_Output_Master_Tables.log" 2>"IMS\log\ERROR_Step_2_1_Create_IMS_TA_Output_Master_Tables.log"
REM osql -r -S 172.20.0.82 -U sa -P love2you -d BMSCNProc2 -i "IMS\Step_2_2_Create_IMS_TA_Final_Output_Tables.sql" 	1>"IMS\log\Step_2_2_Create_IMS_TA_Final_Output_Tables.log" 2>"IMS\log\ERROR_Step_2_2_Create_IMS_TA_Final_Output_Tables.log"
REM osql -r -S 172.20.0.82 -U sa -P love2you -d BMSCNProc2 -i "IMS\Step_3_1_Create_IMS_ATC_Output_Master_Table.sql" 	1>"IMS\log\Step_3_1_Create_IMS_ATC_Output_Master_Table.log" 2>"IMS\log\ERROR_Step_3_1_Create_IMS_ATC_Output_Master_Table.log"
REM osql -r -S 172.20.0.82 -U sa -P love2you -d BMSCNProc2 -i "IMS\Step_3_2_Create_IMS_ATC_Final_Output_Tables.sql" 	1>"IMS\log\Step_3_2_Create_IMS_ATC_Final_Output_Tables.log" 2>"IMS\log\ERROR_Step_3_2_Create_IMS_ATC_Final_Output_Tables.log"

REM output to WEB
REM osql -r -S 172.20.0.82 -U sa -P love2you -d BMSChinaQueryToolNew -i "99_Output_0_Definition.sql" 		1>"log\99_Output_0_Definition.log" 2>"log\ERROR_99_Output_0_Definition.log"
REM osql -r -S 172.20.0.82 -U sa -P love2you -d BMSChinaQueryToolNew -i "IMS\99_Output_IMS.sql" 		1>"IMS\log\99_Output_IMS.log" 2>"IMS\log\ERROR_99_Output_IMS.log"

REM END IMS DATA PROCESSING
