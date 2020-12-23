# Reference MT Steal

Repository for the project _Almost Black-Box MT Model Stealing with Reference Translations Supersampling_


## Introduction 

Consider the following scenario. You want to train a machine learning model to translate between languages but you don't have enough bilingual data to train it accurate. We suggest a simple solution. The idea is quite simple. We use an already trained teacher model and query it on a big monolingual dataset. We than use our dataset and the output of the teacher to create our own bilingual dataset. We then can train our model based on the new data and get better results than training only on the small bilingual dataset we had before. For extraction we will use different strategies and compare them to get the best results.

## Pre-processing 

### Download data

To get the dataset we used for training, evaluating and training our models, simply run the scripts provided in the **reference-mt-steal/data/** directory. First use [_download_process.sh_](./data/download_process.sh) to download, shuffle and create the datasets. We fokused on de-en, en-de, en-cs and cs-en translation. 


### Create datasets
With [_create_data.py_](./src/create_data.py) we are able to create new training, evaluation and test datasets for all language directions (de-en, en-de, cs-en, en-cs). The created datasets are then stored in [_data/original_](./data/original/). The files then look like _train.cs-en.cs_ or _test.de-en.en_. For a description of those files read [this](#datasets).

### Crop dataset for development
For development we also crop the created datasets. They then contain only 10 sentences each to test the implementation also on a CPU only. For that run the [_crop.sh_](./data/crop.sh) script also provided in the same directory.


## Model

#### Teacher models
As our teacher models, we use pre-trained models from the [Machine Translation Group at the UEDIN](http://data.statmt.org/). The script [download.sh](./models/download.sh) downloads 3 teacher models (en-de, cs-en, en-cs). For Inference we use the [marian](https://marian-nmt.github.io/)-Framework in the script [infer_teacher_all.sh](./models/infer_teacher_all.sh). 

#### Student models

`TODO`

---------------------------------
`TODO: used model, extraction, training of students based on small and new datasets`

---------------------------------
`TODO: eval.py - documentation`

## File Types 

Here is a brief explonation of the files that are created during execution.

#### Datasets <a name="datasets"></a>

These files are the paralel corpus. E.g. take _train.cs-en.en_ and _train.cs-en.cs_ from [data/original](./data/original/). Both contain sentences in either english for the .en file or in czech for the .cs file. So line _x_ of file _a_ is the translation of line _x_ in file _b_ and vica versa. This also holds for _eval_ and _test_ files.

The same holds for files in [data/experiment/](data/experiment/). But this time the datasets are the ones that have been extracted from the teacher model.

#### Outputs

The output files that are created contain the provided sentences, the scores and the best hypotheses. All information sepperated by \' ||| \'.  

`TODO: add more files and their descriptions` 
