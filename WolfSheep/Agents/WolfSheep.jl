using Agents

@multiagent :opt_speed struct Animal(GridAgent{2})
    @agent struct Wolf
        energy::Float64
        const reproduction_prob::Float64
        const Δenergy::Float64
    end
    @agent struct Sheep
        energy::Float64
        const reproduction_prob::Float64
        const Δenergy::Float64
    end
end

function predator_prey_model(rng, n_sheep, n_wolves, dims,
        regrowth_time, sheep_reproduce, wolf_reproduce;
        Δenergy_sheep = 5, Δenergy_wolf = 13,)
    space = GridSpace(dims, periodic = false)
    properties = (fully_grown = falses(dims), countdown = zeros(Int, dims),
        regrowth_time = regrowth_time)
    scheduler = Schedulers.ByProperty(kindof)
    model = ABM(Animal, space; agent_step!, model_step!, scheduler,
        properties, rng, warn = false)
    for _ in 1:n_sheep
        energy = rand(abmrng(model), 0:(Δenergy_sheep * 2 - 1))
        add_agent!(Sheep, model, energy, sheep_reproduce, Δenergy_sheep)
    end
    for _ in 1:n_wolves
        energy = rand(abmrng(model), 0:(Δenergy_wolf * 2 - 1))
        add_agent!(Wolf, model, energy, wolf_reproduce, Δenergy_wolf)
    end
    @inbounds for p in positions(model)
        fully_grown = rand(abmrng(model), Bool)
        countdown = fully_grown ? regrowth_time : rand(abmrng(model), 0:(regrowth_time - 1))
        model.countdown[p...] = countdown
        model.fully_grown[p...] = fully_grown
    end
    return model
end

function agent_step!(agent, model)
    randomwalk!(agent, model; ifempty = false)
    agent.energy -= 1
    eat!(agent, model)
    if agent.energy < 0
        remove_agent!(agent, model)
    elseif rand(abmrng(model)) <= agent.reproduction_prob
        agent.energy /= 2
        replicate!(agent, model)
    end
end

eat!(a, model) = kindof(a) === :Sheep ? sheep_eat!(a, model) : wolf_eat!(a, model)

function sheep_eat!(sheep, model)
    if model.fully_grown[sheep.pos...]
        sheep.energy += sheep.Δenergy
        model.fully_grown[sheep.pos...] = false
    end
end

function wolf_eat!(wolf, model)
    dinner = random_agent_in_position(wolf.pos, model, is_sheep)
    if !isnothing(dinner)
        remove_agent!(dinner, model)
        wolf.energy += wolf.Δenergy
    end
end

is_sheep(agent) = agent isa Sheep

function model_step!(model)
    @inbounds for p in positions(model)
        if !(model.fully_grown[p...])
            if model.countdown[p...] ≤ 0
                model.fully_grown[p...] = true
                model.countdown[p...] = model.regrowth_time
            else
                model.countdown[p...] -= 1
            end
        end
    end
end
