import std.stdio;
import std.string;
import std.conv;
import std.algorithm;
import std.range;
import std.math;

struct Point {
    int x;
    int y;
    int label;
}

int distance(Point a, Point b) @nogc nothrow pure @safe {
    return abs(a.x - b.x) + abs(a.y - b.y);
}


int puzzle1(Point[] points, int labels) {

    // Figure out how big my grid needs to be 
    auto maxx = points.maxElement!(x => x.x).x + 2;
    auto maxy = points.maxElement!(x => x.y).y + 2;

    auto grid = new int[][](maxy, maxx);

    // Label each grid point with the closest point
    foreach (j; 0..maxy) { foreach (i; 0..maxx) {
        immutable testpoint = Point(j, i, 0);
        int mindistance = int.max;
        int[] closest;
        foreach (point; points) {
            immutable dist = distance(testpoint, point);
            if (dist < mindistance) {
                closest.length = 0;
                closest ~= point.label;
                mindistance = dist;
            }
            else if (dist == mindistance) {
                closest ~= point.label;
            }
        }

        if (closest.length == 1) {
            grid[j][i] = closest[0];
        }
    }}

    // Sum up the areas discounting any that lie on the edge
    bool[int] validLabels;
    foreach (i; 1..labels) { validLabels[i] = true;}
    foreach (j; [0, maxy-1]) { foreach (i; 0..maxx) { 
        validLabels.remove(grid[j][i]);
    }}
    foreach (j; 0..maxy) { foreach (i; [0, maxx-1]) {
        validLabels.remove(grid[j][i]);
    }}

    // Flatten and count each label
    int[] flatgrid = new int[](maxy*maxx);
    int index;
    foreach (j; 0..maxy) { foreach (i; 0..maxx) {
        flatgrid[index] = grid[j][i];
        index += 1;
    }}

    int maxcount;
    foreach (label; validLabels.byKey) {
        int count;
        foreach (element; flatgrid) {
            if (element == label) {
                count += 1;
            }
        }
        if (count > maxcount) {
            maxcount = count;
        }
    }

    // Return the max count 
    return maxcount;
}

/*
int[][] labelGrid(int[][] data, int maxy, int maxx) {
    int[][] linked;
    int[][] labels = new int[][](maxy, maxx);
    
    // First pass 
    foreach (j; 0..maxy) { foreach (i; 0..maxx) {
        int currval = data[j][i];
        if (currval != 0) {
            if (i > 0 && data[j][i-1] == currval) {
                labels[j][i] = labels[j][i-1];
            }
            if (i > 0 && j > 0 && data[j-1][i] == currval && data[j][i-1] == currval
                && labels[j-1][i] != labels[j][i-1]) {
                immutable minpix = min(labels[j-1][i], labels[j][i-1]);
                labels[j][i] = minpix;
                linked ~= [labels[j-1][i], labels[j][i-1]];
            }
            // https://en.wikipedia.org/wiki/Connected-component_labeling
        }
    }}
}
*/
int puzzle2(Point[] points) {

    // Figure out how big my grid needs to be 
    auto maxx = points.maxElement!(x => x.x).x + 2;
    auto maxy = points.maxElement!(x => x.y).y + 2;

    auto grid = new int[][](maxy, maxx);    
    enum thresh = 10_000;

    // Find the summed distance to each other point and keep a counter if above thresh
    int counter;
    foreach (j; 0..maxy) { foreach (i; 0..maxx) {
        immutable testpoint = Point(j, i, 0);
        foreach (point; points) {
            grid[j][i] += distance(testpoint, point);
        }

        // If the sum is above thresh, inc counter
        if (grid[j][i] < thresh) {
            counter += 1;
        }
    }}

    return counter;

}


void main() {
    auto f = File("input.txt");

    Point[] points;
    int labels = 1;
    while (!f.eof) {
        auto line = f.readln.strip.split(", ");
        if (line.length < 2) continue;
        points ~= Point(to!int(line[0]), to!int(line[1]), labels);
        labels += 1;
    }
    f.close();

    writeln(puzzle1(points, labels));
    writeln(puzzle2(points));

}