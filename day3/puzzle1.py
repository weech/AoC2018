""" Task: Determine the number of claims that overlap on a grid """
import numpy as np 

def main():
    
    edge = 1000
    fabric = np.zeros((edge, edge), int)
    with open("input.txt") as f:
        for line in f:
            #claim_id = int(line.split("@")[0][1:]) Not used
            offsets = line.split("@")[1].split(":")[0].split(",")
            offsets = [int(off) for off in offsets]
            size = line.split(":")[1].split("x")
            size = [int(s) for s in size]
            fabric[offsets[1]:offsets[1]+size[1], offsets[0]:offsets[0]+size[0]] += 1
    
    print(np.sum(fabric > 1))


if __name__ == "__main__":
    main()
