// requires user action

macro "photo_cropandmask" {

		filepath_input = File.openDialog("Select input photo file"); 		
		filename_photo = File.getName(filepath_input);
		input_photo = File.getParent(filepath_input);

		output_crop=getDirectory("Choose an output directory for cropped files");
		output_mask=getDirectory("Choose an output directory for masked files");

		print("Input photo folder: " + input_photo);
		print("Output directory folder: " + output_crop);
		print("Output mask folder: " + output_mask);

function photo_cropandmask(input_photo, output_crop, output_mask, filename_photo) {
		open(input_photo + filename_photo);
		selectWindow(filename_photo);
		setTool("wand");
		doWand(804, 1576, 77.0, "Legacy");
		waitForUser("Adjust Wand if necessary, then click OK");
		setBackgroundColor(0, 0, 0);
		run("Clear Outside");
		setTool("wand");
		doWand(804, 1576, 77.0, "Legacy");
		waitForUser("Adjust selection, then click OK");
		run("Clear Outside");
		saveAs("Tiff", output_crop + filename_photo);
		setForegroundColor(255, 255, 255);
		run("Fill", "slice");
		saveAs("Tiff", output_mask + filename_photo);
		close();
}

setBatchMode("show");
list = getFileList(input);
for (i = 0; i < list.length; i++)
	photo_cropandmask(input_photo, output_crop, output_mask, list[i]);

	}
