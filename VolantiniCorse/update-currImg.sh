#!/bin/bash

dt='2012.12.*'
dt=${1:-$dt}

echo "images ${dt}-*.jpg "

nfiles=0
for f in images/${dt}-*.jpg
do
  echo "using file: $f "
  nfiles=$(( $nfiles + 1 ))
done

echo "nfiles $nfiles "

if [ $nfiles -eq 1 ]
then
   cp images/${dt}-*.jpg currImg.jpg
else
   montage -verbose -mode concatenate -texture images/${dt}-*.jpg -tile 3x4 currImg.jpg
fi

convert currImg.jpg  -quality 2 currImg.jpg
ls -la currImg.jpg
