""" Task: Find the two rows that differ by one character and print the common characters
"""

function searchcommon(lines)

    for idx1 in 1:length(lines)-1, idx2 in idx1:length(lines)
        line1 = collect(lines[idx1])
        line2 = collect(lines[idx2])
        
        # Difference the arrays of Char
        diff = line1 .- line2 .!= 0
        if sum(line1 .- line2 .!= 0) == 1
            return join(line1[.~diff])
        end
    end
    return "failed"      
end


function main()
    lines = readlines(open("input.txt", "r"))
    println(searchcommon(lines))

end

main()
