macro "photo_contrast" {

		filepath_input = File.openDialog("Select input photo file"); 		
		filename = File.getName(filepath_input);
		input = File.getParent(filepath_input);

		output=getDirectory("Choose an output directory");

		print("Output folder: " + output);

function photo_contrast(input, output, filename) {
		open(input + filename);
		selectWindow(filename);
		run("Enhance Contrast...", "saturated=5");
		run("Subtract Background...", "rolling=50 light");
		run("Smooth");
		run("Enhance Contrast...", "saturated=5");
		saveAs("Tiff", output + filename);
		close();
}

setBatchMode(true);
list = getFileList(input);
for (i = 0; i < list.length; i++)
	photo_contrast(input, output, list[i]);
setBatchMode(false);

}		
