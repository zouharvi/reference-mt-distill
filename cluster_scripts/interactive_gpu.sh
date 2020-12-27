#!/bin/bash

qrsh -q 'gpu*' -l gpu=6,gpu_ram=3G -pe smp 6 -pty yes bash -l
