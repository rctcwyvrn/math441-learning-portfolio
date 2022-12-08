#!/usr/bin/bash

# commit changes to LP articles
git add -A 
git commit -m "Update learning portfolio"
git push

# build to branch
git checkout gh-pages

# merge together
git merge master --no-edit

# build all the content
./build_pages.sh

# build and copy files
mkdir docs
cd site
hugo
cp -r public/* ../docs

# commit
git add -A
git commit -m "publish page"
git push

git checkout master