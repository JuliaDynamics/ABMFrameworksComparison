using Agents
using BenchmarkTools

include("model.jl")

a = @benchmark step!(model, agent_step!, model_step!, 100) setup = (
    (model, agent_step!, model_step!) = flocking(
        n_birds = 300,
        separation = 1,
        cohere_factor = 0.03,
        separate_factor = 0.015,
        match_factor = 0.05,
    )
)
println("Agents.jl Flocking (ms): ", minimum(a.times) * 1e-6)


