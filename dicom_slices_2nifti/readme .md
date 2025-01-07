This is a python script that converts a set of single dicom slices (not volumes) into a nifti file

How to run: 

```python3 script_convert.py -i path/to/input/dir/containing/dicom/slices -o path/to/where/to/save/nifti/file -f filename.nii.gz```

or if you have a txt file containing the subjects' paths for each line:

```python3 script_convert.py --txt-file path/to/txtfile.txt```