#!/bin/bash
## downloads changes from a remote git repository

cd $1
git fetch --all && \
git pull --all
cd ~-
