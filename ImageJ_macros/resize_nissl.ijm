macro resize_nissl {

		filepath_input = File.openDialog("Select input file"); 
		filename = File.getName(filepath_input);		
		input = File.getParent(filepath_input);

		output=getDirectory("Choose an output directory");

		print("Output folder: " + output);

function resize_nissl(input, output, filename) {
		open(input + filename);
		selectWindow(filename);  
		myImageID = getImageID();
		makeRectangle(1704, 432, 7655, 6368); 
		waitForUser("Adjust Rectangle, then click OK");
		selectImage(myImageID); 
		run("Cut");
		run("Internal Clipboard");
		run("Size...", "width=9765 height=8123 constrain average interpolation=Bilinear");
		makeRectangle(5632, 4, 1395, 3036); 
		waitForUser("Compare size of rectangle with slide size, then click OK");
		saveAs("Tiff", output + filename);
		close();
		close();
}

setBatchMode("show");
list = getFileList(input);
for (i = 0; i < list.length; i++)
	crop_photo(input, output, list[i]);

	}
