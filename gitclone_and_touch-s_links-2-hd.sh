#!/bin/bash

git_url=git@github.com:mg4v
name_sums=my-sums_4_it
name_scripts=my_bash_scripts
repo_dir=$HOME/Documents/REPO

mkdir $repo_dir
cd $repo_dir
for dirs in $name_sums $name_scripts ; do
  git clone $git_url/$dirs
done

cd $HOME

for items in $repo_dir $repo_dir/$name_sums $repo_dir/$name_scripts ; do
  if [ -d $items ] ; then
    ln -s $items
  else
    echo "No directory has been created for the $items"
  fi
done    
