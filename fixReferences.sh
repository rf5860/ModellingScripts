#!/bin/sh
tempTypesFile=types.txt

grep -r "<type xmi:type=\"uml:Class\"" el_model/UMLModel/Module-8MWP > $tempTypesFile
while read line; do
    file=$(echo $line | cut -d':' -f1);
    path=${file%/*};
    expectedFile=$(echo $line | cut -d'=' -f3|cut -d'#' -f1|cut -d'"' -f2);
    id='_'$(echo $line | cut -d'_' -f3|cut -d'?' -f1);
    grep -q $id ${path}'/'${expectedFile}
    if [ $? -ne 0 ]
    then
	echo "Bad reference for:";
	echo $line
    fi
done < $tempTypesFile