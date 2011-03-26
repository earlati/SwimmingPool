#!/bin/bash 
# ================================
# FILE : swim.sh
# copy in /cgi-bin/swim.sh
# ================================

( cd ../SwimmingPool
perl -Ilib  ./lib/SwimmingPool.pl
)
