# Ecosystem dynamics: Wolf Sheep Grass

This is an archetypical ABM implementation of traditional predator-prey-like ecosystem models in a discrete space.
When compared to the Schelling model, this example tests the performance of handling agents of different types, as well as dynamic birth-death of new-old agents.

Two versions are simulated: a large one and a small one, in the larger one the size of the grid, the number of agents, the reproduction rate of the Sheeps and the Wolves and  the growth rate of the Grass are larger.

## Rules of the ABM

The model consists of: Sheeps, Wolves, and Grass. Sheeps and Wolfs are agents that move around and generate offsprings. Grass is a spatial property (each cell of the space has grass that does not move around).

- The sheeps and wolves have identical property names: a unique id (int) specifier, their position (2-int tuple), an energy (64-bit float), a reproduction probability (64-bit float), and a Δ-energy (64-bit float).
- Grass as a boolean flag of whether it is fully grown, a countdown (int) of time to regrowth, and a regrowth time (int) that is a global constant.
- Default values for all these properties can be seen at the technical implementation below.
- At the setup phase the model is populated randomly with sheep and wolves with energies randomly chosen between 1 and their 2*(δ-energy).
- The grass is initialized with half fully grown, and the other half with a count down value between 1 and the regrowth time.
- The simulation proceeds in steps. At each step first all sheeps activate (in random order, uniquely random each time), then all wolves (in random order), and then all grass (activation order of grass does not matter):
  - Sheeps:
    - Perform 1 random walk (randomly move to any of the 8 adjacent squares).
    - Lose 1 energy.
    - Eat grass if possible: if the grass is in the position of the sheep and it is currently fully grown, the sheep eats the grass and gains energy equal to its Δ-energy. The grass then becomes not fully grown and gains a countdown timer equal to the global constant regrowth time.
    - If the energy of the sheep is less than 1: die.
    - Else, if a random number is less than the reproduction probability: reproduce. (see below)
  - Wolves:
    - perform 1 random walk.
    - lose 1 energy.
    - Eat a sheep: search its current box for sheeps. Eat one of the sheep if any, removing it from the model and increasing own energy by the Δ-energy.
    - If energy is less than 0, die (remove wolf from model).
    - Else, reproduce (see below).
  - Grass:
    - All model positions decrease the grass countdown timer. If it reaches 0 the grass becomes fully grown at this location (do nothing for grass that is already fully grown).
  - Reproduction: the agent reproduction halves its energy creating an offspring with identical properties except for the ID property which must be set by the framework to be unique.
- The simulation runs for 100 steps.

## Technical implementation
The wolves and sheeps must be different agents, in the sense that they should be different types/classes/datastructures, this is done since this benchmark tries to analyze the performance of a multi-type ABM model. Grass can be modelled in whatever way each framework can do in the most performant way, to allow for optimizations regarding handling spatial properties.

Defaults that are the same for small or large simulation:

- Δenergy for sheep eating grass: 5
- Δenergy for wolf eating sheep: 13

Defaults for small simulation:

- init number of sheeps: 60
- init number of wolves: 40
- grass regrowth time: 20
- reproduction rate of sheeps: 0.2
- reproduction rate of wolves: 0.1
- dimensions of the grid: (25, 25)

Defaults for large simulation:

- init number of sheeps: 1000
- init number of wolves: 500
- grass regrowth time: 10
- reproduction rate of sheeps: 0.4
- reproduction rate of wolves: 0.2
- dimensions of the grid: (100, 100)
