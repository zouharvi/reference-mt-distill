import sentencepiece as spm
from extractor import CandidateSent

import os

def loader(fsrc, fref, ftrans, spm_obj, prefix='data/'):
    """
    Effectively traverse both inferred file with n-best hypotheses and subword units and the reference
    """
    prev_i = -1
    # all files are open, but they are not being traversed in a standarrd  zip fashion
    with open(prefix + fsrc, 'r') as fsrc, open(prefix + fref, 'r') as fref, open(prefix + ftrans, 'r') as ftrans:
        buffer = []
        for trans in ftrans:
            cur_i, new_hyp, f0, score = trans.split(' ||| ')
            cur_i = int(cur_i)
            if cur_i != prev_i:
                if cur_i != prev_i + 1:
                    raise Exception(
                        f"The data does not zip well. File ftrans jumped from {prev_i} to {cur_i}"
                    )
                prev_i = cur_i
                cur_ref = next(fref)
                cur_src = next(fsrc)
                if len(buffer) != 0:
                    if (cur_i-1) % 50000 == 0:
                        print(f' SRC line {(cur_i-1)//1000}k ...')
                    yield buffer
                    buffer = []

            buffer.append(CandidateSent(
                cur_src.rstrip('\n'),
                cur_ref.rstrip('\n'),
                new_hyp,
                float(score),
                spm_obj,
            ))

        if len(buffer) != 0:
            yield buffer


def saver(fnew_src, fnew_tgt, candidate_list, spm_obj, prefix='data/'):
    """
    Save candidate lists to files, decode spm
    """

    # make sure path to both exists
    os.makedirs(os.path.dirname(prefix + fnew_src), exist_ok=True)
    os.makedirs(os.path.dirname(prefix + fnew_tgt), exist_ok=True)

    with open(prefix + fnew_src, 'w') as fnew_src, open(prefix + fnew_tgt, 'w') as fnew_tgt:
        for candidate in candidate_list:
            fnew_src.write(candidate.cur_src + '\n')
            fnew_tgt.write(spm_obj.decode(candidate.new_hyp) + '\n')


def load_process_save(fsrc, ftgt, ftrans, generator_partial, fnew_src, fnew_tgt, spm_model):
    """
    Load data (fsrc, ftgt, ftrans), apply generator (generator_lambda), save (fnew_src, fnew_tgt, spm_model)
    """
    spm_obj = spm.SentencePieceProcessor(model_file=spm_model)

    input_loader = loader(fsrc, ftgt, ftrans, spm_obj)
    data_generator = generator_partial(input_loader)
    saver(
        fnew_src, fnew_tgt,
        data_generator,
        spm_obj
    )
