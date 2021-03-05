macro resize_photo {

		filepath_input = File.openDialog("Select input file"); 
		filename = File.getName(filepath_input);		
		input = File.getParent(filepath_input);

		output=getDirectory("Choose an output directory");

		print("Output folder: " + output);

function resize_photo(input, output, filename) {
		open(input + filename);
		run("Size...", "width=3036 height=1395 constrain average interpolation=Bilinear");
		run("Rotate 90 Degrees Left");
		saveAs("Tiff", output + filename);
		close();
}

setBatchMode(true);
list = getFileList(input);
for (i = 0; i < list.length; i++)
	resize_photo(input, output, list[i]);
setBatchMode(false);

}

