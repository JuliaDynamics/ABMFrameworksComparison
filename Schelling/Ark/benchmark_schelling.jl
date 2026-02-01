using Ark
using BenchmarkTools
using Random

include("Schelling.jl")

rng_seed = MersenneTwister(42)

rng_model() = Xoshiro(rand(rng_seed, 1:10000))

function run_model(rng, numagents, griddims, min_to_be_happy, radius)
    world = schelling_model(rng, numagents, griddims, min_to_be_happy, radius)
    step!(world, rng, 100)
end

n_run = 100

a = @benchmark run_model(rng, 1000, (50, 50), 3, 1) setup=(rng = rng_model()) evals=1 samples=n_run seconds=1e6
median_time = sort(a.times)[n_run ÷ 2 + n_run % 2]
println("Ark.jl Schelling-small (ms): ", median_time * 1e-6)

a = @benchmark run_model(rng, 2000, (100, 100), 10, 5) setup=(rng = rng_model()) evals=1 samples=n_run seconds=1e6
median_time = sort(a.times)[n_run ÷ 2 + n_run % 2]
println("Ark.jl Schelling-large (ms): ", median_time * 1e-6)
