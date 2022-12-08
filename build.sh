#!/usr/bin/bash

# commit changes to LP articles
git add -A 
git commit -m "Update learning portfolio"

# build all the content
./build_pages.sh

# build and copy files
mkdir docs
cd site
hugo
cp -r public/* ../docs

# commit
git add -A
git commit -m "Build pages"
git push

# update master with new pages
git checkout master
git checkout gh-pages alternative_nearest_neighbours.ipynb
git checkout gh-pages cryptography_and_lattices.ipynb
git checkout gh-pages how_does_linprog_ip_work.ipynb
git checkout gh-pages smaller_network_matrix_tests.ipynb
git checkout gh-pages cover.md
git checkout gh-pages optimal_transport.md
git checkout gh-pages graph_coloring_animations_notes.md

git commit -m "Update master"
git push
git checkout gh-pages