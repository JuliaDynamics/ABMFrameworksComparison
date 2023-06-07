using PrettyTables

frameworks = ["Agents.jl", "Mason", "Mesa", "NetLogo"]

models = ["WolfSheep-small", "WolfSheep-large", 
          "Flocking-small", "Flocking-large", 
          "Schelling-small", "Schelling-large", 
          "ForestFire-small", "ForestFire-large"]

frameworks_times = Dict(m => Dict(f => 0.0 for f in frameworks) for m in models)
		  
open("benchmark_results.txt", "r") do f
    for line in readlines(f)
        s_line = split(line)
        !in(s_line[1], frameworks) && continue
	!occursin("(ms)", line) && continue
        frameworks_times[String(s_line[2])][String(s_line[1])] = parse(Float64, s_line[4])
    end
end

frameworks_comparison = Dict(m => Dict(f => 0.0 for f in frameworks) for m in models)
for m in models
    for f in frameworks
        if f == "Agents.jl"
            frameworks_comparison[m][f] = 1
        else
            frameworks_times[m][f] == 0.0 && continue
            v = round(frameworks_times[m][f]/frameworks_times[m]["Agents.jl"], digits=1)
            frameworks_comparison[m][f] = v
        end
    end
end

columns = ["Model/Framework", "Agents.jl 5.15.0", "MASON 21.0", "Mesa 1.2.1", "Netlogo 6.3.0"]
results = mapreduce(permutedims, vcat, [vcat([m], [ifelse(frameworks_comparison[m][f] != 0, frameworks_comparison[m][f], ".") for f in frameworks]) for m in models])
conf = set_pt_conf(tf = tf_markdown, alignment = :c)
table = pretty_table_with_conf(conf, results; header = columns)
