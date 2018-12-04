""" Task: Determine which claim does not overlap with any other """

struct Claim
    id::Int 
    leftoffset::Int
    topoffset::Int
    width::Int
    height::Int 
end

const edge = 1000

function checkclaim(claim, fabric)
    for i in claim.leftoffset+1:claim.leftoffset+claim.width
        for j in claim.topoffset+1:claim.topoffset+claim.height
            if fabric[i, j] > 1
                return false
            end
        end
    end
    return true
end

function findnooverlap(claims, fabric)
    for claim in claims
        thisone = checkclaim(claim, fabric)
        if thisone 
            return claim.id 
        end
    end
    # Return -1 if failure
    return -1::Int 
end

function parseclaim!(line, fabric)
    id = parse(Int, split(line, "@")[1][2:end])
    lo, to = parse.(Int, split(split(split(line, "@")[2], ":")[1], ","))
    w, h = parse.(Int, split(split(line, ":")[2], "x"))
    for i in lo+1:lo+w
        for j in to+1:to+h
            fabric[i, j] += 1
        end
    end
    return Claim(id, lo, to, w, h)
end

function main() 

    # Process the claims
    fabric = zeros(Int, edge, edge)
    claims = open("input.txt", "r") do file 
        claims = Array{Claim, 1}()
        for line in eachline(file)
            push!(claims, parseclaim!(line, fabric))
        end 
        claims 
    end

    println(findnooverlap(claims, fabric))

end

@time main()
