using Agents, Random

@agent Automata GridAgent{2} begin end

function forest_fire(rng, density, griddims)
    space = GridSpaceSingle(griddims; periodic = false, metric = :manhattan)
    properties = (trees = zeros(Int, griddims), on_fire = Vector{NTuple{2, Int}}(),
                  n = Ref{Int}())
    forest = UnremovableABM(Automata, space; rng, properties = properties)
    for I in findall(<(density), rand(abmrng(forest), griddims...))
        if I[1] == 1
            forest.trees[I] = 2
            push!(forest.on_fire, Tuple(I))
        else
            forest.trees[I] = 1
        end
    end
    forest.n[] = length(forest.on_fire)
    resize!(forest.on_fire, reduce(*, size(forest.trees)))
    return forest, dummystep, tree_step!
end

function tree_step!(forest)
    k = 0
    for pos in @view forest.on_fire[1:forest.n[]]
        forest.trees[pos...] = 3
        for idx in nearby_positions(pos, forest)
            if forest.trees[idx...] == 1
                forest.trees[idx...] = 2
                k += 1
                forest.on_fire[k] = idx
            end
        end
    end
    forest.n[] = k
end
