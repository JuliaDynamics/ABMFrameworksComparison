# Schelling's segregation

An archetypical example of an agent based model with very simple dynamics.

## Rules of the ABM

- Agents live in a 40 by 40 rectangular discrete space. The space is finite, not periodic.
- There is a model level property "minimum to be happy" that is by default 3.
- Only a single agent can occupy a position in the grid.
- Agents must have at least the following properties: a unique id identifying them, their position, an integer specifying which group agents belong to, and a boolean flag indicating whether an agent is happy.
- There are 1,000 agents in the model 500 of group 1 and 500 of group 2. All agents are initialized at random locations and with the happy boolean being `false`.
- The activation order of the agents does not matter; each framework may use the fastest possible implementation.
- At each step of the simulation, all agents are activated in sequence one by one. Each agent performs the following actions:
  - If the `happy` property is `true`, it does nothing. Otherwise:
  - Searches the nearby 8 positions in the discrete grid for neighbors. Saying the same thing with mathematically specificity, the agent searchers for neighbors in a radius 1 in Chebyshev metric around it.
  - It iterates through the found neighbors and counts how many of the neighbors are belonging to the same group.
  - If that number is equal or greater than the "minimum to be happy" model property, then the agent sets its own happy boolean flag to `true`.
  - If not, then the agent moves to a random unoccupied location on the grid.
- The simulation continues until all agents become happy. The simulation must terminate once this condition is met, and not terminate after a pre-determined number of steps.


## Technical details

- It must be enforced by either the framework or by the code implementation that only one agent can occupy a position.
- Even though the Schelling model can be implemented as a cellular automaton, all implementations must explicitly use agent entities, specified by unique ID, and occupying a unique slot in the computer memory. The agents must move around the space without being deleted from memory and then created elsewhere.
- Even though it remains a constant during the simulation, the model property denoting "minimum to be happy" must be set during model creation and must be accessed from the model during model evolution.