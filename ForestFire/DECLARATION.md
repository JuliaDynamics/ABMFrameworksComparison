# Forest fire propagation model

A basic ABM that specifically targets simulating cellular automata. Two versions are simulated: a large one, with a higher density of trees, and a small one, with a lower density of tres.

Because this is a cellular automaton (all possible positions are occupied by exactly 1 agent which never moves), it is up to the framework to decide the implementation. The declaration below refers to "trees", under the assumption that each unique cell in space could be one unique agent or whatever else the framework uses, since "trees" and "unique positions in space" can be considered the same thing here.

## Rules of the ABM

- The space is a 2D rectangular grid of dimension `(X, X)`, i.e,. of `X` times `X` trees.
- Each tree has an integer property corresponding to the status of the occupying trees: 0 = empty, 1 = green, 2 = burning, 3 = burnt.
- At initialization, a `density` vallue in the interval (0, 1) is provided.
- For each cell, a random number is drawn. If it is less than `density`, the cell becomes green (1).
- All cells of the left-most column are set to burning (2).
- The simulation starts. At each step:
  - All trees that are burning try to propagate their fire: they search for their four nearest neighbors and if any are green, they become on fire (1 -> 2). Said with mathematical specificity, the neighbor search happens with radius 1 in manhattan distance.
  - These burning trees then become burnt (2 -> 3).
- The simulation runs for 100 steps.

## Technical implementation

- For the small model, `X = 100` and `density = 0.7`.
- For the large model, `X = 500` and `density = 0.9`.
- The implementation in each software doesn't actually have to use agents; use whatever means the software has to accelerate cellular automata simulations.
