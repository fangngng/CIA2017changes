REM imp
REM osql -r -S 172.20.0.4 -U sa -P love2you -d BMSChinaCIA_IMS -i "IMS\0_1_init.sql" 1>"IMS\log\0_1_init.log" 2>"IMS\log\error_0_1_init.log"
REM osql -r -S 172.20.0.4 -U sa -P love2you -d BMSChinaOtherDB -i "IMS\0_2_HKAPI_script.sql" 1>"IMS\log\0_2_HKAPI_script.log" 2>"IMS\log\error_0_2_HKAPI_script.log"
REM osql -r -S 172.20.0.4 -U sa -P love2you -d BMSChinaCIA_IMS -i "IMS\0_3_in_IMS.sql" 1>"IMS\log\0_3_in_IMS.log" 2>"IMS\log\error_0_3_in_IMS.log"
REM osql -r -S 172.20.0.4 -U sa -P love2you -d BMSChinaCIA_IMS -i "IMS\0_4_Seeddata.sql" 1>"IMS\log\0_4_Seeddata.log" 2>"IMS\log\error_0_4_Seeddata.log"


REM Mkt
REM osql -r -S 172.20.0.4 -U sa -P love2you -d BMSChinaCIA_IMS -i "IMS\1_MktDefinition.sql" 1>"IMS\log\1_MktDefinition.log" 2>"IMS\log\error_1_MktDefinition.log"
osql -r -S 172.20.0.4 -U sa -P love2you -d BMSChinaCIA_IMS -i "IMS\2_MID.sql" 1>"IMS\log\2_MID.log" 2>"IMS\log\error_2_MID.log"
REM osql -r -S 172.20.0.4 -U sa -P love2you -d BMSChinaCIA_IMS -i "IMS\2_MID_HKAPI.sql" 1>"IMS\log\2_MID_HKAPI.log" 2>"IMS\log\error_2_MID_HKAPI.log"
REM Pro
REM osql -r -S 172.20.0.4 -U sa -P love2you -d BMSChinaCIA_IMS -i "IMS\3_1_OutPut_D.sql" 1>"IMS\log\3_1_OutPut_D.log" 2>"IMS\log\error_3_1_OutPut_D.log"
REM osql -r -S 172.20.0.4 -U sa -P love2you -d BMSChinaCIA_IMS -i "IMS\3_1_OutPut_D_C150.sql" 1>"IMS\log\3_1_OutPut_D_C150.log" 2>"IMS\log\error_3_1_OutPut_D_C150.log"
REM osql -r -S 172.20.0.4 -U sa -P love2you -d BMSChinaCIA_IMS -i "IMS\3_1_OutPut_D_C160.sql" 1>"IMS\log\3_1_OutPut_D_C160.log" 2>"IMS\log\error_3_1_OutPut_D_C160.log"
REM osql -r -S 172.20.0.4 -U sa -P love2you -d BMSChinaCIA_IMS -i "IMS\3_1_1_Eliquis_NOAC.sql" 1>"IMS\log\3_1_1_Eliquis_NOAC.log" 2>"IMS\log\error_3_1_1_Eliquis_NOAC.log"
REM osql -r -S 172.20.0.4 -U sa -P love2you -d BMSChinaCIA_IMS -i "IMS\3_2_OutPut_R.sql" 1>"IMS\log\3_2_OutPut_R.log" 2>"IMS\log\error_3_2_OutPut_R.log"
REM osql -r -S 172.20.0.4 -U sa -P love2you -d BMSChinaCIA_IMS -i "IMS\3_3_OutPut_afterDeal.sql" 1>"IMS\log\3_3_OutPut_afterDeal.log" 2>"IMS\log\error_3_3_OutPut_afterDeal.log"
REM osql -r -S 172.20.0.4 -U sa -P love2you -d BMSChinaCIA_IMS -i "IMS\3_Output_HKAPI.sql" 1>"IMS\log\3_Output_HKAPI.log" 2>"IMS\log\error_3_Output_HKAPI.log"
REM osql -r -S 172.20.0.4 -U sa -P love2you -d BMSChinaCIA_IMS -i "IMS\4_webConfig.sql" 1>"IMS\log\4_webConfig.log" 2>"IMS\log\error_4_webConfig.log"

REM exp
REM osql -r -S 172.20.0.33 -U sa -P love2you -d BMSChina_staging -i "IMS\99_Export_IMS.sql" 1>"IMS\log\99_Export_IMS.log" 2>"IMS\log\error_99_Export_IMS.log"























