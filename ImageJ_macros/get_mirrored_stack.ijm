macro "get_mirrored_stack" {

		filepath_input = File.openDialog("Select input stack file"); 		
		input_filename = File.getName(filepath_input);
		stack_folder = File.getParent(filepath_input);

		separate_slices_folder=getDirectory("Choose an output directory for separate slices");

		print("Stack folder: " + stack_folder);
		print("Output directory folder for separate slides: " + separate_slices_folder);
		
		Dialog.create("Settings");
		Dialog.addChoice("Modality:", newArray("Nissl", "ARG"));
		Dialog.addChoice("Segmented?", newArray("yes", "no"));
		Dialog.addChoice("Adjusted colours?", newArray("yes", "no"));
		Dialog.addChoice("Order of stack slices", newArray("lateral-medial", "medial-lateral"));
		Dialog.show();
		
		modality = Dialog.getChoice();
		
		segmented = Dialog.getChoice();
		if (segmented == "yes")
	 	{name_ext = "_segmented";}
	 	if (segmented == "no")
	 	{name_ext = "";}
	 	
	 	adjusted_col = Dialog.getChoice();
	 	if (adjusted_col == "yes")
	 	{ext = name_ext + "_adjvalues";}
	 	if (adjusted_col == "no")
	 	{ext = name_ext + "";}

		order = Dialog.getChoice();
		
		stack_output_filename = replace(input_filename, "_realigned_adjvalues.tif", ext + "_mirrored")

		open(stack_folder + input_filename);

		if (order == "lateral-medial"){
	for (i=0; i<nSlices; i++) { 	   
	     a = i+1;
	     b = 70-i;
	     Stack.setSlice(a); 
	     run("Duplicate...", "use"); 
		saveAs("Tiff", separate_folder + modality + ext + "_" + a);
		run("Duplicate...", "use"); 
		saveAs("Tiff", separate_folder + modality + ext + "_" + b);
	     close();
	     close();
		}	
	}
	
	if (order == "medial-lateral"){
	for (i=0; i<nSlices; i++) {   
	     a = i+1;
	     b = 35-i;
	     c = i+36;
	     Stack.setSlice(a); 
	     run("Duplicate...", "use"); 
		saveAs("Tiff", separate_folder + modality + ext + "_" + b);
		run("Duplicate...", "use"); 
		saveAs("Tiff", separate_folder + modality + ext + "_" + c);
	     close();
	     close();
		}
	}

		close(); 
		
		run("Image Sequence...", "open=" + separate_slices_folder + modality + ext + '_' + 1 + ".tif sort");
		saveAs("Tiff", stack_folder + stack_output_filename);

close();

}
