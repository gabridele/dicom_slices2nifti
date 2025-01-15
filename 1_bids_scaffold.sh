#!/bin/bash
#SBATCH -t 00:05:00
#SBATCH -J bids_scaffold
#SBATCH --qos=test

set -e -u -x
module load GCC/12.2.0
module load Anaconda3/2022.05
module load parallel/20230722
source /sw/easybuild_milan/software/Anaconda3/2022.05/bin/activate ~/.conda/envs/babs_28_11

source $PWD/config.sh || {
    echo "Error: Failed to source config file"
    exit 1
}


singularity exec \
    -f -e --containall \
    -B "$root_dir":/"$output_bound" \
    bidsify-container/.datalad/environments/dcm2bids-latest/image dcm2bids_scaffold -o $output_bound/$dataset --force


# # cd to dataset and make it datalad dataset
# cd $root_dir/$dataset
# if [[ "$(pwd)" == "$root_dir/$dataset" ]]; then
#     datalad create -c text2git -f
# else
#     echo "Error: Not in the correct directory to create dataset"
#     exit 1
# fi
# echo "Dataset datalad status:"
# datalad status

# # save scaffold
# datalad save -d . -m 'created bids scaffold'
# #it works
# it fucking worked before and not not anymore. didnt change much command wise
