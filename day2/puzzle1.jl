""" Task: Read in a series of newline seperated values from a file. Count the number of lines that
    have a letter that occurs exactly twice and multiply by the number that have a letter that 
    occurs exactly three times.
"""

function main()
    checksum = open("input.txt", "r") do file 
        numdoubles = numtriples = 0
        for line in eachline(file)
            sorted = sort(split(line, ""))
            counts = Dict{String, Int}()
            for char in sorted
                if !(char in keys(counts))
                    counts[char] = 0
                end
                counts[char] += 1
            end 
            countset = Set{Int}()
            for count in values(counts)
                push!(countset, count)
            end 

            if 2 in countset
                numdoubles += 1
            end 
            if 3 in countset 
                numtriples += 1
            end
        end
        numdoubles * numtriples
    end
    println(checksum)
end

main()
