using Ark
using BenchmarkTools
using Random
using StaticArrays

include("Flocking.jl")

rng_seed = MersenneTwister(42)

rng_model() = Xoshiro(rand(rng_seed, 1:10000))

function run_model(rng, extent, n_birds, visual_distance)
    world = flocking_model(rng, extent, n_birds, visual_distance)
    step!(world, rng, 100)
end

n_run = 100

a = @benchmark run_model(rng, (100.0, 100.0), 200, 5.0) setup=(rng = rng_model()) evals=1 samples=n_run seconds=1e6
median_time = sort(a.times)[n_run ÷ 2 + n_run % 2]
println("Ark.jl Flocking-small (ms): ", median_time * 1e-6)

a = @benchmark run_model(rng, (150.0, 150.0), 400, 15.0) setup=(rng = rng_model()) evals=1 samples=n_run seconds=1e6
median_time = sort(a.times)[n_run ÷ 2 + n_run % 2]
println("Ark.jl Flocking-large (ms): ", median_time * 1e-6)
