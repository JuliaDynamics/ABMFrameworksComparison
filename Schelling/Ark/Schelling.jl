using Ark, Random

struct Position
    x::Int
    y::Int
end

struct Range
    offsets::Vector{Tuple{Int,Int}}
end

struct Group
    id::Int8
end

struct SchellingGrid
    grid::Array{Entity, 2}
    empty_positions::Vector{Position}
end

struct SchellingBuffers
    entities::Vector{Entity}
end

function schelling_model(rng, numagents, griddims, min_to_be_happy, r)
    world = World(Position, Group)
    
    grid_data = fill(zero_entity, griddims)
    empty_positions = [Position(x, y) for x in 1:griddims[1] for y in 1:griddims[2]]
    shuffle!(rng, empty_positions)
    
    grid = SchellingGrid(grid_data, empty_positions)
    add_resource!(world, grid)
    add_resource!(world, (min_to_be_happy = min_to_be_happy, radius = r, dims = griddims))
    
    for n in 1:numagents
        group = n <= numagents / 2 ? 1 : 2
        pos = pop!(grid.empty_positions)
        entity = new_entity!(world, (pos, Group(group)))
        grid.grid[pos.x, pos.y] = entity
    end
    
    all_entities = Entity[]
    for (entities,) in Query(world, (Position,))
        append!(all_entities, entities)
    end
    add_resource!(world, SchellingBuffers(all_entities))

    add_resource!(world, Range([(x, y) for x in -r:r for y in -r:r if (x != 0 || y != 0)]))

    return world
end

function schelling_step!(world::World, rng)
    grid = get_resource(world, SchellingGrid)
    props = get_resource(world, NamedTuple{(:min_to_be_happy, :radius, :dims), Tuple{Int, Int, Tuple{Int, Int}}})
    buffers = get_resource(world, SchellingBuffers)
    offsets = get_resource(world, Range).offsets
    nempty = length(grid.empty_positions)

    all_entities = buffers.entities
    shuffle!(rng, all_entities)
    
    @inbounds for entity in all_entities
        pos, group = get_components(world, entity, (Position, Group))
        
        count_neighbors_same_group = 0
        for (dx, dy) in offsets
            nx, ny = pos.x + dx, pos.y + dy
            if 1 <= nx <= props.dims[1] && 1 <= ny <= props.dims[2]
                neighbor_entity = grid.grid[nx, ny]
                if neighbor_entity != zero_entity
                    n_group, = get_components(world, neighbor_entity, (Group,))
                    count_neighbors_same_group += (n_group.id == group.id)
                end
            end
        end
        
        if count_neighbors_same_group < props.min_to_be_happy
            idx = rand(rng, 1:nempty)
            new_pos = grid.empty_positions[idx]
            grid.empty_positions[idx] = pos

            grid.grid[pos.x, pos.y] = zero_entity
            grid.grid[new_pos.x, new_pos.y] = entity
      
            set_components!(world, entity, (new_pos,))
        end
    end
end

function step!(world::World, rng, n::Int = 1)
    for _ in 1:n
        schelling_step!(world, rng)
    end
end
