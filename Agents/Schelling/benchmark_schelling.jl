using Agents
using BenchmarkTools

include("Schelling.jl")

a = @benchmark step!(model, agent_step!, model_step!, 200) setup = (
    (model, agent_step!, model_step!) = schelling()) samples = 100

println("Agents.jl Schelling (ms): ", minimum(a.times) * 1e-6)
