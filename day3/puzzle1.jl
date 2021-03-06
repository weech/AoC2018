""" Task: Determine the number of claims that overlap on a grid """

struct Claim
    id::Int 
    leftoffset::Int
    topoffset::Int
    width::Int
    height::Int 
end

const edge = 1000

function main() 

    # Process the claims
    claims = open("input.txt", "r") do file 
        claims = Array{Claim, 1}()
        for line in eachline(file)
            id = parse(Int, split(line, "@")[1][2:end])
            offsets = parse.(Int, split(split(split(line, "@")[2], ":")[1], ","))
            size = parse.(Int, split(split(line, ":")[2], "x"))
            push!(claims, Claim(id, offsets[1], offsets[2], size[1], size[2]))
        end 
        claims 
    end

    # Create a fabric 2d array and increment the count for each time an element is claimed
    fabric = zeros(Int, edge, edge)
    for claim in claims
        for i in claim.leftoffset+1:claim.leftoffset+claim.width
            for j in claim.topoffset+1:claim.topoffset+claim.height
                fabric[i, j] += 1
            end
        end
    end

    # Count number of elements greater than or equal to 2
    println(sum(fabric .> 1))

end

main()
