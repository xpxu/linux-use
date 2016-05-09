#!/bin/bash

# In bash, to use rm !(file.txt), you must enable extglob:
shopt -s extglob

rm -rf !(drop8|drop9|drop9.1|tools|get_snapshot|site_usdev2335.conf)


# link: http://unix.stackexchange.com/questions/153862/remove-all-files-directories-except-for-one-file
