using Agents
using BenchmarkTools
using Random

include("Schelling.jl")

rng_seed = MersenneTwister(42)

a = @benchmark step!(model, agent_step!, model_step!, 10) setup = 
    ((model, agent_step!, model_step!) = schelling(Xoshiro(rand(rng_seed, 1:10000)))) evals=1 samples=100 

println("Agents.jl Schelling (ms): ", minimum(a.times) * 1e-6)