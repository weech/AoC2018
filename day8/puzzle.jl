
struct Node 
    children::Array{Node, 1}
    meta::Array{Int, 1}
end

""" Node constructor """
function Node(line::Array{Int, 1})
    numchildren = line[1]
    nummeta = line[2]
    startidx = 3
    children = Array{Node, 1}(undef, numchildren)
    meta = Array{Int, 1}(undef, nummeta)
    for nc in 1:numchildren 
        child, numused = Node(line[startidx:end])
        children[nc] = child
        startidx += numused
    end
    for nm in 1:nummeta
        meta[nm] = line[startidx + nm-1]
    end
    return Node(children, meta), startidx + nummeta - 1
end
    
function puzzle1(root)
    if length(root.children) == 0
        return sum(root.meta)
    else
        return sum(root.meta) + sum([puzzle1(child) for child in root.children])
    end
end

function puzzle2(root)
    if length(root.children) == 0
        return sum(root.meta)
    else
        return sum([puzzle2(root.children[m]) for m in root.meta if m > 0 && m <= length(root.children)])
    end
end

function main() 
    line = open("input.txt") do file
        line = parse.(Int, split(strip(readline(file)), " "))
    end

    root, used = Node(line)
    if used != length(line)
        println(used, " ", length(line))
    end

    println(puzzle1(root))
    println(puzzle2(root))
end
main()
