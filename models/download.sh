#!/bin/bash

# run me from the model directory

# ende
wget -nc -P teacher/ende/ http://data.statmt.org/romang/bergamot/models/deen/ende.student.base/model.npz
wget -nc -P teacher/ende/ http://data.statmt.org/romang/bergamot/models/deen/ende.student.tiny11/lex.s2t.gz
wget -nc -P teacher/ende/ http://data.statmt.org/romang/bergamot/models/deen/vocab.deen.spm
mv teacher/ende/vocab.deen.spm teacher/ende/vocab.spm

# csen
wget -nc -P teacher/csen/ http://data.statmt.org/bergamot/models/csen/csen.student.base.tar
tar -xf teacher/csen/csen.student.base.tar
mv csen.student.base/* teacher/csen
rm -rf csen.student.base

# encs
wget -nc -P teacher/encs/ http://data.statmt.org/bergamot/models/csen/encs.student.base.tar
tar -xf teacher/encs/encs.student.base.tar
mv encs.student.base/* teacher/encs
rm -rf encs.student.base