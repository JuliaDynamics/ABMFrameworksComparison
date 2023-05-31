#!/bin/bash

SEED=42
RANDOM=$SEED
N_RUN=100

export CLASSPATH=Schelling/Mason:./mason.21.jar
javac Schelling/Mason/Schelling_small.java Schelling/Mason/Agent_small.java
javac Schelling/Mason/Schelling_large.java Schelling/Mason/Agent_large.java

n_run_model_small () {
    times=()
    for i in $( seq 1 $N_RUN )
    do
        startt=`date +%s%N`
        java Schelling_small -seed $((RANDOM % 10000 + 1)) -for 20 -quiet
        endt=`date +%s%N`
        times+=(`expr $endt - $startt`)
    done
    readarray -t sorted < <(printf '%s\n' "${times[@]}" | sort)
    echo -n "Mason Schelling-small (ms): "
    echo "${sorted[(`expr $N_RUN / 2 + $N_RUN % 2`)]} * 0.000001" | bc
}

n_run_model_large () {
    times=()
    for i in $( seq 1 $N_RUN )
    do
        startt=`date +%s%N`
        java Schelling_large -seed $((RANDOM % 10000 + 1)) -for 20 -quiet
        endt=`date +%s%N`
        times+=(`expr $endt - $startt`)
    done
    readarray -t sorted < <(printf '%s\n' "${times[@]}" | sort)
    echo -n "Mason Schelling-large (ms): "
    echo "${sorted[(`expr $N_RUN / 2 + $N_RUN % 2`)]} * 0.000001" | bc
}

n_run_model_small
n_run_model_large

