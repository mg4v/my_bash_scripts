#!/bin/bash
cd $1
git add . && git commit -m 'automatic_commit' && git push
cd ~-
