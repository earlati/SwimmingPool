#!/bin/bash
# ======================================
# FILE: add-file2git.sh 1.000 2010.02.07
# ======================================

find . -type f -name "*.pl" -exec git add {} \;
find . -type f -name "*.pm" -exec git add {} \;

find . -type f -name "*.conf" -exec git add {} \;
find . -type f -name "*.PL" -exec git add {} \;
find . -type f -name "*.t" -exec git add {} \;
find . -type f -name "*.tt" -exec git add {} \;
find . -type f -name "*.sh" -exec git add {} \;
find . -type f -name "*.txt" -exec git add {} \;
find . -type f -name "*.sql" -exec git add {} \;
find . -type f -name "README" -exec git add {} \;


