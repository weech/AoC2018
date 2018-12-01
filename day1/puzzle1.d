import std.stdio;
import std.string;
import std.conv;

/** Task: Read in a series of newline seperated values from a file. These values are deltas, and the initial
	value is 0. What is the final value?
*/
void main()
{
	// Read in the file and store in list of ints
	auto file = File("input.txt", "r");
	int currentvalue;
	while (!file.eof) {
		// Get rid of newlines and the leading "+"
		immutable dstring = file.readln.strip();
		if (dstring.length > 1) {
			immutable delta = dstring[0] == '+' ? to!int(dstring[1..$]) : to!int(dstring);
			currentvalue += delta;
		}
	}
	writeln(currentvalue);
}
