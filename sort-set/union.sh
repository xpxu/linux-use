#!/usr/local/bin/bash
#1.-m, --merge
#              merge already sorted files; do not sort
#2. uniq should be used after sort 
#3, < 是重定向的意思 
sort -m <`sort file1 | uniq` <(sort file2 | uniq) | uniq
