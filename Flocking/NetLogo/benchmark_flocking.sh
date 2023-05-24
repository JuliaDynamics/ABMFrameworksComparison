#!/bin/bash

# NetLogo's profiler sucks in the sense that it times one run, then spits out a bunch of junk
# to either a file or stdout. There's no easy abilitiy to parse it.

# the netlogo folder is assumed to be inside the NetLogo folder of this repository, which contains the models

SEED=42
RANDOM=$SEED
N_RUN=100

NAME_LAUNCHER="./netlogo/netlogo-headless.sh"
NAME_MODEL="Flocking/NetLogo/Flocking.nlogo"
NAME_PARAM="Flocking/NetLogo/parameters_flocking.xml"

times=()
for i in $( seq 1 $N_RUN )
do
    julia --project=@. change_seed_netlogo.jl $NAME_PARAM $((RANDOM % 10000 + 1))
    sed -i '1d' $NAME_PARAM
    t=$((bash $NAME_LAUNCHER --model $NAME_MODEL --setup-file $NAME_PARAM --experiment benchmark
    	) | awk '/GO/{i++}i==2{print $3;exit}')
    times+=(`expr $t`)
done

readarray -t sorted < <(printf '%s\n' "${times[@]}" | sort)
printf "NetLogo Flocking (ms): "${sorted[(`expr $N_RUN / 2 + $N_RUN % 2`)]}"\n"
