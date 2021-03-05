// script to help 'repair' slices, if no adjustments need to be made, just click OK through the script

macro "photo_repair" {

		filepath_input = File.openDialog("Select input photo file"); 		
		filename_photo = File.getName(filepath_input);
		input_photo = File.getParent(filepath_input);

		filepath_input_nissl = File.openDialog("Select input nissl file"); 		
		input_nissl = File.getParent(filepath_input_nissl);

		output=getDirectory("Choose an output directory");

		print("Input photo folder: " + input_photo);
		print("Input nissl folder: " + input_nissl);
		print("Output directory folder: " + output);

function photo_repair(input_photo, input_nissl, output, filename_photo) {
		open(input_photo + filename_photo);
		filename_nissl = replace(filename_photo,".tif", "_nissl.tif");
		open(input_nissl + filename_nissl);
		
		selectWindow(filename_photo);
		setTool("freehand");
		waitForUser("Select part to be removed, then click OK");
		run("Cut");
		
		selectWindow(filename_nissl);
		close();
		selectWindow(filename_photo);
		saveAs("Tiff", output + filename_photo);
		close();
}

setBatchMode("show");
list = getFileList(input_photo);
for (i = 44; i < 64; i++)
	photo_repair(input_photo, input_nissl, output, list[i]);

	}
