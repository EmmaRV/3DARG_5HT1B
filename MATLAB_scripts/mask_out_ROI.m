function[] = mask_out_ROI(input_file, input_mask, folder)

% Script to mask out a ROI from e.g. MRI or PET images (as nifti-files). 
% uses 'readnifti' and 'createnifti' function, alternatively use 'niftiread'
% and 'niftiwrite'

cd(folder)

file = readnifti(input_file);
mask = readnifti(input_mask);

masked_out = immultiply(mask,file);

createnifti(masked_out, [input_file(1:end-4) '_masked_' input_mask(1:end-4) '.nii'], [input_mask(1:end-4) ' masked out of ' input_file(1:end-4)], input_file)
