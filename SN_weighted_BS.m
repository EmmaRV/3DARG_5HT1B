function[] = SN_weighted_BS(template_folder, template_file, MNI_BS_mask_folder, MNI_BS_mask_file)

% Creates a substantia nigra weighted brainstem mask
% use:
% 1. template_file = 'ATAG_Nonlinear_Keuken_2014_MNI_ROI.nii'
% 2. MNI_BS_mask_file = brainstem data masked out of MRI data in MNI space

%% get the SN from template
cd(template_folder)

input_file = readnifti(template_file);

new_file = input_file;
output = input_file*0;
output(new_file == 7) = 1;
output(new_file == 8) = 1;
createnifti(output,[template_file(1:end-4) '_SN.nii'], ['SN of ' input_file(1:end-4)], template_file)

SN_template = readnifti([template_file(1:end-4) '_SN.nii']);

%% load BS mask file
cd(MNI_BS_mask_folder)

BS_mask = readnifti(MNI_BS_mask_file);

%% resize
im=SN_template; %% input image
ny=d;nx=e;nz=f; %% desired output dimensions
[y x z]=...
   ndgrid(linspace(1,size(im,1),ny),...
          linspace(1,size(im,2),nx),...
          linspace(1,size(im,3),nz));
imOut=interp3(im,x,y,z);

cd(MNI_BS_mask_folder)

createnifti(imOut,[template_folder '/Resized_resliced_' template_file(1:end-4) '_SN_0.5.nii'], ['Resliced and resized SN of ' template_file(1:end-4)], MNI_BS_mask_file)

cd(template_folder)

rr_SN_template = readnifti(['Resized_resliced_' template_file(1:end-4) '_SN.nii']);

% check if size matches 
[a, b, c] = size(BS_mask);
[d, e, f] = size(rr_SN_template);

[a b c] == [d e f]
if sum(ans) ~= 3
    disp('Size of brainstem mask file and SN file do not match')
    return;
end

%% adjust intensity ATAG SN to get high intensity to match that of the MR brainstem
adj_SN = rr_SN_template;
new_output = rr_SN_template*0;
new_output(adj_SN > 0) = 500;

cd(MNI_BS_mask_folder)

createnifti(new_output,[template_folder '/Adjusted_SN_500.nii'],'SN of ATAG template with adj intensity', MNI_BS_mask_file)

cd(template_folder)

SN_template_500 = readnifti('Adjusted_SN_500.nii');

%% get SN weighted BS mask for transformation of 3D ARG to MNI space 
new_mask = BS_mask - SN_template_500;

cd(MNI_BS_mask_folder)

createnifti(new_mask,'BS_masked_weighted_SN.nii', 'SN weighted BS mask', MNI_BS_mask_file)
