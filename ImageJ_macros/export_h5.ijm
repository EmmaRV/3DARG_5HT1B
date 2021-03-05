macro "export_h5" {
		filepath_input = File.openDialog("Select input file"); 		
		input_filename = File.getName(filepath_input);
		input = File.getParent(filepath_input);
	
		print("Input directory source: " + input);

		output=getDirectory("Choose an output directory for output files"); 
		print("Output directory files: " + output);
	
		open(input + input_filename);

	for (i=0; i<nSlices; i++) {  // i count starts at 0, slice number count starts at 1 	   
	     selectWindow(input_filename);
	     a = i+1;
	     Stack.setSlice(a); 
	     run("Duplicate...", "use"); 
		 run("Export HDF5", "hdf5filename=" + output + a + ".h5 input=" + input_filename + " compressionlevel=0");
	     close();
		}

close(); 

}
