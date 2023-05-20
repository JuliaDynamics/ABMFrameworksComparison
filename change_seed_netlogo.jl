using LightXML

xdoc = parse_file(ARGS[1])
xroot = root(xdoc) 

found = false

for c in child_elements(xroot)
	global found
    for cc in child_elements(c)
    	if attribute(cc, "variable"; required=false) == "seed"
    		ccc, _ = iterate(child_elements(cc))
    		set_attribute(ccc, "value", ARGS[2])
    		found = true 
       	end
    end
end

!found && error("No seed was found in XML!")
save_file(xdoc, ARGS[1])
free(xdoc)
