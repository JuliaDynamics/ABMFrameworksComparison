#!/bin/bash

(

echo "Benchmarking Agents.jl"
julia --project=@. ../Flocking/Agents/benchmark_flocking.jl

echo "Benchmarking Mesa"
python3 ../Flocking/Mesa/benchmark_flocking.py

) | tee benchmark_results.txt

julia --project=@. create_benchmark_table.jl