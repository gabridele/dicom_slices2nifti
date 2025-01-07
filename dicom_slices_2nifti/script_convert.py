import os
import pydicom
import nibabel as nib
import numpy as np
from collections import defaultdict
import argparse

def main(dicom_dir, output_dir, output_filename):
    acquisition_dict = defaultdict(list)

    # Iterate through all files in the DICOM directory
    for filename in os.listdir(dicom_dir):
        filepath = os.path.join(dicom_dir, filename)
        try:
            # Read the DICOM file
            ds = pydicom.dcmread(filepath)

            # Extract Series Number (0020, 0011)
            series_number = ds.get((0x0020, 0x0011), None)
            if series_number:
                series_number = series_number.value

            # Extract Acquisition Number (0020, 0012)
            acquisition_number = ds.get((0x0020, 0x0012), None)
            if acquisition_number:
                acquisition_number = acquisition_number.value

            # Extract Instance Number (0020, 0013)
            instance_number = ds.get((0x0020, 0x0013), None)
            if instance_number:
                instance_number = instance_number.value
            
            if acquisition_number is not None:
                acquisition_dict[acquisition_number].append((instance_number, filepath))

        except Exception as e:
            print(f"Error reading {filepath}: {e}")

    # Sort files within each acquisition group by InstanceNumber
    for acquisition_number, files in acquisition_dict.items():
        acquisition_dict[acquisition_number] = sorted(files, key=lambda x: x[0])  # Sort by InstanceNumber

    # Output the grouped data
    print(f"Found {len(acquisition_dict)} unique acquisitions.")

    # Print a summary of each acquisition group
    for acquisition_number, files in acquisition_dict.items():
        print(f"Acquisition Number: {acquisition_number}, Number of Slices: {len(files)}")

    # Ensure output directory exists
    os.makedirs(output_dir, exist_ok=True)

    # Initialize an empty list to store the 3D volumes
    all_volumes = []

    # Convert each group to a 3D volume and append to the list
    for acquisition_number, files in acquisition_dict.items():
        slices = []

        # Read each DICOM slice and append it to the list
        for _, filepath in files:
            try:
                ds = pydicom.dcmread(filepath)
                img_array = ds.pixel_array  # Get the pixel data from the DICOM slice
                slices.append(img_array)
            except Exception as e:
                print(f"Error processing {filepath}: {e}")

        # Stack the slices to form a 3D volume
        volume = np.stack(slices, axis=-1)

        # Append the volume to the list of all volumes
        all_volumes.append(volume)

    # Stack all volumes along the new 4th axis (4D array)
    fourth_dim_data = np.stack(all_volumes, axis=-1)

    # Create a 4D NIfTI image from the stacked volumes
    nifti_img = nib.Nifti1Image(fourth_dim_data, affine=np.eye(4))  # Identity matrix for affine transformation

    # Save the 4D NIfTI file
    nifti_filepath = os.path.join(output_dir, output_filename)
    nib.save(nifti_img, nifti_filepath)

    print(f"Saved 4D NIfTI file: {nifti_filepath}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Convert DICOM slices into a 4D NIfTI file.")
    parser.add_argument(
        "-i", "--input-dir", 
        required=True, 
        help="Path to the input directory containing DICOM files."
    )
    parser.add_argument(
        "-o", "--output-dir", 
        required=True, 
        help="Path to the output directory to save the NIfTI file."
    )
    parser.add_argument(
        "-f", "--output-filename", 
        default="nifti_file.nii.gz", 
        help="Name of the output NIfTI file (default: nifti_file.nii.gz)."
    )

    args = parser.parse_args()

    main(args.input_dir, args.output_dir, args.output_filename)
