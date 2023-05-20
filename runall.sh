#!/bin/bash

(
echo "Benchmarking Julia"
julia --project=@. WolfSheep/Agents/benchmark_wolfsheep.jl
julia --project=@. Flocking/Agents/benchmark_flocking.jl
julia --project=@. Schelling/Agents/benchmark_schelling.jl
julia --project=@. ForestFire/Agents/benchmark_forestfire.jl

echo "Benchmarking Mason"
bash Flocking/Mason/benchmark_flocking.sh
bash Schelling/Mason/benchmark_schelling.sh

echo "Benchmarking Mesa"
python3 WolfSheep/Mesa/benchmark_wolfsheep.py
python3 Flocking/Mesa/benchmark_flocking.py
python3 Schelling/Mesa/benchmark_schelling.py
python3 ForestFire/Mesa/benchmark_forestfire.py

echo "Benchmarking NetLogo"
bash WolfSheep/NetLogo/benchmark_wolfsheep.sh

ws=$(parallel -j1 ::: $(printf 'Flocking/NetLogo/benchmark_flocking.sh %.0s' {1..100}) | sort | head -n1)
echo "NetLogo Flocking (ms): "$ws

ws=$(parallel -j1 ::: $(printf 'Schelling/NetLogo/benchmark_schelling.sh %.0s' {1..100}) | sort | head -n1)
echo "NetLogo Schelling (ms): "$ws

ws=$(parallel -j1 ::: $(printf 'ForestFire/NetLogo/benchmark_forestfire.sh %.0s' {1..100}) | sort | head -n1)
echo "NetLogo ForestFire (ms): "$ws
) | tee benchmark_results.txt

julia --project=@. create_benchmark_table.jl
