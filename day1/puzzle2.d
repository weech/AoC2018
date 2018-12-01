import std.stdio;
import std.string;
import std.conv;
import std.range;

/** Task: Read in a series of newline seperated values from a file. These values are deltas, and the initial
	value is 0. What is the first value that is reached twice?
*/
void main()
{
	// Read in the file and store in list of ints
	auto file = File("input.txt", "r");
	int[] deltas;
	while (!file.eof) {
		// Get rid of newlines and the leading "+"
		immutable dstring = file.readln.strip();
		if (dstring.length > 1) {
			deltas ~= dstring[0] == '+' ? to!int(dstring[1..$]) : to!int(dstring);
		}
	}

    // Loop through the list repetatedly until a duplicate frequency is found
    int currentvalue;
    bool[int] pastvalues;
    pastvalues[currentvalue] = true; // Init with the first currentvalue
    foreach (delta; deltas.cycle) {
        currentvalue += delta;
        if (currentvalue in pastvalues) {
            break;
        }
        else {
            pastvalues[currentvalue] = true;
        }
    }

	writeln(currentvalue);
}