// T-slices should be listed before their equivalent NS-slices

macro "save_T_NS" {
		filepath_input = File.openDialog("Select first input NS file"); 		
		filename_1_input = File.getName(filepath_input);
		input = File.getParent(filepath_input);
	
		print("Input directory source: " + input);

		output_T=getDirectory("Choose an output directory for output T files"); 
		print("Output directory files: " + output_T);

		output_NS=getDirectory("Choose an output directory for output NS files"); 
		print("Output directory files: " + output_NS);

function save_T_NS(input, output_T, output_NS, filename) {
			open(input + filename);

			 j = i/2;
			 if (round(j) == j)
				{saveAs("Tiff", output_T + list[i]);
					close();}
			 if (round(j) > j)
				{saveAs("Tiff", output_NS + list[i]);
					close();}
			
			}			
		
setBatchMode(true);
list = getFileList(input);
for (i = 0; i < list.length; i++)
	save_T_NS(input, output_T, output_NS, list[i]);
setBatchMode(false);

}