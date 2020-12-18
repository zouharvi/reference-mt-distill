#!/bin/python3

# TODO


def loader(ftrans, fref):
    prev_i = None
    with open(ftrans, 'r') as ftrans, open(fref, 'r') as fref:
        for trans in ftrans:
            cur_i, sent_raw, f0a, f0b = trans.split(' ||| ') 
            if cur_i != prev_i:
                prev_i = cur_i
                cur_ref = next(fref)
            yield (sent_raw, cur_ref, f0a, f0b)

gen = loader('data/teacher/europarl.cs-en.cs', 'data/original/europarl.cs-en.cs')
for x in gen:
    # print(x)
    pass