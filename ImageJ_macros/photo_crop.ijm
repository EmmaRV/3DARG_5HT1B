// requires user action

macro "photo_crop" {

		filepath_input = File.openDialog("Select input photo file"); 		
		filename_photo = File.getName(filepath_input);
		input_photo = File.getParent(filepath_input);

		filepath_input_mask = File.openDialog("Select input mask file"); 		
		input_mask = File.getParent(filepath_input_mask);

		output=getDirectory("Choose an output directory");

		print("Input photo folder: " + input_photo);
		print("Input mask folder: " + input_mask);
		print("Output directory folder: " + output);

function photo_crop(input_photo, input_mask, output, filename_photo) {
		open(input_photo + filename_photo);
		selectWindow(filename_photo);
		run("Enhance Contrast...", "saturated=2.5");
		filename_mask = replace(filename_photo,".tif", "_mask.tif");
		open(input_mask + filename_mask);
		selectWindow(filename_mask);
		setTool("wand");
		doWand(804, 1576, 77.0, "Legacy");
		waitForUser("Adjust Wand if necessary, then click OK");
		run("Copy");
		selectWindow(filename_photo);
		run("Restore Selection");
		waitForUser("Dubbelcheck selection, then click OK");
		setBackgroundColor(0, 0, 0);
		selectWindow(filename_photo);
		run("Clear Outside");
		saveAs("Tiff", output + filename_photo);
		close();
		close();
}

setBatchMode("show");
list = getFileList(input_photo);
for (i = 0; i < list.length; i++)
	photo_crop(input_photo, input_mask, output, list[i]);

	}
