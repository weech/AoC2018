mutable struct Node{T}
    value::T 
    before::Union{Node{T}, Nothing}
    after::Union{Node{T}, Nothing}
end

Node(value) = Node(value, nothing, nothing)

mutable struct LinkedList{T}
    head::Union{Node{T}, Nothing}
    tail::Union{Node{T}, Nothing}
    length::UInt
end

function LinkedList(value) 
    head = Node(value)
    return LinkedList(head, nothing, one(UInt))
end

LinkedList() = LinkedList(nothing, nothing, 1)

Base.length(collection::LinkedList) = collection.length

function Base.push!(collection::LinkedList, items...)
    if length(collection) == 0 && length(items) > 1
        collection.head = Node(items[1])
        collection.tail = Node(items[2])
        collection.head.after = collection.tail 
        collection.tail.before = collection.head 
        collection.length = 2
        push!(collection, items[3:end]...)
    elseif length(collection) == 0 && length(items) == 1
        collection.head = Node(items[1])
        collection.length = 1
    elseif length(collection) == 1
        collection.tail = Node(items[1])
        collection.tail.before = collection.head 
        collection.head.after = collection.tail 
        collection.length = 2 
        push!(collection, items[2:end]...)
    else
        for item in items 
            newtail = Node(item)
            newtail.before = collection.tail 
            collection.tail.after = newtail
            collection.tail = newtail 
            collection.length += 1
        end
    end
end

function Base.pushfirst!(collection::LinkedList, items...)
    if length(collection) == 0 && length(items) >= 1
        push!(collection, items...)
    elseif length(collection) == 1
        newhead = Node(items[end])
        newhead.after = collection.head 
        collection.head.before = newhead 
        collection.tail = collection.head 
        collection.head = newhead 
        collection.length = 2
        pushfirst!(collection, items[1:end-1]...)
    else 
        for item in reverse(items)
            newhead = Node(item)
            newhead.after = collection.head
            collection.head.before = newhead 
            collection.head = newhead 
            collection.length += 1
        end
    end
end


function Base.popfirst!(collection::LinkedList) 
    if length(collection) == 0
        return nothing 
    elseif length(collection) == 1
        outval = collection.head.value 
        collection.head = nothing 
        collection.length = 0
        return outval 
    else
        newhead = collection.head.after 
        outval = collection.head.value 
        newhead.before = nothing 
        collection.head = newhead
        collection.length -= 1
        return outval 
    end
end

function Base.pop!(collection::LinkedList)
    newtail = collection.tail.before 
    outval = collection.tail.value 
    newtail.after = nothing 
    collection.tail = newtail 
    collection.length -= 1
    return outval
end

function rotate!(collection::LinkedList, factor::T) where T <: Integer
    if factor > 0
        for f in 1:factor
            oldhead = popfirst!(collection)
            push!(collection, oldhead)
        end
    else 
        for f in factor:0 
            oldtail = pop!(collection)
            pushfirst!(collection, oldtail)
        end
    end
end

function game(lastworth)
    game = LinkedList(0)
    score = zeros(UInt64, numplayers)

    for round in 1:lastworth 
        if round % 23 != 0
            rotate!(game, 1)
            push!(game, round)
        else
            rotate!(game, -7)
            score[round % numplayers + 1] += round + popfirst!(game)
            rotate!(game, 1)
        end
    end
    return maximum(score)
end

const numplayers = 473 
const initend = 70904
function main()
    println(game(initend))
    println(game(initend*100))
end
main()
    


