using Ark, Random

struct Position
    x::Int
    y::Int
end

struct Energy
    e::Float64
end

struct Sheep end
struct Wolf end

struct WolfSheepParams
    Δenergy_sheep::Float64
    Δenergy_wolf::Float64
    sheep_reproduce::Float64
    wolf_reproduce::Float64
    regrowth_time::Int
    dims::Tuple{Int, Int}
end

struct GrassGrid
    fully_grown::BitArray{2}
    countdown::Array{Int, 2}
end

struct WolfSheepBuffers
    entities::Vector{Entity}
end

function wolfsheep_model(rng, n_sheep, n_wolves, dims,
        regrowth_time, sheep_reproduce, wolf_reproduce;
        Δenergy_sheep = 5.0, Δenergy_wolf = 13.0,)
    
    world = World(Position, Energy, Sheep, Wolf)
    
    params = WolfSheepParams(Δenergy_sheep, Δenergy_wolf, sheep_reproduce, wolf_reproduce, regrowth_time, dims)
    add_resource!(world, params)
    
    add_resource!(world, WolfSheepBuffers(Entity[]))
    
    grass = GrassGrid(falses(dims), zeros(Int, dims))
    for i in 1:dims[1], j in 1:dims[2]
        fg = rand(rng, Bool)
        grass.fully_grown[i, j] = fg
        grass.countdown[i, j] = fg ? regrowth_time : rand(rng, 0:(regrowth_time - 1))
    end
    add_resource!(world, grass)
    
    sheep_grid = [Entity[] for _ in 1:dims[1], _ in 1:dims[2]]
    add_resource!(world, sheep_grid)
    
    for _ in 1:n_sheep
        pos = (rand(rng, 1:dims[1]), rand(rng, 1:dims[2]))
        energy = Float64(rand(rng, 0:(Int(Δenergy_sheep) * 2 - 1)))
        entity = new_entity!(world, (Position(pos...), Energy(energy), Sheep()))
        push!(sheep_grid[pos...], entity)
    end
    
    for _ in 1:n_wolves
        pos = (rand(rng, 1:dims[1]), rand(rng, 1:dims[2]))
        energy = Float64(rand(rng, 0:(Int(Δenergy_wolf) * 2 - 1)))
        new_entity!(world, (Position(pos...), Energy(energy), Wolf()))
    end
    
    return world
end

function random_walk(pos, dims, rng)
    offsets = ((-1,-1), (-1,0), (-1,1), (0,-1), (0,1), (1,-1), (1,0), (1,1))
    off = rand(rng, offsets)
    nx = clamp(pos.x + off[1], 1, dims[1])
    ny = clamp(pos.y + off[2], 1, dims[2])
    return Position(nx, ny)
end

function swap_remove!(v::Vector{Entity}, x::Entity)
    idx = findfirst(==(x), v)
    if idx !== nothing
        v[idx] = v[end]
        pop!(v)
    end
    return
end

function sheep_step!(world::World, rng, entities, params, grass, sheep_grid)
    for entity in entities
        pos, energy_comp = get_components(world, entity, (Position, Energy))
        energy = energy_comp.e
        
        new_pos = random_walk(pos, params.dims, rng)
        
        if pos != new_pos
            swap_remove!(sheep_grid[pos.x, pos.y], entity)
            push!(sheep_grid[new_pos.x, new_pos.y], entity)
        end
        
        energy -= 1.0
        if grass.fully_grown[new_pos.x, new_pos.y]
            energy += params.Δenergy_sheep
            grass.fully_grown[new_pos.x, new_pos.y] = false
        end
        
        if energy < 0
            swap_remove!(sheep_grid[new_pos.x, new_pos.y], entity)
            remove_entity!(world, entity)
        else
            if rand(rng) <= params.sheep_reproduce
                energy /= 2.0
                child = new_entity!(world, (new_pos, Energy(energy), Sheep()))
                push!(sheep_grid[new_pos.x, new_pos.y], child)
            end
            set_components!(world, entity, (new_pos, Energy(energy)))
        end
    end
end

function wolf_step!(world::World, rng, entities, params, sheep_grid)
    for entity in entities
        pos, energy_comp = get_components(world, entity, (Position, Energy))
        energy = energy_comp.e
        
        new_pos = random_walk(pos, params.dims, rng)
        energy -= 1.0
        
        potential_dinner = sheep_grid[new_pos.x, new_pos.y]
        if !isempty(potential_dinner)
            dinner_idx = rand(rng, 1:length(potential_dinner))
            dinner = potential_dinner[dinner_idx]
            potential_dinner[dinner_idx] = potential_dinner[end]
            pop!(potential_dinner)
            remove_entity!(world, dinner)
            energy += params.Δenergy_wolf
        end
        
        if energy < 0
            remove_entity!(world, entity)
        else
            if rand(rng) <= params.wolf_reproduce
                energy /= 2.0
                new_entity!(world, (new_pos, Energy(energy), Wolf()))
            end
            set_components!(world, entity, (new_pos, Energy(energy)))
        end
    end
end

function wolfsheep_step!(world::World, rng)
    params = get_resource(world, WolfSheepParams)
    grass = get_resource(world, GrassGrid)
    sheep_grid = get_resource(world, Array{Vector{Entity}, 2})
    buffers = get_resource(world, WolfSheepBuffers)
    entities = buffers.entities
    
    for species in shuffle(rng, [:Sheep, :Wolf])
        empty!(entities)
        if species == :Sheep
            for (ents,) in Query(world, (Sheep,))
                append!(entities, ents)
            end
            shuffle!(rng, entities)
            sheep_step!(world, rng, entities, params, grass, sheep_grid)
        else
            for (ents,) in Query(world, (Wolf,))
                append!(entities, ents)
            end
            shuffle!(rng, entities)
            wolf_step!(world, rng, entities, params, sheep_grid)
        end
    end
    
    for i in 1:params.dims[1], j in 1:params.dims[2]
        if !grass.fully_grown[i, j]
            if grass.countdown[i, j] <= 0
                grass.fully_grown[i, j] = true
                grass.countdown[i, j] = params.regrowth_time
            else
                grass.countdown[i, j] -= 1
            end
        end
    end
end

function step!(world::World, rng, n::Int = 1)
    for _ in 1:n
        wolfsheep_step!(world, rng)
    end
end
