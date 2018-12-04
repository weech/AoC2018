""" Task: Determine which guard has the most minutes asleep and what minute
      does that guard spend asleep the most?
"""
import datetime as dt
from collections import namedtuple
from dataclasses import dataclass

import numpy as np

Entry = namedtuple("Entry", ["date", "event"])

@dataclass
class Guard:
    """ Class representing a guard """
    gid: int = -1
    asleep: np.ndarray = np.empty(1)
    last_asleep: int = -1

def make_guard(event):
    idbit = event.split("#")[1].split(" ")[0]
    gid = int(idbit)
    return Guard(gid, np.zeros(60, int), -1)

def make_entry(line):
    datetimestr = line.split("]")[0][1:].strip()
    date = dt.datetime.strptime(datetimestr, "%Y-%m-%d %H:%M")
    event = line.split("]")[1].strip()
    return Entry(date, event)

def eventlogic(guards, currentguard, entry):
    # It's a new guard posting
    if "#" in entry.event:
        currentguard = make_guard(entry.event)

        # If we've seen this guard before put them in currentguard
        if currentguard.gid in guards:
            currentguard = guards[currentguard.gid]

    # The current guard falls asleep
    elif "falls" in entry.event:
        currentguard.last_asleep = entry.date.minute

    # Only other option is the guard wakes up
    else:
        currentguard.asleep[currentguard.last_asleep:entry.date.minute] += 1

    # Save the current state
    return currentguard


def main():

    # Read in the file
    with open("input.txt") as f:
        entries = sorted([make_entry(line) for line in f.readlines()], key=lambda x: x.date)

    # Assign napping times to each guard
    guards = dict()
    currentguard = Guard()
    for entry in entries:
        currentguard = eventlogic(guards, currentguard, entry)
        guards[currentguard.gid] = currentguard
    # Find the sleepiest guard and their favorite sleepy time
    sleepiest = sorted(guards.values(), key=lambda x: np.sum(x.asleep))[-1]
    peaknap = np.argmax(sleepiest.asleep)
    print(sleepiest.gid * peaknap)

if __name__ == "__main__":
    main()
