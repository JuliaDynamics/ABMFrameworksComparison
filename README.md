# Agent based modelling frameworks comparison


[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.8016506.svg)](https://doi.org/10.5281/zenodo.8016506)



This repository contains code used to compare performance and features between various agent based modelling **(ABM)** frameworks. Currently, frameworks compared are [Agents.jl](https://github.com/JuliaDynamics/Agents.jl), [NetLogo](https://github.com/NetLogo/NetLogo), [MASON](https://github.com/eclab/mason) and [Mesa](https://github.com/projectmesa/mesa). We happily welcome more frameworks to join the comparison.

**The performance benchmark comparison is run automatically during continuous integration, and hence the comparison is updated after every pull request to this repo.**

This repository has been initiated and maintained by the developers of Agents.jl. However, it strongly welcomes contributions (in the form of Pull Requests) from developers or users of other modelling frameworks. Contributions may improve performance of a model implementation, or simplify the code of the implementation, provided that they still abide the model declaration, see below for more information. Furthermore, we also welcome contributions that may implement a comparison across a new agent based model not yet considered in this comparison.

Our conclusions following the objective benchmarks of this repository is that **Agents.jl is the fastest open source general purpose agent based modelling framework and that it has the simplest source code** for a given model specification, in comparison to the other tested frameworks in this repository. You are more than welcomed to dispute the claim by adding more frameworks to this comparison or improving the implementations of existing frameworks!

## Latest results

These are the results of the latest comparison:

 | Model/Framework  | Agents.jl 6.0.0 | MASON 21.0 | Netlogo 6.4.0 | Mesa 2.1.4 |
|:------------------|:---------------:|:------------:|:------------:|:---------------:|
| WolfSheep (Time-Ratio, Small-Version)  |       1        |    93.0x    |     13.7x      |    47.9x    |
| WolfSheep (Time-Ratio, Large-Version)   |       1        |    16.7x    |      7.2x      |    29.0x    |
| WolfSheep (Lines of Code) |     73          |    202        |  137 (871)        | 138 |
 |  Flocking (Time-Ratio, Small-Version)  |       1        |    24.3x    |     19.2x      |   174.8x    |
|  Flocking (Time-Ratio, Large-Version)  |       1        |    4.6x     |     26.2x      |   249.7x    |
|   Flocking (Lines of Code)       |       42     |      159     |    82 (689)   |   102       |
 | Schelling (Time-Ratio, Small-Version)  |       1        |    92.1x    |     22.3x      |    53.7x    |
| Schelling (Time-Ratio, Large-Version)   |       1        |    7.9x     |     25.1x      |    49.5x    |
|    Schelling (Lines of Code)      |       28          |      134   |   58 (743)      |     44    |

## How it works

Various agent based models have been selected to compare performance, such as the Schelling model for example. This repository is structured as follows

1. Each selected ABM is contained in a dedicated folder of this repo.
1. Inside the ABM folder there is a DECLARATION.md markdown file. In declares both the scientific as well as technical implementation of the ABM. We tried our best to make the declaration as clear and as specific as possible, but we welcome Pull Requests that may clarify the declaration even more.
1. In the same folder there are subfolders named after the frameworks. Each contains the files that implement and benchmark the ABM implementation.
1. The implementation must be written in the same way a typical user will use the respective software. The implementations must only use the documented API of the respective software.
1. The benchmark step operates as follows: all models must be seeded with a given random number generator seed. At the start of the process, _`S` random seeds are generated in a reproducible way (or, alternatively, a random number generator that generates seeds is initialized with a specified seed)_. `S` is the amount of random seeds and hence also the amount of simulations performed for a given model. Unless stated otherwise in the declaration file of an ABM, `S` has been arbitrarily decided to be `100`.
1. From these `100` random (but reproducibly random) model runs, the median is used as the performance of each software.
1. The benchmarks are run during continuous integration. The benchmark timings are collected among ABMs and among the different ABM software during continuous integration. The timings are printed in the CI log, and also stored in a csv file (not yet, TODO) to be accessed later.

## How to run the benchmarks locally

To reproduce the results you can run the `runall.sh` file with `bash runall.sh`. It is easier to run the file with a Linux OS, but you can emulate the same behaviour on Windows using WSL.

The requirements to run the benchmark file are:

1. To run the file on a bash shell;
1. To install the tested frameworks (except for Mason which is already provided);
1. To make the commands `julia`, `python`, `java` and `javac` available from the shell and to have the bc tool available;
1. To move the folder where NetLogo is installed, rename it as `netlogo` and put it inside the main folder.

This snippet was tested on an Ubuntu 22.04 LTS x86_64, but it should work also on other similar environments, copy-paste it on a bash shell to set up everything automatically for the benchmark:

```bash
# fetch update software list
sudo apt-get update

# clone the repository and give permissions
sudo git clone https://github.com/JuliaDynamics/ABM_Framework_Comparisons.git
sudo chmod a+rwx ABM_Framework_Comparisons
sudo chmod -R 777 ABM_Framework_Comparisons

# install julia
sudo wget https://julialang-s3.julialang.org/bin/linux/x64/1.9/julia-1.9.4-linux-x86_64.tar.gz
sudo tar zxvf julia-1.9.4-linux-x86_64.tar.gz
export PATH=$PATH:$(pwd)"/julia-1.9.4/bin"
printf "\nexport PATH=\"\$PATH:"$(pwd)"/julia-1.9.4/bin\"" >> ~/.bashrc

# install agents
julia --project=ABM_Framework_Comparisons -e 'using Pkg; Pkg.instantiate()'

# install java
sudo apt install default-jre-headless
sudo apt install default-jdk-headless

# install mesa
sudo apt install python3-pip
pip install mesa==2.1.4

# install netlogo
sudo wget http://ccl.northwestern.edu/netlogo/6.4.0/NetLogo-6.4.0-64.tgz
sudo tar -xzf NetLogo-6.4.0-64.tgz

# move netlogo inside repository
sudo mv "NetLogo-6.4.0-64" netlogo
sudo mv netlogo ABM_Framework_Comparisons

# install bc tools
sudo apt install bc

# move to repo folder
cd ABM_Framework_Comparisons
```

If you are using WSL make sure that you move to a folder inside the subsystem before running these commands.
