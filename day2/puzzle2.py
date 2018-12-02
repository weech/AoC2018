""" Task: Find the two rows that differ by one character and print the common characters
"""
from itertools import combinations

def search_common(lines):
    for line1, line2 in combinations(lines, 2):
        numdiff = sum((c1 != c2 for c1, c2 in zip(line1, line2)))
        if numdiff == 1:
            return "".join((c1 for c1, c2 in zip(line1, line2) if c1 == c2))

def main():
    with open("input.txt") as f:
        lines = f.readlines()
    
    print(search_common(lines))

if __name__ == "__main__":
    main()
