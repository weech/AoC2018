""" Task: Read in a series of newline seperated values from a file. These values are deltas, and the initial
	value is 0. What is the final value?
"""

def main():
    with open("input.txt") as f:
        currentvalue = 0
        for line in f:
            currentvalue += int(line)
    print(currentvalue)


if __name__ == "__main__":
    main()
