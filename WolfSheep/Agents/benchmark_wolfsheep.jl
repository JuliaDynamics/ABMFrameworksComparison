using Agents
using BenchmarkTools
using Random

include("WolfSheep.jl")

rng_seed = MersenneTwister(42)

rng_model() = Xoshiro(rand(rng_seed, 1:10000))

function run_model(rng, n_sheep, n_wolves, dims, regrowth_time,
        sheep_reproduce, wolf_reproduce)
    model = predator_prey_model(rng, n_sheep, n_wolves, dims, regrowth_time,
        sheep_reproduce, wolf_reproduce)
    step!(model, 100)
end

n_run = 100

a = @benchmark run_model(rng, 60, 40, (25, 25), 20, 0.2, 0.1) setup=(rng = rng_model()) evals=1 samples=n_run seconds=1e6
median_time = sort(a.times)[n_run ÷ 2 + n_run % 2]
println("Agents.jl WolfSheep-small (ms): ", median_time * 1e-6)

a = @benchmark run_model(rng, 1000, 500, (100, 100), 10, 0.4, 0.2) setup=(rng = rng_model()) evals=1 samples=n_run seconds=1e6
median_time = sort(a.times)[n_run ÷ 2 + n_run % 2]
println("Agents.jl WolfSheep-large (ms): ", median_time * 1e-6)
