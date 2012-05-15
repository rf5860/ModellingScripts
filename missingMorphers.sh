#!/bin/sh
morphers=$(find el_jsc/jsc/m8MWP/m8MWPGenerated/ -iname *dtomorpher.java);

for file in $(find el_jsc/jsc/m8MWP/m8MWPGenerated/ -iname *dtotype.java); do
    fullName=$(echo $file | cut -d'/' -f 12);
    trimName=${fullName:0:${#fullName}-12};
    grep -q ${trimName} $morphers;
    if [ $? -ne 0 ]
    then
	echo "Missing expected Morpher $fullName";
    fi
done;