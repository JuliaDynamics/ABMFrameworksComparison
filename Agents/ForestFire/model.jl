using Agents, Random

@agent Automata GridAgent{2} begin end

function forest_fire(; density = 1, griddims = (100, 100))
    space = GridSpaceSingle(griddims; periodic = false, metric = :manhattan)
    rng = Random.MersenneTwister()
    ## Empty = 0, Green = 1, Burning = 2, Burnt = 3
    forest = UnkillableABM(Automata, space; rng, properties = (trees = zeros(Int, griddims),))
    for I in CartesianIndices(forest.trees)
        if rand(abmrng(forest)) < density
            ## Set the trees at the left edge on fire
            forest.trees[I] = I[1] == 1 ? 2 : 1
        end
    end
    return forest, dummystep, tree_step!
end

function tree_step!(forest)
    ## Find trees that are burning (coded as 2)
    for I in findall(isequal(2), forest.trees)
        for idx in nearby_positions(I.I, forest)
            ## If a neighbor is Green (1), set it on fire (2)
            if forest.trees[idx...] == 1
                forest.trees[idx...] = 2
            end
        end
        ## Finally, any burning tree is burnt out (3)
        forest.trees[I] = 3
    end
end








