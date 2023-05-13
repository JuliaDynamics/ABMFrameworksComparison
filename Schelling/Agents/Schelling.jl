using Agents

@agent SchellingAgent GridAgent{2} begin
    mood::Bool # whether the agent is happy in its position. (true = happy)
    group::Int # The group of the agent,  determines mood as it interacts with neighbors
end

function schelling(; numagents = 2000, griddims = (50, 50), min_to_be_happy = 3)
    @assert numagents < prod(griddims)
    space = GridSpaceSingle(griddims, periodic = false)
    properties = (min_to_be_happy = min_to_be_happy,)
    model = UnremovableABM(SchellingAgent, space; properties, scheduler = Schedulers.Randomly())
    for n in 1:numagents
        agent = SchellingAgent(n, (1, 1), false, n < numagents / 2 ? 1 : 2)
        add_agent_single!(agent, model)
    end
    return model, schelling_agent_step!, dummystep
end

function schelling_agent_step!(agent, model)
    agent.mood == true && return # do nothing if already happy
    count_neighbors_same_group = 0
    for neighbor in nearby_agents(agent, model)
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
