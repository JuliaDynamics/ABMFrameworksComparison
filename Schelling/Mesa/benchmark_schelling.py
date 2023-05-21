# Use Python 3

import timeit
import gc

setup = f"""
gc.enable()
import os, sys
sys.path.insert(0, os.path.abspath("."))

from Schelling import SchellingModel

import random
random.seed(42)

def runthemodel(schelling):
    for i in range(0, 10):
      schelling.step()

seed = random.randint(1, 10000)
schelling = SchellingModel(seed)
"""

tt = timeit.Timer('runthemodel(schelling)', setup=setup)
n_run = 100
a = tt.repeat(n_run, 1)
median_time = sorted(a)[n_run // 2 + n_run % 2]
print("Mesa Schelling (ms):", a*1e3)
