cd ..

osql -r -S 172.20.0.82 -U sa -P love2you -d BMSChina_bk -i "scripts\IMS\99_Export_IMS.sql" 1>"scripts\IMS\log\99_Export_IMS.log" 2>"scripts\IMS\log\error_99_Export_IMS.log"
osql -r -S 172.20.0.82 -U sa -P love2you -d BMSChina_PPT -i "scripts\CPA\99_Export_Hosp.sql" 1>"scripts\CPA\log\99_Export_Hosp.log" 2>"scripts\CPA\log\error_99_Export_Hosp.log"
osql -r -S 172.20.0.82 -U sa -P love2you -d BMSChina_PPT -i "scripts\Rx\99_Export_Rx.sql" 1>"scripts\Rx\log\99_Export_Rx.log" 2>"scripts\Rx\log\error_99_Export_Rx.log"


osql -r -S 172.20.0.82 -U sa -P love2you -d BMSChina_PPT -i "scripts\99_All_1_SetChartSeries.sql" 1>"scripts\log\99_All_1_SetChartSeries.log" 2>"scripts\log\error_99_All_1_SetChartSeries.log"
osql -r -S 172.20.0.82 -U sa -P love2you -d BMSChina_staging -i "scripts\99_All_2_ToWeb.sql" 1>"scripts\log\99_All_2_ToWeb.log" 2>"scripts\log\error_99_All_2_ToWeb.log"
osql -r -S 172.20.0.82 -U sa -P love2you -d BMSChina_PPT -i "scripts\99_All_3_tblVersionInfo.sql" 1>"scripts\log\99_All_3_tblVersionInfo.log" 2>"scripts\log\error_99_All_3_tblVersionInfo.log"


osql -r -S 172.20.0.82 -U sa -P love2you -d BMSChina_PPT -i "report\run(1)_insertValues_tblPPTGraphDef.sql" 1>"report\log\run(1)_insertValues_tblPPTGraphDef.log" 2>"report\log\error_run(1)_insertValues_tblPPTGraphDef.log"
osql -r -S 172.20.0.82 -U sa -P love2you -d BMSChina_PPT -i "report\run(2)_updateCode_tblcharttitle.sql" 1>"report\log\run(2)_updateCode_tblcharttitle.log" 2>"report\log\error_run(2)_updateCode_tblcharttitle.log"
osql -r -S 172.20.0.82 -U sa -P love2you -d BMSChina_PPT -i "report\run(3)_insertValues_tblPPTOutputCombine.sql" 1>"report\log\run(3)_insertValues_tblPPTOutputCombine.log" 2>"report\log\error_run(3)_insertValues_tblPPTOutputCombine.log"
osql -r -S 172.20.0.82 -U sa -P love2you -d BMSChina_PPT -i "report\run(4)_Patch.sql" 1>"report\log\run(4)_Patch.log" 2>"report\log\error_run(4)_Patch.log"




