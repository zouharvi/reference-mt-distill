from functools import partial


class CandidateSent():
    """
    Small data structure for candidate filtering
    """
    def __init__(self, cur_src, cur_ref, new_ref, score):
        self.cur_src = cur_src
        self.cur_ref = cur_ref
        self.new_ref = new_ref
        self.score = score

def extractor_wrap(func):
    def f(**args):
        return partial(func, **args)
    return f

@extractor_wrap
def top_k(input_loader, scorer, k):
    """
    Take top k scoring candidates according to the scorer
    """
    for nbest in input_loader:
        for x in sorted(nbest, key=scorer)[:k]:
            yield x

@extractor_wrap
def atleast_k(input_loader, scorer, k):
    """
    Take any number of scoring candidates with score at least k 
    """
    for nbest in input_loader:
        for x in [x for x in nbest if scorer(x) >= k]:
            print(x.new_ref)
            print(x.cur_ref)
            yield x
