# Reference MT Distillation

Repository for the project [Sampling and Filtering of Neural Machine Translation Distillation Data](https://arxiv.org/abs/2104.00664). Cite as:

```
@misc{zouhar2021sampling,
      title={Sampling and Filtering of Neural Machine Translation Distillation Data}, 
      author={Vilém Zouhar},
      year={2021},
      eprint={2104.00664},
      archivePrefix={arXiv},
      primaryClass={cs.CL}
}
```


## Introduction 

Model distillation is the task of training a new model (student) in a way that its performance is similar to the one of the already trained one (teacher), by making use either of teacher predictions (black-box) or other products of the workings of the teacher, such as attention-score or decoder score (grey/glass-box). Assuming that we have access to a parallel corpus, we focus on sampling the translation queries and making use not only of the teacher scores but also of their comparison to the reference. There are several motivation factors for MT model distillation.  The student model can be much smaller than the teacher, which has the benefit of faster inference speed. It can also be used for model stealing, which is a practical concern for production MT systems.

## Pre-processing 

### Download data

To get the dataset we used for training, evaluating and training our models, simply run the scripts provided in the **reference-mt-steal/data/** directory. First use [_download_process.sh_](./data/download_process.sh) to download, shuffle and create the datasets. We focused on de-en, en-de, en-cs and cs-en translation. 


### Create datasets
With [create_data.py](src/create_data.py) we are able to create new training, evaluation and test datasets for all language directions (de-en, en-de, cs-en, en-cs). The created datasets are then stored in [data/original](data/original/). The files then look like _train.cs-en.cs_ or _test.de-en.en_. For a description of those files read [this](#datasets).

For development, it is possible to crop the created datasets. They then contain only 10 sentences which makes it viable to test the implementation on a CPU. For that run the [crop.sh](data/crop.sh) script also provided in the same directory.


## Model

#### Teacher models
As our teacher models, we use pre-trained models from the [Machine Translation Group at the UEDIN](http://data.statmt.org/). The script [download.sh](models/download.sh) downloads 3 teacher models (en-de, cs-en, en-cs). For Inference we use the [MarianNMT](https://marian-nmt.github.io/) framework in the script [infer_teacher_all.sh](models/infer_teacher_all.sh). 

#### Student models
Most of our student models share the same configuration and follow the teacher’s architecture with half the size the embedding vector (256 instead of 512) and half the attention heads (4 instead of 8). Student models were trained with an early stopping of 20 on validation data with evaluation every 10k sentences.

## Processing Pipeline

For monitoring active jobs, use `qstat3`. For validation training, use `bleu2`.

An example data creation, training and evaluation for `x1` for `csen encs ende`.

1. Submit data creation `./cluster_scripts/submit_create_data.sh "x1" "csen encs ende"`
2. Submit trainig `./cluster_scripts/submit_experiment.sh "x1"`
3. Submit infer test data `./cluster_scripts/submit_infer_student.sh "x1"`
4. Evalate test data with BLEU `./cluster_scripts/eval_student_test.sh "x1"`

To clear all model data in the current cluster instance use `./cluster_scripts/clear_models.sh`. For test inference on the teacher models use `./cluster_scripts/infer_teacher_{test,wmt,all}.sh`.

## File Types 

A brief explanation of the files that are created during execution.

#### Datasets <a name="datasets"></a>

These files are the paralel corpus. E.g. take _train.cs-en.en_ and _train.cs-en.cs_ from [data/original](data/original/). Both contain sentences in either English for the .en file or in Czech for the .cs file.

The same holds for files in [data/experiment/](data/experiment/). But this time, the datasets are the ones that have been extracted from the teacher model.

#### Outputs

The output files that are created contain the provided sentences, the scores and the best hypotheses. All information separated by ` ||| `.  

## Experiment composition

- T(metrics, k) := take __k__-th sentences according to __metrics__.
- G(metrics, min) := take all sentences with __metrics__ of at least __min__.
- F(metrics, (a1, a2, a3, ..)) := take the first sentence according to __metrics__ and duplicate it __a1__-times. Similarly for __j__-th sentence and __aj__. The rest is zeroes.
- Dedup\[X\] := deduplicate sentence pairs in X.
- All of the configurations are stored in [src/recipes.py](src/recipes.py).

### Baseline
- B1: original data
- B2: T(score, 1)
- B3: T(score, 12)
- B4: T(score, 1) + original data

### Metrics
- M1: T(BLEU, 1)
- M2: T(chrf, 1)
- M3: T(sp, 1)
- M5: T(TER, 1)
- N1: T(BLEU, 4)
- N2: T(chrf, 4)
- N3: T(sp, 4)
- N4: T(score, 4)
- N5: T(TER, 4)

### Guaranteed:
- G1: G(BLEU, 65/60/55)
- G2: G(chrf, 0.9/0.85/0.8) 
- G3: G(sp, -1/-2/-1) 
- G4: G(score, -0.08/-0.09/-0.10) 
- G5: G(TER, -0.20/-0.22/-0.24) 

### Oversampling S:
- S1: F(BLEU, 4,3,2,1)
- S2: F(score, 4,3,2,1)
- S3: F(chrf, 4,3,2,1)
- S4: F(score, 4,3,2,1)
- S5: F(TER, 4,3,2,1)

### Oversampling O:
- O1: F(BLEU, 2,2,1,1)
- O2: F(score, 2,2,1,1)
- O3: F(chrf, 2,2,1,1)
- O4: F(score, 2,2,1,1)
- O5: F(TER, 2,2,1,1)

### Combination

- C1: Original + Dedup[ T(score, 4), T(BLEU, 4) ]
- C2: Dedup[ T(BLEU, 2), T(ter, 2), T(chrf, 2), T(spm_diff, 2), T(score, 2) ]
- C3: T(score, 12) + Dedup[ T(BLEU, 2), T(ter, 2), T(chrf, 2), T(spm_diff, 2), T(score, 2) ]
- C4: Dedup[ T(score, 4), T(BLEU, 4) ] + Dedup[ T(score, 1), T(BLEU, 1) ]
- C5: T(score, 12) + T(score, 4)
- C6: Dedup[ T(score, 4), T(BLEU, 4) ] + T(score, 1) + T(BLEU, 1)
- C7: T(score, 12) + T(BLEU, 4)
- C8: T(score, 4) + T(BLEU, 4)
- C9: Dedup[ T(score, 4), T(BLEU, 4) ]

### Combination Extra
- Y1: F(score, (4,3,2,1)) + 2\*Original
- X1: F(BLEU, (4,3,2,1)) + 2\*Original
- X2: F(BLEU, (4,3,2,1)) + 4\*Original
- X1: F(BLEU, (4,3,2,1)) + 2\*Original (teacher-sized model)
- X2: F(BLEU, (4,3,2,1)) + 4\*Original (teacher-sized model) 
