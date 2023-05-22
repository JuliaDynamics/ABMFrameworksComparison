# Use Python 3

import timeit
import gc

setup = f"""
gc.enable()
import os, sys
sys.path.insert(0, os.path.abspath("."))

from ForestFire import ForestFire

import random
random.seed(42)

def runthemodel(fire):
    for i in range(0, 100):
      fire.step()

seed = random.randint(1, 10000)
fire = ForestFire(seed)
"""

tt = timeit.Timer('runthemodel(fire)', setup=setup)
n_run = 100
a = tt.repeat(n_run, 1)
median_time = sorted(a)[n_run // 2 + n_run % 2]
print("Mesa ForestFire (ms):", a*1e3)
