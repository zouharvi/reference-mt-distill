#!/bin/python3

from utils import loader

gen = loader('teacher/europarl.cs-en.cs', 'original/europarl.cs-en.cs')

for x in gen:
    print(x[0])