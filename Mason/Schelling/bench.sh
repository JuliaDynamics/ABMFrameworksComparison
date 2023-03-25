#!/bin/bash

export CLASSPATH=Mason/Schelling:Mason/mason.21.jar
javac Mason/Schelling/Schelling.java Mason/Schelling/Agent.java
times=()
for i in {1..100}
do
    startt=`date +%s%N`
    java Schelling -for 10 -quiet
    endt=`date +%s%N`
    times+=(`expr $endt - $startt`)
done
readarray -t sorted < <(printf '%s\n' "${times[@]}" | sort)
echo -n "Mason Schelling (ms): "
echo "${sorted[0]} * 0.000001" | bc
