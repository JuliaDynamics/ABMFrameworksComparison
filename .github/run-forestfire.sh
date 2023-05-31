#!/bin/bash

(

echo "Benchmarking Agents.jl"
julia --project=@. ./ForestFire/Agents/benchmark_forestfire.jl

echo "Benchmarking Mason"
bash ./ForestFire/Mason/benchmark_forestfire.sh

echo "Benchmarking Mesa"
python3 ./ForestFire/Mesa/benchmark_forestfire.py

echo "Benchmarking NetLogo"
bash ./ForestFire/NetLogo/benchmark_forestfire.sh

) | tee benchmark_results.txt

julia --project=@. create_benchmark_table.jl
