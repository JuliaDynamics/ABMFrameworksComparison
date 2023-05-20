#!/bin/bash

# NetLogo's profiler sucks in the sense that it times one run, then spits out a bunch of junk
# to either a file or stdout. There's no easy abilitiy to parse it.

# the netlogo folder is assumed to be inside the NetLogo folder of this repository, which contains the models

NAME_LAUNCHER="./netlogo/netlogo-headless.sh"
NAME_MODEL="WolfSheep/NetLogo/WolfSheep.nlogo"
NAME_PARAM="WolfSheep/NetLogo/parameters_wolfsheep.xml"

# Don't run above 8 threads otherwise errors will spit once the JVMs try
# to share the Backing Store and lock it
times=()
for i in {1..100}
do
    t=$((bash $NAME_LAUNCHER --model $NAME_MODEL --setup-file $NAME_PARAM --experiment benchmark
    	) | awk '/GO/{i++}i==2{print $3;exit}')
    times+=(`expr $t`)
done

readarray -t sorted < <(printf '%s\n' "${times[@]}" | sort)
printf "NetLogo WolfSheep (ms): "${sorted[0]}"\n"
