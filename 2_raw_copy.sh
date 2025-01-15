#!/bin/bash
#SBATCH --time=05:00:00
#SBATCH -N 1
#SBATCH -J raw_copy
#SBATCH --output=%j_output.log # Standard output log
#SBATCH --error=%j_error.log   # Standard error log

set -e -u -x
module load GCC/12.2.0
module load Anaconda3/2022.05
module load parallel/20230722
source /sw/easybuild_milan/software/Anaconda3/2022.05/bin/activate ~/.conda/envs/babs_28_11

source $PWD/config.sh || {
    echo "Error: Failed to source config file"
    exit 1
}

cd "$input_dir"

echo "I'm in $PWD"
datalad status -d $root_dir/$dataset

for subdir in sub-*; do
    if [ -d "$subdir" ]; then
        datalad run \
	    	-i code/2_1_subs_copy.sh \
	        -i "$input_dir" \
	        --expand both \
	        --explicit \
	        -o $root_dir/$dataset/sourcedata/ \
	        -m "checking in raw data for ${subdir}" \
	        "bash $root_dir/2_1_subs_copy.sh ${subdir}"

    fi
done

for other in *; do
    if [ -d "$other" ] && [[ "$other" != sub-* ]]; then
        datalad run \
            -i code/2_2_copy_rest.sh \
            -i "$input_dir" \
            --expand both \
            --explicit \
            -o $root_dir/$dataset/sourcedata/ \
            -m "checking in file ${other} into raw dataset" \
            "bash $root_dir/2_2_copy_rest.sh ${other}"
    fi
done
