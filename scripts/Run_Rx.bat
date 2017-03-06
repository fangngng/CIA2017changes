osql -r -S 172.20.0.4 -U sa -P love2you -d BMSChinaMRBI -i "Rx\0_DataPrepare.sql" 1>"Rx\log\0_DataPrepare.log" 2>"Rx\log\error_0_DataPrepare.log"


osql -r -S 172.20.0.4 -U sa -P love2you -d BMSChinaMRBI -i "Rx\1_DataProcessing.sql" 1>"Rx\log\1_DataProcessing.log" 2>"Rx\log\error_1_DataProcessing.log"
osql -r -S 172.20.0.4 -U sa -P love2you -d BMSChinaMRBI -i "Rx\2_1_OutputRx_bak.sql" 1>"Rx\log\2_1_OutputRx_bak.log" 2>"Rx\log\error_2_1_OutputRx_bak.log"
osql -r -S 172.20.0.4 -U sa -P love2you -d BMSChinaMRBI -i "Rx\2_2_OutputRx_Final.sql" 1>"Rx\log\2_2_OutputRx_Final.log" 2>"Rx\log\error_2_2_OutputRx_Final.log"



REM exp
osql -r -S 172.20.0.82 -U sa -P love2you -d BMSChina_PPT -i "Rx\99_Export_Rx.sql" 1>"Rx\log\99_Export_Rx.log" 2>"Rx\log\error_99_Export_Rx.log"






