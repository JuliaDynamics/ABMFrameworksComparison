using Agents, Random

@agent struct WealthAgent(NoSpaceAgent)
    wealth::Int
end

function wealth_model(; numagents = 100, initwealth = 1)
    model = ABM(WealthAgent; agent_step!, scheduler = Schedulers.Randomly(), 
                rng = Xoshiro(42), container = Vector)
    for _ in 1:numagents
        add_agent!(model, initwealth)
    end
    return model
end

function agent_step!(agent, model)
    agent.wealth == 0 && return
    agent.wealth -= 1
    random_agent(model).wealth += 1
end
