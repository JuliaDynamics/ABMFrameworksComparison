#!/bin/bash

(

echo "Benchmarking Agents.jl"
julia --project=@. ./Schelling/Agents/benchmark_schelling.jl

echo "Benchmarking Mesa"
python3 ./Schelling/Mesa/benchmark_schelling.py

) | tee benchmark_results.txt

julia --project=@. create_benchmark_table.jl
