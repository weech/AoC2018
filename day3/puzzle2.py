""" Task: Determine which claim has no overlaps """
from collections import namedtuple 

import numpy as np 

Claim = namedtuple("Claim", ["id", "left_offset", "top_offset", "width", "height"])

def check_claim(claim, fabric):
    lo = claim.left_offset 
    to = claim.top_offset
    w = claim.width 
    h = claim.height 
    return ~np.any(fabric[to:to+h, lo:lo+w] > 1)

def find_no_overlap(claims, fabric):
    for claim in claims:
        if check_claim(claim, fabric):
            return claim.id 

def main():
    
    edge = 1000
    fabric = np.zeros((edge, edge), int)
    claims = list()
    with open("input.txt") as f:
        for line in f:
            claim_id = int(line.split("@")[0][1:])
            offsets = line.split("@")[1].split(":")[0].split(",")
            lo, to = [int(off) for off in offsets]
            size = line.split(":")[1].split("x")
            w, h = [int(s) for s in size]
            fabric[to:to+h, lo:lo+w] += 1
            claims.append(Claim(id=claim_id, left_offset=lo, top_offset=to, width=w, height=h))
    
    print(find_no_overlap(claims, fabric))


if __name__ == "__main__":
    main()
