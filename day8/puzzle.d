import std.stdio;
import std.string;
import std.conv;
import std.algorithm;
import std.array;

class Node {
    Node[] children;
    int[] meta;

    this(int[] line, out int numUsed) {
        numchildren = line[0];
        nummeta = line[1];
        int startidx = 2;
        foreach (child; 0..numchildren) {
            int numUsedLocal;
            this.children ~= new Node(line[startidx..$], numUsedLocal);
            startidx += numUsedLocal;
        }
        foreach (metaidx; 0..nummeta) {
            this.meta ~= line[startidx + metaidx];
        }
        numUsed = startidx + nummeta;
    }
}

int puzzle1(Node root) {
    // Traverse root to get sum of metadata entries
    if (root.children.length == 0) {
        return root.meta.sum;
    }
    else {
        return root.meta.sum + root.children.map!(x => x.puzzle1).sum; 
    }
}

int puzzle2(Node root) {
    if (root.children.length == 0) {
        return root.meta.sum;
    }
    else {
        return root.meta.filter!(m => m <= root.children.length && m > 0)
                        .map!(m => root.children[m-1].puzzle2)
                        .sum;
    }
}

void main() {

    auto f = File("input.txt");
    auto line = f.readln.strip.split(" ").map!(x => to!int(x)).array;
    f.close();

    int numUsed;
    Node root = new Node(line, numUsed);

    writeln(puzzle1(root));
    writeln(puzzle2(root));
}