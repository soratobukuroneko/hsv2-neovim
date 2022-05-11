#!/bin/sh
cd "`dirname $0`"
git stash push
git checkout master &&\
git pull &&\
git checkout localconf &&\
git rebase master
git stash pop
