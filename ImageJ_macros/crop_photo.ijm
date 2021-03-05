// size based on ruler and size of glass slide 74 x 34 mm

macro crop_photo {

		filepath_input = File.openDialog("Select input file"); 
		filename = File.getName(filepath_input);		
		input = File.getParent(filepath_input);

		output=getDirectory("Choose an output directory");

		print("Output folder: " + output);

function crop_photo(input, output, filename) {
		open(input + filename);
		selectWindow(filename);  
		myImageID = getImageID();
		makeRectangle(870, 1190, 3318, 1525);
		waitForUser("Adjust Rectangle, then click OK");
		selectImage(myImageID); 
		run("Cut");
		run("Internal Clipboard");
		saveAs("Tiff", output + filename);
		close();
		close();
}

setBatchMode("show");
list = getFileList(input);
for (i = 0; i < list.length; i++)
	crop_photo(input, output, list[i]);

	}
