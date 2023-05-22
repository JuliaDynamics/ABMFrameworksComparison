# Use Python 3

# Only collect the number of wolves and sheeps per step.

import timeit
import gc

setup = f"""
gc.enable()
import os, sys
sys.path.insert(0, os.path.abspath("."))

from agents import Sheep, Wolf, GrassPatch
from WolfSheep import WolfSheep

import random
random.seed(42)

def runthemodel(wolfsheep):
    for i in range(0, 500):
      wolfsheep.step()

seed = random.randint(1, 10000)
wolfsheep = WolfSheep(seed)
"""

tt = timeit.Timer('runthemodel(wolfsheep)', setup=setup)
n_run = 100
a = tt.repeat(n_run, 1)
median_time = sorted(a)[n_run // 2 + n_run % 2]
print("Mesa WolfSheep (ms):", median_time*1e3)