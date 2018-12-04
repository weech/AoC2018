import std.stdio;
import std.string;
import std.algorithm;
import std.conv;
import std.range;

struct Claim {
    int id;
    int leftOffset;
    int topOffset;
    int width;
    int height;
}

/** Task: Determine the number of claims that overlap on a grid */
void main()
{
	// Read in the file and create claims
	auto file = File("input.txt", "r");
	Claim[] claims;
	while (!file.eof) {
		// Create claim
		auto line = file.readln.strip;
        if (line.length < 2) continue;
        auto id = to!int(line.split("@")[0][1..$].strip);
        auto offsets = line.split("@")[1].split(":")[0].strip.split(",");
        auto size = line.split(":")[1].strip.split("x");
        claims ~= Claim(id, to!int(offsets[0]), to!int(offsets[1]), to!int(size[0]), to!int(size[1]));
	}

    // Create a 1000 x 1000 array and iterate over the claims incrementing number of times each element is claimed
    enum edge = 1000;
    int[edge][edge] fabric;
    foreach (claim; claims) {
        foreach (j; claim.topOffset .. claim.topOffset + claim.height) {
            foreach (i; claim.leftOffset .. claim.leftOffset + claim.width) {
                fabric[j][i] += 1;
            }
        }
    }

    // Count number of elements with 2 or more claims
    int morethantwo;
    foreach (j; 0 .. edge) { foreach (i; 0 .. edge) {
        morethantwo += fabric[j][i] >= 2 ? 1 : 0;
    }}

	writeln(morethantwo);
}
