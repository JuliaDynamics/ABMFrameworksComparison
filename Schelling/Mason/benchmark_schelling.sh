#!/bin/bash

SEED=42
RANDOM=$SEED
N_RUN=100

export CLASSPATH=Schelling/Mason:./mason.22.jar
javac Schelling/Mason/Schelling_small.java Schelling/Mason/Agent_small.java
javac Schelling/Mason/Schelling_large.java Schelling/Mason/Agent_large.java

n_run_model_small () {
    times=($(java Schelling_small -seed $((RANDOM % 10000 + 1)) -for 20 -repeat $N_RUN -quiet | grep "JobTime:" | awk '{print $2}'))
    readarray -t sorted < <(printf '%s\n' "${times[@]}" | sort -n)
    echo -n "Mason Schelling-small (ms): "
    echo "${sorted[(`expr $N_RUN / 2`)]} * 0.000001" | bc
}

n_run_model_large () {
    times=($(java Schelling_large -seed $((RANDOM % 10000 + 1)) -for 20 -repeat $N_RUN -quiet | grep "JobTime:" | awk '{print $2}'))
    readarray -t sorted < <(printf '%s\n' "${times[@]}" | sort -n)
    echo -n "Mason Schelling-large (ms): "
    echo "${sorted[(`expr $N_RUN / 2`)]} * 0.000001" | bc
}

n_run_model_small
n_run_model_large

