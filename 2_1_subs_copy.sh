#!/bin/bash

set -e -u -x
module load GCC/12.2.0
module load Anaconda3/2022.05
module load parallel/20230722
source /sw/easybuild_milan/software/Anaconda3/2022.05/bin/activate ~/.conda/envs/babs_28_11

source $PWD/config.sh || {
    echo "Error: Failed to source config file"
    exit 1
}

echo "now proceeding to copy"


cd "$input_dir"
echo "I'm in $PWD"

subdir="$1"
rsync -Rv --ignore-existing "$subdir" "$root_dir/$dataset/sourcedata/"


echo "done copying subject dirs"
