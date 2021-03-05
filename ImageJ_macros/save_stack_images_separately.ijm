macro "save_stack_images_separately" {

	filepath = File.openDialog("Select an input file"); 
	input_filename = File.getName(filepath);
	input_path = File.getParent(filepath);
	print("Input directory: " + input_path);
	print("Input file: " + input_filename);
	open(filepath);

	if (endsWith(input_filename, ".tif")) 
		{file_ext = ".tif";}
	if (endsWith(input_filename, ".nii")) 	
		{file_ext = ".nii";}

	output_path=getDirectory("Choose an output directory"); 
	print("Output directory: " + output_path); 

	output_filename = replace(input_filename, file_ext, "_");

	for (i=0; i<nSlices; i++) {  // i count starts at 0, slice number count starts at 1 	   
	     a = i+1;	     
	     Stack.setSlice(a); 
	     run("Duplicate...", "use"); 
	     if (file_ext == ".tif")
	     {saveAs("Tiff", output_path + output_filename + a);}  
		 if (file_ext == ".nii")
		 {run("NIfTI-1", "save=" + output_path + output_filename + a + ".nii");}	
	     close();
		}

close(); 

}