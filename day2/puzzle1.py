""" Task: Read in a series of newline seperated values from a file. Count the number of lines that
    have a letter that occurs exactly twice and multiply by the number that have a letter that 
    occurs exactly three times.
"""
from collections import Counter

def main():
    numdoubles = 0
    numtriples = 0
    with open("input.txt") as f:
        for line in f:
            counts = Counter(line)
            if 2 in counts.values():
                numdoubles += 1
            if 3 in counts.values():
                numtriples += 1
    
    print(numdoubles * numtriples)


if __name__ == "__main__":
    main()
