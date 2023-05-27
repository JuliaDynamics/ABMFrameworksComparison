using Agents
using BenchmarkTools
using Random

include("ForestFire.jl")

rng_seed = MersenneTwister(42)

rng_model() = Xoshiro(rand(rng_seed, 1:10000))

function run_model(rng, density, griddims)
    model, agent_step!, model_step! = forest_fire(rng, density, griddims)
    step!(model, agent_step!, model_step!, 100)
end

n_run = 100

a = @benchmark run_model(rng, 0.7, (100, 100)) setup = (rng = rng_model()) evals=1 samples=n_run seconds=1e6
median_time = sort(a.times)[n_run ÷ 2 + n_run % 2]
println("Agents.jl ForestFire-small (ms): ", median_time * 1e-6)

a = @benchmark run_model(rng, 0.9, (1000, 1000)) setup = (rng = rng_model()) evals=1 samples=n_run seconds=1e6
median_time = sort(a.times)[n_run ÷ 2 + n_run % 2]
println("Agents.jl ForestFire-large (ms): ", median_time * 1e-6)
