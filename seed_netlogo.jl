using LightXML, Random

n_run = parse(Int, ARGS[2])
rng_seed = MersenneTwister(42)

xdoc = parse_file(ARGS[1])
xroot = root(xdoc) 

found = false

println("ok")
for c in child_elements(xroot)
    global found
    for cc in child_elements(c)
        if attribute(cc, "variable"; required=false) == "seed"
            println("ok")
            for _ in 1:n_run
                seed = rand(rng_seed, 1:10000)
                e = new_child(cc, "value")  
                set_attribute(e, "value", seed)
            end
            found = true 
        end
    end
end

!found && error("No seed was found in XML!")
save_file(xdoc, ARGS[1])
free(xdoc)
