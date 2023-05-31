#!/bin/bash

SEED=42
RANDOM=$SEED
N_RUN=100

export CLASSPATH=ForestFire/Mason:./mason.21.jar
javac ForestFire/Mason/ForestFire_small.java
javac ForestFire/Mason/ForestFire_large.java

n_run_model_small () {
    times=()
    for i in $( seq 1 $N_RUN )
    do
        startt=`date +%s%N`
        java ForestFire_small -seed $((RANDOM % 10000 + 1)) -for 100 -quiet
        endt=`date +%s%N`
        times+=(`expr $endt - $startt`)
    done
    readarray -t sorted < <(printf '%s\n' "${times[@]}" | sort)
    echo -n "Mason ForestFire (ms): "
    echo "${sorted[(`expr $N_RUN / 2 + $N_RUN % 2`)]} * 0.000001" | bc
}

n_run_model_large () {
    times=()
    for i in $( seq 1 $N_RUN )
    do
        startt=`date +%s%N`
        java ForestFire_large -seed $((RANDOM % 10000 + 1)) -for 100 -quiet
        endt=`date +%s%N`
        times+=(`expr $endt - $startt`)
    done
    readarray -t sorted < <(printf '%s\n' "${times[@]}" | sort)
    echo -n "Mason ForestFire-large (ms): "
    echo "${sorted[(`expr $N_RUN / 2 + $N_RUN % 2`)]} * 0.000001" | bc
}

n_run_model_small
n_run_model_large
