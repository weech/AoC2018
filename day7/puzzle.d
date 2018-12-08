import std.stdio;
import std.algorithm;
import std.range;
import std.array;
import std.string;
import std.ascii;

class Step {

    string name;
    Step[] postreqs;
    Step[] prereqs;

    this(string name) {
        this.name = name;
    }

    void addPostreq(Step postreq) {
        postreqs ~= postreq;
    }

    void addPrereq(Step prereq) {
        prereqs ~= prereq;
    }

}

string puzzle1(Step[string] steps) {

    // Traverse nodes to find out which is head
    Step[] available;
    foreach (step; steps.values) {
        if (step.prereqs.length == 0) {
            available ~= step;
        }
    }
    available = available.sort!((a, b) => a.name < b.name).array;

    // Traverse available's children marking them as done
    string[] done;
    while (done.length < steps.length && !available.empty > 0) {

        auto front = available.front;
        done ~= front.name;
        foreach (child; front.postreqs) {
            bool failed;
            foreach (prereq; child.prereqs) {
                if (!done.canFind(prereq.name)) {
                    failed = true;
                    break;
                }
            }
            if (!failed) {
                available ~= child;
            }            
        }
        available.popFront;
        available = available.sort!((a, b) => a.name < b.name).array;
    }

    return done.join("");
}

int puzzle2(Step[string] steps) {

    // Find out how long each step takes
    enum baselength = 60; 
    ulong[string] delays;
    foreach (idx, letter; uppercase.split("")) {
        delays[letter] = baselength + idx+1;
    }

    // Lists to keep track of things
    enum numworkers = 5;  
    Step[] available;   // Steps that have had all prereqs put in done
    ulong[string] working; // Steps that are currently being worked on. Key is step name and value is time left.
    string[] done;  // Steps that have been completed

    // Traverse nodes to find out which is head
    foreach (step; steps.values) {
        if (step.prereqs.length == 0) {
            available ~= step;
        }
    }
    available = available.sort!((a, b) => a.name < b.name).array;

    // Traverse available's children marking them as done
    int frame;
    while (done.length < steps.length) {

        // If there's a task available add to AA and a worker to take it
        while (working.length < numworkers && !available.empty) {
            auto front = available.front;
            working[front.name] = delays[front.name];
            available.popFront;
        }
        // Check if any tasks are done being worked on. If so, give the worker a new task.
        foreach (name, task; working) {
            if (task == 1) {
                done ~= name;
                working.remove(name);
                foreach (child; steps[name].postreqs) {
                    bool failed;
                    foreach (prereq; child.prereqs) {
                        if (!done.canFind(prereq.name)) {
                            failed = true;
                            break;
                        }
                    }
                    if (!failed) {
                        available ~= child;
                    }            
                }
            }
            else {
                working[name] -= 1;
            }
        }
        frame += 1;
        available = available.sort!((a, b) => a.name < b.name).array;
    }

    return frame;
}


void main() {

    auto f = File("input.txt", "r");
    Step[string] steps;
    while (!f.eof) {
        auto line = f.readln.strip.split(" ");
        if (line.length < 2) {
            continue;
        }

        string name = line[1];
        string postreq = line[7];

        if (name !in steps) {
            steps[name] = new Step(name);
        }
        if (postreq !in steps) {
            steps[postreq] = new Step(postreq);
        }

        steps[name].addPostreq(steps[postreq]);
        steps[postreq].addPrereq(steps[name]);
    }

    writeln(puzzle1(steps));
    writeln(puzzle2(steps));
}