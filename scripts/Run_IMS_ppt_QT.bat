REM imp
REM osql -r -S 172.20.0.4 -U sa -P love2you -d BMSChinaCIA_IMS -i "IMS\0_1_init.sql" 1>"IMS\log\0_1_init.log" 2>"IMS\log\error_0_1_init.log"
REM osql -r -S 172.20.0.4 -U sa -P love2you -d BMSChinaOtherDB -i "IMS\0_2_in_HKAPI.sql" 1>"IMS\log\0_2_in_HKAPI.log" 2>"IMS\log\error_0_2_in_HKAPI.log"
REM osql -r -S 172.20.0.4 -U sa -P love2you -d BMSChinaCIA_IMS -i "IMS\0_3_in_IMS.sql" 1>"IMS\log\0_3_in_IMS.log" 2>"IMS\log\error_0_3_in_IMS.log"
REM osql -r -S 172.20.0.4 -U sa -P love2you -d BMSChinaCIA_IMS -i "IMS\0_4_RawdataProcess.sql" 1>"IMS\log\0_4_RawdataProcess.log" 2>"IMS\log\error_0_4_RawdataProcess.log"


REM Mkt
REM osql -r -S 172.20.0.4 -U sa -P love2you -d BMSChinaCIA_IMS -i "IMS\1_MktDefinition.sql" 1>"IMS\log\1_MktDefinition.log" 2>"IMS\log\error_1_MktDefinition.log"
REM osql -r -S 172.20.0.4 -U sa -P love2you -d BMSChinaCIA_IMS -i "IMS\2_MID.sql" 1>"IMS\log\2_MID.log" 2>"IMS\log\error_2_MID.log"
REM Pro
REM osql -r -S 172.20.0.4 -U sa -P love2you -d BMSChinaCIA_IMS -i "IMS\3_1_OutPut_D.sql" 1>"IMS\log\3_1_OutPut_D.log" 2>"IMS\log\error_3_1_OutPut_D.log"
osql -r -S 172.20.0.4 -U sa -P love2you -d BMSChinaCIA_IMS -i "IMS\3_1_OutPut_D_C150.sql" 1>"IMS\log\3_1_OutPut_D_C150.log" 2>"IMS\log\error_3_1_OutPut_D_C150.log"
osql -r -S 172.20.0.4 -U sa -P love2you -d BMSChinaCIA_IMS -i "IMS\3_1_OutPut_D_C160.sql" 1>"IMS\log\3_1_OutPut_D_C160.log" 2>"IMS\log\error_3_1_OutPut_D_C160.log"
osql -r -S 172.20.0.4 -U sa -P love2you -d BMSChinaCIA_IMS -i "IMS\3_2_OutPut_R.sql" 1>"IMS\log\3_2_OutPut_R.log" 2>"IMS\log\error_3_2_OutPut_R.log"
osql -r -S 172.20.0.4 -U sa -P love2you -d BMSChinaCIA_IMS -i "IMS\3_3_OutPut_afterDeal.sql" 1>"IMS\log\3_3_OutPut_afterDeal.log" 2>"IMS\log\error_3_3_OutPut_afterDeal.log"
osql -r -S 172.20.0.4 -U sa -P love2you -d BMSChinaCIA_IMS -i "IMS\4_webConfig.sql" 1>"IMS\log\4_webConfig.log" 2>"IMS\log\error_4_webConfig.log"

REM exp
REM osql -r -S 172.20.0.33 -U sa -P love2you -d BMSChina_staging -i "IMS\99_Export_IMS.sql" 1>"IMS\log\99_Export_IMS.log" 2>"IMS\log\error_99_Export_IMS.log"

REM main.ppt

cd ..

osql -r -S 172.20.0.33 -U sa -P love2you -d BMSChina_bk -i "scripts\IMS\99_Export_IMS.sql" 1>"scripts\IMS\log\99_Export_IMS.log" 2>"scripts\IMS\log\error_99_Export_IMS.log"
osql -r -S 172.20.0.33 -U sa -P love2you -d BMSChina_PPT -i "scripts\CPA\99_Export_Hosp.sql" 1>"scripts\CPA\log\99_Export_Hosp.log" 2>"scripts\CPA\log\error_99_Export_Hosp.log"
osql -r -S 172.20.0.33 -U sa -P love2you -d BMSChina_PPT -i "scripts\Rx\99_Export_Rx.sql" 1>"scripts\Rx\log\99_Export_Rx.log" 2>"scripts\Rx\log\error_99_Export_Rx.log"


osql -r -S 172.20.0.33 -U sa -P love2you -d BMSChina_PPT -i "scripts\99_All_1_SetChartSeries.sql" 1>"scripts\log\99_All_1_SetChartSeries.log" 2>"scripts\log\error_99_All_1_SetChartSeries.log"
osql -r -S 172.20.0.33 -U sa -P love2you -d BMSChina_staging -i "scripts\99_All_2_ToWeb.sql" 1>"scripts\log\99_All_2_ToWeb.log" 2>"scripts\log\error_99_All_2_ToWeb.log"
osql -r -S 172.20.0.33 -U sa -P love2you -d BMSChina_PPT -i "scripts\99_All_3_tblVersionInfo.sql" 1>"scripts\log\99_All_3_tblVersionInfo.log" 2>"scripts\log\error_99_All_3_tblVersionInfo.log"


