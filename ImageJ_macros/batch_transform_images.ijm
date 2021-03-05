macro "batch_transform_images" {
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

function batch_transform_images(input_source, output_folder, filename_source, output_transf_folder, input_target, filename_target) {
		open(input_source + filename_source);
		open(input_target + filename_target);
		run("bUnwarpJ", "source_image=" + filename_source + " target_image=" + filename_target + " registration=Accurate image_subsample_factor=0 initial_deformation=[Very Coarse] final_deformation=Fine divergence_weight=0 curl_weight=0 landmark_weight=0 image_weight=1 consistency_weight=10 stop_threshold=0.01 save_transformations save_direct_transformation=" + output_transf_folder + filename_source + "_direct_transf.txt save_inverse_transformation=" + output_transf_folder + filename_target + "_inverse_transf.txt"); 
		selectWindow("Registered Source Image");
		run("Duplicate...", "use");
		saveAs("Tiff", output_folder + filename_source + "_transformed_to_" + filename_target);
		close();
		selectWindow("Registered Source Image");
		close();
		selectWindow("Registered Target Image");
		close();
}

setBatchMode(true);
list = getFileList(input_source);
list_target = getFileList(input_target);
for (i = 0; i < list.length; i++)
batch_transform_images(input_source, output_folder, list[i], output_transf_folder, input_target, list_target[i]);
setBatchMode(false);

}
