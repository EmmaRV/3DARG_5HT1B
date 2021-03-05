change_transf_extraslices <- function(filepath, sourcefilename, targetfilename, newfilename, checkLines = F) {

  # install.packages("XML")
  # install.packages("methods")
  
  library("XML")
  library("methods")

  setwd(filepath)
  
source_xml <- xmlParse(sourcefilename)
rootnode_source <- xmlRoot(source_xml)
node_source <- rootnode_source[["t2_layer_set"]]

target_xml <- xmlParse(targetfilename)
rootnode_target <- xmlRoot(target_xml)
node_target <- rootnode_target[["t2_layer_set"]]

 for (j in 1:7) {  
     
      k = j+1  
      l = j*2
    
      { print(paste('slice ', j, sep="")) }
    
        slice_node_target <- rootnode_target[[2]][[k]][[1]] 
          print(rootnode_target[[2]][[k]][[1]])
        attr_slice_target <- xmlAttrs(slice_node_target)
      
        slice_node_source <- rootnode_source[[2]][[l]][[1]]
          print(rootnode_source[[2]][[l]][[1]])
        slice_node_source_new <- slice_node_source
    
        addAttributes(slice_node_source_new, "transform" = attr_slice_target[[4]], append = TRUE)

          print(slice_node_source_new)
    
        replaceNodes(slice_node_source, slice_node_source_new)
    
        saveXML(source_xml, file = newfilename)
    
    rm(slice_node_target)
    rm(attr_slice_target)
    rm(slice_node_source)
    rm(slice_node_source_new)
    rm(k)
    rm(l)
 }

}
