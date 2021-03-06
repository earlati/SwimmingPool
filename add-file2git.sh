#!/bin/bash
# ======================================
# FILE: add-file2git.sh 1.003 11.07.2011
# ======================================

dir=$( dirname $0 )

git add $0

(
cd "$dir" 
git add geany.project
git add appunti.swimmingpool.txt

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
find . -type f -name "*.css" -exec git add {} \;
find . -type f -name "*.js" -exec git add {} \;
find . -type f -name "*.html" -exec git add {} \;

)

echo "NOW: git commit -am '<comment here>' "
echo "   : git push origin "
echo "   : git push gitorious "
