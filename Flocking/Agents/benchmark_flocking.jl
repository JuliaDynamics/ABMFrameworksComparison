using Agents
using BenchmarkTools
using Random

include("Flocking.jl")

rng_seed = MersenneTwister(42)

rng_model() = Xoshiro(rand(rng_seed, 1:10000))

function run_model(rng, extent, n_birds, visual_distance)
    model, agent_step!, model_step! = flocking(rng, extent, n_birds, visual_distance)
    step!(model, agent_step!, model_step!, 100)
end

n_run = 100

a = @benchmark run_model(rng, (100, 100), 200, 5.0) setup = (rng = rng_model()) evals=1 samples=n_run seconds=1e6
median_time = sort(a.times)[n_run ÷ 2 + n_run % 2]
println("Agents.jl Flocking-small (ms): ", median_time * 1e-6)

a = @benchmark run_model(rng, (150, 150), 400, 15.0) setup = (rng = rng_model()) evals=1 samples=n_run seconds=1e6
median_time = sort(a.times)[n_run ÷ 2 + n_run % 2]
println("Agents.jl Flocking-large (ms): ", median_time * 1e-6)