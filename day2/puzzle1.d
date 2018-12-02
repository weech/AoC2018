import std.stdio;
import std.string;
import std.algorithm;

/** Task: Read in a series of newline seperated values from a file. Count the number of lines that
    have a letter that occurs exactly twice and multiply by the number that have a letter that 
    occurs exactly three times.
*/
void main()
{
	// Read in the file and keep track of current value
	auto file = File("input.txt", "r");
	int numdoubles;
    int numtriples;
	while (!file.eof) {
		// Sort and group
		auto groupings = file.readln.strip.split("").sort.group;
        bool[int] groupset;
        foreach (elem, count; groupings) {
            groupset[count] = true;
        }
        if (2 in groupset) {
            numdoubles += 1;
        }
        if (3 in groupset) {
            numtriples += 1;
        }
	}
	writeln(numdoubles * numtriples);
}
