#!/usr/local/bin/bash
sort -m <(sort file1 | uniq) <(sort file2 | uniq) | uniq
