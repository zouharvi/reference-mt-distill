#!/bin/bash

qrsh -q 'gpu*' -l gpu=4,gpu_ram=3G -pe smp 4 -pty yes bash -l
