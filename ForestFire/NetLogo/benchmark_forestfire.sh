#!/bin/bash

# NetLogo's profiler sucks in the sense that it times one run, then spits out a bunch of junk
# to either a file or stdout. There's no easy abilitiy to parse it.

# the netlogo folder is assumed to be inside the NetLogo folder of this repository, which contains the models

N_RUN=100

NAME_LAUNCHER="./netlogo/netlogo-headless.sh"
NAME_MODEL="ForestFire/NetLogo/ForestFire.nlogo"
NAME_PARAM="ForestFire/NetLogo/parameters_forestfire.xml"
NAME_TIMES="ForestFire/NetLogo/times.txt"

julia --project=@. seed_netlogo.jl $NAME_PARAM $N_RUN

n_run_model_small () {
    sed -i '1d' $NAME_PARAM
    (bash $NAME_LAUNCHER --model $NAME_MODEL --setup-file $NAME_PARAM --experiment benchmark_small \
         --min-pxcor 0 --max-pxcor 99 --min-pycor 0 --max-pycor 99 --threads 1)
    times=()
    while IFS= read -r line; do
    times+=("$line")
    done < $NAME_TIMES
    readarray -t sorted < <(printf '%s\n' "${times[@]}" | sort)
    printf "NetLogo ForestFire-small (ms): "${sorted[(`expr $N_RUN / 2 + $N_RUN % 2`)]}"\n"  
    rm $NAME_TIMES
}

n_run_model_large () {
    (bash $NAME_LAUNCHER --model $NAME_MODEL --setup-file $NAME_PARAM --experiment benchmark_large \
         --min-pxcor 0 --max-pxcor 499 --min-pycor 0 --max-pycor 499 --threads 1)
    times=()
    while IFS= read -r line; do
    times+=("$line")
    done < $NAME_TIMES
    readarray -t sorted < <(printf '%s\n' "${times[@]}" | sort)
    printf "NetLogo ForestFire-large (ms): "${sorted[(`expr $N_RUN / 2 + $N_RUN % 2`)]}"\n"  
    rm $NAME_TIMES
}

n_run_model_small
n_run_model_large
