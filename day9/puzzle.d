import std.stdio;
import std.algorithm;
import std.conv;

enum numplayers = 473;
enum startgamelength = 70904;

class LinkedList(T) {
    Node!T head;
    Node!T tail;
    int length;

    this(T value1, T value2) {
        head = new Node!T(value1);
        tail = new Node!T(value2);
        head.after = tail;
        tail.before = head;
        length = 2;
    }

    void insertEnd(T value) {
        Node!T newtail = new Node!T(value);
        newtail.before = this.tail;
        this.tail.after = newtail;
        this.tail = newtail;
        this.length += 1;
    }

    void insertFront(T value) {
        Node!T newhead = new Node!T(value);
        newhead.after = this.head;
        this.head.before = newhead;
        this.head = newhead;
        this.length += 1;
    }

    T popBack() {
        this.tail.before.after = null;
        T value = this.tail.value;
        this.tail = this.tail.before;
        length -= 1;
        return value;
    }

    T popFront() {
        this.head.after.before = null;
        T value = this.head.value;
        this.head = this.head.after;
        length -= 1;
        return value;
    }

    T popIndex(int idx) {
        if (idx == this.length) {
            return popBack();
        }
        else if (idx == 0) {
            return popFront();
        }
        else {
            auto currnode = findIndex(idx);
            currnode.before.after = currnode.after;
            currnode.after.before = currnode.before;
            length -= 1;
            return currnode.value;
        }
    }

    void addBeforeIndex(T value, int idx) {
        if (idx == this.length) {
            insertEnd(value);
        }
        else if (idx == 0) {
            insertFront(value);
        }
        else {
            auto currnode = findIndex(idx);
            auto newNode = new Node!T(value);
            newNode.before = currnode.before;
            newNode.before.after = newNode;
            newNode.after  = currnode;
            currnode.before = newNode;
            length += 1;
        }
    }

    Node!T findIndex(int idx) {
        Node!T currnode;
        if (idx > length / 2) {
            int i = length-1;
            currnode = tail;
            while (i != idx) {
                currnode = currnode.before;
                i -= 1;
            }
        }
        else {
            int i = 0;
            currnode = head;
            while (i != idx) {
                currnode = currnode.after;
                i += 1;
            }
        }
        return currnode;
    }

    void rotate(int factor) {
        if (factor > 0) {
            foreach (f; 0..factor) {
                auto oldhead = popFront();
                insertEnd(oldhead);
            }
        }
        else {
            foreach (f; 0..-(factor-1)) {
                auto oldtail = popBack();
                insertFront(oldtail);
            }
        }
    }

    override string toString() {
        Node!T currnode = head;
        T[] repr;
        while (currnode !is null) {
            repr ~= currnode.value;
            currnode = currnode.after;
        }
        return to!string(repr);
    }
}

class Node(T) {
    Node!T before;
    Node!T after;
    T value;

    this(T value) {
        this.value = value;
        this.before = null;
        this.after = null;
    }
}

/** What is the winning elf's score */
ulong game(int lastworth) {
    // Create a linked list
    auto game = new LinkedList!int(0, 1);
    ulong[numplayers] score;

    // Gameplay
    int round = 2;
    int player;
    while (round <= lastworth) {

        // Normal play
        if (round % 23 != 0) {
            // Insert two spots up
            game.rotate(1);
            game.insertEnd(round);
        }
        else {
            game.rotate(-7);
            score[player] += round + game.popFront();
            game.rotate(1);
        }
        player += 1;
        player = player >= numplayers ? player % numplayers : player;
        round += 1;
    }
    return score[].maxElement;
}

void main() {
    writeln(game(startgamelength));
    writeln(game(startgamelength*100));
}