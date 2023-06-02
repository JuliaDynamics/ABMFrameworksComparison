#!/bin/bash

SEED=42
RANDOM=$SEED
N_RUN=100

export CLASSPATH=WolfSheep/Mason:./mason.21.jar
javac WolfSheep/Mason/Wsg_small.java WolfSheep/Mason/Wolf_small.java WolfSheep/Mason/Sheep_small.java
javac WolfSheep/Mason/Wsg_large.java WolfSheep/Mason/Wolf_large.java WolfSheep/Mason/Sheep_large.java

n_run_model_small () {
    times=()
    for i in $( seq 1 $N_RUN )
    do
        startt=`date +%s%N`
        java Wsg_small -seed $((RANDOM % 10000 + 1)) -for 20 -quiet
        endt=`date +%s%N`
        times+=(`expr $endt - $startt`)
    done
    readarray -t sorted < <(printf '%s\n' "${times[@]}" | sort)
    echo -n "Mason WolfSheep-small (ms): "
    echo "${sorted[(`expr $N_RUN / 2 + $N_RUN % 2`)]} * 0.000001" | bc
}

n_run_model_large () {
    times=()
    for i in $( seq 1 $N_RUN )
    do
        startt=`date +%s%N`
        java Wsg_large -seed $((RANDOM % 10000 + 1)) -for 20 -quiet
        endt=`date +%s%N`
        times+=(`expr $endt - $startt`)
    done
    readarray -t sorted < <(printf '%s\n' "${times[@]}" | sort)
    echo -n "Mason WolfSheep-large (ms): "
    echo "${sorted[(`expr $N_RUN / 2 + $N_RUN % 2`)]} * 0.000001" | bc
}

n_run_model_small
n_run_model_large
