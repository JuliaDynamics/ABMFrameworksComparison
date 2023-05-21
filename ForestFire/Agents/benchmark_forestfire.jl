using Agents
using BenchmarkTools
using Random

include("ForestFire.jl")

rng_seed = MersenneTwister(42)

n_run = 100
a = @benchmark step!(model, agent_step!, model_step!, 100) setup =
    ((model, agent_step!, model_step!) = forest_fire(Xoshiro(rand(rng_seed, 1:10000)))) evals=1 samples=n_run

median_time = sort(a.times)[n_run // 2 + n_run % 2]
println("Agents.jl ForestFire (ms): ", median_time * 1e-6)
