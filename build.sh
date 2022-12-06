# clear posts
rm -r site/content/post/*

.# copy the markdowns
cp graph_coloring_and_register_allocation.md site/content/post/graph_coloring_and_register_allocation.md
cp optimal_transport.md site/content/post/optimal_transport.md

# build the jupyter notebook htmls, add the frontmatters

jupyter nbconvert --execute --to html alternative_nearest_neighbours.ipynb.ipynb
echo "+++" > site/content/post/alternative_nearest_neighbours.html
echo "title = \"Learning portfolio: Alternative nearest neighbours algorithms\"" >> site/content/post/alternative_nearest_neighbours.html
echo "+++" >> site/content/post/alternative_nearest_neighbours.html
cat alternative_nearest_neighbours.html >> site/content/post/alternative_nearest_neighbours.html