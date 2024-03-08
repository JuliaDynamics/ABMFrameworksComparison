using Agents, LinearAlgebra

@agent struct Bird(ContinuousAgent{2, Float64})
    const speed::Float64
    const cohere_factor::Float64
    const separation::Float64
    const separate_factor::Float64
    const match_factor::Float64
    const visual_distance::Float64
end

function flocking_model(rng, extent, n_birds, visual_distance;
        speed = 1.0, cohere_factor = 0.03, separation = 1.0, separate_factor = 0.015,
        match_factor = 0.05, spacing = visual_distance / 1.5,)
    space2d = ContinuousSpace(extent; spacing)
    model = StandardABM(Bird, space2d; agent_step!, rng, container = Vector,
        scheduler = Schedulers.Randomly())
    for n in 1:n_birds
        vel = SVector{2}(rand(abmrng(model)) * 2 - 1 for _ in 1:2)
        add_agent!(model, vel, speed, cohere_factor, separation,
            separate_factor, match_factor, visual_distance)
    end
    return model
end

function agent_step!(bird, model)
    neighbor_agents = nearby_agents(bird, model, bird.visual_distance)
    N = 0
    match = separate = cohere = SVector{2}(0.0, 0.0)
    for neighbor in neighbor_agents
        N += 1
        heading = get_direction(bird.pos, neighbor.pos, model)
        cohere += heading
        match += neighbor.vel
        if sum(heading .^ 2) < bird.separation^2
            separate -= heading
        end
    end
    cohere *= bird.cohere_factor
    separate *= bird.separate_factor
    match *= bird.match_factor
    bird.vel += (cohere + separate + match) / max(N, 1)
    bird.vel /= norm(bird.vel)
    move_agent!(bird, model, bird.speed)
end
