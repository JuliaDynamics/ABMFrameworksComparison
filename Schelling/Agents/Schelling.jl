using Agents

@agent struct SchellingAgent(GridAgent{2})
    mood::Bool # whether the agent is happy in its position. (true = happy)
    const group::Int # The group of the agent,  determines mood as it interacts with neighbors
end

function schelling_model(rng, numagents, griddims, min_to_be_happy, radius)
    space = GridSpaceSingle(griddims, periodic = false)
    properties = (min_to_be_happy = min_to_be_happy, radius = radius)
    model = StandardABM(SchellingAgent, space; agent_step!, properties, rng,
        container = Vector, scheduler = Schedulers.Randomly())
    for n in 1:numagents
        add_agent_single!(model, false, n < numagents / 2 ? 1 : 2)
    end
    return model
end

function agent_step!(agent, model)
    count_neighbors_same_group = 0
    for neighbor in nearby_agents(agent, model, model.radius)
        if agent.group == neighbor.group
            count_neighbors_same_group += 1
        end
    end
    if count_neighbors_same_group ≥ model.min_to_be_happy
        agent.mood = true
    else
        move_agent_single!(agent, model)
    end
end
