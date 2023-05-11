#!/bin/bash

(echo "Benchmarking Julia"
julia --project=@. WolfSheep/Agents/benchmark_wolfsheep.jl
julia --project=@. Flocking/Agents/benchmark_flocking.jl
julia --project=@. Schelling/Agents/benchmark_schelling.jl
julia --project=@. ForestFire/Agents/benchmark_forestfire.jl

echo "Benchmarking Mason"
bash Flocking/Mason/benchmark_flocking.sh
bash Schelling/Mason/benchmark_schelling.sh

echo "Benchmarking Mesa"
python WolfSheep/Mesa/benchmark_wolfsheep.py
python Flocking/Mesa/benchmark_flocking.py
python Schelling/Mesa/benchmark_schelling.py
python ForestFire/Mesa/benchmark_forestfire.py

echo "Benchmarking NetLogo"
# Don't run above 8 threads otherwise errors will spit once the JVMs try
# to share the Backing Store and lock it
ws=$(parallel -j1 ::: $(printf 'WolfSheep/NetLogo/benchmark_wolfsheep.sh %.0s' {1..100}) | sort | head -n1)
echo "NetLogo WolfSheep (ms): "$ws

ws=$(parallel -j1 ::: $(printf 'Flocking/NetLogo/benchmark_flocking.sh %.0s' {1..100}) | sort | head -n1)
echo "NetLogo Flocking (ms): "$ws

ws=$(parallel -j1 ::: $(printf 'Schelling/NetLogo/benchmark_schelling.sh %.0s' {1..100}) | sort | head -n1)
echo "NetLogo Schelling (ms): "$ws

ws=$(parallel -j1 ::: $(printf 'ForestFire/NetLogo/benchmark_forestfire.sh %.0s' {1..100}) | sort | head -n1)
echo "NetLogo ForestFire (ms): "$ws) | tee benchmark_results.txt

julia create_benchmark_table.jl