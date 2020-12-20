# Reference MT Steal

Repository for the project _Almost Black-Box MT Model Stealing with Reference Translations Supersampling_


## Pre-processing 

### Download data

To get the dataset we used for training, evaluating and training our models, simply run the scripts provided in the **reference-mt-steal/data/** directory. First use [_download_process.sh_](./data/download_process.sh) to download, shuffle and create the datasets. We fokused on de-en, en-de, en-cs and cs-en translation. 


### Create datasets
With [_create_data.py_](./src/create_data.py) we are able to create new training, evaluation and test datasets for all language directions (de-en, en-de, cs-en, en-cs). The created datasets are then stored in [_data/original_](./data/original/). The files then look like _train.cs-en.cs_ or _test.de-en.en_. For a description of those files read [this](#datasets).

### Crop dataset for development
For development we also crop the created datasets. They then contain only 10 sentences each to test the implementation also on a CPU only. For that run the [_crop.sh_](./data/crop.sh) script also provided in the same directory.


## Model

`TODO: training, evaluation, testing of teacher and students`

## File Types 

Here is a brief explonation of the files that are created during execution.

#### Datasets <a name="datasets"></a>

These files are the paralel corpus. E.g. take _data/original/train.cs-en.en_ and _data/original/train.cs-en.cs_. Both contain sentences in either english for the .en file or in czech for the .cs file. So line _x_ of file _a_ is the translation of line _x_ in file _b_ and vica versa. This also holds for _eval_ and _test_ files.

#### Outputs

The output files that are created while training, evaluation or testing contain the provided sentences, the scores and the best hypotheses. All information sepperated by 
\' ||| \'. They are stored in either the [_teacher_](./data/teacher/) directory - if teacher model was queried - or in the [_experiment_](./data/experiment) directory - if a student model, which was trainend based on the teacher, was queried. 

`TODO: add more files and their descriptions` 
