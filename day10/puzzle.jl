struct Point 
    x::Int
    y::Int 
    u::Int 
    v::Int 
end

function Point(line) 
    position, velocity = split(line, "v")
    px, py = split(position, ",")
    x = parse(Int, split(px, "<")[2])
    y = parse(Int, split(py, ">")[1])

    vx, vy = split(velocity, ",")
    u = parse(Int, split(vx, "<")[2])
    v = parse(Int, split(vy, ">")[1])
    return Point(x, y, u, v)
end

function Point(point, offset)
    return Point(point.x + offset*point.u, point.y + offset*point.v, point.u, point.v)
end

function findBBox(points)
    minx = 100000
    maxx = -100000
    miny = 1000000
    maxy = -1000000
    for p in points
        if p.x < minx
            minx = p.x
        end
        if p.x > maxx
            maxx = p.x
        end
        if p.y < miny
            miny = p.y
        end
        if p.y > maxy
            maxy = p.y
        end
    end
    return minx, maxx, miny, maxy
end

const testnum = 20_000
function findMinIndex(points)
    bboxes = Array{Int, 1}(undef, testnum)
    for i in 1:testnum 
        bbox = findBBox([Point(p, i) for p in points])
        bboxes[i] = (bbox[2]-bbox[1])*(bbox[4]-bbox[3])
    end
    return argmin(bboxes)
end

function main()

    points = open("input.txt") do file
        points = [Point(line) for line in eachline(file)]
    end

    idx = findMinIndex(points)
    newpoints = [Point(p, idx) for p in points]
    minx, maxx, miny, maxy = findBBox(newpoints)
    chars = fill(" ", maxx-minx+1, maxy-miny+1)
    for p in newpoints
        chars[p.x-minx+1, p.y-miny+1] = "#"
    end
    for row in 1:size(chars)[2]
        println(join(chars[:, row]))
    end
    println(idx)

end
main()
