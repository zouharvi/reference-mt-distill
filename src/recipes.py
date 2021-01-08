from extractor import *

# every recipe is a tuple of number of repetitions and a generator
# examples:
# (1, original()),
# (5, top_k(scorer=lambda x: x.score, k=1)),
# (1, atleast(scorer=lambda x: x.score, threshold=-0.1)),

META_RECIPES = {
    'b1': aggregator(recipe=[
        (1, original()),
    ]),
    'b2': aggregator(recipe=[
        (1, top_kth(scorer=lambda x: x.score, k=1)),
    ]),
    'b3': aggregator(recipe=[
        (1, top_k(scorer=lambda x: x.score, k=12)),
    ]),
    'b4': aggregator(recipe=[
        (1, original()),
        (1, top_k(scorer=lambda x: x.score, k=1)),
    ]),
    'm1': aggregator(recipe=[
        (1, top_k(scorer=lambda x: x.bleu(), k=1)),
    ]),
    'm2': aggregator(recipe=[
        (1, top_k(scorer=lambda x: x.chrf(), k=1)),
    ]),
    'm3': aggregator(recipe=[
        (1, top_k(scorer=lambda x: x.spm_diff(), k=1)),
    ]),
    'm5': aggregator(recipe=[
        (1, top_k(scorer=lambda x: x.ter(), k=1)),
    ]),
    'n1': aggregator(recipe=[
        (1, top_k(scorer=lambda x: x.bleu(), k=4)),
    ]),
    'n2': aggregator(recipe=[
        (1, top_k(scorer=lambda x: x.chrf(), k=4)),
    ]),
    'n3': aggregator(recipe=[
        (1, top_k(scorer=lambda x: x.spm_diff(), k=4)),
    ]),
    'n4': aggregator(recipe=[
        (1, top_k(scorer=lambda x: x.score, k=4)),
    ]),
    'n5': aggregator(recipe=[
        (1, top_k(scorer=lambda x: x.ter(), k=4)),
    ]),
    'g1': aggregator(recipe=[
        (1, atleast(scorer=lambda x: x.bleu(), threshold=65)),
    ]),
    'g2': aggregator(recipe=[
        (1, atleast(scorer=lambda x: x.chrf(), threshold=0.8)),
    ]),
    'g3': aggregator(recipe=[
        (1, atleast(scorer=lambda x: x.spm_diff(), threshold=-1)),
    ]),
    'g4': aggregator(recipe=[
        (1, atleast(scorer=lambda x: x.score, threshold=-0.1)),
    ]),
    'g5': aggregator(recipe=[
        (1, atleast(scorer=lambda x: x.ter(), threshold=-0.7)),
    ]),
    's1': aggregator(recipe=[
        (1, top_k_fast(scorer=lambda x: x.bleu(), ks=[4, 3, 2, 1])),
    ]),
    's2': aggregator(recipe=[
        (1, top_k_fast(scorer=lambda x: x.chrf(), ks=[4, 3, 2, 1])),
    ]),
    's3': aggregator(recipe=[
        (1, top_k_fast(scorer=lambda x: x.spm_diff(), ks=[4, 3, 2, 1])),
    ]),
    's4': aggregator(recipe=[
        (1, top_k_fast(scorer=lambda x: x.score, ks=[4, 3, 2, 1])),
    ]),
    's5': aggregator(recipe=[
        (1, top_k_fast(scorer=lambda x: x.ter(), ks=[4, 3, 2, 1])),
    ]),
    'o1': aggregator(recipe=[
        (1, top_k_fast(scorer=lambda x: x.bleu(), ks=[2, 2, 1, 1])),
    ]),
    'o2': aggregator(recipe=[
        (1, top_k_fast(scorer=lambda x: x.chrf(), ks=[2, 2, 1, 1])),
    ]),
    'o3': aggregator(recipe=[
        (1, top_k_fast(scorer=lambda x: x.spm_diff(), ks=[2, 2, 1, 1])),
    ]),
    'o4': aggregator(recipe=[
        (1, top_k_fast(scorer=lambda x: x.score, ks=[2, 2, 1, 1])),
    ]),
    'o5': aggregator(recipe=[
        (1, top_k_fast(scorer=lambda x: x.ter(), ks=[2, 2, 1, 1])),
    ]),
    'c1': aggregator(recipe=[
        (1, original()),
        (1, aggregator_deduplicate(recipe=[
            top_k(scorer=lambda x: x.score, k=4),
            top_k(scorer=lambda x: x.bleu(), k=4),
        ]))
    ]),
    'c2': aggregator(recipe=[
        (1, aggregator_deduplicate(recipe=[
            top_k_fast(scorer=lambda x: x.bleu(), ks=[1, 1]),
            top_k_fast(scorer=lambda x: x.ter(), ks=[1, 1]),
            top_k_fast(scorer=lambda x: x.chrf(), ks=[1, 1]),
            top_k_fast(scorer=lambda x: x.spm_diff(), ks=[1, 1]),
            top_k_fast(scorer=lambda x: x.score, ks=[1, 1]),
        ]))
    ]),
    'c3': aggregator(recipe=[
        (1, top_k(scorer=lambda x: x.score, k=12)),
        (1, aggregator_deduplicate(recipe=[
            top_k_fast(scorer=lambda x: x.bleu(), ks=[1, 1]),
            top_k_fast(scorer=lambda x: x.ter(), ks=[1, 1]),
            top_k_fast(scorer=lambda x: x.chrf(), ks=[1, 1]),
            top_k_fast(scorer=lambda x: x.spm_diff(), ks=[1, 1]),
            top_k_fast(scorer=lambda x: x.score, ks=[1, 1]),
        ]))
    ]),
    'c4': aggregator(recipe=[
        (1, aggregator_deduplicate(recipe=[
            top_k(scorer=lambda x: x.score, k=4),
            top_k(scorer=lambda x: x.bleu(), k=4),
        ])),
        (1, aggregator_deduplicate(recipe=[
            top_k(scorer=lambda x: x.score, k=1),
            top_k(scorer=lambda x: x.bleu(), k=1),
        ])),
    ]),
    'c5': aggregator(recipe=[
        (1, top_k(scorer=lambda x: x.score, k=12)),
        (1, top_k(scorer=lambda x: x.score, k=4)),
    ]),
    'c6': aggregator(recipe=[
        (1, aggregator_deduplicate(recipe=[
            top_k(scorer=lambda x: x.score, k=4),
            top_k(scorer=lambda x: x.bleu(), k=4),
        ])),
        (1, top_k(scorer=lambda x: x.score, k=1)),
        (1, top_k(scorer=lambda x: x.bleu(), k=1)),
    ]),
    'c7': aggregator(recipe=[
        (1, top_k(scorer=lambda x: x.score, k=12)),
        (1, top_k(scorer=lambda x: x.bleu(), k=4)),
    ]),
    'c8': aggregator(recipe=[
        (1, top_k(scorer=lambda x: x.score, k=4)),
        (1, top_k(scorer=lambda x: x.bleu(), k=4)),
    ]),
    'c9': aggregator(recipe=[
        (1, aggregator_deduplicate(recipe=[
            top_k(scorer=lambda x: x.score, k=4),
            top_k(scorer=lambda x: x.bleu(), k=4),
        ]))
    ]),
    'x1': aggregator(recipe=[
        (2, original()),
        (1, top_k_fast(scorer=lambda x: x.bleu(), ks=[4, 3, 2, 1])),
    ]),
    'x2': aggregator(recipe=[
        (4, original()),
        (1, top_k_fast(scorer=lambda x: x.bleu(), ks=[4, 3, 2, 1])),
    ]),
    'y1': aggregator(recipe=[
        (2, original()),
        (1, top_k_fast(scorer=lambda x: x.score, ks=[4, 3, 2, 1])),
    ]),
}