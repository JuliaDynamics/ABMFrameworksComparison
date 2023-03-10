using Agents
using BenchmarkTools

include("model.jl")

a = @benchmark step!(model, agent_step!, model_step!, 500) setup = (
    (model, agent_step!, model_step!) = predator_prey(
        n_wolves = 40,
        n_sheep = 60,
        dims = (25, 25),
        Δenergy_sheep = 5,
        Δenergy_wolf = 13,
        sheep_reproduce = 0.2,
        wolf_reproduce = 0.1,
        regrowth_time = 20,
    )
) samples = 100

println("Agents.jl WolfSheep (ms): ", minimum(a.times) * 1e-6)

