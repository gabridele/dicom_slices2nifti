# Do not run this script, it is meant to be sourced by the main script

#n_sessions=4 do not input session num because script extracts it
n_sub=10
input_dir='/home/gabridele/backup/backup_deidentified_rsfmri/rsfMRI'
input_bound='/dicoms'
output_dir='/home/gabridele/backup'
dataset='Biof_2312'
output_bound='/bids'

num_scans=462
gen_path_dicom="/home/gabridele/backup/backup_deidentified_rsfmri/rsfMRI/sub-0${i}/session${ii}/DCM/Serie*"

# input participant number range (aka num of participants, supposes they are consecutive numbers)
# path dir to input
# name of bound input dir (arbitrary name)
# path dir to output
# name of dataset folder
# name of bound output dir (arbitrary name)

# num of scans per session, useful if some sessions are acquired differently. \
## i.e., each dicom file is a slice, not a volume. in that case use python script
# general path to dicom files, useful to create txt file containing paths, for python script input. Use wilcard * to match all paths across subjs