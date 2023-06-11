#!/bin/bash

# NetLogo's profiler sucks in the sense that it times one run, then spits out a bunch of junk
# to either a file or stdout. There's no easy abilitiy to parse it.

# the netlogo folder is assumed to be inside the NetLogo folder of this repository, which contains the models

N_RUN=100

NAME_LAUNCHER="./netlogo/netlogo-headless.sh"
NAME_MODEL="ForestFire/NetLogo/ForestFire.nlogo"
NAME_PARAM="ForestFire/NetLogo/parameters_forestfire.xml"

n_run_model_small () {
    times=()
    julia --project=@. seed_netlogo.jl $NAME_PARAM $N_RUN
    sed -i '1d' $NAME_PARAM
    t=$((bash $NAME_LAUNCHER --model $NAME_MODEL --setup-file $NAME_PARAM --experiment benchmark
        ) | awk '/GO/{i++}i==2{print $3;exit}')
    times+=(`expr $t`)
    readarray -t sorted < <(printf '%s\n' "${times[@]}" | sort)
    printf "NetLogo ForestFire-small (ms): "${sorted[(`expr $N_RUN / 2 + $N_RUN % 2`)]}"\n"  
}

n_run_model_large () {
    times=()
    julia --project=@. seed_netlogo.jl $NAME_PARAM $N_RUN
    sed -i '1d' $NAME_PARAM
    t=$((bash $NAME_LAUNCHER --model $NAME_MODEL --setup-file $NAME_PARAM --experiment benchmark
        ) | awk '/GO/{i++}i==2{print $3;exit}')
    times+=(`expr $t`)
    readarray -t sorted < <(printf '%s\n' "${times[@]}" | sort)
    printf "NetLogo ForestFire-large (ms): "${sorted[(`expr $N_RUN / 2 + $N_RUN % 2`)]}"\n"  
}

n_run_model_small
n_run_model_large