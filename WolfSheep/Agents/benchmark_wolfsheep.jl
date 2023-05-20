using Agents
using BenchmarkTools
using Random

include("WolfSheep.jl")

rng_seed = MersenneTwister(42)

a = @benchmark step!(model, agent_step!, model_step!, 500) setup = 
    ((model, agent_step!, model_step!) = predator_prey(Xoshiro(rand(rng_seed, 1:10000)))) evals=1 samples=100 

println("Agents.jl WolfSheep (ms): ", minimum(a.times) * 1e-6)
