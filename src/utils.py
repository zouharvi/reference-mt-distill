#!/bin/python3

def loader(ftrans, fref, prefix='data/'):
    """
    Effectively traverse both inferred file with n-best hypotheses and subword units and the reference
    """
    prev_i = -1
    with open(prefix + ftrans, 'r') as ftrans, open(prefix + fref, 'r') as fref:
        for trans in ftrans:
            cur_i, sent_raw, f0a, f0b = trans.split(' ||| ') 
            cur_i = int(cur_i)
            if cur_i != prev_i:
                if cur_i != prev_i + 1:
                    raise Exception(f"The data does not zip well. File ftrans jumped from {prev_i} to {cur_i}")
                prev_i = cur_i
                cur_ref = next(fref)
            yield (sent_raw, cur_ref, f0a, f0b)
    