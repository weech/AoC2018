import std.stdio;
import std.string;
import std.range;
import std.algorithm;
import std.array;
import std.conv;

struct Rule {
    bool[5] input;
    bool output;
}

int puzzle1(bool[] currentpots, bool[bool[5]] rules, int paddingLength) {

    bool[5] window;
    bool[] nextpots = currentpots.dup;
    int lastval;
    foreach (t; 0..20) {
        foreach (potIdx; 2..currentpots.length-2) {
            // Fill a window
            foreach (wIdx; -2..3) {
                window[wIdx+2] = currentpots[potIdx + wIdx];
            }   
            nextpots[potIdx] = rules[window];
        }
        lastval = currentpots.enumerate(-paddingLength).map!(x => x[1] ? x[0] : 0).sum();
        currentpots = nextpots.dup;
    }

    return currentpots.enumerate(-paddingLength).map!(x => x[1] ? x[0] : 0).sum();
}

ulong puzzle2(bool[] currentpots, bool[bool[5]] rules, int paddingLength, ulong finalGen) {

    bool[5] window;
    bool[] nextpots = currentpots.dup;
    int lastval;
    int change;
    int change2;
    int change3;
    bool stable;
    int t;
    while (!stable && t < paddingLength) {
        foreach (potIdx; 2..currentpots.length-2) {
            // Fill a window
            foreach (wIdx; -2..3) {
                window[wIdx+2] = currentpots[potIdx + wIdx];
            }   
            nextpots[potIdx] = rules[window];
        }
        immutable thisval = currentpots.enumerate(-paddingLength).map!(x => x[1] ? x[0] : 0).sum();
        currentpots = nextpots.dup;

        change3 = change2;
        change2 = change;
        change = thisval - lastval;
    
        if (change3 == change2 && change2 == change) {
            stable = true;
        }
        lastval = thisval;
        t += 1;

    }
    immutable sumAtStable = lastval;
    immutable diffPerGen = change;
    immutable genAtStable = t-1;
    return sumAtStable + diffPerGen * (finalGen - genAtStable);
}



void main() {

    auto f = File("input.txt", "r");

    // Add the initial state
    auto initialstate = f.readln.split(":")[1].strip.split("");
    bool[] currentpots = initialstate.map!(x => x == "#").array;
    
    // Pad with a bunch of falses
    auto padding = [false].cycle.take(130).array;
    currentpots = padding ~ currentpots ~ padding;

    // Add the rules
    bool[bool[5]] rules;
    while (!f.eof) {
        auto line = f.readln.strip.split("=>");
        if (line.length < 2) {
            continue;
        }

        bool[5] key;
        foreach (i, character; line[0].strip.split("")) {
            if (character == "#") {
                key[i] = true;
            }
        }      

        rules[key] = line[1].strip == "#";
    }

    writeln(puzzle1(currentpots.dup, rules, to!int(padding.length)));

    writeln(puzzle2(currentpots, rules, to!int(padding.length), 50_000_000_000));

}