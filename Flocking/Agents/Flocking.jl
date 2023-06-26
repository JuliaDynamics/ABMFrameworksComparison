using LinearAlgebra

@agent Bird ContinuousAgent{2} begin
    speed::Float64
    cohere_factor::Float64
    separation::Float64
    separate_factor::Float64
    match_factor::Float64
    visual_distance::Float64
end

function flocking(
    rng,
    extent,
    n_birds,
    visual_distance;
    speed = 1.0,
    cohere_factor = 0.03,
    separation = 1.0,
    separate_factor = 0.015,
    match_factor = 0.05,
    spacing = visual_distance / 1.5,
)
    space2d = ContinuousSpace(extent; spacing)
    model = UnremovableABM(Bird, space2d; scheduler = Schedulers.Randomly(), rng = rng)
    for n in 1:n_birds
        vel = ntuple(_ -> rand(model.rng), 2) .* 2 .- 1
        add_agent!(model, vel, speed, cohere_factor, separation, 
                   separate_factor, match_factor, visual_distance)
    end
    return model, flocking_agent_step!, dummystep
end

function flocking_agent_step!(bird, model)
    neighbor_agents = nearby_agents(bird, model, bird.visual_distance)
    N = 0
    match = separate = cohere = (0.0, 0.0)
    for neighbor in neighbor_agents
        N += 1
        heading = neighbor.pos .- bird.pos
        cohere = cohere .+ heading
        match = match .+ neighbor.vel
        if sum(heading.^2) < bird.separation^2
            separate = separate .- heading
        end
    end
    N = max(N, 1)
    cohere = cohere .* bird.cohere_factor
    separate = separate .* bird.separate_factor
    match = match .* bird.match_factor
    bird.vel = bird.vel .+ (cohere .+ separate .+ match) ./ N 
    bird.vel = bird.vel ./ norm(bird.vel)
    move_agent!(bird, model, bird.speed)
end
