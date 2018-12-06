import std.stdio;
import std.string;
import std.algorithm;
import std.range;

string[] cleanUnits(string[] line) {
    if (line.length <= 2) {
        return line;
    }
    else if (line[0].toLower == line[1].toLower && line[0] != line[1]) {
        return cleanUnits(line[2..$]);
    }
    else {
        return line[0] ~ cleanUnits(line[1..$]);
    }
}

bool condition(string el1, string el2) {
    return el1.toLower == el2.toLower && el1 != el2;
}

/** Task: Remove characters from a string that are the same letter but opposite case that are adjacent */
void main()
{
    // There's only one line
	auto file = File("input.txt", "r");    
    auto line = file.readln.strip.split("");
    file.close();

    // Loop through removing cases that should be removed
    /*
    ulong nremoved = 999;
    while (nremoved > 0) {
        auto retline = line.chunks(2)
                           .filter!(x => !(x[0].toLower == x[1].toLower && x[0] != x[1]))
                           .map!(x => x[0] ~ x[1])
                           .join("").split("");

        // Check the off-by-one
        string oddsave = retline.length % 2 == 1 ? retline[$-1] : "";
        retline = retline[0] ~ retline.dropOne.chunks(2)
                                              .filter!(x => x.length > 1)
                                              .filter!(x => !(x[0].toLower == x[1].toLower && x[0] != x[1]))
                                              .map!(x => x[0] ~ x[1])
                                              .join("").split("") ~ oddsave;

        nremoved = line.length - retline.length;
        writeln(nremoved);
        line = retline;        
    }
    */
    ulong nremoved = 999;
    while (nremoved > 0) {
        int idx = 0;
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
    

    writeln(line);
    writeln(line.length);
    
}