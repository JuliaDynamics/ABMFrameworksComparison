#!/bin/bash

SEED=42
RANDOM=$SEED
N_RUN=100

export CLASSPATH=Schelling/Mason:./mason.21.jar
javac Schelling/Mason/Schelling.java Schelling/Mason/Agent.java

n_run_model () {
    times=()
    for i in $( seq 1 $N_RUN )
    do
        startt=`date +%s%N`
        java Schelling -seed $((RANDOM % 10000 + 1)) -for 10 -quiet
        endt=`date +%s%N`
        times+=(`expr $endt - $startt`)
    done
    readarray -t sorted < <(printf '%s\n' "${times[@]}" | sort)
    echo -n "Mason Schelling (ms): "
    echo "${sorted[(`expr $N_RUN / 2 + $N_RUN % 2`)]} * 0.000001" | bc
}

n_run_model