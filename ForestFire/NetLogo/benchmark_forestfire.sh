#!/bin/bash

# NetLogo's profiler sucks in the sense that it times one run, then spits out a bunch of junk
# to either a file or stdout. There's no easy abilitiy to parse it.

# the netlogo folder is assumed to be inside the NetLogo folder of this repository, which contains the models
bash ./netlogo/netlogo-headless.sh --model "ForestFire/NetLogo/ForestFire.nlogo" --experiment benchmark | awk '/GO/{i++}i==2{print $3;exit}'
