# Do not run this script, it is meant to be sourced by the main script

#n_sessions do not input session num because script extracts it

# input participant number range (aka num of participants, supposes they are consecutive numbers)
n_sub=10

# path to root directory
root_dir="$PWD"

#path to singularity image
singularity_img="${root_dir}/../backup_files/dcm2bids_latest.sif"

# path dir to input
input_dir="${root_dir}/../backup_deidentified_rsfmri/rsfMRI"

# name of bound input dir (arbitrary name)
input_bound="/dicoms"

# name of dataset folder
dataset="Biof_1401"

# name of bound output dir (arbitrary name)
output_bound="/bids"

# num of scans per session, useful if some sessions are acquired differently. It assumes same protocol across subs/sessions, except for slices vs volumes acquisitions\
## i.e., each dicom file is a slice, not a volume. in that case use python script
num_scans=462

# general path to dicom files, useful to create txt file containing paths, for python script input. Use wilcard * to match all paths across subjs
#gen_path_dicom="${root_dir}/../backup_deidentified_rsfmri/rsfMRI/sub-0${i}/session${ii}/DCM/Serie*"
