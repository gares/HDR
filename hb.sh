#!/bin/bash
#set -x
set -e

GET_TAGS="git tag --sort=creatordate"

cd ~/MATHCOMP/math-comp/
git checkout master
git pull
TAGS="`$GET_TAGS | grep -v odd-order | grep -v archive | grep -v mathcomp-1.1[6789].0` `git describe --tags`"
for t in $TAGS; do
    printf "%s (${t##mathcomp-}),%d,%d\n" "`git log -1 --format=%as $t`" "`git grep ^Structure $t|wc -l`" "`git grep HB.structure $t|wc -l`"
done

cd ~/MATHCOMP/analysis/
git checkout master
git pull
TAGS="`$GET_TAGS |grep -v ^v` `git describe --tags`"
for t in $TAGS; do
    printf "%s ($t),%d,%d\n" "`git log -1 --format=%as $t`" "`git grep ^Structure $t|wc -l`" "`git grep HB.structure $t|wc -l`"
done
