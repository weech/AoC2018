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

bool checkClaim(in Claim claim, in int[][] fabric) {
    foreach (j; claim.topOffset .. claim.topOffset + claim.height) {
        foreach (i; claim.leftOffset .. claim.leftOffset + claim.width) {
            if (fabric[j][i] > 1) {
                return false;
            }
        }
    }
    return true;
}

int findNoOverlap(in Claim[] claims, in int[][] fabric) {
    foreach (claim; claims) {
        immutable thisone = checkClaim(claim, fabric);
        if (thisone) {
            return claim.id;
        }
    }
    // In case of failure
    return -1;
}

/** Task: Determine which claim does not overlap any others */
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
    int[][] fabric = new int[][](edge, edge);
    foreach (claim; claims) {
        foreach (j; claim.topOffset .. claim.topOffset + claim.height) {
            foreach (i; claim.leftOffset .. claim.leftOffset + claim.width) {
                fabric[j][i] += 1;
            }
        }
    }

    // Return the id of the claim that has no overlap
	writeln(findNoOverlap(claims, fabric));
}
