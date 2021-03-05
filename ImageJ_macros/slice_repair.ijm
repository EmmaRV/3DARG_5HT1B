// script to help 'repair' slices, if no adjustments need to be made, just click OK through the script

macro "slice_repair" {

		filepath_input = File.openDialog("Select input ARG file"); 		
		filename_arg = File.getName(filepath_input);
		input_arg = File.getParent(filepath_input);

		filepath_input_nissl = File.openDialog("Select input nissl file"); 		
		input_nissl = File.getParent(filepath_input_nissl);

		output_arg=getDirectory("Choose an output directory for ARG files");
		output_nissl=getDirectory("Choose an output directory for nissl files");

		print("Input ARG folder: " + input_arg);
		print("Input nissl folder: " + input_nissl);
		print("Output directory folder for ARG files: " + output_arg);
		print("Output directory folder for nissl files: " + output_nissl);

function slice_repair(input_arg, input_nissl, output_arg, output_nissl, filename_arg) {
		// 1. Open files
		open(input_arg + filename_arg);
		filename_nissl = replace(filename_arg,".tif", "_nissl.tif");
		open(input_nissl + filename_nissl);

		// 2. Select ROIs to be adjusted in Nissl image 
		selectWindow(filename_nissl);
		setTool("freehand");
		waitForUser("Click outside selection, then click OK");
		run("ROI Manager...");
		waitForUser("Select parts to be adjusted, type 'T', then click OK");
		selectWindow(filename_nissl);
		waitForUser("For every ROI: Select ROI-manager, cut and paste in correct position and type 'T', rename ROI (e.g. 'new_...' and then click OK");

		// 3. Adjust ROIs in ARG image
		selectWindow(filename_nissl);
		run("ROI Manager...");
		waitForUser("For every ROI to be adjusted: select, cut, select new ROI and paste, [create at least one ROI] then click OK");
		run("ROI Manager...");
		roiManager("Delete");

		// 4. Check and save
		run("Show All");
		selectWindow(filename_arg);
		saveAs("Tiff", output_arg + filename_arg);
		close();
		selectWindow(filename_nissl);
		saveAs("Tiff", output_nissl + filename_nissl);
		close();

}

setBatchMode("show");
list = getFileList(input_arg);
for (i = 0; i < list.length; i++)
	slice_repair(input_arg, input_nissl, output_arg, output_nissl, list[i]);

}