#!/bin/bash

cnewer="newer.time";

# find . -name "*.jpg" -cnewer $cnewer -exec echo "Processing file: {} "  \;
# find . -name "*.jpg" -cnewer $cnewer -exec convert {} -resize 1200x1716 -quality 20  {}  \;

find . -name "*.jpg" -cnewer $cnewer \
             -exec echo "Processing file: {} "  \; \
             -exec convert {} -resize 1200x1716 -quality 20  {}  \;   


touch $cnewer


