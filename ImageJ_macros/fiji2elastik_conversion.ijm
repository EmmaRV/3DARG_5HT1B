macro "fiji2elastik_conversion" {

		filepath_input = File.openDialog("Select input file"); 
		filename = File.getName(filepath_input);		
		input = File.getParent(filepath_input);

		output=getDirectory("Choose an output directory");

		print("Output folder: " + output);

function fiji2ilastik_conversion(input, output, filename) {
		open(input + filename);
		name_only=replace(filename,".tif",".");
		run("Export HDF5", "hdf5filename="+output+name_only+"h5 input="+filename+" compressionlevel=0");
		close();
}

setBatchMode(true);
list = getFileList(input);
for (i = 0; i < list.length; i++)
	fiji2ilastik_conversion(input, output, list[i]);
setBatchMode(false);

}
