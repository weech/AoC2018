""" Task: Read in a series of newline seperated values from a file. These values are deltas, and the initial
	value is 0. What is the first value that is reached twice?
"""

function main()
    deltas = open("input.txt", "r") do file 
        deltalist = Int[];
        for line in eachline(file)
            push!(deltalist, parse(Int, line))
        end
        deltalist
    end
    
    # Loop through repeatedly keeping track of current and previous values
    currentvalue = 0
    pastvalues = Set([currentvalue])
    for delta in Iterators.cycle(deltas)
        currentvalue += delta 
        if currentvalue in pastvalues 
            break
        else
            push!(pastvalues, currentvalue)
        end
    end
    println(currentvalue)
end

main()
