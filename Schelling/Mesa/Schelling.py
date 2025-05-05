import random

from mesa import Model
from mesa.discrete_space import CellAgent, OrthogonalMooreGrid

class SchellingAgent(CellAgent):
    '''
    Schelling segregation agent
    '''
    def __init__(self, cell, model, agent_type):
        '''
         Create a new Schelling agent.
         Args:
            unique_id: Unique identifier for the agent.
            x, y: Agent initial location.
            agent_type: Indicator for the agent's type (minority=1, majority=0)
        '''
        super().__init__(model)
        self.cell = cell
        self.type = agent_type

    def step(self):
        similar = 0
        r = self.model.radius
        for neighbor in self.cell.get_neighborhood(radius=self.radius).agents:
            if neighbor.type == self.type:
                similar += 1

        # If unhappy, move:
        if similar < self.model.homophily:
            self.cell = self.model.grid.select_random_empty_cell()
        else:
            self.model.happy += 1


class SchellingModel(Model):
    '''
    Model class for the Schelling segregation model.
    '''

    def __init__(self, seed, height, width, homophily, radius, density, minority_pc=0.5):
        '''
        '''
        super().__init__(seed=seed)
        self.height = height
        self.width = width
        self.density = density
        self.minority_pc = minority_pc
        self.homophily = homophily
        self.radius = radius
        self.grid = OrthogonalMooreGrid((width, height), random=self.random, capacity=1)
        self.happy = 0

        for cell in self.grid.all_cells:
            if self.random.random() < self.density:
                agent_type = 1 if self.random.random() < minority_pc else 0
                SchellingAgent(self, cell, agent_type)

    def step(self):
        '''
        Run one step of the model.
        '''
        self.happy = 0  # Reset counter of happy agents
        self.agents.shuffle_do("step")
