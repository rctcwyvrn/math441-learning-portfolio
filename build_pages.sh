#!/usr/bin/bash

rm -r site/content/post/*

# copy the markdowns
cp graph_coloring_and_register_allocation.md site/content/post/graph_coloring_and_register_allocation.md
cp optimal_transport.md site/content/post/optimal_transport.md
cp cover.md site/content/post/cover.md

# build the jupyter notebook htmls, add the frontmatters

jupyter nbconvert --to html alternative_nearest_neighbours.ipynb
echo "+++" > site/content/post/alternative_nearest_neighbours.html
echo "title = \"Alternative nearest neighbours algorithms\"" >> site/content/post/alternative_nearest_neighbours.html
echo "+++" >> site/content/post/alternative_nearest_neighbours.html
cat alternative_nearest_neighbours.html >> site/content/post/alternative_nearest_neighbours.html
# patch the black colored box
python patch.py site/content/post/alternative_nearest_neighbours.html
rm alternative_nearest_neighbours.html

jupyter nbconvert --to html cryptography_and_lattices.ipynb
echo "+++" > site/content/post/cryptography_and_lattices.html
echo "title = \"Knapsack problems, cryptography, and lattices\"" >> site/content/post/cryptography_and_lattices.html
echo "+++" >> site/content/post/cryptography_and_lattices.html
cat cryptography_and_lattices.html >> site/content/post/cryptography_and_lattices.html
python patch.py site/content/post/cryptography_and_lattices.html
rm cryptography_and_lattices.html

jupyter nbconvert --to html how_does_linprog_ip_work.ipynb
echo "+++" > site/content/post/how_does_linprog_ip_work.html
echo "title = \"Solving mixed-integer linear programming problems\"" >> site/content/post/how_does_linprog_ip_work.html
echo "+++" >> site/content/post/how_does_linprog_ip_work.html
cat how_does_linprog_ip_work.html >> site/content/post/how_does_linprog_ip_work.html
python patch.py site/content/post/how_does_linprog_ip_work.html
rm how_does_linprog_ip_work.html

jupyter nbconvert --to html smaller_network_matrix_tests.ipynb
echo "+++" > site/content/post/smaller_network_matrix_tests.html
echo "title = \"Exploring a smaller matrix representation of network flows\"" >> site/content/post/smaller_network_matrix_tests.html
echo "+++" >> site/content/post/smaller_network_matrix_tests.html
cat smaller_network_matrix_tests.html >> site/content/post/smaller_network_matrix_tests.html
python patch.py site/content/post/smaller_network_matrix_tests.html
rm smaller_network_matrix_tests.html

# copy over the static animations
mkdir site/content/post/graph_coloring_animations/
cp graph_coloring_animations/static/* site/content/post/graph_coloring_animations/
# cp graph_coloring_animations_notes.md site/content/post/