""" Task: Read in a series of newline seperated values from a file. These values are deltas, and the initial
	value is 0. What is the first value that is reached twice?
"""
from itertools import cycle

def main():
    deltas = list()
    with open("input.txt") as f:
        currentvalue = 0
        for line in f:
            deltas.append(int(line))
    
    # Cycle through deltas and values
    currentvalue = 0
    pastvalues = set([currentvalue])
    for delta in cycle(deltas):
        currentvalue += delta 
        if currentvalue in pastvalues:
            break 
        else:
            pastvalues.add(currentvalue)
    
    print(currentvalue)



if __name__ == "__main__":
    main()
