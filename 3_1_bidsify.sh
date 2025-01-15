#!/bin/bash

set -e -u -x
module load GCC/12.2.0
module load Anaconda3/2022.05
module load parallel/20230722
source /sw/easybuild_milan/software/Anaconda3/2022.05/bin/activate ~/.conda/envs/babs_28_11

source config.sh || {
    echo "Error: Failed to source config file"
    exit 1
}

echo "Working on dataset: $dataset"

subid="$1"
strippedid=$(echo "$subid" | sed 's/^sub-//')
sesid="$2"

# if sesid = none
if [[ -z "$sesid" ]]; then
    if [[ "$sesid" == "session4" ]]; then
        echo "Skipping subject $subid with session $sesid"
        exit 0
    fi
    echo "Processing subject $subid with no sessions"    
    singularity run -e -containall \
        -B $input_dir:/$input_bound \
        -B $root_dir:/$output_bound \
        bidsify-container/.datalad/environments/dcm2bids-latest/image \
        --auto_extract_entities --bids_validate \
        -o /$output_bound \
        -d /"$input_bound"/$subid \
        -c /"$input_bound"/config.json \
        -p $strippedid || echo "Error processing $subid"


else

    echo "Processing subject $subid, $sesid"

    singularity run -e -containall \
        -B $input_dir:/$input_bound \
        -B $root_dir:/$output_bound \
        bidsify-container/.datalad/environments/dcm2bids-latest/image \
        --auto_extract_entities --bids_validate \
        -o /$output_bound \
        -d /"$input_bound"/$subid/$sesid \
        -c /"$input_bound"/config.json \
        -s $sesid \
        -p $strippedid || echo "Error processing $subid $sesid"

fi