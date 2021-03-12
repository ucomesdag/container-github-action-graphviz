#!/bin/sh

for file in $(ls *.dot) ; do
  dot ${file} -Tpng -o ${file%.*}.png
  mogrify -filter spline -unsharp 0x1 -normalize -resample 96 -scale 25% -quality 100 ${file%.*}.png
done
