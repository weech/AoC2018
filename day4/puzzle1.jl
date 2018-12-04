# Task: Determine which guard has the most minutes asleep and what minute
#       does that guard spend asleep the most?

using Dates

struct Entry
    date::DateTime
    event::String
end

mutable struct Guard
    id::Int
    asleep::Array{Int64, 1}
    lastasleep::Int
end

function Guard(id::Int)
    return Guard(id, zeros(Int64, 60), 0)
end

Guard() = Guard(-1, Array{Int64, 1}(undef, 1), -1)

const df = DateFormat("yyyy-mm-dd HH:MM")

function parseentry(line)
    datetimestr = split(line, "]")[1][2:end]
    date = DateTime(datetimestr, df)
    event = strip(split(line, "]")[2])
    return Entry(date, event)
end

function eventlogic!(guards, currentguard, entry)
    # It's a new guard posting
    if occursin("#", entry.event)
        idbit = parse(Int, split(split(entry.event, "#")[2], " ")[1])

        # If we've seen this guard before put them in currentguard
        currentguard = get!(guards, idbit, Guard(idbit))

    # The current guard falls asleep
    elseif occursin("falls", entry.event)
        currentguard.lastasleep = minute(entry.date)

    # Only other option is the guard wakes up
    else
        currentguard.asleep[currentguard.lastasleep+1:minute(entry.date)] .+= 1
    end
    return currentguard
end

function main()

    # Process the entries
    entries = open("input.txt", "r") do file
        entries = [parseentry(line) for line in eachline(file)]
        sort(entries, by=x->x.date)
    end

    # Assign napping times to each guard
    guards = Dict{Int, Guard}()
    currentguard = Guard()
    for entry in entries
        currentguard = eventlogic!(guards, currentguard, entry)
    end

    # Find the sleepiest guard and their favorite sleepy time
    sleepiest = sort(collect(values(guards)), by=x->sum(x.asleep))[end]
    peaknap = argmax(sleepiest.asleep) - 1
    println(sleepiest.id * peaknap)

end

main()
