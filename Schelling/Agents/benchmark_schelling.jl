using Agents
using BenchmarkTools
using Random

include("Schelling.jl")

rng_seed = MersenneTwister(42)

rng_model() = Xoshiro(rand(rng_seed, 1:10000))

function run_model(rng, numagents, griddims, min_to_be_happy, radius)
    model, agent_step!, model_step! = schelling(rng, numagents, griddims, min_to_be_happy, radius)
    step!(model, agent_step!, model_step!, 20)
end

n_run = 100

a = @benchmark run_model(rng, 1000, (40, 40), 3, 1) setup = (rng = rng_model()) evals=1 samples=n_run seconds=1e6
median_time = sort(a.times)[n_run ÷ 2 + n_run % 2]
println("Agents.jl Schelling-small (ms): ", minimum(a.times) * 1e-6)

a = @benchmark run_model(rng, 5000, (100, 100), 8, 2) setup = (rng = rng_model()) evals=1 samples=n_run seconds=1e6
median_time = sort(a.times)[n_run ÷ 2 + n_run % 2]
println("Agents.jl Schelling-large (ms): ", minimum(a.times) * 1e-6)
