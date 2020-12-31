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
        BLEU of the hypothesis
        """
        return sacrebleu.sentence_bleu(self.new_hyp.replace(' ', '').replace('</s>', '').replace('▁', ' '), [self.cur_ref]).score

    def ter(self):
        """
        TER of the hypothesis
        """
        return -sacrebleu.sentence_ter(self.new_hyp.replace(' ', '').replace('</s>', '').replace('▁', ' '), [self.cur_ref]).score

    def chrf(self):
        """
        ChRF of the hypothesis
        """
        return sacrebleu.sentence_chrf(self.new_hyp.replace(' ', '').replace('</s>', '').replace('▁', ' '), [self.cur_ref]).score

    def spm_diff(self):
        """
        Difference in subword unit counts
        """
        return -abs(self.new_hyp.count('▁') - len(self.spm_obj.encode(self.cur_ref)))

    def printable_signature(self):
        """
        Returns a tuple needed for printing
        """
        return (self.cur_src, self.new_hyp)

class CandidateSentPrint():
    """
    Used only for printing after deduplication
    """
    def __init__(self, cur_src, new_hyp):
        self.cur_src = cur_src
        self.new_hyp = new_hyp

def extractor_wrap(func):
    """
    Partially instantiate extractors, so that they can be used in recipe definitions
    without the need of having the input generator
    """
    def f(**args):
        return partial(func, **args)
    return f


@extractor_wrap
def top_kth(nbest, scorer, k):
    """
    Take top k-th scoring candidate according to the scorer
    """
    assert(k > 0)
    yield sorted(nbest, key=scorer, reverse=True)[k-1]


@extractor_wrap
def top_k(nbest, scorer, k):
    """
    Take top k scoring candidates according to the scorer
    """
    for candidate in sorted(nbest, key=scorer, reverse=True)[:k]:
        yield candidate


@extractor_wrap
def top_k_fast(nbest, scorer, ks):
    """
    Take topk scoring candidates according to the scorer and ks
    """
    for candidate, repetitions in zip(sorted(nbest, key=scorer, reverse=True), ks):
        for _ in range(repetitions):
            yield candidate


@extractor_wrap
def atleast(nbest, scorer, threshold):
    """
    Take any number of scoring candidates with score at least k 
    """
    for x in [x for x in nbest if scorer(x) >= threshold]:
        yield x


@extractor_wrap
def original(nbest):
    """
    Take any number of scoring candidates with score at least k 
    """
    yield CandidateSent(
        nbest[0].cur_src,
        nbest[0].cur_ref,
        ' '.join(nbest[0].spm_obj.encode(nbest[0].cur_ref, out_type=str)),
        nbest[0].score,
        nbest[0].spm_obj,
    )


@extractor_wrap
def aggregator(candidate_list, recipe):
    """
    Aggregates extractor list recipes [(repetition, extractor)] and yields the results
    """
    i = 0
    for nbest in candidate_list:
        i += 1
        for repetition, extractor in recipe:
            for _ in range(repetition):
                for candidate in extractor(nbest):
                    yield candidate
        if i == 2:
            exit()

@extractor_wrap
def aggregator_deduplicate(nbest, recipe):
    """
    Deduplicates extractor list recipes [extractor] and yields the results
    """
    buffer = set()
    for extractor in recipe:
        for candidate in extractor(nbest):
            buffer.add(candidate.printable_signature())
    # yield candidates
    for src, hyp in buffer:
        yield CandidateSentPrint(src, hyp)