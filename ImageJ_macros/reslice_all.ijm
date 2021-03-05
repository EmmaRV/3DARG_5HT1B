macro "reslice_all" {
		filepath_input = File.openDialog("Select input stack file"); 		
		input_filename = File.getName(filepath_input);
		input_stack_folder = File.getParent(filepath_input);		

		separate_mirr_folder=getDirectory("Choose an output directory for mirrored separate files");
		reslice_separate_folder=getDirectory("Choose an output directory for resliced separate files"); 
		reslice_cropped_folder=getDirectory("Choose an output directory for resliced separate cropped files");  
		
		print("Input stack folder: " + input_stack_folder);
		print("Output directory folder for mirrored separate slides: " + separate_mirr_folder);
		print("Output directory folder for resliced separate slides: " + reslice_separate_folder);
		print("Output directory folder for cropped separate slides: " + reslice_cropped_folder);

		Dialog.create("Settings");
  		Dialog.addNumber("Nr of slices stack consists of before mirroring:", 35);
  		Dialog.addNumber("Nr of slices to be resliced in after mirroring:", 60);
  		Dialog.addChoice("Segmented?", newArray("yes", "no"));
		Dialog.show();
		nr_slices = Dialog.getNumber();
		nr_reslice = Dialog.getNumber();
		segmented = Dialog.getChoice();
		
	 	if (segmented == "yes")
		{nametag = "ARG_segmented";}
	 	if (segmented == "no")
	 	{nametag = "ARG";}

function reslice_all(input_stack_folder, input_filename, separate_mirr_folder, reslice_separate_folder, reslice_cropped_folder, nametag, nr_slices, nr_reslice) {

// get file in RGB
	open(input_stack_folder + input_filename);
	run("RGB Color");
	saveAs("Tiff", input_stack_folder + input_filename + "_RGB");

	selectWindow(input_filename);
	close();
	selectWindow(input_filename + "_RGB.tif");

// create mirrored stack file
	for (i=0; i<nSlices; i++) {	   
	     a = i+1;
	     b = nr_slices - i;
	     c = i + nr_slices + 1;
	     Stack.setSlice(a); 
	     run("Duplicate...", "use"); 
		saveAs("Tiff", separate_mirr_folder + nametag + b);
		run("Duplicate...", "use"); 
		saveAs("Tiff", separate_mirr_folder + nametag + c);
	     close();
	     close();
		}

	mirror_nametag = nametag + "_mirrored";
	run("Image Sequence...", "open=" + separate_mirr_folder + nametag + 1 + ".tif sort");
	saveAs("Tiff", input_stack_folder + mirror_nametag);

	selectWindow(input_filename + "_RGB.tif");
	close();

	selectWindow(mirror_nametag + ".tif");
	filename = getTitle();

// reslice in axial slices
	setBatchMode(true);	
	z = 20.25; // z-aspect
	scale = 0.35;
	start_dist = -1500;
	reslice_nametag = "_axial"
	angle_y = 0;
	
	end_dist = abs(start_dist);
	delta_dist = end_dist * 2;
	slice_dist = delta_dist / nr_reslice;
	mode = 0; // mode = slice

	stack1 = filename;
  	stack2 = 0;
  	
	for (i=0; i<nr_reslice; i++) {  
		showProgress(i, nr_reslice);
    	selectImage(stack1);
		dist = start_dist + i * slice_dist; 
    	run("Volume Viewer", "display_mode=" + mode + " z-aspect=" + z +" dist=" + dist + " scale=" + scale + " axes=0 interpolation=3 angle_x=90 angle_z=0 angle_y=" + angle_y);
		run("Copy");
		w=getWidth; h=getHeight;
		close();    
    		if (stack2==0) {
      		newImage("Plots", "RGB", w, h, 1);
      		stack2 = getImageID;
    		} else {
      		selectImage(stack2);
      		run("Add Slice");
    		}
    	run("Paste");
  	}
  	setSlice(1);
  	run("Select None");

	setBatchMode(false);

  	reslice_filename = replace(filename, ".tif", reslice_nametag);
	
  	selectWindow("Plots");
  	saveAs("Tiff", input_stack_folder +  reslice_filename);
  	reslice_file = getTitle();

// save resliced images separately
	nametag_resliced = nametag + "_resliced" + reslice_nametag;

	for (i=0; i<nSlices; i++) {	   
	     d = i+1;
	     Stack.setSlice(d); 
	     run("Duplicate...", "use"); 
		saveAs("Tiff", reslice_separate_folder + nametag_resliced + d);
	     close();
		}

// crop images from volume viewer
	selectWindow(reslice_file);
	
	for (i=0; i<nSlices; i++) {
		e = i+1; 
		Stack.setSlice(e); 
	    run("Duplicate...", "use"); 
		makeRectangle(0, 83, 480, 495);
		run("Copy");
		run("Internal Clipboard");
		saveAs("Tiff", reslice_cropped_folder + nametag_resliced + e);
		close();
	}

	close();
}

}
