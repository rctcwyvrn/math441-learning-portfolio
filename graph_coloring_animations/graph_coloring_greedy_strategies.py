from tkinter import N
from flask import Flask, render_template, redirect, request
import networkx as nx
import matplotlib.pyplot as plt
import matplotlib.animation as animation
import hashlib

app = Flask(__name__)

STRATEGIES = {
    "largest_first": nx.algorithms.coloring.strategy_largest_first,
    "random_sequential": nx.algorithms.coloring.strategy_random_sequential,
    "smallest_last": nx.algorithms.coloring.strategy_smallest_last,
    "independent_set": nx.algorithms.coloring.strategy_independent_set,
    "connected_sequential_bfs": nx.algorithms.coloring.strategy_connected_sequential_bfs,
    "connected_sequential_dfs": nx.algorithms.coloring.strategy_connected_sequential_dfs,
}

@app.context_processor
def inject_strategies():
    def hash_file(filename):
        return hashlib.md5(open("static/" + filename, "rb").read(20)).hexdigest()
    return dict(STRATEGIES=STRATEGIES, hash=hash_file)

def draw_animation_for_ordering(G, name, strategy):
    coloring = nx.greedy_color(G, strategy=strategy)
    ordering = list(strategy(G, None))
    fig,ax = plt.subplots()
    fig.set_size_inches(6,6)
    max_color= max(coloring.values()) + 1
    def plot_first_i(i):
        # clear current plot
        ax.clear()

        # plot new coloring
        first_i = ordering[:i]
        mapping = [coloring[n] + 1 if n in first_i else 0 for n in range(len(G.nodes))]
        nx.draw_networkx(G, with_labels=True, node_color=mapping, pos = nx.circular_layout(G), ax=ax, cmap="Spectral", vmin=0,  vmax=max_color)
    anim = animation.FuncAnimation(fig, plot_first_i, frames=len(G.nodes)+1)
    anim.save(f"static/{name}_animation.mp4", fps=2)
    ax.clear()
    mapping = [coloring[n] + 1 for n in range(len(G.nodes))]
    nx.draw_networkx(G, with_labels=True, node_color=mapping, pos = nx.circular_layout(G), ax=ax, cmap="Spectral", vmin=0,  vmax=max_color)
    fig.savefig(f"static/{name}_final.png")

def generate_new_animations(n, m):
    G = nx.dense_gnm_random_graph(n, m)
    for name, strategy in STRATEGIES.items():
        draw_animation_for_ordering(G, name, strategy)

@app.route("/new", methods=['POST'])
def new():
    n = int(request.form['n'])
    m = int(request.form['m'])
    generate_new_animations(n, m)
    return redirect("/")

@app.route("/")
def index():
    return render_template('template.html')

if __name__ == "__main__":
    # generate_new_animations(8, 12)
    app.run(host="localhost", port=8000, debug=True)