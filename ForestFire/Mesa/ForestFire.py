# This example deviates from Mesa's ForestFire in that it is
# performance optimized.

from mesa import Model
from mesa import Agent
from mesa.space import SingleGrid


class ForestFire(Model):
    """
    Simple Forest Fire model.
    """

    def __init__(self, seed, height, width, density):
        """
        Create a new forest fire model.
        Args:
            height, width: The size of the grid to model
            density: What fraction of grid cells have a tree in them.
        """
        super().__init__(seed=seed)
        # Set up model objects
        # Instead of actual agents, we just use a grid with the following encoding:
        # 0 = empty, 1 = tree, 2 = burning tree, 3 = burnt tree
        self.grid = SingleGrid(height, width, torus=False)
        self.trees = [[0] * width for _ in range(height)]
        self.burning_tree_coordinates = set()

        for x in range(width):
            for y in range(height):
                # Place a tree in each cell with Prob = density
                if self.random.random() < density:
                    # Set Trees in first column on fire.
                    if x == 0:
                        self.trees[x][y] = 2
                        self.burning_tree_coordinates.add((x, y))
                    else:
                        self.trees[x][y] = 1

    def step(self):
        """
        Advance the model by one step.
        """
        for x, y in list(self.burning_tree_coordinates):
            for nx, ny in self.grid.get_neighborhood(
                (x, y),
                moore=False,
            ):
                if self.trees[nx][ny] == 1:
                    self.trees[nx][ny] = 2
                    self.burning_tree_coordinates.add((nx, ny))
            self.trees[x][y] = 3
            self.burning_tree_coordinates.remove((x, y))
