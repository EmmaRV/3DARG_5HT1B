macro "batch_subtract" {
		filepath_NS = File.openDialog("Select first input NS file"); 		
		filename_1_NS = File.getName(filepath_NS);
		
		filepath_T = File.openDialog("Select first input T file"); 

		input_NS = File.getParent(filepath_NS);
		input_T = File.getParent(filepath_T);
	
		print("Input directory source: " + input_NS);
		print("Input directory target: " + input_T);

		output_SB=getDirectory("Choose an output directory for output (SB) files"); 
		print("Output directory files: " + output_SB);

function batch_subtract(input_NS, filename_NS, input_T, filename_T, output_SB) {
	open(input_NS + filename_NS);
	open(input_T + filename_T);

	selectWindow(filename_T);
	waitForUser("In case a part of the image is selection, click outside of selection, then click OK");
	run("Invert");
	selectWindow(filename_NS);
	waitForUser("In case a part of the image is selection, click outside of selection, then click OK");
	run("Invert");
	imageCalculator("Subtract create", filename_T, filename_NS);
	selectWindow("Result of " + filename_T);
	run("Invert");

	selectWindow(filename_T);
	setTool("wand");
	doWand(537, 735, 192.0, "Legacy");
	waitForUser("Check if wand is in right position, then click OK");
	//run("Wand Tool...", "tolerance=192 mode=Legacy");
	run("Copy");
	selectWindow("Result of " + filename_T);
	run("Restore Selection");
	setBackgroundColor(0, 0, 0);
	run("Clear Outside");

	saveAs("Tiff", output_SB + "SpecificBinding_" +  filename_T);

	run("Close All");

	}

setBatchMode("show");
//setBatchMode(true);
list_NS = getFileList(input_NS);
list_T = getFileList(input_T);
for (i = 29; i < list_NS.length; i++)
batch_subtract(input_NS, list_NS[i], input_T, list_T[i], output_SB);
//setBatchMode(false);

}
