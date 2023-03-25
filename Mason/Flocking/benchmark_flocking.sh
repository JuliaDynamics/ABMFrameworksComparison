#!/bin/bash

export CLASSPATH=Mason/Flocking:Mason/mason.21.jar
javac Mason/Flocking/Flocking.java Mason/Flocking/Flocker.java
times=()
for i in {1..100}
do
    startt=`date +%s%N`
    java Flocking -for 100 -quiet
    endt=`date +%s%N`
    times+=(`expr $endt - $startt`)
done
readarray -t sorted < <(printf '%s\n' "${times[@]}" | sort)
echo -n "Mason Flocking (ms): "
echo "${sorted[0]} * 0.000001" | bc
