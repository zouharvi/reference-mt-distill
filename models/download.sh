#!/bin/bash

wget -nc -P ende/ http://data.statmt.org/romang/bergamot/models/deen/ende.student.base/model.npz
wget -nc -P ende/ http://data.statmt.org/romang/bergamot/models/deen/ende.student.tiny11/lex.s2t.gz
wget -nc -P ende/ http://data.statmt.org/romang/bergamot/models/deen/vocab.deen.spm


wget -nc -P csen/ http://data.statmt.org/bergamot/models/8bit-students/csen/base/model.npz.best-bleu-detok.npz
wget -nc -P csen/ http://data.statmt.org/bergamot/models/8bit-students/csen/base/lex.s2t.gz
wget -nc -P csen/ http://data.statmt.org/bergamot/models/8bit-students/csen/base/vocab.spm

wget -nc -P encs/ http://data.statmt.org/bergamot/models/8bit-students/encs/base/model.npz.best-bleu-detok.npz
wget -nc -P encs/ http://data.statmt.org/bergamot/models/8bit-students/encs/base/lex.s2t.gz
wget -nc -P encs/ http://data.statmt.org/bergamot/models/8bit-students/encs/base/vocab.spm
