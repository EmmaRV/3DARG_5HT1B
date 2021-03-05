macro "nissl_crop" {

		filepath_input_nissl = File.openDialog("Select input nissl file"); 
		filename_nissl = File.getName(filepath_input_nissl);		
		input_nissl = File.getParent(filepath_input_nissl);

		filepath_input_mask = File.openDialog("Select input mask file"); 		
		input_mask = File.getParent(filepath_input_mask);

		output_nissl=getDirectory("Choose an output directory for nissl files");
		output_mask=getDirectory("Choose an output directory for mask files");

		print("Output folder for nissl files: " + output_nissl);
		print("Output folder for mask files: " + output_mask);

function nissl_crop(input_nissl, input_mask, output_nissl, output_mask, filename_nissl) {
		open(input_nissl + filename_nissl);
		filename_mask = replace(filename_nissl,".tif", "_mask.tif");
		open(input_mask + filename_mask);

		// 1. Create selection and include parts
		selectWindow(filename_mask);
		run("Wand Tool...", "tolerance=0 mode=4-connected");
		doWand(174, 918, 0.0, "4-connected");
		waitForUser("1. Adjust Wand if necessary, then click OK");
		run("Copy");
		selectWindow(filename_nissl);
		run("Restore Selection");
		setTool("dropper");
		run("Color Picker...");
		setForegroundColor(255, 255, 255);
		setBackgroundColor(0, 0, 0);
		run("Sync Windows");
		setTool("brush");
		waitForUser("Select images to be synced, synchronize all and paint part to be enlarged on mask, then click OK");
		run("Fill", "slice");

		// 2. Updated selection, remove parts 
		setTool("rectangle");
		waitForUser("2. Click outside selection, then click OK");
		run("Wand Tool...", "tolerance=0 mode=4-connected");
		doWand(174, 918, 0.0, "4-connected");
		waitForUser("2. Adjust Wand if necessary, then click OK");
		run("Copy");
		selectWindow(filename_nissl);
		run("Restore Selection");	
		selectWindow(filename_mask);
		setForegroundColor(255, 255, 255);
		setBackgroundColor(0, 0, 0);
		setTool("brush");
		waitForUser("Paint part to be removed, connect all to be removed, then click OK");
		run("Clear Outside");
		run("Fill", "slice");

		// 3. Updated selection, final or to be adjusted again
		run("Wand Tool...", "tolerance=0 mode=4-connected");
		doWand(174, 918, 0.0, "4-connected");
		waitForUser("3. Adjust Wand if necessary, then click OK");
		run("Copy");	
		selectWindow(filename_nissl);
		run("Restore Selection");
		waitForUser("Check if selection is ok, otherwise adjust and create new selection, then click OK");
		run("Clear Outside");
		saveAs("Tiff", output_nissl + filename_nissl);
		close();
		selectWindow(filename_mask);
		saveAs("Tiff", output_mask + filename_mask);
		close();
}

setBatchMode("show");
list = getFileList(input_nissl);
for (i = 72; i < list.length; i++)
	nissl_crop(input_nissl, input_mask, output_nissl, output_mask, list[i]);

}
