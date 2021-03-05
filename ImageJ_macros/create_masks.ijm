macro "create_masks" {

		filepath_input = File.openDialog("Select input file"); 
		filename = File.getName(filepath_input);		
		input = File.getParent(filepath_input);

		output=getDirectory("Choose an output directory");

		print("Output folder: " + output);

function create_masks(input, output, filename) {
	run("Import HDF5", "hdf5filename=["+input+filename+"]");	// click on 'load raw'
	selectWindow(input+filename+"//exported_data"); 
	run("Apply LUT");
	run("Make Binary");
	run("Invert");
	run("Wand Tool...", "tolerance=0 mode=4-connected");
	doWand(174, 918, 0.0, "4-connected");
	waitForUser("Adjust Wand if necessary, then click OK");
	setForegroundColor(255, 255, 255);
	run("Fill", "slice");
	setBackgroundColor(0, 0, 0);
	run("Clear Outside");
	run("Invert");
	run("Dilate");
	run("Close-");
	run("Invert");
//	run("Fill Holes"); //	additional option
// 	waitForUser("Check fill holes, then click OK");
//	run("Dilate");
//	waitForUser("Check dilate, then click OK");
//	run("Close-");
//	waitForUser("Check close, then click OK"); //
	run("Gaussian Blur...", "sigma=2");
	setTool("wand");
	run("Wand Tool...", "tolerance=0 mode=4-connected");
	doWand(174, 918, 0.0, "4-connected");
	waitForUser("Adjust Wand if necessary, then click OK");
	run("Fill", "slice");
	setBackgroundColor(0, 0, 0);
	run("Clear Outside");
	new_filename=replace(filename,"Simple Segmentation.h5","mask");
	saveAs("Tiff", output + new_filename);
	close();
}

setBatchMode("show");
list = getFileList(input);
for (i = 0; i < list.length; i++)
	create_masks(input, output, list[i]);
setBatchMode(false);

}
