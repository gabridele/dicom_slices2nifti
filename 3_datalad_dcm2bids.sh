#!/bin/bash
#SBATCH -t 00:30:00
#SBATCH -N 4
#SBATCH --ntasks-per-node=4
#SBATCH -J dcm2bids
#SBATCH --output=job_output.log # Standard output log
#SBATCH --error=job_error.log   # Standard error log

set -e -u -x
module load GCC/12.2.0
module load Anaconda3/2022.05
module load parallel/20230722
source /sw/easybuild_milan/software/Anaconda3/2022.05/bin/activate ~/.conda/envs/babs_28_11

source config.sh || {
    echo "Error: Failed to source config file"
    exit 1
}
for subid in $(find $dataset/sourcedata -mindepth 1 -maxdepth 1 -type d -name 'sub-*' | sed -E 's|.*/sub-([0-9]+)$|\1|' | sort -n); do
	for sesid in $(find $dataset/sourcedata/sub-${subid} -mindepth 1 -maxdepth 1 -type d -name 'session*' | sed -E 's|.*/session([0-9]+)$|\1|' | sort -n); do
    	echo "Processing sub-${subid} ses-${sesid}"
    	datalad run \
	    	-i code/3_1_bidsify.sh \
	        -i "$input_dir"/config.json \
	        -i "$input_dir"/${subid}/${sesid} \
	        -i bidsify-container/.datalad/environments/dcm2bids-latest/image \
	        --expand both \
	        --explicit \
	        -o $output_bound \
	        -m "dcm2bids ${subid} ${sesid}" \
	        "bash ./code/bidsify.sh ${subid} ${sesid}"
	done
done
