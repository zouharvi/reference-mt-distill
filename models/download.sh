#!/bin/bash

# run me from the model directory

# ende
wget -nc -P teacher/ende/ http://data.statmt.org/romang/bergamot/models/deen/ende.student.base/model.npz
wget -nc -P teacher/ende/ http://data.statmt.org/romang/bergamot/models/deen/ende.student.tiny11/lex.s2t.gz
wget -nc -P teacher/ende/ http://data.statmt.org/romang/bergamot/models/deen/vocab.deen.spm
mv teacher/ende/vocab.deen.spm teacher/ende/vocab.spm

# csen
wget -nc -P teacher/csen/ http://data.statmt.org/bergamot/models/8bit-students/csen/base/model.npz.best-bleu-detok.npz
wget -nc -P teacher/csen/ http://data.statmt.org/bergamot/models/8bit-students/csen/base/lex.s2t.gz
wget -nc -P teacher/csen/ http://data.statmt.org/bergamot/models/8bit-students/csen/base/vocab.spm
mv teacher/csen/model.npz.best-bleu-detok.npz teacher/csen/model.npz

# encs
wget -nc -P teacher/encs/ http://data.statmt.org/bergamot/models/8bit-students/encs/base/model.npz.best-bleu-detok.npz
wget -nc -P teacher/encs/ http://data.statmt.org/bergamot/models/8bit-students/encs/base/lex.s2t.gz
wget -nc -P teacher/encs/ http://data.statmt.org/bergamot/models/8bit-students/encs/base/vocab.spm
mv teacher/encs/model.npz.best-bleu-detok.npz teacher/encs/model.npz