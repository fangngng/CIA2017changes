REM osql -r -S 172.20.0.4 -U sa -P love2you -d BMSChinaMRBI -i "CPA\0_1_Import.sql" 1>"CPA\log\0_1_Import.log" 2>"CPA\log\error_0_1_Import.log"
REM osql -r -S 172.20.0.4 -U sa -P love2you -d BMSChinaMRBI -i "CPA\1_1_ProdDef.sql" 1>"CPA\log\1_1_ProdDef.log" 2>"CPA\log\error_1_1_ProdDef.log"


osql -r -S 172.20.0.4 -U sa -P love2you -d BMSChinaMRBI -i "CPA\1_2_MktDef.sql" 1>"CPA\log\1_2_MktDef.log" 2>"CPA\log\error_1_2_MktDef.log"
osql -r -S 172.20.0.4 -U sa -P love2you -d BMSChinaMRBI -i "CPA\2_1_MID.sql" 1>"CPA\log\2_MID.log" 2>"CPA\log\error_2_MID.log"
osql -r -S 172.20.0.4 -U sa -P love2you -d BMSChinaMRBI -i "CPA\2_2_MID_R640.sql" 1>"CPA\log\2_2_MID_R640.log" 2>"CPA\log\error_2_2_MID_R640.log"
osql -r -S 172.20.0.4 -U sa -P love2you -d BMSChinaMRBI -i "CPA\3_1_Out.sql" 1>"CPA\log\3_1_Out.log" 2>"CPA\log\error_3_1_Out.log"
osql -r -S 172.20.0.4 -U sa -P love2you -d BMSChinaMRBI -i "CPA\3_2_Out_Onglyza.sql" 1>"CPA\log\3_2_Out_Onglyza.log" 2>"CPA\log\error_3_2_Out_Onglyza.log"
osql -r -S 172.20.0.4 -U sa -P love2you -d BMSChinaMRBI -i "CPA\3_3_Out_R530.sql" 1>"CPA\log\3_3_Out_R530.log" 2>"CPA\log\error_3_3_Out_R530.log"
osql -r -S 172.20.0.4 -U sa -P love2you -d BMSChinaMRBI -i "CPA\3_4_Out_Eliquis_R640.sql" 1>"CPA\log\3_4_Out_Eliquis_R640.log" 2>"CPA\log\error_3_4_Out_Eliquis_R640.log"
osql -r -S 172.20.0.4 -U sa -P love2you -d BMSChinaMRBI -i "CPA\3_5_Eliquis_NOAC_CPA.sql" 1>"CPA\log\3_5_Eliquis_NOAC_CPA.log" 2>"CPA\log\error_3_5_Eliquis_NOAC_CPA.log"
osql -r -S 172.20.0.4 -U sa -P love2you -d BMSChinaMRBI -i "CPA\4_1_Out_Finall.sql" 1>"CPA\log\4_1_Out_Finall.log" 2>"CPA\log\error_4_1_Out_Finall.log"
osql -r -S 172.20.0.4 -U sa -P love2you -d BMSChinaMRBI -i "CPA\4_2_Out_afterDeal.sql" 1>"CPA\log\4_2_Out_afterDeal.log" 2>"CPA\log\error_4_2_Out_afterDeal.log"

REM exp
REM osql -r -S 172.20.0.33 -U sa -P love2you -d BMSChina_PPT -i "CPA\99_Export_CPA.sql" 1>"CPA\log\99_Export_CPA.log" 2>"CPA\log\error_99_Export_CPA.log"



