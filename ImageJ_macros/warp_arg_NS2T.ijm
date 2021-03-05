// warp ARG NS images to ARG T images with transformation info acquired with nissl slides
// only works if nr of NS slides and nr of T slides are equal, otherwise: temporarely move file without matching NS/T slice

macro "warp_arg_NS2T" {
		filepath_source = File.openDialog("Select first input source file"); 		
		filename_1_source = File.getName(filepath_source);
		
		filepath_target = File.openDialog("Select first input target file"); 

		input_source = File.getParent(filepath_source);
		input_target = File.getParent(filepath_target);
	
		print("Input directory source: " + input_source);
		print("Input directory target: " + input_target);

		output_folder=getDirectory("Choose an output directory for transformed files"); 
		print("Output directory transformation files: " + output_folder);

		output_transf_folder=getDirectory("Choose an output directory for transformation files"); 
		print("Output directory transformation files: " + output_transf_folder);

function warp_arg_NS2T(input_source, filename_source, input_target, filename_target, output_transf_folder, transf_file, output_folder) {
	open(input_target + filename_target);
	open(input_source + filename_source);

	call("bunwarpj.bUnwarpJ_.loadElasticTransform", output_transf_folder + transf_file, filename_target, filename_source);

	selectWindow(filename_target);
	close();
	
	selectWindow(filename_source);
	saveAs("Tiff", output_folder + filename_source + "_transformed");
	close();

}

setBatchMode(true);
list = getFileList(input_source);
list_target = getFileList(input_target);
list_txt = getFileList(output_transf_folder);
for (i = 0; i < list.length; i++)
	warp_arg_NS2T(input_source, list[i], input_target, list_target[i], output_transf_folder, list_txt[i], output_folder);
setBatchMode(false);