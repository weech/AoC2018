import std.stdio;
import std.algorithm;
import core.exception;
import std.conv;
import std.container;

enum numplayers = 473;

/** What is the winning elf's score */
int game(int lastworth) pure {
    // Create a big-old array
    auto game = DList!int([0]);
    int[numplayers] score;

    game ~= 0;

    // Gameplay
    int round = 1;
    int current;
    int player;
    while (round <= lastworth) {
        // Place a marble to start
        if (game.length < 2) {
            game ~= round;
            current = round;
        }

        // Normal play
        else if (round % 23 != 0) {
            // Insert two spots up
            current += 2;
            current = current > game.length ? to!int(current % game.length) : current;
            game = game[0..current] ~ [round] ~ game[current..$];
        }
        else {
            current -= 7;
            current = current >= 0 ? current : to!int(current + game.length);
            score[player] += round;
            score[player] += game[current];
            game = game[0..current] ~ game[current+1..$];
        }
        player += 1;
        player = player >= numplayers ? player % numplayers : player;
        round += 1;
    }

    return score[].maxElement;

}


void main() {
    writeln(game(70904));
    writeln(game(70904*100));
}