#!/bin/bash
files=$(find . -type d -regex '\./[A-Za-z]*')
DIR="./assets"

for file in $files; do
    baseName=$(echo "$file" | sed 's|[\.\/]||g')
    ./AutoGenerate.py $file > ../draw$baseName.v
    echo $file "has been generated."
done;

find *~ -exec rm {} \;
echo 'Temporary files cleaned!'
