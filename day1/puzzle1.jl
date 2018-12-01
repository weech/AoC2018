""" Task: Read in a series of newline seperated values from a file. These values are deltas, and the initial
	value is 0. What is the final value?
"""

function main()
    currentvalue = open("input.txt", "r") do file 
        value = 0 
        for line in eachline(file)
            value += parse(Int, line)
        end
        value
    end
    println(currentvalue)
end

main()
