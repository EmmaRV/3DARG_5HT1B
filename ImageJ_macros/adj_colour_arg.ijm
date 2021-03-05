macro "adj_colour_arg" {

		filepath_input = File.openDialog("Select input stack file"); 		
		input_filename = File.getName(filepath_input);
		stack_folder = File.getParent(filepath_input);

		separate_slices_folder=getDirectory("Choose an output directory for separate slice files");

		print("Stack folder: " + stack_folder);
		print("Output directory folder for separate slides: " + separate_slices_folder);

		Dialog.create("Settings");
  		Dialog.addChoice("Segmented?", newArray("yes", "no"));
		Dialog.show();
		
		segmented = Dialog.getChoice();
	 	if (segmented == "yes")
		{nametag = "ARG_segmented";}
	 	if (segmented == "no")
	 	{nametag = "ARG";}
	
	run("Threshold...");
	
	stack_output_filename = replace(input_filename, ".tif", ext)
	open(stack_folder + input_filename);

for (i=0; i<nSlices; i++) {
	Stack.setSlice(i);
	run("Duplicate...", "use");
	run("16-bit");
	call("ij.plugin.frame.ThresholdAdjuster.setMode", "Red");

	if (segmented == "no") {	
	// select missed tissue
	setThreshold(255, 65535);
	run("Create Selection");
	run("Set...", "value=240");   // lightgrey
	run("Select None");
	// background
	setThreshold(0, 10);
	run("Create Selection");
	run("Set...", "value=255");  // white
	run("Select None");
	// invert values
	run("Invert");
	// get black background
	run("Color Picker...");
	setBackgroundColor(0, 0, 0);
	setThreshold(0, 10);
	run("Create Selection");	
	run("Clear", "slice");
	}
	
	if (segmented == "yes") {	
		// lowest binding
	setThreshold(240, 65535);
	run("Create Selection");
	run("Set...", "value=25");   // 0-50
	// low binding
	setThreshold(165, 65535);
	run("Create Selection");
	run("Set...", "value=75");  // 50-100
	// medium binding
	setThreshold(130, 65535);
	run("Create Selection");
	run("Set...", "value=150");	 // 100-200
	// high binding
	setThreshold(80, 100);
	run("Create Selection");
	run("Set...", "value=275");  // 200-350
	}
	
	saveAs("Tiff", separate_folder + nametag + "_adjvalues_" + i+1);
	close();
}

		close(); 
		
		run("Image Sequence...", "open=" + separate_slices_folder + nametag + "_adjvalues_" + 1 + ".tif sort");
		saveAs("Tiff", stack_folder + stack_output_filename);

close();

}
