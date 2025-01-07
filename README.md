Code allowing to convert dicom files into nifti files and arranging them according to the BIDS format. This is basically a wrapper around the singularity image [```dcm2bids```](https://unfmontreal.github.io/Dcm2Bids/3.2.0/). 
Scripts are tailored to be run on a SLURM high performing computer.

How to run:

- open ```config.sh``` file and set your variables. These paths will be used in the main script.

- then run: ```$ sbatch bidsify.sh```
  - alternatively, ```$ bash bidsify.sh``` works too, by running the job locally and not in a remote node

Requirements:
- Libraries:
  - [Datalad](https://github.com/datalad) and its dependencies 
  - [Singularity](https://docs.sylabs.io/guides/3.0/user-guide/installation.html)
- Downloading singularity image [```dcm2bids```](https://unfmontreal.github.io/Dcm2Bids/3.0.1/get-started/install/#containers)
