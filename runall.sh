#!/bin/bash

(echo "Benchmarking Julia"
julia --project=@. Agents/WolfSheep/benchmark_wolfsheep.jl
julia --project=@. Agents/Flocking/benchmark_flocking.jl
julia --project=@. Agents/Schelling/benchmark_schelling.jl
julia --project=@. Agents/ForestFire/benchmark_forestfire.jl

echo "Benchmarking Mason"
bash Mason/Flocking/benchmark_flocking.sh
bash Mason/Schelling/benchmark_schelling.sh

echo "Benchmarking Mesa"
python Mesa/WolfSheep/benchmark_wolfsheep.py
python Mesa/Flocking/benchmark_flocking.py
python Mesa/Schelling/benchmark_schelling.py
python Mesa/ForestFire/benchmark_forestfire.py

echo "Benchmarking NetLogo"
# Don't run above 8 threads otherwise errors will spit once the JVMs try
# to share the Backing Store and lock it
ws=$(parallel -j1 ::: $(printf 'NetLogo/WolfSheep/benchmark_wolfsheep.sh %.0s' {1..100}) | sort | head -n1)
echo "NetLogo WolfSheep (ms): "$ws

ws=$(parallel -j1 ::: $(printf 'NetLogo/Flocking/benchmark_flocking.sh %.0s' {1..100}) | sort | head -n1)
echo "NetLogo Flocking (ms): "$ws

ws=$(parallel -j1 ::: $(printf 'NetLogo/Schelling/benchmark_schelling.sh %.0s' {1..100}) | sort | head -n1)
echo "NetLogo Schelling (ms): "$ws

ws=$(parallel -j1 ::: $(printf 'NetLogo/ForestFire/benchmark_forestfire.sh %.0s' {1..100}) | sort | head -n1)
echo "NetLogo ForestFire (ms): "$ws) | tee benchmark_results.txt
