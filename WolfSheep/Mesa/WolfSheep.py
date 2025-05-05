"""
Wolf-Sheep Predation Model
================================

Replication of the model found in NetLogo:
    Wilensky, U. (1997). NetLogo Wolf Sheep Predation model.
    http://ccl.northwestern.edu/netlogo/models/WolfSheepPredation.
    Center for Connected Learning and Computer-Based Modeling,
    Northwestern University, Evanston, IL.
"""

import math, mesa

from mesa import model
from mesa.discrete_space import OrthogonalVonNeumannGrid
from mesa.experimental.devs import ABMSimulator

from agents import Sheep, Wolf, GrassPatch

class WolfSheep(Model):
    """
    Wolf-Sheep Predation Model
    
    A model for simulating wolf and sheep (predator-prey) ecosystem modelling.
    """

    def __init__(
        self,
        seed,
        height,
        width,
        initial_sheep,
        initial_wolves,
        sheep_reproduce,
        wolf_reproduce,
        grass_regrowth_time,
        wolf_gain_from_food=13,
        sheep_gain_from_food=5,
    ):
        """
        Create a new Wolf-Sheep model with the given parameters.

        Args:
            initial_sheep: Number of sheep to start with
            initial_wolves: Number of wolves to start with
            sheep_reproduce: Probability of each sheep reproducing each step
            wolf_reproduce: Probability of each wolf reproducing each step
            wolf_gain_from_food: Energy a wolf gains from eating a sheep
            grass: Whether to have the sheep eat grass for energy
            grass_regrowth_time: How long it takes for a grass patch to regrow
                                 once it is eaten
            sheep_gain_from_food: Energy sheep gain from grass, if enabled.
        """
        super().__init__(seed=seed)    
        # Set parameters
        self.height = height
        self.width = width
        self.initial_sheep = initial_sheep
        self.initial_wolves = initial_wolves
        self.sheep_reproduce = sheep_reproduce
        self.wolf_reproduce = wolf_reproduce
        self.wolf_gain_from_food = wolf_gain_from_food
        self.grass_regrowth_time = grass_regrowth_time
        self.sheep_gain_from_food = sheep_gain_from_food

        self.schedule = RandomActivationByType(self)
        self.grid = OrthogonalVonNeumannGrid([self.height, self.width],
            torus=False, capacity=math.inf, random=self.random,
        )

        # Create sheep:
        Sheep.create_agents(
            self,
            initial_sheep,
            energy=self.rng.random((initial_sheep,)) * 2 * sheep_gain_from_food,
            cell=self.random.choices(self.grid.all_cells.cells, k=initial_sheep),
        )

        # Create wolves
        Wolf.create_agents(
            self,
            initial_wolves,
            energy=self.rng.random((initial_wolves,)) * 2 * wolf_gain_from_food,
            cell=self.random.choices(self.grid.all_cells.cells, k=initial_wolves),
        )
        
        # Create grass patches
        possibly_fully_grown = [True, False]
        for cell in self.grid:
            fully_grown = self.random.choice(possibly_fully_grown)
            countdown = (
                0 if fully_grown else self.random.randrange(0, grass_regrowth_time)
            )
            GrassPatch(self, countdown, grass_regrowth_time, cell)

    def step(self):
        """Execute one step of the model."""
        # First activate all sheep, then all wolves, both in random order
        self.agents_by_type[Sheep].shuffle_do("step")
        self.agents_by_type[Wolf].shuffle_do("step")
