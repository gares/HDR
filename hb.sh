#!/bin/bash
#set -x
set -e

GET_TAGS="git tag --sort=creatordate"

declare -A DATE=( ["1.1"]="2008-03-18" ["1.2"]="2009-08-14" ["1.3"]="2011-03-11" ["1.4"]="2012-09-05" ["1.5"]="2014-03-11")


cd mc-old/
rm -rf ./ss*/ ./ma*/ ./xx-*/ 
for a in 1.1  1.2  1.3  1.4; do
    tar -xzf ssreflect-$a*z
    cd ./ssr*/
    LOC=`find theories -name \*.v | xargs cat | wc -l`
    printf "%s ($a),%d,%d,%d\n" "${DATE[$a]}" "`grep ^Structure theories/*.v|wc -l`" "0" "$LOC"
    cd ..
    mv ./ssr*/ ./xx-$a
done
for a in 1.5; do
    tar -xzf ssreflect-$a*z
    tar -xzf mathcomp-$a*z
    mv mathco*/theories/*.v ssr*/theories/
    rm -rf mathco*/
    cd ./ssr*/
    LOC=`find theories -name \*.v | xargs cat | wc -l`
    printf "%s ($a),%d,%d,%d\n" "${DATE[$a]}" "`grep ^Structure theories/*.v|wc -l`" "0" "$LOC"
    cd ..
    mv ./ssr*/ ./xx-$a
done
rm -rf mc-old/xx-*/
cd ~/MATHCOMP/math-comp/
git checkout master -q
git pull -q
TAGS="`$GET_TAGS | grep -v odd-order | grep -v archive | grep -v beta1 | grep -v '[^0]$' | grep -v mathcomp-1.1[6789].0`"
for t in $TAGS; do
    git checkout -q -b tmp $t
    LOC=`find . -name \*.v | grep -v order.v | xargs cat | wc -l`
    git checkout -q master
    git branch -q -D tmp
    T=`echo ${t##mathcomp-} | sed 's/.0$//'`
    printf "%s ($T),%d,%d,%d\n" "`git log -1 --format=%as $t`" "`git grep ^Structure $t|wc -l`" "`git grep HB.structure $t|wc -l`" "$LOC"
done
echo "-------------------"
cd ~/MATHCOMP/analysis/
git checkout master -q
git pull -q
TAGS="`$GET_TAGS |grep -v ^v`"
for t in $TAGS; do
    git checkout -q -b tmp $t
    LOC=`find . -name \*.v | xargs cat | wc -l`
    git checkout -q master
    git branch -q -D tmp
    printf "%s (${t}),%d,%d,%d\n" "`git log -1 --format=%as $t`" "`git grep ^Structure $t|wc -l`" "`git grep HB.structure $t|wc -l`" $LOC
done
