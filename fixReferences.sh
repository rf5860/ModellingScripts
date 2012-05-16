#!/bin/sh
tempTypesFile=types.txt
function sedeasy {
  sed -i "s/$(echo $1 | sed -e 's/\([[\/.*]\|\]\)/\\&/g')/$(echo $2 | sed -e 's/[\/&]/\\&/g')/g" $3
}

grep -r " href=\"[\.\./]\+Module" el_model/UMLModel/Module-8MWP > $tempTypesFile
sort $tempTypesFile | uniq > ${tempTypesFile}.bak && mv ${tempTypesFile}.bak $tempTypesFile

while read line; do
    file=$(echo $line | cut -d':' -f1);
    path=${file%/*};
    expectedFile=$(echo ${line#*href} | cut -d'=' -f2|cut -d'#' -f1|cut -d'"' -f2);
    rawId=$(echo $line | cut -d'#' -f2|cut -d'?' -f1)
    id='xmi:id="'$(echo $line | cut -d'#' -f2|cut -d'?' -f1)'"';
    grep -q $id ${path}'/'${expectedFile}
    if [ $? -ne 0 ]
    then
	actualMatch=$(grep -r $id el_model/UMLModel/*)
	foundPath=$(echo $actualMatch|cut -d':' -f1)
	relativePath=${expectedFile%../*}../
	parentSep=${expectedFile%../*}../
	relativeFound=${parentSep}${foundPath:18}

	sedeasy "href=\"${expectedFile}#${rawId}" "href=\"${relativeFound}#${rawId}" "$file"
    fi
done < $tempTypesFile