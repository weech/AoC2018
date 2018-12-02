import std.stdio;
import std.string;
import std.algorithm;
import std.range;

/** Just going to churn this out */
string searchSimilar(string[] lines) {
    for (int idx1; idx1 < lines.length-1; idx1++) {
        for (int idx2 = idx1; idx2 < lines.length; idx2++) {
            auto line1 = lines[idx1].split("");
            auto line2 = lines[idx2].split("");
            immutable numdiff = levenshteinDistance(line1, line2);
            if (numdiff == 1) {
                return zip(line1, line2).filter!(a => a[0] == a[1]).map!(a => a[0]).join("");
            }
        }
    }
    return "failed";
}


/** Task: Find the two rows that differ by one character and print the common characters
*/
void main()
{
	// Read in the file
	auto file = File("input.txt", "r");
	string[] lines;
	while (!file.eof) {
		lines ~= file.readln.strip;
	}

	writeln(searchSimilar(lines));
}
