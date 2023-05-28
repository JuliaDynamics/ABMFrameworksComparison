#!/bin/bash

(

echo "Benchmarking Agents.jl"
julia --project=@. ./Schelling/Agents/benchmark_schelling.jl

echo "Benchmarking Mason"
bash ./Schelling/Mason/benchmark_schelling.sh

echo "Benchmarking Mesa"
python3 ./Schelling/Mesa/benchmark_schelling.py

echo "Benchmarking NetLogo"
bash Schelling/NetLogo/benchmark_schelling.sh

) | tee benchmark_results.txt

julia --project=@. create_benchmark_table.jl
