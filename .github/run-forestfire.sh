#!/bin/bash

(

echo "Benchmarking Agents.jl"
julia --project=@. ./ForestFire/Agents/benchmark_forestfire.jl

echo "Benchmarking Mesa"
python3 ./ForestFire/Mesa/benchmark_forestfire.py

) | tee benchmark_results.txt

julia --project=@. create_benchmark_table.jl