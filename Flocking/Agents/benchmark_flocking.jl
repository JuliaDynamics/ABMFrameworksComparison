using Agents
using BenchmarkTools
using Random

include("Flocking.jl")

rng_seed = MersenneTwister(42)

a = @benchmark step!(model, agent_step!, model_step!, 100) setup = 
    ((model, agent_step!, model_step!) = flocking(Xoshiro(rand(rng_seed, 1:10000)))) evals=1 samples=100 

println("Agents.jl Flocking (ms): ", minimum(a.times) * 1e-6)

