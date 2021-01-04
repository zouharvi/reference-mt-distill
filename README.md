# Reference MT Distillation

Repository for the project _Sampling and Filtering of Neural Machine Translation Distillation Data_


## Introduction 

Model distillation is the task of training a new model (student) in a way that its performance is similar to the one of the already trained one (teacher), by making use either of teacher predictions (black-box) or other products of the workings of the teacher, such as attention-score or decoder score (grey/glass-box). Assuming that we have access to a parallel corpus, we focus on sampling the translation queries and making use not only of the teacher scores but also of their comparison to the reference. There are several motivation factors for MT model distillation.  The student model can be much smaller than the teacher, which has the benefit of faster inference speed. It can also be used for model stealing, which is a practical concern for production MT systems.

## Pre-processing 

### Download data

To get the dataset we used for training, evaluating and training our models, simply run the scripts provided in the **reference-mt-steal/data/** directory. First use [_download_process.sh_](./data/download_process.sh) to download, shuffle and create the datasets. We fokused on de-en, en-de, en-cs and cs-en translation. 


### Create datasets
With [create_data.py](src/create_data.py) we are able to create new training, evaluation and test datasets for all language directions (de-en, en-de, cs-en, en-cs). The created datasets are then stored in [data/original](data/original/). The files then look like _train.cs-en.cs_ or _test.de-en.en_. For a description of those files read [this](#datasets).

### Crop dataset for development
For development we also crop the created datasets. They then contain only 10 sentences which makes it viable to test the implementation on a CPU. For that run the [crop.sh](data/crop.sh) script also provided in the same directory.


## Model

#### Teacher models
As our teacher models, we use pre-trained models from the [Machine Translation Group at the UEDIN](http://data.statmt.org/). The script [download.sh](models/download.sh) downloads 3 teacher models (en-de, cs-en, en-cs). For Inference we use the [MarianNMT](https://marian-nmt.github.io/) framework in the script [infer_teacher_all.sh](models/infer_teacher_all.sh). 

#### Student models
All of our student  models  share  the  same  configuration  and  follow  the teacher’s architecture with half the size the embedding vector (256 instead of 512) and half the attention heads (4 instead of 8). Student models were trained with an early stopping of 20 on validation data with evaluation every 10k sentences.

## Training
`TODO: cluster_scripts/...`


## File Types 

Here is a brief explonation of the files that are created during execution.

#### Datasets <a name="datasets"></a>

These files are the paralel corpus. E.g. take _train.cs-en.en_ and _train.cs-en.cs_ from [data/original](data/original/). Both contain sentences in either english for the .en file or in czech for the .cs file. So line _x_ of file _a_ is the translation of line _x_ in file _b_ and vica versa. This also holds for _eval_ and _test_ files.

The same holds for files in [data/experiment/](data/experiment/). But this time the datasets are the ones that have been extracted from the teacher model.

#### Outputs

The output files that are created contain the provided sentences, the scores and the best hypotheses. All information sepperated by \' ||| \'.  

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
- M1: T(bleu, 1)
- M2: T(chrf, 1)
- M3: T(sp, 1)
- M5: T(TER, 1)
- N1: T(bleu, 4)
- N2: T(chrf, 4)
- N3: T(sp, 4)
- N4: T(score, 4)
- N5: T(TER, 4)

### Guaranteed:
- G1: G(bleu, 65/60/55)
- G2: G(chrf, 0.9/0.85/0.8) 
- G3: G(sp, -1/-2/-1) 
- G4: G(score, -0.08/-0.09/-0.10) 
- G5: G(TER, -0.20/-0.22/-0.24) 

### Oversampling S:
- S1: F(bleu, 4,3,2,1)
- S2: F(score, 4,3,2,1)
- S3: F(chrf, 4,3,2,1)
- S4: F(score, 4,3,2,1)
- S5: F(TER, 4,3,2,1)

### Oversampling O:
- O1: F(bleu, 2,2,1,1)
- O2: F(score, 2,2,1,1)
- O3: F(chrf, 2,2,1,1)
- O4: F(score, 2,2,1,1)
- O5: F(TER, 2,2,1,1)

### Combination

`TODO: Philipp`

- C1
- C2
- C3
- C4
- C5
- C6
- C7
- C8
- C9
