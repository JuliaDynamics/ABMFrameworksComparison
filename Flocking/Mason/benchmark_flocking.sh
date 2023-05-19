#!/bin/bash

SEED=42
RANDOM=$SEED

export CLASSPATH=Flocking/Mason:./mason.21.jar
javac Flocking/Mason/Flocking.java Flocking/Mason/Flocker.java
times=()
for i in {1..100}
do
    startt=`date +%s%N`
    java Flocking -seed $((RANDOM % 10000 + 1)) -for 100 -quiet
    endt=`date +%s%N`
    times+=(`expr $endt - $startt`)
done
readarray -t sorted < <(printf '%s\n' "${times[@]}" | sort)
echo -n "Mason Flocking (ms): "
echo "${sorted[0]} * 0.000001" | bc