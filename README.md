# Reference MT Steal

Repository for the project _Almost Black-Box MT Model Stealing with Reference Translations Supersampling_


## Data

#### Download and prepair dataset

To get the dataset we used for training, evaluating and training our models, simply run the scripts provided in the **reference-mt-steal/data/** directory. First use [_download_process.sh_](./data/download_process.sh) to download, shuffle and create the datasets. We fokused on de-en, en-de, en-cs and cs-en translation. After the download we crop our training-dataset. For that run the [_crop.sh_](./data/crop.sh) script also provided in the same directory.

## Models
