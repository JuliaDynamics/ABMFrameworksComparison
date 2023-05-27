# Use Python 3

import timeit
import gc

setup = """
gc.enable()
import os, sys
sys.path.insert(0, os.path.abspath("."))

from ForestFire import ForestFire

import random
random.seed(42)

def runthemodel(seed, height, width, density):
    fire = ForestFire(seed, height, width, density)
    for i in range(0, 100):
      fire.step()

seed = random.randint(1, 10000)
height = {}
width = {}
density = {}
"""

n_run = 100

tt = timeit.Timer('runthemodel(seed, height, width, density)', setup=setup.format(100, 100, 0.7))
a = tt.repeat(n_run, 1)
median_time = sorted(a)[n_run // 2 + n_run % 2]
print("Mesa ForestFire-small (ms):", median_time*1e3)

tt = timeit.Timer('runthemodel(seed, height, width, density)', setup=setup.format(1000, 1000, 0.9))
a = tt.repeat(n_run, 1)
median_time = sorted(a)[n_run // 2 + n_run % 2]
print("Mesa ForestFire-large (ms):", median_time*1e3)
