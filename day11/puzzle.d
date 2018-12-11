import std.stdio;

enum serialNumber = 4172;
enum size = 300;

int getPowerLevel(int x, int y) {
    auto rackID = x + 10;
    auto powerlevel = rackID * y;
    powerlevel += serialNumber;
    powerlevel *= rackID;
    auto hundo = (powerlevel / 100) % 10;
    return hundo - 5;
}

int[4] puzzle(in int[][] grid, int cell) {
    // Find 3x3 cell with largest power level
    int[3] currentmax = [-1, -1, -1];
    foreach (x; 0..size-cell) { foreach (y; 0..size-cell) {
        int total;
        foreach (ix; x..x+cell) { foreach (iy; y..y+cell) {
            total += grid[ix][iy];
        }}
        //writeln(total);
        if (total > currentmax[2]) {
            currentmax = [x+1, y+1, total];
        }
    }}
    return [currentmax[0], currentmax[1], currentmax[2], cell];
}

void main() {

    // Create grid filled with power levels
    int[][] grid = new int[][](size, size);
    foreach (x; 0..size) { foreach (y; 0..size) {
        grid[x][y] = getPowerLevel(x+1, y+1);
    }}

    writeln(puzzle(grid, 3));

    // Going to try all the sizes less than 30 so I don't run afoul of the divide by 100
    auto currentmax = [-1, -1, -1, -1];
    foreach (cell; 1..30) {
        auto output = puzzle(grid, cell);
        if (output[2] > currentmax[2]) {
            currentmax = output.dup;    // Have to have the dup because output is a static array, lol
        }
    }
    writeln(currentmax);

}