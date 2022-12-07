#!/usr/bin/bash

# commit changes to LP articles
git add -A 
git commit -m "Update learning portfolio"
git push

# build to branch
git checkout gh-pages

# merge together
git merge master --no-edit

# clear posts
rm -r site/content/post/*

# copy the markdowns
cp graph_coloring_and_register_allocation.md site/content/post/graph_coloring_and_register_allocation.md
cp optimal_transport.md site/content/post/optimal_transport.md

# build the jupyter notebook htmls, add the frontmatters

jupyter nbconvert --to html alternative_nearest_neighbours.ipynb
echo "+++" > site/content/post/alternative_nearest_neighbours.html
echo "title = \"Learning portfolio: Alternative nearest neighbours algorithms\"" >> site/content/post/alternative_nearest_neighbours.html
echo "+++" >> site/content/post/alternative_nearest_neighbours.html
cat alternative_nearest_neighbours.html >> site/content/post/alternative_nearest_neighbours.html
# patch the black colored box
python patch.py site/content/post/alternative_nearest_neighbours.html
rm alternative_nearest_neighbours.html

jupyter nbconvert --to html cryptography_and_lattices.ipynb
echo "+++" > site/content/post/cryptography_and_lattices.html
echo "title = \"Learning portfolio: Knapsack problems, cryptography, and lattices\"" >> site/content/post/cryptography_and_lattices.html
echo "+++" >> site/content/post/cryptography_and_lattices.html
cat cryptography_and_lattices.html >> site/content/post/cryptography_and_lattices.html
python patch.py site/content/post/cryptography_and_lattices.html
rm cryptography_and_lattices.html

jupyter nbconvert --to html how_does_linprog_ip_work.ipynb
echo "+++" > site/content/post/how_does_linprog_ip_work.html
echo "title = \"Learning portfolio: Solving mixed-integer linear programming\"" >> site/content/post/how_does_linprog_ip_work.html
echo "+++" >> site/content/post/how_does_linprog_ip_work.html
cat how_does_linprog_ip_work.html >> site/content/post/how_does_linprog_ip_work.html
python patch.py site/content/post/how_does_linprog_ip_work.html
rm how_does_linprog_ip_work.html

jupyter nbconvert --to html smaller_network_matrix_tests.ipynb
echo "+++" > site/content/post/smaller_network_matrix_tests.html
echo "title = \"Learning portfolio: Exploring a smaller matrix representation of network flows\"" >> site/content/post/smaller_network_matrix_tests.html
echo "+++" >> site/content/post/smaller_network_matrix_tests.html
cat smaller_network_matrix_tests.html >> site/content/post/smaller_network_matrix_tests.html
python patch.py site/content/post/smaller_network_matrix_tests.html
rm smaller_network_matrix_tests.html

# jank for now

echo "+++" > site/content/post/graph_coloring_animations.md
echo "title = \"Learning portfolio: Graph coloring animations\"" >> site/content/post/graph_coloring_animations.md
echo "+++" >> site/content/post/graph_coloring_animations.md
echo "" >> site/content/post/graph_coloring_animations.md
echo "\`\`\`python" >> site/content/post/graph_coloring_animations.md
cat graph_coloring_animations/graph_coloring_greedy_strategies.py >> site/content/post/graph_coloring_animations.md
echo "" >> site/content/post/graph_coloring_animations.md
echo "\`\`\`" >> site/content/post/graph_coloring_animations.md

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