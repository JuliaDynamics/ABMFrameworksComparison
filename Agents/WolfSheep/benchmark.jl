using Agents
using BenchmarkTools

include("model.jl")

a = @benchmark step!(model, agent_step!, model_step!, 100) setup = (
    (model, agent_step!, model_step!) = predator_prey()) samples = 100

println("Agents.jl WolfSheep (ms): ", minimum(a.times) * 1e-6)

