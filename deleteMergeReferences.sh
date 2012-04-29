#!/bin/sh
for file in $(git grep -l merge_file el_model/UMLModel/Module-8MWP*)
do
    sed -i '/merge_file/d' $file
done