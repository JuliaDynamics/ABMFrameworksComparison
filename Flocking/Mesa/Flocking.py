"""
Flockers
=============================================================
A Mesa implementation of Craig Reynolds's Boids flocker model.
Uses numpy arrays to represent vectors.
"""

import numpy as np

from mesa import Model
from mesa.experimental.continuous_space import ContinuousSpace

from boid import Boid

class BoidFlockers(Model):
    """
    Flocker model class. Handles agent creation, placement and scheduling.
    """

    def __init__(
        self,
        seed,
        population_size,
        width,
        height,
        vision,
        speed=1,
        separation=1,
        cohere=0.03,
        separate=0.015,
        match=0.05,
    ):
        """
        Create a new Flockers model.

        Args:
            population: Number of Boids
            width, height: Size of the space.
            speed: How fast should the Boids move.
            vision: How far around should each Boid look for its neighbors
            separation: What's the minimum distance each Boid will attempt to
                    keep from any other
            cohere, separate, match: factors for the relative importance of
                    the three drives.        """
        super().__init__(seed=seed)

        # Set up the space
        self.space = ContinuousSpace(
            [[0, width], [0, height]],
            torus=True,
            random=self.random,
            n_agents=population_size,
        )

        # Create and place the Boid agents
        positions = self.rng.random(size=(population_size, 2)) * self.space.size
        directions = self.rng.uniform(-1, 1, size=(population_size, 2))
        Boid.create_agents(
            self,
            population_size,
            self.space,
            position=positions,
            direction=directions,
            cohere=cohere,
            separate=separate,
            match=match,
            speed=speed,
            vision=vision,
            separation=separation,
        )

        # For tracking statistics
        self.average_heading = None
        self.update_average_heading()

    def update_average_heading(self):
        """Calculate the average heading (direction) of all Boids."""
        if not self.agents:
            self.average_heading = 0
            return

        headings = np.array([agent.direction for agent in self.agents])
        mean_heading = np.mean(headings, axis=0)
        self.average_heading = np.arctan2(mean_heading[1], mean_heading[0])

    def step(self):
        """Run one step of the model.

        All agents are activated in random order using the AgentSet shuffle_do method.
        """
        self.agents.shuffle_do("step")
        self.update_average_heading()
