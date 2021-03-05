// To create an animation for volume viewer
// e.g. 36 photos with +10 angles
// based on script by Kai Uwe Barthel
// check https://imagej.nih.gov/ij/plugins/volume-viewer.html

macro "volume_viewer_animation" {
		filepath_input = File.openDialog("Select input file"); 		
		input_filename = File.getName(filepath_input);
		input_folder = File.getParent(filepath_input);		

		output_folder=getDirectory("Choose an output directory");

		print("Input folder: " + input_folder);
		print("Output folder: " + output_folder);

		Dialog.create("Settings");
  		Dialog.addNumber("Scale:", 5);
  		Dialog.addChoice("Plane", newArray("Axial", "Coronal", "Saggital"));
		Dialog.show();
		scale = Dialog.getNumber();
		plane = Dialog.getChoice();
		
	 	if (plane == "Axial")
		{	start_dist = -12.5;
			end_dist = -90;
			delta_dist = abs(end_dist) - abs(start_dist);
			n = 60;
			nametag = "_axial"
			angle_y = 0;
			;}
	 	if (plane == "Coronal")
	 	{	start_dist = -900;
	 		end_dist = abs(start_dist);
			delta_dist = end_dist * 2;
			n = 30;
			nametag = "_coronal"
			angle_y = 90;
	 		;}
	 	if (plane == "Saggital")
	 	{	start_dist = -900;
	 		end_dist = abs(start_dist);
			delta_dist = end_dist * 2;
			n = 70;
			nametag = "_saggital"
			angle_y = 0;
	 		;}

setBatchMode(true);
	
	slice_dist = delta_dist / n;
	mode = 0; // mode = slice

	open(input_folder + input_filename);

	stack1 = input_filename;
  	stack2 = 0;
  	
for (i=0; i<n; i++) {  
	showProgress(i, n);
    selectImage(stack1);
	dist = start_dist - i * slice_dist; 
	//dist = start_dist + i * slice_dist; 
	run("Volume Viewer", "display_mode=" + mode + " dist=" + dist + " scale=" + scale + " axes=0 interpolation=2 angle_x=0 angle_z=0 angle_y=" + angle_y);
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

  newfilename = replace(input_filename, ".tif", nametag);
	
  selectWindow("Plots");
  saveAs("Tiff", output +  newfilename);
  close();
}