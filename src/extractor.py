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
    """
    Partially instantiate extractors, so that they can be used in recipe definitions
    without the need of having the input generator
    """
    def f(**args):
        return partial(func, **args)
    return f

@extractor_wrap
def top_k(nbest, scorer, k):
    """
    Take top k scoring candidates according to the scorer
    """
    yield sorted(nbest, key=scorer)[k]

@extractor_wrap
def atleast_k(nbest, scorer, k):
    """
    Take any number of scoring candidates with score at least k 
    """
    for x in [x for x in nbest if scorer(x) >= k]:
        yield x

@extractor_wrap
def aggregator(candidate_list, recipe):
    """
    Aggregates extractor list recipes [(repetition, extractor)] and yields the results
    """
    for nbest in candidate_list:
        for repetition, extractor in recipe:
            for _ in range(repetition):
                for candidate in extractor(nbest):
                    yield candidate