#!/bin/bash

(

echo "Benchmarking Agents.jl"
julia --project=@. WolfSheep/Agents/benchmark_wolfsheep.jl
julia --project=@. Flocking/Agents/benchmark_flocking.jl
julia --project=@. Schelling/Agents/benchmark_schelling.jl

echo "Benchmarking Mason"
bash WolfSheep/Mason/benchmark_wolfsheep.sh
bash Flocking/Mason/benchmark_flocking.sh
bash Schelling/Mason/benchmark_schelling.sh

echo "Benchmarking Mesa"
python3 WolfSheep/Mesa/benchmark_wolfsheep.py
python3 Flocking/Mesa/benchmark_flocking.py
python3 Schelling/Mesa/benchmark_schelling.py

echo "Benchmarking NetLogo"
bash WolfSheep/NetLogo/benchmark_wolfsheep.sh
bash Flocking/NetLogo/benchmark_flocking.sh
bash Schelling/NetLogo/benchmark_schelling.sh

) | tee benchmark_results.txt

julia --project=@. create_benchmark_table.jl