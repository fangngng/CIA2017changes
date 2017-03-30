REM start HKAPI Data Processing



osql -r -S 172.20.0.82 -U sa -P love2you -d BMSCNProc2 -i "HKAPI\HKAPI_Processing_Setp_1.sql" 		1>"HKAPI\log\HKAPI_Processing_Setp_1.log" 2>"HKAPI\log\ERROR_HKAPI_Processing_Setp_1.log"
osql -r -S 172.20.0.82 -U sa -P love2you -d BMSCNProc2 -i "HKAPI\HKAPI_Processing_Setp_2.sql" 		1>"HKAPI\log\HKAPI_Processing_Setp_2.log" 2>"HKAPI\log\ERROR_HKAPI_Processing_Setp_2.log"

REM output to WEB
osql -r -S 172.20.0.82 -U sa -P love2you -d BMSChinaQueryToolNew -i "99_Output_0_Definition.sql" 		1>"log\99_Output_0_Definition.log" 2>"log\ERROR_99_Output_0_Definition.log"

osql -r -S 172.20.0.82 -U sa -P love2you -d BMSChinaQueryToolNew -i "HKAPI\99_Output_HKAPI.sql" 		1>"HKAPI\log\99_Output_HKAPI.log" 2>"HKAPI\log\ERROR_99_Output_HKAPI.log"


REM END HKAPI DATA PROCESSING