# Agent based modelling frameworks comparison

This repository contains code used to compare performance and features between various agent based modelling **(ABM)** frameworks. Currently, frameworks compared are [Agents.jl](https://github.com/JuliaDynamics/Agents.jl), [NetLogo](https://github.com/NetLogo/NetLogo), [MASON](https://github.com/eclab/mason) and [Mesa](https://github.com/projectmesa/mesa). We happily welcome more frameworks to join the comparison.

**This repository establishes objectively that Agents.jl is the fastest open source agent based modelling framework and that Agents.jl has the simplest source code for a given model specification, in comparison to all the other tested frameworks.**

This repository has been initiated and maintained by the developers of Agents.jl However, it strongly welcomes contributions (in the form of Pull Requests) from developers or users of other modelling frameworks. Contributions may improve performance of a model implementation, or simplify the code of the implementation, provided that they still abide the model declaration, see below for more information. Note that this repository is fully open source, hence any Pull Request and discussion done here will be forever visible openly. Furthermore, we also welcome contributions that may implement a comparison across a new agent based model not yet considered in this comparison.

**The performance benchmark comparison is run automatically during continuous integration, and hence the comparison is updated after every pull request to this repo.**

## How it works

Various agent based models have been selected to compare performance, such as the Schelling model for example. This repository is structured as follows

1. Each selected ABM is contained in a dedicated folder of this repo.
1. Inside the ABM folder there is a DECLARATION.md markdown file. In declares both the scientific as well as technical implementation of the ABM. We tried our best to make the declaration as clear and as specific as possible, but we welcome Pull Requests that may clarify the declaration even more.
1. In the same folder there are subfolders named after the frameworks. Each contains the files that implement and benchmark the ABM implementation.
1. The implementation must be written in the same way a typical user will use the respective software. The implementations must only use the documented API of the respective software.
1. The benchmark step operates as follows: all models must be seeded with a given random number generator seed. At the start of the process, _`S` random seeds are generated in a reproducible way (or, alternatively, a random number generator that generates seeds is initialized with a specified seed)_. `S` is the amount of random seeds and hence also the amount of simulations performed for a given model. Unless stated otherwise in the declaration file of an ABM, `S` has been arbitrarily decided to be `1000`.
1. From these `1000` random (but reproducibly random) model runs, the median is used as the performance of each software.
1. The benchmarks are run during continuous integration. The benchmark timings are collected among ABMs and among the different ABM software during continuous integration. The timings are printed in the CI log, and also stored in a csv file (not yet, TODO) to be accessed later.

The results of the latest comparison are presented here: TODO: provide link to a CI log.

[Here are the old benchmarks](https://juliadynamics.github.io/Agents.jl/stable/comparison/). The hardware configuration used for the benchmark is a Ubuntu 22.04 LTS x86_64 with a Ryzen 5 5600H CPU and 16GB of RAM.

## How to run the benchmarks locally

To reproduce the results you can run the `runall.sh` file with `bash runall.sh`. It is easier to run the file with a Linux OS, but you can emulate the same behaviour on Windows using WSL.

The requirements to run the benchmark file are:

1. To run the file on a bash shell;
1. To install the tested frameworks (except for Mason which is already provided);
1. To make the commands `julia`, `python`, `java` and `javac` available from the shell and to have the GNU Parallel and bc tools available;
1. To move the folder where NetLogo is installed, rename it as `netlogo` and put it inside the main folder.

This snippet was tested on an Ubuntu 22.04 LTS x86_64, but it should work also on other similar enviroments, copy-paste it on a bash shell to set up everything automatically for the benchmark:

```bash
# fetch update software list
sudo apt-get update

# clone the repository and give permissions
sudo git clone https://github.com/JuliaDynamics/ABM_Framework_Comparisons.git
sudo chmod a+rwx ABM_Framework_Comparisons
sudo chmod -R 777 ABM_Framework_Comparisons

# install java
sudo apt install default-jre-headless
sudo apt install default-jdk-headless

# install julia
sudo wget https://julialang-s3.julialang.org/bin/linux/x64/1.9/julia-1.9.0-linux-x86_64.tar.gz
sudo tar zxvf julia-1.9.0-linux-x86_64.tar.gz
export PATH=$PATH:$(pwd)"/julia-1.9.0/bin"
printf "\nexport PATH=\"\$PATH:"$(pwd)"/julia-1.9.0/bin\"" >> ~/.bashrc

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

# install parallel and bc tools
sudo apt install parallel
sudo apt install bc

# move to repo folder
cd ABM_Framework_Comparisons
```
