macro rotate_all_images {

		filepath_input = File.openDialog("Select input file"); 
		filename = File.getName(filepath_input);		
		input = File.getParent(filepath_input);

		output=getDirectory("Choose an output directory");

		print("Output folder: " + output);

function flip_all_images(input, output, filename) {
		open(input + filename);
		run("Rotate... ", "angle=10 grid=1 interpolation=Bilinear");
		saveAs("Tiff", output + filename);
		close();
}

setBatchMode(true);
list = getFileList(input);
for (i = 0; i < list.length; i++)
	flip_all_images(input, output, list[i]);
setBatchMode(false);

//for extra flipping per slice
// fill in
// nr=

//open(output+nr+".tif");
//run("Rotate... ", "angle=10 grid=1 interpolation=Bilinear");
//saveAs("Tiff", output+nr+".tif");
//close();

}
