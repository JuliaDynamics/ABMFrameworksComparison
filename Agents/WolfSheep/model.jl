@agent SheepWolf GridAgent{2} begin
    type::Symbol # :sheep or :wolf
    energy::Float64
    reproduction_prob::Float64
    Δenergy::Float64
end

Sheep(id, pos, energy, repr, Δe) = SheepWolf(id, pos, :sheep, energy, repr, Δe)
Wolf(id, pos, energy, repr, Δe) = SheepWolf(id, pos, :wolf, energy, repr, Δe)

function predator_prey(;
    n_sheep = 60,
    n_wolves = 40,
    dims = (25, 25),
    regrowth_time = 30,
    Δenergy_sheep = 5,
    Δenergy_wolf = 13,
    sheep_reproduce = 0.2,
    wolf_reproduce = 0.1,
)
    space = GridSpace(dims, periodic = false)
    properties = (
        fully_grown = falses(dims),
        countdown = zeros(Int, dims),
        regrowth_time = regrowth_time,
    )
    model = ABM(SheepWolf, space; properties, scheduler = Schedulers.by_property(:type))
    id = 0
    for _ in 1:n_sheep
        id += 1
        energy = rand(1:(Δenergy_sheep*2)) - 1
        sheep = Sheep(id, (0, 0), energy, sheep_reproduce, Δenergy_sheep)
        add_agent!(sheep, model)
    end
    for _ in 1:n_wolves
        id += 1
        energy = rand(1:(Δenergy_wolf*2)) - 1
        wolf = Wolf(id, (0, 0), energy, wolf_reproduce, Δenergy_wolf)
        add_agent!(wolf, model)
    end
    for p in positions(model) # random grass initial growth
        fully_grown = rand(abmrng(model), Bool)
        countdown = fully_grown ? regrowth_time : rand(abmrng(model), 1:regrowth_time) - 1
        model.countdown[p...] = countdown
        model.fully_grown[p...] = fully_grown
    end
    return model, predator_agent_step!, predator_model_step!
end

predator_agent_step!(agent::SheepWolf, model) =
    agent.type == :sheep ? sheep_step!(agent, model) : wolf_step!(agent, model)

function sheep_step!(sheep, model)
    randomwalk!(sheep, model, 1)
    sheep.energy -= 1
    sheep_eat!(sheep, model)
    if sheep.energy < 0
        kill_agent!(sheep, model)
        return
    end
    if rand(abmrng(model)) <= sheep.reproduction_prob
        wolfsheep_reproduce!(sheep, model)
    end
end

function wolf_step!(wolf, model)
    randomwalk!(wolf, model, 1)
    wolf.energy -= 1
    agents = collect(agents_in_position(wolf.pos, model))
    dinner = filter!(x -> x.type == :sheep, agents)
    wolf_eat!(wolf, dinner, model)
    if wolf.energy < 0
        kill_agent!(wolf, model)
        return
    end
    if rand(abmrng(model)) <= wolf.reproduction_prob
        wolfsheep_reproduce!(wolf, model)
    end
end

function sheep_eat!(sheep, model)
    if model.fully_grown[sheep.pos...]
        sheep.energy += sheep.Δenergy
        model.fully_grown[sheep.pos...] = false
    end
end

function wolf_eat!(wolf, sheep, model)
    if !isempty(sheep)
        dinner = rand(abmrng(model), sheep)
        kill_agent!(dinner, model)
        wolf.energy += wolf.Δenergy
    end
end

function wolfsheep_reproduce!(agent, model)
    agent.energy /= 2
    id = nextid(model)
    offspring = SheepWolf(
        id,
        agent.pos,
        agent.type,
        agent.energy,
        agent.reproduction_prob,
        agent.Δenergy,
    )
    add_agent_pos!(offspring, model)
    return
end

function predator_model_step!(model)
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


