function[] = create_mask(input_filename, folder)

% Create a mask from a nifti file
% uses 'readnifti' and 'createnifti' function, alternatively use 'niftiread'
% and 'niftiwrite'

cd(folder);

input_file = readnifti(input_filename);

new_file = input_file;
output = input_file*0;
output(new_file > 0) = 1;
createnifti(output,[input_filename(1:end-4) '_mask.nii'], ['Mask of ' input_filename(1:end-4)], input_filename)
