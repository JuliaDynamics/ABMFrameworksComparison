# Use Python 3

# Only collect the number of wolves and sheeps per step.

import timeit
import gc

setup = f"""
gc.enable()
import os, sys
sys.path.insert(0, os.path.abspath("."))

from Flocking import BoidFlockers

import random
random.seed(42)

def runthemodel(flock):
    for i in range(0, 100):
      flock.step()

seed = random.randint(1, 10000)
flock = BoidFlockers(seed)
"""

tt = timeit.Timer('runthemodel(flock)', setup=setup)
n_run = 100
a = tt.repeat(n_run, 1)
median_time = sorted(a)[n_run // 2 + n_run % 2]
print("Mesa Flocking (ms):", median_time*1e3)
