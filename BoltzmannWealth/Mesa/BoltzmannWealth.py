

class MoneyAgent(mesa.Agent):
    """An agent with fixed initial wealth."""

    def __init__(self, unique_id, model):
        # Pass the parameters to the parent class.
        super().__init__(unique_id, model)

        # Create the agent's variable and set the initial values.
        self.wealth = 1

    def step(self):
        # Verify agent has some wealth
        if self.wealth > 0:
            other_agent = self.random.choice(self.model.agents)
            other_agent.wealth += 1
            self.wealth -= 1


class MoneyModel(mesa.Model):
    """A model with some number of agents."""

    def __init__(self, N):
        super().__init__()
        self.num_agents = N
        # Create scheduler and assign it to the model
        self.agents = [MoneyAgent(i, self) for i in range(self.num_agents)]

    def step(self):
        """Advance the model by one step."""
        self.random.shuffle(self.agents)
        for agent in self.agents:
            agent.step()

    def run_model(self, n_steps) -> None:
        for _ in range(n_steps):
            self.step()
