# Benchmarks and comparisons of leading ABM frameworks and Agents.jl

Many agent-based modeling frameworks have been constructed to ease the process of building and analyzing ABMs (see [here](http://dx.doi.org/10.1016/j.cosrev.2017.03.001) for a review).
Notable examples are [NetLogo](https://ccl.northwestern.edu/netlogo/), [Repast](https://repast.github.io/index.html), [MASON](https://journals.sagepub.com/doi/10.1177/0037549705058073), and [Mesa](https://github.com/projectmesa/mesa).

This repository contains examples to compare [Agents.jl](https://github.com/JuliaDynamics/Agents.jl) with Mesa, Netlogo and Mason, to assess where Agents.jl excels and also may need some future improvement.
We used the following models for the comparison:

- **Wolf Sheep Grass**, a `GridSpace` model, which requires agents to be added, removed and moved; as well as identify properties of neighbouring positions.
- **Flocking**, a `ContinuousSpace` model, chosen over other models to include a MASON benchmark. Agents must move in accordance with social rules over the space.
- **Forest fire**, provides comparisons for cellular automata type ABMs (i.e. when agents do not move and every location in space contains exactly one agent). NOTE: The Agents.jl implementation of this model has been changed in v4.0 to be directly comparable to Mesa and NetLogo. As a consequence it no longer follows the [original rule-set](https://en.wikipedia.org/wiki/Forest-fire_model).
- **Schelling's-segregation-model**, an additional `GridSpace` model to compare with MASON. Simpler rules than Wolf Sheep Grass.

The results of the latest comparison are presented [here](https://juliadynamics.github.io/Agents.jl/stable/comparison/). The hardware configuration used for the benchmark is a Ubuntu 22.04 LTS x86_64 with a Ryzen 5 5600H CPU and 16GB of RAM.

## How to run the benchmarks locally

To reproduce the results you can run the `runall.sh` file with `bash runall.sh`. It is easier to run the file with a Linux OS, but you can emulate the same behaviour on Windows using WSL. 

The requirements to run the benchmark file are:

- To run the file on a bash shell;
- To install the tested frameworks (except for Mason which is already provided);
- To make the commands `julia`, `python`, `java` and `javac` available from the shell and to have the GNU Parallel tool available;
- To move the folder where NetLogo is installed, rename it as `netlogo` and put it inside the main folder.

This snippet was tested on an Ubuntu 22.04 LTS x86_64, but it should work also on other similar enviroments, copy-paste it on a bash shell to set up everything automatically for the benchmark:

```bash

# fetch update software list
sudo apt-get update

# clone the repository
sudo git clone https://github.com/JuliaDynamics/ABM_Framework_Comparisons.git

# install java
sudo apt install default-jre-headless
sudo apt install default-jdk-headless

# install julia
sudo wget https://julialang-s3.julialang.org/bin/linux/x64/1.9/julia-1.9.0-linux-x86_64.tar.gz
sudo tar zxvf julia-1.9.0-linux-x86_64.tar.gz
printf "\nexport PATH=\"\$PATH:"$(pwd)"/julia-1.9.0/bin\"" >> ~/.bashrc
exec bash

# install agents
julia --project=ABM_Framework_Comparisons -e 'using Pkg; Pkg.instantiate()'

# install mesa
sudo apt install python3-pip
pip install mesa==1.2.1

# install netlogo
sudo wget http://ccl.northwestern.edu/netlogo/6.3.0/NetLogo-6.3.0-64.tgz
sudo tar -xzf NetLogo-6.3.0-64.tgz

# move netlogo inside repository
sudo mv "NetLogo 6.3.0" netlogo
sudo mv netlogo ABM_Framework_Comparisons

# install parallel tool
sudo apt install parallel

# move to repo folder
cd ABM_Framework_Comparisons
```

## Contributions from other Frameworks

We welcome improvements from other framework contributors, either with new code that beats the implementation provided here with updated improvements from your framework's development process.

Frameworks not included in the comparison are invited to provide code for the above, standardised comparison models.

All are welcome to suggest better 'standard candle' models to test framework capability.

