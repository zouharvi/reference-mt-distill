from functools import partial
import sacrebleu

class CandidateSent():
    """
    Small data structure for candidate filtering
    """
    def __init__(self, cur_src, cur_ref, new_hyp, score, spm_obj):
        self.cur_src = cur_src
        self.cur_ref = cur_ref
        self.new_hyp = new_hyp
        self.score = score
        self.spm_obj = spm_obj

    def bleu(self):
        """
        Bleu of the hypothesis
        """
        return sacrebleu.sentence_bleu(self.new_hyp.replace(' ', '').replace('</s>', '').replace('▁', ' '), [self.cur_ref]).score

    def spm_diff(self):
        """
        Difference in subword unit counts
        """
        return abs(self.new_hyp.count('▁') - len(self.spm_obj.encode(self.cur_ref)))


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
def original(nbest):
    """
    Take any number of scoring candidates with score at least k 
    """
    yield CandidateSent(
        nbest[0].cur_src,
        nbest[0].cur_ref,
        nbest[0].cur_ref,
        nbest[0].score,
        nbest[0].spm_obj,
    )

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