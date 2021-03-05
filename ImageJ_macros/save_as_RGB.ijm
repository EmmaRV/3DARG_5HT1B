macro save_as_RGB {

		filepath_input = File.openDialog("Select input file"); 
		filename = File.getName(filepath_input);		
		input = File.getParent(filepath_input);

		output=getDirectory("Choose an output directory");

		print("Output folder: " + output);

function save_as_RGB(input, output, filename) {
		open(input + filename);
		run("RGB Color");
		saveAs("Tiff", output + filename);
		close();
		close();
}

setBatchMode(true);
list = getFileList(input);
for (i = 1; i < list.length; i++)
	save_as_RGB(input, output, list[i]);
setBatchMode(false);

}