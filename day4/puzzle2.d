import std.stdio;
import std.string;
import std.algorithm;
import std.conv;
import std.range;
import std.datetime;

alias ID = int;

struct Entry {
    DateTime date;
    string event;
}

struct Guard {
    ID id;
    int[60] asleep;
    ubyte lastAsleep;

    this(Entry entry) {
        auto idbit = entry.event.split("#")[1].split(" ")[0];
        this.id = to!int(idbit);
    }
}


/** Task: Determine which guard is most consistently asleep at a certain time
*/
void main()
{
	// Read in the file and create entries I can sort
	auto file = File("input.txt", "r");
	Entry[] entries;
	while (!file.eof) {
		// Create claim
		auto line = file.readln.strip;
        if (line.length < 2) continue;
        auto datetimestr = line.split("]")[0][1..$].strip.split(" ");
        auto datestr = datetimestr[0].split("-");
        auto timestr = datetimestr[1].split(":");
        auto date = Date(to!int(datestr[0]), to!int(datestr[1]), to!int(datestr[2]));
        auto time = TimeOfDay(to!int(timestr[0]), to!int(timestr[1]));
        auto event = line.split("]")[1].strip;
        entries ~= Entry(DateTime(date, time), event);
	}

    // Sort by date
    entries = entries.sort!((a, b) => a.date < b.date).array;

    // Go through entry list marking when a guard is asleep
    Guard currentGuard;
    Guard[ID] guards;
    foreach (entry; entries) {
        // It's a new guard posting
        if (entry.event.canFind("#")) {
            currentGuard = Guard(entry);

            // If we've seen this guard before put them in currentGuard
            if (currentGuard.id in guards) {
                currentGuard = guards[currentGuard.id];
            }
        }
        // The current guard falls asleep
        else if (entry.event.canFind("falls")) {
            currentGuard.lastAsleep = entry.date.minute;
        }
        // Only other option is the guard wakes up
        else {
            foreach (idx; currentGuard.lastAsleep .. entry.date.minute) {
                currentGuard.asleep[idx] += 1;
            }
        }
        // Save the current state
        guards[currentGuard.id] = currentGuard;
    }

    // Find out which guard spends is most frequently asleep at the same minute
    immutable biggestSleeper = guards.values.maxElement!(a => a.asleep[].maxElement);
    immutable peakSleep = biggestSleeper.asleep[].maxIndex;

    writeln(peakSleep * biggestSleeper.id);


}