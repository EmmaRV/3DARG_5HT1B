macro "arg_crop" {

		filepath_input_arg = File.openDialog("Select input ARG file"); 		
		filename_arg = File.getName(filepath_input_arg);
		input_arg = File.getParent(filepath_input_arg);

		filepath_input_mask = File.openDialog("Select input mask file"); 		
		input_mask = File.getParent(filepath_input_mask);

		filepath_input_nissl = File.openDialog("Select input nissl file"); 		
		input_nissl = File.getParent(filepath_input_nissl);

		output_arg=getDirectory("Choose an output directory for ARG files");
		output_nissl=getDirectory("Choose an output directory for nissl files");

		print("Output folder for ARG files: " + output_arg);
		print("Output folder for nissl files: " + output_nissl);

function arg_crop(input_arg, input_mask, input_nissl, output_arg, output_nissl, filename_arg) {
		// 1. Open files and select mask
		open(input_arg + filename_arg);
		open(input_nissl + filename_arg);
		filename_nissl = replace(filename_arg,".tif", "-1.tif");
		filename_mask = replace(filename_arg,".tif", "_mask.tif");
		open(input_mask + filename_mask);	
		selectWindow(filename_mask);
		
		run("Wand Tool...", "tolerance=0 mode=4-connected");
		doWand(174, 918, 0.0, "4-connected");
		waitForUser("Mask-file (step 1): Adjust Wand if necessary, then click OK");
		run("Copy");

		// 2. Check mask on ARG and adjust if necessary
		selectWindow(filename_arg);
		run("Restore Selection");
		setTool("brush");
		waitForUser("ARG-file (step 2): Adjust selection if necessary, then click OK");

		// 3. Copy to mask
		run("Copy");
		selectWindow(filename_mask);
		run("Restore Selection");
		run("Clear Outside");
		run("Fill", "slice");
		run("Wand Tool...", "tolerance=0 mode=4-connected");
		doWand(174, 918, 0.0, "4-connected");
		waitForUser("Mask-file (step 3): Adjust position of wand if necessary, then click OK");

		// 4. Adjust nissl crop
		run("Copy");
		selectWindow(filename_nissl);
		run("Restore Selection");
		setTool("brush");
		waitForUser("Nissl-file (step 4): Adjust selection if necessary, then click OK");
		
		// 5. Last adjustments and set background to black
		setTool("dropper");
		run("Color Picker...");
		setBackgroundColor(0, 0, 0);
		setForegroundColor(255, 255, 255);	
		
		run("Copy");
		selectWindow(filename_arg);
		run("Restore Selection");
		setTool("brush");
		waitForUser("(Step 5) Adjust selection on ARG if necessary, then click OK");
		run("Copy");
		run("Clear Outside");
		saveAs("Tiff", output_arg + filename_arg);
		
		selectWindow(filename_nissl);
		run("Restore Selection");
		setTool("brush");
		waitForUser("(Step 5) Adjust selection on nissl if necessary, then click OK");
		run("Copy");
		run("Clear Outside");
		
		selectWindow(filename_mask);
		run("Restore Selection");
		run("Clear Outside");
		setTool("dropper");
		run("Color Picker...");
		setForegroundColor(255, 255, 255);
		run("Fill", "slice");
		saveAs("Tiff", input_mask + filename_mask);
		close();

		selectWindow(filename_arg);
		close();
		selectWindow(filename_nissl);
		new_nissl_name = replace(filename_nissl,"-1", "_nissl");
		saveAs("Tiff", output_nissl + new_nissl_name);
		close();
}

setBatchMode("show");
list = getFileList(input_arg);
for (i = 69; i < list.length; i++)
	arg_crop(input_arg, input_mask, input_nissl, output_arg, output_nissl, list[i]);

	}
