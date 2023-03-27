# Benchmarks and comparisons of leading ABM frameworks and Agents.jl

Many agent-based modeling frameworks have been constructed to ease the process of building and analyzing ABMs (see [here](http://dx.doi.org/10.1016/j.cosrev.2017.03.001) for a review).
Notable examples are [NetLogo](https://ccl.northwestern.edu/netlogo/), [Repast](https://repast.github.io/index.html), [MASON](https://journals.sagepub.com/doi/10.1177/0037549705058073), and [Mesa](https://github.com/projectmesa/mesa).

This repository contains examples to compare [Agents.jl](https://github.com/JuliaDynamics/Agents.jl) with Mesa, Netlogo and Mason, to assess where Agents.jl excels and also may need some future improvement.
We used the following models for the comparison:

- **Wolf Sheep Grass**, a `GridSpace` model, which requires agents to be added, removed and moved; as well as identify properties of neighbouring positions.
- **Flocking**, a `ContinuousSpace` model, chosen over other models to include a MASON benchmark. Agents must move in accordance with social rules over the space.
- **Forest fire**, provides comparisons for cellular automata type ABMs (i.e. when agents do not move and every location in space contains exactly one agent). NOTE: The Agents.jl implementation of this model has been changed in v4.0 to be directly comparable to Mesa and NetLogo. As a consequence it no longer follows the [original rule-set](https://en.wikipedia.org/wiki/Forest-fire_model).
- **Schelling's-segregation-model**, an additional `GridSpace` model to compare with MASON. Simpler rules than Wolf Sheep Grass.

## How to run the benchmarks locally

To do this you can run the `runall.sh` file with `bash runall.sh`. It is easier to run the file with a Linux OS, but you can emulate the same behaviour on other systems. The requirements to do so are:

- a Bash shell
- To install the tested frameworks (except from Mason which is already provided)
- To make the commands `julia`, `python`, `java` and `javac` available from the shell and to have the GNU Parallel tool available. 
- Move the folder where NetLogo is installed inside the folder where the Netlogo benchmarks reside. 

## Contributions from other Frameworks

We welcome improvements from other framework contributors, either with new code that beats the implementation provided here with updated improvements from your framework's development process.

Frameworks not included in the comparison are invited to provide code for the above, standardised comparison models.

All are welcome to suggest better 'standard candle' models to test framework capability.