osql -r -S 172.20.0.33 -U sa -P love2you -d BMSChina_PPT -i "report\run(1)_insertValues_tblPPTGraphDef.sql" 1>"report\log\run(1)_insertValues_tblPPTGraphDef.log" 2>"report\log\error_run(1)_insertValues_tblPPTGraphDef.log"
osql -r -S 172.20.0.33 -U sa -P love2you -d BMSChina_PPT -i "report\run(2)_updateCode_tblcharttitle.sql" 1>"report\log\run(2)_updateCode_tblcharttitle.log" 2>"report\log\error_run(2)_updateCode_tblcharttitle.log"
osql -r -S 172.20.0.33 -U sa -P love2you -d BMSChina_PPT -i "report\run(3)_insertValues_tblPPTOutputCombine.sql" 1>"report\log\run(3)_insertValues_tblPPTOutputCombine.log" 2>"report\log\error_run(3)_insertValues_tblPPTOutputCombine.log"
osql -r -S 172.20.0.33 -U sa -P love2you -d BMSChina_PPT -i "report\run(4)_Patch.sql" 1>"report\log\run(4)_Patch.log" 2>"report\log\error_run(4)_Patch.log"





REM start IMS Data Processing querytool


osql -r -S 172.20.0.32 -U sa -P love2you -d BMSCNProc2 -i "scripts\BMS_QueryTool\IMS\0_Prepare_IMS.sql" 			1>"scripts\BMS_QueryTool\IMS\log\0_Prepare_IMS.log" 2>"scripts\BMS_QueryTool\IMS\log\ERROR_0_Prepare_IMS.log"


osql -r -S 172.20.0.32 -U sa -P love2you -d BMSCNProc2 -i "scripts\BMS_QueryTool\IMS\Step_1_Load_tblIMSRawData.sql" 			1>"scripts\BMS_QueryTool\IMS\log\Step_1_Load_tblIMSRawData.log" 2>"scripts\BMS_QueryTool\IMS\log\ERROR_Step_1_Load_tblIMSRawData.log"
osql -r -S 172.20.0.32 -U sa -P love2you -d BMSCNProc2 -i "scripts\BMS_QueryTool\IMS\Step_2_1_Create_IMS_TA_Output_Master_Tables.sql" 	1>"scripts\BMS_QueryTool\IMS\log\Step_2_1_Create_IMS_TA_Output_Master_Tables.log" 2>"scripts\BMS_QueryTool\IMS\log\ERROR_Step_2_1_Create_IMS_TA_Output_Master_Tables.log"
osql -r -S 172.20.0.32 -U sa -P love2you -d BMSCNProc2 -i "scripts\BMS_QueryTool\IMS\Step_2_2_Create_IMS_TA_Final_Output_Tables.sql" 	1>"scripts\BMS_QueryTool\IMS\log\Step_2_2_Create_IMS_TA_Final_Output_Tables.log" 2>"scripts\BMS_QueryTool\IMS\log\ERROR_Step_2_2_Create_IMS_TA_Final_Output_Tables.log"
osql -r -S 172.20.0.32 -U sa -P love2you -d BMSCNProc2 -i "scripts\BMS_QueryTool\IMS\Step_3_1_Create_IMS_ATC_Output_Master_Table.sql" 	1>"scripts\BMS_QueryTool\IMS\log\Step_3_1_Create_IMS_ATC_Output_Master_Table.log" 2>"scripts\BMS_QueryTool\IMS\log\ERROR_Step_3_1_Create_IMS_ATC_Output_Master_Table.log"
osql -r -S 172.20.0.32 -U sa -P love2you -d BMSCNProc2 -i "scripts\BMS_QueryTool\IMS\Step_3_2_Create_IMS_ATC_Final_Output_Tables.sql" 	1>"scripts\BMS_QueryTool\IMS\log\Step_3_2_Create_IMS_ATC_Final_Output_Tables.log" 2>"scripts\BMS_QueryTool\IMS\log\ERROR_Step_3_2_Create_IMS_ATC_Final_Output_Tables.log"

REM output to WEB
osql -r -S 172.20.0.31 -U sa -P love2you -d BMSChinaQueryToolNew -i "scripts\BMS_QueryTool\99_Output_0_Definition.sql" 		1>"scripts\BMS_QueryTool\log\99_Output_0_Definition.log" 2>"scripts\BMS_QueryTool\log\ERROR_99_Output_0_Definition.log"
osql -r -S 172.20.0.31 -U sa -P love2you -d BMSChinaQueryToolNew -i "scripts\BMS_QueryTool\IMS\99_Output_IMS.sql" 		1>"scripts\BMS_QueryTool\IMS\log\99_Output_IMS.log" 2>"scripts\BMS_QueryTool\IMS\log\ERROR_99_Output_IMS.log"

REM END IMS DATA PROCESSING















