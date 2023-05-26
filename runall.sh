#!/bin/bash

(



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
bash Flocking/NetLogo/benchmark_flocking.sh
bash Schelling/NetLogo/benchmark_schelling.sh
bash ForestFire/NetLogo/benchmark_forestfire.sh

) | tee benchmark_results.txt

julia --project=@. create_benchmark_table.jl
