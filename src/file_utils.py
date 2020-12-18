import sentencepiece as spm
from extractor import CandidateSent


def loader(fsrc, fref, ftrans, prefix='data/'):
    """
    Effectively traverse both inferred file with n-best hypotheses and subword units and the reference
    """
    prev_i = -1
    with open(prefix + fsrc, 'r') as fsrc, open(prefix + fref, 'r') as fref, open(prefix + ftrans, 'r') as ftrans:
        buffer = []
        for trans in ftrans:
            cur_i, sent_raw, f0, score = trans.split(' ||| ')
            cur_i = int(cur_i)
            if cur_i != prev_i:
                if cur_i != prev_i + 1:
                    raise Exception(
                        f"The data does not zip well. File ftrans jumped from {prev_i} to {cur_i}")
                prev_i = cur_i
                cur_ref = next(fref)
                cur_src = next(fsrc)
                if len(buffer) != 0:
                    yield buffer
                    buffer = []

            buffer.append(CandidateSent(
                cur_src.rstrip('\n'),
                cur_ref.rstrip('\n'),
                sent_raw.split(),
                float(score)
            ))


def saver(fnew_src, fnew_tgt, candidate_list, spm_model, prefix='data/'):
    """
    Save candidate lists to files, decode spm
    """

    sp = spm.SentencePieceProcessor(model_file=spm_model)
    with open(prefix + fnew_src, 'w') as fnew_src, open(prefix + fnew_tgt, 'w') as fnew_tgt:
        for candidate in candidate_list:
            fnew_src.write(candidate.cur_src + '\n')
            fnew_tgt.write(sp.decode(candidate.new_ref) + '\n')


def load_process_save(fsrc, ftgt, ftrans, generator_lambda, fnew_src, fnew_tgt, spm_model):
    """
    Load data (fsrc, ftgt, ftrans), apply generator (generator_lambda), save (fnew_src, fnew_tgt, spm_model)
    """
    input_loader = loader(fsrc, ftgt, ftrans)
    data_generator = generator_lambda(input_loader)
    saver(
        fnew_src, fnew_tgt,
        data_generator,
        spm_model=spm_model
    )
