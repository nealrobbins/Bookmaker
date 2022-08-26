#!/bin/bash

#short script for adding a soft return after each line in a text file

string='  '

cat $1 | while read line; do echo ${line}$string; done
