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
a = min(tt.repeat(100, 1))
print("Mesa ForestFire (ms):", a*1e3)
