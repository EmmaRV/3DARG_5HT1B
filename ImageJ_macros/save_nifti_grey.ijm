macro "save_nifty_grey" {

		filepath_input = File.openDialog("Select input file"); 		
		input_filename = File.getName(filepath_input);
		input_folder = File.getParent(filepath_input);

		output_folder=getDirectory("Choose an output directory");
		stack_folder=getDirectory("Choose an output directory for the stack");

		print("Input folder: " + input_folder);
		print("Output folder: " + output_folder);
		print("Output folder for stack: " + stack_folder);

function save_nifti_grey(input_folder, input_filename, output_folder)  {
		open(input_folder + input_filename);
		//run("16-bit");
		run("Flip Horizontally"); //
		new_filename = replace(input_filename, ".tif", "_16bit");
		run("NIfTI-1", "save=" + output_folder + new_filename + ".nii");
	    close();
}
	
setBatchMode(true);
list = getFileList(input);
for (i = 0; i < list.length; i++)
	save_nifti_grey(input_folder, list[i], output_folder);
setBatchMode(false);

		Dialog.create("Settings");
		Dialog.addChoice("Modality:", newArray("Nissl", "ARG"));
		Dialog.addChoice("Segmented?", newArray("yes", "no"));
		Dialog.show();
		modality = Dialog.getChoice();
		segmented = Dialog.getChoice();
	 	if (segmented == "yes")
		{name_ext = "_segmented";}
	 	if (segmented == "no")
	 	{name_ext = "";}

run("Image Sequence...", "open=" + output_folder + modality + name_ext + "_resliced_" + 1 + "_16bit.tif sort");
saveAs("Tiff", stack_folder + modality + "_resliced_16bit");
open(stack_folder + modality + name_ext + "_resliced_16bit.tif");
run("NIfTI-1", "save=" + stack_folder + modality + name_ext + "_resliced_16bit.nii");

print("Saved in: " + stack_folder);
print("Saved as: " + modality + name_ext + "_resliced_16bit in tiff and nii format");

close();

}