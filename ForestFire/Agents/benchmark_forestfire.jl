using Agents
using BenchmarkTools
using Random

include("ForestFire.jl")

rng_seed = MersenneTwister(42)

a = @benchmark step!(model, agent_step!, model_step!, 100) setup =
    ((model, agent_step!, model_step!) = forest_fire(Xoshiro(rand(rng_seed, 1:10000)))) evals=1 samples=100

println("Agents.jl ForestFire (ms): ", minimum(a.times) * 1e-6)
