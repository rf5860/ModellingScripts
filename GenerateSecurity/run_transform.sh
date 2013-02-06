#!/usr/bin/sh

securityDirectory=/c/RIATransform/UML2SecurityGenerated
files=("MSF02K_CORE" "MSF02L_CORE" "MSF02M_CORE" "MSF02N_CORE" "MSF02P_CORE" "MSF02Q_CORE" "MSF02R_CORE" "MSF02S_CORE" "MSF02T_CORE")
rm *.sql
for i in "${files[@]}"
do
    msxsl.exe $securityDirectory/$i.xml transform.xsl -o $i.sql
    cat $i.sql >> ALL_TABLES.sql
done