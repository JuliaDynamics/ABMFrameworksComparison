using Agents
using BenchmarkTools

include("Flocking.jl")

a = @benchmark step!(model, agent_step!, model_step!, 200) setup = (
    (model, agent_step!, model_step!) = flocking()) samples=10

println("Agents.jl Flocking (ms): ", minimum(a.times) * 1e-6)


