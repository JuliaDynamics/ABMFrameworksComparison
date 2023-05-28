#!/bin/bash

(

echo "Benchmarking Agents.jl"
julia --project=@. ../WolfSheep/Agents/benchmark_wolfsheep.jl

echo "Benchmarking Mesa"
python3 ../WolfSheep/Mesa/benchmark_wolfsheep.py

) | tee benchmark_results.txt

julia --project=@. create_benchmark_table.jl