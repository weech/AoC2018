import std.stdio;
import std.string;
import std.conv;
import std.algorithm;
import std.math;

struct Point {
    int x;
    int y;
    int u;
    int v;
}

void main() {

    auto f = File("input.txt", "r");
    Point[] points;
    while (!f.eof) {
        auto line = f.readln.strip().split("v");
        if (line.length < 2) {
            continue;
        }
        auto position = line[0].split(",");
        auto x = to!int(position[0].split("<")[1].strip);
        auto y = to!int(position[1].split(">")[0].strip);

        auto velocity = line[1].split(",");
        auto u = to!int(velocity[0].split("<")[1].strip);
        auto v = to!int(velocity[1].split(">")[0].strip);
        points ~= Point(x, y, u, v);
    }

    // Start points are ~1e5 and velocities are ~1e0, so guess it's in this range
    enum testnum = 20_000;
    int[testnum] bboxes;
    foreach (i; 0..testnum) {
        int minx = int.max;
        int maxx = int.min;
        int miny = int.max;
        int maxy = int.min;
        int x, y;
        foreach (point; points) {
            x = point.x + point.u * i;
            y = point.y + point.v * i;
            if (x < minx) {
                minx = x;
            }
            if (x > maxx) {
                maxx = x;
            }
            if (y < miny) {
                miny = y;
            }
            if (y > maxy) {
                maxy = y;
            }
        }
        bboxes[i] = (maxx - minx) + (maxy - miny);
    }
    int idx = to!int(bboxes[].minIndex);

    // Print to screen
    int minx = int.max;
    int maxx = int.min;
    int miny = int.max;
    int maxy = int.min;
    int x, y;
    Point[] newpoints;
    foreach (point; points) {
        x = point.x + point.u * idx;
        y = point.y + point.v * idx;
        newpoints ~= Point(x, y, point.u, point.v);
        if (x < minx) {
            minx = x;
        }
        if (x > maxx) {
            maxx = x;
        }
        if (y < miny) {
            miny = y;
        }
        if (y > maxy) {
            maxy = y;
        }
    }

    string[][] chars = new string[][](maxy-miny+1, maxx-minx+1);
    foreach (j; 0..(maxy-miny+1)) { foreach (i; 0..(maxx-minx+1)) {
        chars[j][i] = " ";
    }}

    foreach (p; newpoints) {
        chars[p.y - miny][p.x - minx] = "#";
    }    

    foreach (row; chars) {
        row.join("").writeln;
    }
    
    writeln(idx); // Part 2
}