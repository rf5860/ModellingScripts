#!/bin/sh
for file in $(find el_model/UMLModel/Module-8MWP/ -name "*.efx")
do
    uniq $file > $file.bak && mv $file.bak $file
done