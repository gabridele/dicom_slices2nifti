Code allowing to convert dicom files into nifti files and arranging them according to the BIDS format. This is basically a wrapper around the singularity image [```dcm2bids```](https://unfmontreal.github.io/Dcm2Bids/3.2.0/). 
Scripts are tailored to be run on a SLURM high performing computer.

How to run:

- open ```config.sh``` file and set your variables. These paths will be used in the main script.

- then run: ```$ sbatch bidsify.sh```
  - alternatively, ```$ bash bidsify.sh``` works too, by running the job locally and not in a remote node

Note:
You should create a config file, as outlined in the [```dcm2bids``` documentation](https://unfmontreal.github.io/Dcm2Bids/3.2.0/how-to/create-config-file/)
Requirements:
- Libraries:
  - [Datalad](https://github.com/datalad) and its dependencies 
  - [Singularity](https://docs.sylabs.io/guides/3.0/user-guide/installation.html)
- Downloading singularity image [```dcm2bids```](https://unfmontreal.github.io/Dcm2Bids/3.0.1/get-started/install/#containers)

In case some dicom acquisitions are made slice by slice, you will be notified by the script that some subjects acquisitions don't match the number of scans you defined. In that case a txt file with the filepaths will be produced. That txt file can be used as a flag with the python script.
