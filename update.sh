#!/bin/sh
cd "`dirname $0`"
git checkout master &&\
git pull &&\
git checkout localconf &&\
git rebase master
