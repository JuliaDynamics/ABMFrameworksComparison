# Flocking model

An archetypical model of flocking behaviour of animals in continuous space. It is meant to test the performance of the software in continuous space: handling 64-bit floats, moving agents, searching for nearby agents.

Note that there are two versions of this model, a "small" and a "large" one. The difference in the large is that the space extent, visual distance, and number of agents, are larger.

The flock model illustrates how flocking behaviour can emerge when each bird follows three simple rules:

* maintain a minimum distance from other birds to avoid collision
* fly towards the average position of neighbors
* fly in the average direction of neighbors

## Rules of the ABM

- Agents live in a 2 dimensional continuous space. This means that agent position is a 64 bit float and the the extent of the space the agents live in is also a 64 bit float.
- The space is periodic in both directions: if an agent were to move outside the space extent, the agent wraps back to the other side. Additionally, when searching for nearby agents, the periodicity of the space must be respected.
- Agents represents birds trying to flock. They have many properties that are listed below, including the type each property should have. See the technical implementation below for default values.  (the properties may be named arbitrarily by each implementation)
  - `ID`, integer, a unique identifier for each agent
  - `pos`, a tuple/vector of 2 64-bit floats, the position of the agent
  - `vel`, a tuple/vector of 2 64-bit floats, the velocity of the agent. The rules of the ABM enforce vel to always be a unit vector
  - `speed`, 64-bit number, the speed of the agent (magnitude of velocity). Defines how much an agent will move in one simulation step.
  - `separation`, 64-bit real, defines the minimum distance a bird must maintain from its neighbors.
  - `visual_distance` refers to the distance a bird can see and defines a radius of neighboring birds.
  - `cohere_factor`, 64-bit number, is the importance of maintaining the average position of neighbors,
  - `match_factor`, 64bit real, is the importance of matching the average trajectory of neighboring birds,
  - `separate_factor`, 64bit float,  is the importance of maintaining the minimum distance from neighboring birds.
- Agents are activated in sequence one by one in a random order (a new random order must be generated at each step of the simulation). Once activated, each agent does the following:
  - Finds all neighbors within its visual distance (i.e., finds all neighbors with Euclidean distance less or equal to the number specified by the visual distance).
  - Three orientation vectors are generated from the neighbors: a coherence, matching, and a separation vector. How these vectors are generated is actually simpler to show in code, see technical implementation below.
  - The agent updates its velocity based on the three orientation vectors and its own velocity as the average of the four vectors. The velocity vector is then normalized to unit length.
  - The agent moves according the direction of its velocity vector for length given by the `speed` agent property.
  - The simulation is performed for a fixed amount of steps.

## Technical implementation

The simulation is performed for exactly 100 steps.


Defaults that are the same for small or large simulation:

- speed of birds: 1.0
- cohere factor of birds: 0.03
- separation of birds: 1.0
- separate factor of birds: 0.015
- match factor of birds: 0.05

Defaults for small simulation:

- dimensions of the space: (100, 100)
- number of birds: 200
- visual distance of birds: 5.0

Defaults for large simulation:

- dimensions of the space: (150, 150)
- number of birds: 400
- visual distance of birds: 15.0

Here is the code for the update rule of the flocking behaviour in Agents.jl:
```julia
function flocking_agent_step!(bird, model)
    neighbor_ids = nearby_ids(bird, model, bird.visual_distance)
    N = 0
    match = separate = cohere = (0.0, 0.0)
    for id in neighbor_ids
        N += 1
        neighbor = model[id].pos
        heading = neighbor .- bird.pos
        cohere = cohere .+ heading
        if euclidean_distance(bird.pos, neighbor, model) < bird.separation
            separate = separate .- heading
        end
        match = match .+ model[id].vel
    end
    N = max(N, 1)
    cohere = cohere ./ N .* bird.cohere_factor
    separate = separate ./ N .* bird.separate_factor
    match = match ./ N .* bird.match_factor
    bird.vel = (bird.vel .+ cohere .+ separate .+ match) ./ 2
    bird.vel = bird.vel ./ norm(bird.vel)
    move_agent!(bird, model, bird.speed)
end
```

