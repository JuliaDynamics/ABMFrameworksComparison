#!/bin/bash

# NetLogo's profiler sucks in the sense that it times one run, then spits out a bunch of junk
# to either a file or stdout. There's no easy abilitiy to parse it.

# the netlogo folder is assumed to be inside the NetLogo folder of this repository, which contains the models

SEED=42
RANDOM=$SEED
N_RUN=100

NAME_LAUNCHER="./netlogo/netlogo-headless.sh"
NAME_MODEL="WolfSheep/NetLogo/WolfSheep.nlogo"
NAME_PARAM="WolfSheep/NetLogo/parameters_wolfsheep.xml"

# Don't run above 8 threads otherwise errors will spit once the JVMs try
# to share the Backing Store and lock it

n_run_model_small () {
    times=()
    for i in $( seq 1 $N_RUN )
    do
        julia --project=@. change_seed_netlogo.jl $NAME_PARAM $((RANDOM % 10000 + 1))
        sed -i '1d' $NAME_PARAM
        t=$((bash $NAME_LAUNCHER --model $NAME_MODEL --setup-file $NAME_PARAM --experiment benchmark_small \
             --min-pxcor 0 --max-pxcor 24 --min-pycor 0 --max-pycor 24
        	) | awk '/GO/{i++}i==2{print $3;exit}')
        times+=(`expr $t`)
    done

    readarray -t sorted < <(printf '%s\n' "${times[@]}" | sort)
    printf "NetLogo WolfSheep-small (ms): "${sorted[(`expr $N_RUN / 2 + $N_RUN % 2`)]}"\n"
}

n_run_model_large () {
    times=()
    for i in $( seq 1 $N_RUN )
    do
        julia --project=@. change_seed_netlogo.jl $NAME_PARAM $((RANDOM % 10000 + 1))
        sed -i '1d' $NAME_PARAM
        t=$((bash $NAME_LAUNCHER --model $NAME_MODEL --setup-file $NAME_PARAM --experiment benchmark_large \
             --min-pxcor 0 --max-pxcor 99 --min-pycor 0 --max-pycor 99
            ) | awk '/GO/{i++}i==2{print $3;exit}')
        times+=(`expr $t`)
    done

    readarray -t sorted < <(printf '%s\n' "${times[@]}" | sort)
    printf "NetLogo WolfSheep-large (ms): "${sorted[(`expr $N_RUN / 2 + $N_RUN % 2`)]}"\n"
}

n_run_model_small
n_run_model_large
