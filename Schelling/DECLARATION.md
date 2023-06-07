# Schelling's segregation model

An archetypical example of an agent based model with very simple dynamics.
This model tests the performance of the two most basic operations any ABM will use: searching for nearest neighbors and moving agents. Two versions are simulated: a large one, with a higher density and a bigger radius, and a small one, with a lower density and a smaller radius.

## Rules of the ABM

- Agents live in a `X` by `X` rectangular discrete space. The space is finite and not periodic.
- Only a single agent can occupy a position in the grid.
- Agents must have at least the following properties: a unique id identifying them, their position, an integer specifying which group agents belong to, and a boolean flag indicating whether an agent is happy.
- There are `K` agents in the model, `0.5K` of group 1 and `0.5K` of group 2. All agents are initialized at random locations and with the happy boolean being `false`.
- The agents are activated in random order, so that at each step the order may change.
- At each step of the simulation each agent performs the following actions:
  - If the `happy` property is `true`, it does nothing. Otherwise:
  - Searches the nearby positions within the specified radius in the discrete grid for neighbors. Saying the same thing with mathematically specificity, the agent searchers for neighbors in a radius `r` in Chebyshev metric around it.
  - It iterates through the found neighbors and counts how many of the neighbors are belonging to the same group.
  - If that number is equal or greater than the model property "minimum to be happy", the agent sets its own happy boolean flag to `true`, otherwise, then the agent moves to a random unoccupied location on the grid.
- The simulation runs for 20 steps.

## Technical details

- It must be enforced by either the framework or by the implementation that only one agent can occupy a position.
- Even though the Schelling model can be implemented as a cellular automaton, all implementations must explicitly use agent entities, specified by unique ID, occupying a unique position in the grid. The agents must move around the space without being deleted from memory and then created elsewhere.
- Even though it remains a constant during the simulation, the model property denoting "minimum to be happy" must be set during model creation and must be accessed from the model during model evolution.
- For the small model, `X = 40`, `K = 1000`, `r = 1` and `minimum_to_be_happy = 3`.
- For the large model, `X = 100`, `K = 8000`, `r = 2` and `minimum_to_be_happy = 8`.
