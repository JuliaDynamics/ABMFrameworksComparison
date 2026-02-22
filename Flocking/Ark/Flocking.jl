using Ark, LinearAlgebra, StaticArrays, Random

struct Position
    p::SVector{2, Float64}
end

struct Velocity
    v::SVector{2, Float64}
end

struct BirdParams
    speed::Float64
    cohere_factor::Float64
    separation::Float64
    separate_factor::Float64
    match_factor::Float64
    visual_distance::Float64
end

struct SpatialGrid
    entities::Array{Vector{Entity}, 2}
    extent::SVector{2, Float64}
    cell_size::Float64
    rows::Int
    cols::Int
end

function SpatialGrid(extent, cell_size)
    width, height = extent
    rows = max(1, ceil(Int, height / cell_size))
    cols = max(1, ceil(Int, width / cell_size))
    entities = [Entity[] for _ in 1:rows, _ in 1:cols]
    return SpatialGrid(entities, extent, cell_size, rows, cols)
end

function get_direction(from, to, extent)
    direct_dir = to .- from
    inverse_dir = direct_dir .- sign.(direct_dir) .* extent
    return map((x, y) -> abs(x) <= abs(y) ? x : y, direct_dir, inverse_dir)
end

function get_cell(grid::SpatialGrid, p::SVector{2, Float64})
    row = floor(Int, p[2] / grid.cell_size) + 1
    col = floor(Int, p[1] / grid.cell_size) + 1
    return clamp(row, 1, grid.rows), clamp(col, 1, grid.cols)
end

struct FlockingBuffers
    entities::Vector{Entity}
end

struct Range
    offsets::Vector{Vector{Tuple{Int, Int}}}
end

function compute_offsets(range, r)
    if isassigned(range.offsets, r)
        return range.offsets[r]
    else
        resize!(range.offsets, r)
        return range.offsets[r] = [(x, y) for x in -r:r for y in -r:r if x^2 + y^2 <= r^2]
    end
end

function flocking_model(rng, extent, n_birds, visual_distance;
        speed = 1.0, cohere_factor = 0.03, separation = 1.0, separate_factor = 0.015,
        match_factor = 0.05, spacing = visual_distance / 1.5,)
    
    world = World(Position, Velocity, BirdParams)

    params = BirdParams(speed, cohere_factor, separation, separate_factor, match_factor, visual_distance)
    
    all_entities = Entity[]
    resize!(all_entities, n_birds)
    for i in 1:n_birds
        pos = SVector{2, Float64}(rand(rng, Float64) * extent[1], rand(rng, Float64) * extent[2])
        vel = SVector{2, Float64}(rand(rng, Float64) * 2 - 1, rand(rng, Float64) * 2 - 1)
        entity = new_entity!(world, (Position(pos), Velocity(vel), params))
        all_entities[i] = entity
    end
    add_resource!(world, FlockingBuffers(all_entities))

    grid = SpatialGrid(SVector{2, Float64}(extent), spacing)
    for (entities, positions) in Query(world, (Position,))
        for i in eachindex(entities)
            row, col = get_cell(grid, positions[i].p)
            push!(grid.entities[row, col], entities[i])
        end
    end
    add_resource!(world, grid)
    add_resource!(world, Range(Vector{Tuple{Int, Int}}[]))
    
    return world
end

function swap_remove!(v::Vector{Entity}, x::Entity)
    idx = findfirst(==(x), v)
    if idx !== nothing
        v[idx] = v[end]
        pop!(v)
    end
end

function flocking_step!(world::World, rng)
    grid = get_resource(world, SpatialGrid)
    range = get_resource(world, Range)
    buffers = get_resource(world, FlockingBuffers)
    
    entities = buffers.entities
    shuffle!(rng, entities)
    
    @unchecked for entity in entities
        pos_comp, vel_comp, param = get_components(world, entity, (Position, Velocity, BirdParams))
        pos, vel = pos_comp.p, vel_comp.v
        
        match = separate = cohere = SVector{2, Float64}(0.0, 0.0)
        N = 0
        
        row, col = get_cell(grid, pos)
        radius = ceil(Int, param.visual_distance / grid.cell_size)

        for (dr, dc) in compute_offsets(range, radius)
            r, c = mod1(row + dr, grid.rows), mod1(col + dc, grid.cols)
            for neighbor_entity in grid.entities[r, c]
                if neighbor_entity == entity
                    continue
                end
                
                n_pos_comp, n_vel_comp = get_components(world, neighbor_entity, (Position, Velocity))
                n_pos, n_vel = n_pos_comp.p, n_vel_comp.v

                heading = get_direction(pos, n_pos, grid.extent)

                N += 1
                cohere += heading
                match += n_vel
                if sum(heading .^ 2) < param.separation^2
                    separate -= heading
                end
            end
        end
        
        cohere *= param.cohere_factor
        separate *= param.separate_factor
        match *= param.match_factor
        vel += (cohere + separate + match) / max(N, 1)
        vel /= norm(vel)

        new_pos = pos + vel * param.speed
        new_pos = mod1.(new_pos, grid.extent)

        old_row, old_col = get_cell(grid, pos)
        new_row, new_col = get_cell(grid, new_pos)
        if (old_row, old_col) != (new_row, new_col)
            swap_remove!(grid.entities[old_row, old_col], entity)
            push!(grid.entities[new_row, new_col], entity)
        end

        set_components!(world, entity, (Position(new_pos), Velocity(vel)))
    end
end

function step!(world::World, rng, n::Int = 1)
    for _ in 1:n
        flocking_step!(world, rng)
    end
end
