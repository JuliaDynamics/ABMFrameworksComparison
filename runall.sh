#!/bin/bash

(


echo "Benchmarking Mason"
bash Flocking/Mason/benchmark_flocking.sh
bash Schelling/Mason/benchmark_schelling.sh

) | tee benchmark_results.txt

julia --project=@. create_benchmark_table.jl
