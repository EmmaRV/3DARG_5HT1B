macro "reslice_and_resize" {

		filepath_input = File.openDialog("Select input stack file"); 		
		input_filename = File.getName(filepath_input);
		stack_folder = File.getParent(filepath_input);

		separate_slices_folder=getDirectory("Choose an output directory for separate slices");

		print("Stack folder: " + stack_folder);
		print("Output directory folder for separate slides: " + separate_slices_folder);

	Dialog.create("Settings");
	Dialog.addString("Foldername resized images:", "Resized");
	Dialog.addString("Foldername rescliced images:", "Resliced");
	Dialog.addNumber("Scaling factor:", 36.714);
	Dialog.addChoice("Modality:", newArray("Nissl", "ARG"));
	Dialog.addChoice("Segmented?", newArray("yes", "no"));
  	Dialog.addNumber("Nr of slices:", 70);
	Dialog.show();
	
	scaling_factor = Dialog.getNumber();
	modality = Dialog.getChoice();
	
	segmented = Dialog.getChoice();
	 if (segmented == "yes")
	 {name_ext = "_segmented";}
	 if (segmented == "no")
	 {name_ext = "";}
	
	nr_slices = Dialog.getNumber();
	foldername_resized = Dialog.getString();
	foldername_resliced = Dialog.getString();
	
	resized_dir = separate_slices_folder + foldername_resized + name_ext + "\\" +File.separator;
  	if (!File.exists(resized_dir))
  		{File.makeDirectory(resized_dir);
  		if (!File.exists(resized_dir))
      	exit("Unable to create directory");}
  	print("");
  	print(resized_dir);

  	resliced_dir = separate_slices_folder + foldername_resliced + name_ext + "\\" +File.separator;
  	if (!File.exists(resliced_dir))
  		{File.makeDirectory(resliced_dir);
  		if (!File.exists(resliced_dir))
      	exit("Unable to create directory");}
  	print("");
  	print(resliced_dir);
	
	resized_output = resized_dir;
	resliced_output = resliced_dir;
	
	// resize canvas
	open(stack_folder + input_filename);

	for (i=0; i<nSlices; i++) {  // i count starts at 0, slice number count starts at 1 	   
	     a = i+1;
	     Stack.setSlice(a); 
	     run("Duplicate...", "use"); 
		
		new_width = round(scaling_factor * 218);
		new_height = round(scaling_factor * 182);	
		run("Canvas Size...", "width=" + new_width + " height=" + new_height + " position=Center zero");
		saveAs("Tiff", resized_output + modality + name_ext + "_resized_" + a);
		close();
	}
	close();
	
	run("Image Sequence...", "open=" + resized_output + modality + name_ext + "_resized_" + 1 + ".tif sort");
	saveAs("Tiff", stack_folder + modality + name_ext + "_resized");

	run("Size...", "width=2180 height=1820 constrain average interpolation=Bilinear");
	saveAs("Tiff", stack_folder + modality + name_ext + "_resizedx10");

		// add empty images to get full brain space
		selectWindow(modality + name_ext + "_resizedx10.tif");

		slices_toadd = (364 - nr_slices)/2;
		print(slices_toadd);
		setSlice(1);
		run("Copy");
		run("Add Slice");
		setSlice(2);
		run("Paste");
		setSlice(1);
		run("Select All");
		run("Clear", "slice");
		slices_left = slices_toadd - 1;
		for (i=0; i< slices_left; i++) {
			run("Add Slice");
			setSlice(1);
		}
		slicenr_toset = slices_toadd + nr_slices;
		setSlice(slicenr_toset);
		for (i=0; i< slices_toadd; i++) {
			run("Add Slice");
			setSlice(slicenr_toset);
		}

		saveAs("Tiff", stack_folder + modality + name_ext + "_addedspace");

		// reslice
		selectWindow(modality + name_ext + "_addedspace.tif");
		run("Reslice [/]...", "output=1.000 start=Bottom flip rotate");
//		run("Flip Horizontally", "stack");
		selectWindow(modality + name_ext + "_addedspace.tif");
		close();

		// downscaled
		selectWindow("Reslice of " + modality + name_ext + "_addedspace");
		run("Size...", "width=182 height=218 depth=182 average interpolation=Bilinear");
//		run("Properties...", "channels=1 slices=182 frames=1 unit=pixel pixel_width=1.0000 pixel_height=1.0000 voxel_depth=1.0000");
		saveAs("Tiff", stack_folder + modality + name_ext + "_resliced");

		// save as separate images
		selectWindow(modality + name_ext + "_resliced.tif");
		for (i=0; i<nSlices; i++) { 	   
	     a = i+1;
	     Stack.setSlice(a); 
	     run("Duplicate...", "use"); 
		saveAs("Tiff", resliced_output + modality + name_ext + "_resliced_" + a);
	     close();
		}

		close();
		
}
