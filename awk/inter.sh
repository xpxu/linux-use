#!/usr/local/bin/bash
sort -m <(sort $1 | uniq) <(sort $2 | uniq) | uniq -d 
