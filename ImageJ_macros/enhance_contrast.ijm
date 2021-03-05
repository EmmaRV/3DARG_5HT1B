macro enhance_contrast {

		filepath_input = File.openDialog("Select input file"); 
		filename = File.getName(filepath_input);		
		input = File.getParent(filepath_input);

		output=getDirectory("Choose an output directory");

		print("Output folder: " + output);

function enhance_contrast(input, output, filename) {
		open(input + filename);
		selectWindow(filename);
		run("Smooth");
		run("Enhance Contrast...", "saturated=10");		
		run("Subtract Background...", "rolling=1 light create");
		run("Subtract Background...", "rolling=50 light create sliding disable");
		run("Enhance Contrast...", "saturated=1");		
		run("8-bit");
		run("Southeast");		
		saveAs("Tiff", output + filename);
		close();
}

setBatchMode(true);
list = getFileList(input);
for (i = 0; i < list.length; i++)
	enhance_contrast(input, output, list[i]);
setBatchMode(false);

}
