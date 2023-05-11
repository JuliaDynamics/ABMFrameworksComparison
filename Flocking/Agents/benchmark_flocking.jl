using Agents
using BenchmarkTools

include("Flocking.jl")

a = @benchmark step!(model, agent_step!, model_step!, 100) setup = (
    (model, agent_step!, model_step!) = flocking()) samples=100

println("Agents.jl Flocking (ms): ", minimum(a.times) * 1e-6)


