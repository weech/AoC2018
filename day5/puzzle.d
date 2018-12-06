import std.stdio;
import std.string;
import std.algorithm;
import std.range;
import std.ascii;

bool condition(string el1, string el2) {
    return el1.toLower == el2.toLower && el1 != el2;
}

string[] reactString(string[] line) {

    ulong nremoved = 999;
    while (nremoved > 0) {
        int idx;
        string[] newline;
        while (idx < line.length-1) {
            if (condition(line[idx], line[idx+1])) {
                idx += 2;
            }
            else {
                newline ~= line[idx];
                idx += 1;
            }
        }
        // Reattach the end
        if (!condition(line[$-2], line[$-1])) {
            newline ~= line[$-1];
        }

        nremoved = line.length - newline.length;
        line = newline;
    }
    return line;
}

/** Task: Remove characters from a string that are the same letter but opposite case that are adjacent */
void main()
{
    // There's only one line
	auto file = File("input.txt", "r");    
    auto line = file.readln.strip.split("");
    file.close();

    line = reactString(line);    

    writeln(line.length);


    // Puzzle 2
    auto letters = lowercase.split("");
    ulong[string] results;
    foreach (letter; letters) {
        auto testline = line.filter!(x => x.toLower != letter).array;
        testline = reactString(testline);
        results[letter] = testline.length;
    }

    string maxletter = "failed";
    ulong maxlength = ulong.max;
    foreach (key, value; results) {
        if (value < maxlength) {
            maxletter = key;
            maxlength = value;
        }
    }
    writeln(maxletter);
    writeln(maxlength);
}