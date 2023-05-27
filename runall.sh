#!/bin/bash

(

echo "Benchmarking Agents.jl"
julia --project=@. WolfSheep/Agents/benchmark_wolfsheep.jl
julia --project=@. Flocking/Agents/benchmark_flocking.jl
julia --project=@. Schelling/Agents/benchmark_schelling.jl
julia --project=@. ForestFire/Agents/benchmark_forestfire.jl

echo "Benchmarking Mesa"
python3 WolfSheep/Mesa/benchmark_wolfsheep.py
python3 Flocking/Mesa/benchmark_flocking.py
python3 Schelling/Mesa/benchmark_schelling.py
python3 ForestFire/Mesa/benchmark_forestfire.py

) | tee benchmark_results.txt

julia --project=@. create_benchmark_table.jl
