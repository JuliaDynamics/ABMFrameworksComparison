#!/bin/bash

SEED=42
RANDOM=$SEED
N_RUN=100

export CLASSPATH=Flocking/Mason:./mason.22.jar
javac Flocking/Mason/Flocking_small.java Flocking/Mason/Flocker_small.java
javac Flocking/Mason/Flocking_large.java Flocking/Mason/Flocker_large.java 

n_run_model_small () {
    times=()
    for i in $( seq 1 $N_RUN )
    do
        startt=`date +%s%N`
        java Flocking_small -seed $((RANDOM % 10000 + 1)) -for 100 -quiet
        endt=`date +%s%N`
        times+=(`expr $endt - $startt`)
    done
    readarray -t sorted < <(printf '%s\n' "${times[@]}" | sort)
    echo -n "Mason Flocking-small (ms): "
    echo "${sorted[(`expr $N_RUN / 2 + $N_RUN % 2`)]} * 0.000001" | bc
}

n_run_model_large () {
    times=()
    for i in $( seq 1 $N_RUN )
    do
        startt=`date +%s%N`
        java Flocking_large -seed $((RANDOM % 10000 + 1)) -for 100 -quiet
        endt=`date +%s%N`
        times+=(`expr $endt - $startt`)
    done
    readarray -t sorted < <(printf '%s\n' "${times[@]}" | sort)
    echo -n "Mason Flocking-large (ms): "
    echo "${sorted[(`expr $N_RUN / 2 + $N_RUN % 2`)]} * 0.000001" | bc
}

n_run_model_small
n_run_model_large
